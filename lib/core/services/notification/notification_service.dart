import 'dart:async';
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
  static const String lastNotificationKey = 'last_notification_timestamp';
  static const String lastLoginKey = 'last_login_timestamp';
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();
  final CacheService _cacheService;
  final FirebaseDatabase _database;
  final GlobalKey<NavigatorState> navigatorKey;
  StreamSubscription? _reservationNotificationsSubscription;
  StreamSubscription? _userNotificationsSubscription;
  final AuthRepository authRepository;

  // تعديل تعريف StreamController
  StreamController<int>? _unreadCountController;
  Stream<int> get unreadCount => _getUnreadCountStream();

  Stream<int> _getUnreadCountStream() {
    _unreadCountController ??= StreamController<int>.broadcast();
    return _unreadCountController!.stream;
  }

  // جعل _currentUnreadCount متاح للوصول
  int _currentUnreadCount = 0;
  int get currentUnreadCount => _currentUnreadCount;

  NotificationService({
    required this.navigatorKey,
    required CacheService cacheService,
    required FirebaseDatabase database,
    required this.authRepository,
  })  : _cacheService = cacheService,
        _database = database;

  Future<void> init() async {
    try {
      // إلغاء الاشتراكات القديمة
      await dispose();

      // إنشاء controller جديد
      _unreadCountController = StreamController<int>.broadcast();

      await _initLocalNotifications();
      await _setupFCM();

      final userId = _cacheService.getUserId();
      if (userId != null) {
        await _setupUserNotifications(userId);
      }
    } catch (e) {
      //  print('❌ Error initializing notifications: $e');
    }
  }

  Future<void> _initLocalNotifications() async {
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
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
    await _localNotifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(
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

  Future<void> _setupFCM() async {
    await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    final token = await _messaging.getToken();
    if (token != null) {
      await _cacheService.saveFCMToken(token);
    }
  }

  Future<void> _setupUserNotifications(int userId) async {
    // حفظ وقت تسجيل الدخول
    final loginTime = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(lastLoginKey, loginTime);

    // تحديث العداد الأولي
    await _updateUnreadCount(userId);

    // الاستماع للإشعارات من FCM
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _handleMessage(message, userId);
      _incrementUnreadCount();
    });

    // الاستماع للإشعارات من Realtime Database
    _listenToReservationNotifications(userId);
    _listenToUserNotifications(userId);

    // الاستماع للإشعارات الجديدة
    _database
        .ref('notifications')
        .child(userId.toString())
        .onChildAdded
        .listen((event) {
      try {
        if (event.snapshot.value != null) {
          final data = Map<String, dynamic>.from(event.snapshot.value as Map);
          if (data['read'] == false) {
            _incrementUnreadCount();

            _showLocalNotification(
              title: data['title'] ?? 'إشعار جديد',
              body: data['message'] ?? '',
              payload: data['payload'],
            );
          }
        }
      } catch (e) {
        //   print('❌ Error processing new notification: $e');
      }
    });

    // الاستماع لتغييرات حالة القراءة
    _database
        .ref('notifications')
        .child(userId.toString())
        .onChildChanged
        .listen((event) {
      _updateUnreadCount(userId); // تحديث العداد عند تغيير حالة أي إشعار
    });
  }

  void _listenToUserNotifications(int userId) async {
    final lastLogin = await SharedPreferences.getInstance()
        .then((prefs) => prefs.getInt(lastLoginKey) ?? 0);

    _userNotificationsSubscription = _database
        .ref('notifications/users')
        .child(userId.toString())
        .orderByChild('timestamp')
        .startAfter(lastLogin)
        .onChildAdded
        .listen((event) async {
      try {
        if (event.snapshot.value != null) {
          final data = Map<String, dynamic>.from(event.snapshot.value as Map);

          if (data['order_id'] != null && data['read'] == false) {
            // التحقق من حالة القراءة
            _showLocalNotification(
              title: data['title'] ?? 'عرض جديد',
              body: data['body'] ?? '',
              payload: '/orders/${data["order_id"]}',
            );

            _incrementUnreadCount();
          }
        }
      } catch (e) {
        //print('❌ Error processing offer notification: $e');
      }
    });
  }

  void _listenToReservationNotifications(int userId) async {
    final lastLogin = await SharedPreferences.getInstance()
        .then((prefs) => prefs.getInt(lastLoginKey) ?? 0);

    _reservationNotificationsSubscription = _database
        .ref('notifications')
        .child(userId.toString())
        .orderByChild('timestamp')
        .startAfter(lastLogin)
        .onChildAdded
        .listen((event) async {
      try {
        if (event.snapshot.value != null) {
          final data = Map<String, dynamic>.from(event.snapshot.value as Map);

          if (data['read'] == false && data['type'] == 'reservation') {
            _showLocalNotification(
              title: 'تحديث حالة الحجز',
              body: data['message'] ?? '',
              payload: '/reservation/${data["reservation_id"]}',
            );
          }
        }
      } catch (e) {
        //    print('❌ Error processing reservation notification: $e');
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
    await _userNotificationsSubscription?.cancel();
    await _reservationNotificationsSubscription?.cancel();
    await _unreadCountController?.close();
    _unreadCountController = null;
  }

  Future<void> listenToNotifications() async {
    try {
      final token = await _cacheService.getToken();
      final sessionCookie = await _cacheService.getSessionCookie();

      //print('🔍 Notifications Request Headers:');
      //print('Token: $token');
      //print('x-api-key: ${ApiEndpoints.apiKey}');
      //print('Cookie: $sessionCookie');

      final response = await http.get(
        Uri.parse(ApiEndpoints.notifications),
        headers: {
          'Authorization': 'Bearer $token',
          'x-api-key': ApiEndpoints.apiKey,
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
    if (_unreadCountController?.isClosed == false) {
      _currentUnreadCount++;
      _unreadCountController?.add(_currentUnreadCount);
    }
  }

  void decrementUnreadCount() {
    if (_unreadCountController?.isClosed == false) {
      _currentUnreadCount--;
      _unreadCountController?.add(_currentUnreadCount);
    }
  }

  Future<void> _updateUnreadCount(int userId) async {
    try {
      final snapshot =
          await _database.ref('notifications').child(userId.toString()).get();

      if (snapshot.exists) {
        final data = Map<String, dynamic>.from(snapshot.value as Map);
        int count = 0;

        data.forEach((key, value) {
          if (value is Map && value['read'] == false) {
            count++;
          }
        });

        if (_unreadCountController?.isClosed == false) {
          _currentUnreadCount = count;
          _unreadCountController?.add(count);
        }
      }
    } catch (e) {
      //   print('❌ Error updating unread count: $e');
    }
  }

  Future<void> markAllAsRead() async {
    try {
      final userId = _cacheService.getUserId();
      if (userId == null) return;

      // تحديث إشعارات الحجوزات
      final reservationsRef =
          _database.ref('notifications').child(userId.toString());
      final reservationsSnapshot = await reservationsRef.get();

      // تحديث إشعارات عروض الطلبات
      final offersRef =
          _database.ref('notifications/users').child(userId.toString());
      final offersSnapshot = await offersRef.get();

      final updates = <String, dynamic>{};

      // تحديث إشعارات الحجوزات
      if (reservationsSnapshot.exists) {
        final data =
            Map<String, dynamic>.from(reservationsSnapshot.value as Map);
        data.forEach((key, value) {
          if (value is Map && value['read'] == false) {
            updates['$key/read'] = true;
          }
        });
        if (updates.isNotEmpty) {
          await reservationsRef.update(updates);
        }
      }

      // تحديث إشعارات عروض الطلبات
      if (offersSnapshot.exists) {
        final data = Map<String, dynamic>.from(offersSnapshot.value as Map);
        data.forEach((key, value) {
          if (value is Map && value['read'] == false) {
            updates['$key/read'] = true;
          }
        });
        if (updates.isNotEmpty) {
          await offersRef.update(updates);
        }
      }

      // تصفير العداد
      if (_unreadCountController?.isClosed == false) {
        _currentUnreadCount = 0;
        _unreadCountController?.add(0);
      }
    } catch (e) {
      //print('❌ Error marking notifications as read: $e');
    }
  }

  // دالة جديدة لتحديث حالة القراءة عند فتح صفحة الإشعارات
  Future<void> markNotificationsAsRead(int userId) async {
    try {
      final ref = _database.ref('notifications/users').child(userId.toString());
      final snapshot = await ref.get();

      if (snapshot.exists) {
        final updates = <String, dynamic>{};
        final data = Map<String, dynamic>.from(snapshot.value as Map);

        data.forEach((key, value) {
          if (value is Map && value['read'] == false) {
            updates['$key/read'] = true;
          }
        });

        if (updates.isNotEmpty) {
          await ref.update(updates);
          if (_unreadCountController?.isClosed == false) {
            _currentUnreadCount = 0;
            _unreadCountController?.add(0);
          }
        }
      }
    } catch (e) {
      //print('❌ Error marking notifications as read: $e');
    }
  }
}
