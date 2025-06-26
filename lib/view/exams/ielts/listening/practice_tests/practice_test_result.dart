// lib/view/exams/ielts/listening/practice_test_result.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import 'package:lottie/lottie.dart';
import 'dart:async';
import 'practice_test_screen.dart';

class PracticeTestResultScreen extends StatefulWidget {
  final int score;
  final int totalQuestions;
  final bool unlockedNextPart;
  final bool timeExpired;
  final String part;

  const PracticeTestResultScreen({
    required this.score,
    required this.totalQuestions,
    required this.unlockedNextPart,
    required this.timeExpired,
    required this.part,
    super.key,
  });

  @override
  State<PracticeTestResultScreen> createState() =>
      _PracticeTestResultScreenState();
}

class _PracticeTestResultScreenState extends State<PracticeTestResultScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _showContent = false;
  bool _isPassed = false;
  int _countdown = 8;
  late Timer _timer;
  late int _correctAnswers;
  late int _wrongAnswers;

  // Color scheme
  final Color _passColor = const Color(0xFF4CAF50);
  final Color _failColor = const Color(0xFFF44336);
  final Color _timeExpiredColor = const Color(0xFFFF9800);
  final Color _passLight = const Color.fromARGB(255, 255, 255, 255);
  final Color _failLight = const Color.fromARGB(255, 255, 255, 255);

  @override
  void initState() {
    super.initState();
    _correctAnswers = widget.score;
    _wrongAnswers = widget.totalQuestions - widget.score;
    _isPassed = widget.unlockedNextPart;

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    Future.delayed(const Duration(milliseconds: 300), () {
      _controller.forward();
      setState(() => _showContent = true);
    });

    // Start countdown to redirect to PracticeTestScreen
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_countdown > 1) {
        setState(() => _countdown--);
      } else {
        timer.cancel();
        _redirectToPracticeTestScreen();
      }
    });
  }

  void _redirectToPracticeTestScreen() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const PracticeTestScreen()),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        final percentage = (widget.score / widget.totalQuestions) * 100;
        final backgroundColor =
            widget.timeExpired
                ? _timeExpiredColor
                : _isPassed
                ? _passColor
                : _failColor;
        final progressColor = _isPassed ? _passLight : _failLight;

        return Scaffold(
          backgroundColor: backgroundColor,
          body: SafeArea(
            child: Stack(
              children: [
                // Background gradient
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

                // Confetti animation for success (only if passed and not time expired)
                if (_isPassed && !widget.timeExpired)
                  Positioned(
                    top: MediaQuery.of(context).size.height * 0.15,
                    left: 0,
                    right: 0,
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.7,
                      child: Lottie.asset(
                        'assets/animations/confetti.json',
                        fit: BoxFit.contain,
                        repeat: false,
                        controller: _controller,
                      ),
                    ),
                  ),

                // Main content
                Padding(
                  padding: EdgeInsets.all(24.w),
                  child: Column(
                    children: [
                      // Header
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.arrow_back_rounded,
                              color: Colors.white,
                              size: 24.sp,
                            ),
                            onPressed: _redirectToPracticeTestScreen,
                          ),
                          const Spacer(),
                          Text(
                            '${widget.part} Results',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 18.sp,
                            ),
                          ),
                          const Spacer(),
                          SizedBox(width: 48.w),
                        ],
                      ),

                      SizedBox(height: 40.h),

                      // Progress circle
                      FadeIn(
                        delay: const Duration(milliseconds: 200),
                        child: Container(
                          padding: EdgeInsets.all(20.w),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withOpacity(0.1),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 20.r,
                              ),
                            ],
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              SizedBox(
                                width: 160.w,
                                height: 160.h,
                                child: CircularProgressIndicator(
                                  value: percentage / 100,
                                  strokeWidth: 12.w,
                                  backgroundColor: Colors.white.withOpacity(
                                    0.1,
                                  ),
                                  valueColor: AlwaysStoppedAnimation(
                                    progressColor,
                                  ),
                                ),
                              ),
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    '${percentage.toStringAsFixed(0)}%',
                                    style: GoogleFonts.poppins(
                                      fontSize: 36.sp,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    '${widget.score}/${widget.totalQuestions}',
                                    style: GoogleFonts.poppins(
                                      fontSize: 18.sp,
                                      color: Colors.white.withOpacity(0.8),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(height: 40.h),

                      // Pass/Fail/Time Expired status
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
                            widget.timeExpired
                                ? 'TIME EXPIRED'
                                : _isPassed
                                ? 'PASSED'
                                : 'FAILED',
                            style: GoogleFonts.poppins(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: progressColor,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 40.h),

                      // Stats cards
                      if (_showContent) ...[
                        FadeInLeft(
                          delay: const Duration(milliseconds: 400),
                          child: _buildStatCard(
                            icon: Icons.check_circle_rounded,
                            title: 'Correct Answers',
                            value: _correctAnswers.toString(),
                            color: _passLight,
                          ),
                        ),
                        SizedBox(height: 16.h),
                        FadeInRight(
                          delay: const Duration(milliseconds: 500),
                          child: _buildStatCard(
                            icon: Icons.error_rounded,
                            title: 'Wrong Answers',
                            value: _wrongAnswers.toString(),
                            color: _failLight,
                          ),
                        ),
                      ],

                      const Spacer(),

                      // Feedback message
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
                              _getFeedbackMessage(
                                widget.score,
                                widget.totalQuestions,
                                widget.unlockedNextPart,
                                widget.timeExpired,
                              ),
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

                      // Countdown
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
                                'Returning in $_countdown seconds',
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
        );
      },
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
            padding: EdgeInsets.all(12.w),
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
                  fontSize: 14.sp,
                  color: Colors.white.withOpacity(0.8),
                ),
              ),
              Text(
                value,
                style: GoogleFonts.poppins(
                  fontSize: 24.sp,
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

  String _getFeedbackMessage(
    int score,
    int totalQuestions,
    bool unlockedNextPart,
    bool timeExpired,
  ) {
    if (timeExpired) {
      return "Time expired! Your answers have been automatically submitted.";
    }

    double percentage = (score / totalQuestions) * 100;
    if (unlockedNextPart) {
      return "Congratulations! You've unlocked the next part!";
    } else if (percentage >= 50) {
      return "Good effort! Try again to unlock the next part.";
    } else {
      return "Keep practicing to unlock the next part!";
    }
  }
}
