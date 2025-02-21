import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../cache/cache_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';


class NotificationService {
  static const String _lastNotificationKey = 'last_notification_timestamp';
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();
  final CacheService _cacheService;
  final FirebaseDatabase _database;
  final GlobalKey<NavigatorState> navigatorKey;
  StreamSubscription? _databaseSubscription;

  NotificationService({
    required this.navigatorKey,
    required CacheService cacheService,
    required FirebaseDatabase database,
  }) : _cacheService = cacheService,
       _database = database;

  Future<void> init() async {
    try {
      // إلغاء الاشتراك السابق إن وجد
      await _databaseSubscription?.cancel();
      
      await _initLocalNotifications();

      final settings = await _messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );
      print('📱 Notification permissions status: ${settings.authorizationStatus}');

      final token = await _messaging.getToken();
      if (token != null) {
        print('📱 FCM Token: $token');
        await _cacheService.saveFCMToken(token);
      }

      final userId = _cacheService.getUserId();
      print('👤 Current user ID: $userId');

      if (userId != null) {
        // إعداد معالجة الإشعارات في الـ foreground
        FirebaseMessaging.onMessage.listen((RemoteMessage message) {
          print('📬 Received foreground message:');
          print('Data: ${message.data}');
          print('Notification: ${message.notification?.title}');
          _handleMessage(message, userId);
        });

        // الاستماع للتغييرات في Firebase Database
        _listenToDatabaseNotifications(userId);
      } else {
        print('❌ User ID not found - notifications won\'t work');
      }

    } catch (e) {
      print('❌ Error initializing notifications: $e');
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
        // التنقل عند الضغط على الإشعار
        if (details.payload != null) {
          navigatorKey.currentState?.pushNamed(details.payload!);
        }
      },
    );

    // إنشاء قناة الإشعارات للأندرويد
    const channel = AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      description: 'This channel is used for important notifications.',
      importance: Importance.max,
      playSound: true,
      enableVibration: true,
      enableLights: true,
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    print('✅ Local notifications initialized successfully');
  }

  void _listenToDatabaseNotifications(int userId) {
    print('🎯 Starting database notifications listener for user: $userId');
    
    _databaseSubscription = _database
        .ref('notifications')
        .child(userId.toString())
        .orderByChild('timestamp')
        .limitToLast(1)  // نحصل فقط على آخر إشعار
        .onChildAdded
        .listen((DatabaseEvent event) async {
      try {
        if (event.snapshot.value != null) {
          final data = event.snapshot.value as Map<dynamic, dynamic>;
          final timestamp = data['timestamp'] as String?;
          
          // نتحقق من آخر إشعار تم استلامه
          final lastTimestamp = await _getLastNotificationTimestamp();
          
          if (timestamp != null && 
              (lastTimestamp == null || timestamp.compareTo(lastTimestamp) > 0)) {
            
            if (data['read'] == false) {
              print('📨 Processing new notification: $data');
              
              _showLocalNotification(
                title: 'تحديث حالة الحجز',
                body: data['message'] as String? ?? '',
                payload: '/reservation/${data['reservation_id']}',
              );

              // تحديث حالة القراءة
              event.snapshot.ref.update({'read': true});
              
              // حفظ وقت آخر إشعار
              await _saveLastNotificationTimestamp(timestamp);
            }
          } else {
            print('⏭️ Skipping already processed notification');
          }
        }
      } catch (e) {
        print('❌ Error processing database notification: $e');
      }
    }, onError: (error) {
      print('❌ Database listener error: $error');
    });
  }

  Future<String?> _getLastNotificationTimestamp() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_lastNotificationKey);
  }

  Future<void> _saveLastNotificationTimestamp(String timestamp) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_lastNotificationKey, timestamp);
  }

  void _handleMessage(RemoteMessage message, int userId) {
    try {
      final messageUserId = message.data['user_id']?.toString();
      print('📩 Message user ID: $messageUserId, Current user ID: $userId');

      if (messageUserId == userId.toString()) {
        _showLocalNotification(
          title: message.notification?.title ?? 'إشعار جديد',
          body: message.notification?.body ?? message.data['message'] ?? '',
          payload: message.data['route'],
        );
      } else {
        print('⚠️ Notification not for current user');
      }
    } catch (e) {
      print('❌ Error handling message: $e');
    }
  }

  Future<void> _showLocalNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    try {
      print('🔔 Showing local notification:');
      print('Title: $title');
      print('Body: $body');
      print('Payload: $payload');

      await _localNotifications.show(
        DateTime.now().millisecondsSinceEpoch ~/ 1000,
        title,
        body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            'high_importance_channel',
            'High Importance Notifications',
            channelDescription: 'This channel is used for important notifications.',
            importance: Importance.max,
            priority: Priority.high,
            showWhen: true,
            enableVibration: true,
            playSound: true,
          ),
          iOS: const DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
        payload: payload,
      );
      print('✅ Notification shown successfully');
    } catch (e) {
      print('❌ Error showing notification: $e');
    }
  }

  static Future<void> handleBackgroundMessage(RemoteMessage message) async {
    print('Handling background message: ${message.messageId}');
    // يمكنك إضافة المزيد من المعالجة هنا
  }

  Future<void> dispose() async {
    await _databaseSubscription?.cancel();
  }
}