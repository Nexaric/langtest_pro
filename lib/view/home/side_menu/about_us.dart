import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          "About Us",
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
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16.sp),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: FadeInDown(
                    child: CircleAvatar(
                      radius: 50.r,
                      backgroundImage: const AssetImage("assets/logo.png"),
                      backgroundColor: Colors.white24,
                    ),
                  ),
                ),
                SizedBox(height: 16.h),
                FadeInUp(
                  child: Text(
                    "Welcome to LangTest Pro!",
                    style: GoogleFonts.poppins(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 12.h),
                FadeInUp(
                  delay: const Duration(milliseconds: 300),
                  child: Text(
                    "LangTest Pro is your AI-powered companion for mastering IELTS, OET, PTE, and TOEFL exams with tools like AI-driven speaking evaluations, writing feedback, and interactive lessons.",
                    style: GoogleFonts.poppins(
                      fontSize: 16.sp,
                      color: Colors.white70,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 24.h),
                FadeInLeft(
                  child: Text(
                    "🚀 Our Mission",
                    style: GoogleFonts.poppins(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: 8.h),
                FadeInLeft(
                  delay: const Duration(milliseconds: 400),
                  child: Text(
                    "Empowering students globally with AI-driven learning to achieve top scores in English proficiency exams.",
                    style: GoogleFonts.poppins(
                      fontSize: 16.sp,
                      color: Colors.white70,
                    ),
                  ),
                ),
                SizedBox(height: 24.h),
                FadeInRight(
                  child: Text(
                    "✨ Key Features",
                    style: GoogleFonts.poppins(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: 8.h),
                FadeInRight(
                  delay: const Duration(milliseconds: 400),
                  child: _buildBulletPoint("AI-Powered Exam Preparation"),
                ),
                FadeInRight(
                  delay: const Duration(milliseconds: 500),
                  child: _buildBulletPoint(
                    "Interactive Speaking & Writing Evaluations",
                  ),
                ),
                FadeInRight(
                  delay: const Duration(milliseconds: 600),
                  child: _buildBulletPoint("Personalized Learning Paths"),
                ),
                FadeInRight(
                  delay: const Duration(milliseconds: 700),
                  child: _buildBulletPoint(
                    "Mock Tests & Performance Analytics",
                  ),
                ),
                SizedBox(height: 24.h),
                FadeInLeft(
                  child: Text(
                    "📞 Contact Us",
                    style: GoogleFonts.poppins(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: 8.h),
                FadeInLeft(
                  delay: const Duration(milliseconds: 400),
                  child: Text(
                    "For support, reach out at:\n📧 support@langtestpro.com\n🌐 www.langtestpro.com",
                    style: GoogleFonts.poppins(
                      fontSize: 16.sp,
                      color: Colors.white70,
                    ),
                  ),
                ),
                SizedBox(height: 32.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: EdgeInsets.only(left: 12.w, top: 8.h),
      child: Row(
        children: [
          Icon(Icons.check_circle, color: Colors.white70, size: 18.sp),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.poppins(
                fontSize: 16.sp,
                color: Colors.white70,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
