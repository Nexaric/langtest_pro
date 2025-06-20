import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "Notifications",
          style: GoogleFonts.poppins(
            fontSize: 22.sp,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white, size: 20.sp),
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
        child: ListView(
          padding: EdgeInsets.all(20.sp),
          children: [
            _buildNotification(
              "New AI Chat Update!",
              "Chat with AI for better speaking practice.",
            ),
            _buildNotification(
              "Reminder: Mock Test",
              "Your IELTS mock test is due tomorrow.",
            ),
            _buildNotification(
              "New Course Available",
              "PTE course has been updated with new materials.",
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotification(String title, String description) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      elevation: 8,
      margin: EdgeInsets.symmetric(vertical: 10.h),
      color: Colors.white.withOpacity(0.95),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        leading: Icon(
          Icons.notifications_active,
          color: const Color(0xFF3E1E68),
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
          description,
          style: GoogleFonts.poppins(
            fontSize: 14.sp,
            color: const Color(0xFF718096),
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 18.sp,
          color: const Color(0xFF3E1E68),
        ),
      ),
    );
  }
}
