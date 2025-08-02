import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import 'package:langtest_pro/controller/listening/listening_controller.dart';
import 'package:langtest_pro/model/progress_model.dart';
import 'package:langtest_pro/res/colors/app_colors.dart';

import 'package:langtest_pro/view/exams/ielts/listening/audio_lessons/audio_lessons.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'questions/question_manager.dart';
import 'dart:async';

class AudioResultScreen extends StatefulWidget {
  final bool isPassed;
  final int score;
  final int totalQuestions;
  final int correctAnswers;
  final int wrongAnswers;
  final int lessonId;
  final VoidCallback onComplete;

  const AudioResultScreen({
    required this.isPassed,
    required this.score,
    required this.totalQuestions,
    required this.correctAnswers,
    required this.wrongAnswers,
    required this.lessonId,
    required this.onComplete,
    super.key,
  });

  @override
  State<AudioResultScreen> createState() => _AudioResultScreenState();
}

class _AudioResultScreenState extends State<AudioResultScreen>
    with SingleTickerProviderStateMixin {
  final progressController = Get.find<ListeningController>();
  late AnimationController _controller;
  bool _showContent = false;
  bool _isPassed = false;
  int _countdown = 5;
  late Timer _timer;

  final Color _passColor = const Color(0xFF4CAF50);
  final Color _failColor = const Color(0xFFF44336);
  final Color _passLight = const Color.fromARGB(255, 200, 230, 201);
  final Color _failLight = const Color.fromARGB(255, 255, 205, 210);

  @override
  void initState() {
    super.initState();
    _isPassed = widget.isPassed;
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    // updateProgress();
 

    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        _controller.forward();
        setState(() => _showContent = true);
      }
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_countdown > 0) {
        if (mounted) {
          setState(() => _countdown--);
        }
      } else {
        timer.cancel();
        if (_isPassed) {
          widget.onComplete();
        }
        // _navigateBackToLessons();
      }
    });
  }

  void _navigateBackToLessons() {
    progressController.getProgress(ctx: context);
    
  }
  // Navigator.of(context).pushAndRemoveUntil(
    //   MaterialPageRoute(builder: (context) => const AudioLessonsScreen()),
    //   (Route<dynamic> route) => false,
    // );

  @override
  void dispose() {
    _controller.dispose();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final percentage =
        widget.totalQuestions > 0
            ? (widget.score / widget.totalQuestions) * 100
            : 0.0;
    final backgroundColor = _isPassed ? _passColor : _failColor;
    final progressColor = _isPassed ? _passLight : _failLight;
    final requiredScore = _getRequiredScore();

    return Scaffold(
      appBar: AppBar(
        
        foregroundColor: AppColors.whiteColor,
        backgroundColor: backgroundColor,
        title: Text(
          'Lesson ${widget.lessonId} Results',
          // 'Lesson ${widget.lessonId} Results (${(_progressController.getProgress(widget.lessonId.toString()) * 100).toStringAsFixed(0)}%)',
          style: GoogleFonts.poppins(
            color: AppColors.whiteColor,
            fontWeight: FontWeight.w600,
            fontSize: 18.sp,
          ),
          textAlign: TextAlign.center,
        ),
      ),
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Stack(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 1000),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      backgroundColor.withOpacity(0.8),
                      backgroundColor.withOpacity(0.9),
                      backgroundColor,
                    ],
                  ),
                ),
              ),

              if (_isPassed)
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Column(
                    children: [
                      FadeIn(
                        delay: const Duration(milliseconds: 200),
                        child: CircularPercentIndicator(
                          radius: 100.0,
                          lineWidth: 15.0,
                          percent: 0.3,
                          animation: true,
                          circularStrokeCap: CircularStrokeCap.round,
                          center: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "30%",
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                "3/10",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                          backgroundColor: Colors.white.withOpacity(0.1),
                          progressColor: Colors.white,
                        ),
                      ),

                      SizedBox(height: 20.h),

                      SlideInUp(
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 24.w,
                            vertical: 12.h,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(24.r),
                            border: Border.all(
                              color: progressColor.withOpacity(0.6),
                              width: 1.5.w,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 10.r,
                                offset: Offset(0, 4.h),
                              ),
                            ],
                          ),
                          child: Text(
                            _isPassed ? 'PASSED' : 'FAILED',
                            style: GoogleFonts.poppins(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: progressColor,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 20.h),

                      if (_showContent) ...[
                        FadeInLeft(
                          delay: const Duration(milliseconds: 400),
                          child: _buildStatCard(
                            icon: Icons.check_circle_rounded,
                            title: 'Correct Answers',
                            value: widget.correctAnswers.toString(),
                            color: _passLight,
                          ),
                        ),
                        SizedBox(height: 16.h),
                        FadeInRight(
                          delay: const Duration(milliseconds: 500),
                          child: _buildStatCard(
                            icon: Icons.error_rounded,
                            title: 'Wrong Answers',
                            value: widget.wrongAnswers.toString(),
                            color: _failLight,
                          ),
                        ),
                      ],

                      SizedBox(height: 20),
                      if (_showContent)
                        FadeInUp(
                          delay: const Duration(milliseconds: 600),
                          child: Container(
                            padding: EdgeInsets.all(16.w),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12.r),
                            ),

                            child: Text(
                              _isPassed
                                  ? 'You unlocked the next lesson!'
                                  : 'Need $requiredScore+ correct answers to pass',
                              style: GoogleFonts.poppins(
                                fontSize: 16.sp,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),

                      SizedBox(height: 24.h),

                      if (_showContent)
                        FadeIn(
                          delay: const Duration(milliseconds: 700),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.timer_outlined,
                                color: Colors.white,
                                size: 18.sp,
                              ),
                              SizedBox(width: 8.w),
                              Text(
                                'Redirecting in $_countdown seconds',
                                style: GoogleFonts.poppins(
                                  fontSize: 14.sp,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),

             Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Column(
                    children: [
                      FadeIn(
                        delay: const Duration(milliseconds: 200),
                        child: CircularPercentIndicator(
                          radius: 100.0,
                          lineWidth: 15.0,
                          percent: 0.3,
                          animation: true,
                          circularStrokeCap: CircularStrokeCap.round,
                          center: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "30%",
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                "3/10",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                          backgroundColor: Colors.white.withOpacity(0.1),
                          progressColor: Colors.white,
                        ),
                      ),

                      SizedBox(height: 20.h),

                      SlideInUp(
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 24.w,
                            vertical: 12.h,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(24.r),
                            border: Border.all(
                              color: progressColor.withOpacity(0.6),
                              width: 1.5.w,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 10.r,
                                offset: Offset(0, 4.h),
                              ),
                            ],
                          ),
                          child: Text(
                            _isPassed ? 'PASSED' : 'FAILED',
                            style: GoogleFonts.poppins(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: progressColor,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 20.h),

                      if (_showContent) ...[
                        FadeInLeft(
                          delay: const Duration(milliseconds: 400),
                          child: _buildStatCard(
                            icon: Icons.check_circle_rounded,
                            title: 'Correct Answers',
                            value: widget.correctAnswers.toString(),
                            color: _passLight,
                          ),
                        ),
                        SizedBox(height: 16.h),
                        FadeInRight(
                          delay: const Duration(milliseconds: 500),
                          child: _buildStatCard(
                            icon: Icons.error_rounded,
                            title: 'Wrong Answers',
                            value: widget.wrongAnswers.toString(),
                            color: _failLight,
                          ),
                        ),
                      ],

                      SizedBox(height: 20),
                      if (_showContent)
                        FadeInUp(
                          delay: const Duration(milliseconds: 600),
                          child: Container(
                            padding: EdgeInsets.all(16.w),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12.r),
                            ),

                            child: Text(
                              _isPassed
                                  ? 'You unlocked the next lesson!'
                                  : 'Need $requiredScore+ correct answers to pass',
                              style: GoogleFonts.poppins(
                                fontSize: 16.sp,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),

                      SizedBox(height: 24.h),

                      if (_showContent)
                        FadeIn(
                          delay: const Duration(milliseconds: 700),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.timer_outlined,
                                color: Colors.white,
                                size: 18.sp,
                              ),
                              SizedBox(width: 8.w),
                              Text(
                                'Redirecting in $_countdown seconds',
                                style: GoogleFonts.poppins(
                                  fontSize: 14.sp,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
                
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10.r,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            // padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 24.sp),
          ),
          SizedBox(width: 16.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.white.withOpacity(0.8),
                ),
              ),
              Text(
                value,
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  int _getRequiredScore() {
    return QuestionManager.getPassThreshold(widget.lessonId);
  }
}
