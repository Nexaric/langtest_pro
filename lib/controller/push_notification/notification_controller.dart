import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationController extends GetxController {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  Future<void> requestPermission({required String userId}) async {
    await _messaging.requestPermission();

    final _token = await _messaging.getToken();
    debugPrint("Fcm token = $_token");

    if (_token != null) {
      await FirebaseFirestore.instance.collection('users').doc(userId).set({
        'fcmToken': _token,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    }

    FirebaseMessaging.onMessage.listen((message) {
      debugPrint(
        '📬 Message received in foreground: ${message.notification?.title}',
      );
    });

    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) async {
      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'fcmToken': newToken,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    });
  }
}
