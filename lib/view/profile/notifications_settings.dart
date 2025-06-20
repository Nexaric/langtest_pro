import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class NotificationSettingsController extends GetxController {
  var generalNotifications = true.obs;
  var courseUpdates = true.obs;
  var examReminders = false.obs;
  var aiAssistantAlerts = true.obs;

  void saveSettings() {
    Get.snackbar(
      'Success',
      'Settings saved successfully!',
      backgroundColor: const Color(0xFF3E1E68),
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      borderRadius: 12.r,
      margin: EdgeInsets.all(16.w),
    );
  }
}

class NotificationSettingsScreen extends StatelessWidget {
  const NotificationSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NotificationSettingsController());

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "Notification Settings",
          style: GoogleFonts.poppins(
            fontSize: 22.sp,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.arrow_back, color: Colors.white),
          ),
          onPressed: () => Get.back(),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF3E1E68), Color(0xFF6A5AE0)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Manage Notifications",
                style: GoogleFonts.poppins(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 16.h),
              Obx(
                () => _buildSwitchTile(
                  "📢 General Notifications",
                  "Receive app-wide updates and announcements",
                  controller.generalNotifications.value,
                  (value) => controller.generalNotifications.value = value,
                ),
              ),
              Obx(
                () => _buildSwitchTile(
                  "📚 Course Updates",
                  "Get notified about new course content",
                  controller.courseUpdates.value,
                  (value) => controller.courseUpdates.value = value,
                ),
              ),
              Obx(
                () => _buildSwitchTile(
                  "⏰ Exam Reminders",
                  "Reminders for upcoming tests and deadlines",
                  controller.examReminders.value,
                  (value) => controller.examReminders.value = value,
                ),
              ),
              Obx(
                () => _buildSwitchTile(
                  "🤖 AI Assistant Alerts",
                  "Alerts from your AI tutor and practice sessions",
                  controller.aiAssistantAlerts.value,
                  (value) => controller.aiAssistantAlerts.value = value,
                ),
              ),
              SizedBox(height: 30.h),
              Center(
                child: ElevatedButton(
                  onPressed: controller.saveSettings,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white.withOpacity(0.95),
                    padding: EdgeInsets.symmetric(
                      vertical: 16.h,
                      horizontal: 40.w,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    elevation: 8,
                    shadowColor: Colors.black.withOpacity(0.1),
                  ),
                  child: Text(
                    "Save Settings",
                    style: GoogleFonts.poppins(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF3E1E68),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSwitchTile(
    String title,
    String subtitle,
    bool value,
    Function(bool) onChanged,
  ) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      elevation: 8,
      margin: EdgeInsets.symmetric(vertical: 10.h),
      color: Colors.white.withOpacity(0.95),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        leading: Icon(
          Icons.notifications,
          color: value ? const Color(0xFF3E1E68) : Colors.grey,
          size: 32.sp,
        ),
        title: Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF2D3748),
          ),
        ),
        subtitle: Text(
          subtitle,
          style: GoogleFonts.poppins(
            fontSize: 12.sp,
            color: const Color(0xFF718096),
          ),
        ),
        trailing: Switch(
          value: value,
          onChanged: onChanged,
          activeColor: const Color(0xFF3E1E68),
          inactiveTrackColor: Colors.grey.withOpacity(0.3),
        ),
      ),
    );
  }
}
