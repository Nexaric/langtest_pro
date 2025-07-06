import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:langtest_pro/repo/push_notification/i_push_facade.dart';

class PushImpl implements IPushFacade {
  final FirebaseMessaging _messaging;
  final FlutterLocalNotificationsPlugin _localNotifications;

  PushImpl()
    : _messaging = FirebaseMessaging.instance,
      _localNotifications = FlutterLocalNotificationsPlugin() {
    if (Firebase.apps.isEmpty) {
      debugPrint('Firebase not initialized in PushImpl');
      throw Exception('Firebase not initialized');
    }
  }

  @override
  Future<void> requestPermissionForFcm({required String userId}) async {
    try {
      await _messaging.requestPermission();
      // final token = await _messaging.getToken();
      await FirebaseMessaging.instance.subscribeToTopic("PushNotification");
    } catch (e) {
      debugPrint('Error requesting FCM permission: $e');
    }
  }

  @override
  Future<void> foregroundNotificationChannel() async {
    try {
      // Initialize local notifications
      const androidInitSettings = AndroidInitializationSettings(
        '@mipmap/ic_launcher',
      );
      const initSettings = InitializationSettings(android: androidInitSettings);
      await _localNotifications.initialize(initSettings);

      // Create Android notification channel
      const channel = AndroidNotificationChannel(
        'high_importance_channel',
        'High Importance Notifications',
        description: 'This channel is used for important notifications.',
        importance: Importance.high,
      );

      await _localNotifications
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.createNotificationChannel(channel);

      // Listen for foreground messages
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        final notification = message.notification;
        final android = message.notification?.android;

        if (notification != null && android != null) {
          _localNotifications.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channelDescription: channel.description,
                icon: '@mipmap/ic_launcher',
                importance: Importance.high,
                priority: Priority.high,
              ),
            ),
          );
          debugPrint('Foreground message: ${notification.title}');
        }
      });

      // Set up background message handler
      FirebaseMessaging.onBackgroundMessage(_backgroundHandler);
    } catch (e) {
      debugPrint('Error initializing foreground channel: $e');
    }
  }

  static Future<void> _backgroundHandler(RemoteMessage message) async {
    debugPrint('Background message: ${message.notification?.title}');
  }
}
