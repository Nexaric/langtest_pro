import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class TermsPoliciesScreen extends StatelessWidget {
  const TermsPoliciesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "Terms & Policies",
          style: GoogleFonts.poppins(
            fontSize: 22.sp,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white, size: 20.sp),
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
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            children: [
              SizedBox(height: 80.h),
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionTitle("📜 Terms of Service"),
                        _buildBulletPoint(
                          "You must be at least 18 years old or have parental consent.",
                        ),
                        _buildBulletPoint(
                          "Unauthorized access to accounts is strictly prohibited.",
                        ),
                        _buildBulletPoint(
                          "Use of this platform must be in compliance with local laws.",
                        ),
                        SizedBox(height: 20.h),
                        _buildSectionTitle("🔒 Privacy Policy"),
                        _buildBulletPoint(
                          "We collect data to improve user experience.",
                        ),
                        _buildBulletPoint(
                          "Your data is securely stored and never sold.",
                        ),
                        _buildBulletPoint(
                          "You can request data deletion at any time.",
                        ),
                        SizedBox(height: 20.h),
                        _buildSectionTitle("🚀 User Responsibilities"),
                        _buildBulletPoint(
                          "Do not share your account with others.",
                        ),
                        _buildBulletPoint(
                          "Respect other users and avoid inappropriate content.",
                        ),
                        _buildBulletPoint(
                          "Violating policies may result in account suspension.",
                        ),
                        SizedBox(height: 20.h),
                        _buildSectionTitle("⚖ Changes & Updates"),
                        _buildBulletPoint(
                          "We may update these terms occasionally.",
                        ),
                        _buildBulletPoint(
                          "You will be notified of significant changes.",
                        ),
                        _buildBulletPoint(
                          "Continued use means acceptance of new terms.",
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20.h),
              ElevatedButton(
                onPressed: () => Get.back(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.greenAccent,
                  padding: EdgeInsets.symmetric(
                    vertical: 12.h,
                    horizontal: 40.w,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                child: Text(
                  "Accept & Continue",
                  style: GoogleFonts.poppins(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.poppins(
        fontSize: 18.sp,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: EdgeInsets.only(top: 8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.check_circle, color: Colors.white, size: 18.sp),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.poppins(
                fontSize: 14.sp,
                color: Colors.white.withOpacity(0.7),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
