import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:animate_do/animate_do.dart';
import 'package:langtest_pro/controller/listening_controller.dart';
import 'package:langtest_pro/controller/reading_controller.dart';
import 'package:langtest_pro/controller/speaking_progress_provider.dart';
import 'package:langtest_pro/controller/writing_controller.dart';
import 'package:langtest_pro/core/loading/under_maintenance.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:get/get.dart';

import 'ielts_listening.dart';
import 'ielts_reading.dart';
import 'ielts_writing.dart';

class IeltsScreen extends StatelessWidget {
  const IeltsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          "IELTS Preparation",
          style: GoogleFonts.poppins(
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF3E1E68), Color(0xFF6A5AE0)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
              child: Column(
                children: [
                  FadeInDown(
                    delay: const Duration(milliseconds: 300),
                    child: _buildProgressOverview(context),
                  ),
                  SizedBox(height: 30.h),
                  ZoomIn(
                    duration: const Duration(milliseconds: 600),
                    child: _buildModulesGrid(context, size),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressOverview(BuildContext context) {
    final listeningController = Get.find<ListeningController>();
    final readingController = Get.find<ReadingController>();
    final writingController = Get.find<WritingController>();
    final speakingController = Get.find<SpeakingProgressController>();

    return Obx(() {
      return GlassmorphicContainer(
        width: double.infinity,
        height: 200.h,
        borderRadius: 20.r,
        blur: 20,
        alignment: Alignment.center,
        linearGradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.1),
            Colors.white.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: 1,
        borderGradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.4),
            Colors.white.withOpacity(0.1),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            children: [
              Text(
                "📊 Skill Progress",
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildProgressCircle(
                    "Listening",
                    listeningController.overallProgress / 100,
                  ),
                  _buildProgressCircle(
                    "Reading",
                    readingController.overallProgress / 100,
                  ),
                  _buildProgressCircle(
                    "Writing",
                    writingController.completionPercentage / 100,
                  ),
                  _buildProgressCircle("Speaking", speakingController.progress),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildProgressCircle(String skill, double progress) {
    return Column(
      children: [
        CircularPercentIndicator(
          radius: 35.r,
          lineWidth: 6.w,
          percent: progress.clamp(0.0, 1.0),
          animation: true,
          circularStrokeCap: CircularStrokeCap.round,
          center: Text(
            "${(progress * 100).toInt()}%",
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 12.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          progressColor: Colors.white,
          backgroundColor: Colors.white24,
        ),
        SizedBox(height: 4.h),
        Text(
          skill,
          style: GoogleFonts.poppins(color: Colors.white, fontSize: 13.sp),
        ),
      ],
    );
  }

  Widget _buildModulesGrid(BuildContext context, Size size) {
    final isTablet = size.width > 600;

    return GlassmorphicContainer(
      width: double.infinity,
      height: isTablet ? 550.h : 450.h,
      borderRadius: 20.r,
      blur: 20,
      alignment: Alignment.center,
      linearGradient: LinearGradient(
        colors: [
          Colors.white.withOpacity(0.15),
          Colors.white.withOpacity(0.05),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      border: 1,
      borderGradient: LinearGradient(
        colors: [Colors.white.withOpacity(0.3), Colors.white.withOpacity(0.1)],
      ),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          children: [
            Text(
              "📚 IELTS Modules",
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 30.h),
            Expanded(
              child: GridView.count(
                crossAxisCount: isTablet ? 3 : 2,
                mainAxisSpacing: 16.h,
                crossAxisSpacing: 16.w,
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                children: [
                  _buildModuleCard(
                    context,
                    "🎧 Listening",
                    "Practice exercises",
                    Colors.blue,
                    const IeltsListeningScreen(),
                  ),
                  _buildModuleCard(
                    context,
                    "📖 Reading",
                    "Comprehension practice",
                    Colors.green,
                    const IeltsReadingScreen(),
                  ),
                  _buildModuleCard(
                    context,
                    "✍ Writing",
                    "Practice tasks",
                    Colors.orange,
                    const IeltsWritingScreen(),
                  ),
                  _buildModuleCard(
                    context,
                    "🗣 Speaking",
                    "Fluency practice",
                    Colors.purple,
                    const UnderMaintenanceScreen(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModuleCard(
    BuildContext context,
    String title,
    String subtitle,
    Color color,
    Widget screen,
  ) {
    return GestureDetector(
      onTap:
          () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => screen),
          ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.92),
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(color: Colors.black12, blurRadius: 6, spreadRadius: 2),
          ],
        ),
        padding: EdgeInsets.all(14.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.school_rounded, color: color, size: 40.sp),
            SizedBox(height: 10.h),
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 6.h),
            Text(
              subtitle,
              style: GoogleFonts.poppins(
                fontSize: 13.sp,
                color: Colors.black54,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
