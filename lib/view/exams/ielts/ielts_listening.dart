import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import 'package:get/get.dart';
import 'package:langtest_pro/controller/listening_controller.dart';
import 'package:langtest_pro/res/routes/routes_name.dart';

class IeltsListeningScreen extends StatelessWidget {
  const IeltsListeningScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final progressController = Get.find<ListeningProgressController>();

    return Obx(() {
      if (progressController.isLoading) {
        return Scaffold(
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF3E1E68), Color.fromARGB(255, 84, 65, 228)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [0.1, 0.9],
              ),
            ),
            child: Center(
              child: CircularProgressIndicator(color: Colors.white),
            ),
          ),
        );
      }

      if (progressController.hasError) {
        return Scaffold(
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF3E1E68), Color.fromARGB(255, 84, 65, 228)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [0.1, 0.9],
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    progressController.errorMessage ?? 'Error loading progress',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 16.sp,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  ElevatedButton(
                    onPressed: () async {
                      await progressController.restoreFromCloud();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00BFA6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 10.h,
                      ),
                    ),
                    child: Text(
                      'Retry',
                      style: GoogleFonts.poppins(
                        fontSize: 14.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }

      return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: Text(
            "IELTS Listening",
            style: GoogleFonts.poppins(
              fontSize: 22.sp,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          leading:
              Navigator.canPop(context)
                  ? IconButton(
                    icon: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: 20.sp,
                      color: Colors.white,
                    ),
                    onPressed: () => Get.back(),
                  )
                  : null,
        ),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF3E1E68), Color.fromARGB(255, 84, 65, 228)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              stops: [0.1, 0.9],
            ),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FadeInDown(child: _buildHeader(context, progressController)),
                  SizedBox(height: 24.h),
                  Padding(
                    padding: EdgeInsets.only(left: 8.w),
                    child: Text(
                      "Explore Listening Modules",
                      style: GoogleFonts.poppins(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ),
                  SizedBox(height: 12.h),
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    mainAxisSpacing: 12.w,
                    crossAxisSpacing: 12.w,
                    childAspectRatio: 0.95,
                    children: [
                      FadeInUp(
                        child: GestureDetector(
                          onTap:
                              () => Get.toNamed(RoutesName.audioLessonsScreen),
                          child: _buildFeatureCard(
                            Icons.headset_rounded,
                            "Audio Lessons",
                            Colors.blue.shade200,
                            "Real IELTS recordings",
                          ),
                        ),
                      ),
                      FadeInUp(
                        delay: const Duration(milliseconds: 50),
                        child: GestureDetector(
                          onTap:
                              () => Get.toNamed(RoutesName.practiceTestScreen),
                          child: _buildFeatureCard(
                            Icons.quiz_rounded,
                            "Practice Tests",
                            Colors.green.shade200,
                            "Full-length tests",
                          ),
                        ),
                      ),
                      FadeInUp(
                        delay: const Duration(milliseconds: 100),
                        child: GestureDetector(
                          onTap: () => Get.toNamed(RoutesName.feedbackScreen),
                          child: _buildFeatureCard(
                            Icons.feedback_rounded,
                            "Feedback",
                            Colors.orange.shade200,
                            "Track your progress",
                          ),
                        ),
                      ),
                      FadeInUp(
                        delay: const Duration(milliseconds: 150),
                        child: GestureDetector(
                          onTap:
                              () =>
                                  Get.toNamed(RoutesName.strategiesTipsScreen),
                          child: _buildFeatureCard(
                            Icons.lightbulb_rounded,
                            "Tips",
                            Colors.purple.shade200,
                            "Expert strategies",
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 24.h),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget _buildHeader(
    BuildContext context,
    ListeningProgressController progressController,
  ) {
    final progress = progressController.lessonProgressPercentage / 100;

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.12),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 100.w,
                height: 100.h,
                child: CircularProgressIndicator(
                  value: progress.clamp(0.0, 1.0),
                  strokeWidth: 8.w,
                  backgroundColor: Colors.white.withOpacity(0.2),
                  color: Colors.white,
                ),
              ),
              Column(
                children: [
                  Text(
                    "${(progress * 100).toStringAsFixed(0)}%",
                    style: GoogleFonts.poppins(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    "Complete",
                    style: GoogleFonts.poppins(
                      fontSize: 14.sp,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Text(
            "Master IELTS Listening",
            style: GoogleFonts.poppins(
              fontSize: 20.sp,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            "Practice makes perfect! Complete lessons and track your progress.",
            style: GoogleFonts.poppins(
              fontSize: 14.sp,
              color: Colors.white.withOpacity(0.8),
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard(
    IconData icon,
    String title,
    Color iconColor,
    String description,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.white.withOpacity(0.15)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 28.sp, color: iconColor),
          ),
          SizedBox(height: 12.h),
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 8.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: Text(
              description,
              style: GoogleFonts.poppins(
                fontSize: 12.sp,
                color: Colors.white.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
