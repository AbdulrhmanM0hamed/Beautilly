import 'dart:async';
import 'dart:convert';

import 'package:beautilly/core/utils/constant/api_endpoints.dart';
import 'package:beautilly/features/auth/domain/repositories/auth_repository.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../cache/cache_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;



class NotificationService {
  static const String _lastNotificationKey = 'last_notification_timestamp';
  static const String _lastLoginKey = 'last_login_timestamp';
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();
  final CacheService _cacheService;
  final FirebaseDatabase _database;
  final GlobalKey<NavigatorState> navigatorKey;
  StreamSubscription? _reservationNotificationsSubscription;
  StreamSubscription? _userNotificationsSubscription;
  final AuthRepository authRepository;

  // إضافة متغير لعدد الإشعارات
  final StreamController<int> _unreadCountController = StreamController<int>.broadcast();
  Stream<int> get unreadCount => _unreadCountController.stream;
  int _currentUnreadCount = 0;

  NotificationService({
    required this.navigatorKey,
    required CacheService cacheService,
    required FirebaseDatabase database,
    required this.authRepository,
  }) : _cacheService = cacheService,
       _database = database;

  Future<void> init() async {
    try {
      await _reservationNotificationsSubscription?.cancel();
      await _userNotificationsSubscription?.cancel();
      
      await _initLocalNotifications();

      final settings = await _messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );
   //   print('📱 Notification permissions status: ${settings.authorizationStatus}');

      final token = await _messaging.getToken();
      if (token != null) {
      //  print('📱 FCM Token: $token');
        await _cacheService.saveFCMToken(token);
      }

      final userId = _cacheService.getUserId();
      //  print('👤 Current user ID: $userId');

      if (userId != null) {
        // حفظ وقت تسجيل الدخول
        final loginTime = DateTime.now().millisecondsSinceEpoch ~/ 1000;
        final prefs = await SharedPreferences.getInstance();
        await prefs.setInt(_lastLoginKey, loginTime);

        // إضافة تحديث العداد عند بدء التطبيق
        await _updateUnreadCount();
        
        // تحديث العداد عند استلام إشعار جديد
        FirebaseMessaging.onMessage.listen((RemoteMessage message) {
          _handleMessage(message, userId);
          _incrementUnreadCount();
        });

        // الاستماع للإشعارات
        _listenToReservationNotifications(userId);
        _listenToUserNotifications(userId);
      } else {
        //print('❌ User ID not found - notifications won\'t work');
      }

    } catch (e) {
      //print('❌ Error initializing notifications: $e');
    }
  }

  Future<void> _initLocalNotifications() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (details) {
        //print('🔔 Notification tapped: ${details.payload}');
        // يمكنك إضافة التنقل هنا
      },
    );

    // إعداد قناة الإشعارات لنظام Android
    await _localNotifications.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(
      const AndroidNotificationChannel(
        'high_importance_channel',
        'High Importance Notifications',
        description: 'This channel is used for important notifications.',
        importance: Importance.high,
        playSound: true,
        enableVibration: true,
        showBadge: true,
      ),
    );
  }

  void _listenToReservationNotifications(int userId) async {
    
    //print('🎯 Starting reservation notifications listener for user: $userId');
    
    final prefs = await SharedPreferences.getInstance();
    final lastLogin = prefs.getInt(_lastLoginKey) ?? 0;
    
    _reservationNotificationsSubscription = _database
        .ref('notifications')
        .child(userId.toString())
        .orderByChild('timestamp')
        .limitToLast(1)  // نفس منطق إشعارات العروض
        .onChildAdded
        .listen((DatabaseEvent event) async {
      try {
        if (event.snapshot.value != null) {
          final data = event.snapshot.value as Map<dynamic, dynamic>;
          final timestamp = data['timestamp'] is String 
              ? DateTime.parse(data['timestamp'] as String).millisecondsSinceEpoch ~/ 1000
              : data['timestamp'] as int;
          
          //print('📦 Received reservation notification: $data');
          
          final lastTimestamp = int.tryParse(
            await _cacheService.getLastNotificationTimestamp() ?? '0'
          ) ?? 0;
          
          //print('⏰ Current timestamp: $timestamp');
          //print('⏰ Last timestamp: $lastTimestamp');
          
          if (timestamp > lastTimestamp && data['read'] == false) {
            //print('📨 Processing new reservation notification');
            
            _showLocalNotification(
              title: 'تحديث حالة الحجز',
              body: data['message'] as String? ?? '',
              payload: '/reservation/${data['reservation_id']}',
            );

            event.snapshot.ref.update({'read': true});
            await _cacheService.saveLastNotificationTimestamp(
              timestamp.toString()
            );
          } else {
            //print('⏭️ Skipping old or read notification');
          }
        }
      } catch (e) {
        //print('❌ Error processing reservation notification: $e');
        //print('Data received: ${event.snapshot.value}');
      }
    });
  }

  void _listenToUserNotifications(int userId) async {
    //print('🎯 Starting user notifications listener for user: $userId');
    
    final prefs = await SharedPreferences.getInstance();
    final lastLogin = prefs.getInt(_lastLoginKey) ?? 0;
    
    _userNotificationsSubscription = _database
        .ref('notifications/users')
        .child(userId.toString())
        .orderByChild('timestamp')
        .startAfter(lastLogin)  // استمع فقط للإشعارات بعد آخر تسجيل دخول
        .onChildAdded
        .listen((DatabaseEvent event) async {
      try {
        if (event.snapshot.value != null) {
          final data = event.snapshot.value as Map<dynamic, dynamic>;
          final timestamp = data['timestamp'] as int;
          
          //print('📦 Received new user notification:');
          //print('Timestamp: $timestamp (Last login: $lastLogin)');
          //print('Data: $data');
            
          _showLocalNotification(
            title: data['title'] as String? ?? 'عرض جديد',
            body: data['body'] as String? ?? '',
            payload: '/orders/${data['order_id']}',
          );

          event.snapshot.ref.update({'read': true});
        }
      } catch (e) {
        //print('❌ Error processing user notification: $e');
        //print('Data received: ${event.snapshot.value}');
      }
    });
  }

  void _handleMessage(RemoteMessage message, int userId) {
    try {
      final messageUserId = message.data['user_id']?.toString();
      //print('📩 Message user ID: $messageUserId, Current user ID: $userId');

      if (messageUserId == userId.toString()) {
        _showLocalNotification(
          title: message.notification?.title ?? 'إشعار جديد',
          body: message.notification?.body ?? message.data['message'] ?? '',
          payload: message.data['route'],
        );
      } else {
        //print('⚠️ Notification not for current user');
      }
    } catch (e) {
      //print('❌ Error handling message: $e');
    }
  }

  Future<void> _showLocalNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    try {
      //print('🔔 Showing notification:');
      //print('Title: $title');
      //print('Body: $body');
      //print('Payload: $payload');

      const androidDetails = AndroidNotificationDetails(
        'high_importance_channel',
        'High Importance Notifications',
        channelDescription: 'This channel is used for important notifications.',
        importance: Importance.max,
        priority: Priority.high,
        showWhen: true,
        enableVibration: true,
        playSound: true,
        icon: '@mipmap/ic_launcher',
        largeIcon: DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
        styleInformation: BigTextStyleInformation(''),
      );

      const iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      const details = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      await _localNotifications.show(
        DateTime.now().millisecondsSinceEpoch ~/ 1000,
        title,
        body,
        details,
        payload: payload,
      );

      //print('✅ Notification shown successfully');
    } catch (e) {
      //print('❌ Error showing notification: $e');
    }
  }

  static Future<void> handleBackgroundMessage(RemoteMessage message) async {
    //print('Handling background message: ${message.messageId}');
    // يمكنك إضافة المزيد من المعالجة هنا
  }

  Future<void> dispose() async {
    await _reservationNotificationsSubscription?.cancel();
    await _userNotificationsSubscription?.cancel();
    _unreadCountController.close();
  }

  Future<void> _listenToNotifications() async {
    try {
      final token = await _cacheService.getToken();
      final sessionCookie = await _cacheService.getSessionCookie();
      
      //print('🔍 Notifications Request Headers:');
      //print('Token: $token');
      //print('x-api-key: ${ApiEndpoints.api_key}');
      //print('Cookie: $sessionCookie');

      final response = await http.get(
        Uri.parse(ApiEndpoints.notifications),
        headers: {
          'Authorization': 'Bearer $token',
          'x-api-key': ApiEndpoints.api_key,
          'Accept': 'application/json',
          if (sessionCookie != null) 'Cookie': sessionCookie,
        },
      );

      //print('📄 Response Status: ${response.statusCode}');
      //print('Response Body: ${response.body}');

      if (response.statusCode == 401) {
        // تجديد التوكن
        await _refreshToken();
      }
    } catch (e) {
      //print('❌ Error in notifications: $e');
    }
  }

  Future<void> _refreshToken() async {
    try {
      // محاولة تجديد التوكن
      await authRepository.refreshToken();
    } catch (e) {
      //print('❌ Error refreshing token: $e');
    }
  }

  void _incrementUnreadCount() {
    _currentUnreadCount++;
    _unreadCountController.add(_currentUnreadCount);
  }

  Future<void> _updateUnreadCount() async {
    try {
      final token = await _cacheService.getToken();
      final response = await http.get(
        Uri.parse('${ApiEndpoints.notifications}/unread-count'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final count = json.decode(response.body)['count'] as int;
        _currentUnreadCount = count;
        _unreadCountController.add(count);
      }
    } catch (e) {
      print('❌ Error updating unread count: $e');
    }
  }

  // تصفير العداد عند قراءة كل الإشعارات
  void markAllAsRead() {
    _currentUnreadCount = 0;
    _unreadCountController.add(0);
  }
}