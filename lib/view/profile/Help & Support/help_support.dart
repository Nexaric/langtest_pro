import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import 'package:langtest_pro/res/routes/routes_name.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "Help & Support",
          style: GoogleFonts.poppins(
            fontSize: 22.sp,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(
          color: Colors.white
        ),
      ),
      body: SizedBox.expand(
        child: Container(
          
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF3E1E68), Color(0xFF6A5AE0)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FadeInDown(
                    duration: const Duration(milliseconds: 500),
                    child: Text(
                      "Frequently Asked Questions",
                      style: GoogleFonts.poppins(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),
        
                  _buildFAQTile(
                    "How do I access my purchased courses?",
                    "Navigate to 'My Courses' in the profile section.",
                  ),
                  _buildFAQTile(
                    "How do I contact support?",
                    "Use the contact options below to reach us.",
                  ),
                  SizedBox(height: 30.h),
                  FadeInLeft(
                    duration: const Duration(milliseconds: 600),
                    child: Text(
                      "Contact Support",
                      style: GoogleFonts.poppins(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  _buildSupportOption(
                    Icons.email,
                    "Email Us",
                    "support@langtestpro.com",
                  ),
                  SizedBox(height: 30.h),
                  FadeInRight(
                    duration: const Duration(milliseconds: 700),
                    child: Center(
                      child: ElevatedButton.icon(
                        onPressed:
                            () => Get.toNamed(RoutesName.reportProblemScreen),
                        icon: Icon(
                          Icons.report,
                          color: const Color(0xFF3E1E68),
                          size: 20.sp,
                        ),
                        label: Text(
                          "Report a Problem",
                          style: GoogleFonts.poppins(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF3E1E68),
                          ),
                        ),
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
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFAQTile(String question, String answer) {
    return Card(
      // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      // elevation: 8,
      color: Colors.white.withOpacity(0.95),
      child: ExpansionTile(
        title: Text(
          question,
          style: GoogleFonts.poppins(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF2D3748),
          ),
        ),
        children: [
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Text(
              answer,
              style: GoogleFonts.poppins(
                fontSize: 14.sp,
                color: const Color(0xFF718096),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSupportOption(IconData icon, String title, String subtitle) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      // elevation: 8,
      color: Colors.white.withOpacity(0.95),
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFF3E1E68), size: 24.sp),
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
        // contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      ),
    );
  }
}
