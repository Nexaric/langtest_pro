import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/services.dart';

class ShareAppScreen extends StatelessWidget {
  const ShareAppScreen({super.key});

  void _shareApp() {
    const String appLink =
        "https://play.google.com/store/apps/details?id=com.nexaric.langtestpro";
    Share.share(
      "🌟 Discover LangTest Pro for IELTS, OET, PTE & TOEFL prep! 🚀\nDownload now: $appLink",
    );
  }

  void _copyAppLink() {
    const String appLink =
        "https://play.google.com/store/apps/details?id=com.nexaric.langtestpro";
    Clipboard.setData(const ClipboardData(text: appLink));
    Get.snackbar(
      "Link Copied",
      "Link copied to clipboard!",
      backgroundColor: Colors.green,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      borderRadius: 8.r,
      margin: EdgeInsets.all(16.sp),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          "Share LangTest Pro",
          style: GoogleFonts.poppins(
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
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
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(16.sp),
            child: Center(
              child: BounceInUp(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Invite Your Friends 🎉",
                      style: GoogleFonts.poppins(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    Text(
                      "Share LangTest Pro to help your friends excel in their English exams!",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 16.sp,
                        color: Colors.white70,
                      ),
                    ),
                    SizedBox(height: 32.h),
                    ElevatedButton.icon(
                      onPressed: _shareApp,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: const Color(0xFF6A5AE0),
                        padding: EdgeInsets.symmetric(
                          horizontal: 24.w,
                          vertical: 12.h,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        elevation: 2,
                      ),
                      icon: Icon(Icons.share, size: 20.sp),
                      label: Text(
                        "Share Now",
                        style: GoogleFonts.poppins(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    SizedBox(height: 16.h),
                    TextButton.icon(
                      onPressed: _copyAppLink,
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                      ),
                      icon: Icon(Icons.link, size: 20.sp),
                      label: Text(
                        "Copy App Link",
                        style: GoogleFonts.poppins(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
