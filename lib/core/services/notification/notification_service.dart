import 'package:beautilly/firebase_options.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../cache/cache_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';

class NotificationService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();
  final CacheService _cacheService;
  final FirebaseDatabase _database;
  final _notificationChannelId = 'high_importance_channel';
  final _notificationChannelName = 'High Importance Notifications';
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  NotificationService(this._cacheService, {required FirebaseDatabase database}) 
      : _database = database;

  Future<void> init() async {
    try {
      // إعدادات إضافية للإشعارات
      await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );

      // طلب إذن الإشعارات
      final settings = await _messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        provisional: false,
      );

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        print('User granted permission: ${settings.authorizationStatus}');
        
        // تهيئة الإشعارات المحلية
        await _initLocalNotifications();
        
        // الحصول على FCM token وحفظه
        String? token = await _messaging.getToken();
        if (token != null) {
          print('🔥 FCM Token: $token');
          await _cacheService.saveFCMToken(token);
        }

        // الاستماع لتحديثات الـ token
        _messaging.onTokenRefresh.listen((newToken) async {
          print('FCM Token refreshed: $newToken');
          await _cacheService.saveFCMToken(newToken);
        });

        // معالجة الإشعارات في المقدمة
        FirebaseMessaging.onMessage.listen((message) {
          print('Got a message whilst in the foreground!');
          print('Message data: ${message.data}');
          _handleForegroundMessage(message);
        });

        // معالجة الضغط على الإشعار عندما التطبيق في الخلفية
        FirebaseMessaging.onMessageOpenedApp.listen((message) {
          print('Message clicked when app was in background!');
          _handleMessageOpenedApp(message);
        });

        // التحقق من الإشعار الذي فتح التطبيق
        final initialMessage = await _messaging.getInitialMessage();
        if (initialMessage != null) {
          print('App opened from terminated state via notification!');
          _handleMessageOpenedApp(initialMessage);
        }

        // مراقبة الإشعارات في Realtime Database
        _listenToNotifications();

        // إضافة معالجة الإشعارات في الخلفية
        FirebaseMessaging.instance.getInitialMessage().then((message) {
          if (message != null) {
            _handleBackgroundMessage(message);
          }
        });

        // معالجة الإشعارات عندما التطبيق في الخلفية
        FirebaseMessaging.onBackgroundMessage(_handleBackgroundMessage);
        
        // معالجة الإشعارات عندما يتم فتح التطبيق من الإشعار
        FirebaseMessaging.onMessageOpenedApp.listen((message) {
          _handleBackgroundMessage(message);
        });
      } else {
        print('User declined or has not accepted permission');
      }
    } catch (e) {
      print('Error initializing notifications: $e');
    }
  }

  Future<void> _initLocalNotifications() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
    );

    await _localNotifications.initialize(
      const InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      ),
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    // إنشاء قناة الإشعارات للأندرويد
    await _localNotifications.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(
      AndroidNotificationChannel(
        _notificationChannelId,
        _notificationChannelName,
        importance: Importance.high,
        playSound: true,
        enableVibration: true,
      ),
    );
  }

  Future<void> _handleForegroundMessage(RemoteMessage message) async {
    print('Handling foreground message: ${message.messageId}');
    
    if (message.notification != null) {
      await _showLocalNotification(
        title: message.notification?.title ?? 'إشعار جديد',
        body: message.notification?.body ?? '',
        payload: message.data['route'],
      );
    }
  }

  Future<void> _showLocalNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    final androidDetails = AndroidNotificationDetails(
      _notificationChannelId,
      _notificationChannelName,
      importance: Importance.high,
      priority: Priority.high,
      enableVibration: true,
      playSound: true,
      icon: '@mipmap/ic_launcher',
    );

    final iosDetails = const DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    await _localNotifications.show(
      DateTime.now().millisecond,
      title,
      body,
      NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      ),
      payload: payload,
    );
  }

  void _onNotificationTapped(NotificationResponse response) {
    print('Notification tapped: ${response.payload}');
    if (response.payload != null) {
      navigatorKey.currentState?.pushNamed(response.payload!);
    }
  }

  void _handleMessageOpenedApp(RemoteMessage message) {
    print('Handling message opened app: ${message.messageId}');
    final route = message.data['route'];
    if (route != null) {
      navigatorKey.currentState?.pushNamed(route);
    }
  }

  void _listenToNotifications() {
    print('🎯 Starting to listen to notifications...');
    
    try {
      final DatabaseReference ref = FirebaseDatabase.instance.ref("notifications");
      
      ref.onValue.listen(
        (DatabaseEvent event) {
          if (event.snapshot.value != null) {
            print('🔔 New Data Received');
            
            try {
              final Map<dynamic, dynamic> data = event.snapshot.value as Map<dynamic, dynamic>;
              
              // معالجة الإشعارات المتداخلة
              data.forEach((parentKey, parentValue) {
                if (parentValue is Map) {
                  parentValue.forEach((key, value) async {
                    if (value is Map && value['read'] == false) {
                      print('📦 Processing notification: $value');
                      
                      // عرض الإشعار المحلي
                      await _showLocalNotification(
                        title: 'تحديث حالة الحجز',
                        body: value['message'] as String? ?? '',
                        payload: '/reservation/${value['reservation_id']}',
                      ).then((_) {
                        print('✅ Local notification shown successfully');
                      }).catchError((error) {
                        print('❌ Error showing notification: $error');
                      });

                      // تحديث حالة القراءة
                      await ref.child(parentKey).child(key).update({'read': true}).then((_) {
                        print('✔️ Notification marked as read');
                      }).catchError((error) {
                        print('❌ Error updating read status: $error');
                      });
                    }
                  });
                }
              });
            } catch (e) {
              print('❌ Error processing data: $e');
            }
          }
        },
        onError: (error) => print('❌ Database listen error: $error'),
      );
    } catch (e) {
      print('❌ Error setting up notification listener: $e');
    }
  }

  static final FlutterLocalNotificationsPlugin _backgroundNotifications = FlutterLocalNotificationsPlugin();
  
  static Future<void> handleBackgroundMessage(RemoteMessage message) async {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    
    // تهيئة قناة الإشعارات
    await _backgroundNotifications.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(
      const AndroidNotificationChannel(
        'high_importance_channel',
        'High Importance Notifications',
        importance: Importance.high,
        playSound: true,
        enableVibration: true,
      ),
    );

    // عرض الإشعار
    await _backgroundNotifications.show(
      DateTime.now().millisecond,
      'تحديث حالة الحجز',
      message.data['message'] ?? message.notification?.body ?? '',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'high_importance_channel',
          'High Importance Notifications',
          importance: Importance.high,
          priority: Priority.high,
          playSound: true,
          enableVibration: true,
          icon: '@mipmap/ic_launcher',
        ),
      ),
    );
  }

  @pragma('vm:entry-point')
  static Future<void> _handleBackgroundMessage(RemoteMessage message) async {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    print('📱 Handling background message: ${message.messageId}');
    
    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    
    await flutterLocalNotificationsPlugin.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      ),
    );

    await flutterLocalNotificationsPlugin.show(
      DateTime.now().millisecond,
      'تحديث حالة الحجز',
      message.data['message'] ?? message.notification?.body ?? '',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'high_importance_channel',
          'High Importance Notifications',
          importance: Importance.max,
          priority: Priority.high,
          showWhen: true,
          enableVibration: true,
          playSound: true,
          icon: '@mipmap/ic_launcher',
        ),
      ),
    );
  }
}