// lib/controller/push_notification/notification_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:langtest_pro/repo/push_notification/i_push_facade.dart';
import 'package:langtest_pro/repo/push_notification/push_impl.dart';

class NotificationController extends GetxController {
  final IPushFacade pushFacade;

  NotificationController({IPushFacade? pushFacade})
    : pushFacade = pushFacade ?? PushImpl();

  @override
  void onInit() {
    super.onInit();
    _initializeNotifications();
  }

  Future<void> _initializeNotifications() async {
    try {
      // Get userId from Supabase auth
      final userId = Supabase.instance.client.auth.currentUser?.id ?? 'unknown';
      await requestPermissionForFcm(userId: userId);
      await foregroundNotificationChannel();
      debugPrint('Notifications initialized successfully');
    } catch (e) {
      debugPrint('Notification initialization error: $e');
    }
  }

  Future<void> requestPermissionForFcm({required String userId}) async {
    try {
      await pushFacade.requestPermissionForFcm(userId: userId);
      debugPrint('FCM permission requested for user: $userId');
    } catch (e) {
      debugPrint('Error requesting FCM permission: $e');
    }
  }

  Future<void> foregroundNotificationChannel() async {
    try {
      pushFacade.foregroundNotificationChannel();
      debugPrint('Foreground notification channel initialized');
    } catch (e) {
      debugPrint('Error initializing foreground channel: $e');
    }
  }
}
