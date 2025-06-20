import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class PreferencesController extends GetxController {
  var notificationsEnabled = true.obs;

  void savePreferences() {
    Get.snackbar(
      'Success',
      'Preferences saved successfully!',
      backgroundColor: const Color(0xFF3E1E68),
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      borderRadius: 12.r,
      margin: EdgeInsets.all(16.w),
    );
  }
}

class PreferencesScreen extends StatelessWidget {
  const PreferencesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PreferencesController());

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "Preferences",
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
              Obx(
                () => Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  elevation: 8,
                  color: Colors.white.withOpacity(0.95),
                  child: SwitchListTile(
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 12.h,
                    ),
                    title: Text(
                      "Enable Notifications",
                      style: GoogleFonts.poppins(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF2D3748),
                      ),
                    ),
                    subtitle: Text(
                      "Receive app notifications for updates and reminders",
                      style: GoogleFonts.poppins(
                        fontSize: 12.sp,
                        color: const Color(0xFF718096),
                      ),
                    ),
                    value: controller.notificationsEnabled.value,
                    onChanged:
                        (value) =>
                            controller.notificationsEnabled.value = value,
                    activeColor: const Color(0xFF3E1E68),
                    inactiveTrackColor: Colors.grey.withOpacity(0.3),
                  ),
                ),
              ),
              SizedBox(height: 30.h),
              Center(
                child: ElevatedButton(
                  onPressed: controller.savePreferences,
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
                    "Save Preferences",
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
}
