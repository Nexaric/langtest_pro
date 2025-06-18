import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:langtest_pro/repo/push_notification/i_push_facade.dart';

class PushImpl implements IPushFacade {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  @override
  Future<void> requestPermissionForFcm({required String userId}) async {
    // await _messaging.requestPermission();
    // print("object in fcm clss impl");
    // final _token = await _messaging.getToken();
    // debugPrint("Fcm token = $_token");

    // if (_token != null) {
    //   await FirebaseFirestore.instance.collection('users').doc(userId).set({
    //     'fcmToken': _token,
    //     'updatedAt': FieldValue.serverTimestamp(),
    //   }, SetOptions(merge: true));
    // }

    // FirebaseMessaging.onMessage.listen((message) {
    //   debugPrint(
    //     '📬 Message received in foreground: ${message.notification?.title}',
    //   );
    // });

    // FirebaseMessaging.instance.onTokenRefresh.listen((newToken) async {
    //   await FirebaseFirestore.instance.collection('users').doc(userId).update({
    //     'fcmToken': newToken,
    //     'updatedAt': FieldValue.serverTimestamp(),
    //   });
    // });
  }

  @override
  Future<void> foregroundNotificationChannel() async {
  //   final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  //       FlutterLocalNotificationsPlugin();

  //   const AndroidInitializationSettings initializationSettingsAndroid =
  //       AndroidInitializationSettings('@mipmap/ic_launcher');

  //   const InitializationSettings initializationSettings =
  //       InitializationSettings(android: initializationSettingsAndroid);

  //   await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  //   const AndroidNotificationChannel channel = AndroidNotificationChannel(
  //     'high_importance_channel',
  //     'High Importance Notifications',
  //     description: 'This channel is used for important notifications.',
  //     importance: Importance.high,
  //   );

  //   await flutterLocalNotificationsPlugin
  //       .resolvePlatformSpecificImplementation<
  //         AndroidFlutterLocalNotificationsPlugin
  //       >()
  //       ?.createNotificationChannel(channel);

  //   FirebaseMessaging.onMessage.listen((RemoteMessage message) {
  //     RemoteNotification? notification = message.notification;
  //     AndroidNotification? android = message.notification?.android;

  //     if (notification != null && android != null) {
  //       flutterLocalNotificationsPlugin.show(
  //         notification.hashCode,
  //         notification.title,
  //         notification.body,
  //         NotificationDetails(
  //           android: AndroidNotificationDetails(
  //             channel.id,
  //             channel.name,
  //             channelDescription: channel.description,
  //             icon: '@mipmap/ic_launcher',
  //             importance: Importance.high,
  //             priority: Priority.high,
  //           ),
  //         ),
  //       );
  //     }
  //   });
}
}
