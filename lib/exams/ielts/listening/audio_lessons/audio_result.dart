// lib/exams/ielts/listening/audio_lessons/audio_result.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import 'package:lottie/lottie.dart';
import 'package:langtest_pro/exams/ielts/listening/audio_lessons/audio_lessons.dart';
import 'questions/question_manager.dart';
import 'dart:async';

class AudioResultScreen extends StatefulWidget {
  final int score;
  final int totalQuestions;
  final int correctAnswers;
  final int wrongAnswers;
  final int lessonId;
  final VoidCallback onComplete;

  const AudioResultScreen({
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
  late AnimationController _controller;
  bool _showContent = false;
  bool _isPassed = false;
  int _countdown = 5;
  late Timer _timer;

  // Color scheme
  final Color _passColor = const Color(0xFF4CAF50); // Green 500
  final Color _failColor = const Color(0xFFF44336); // Red 500
  final Color _passLight = const Color.fromARGB(
    255,
    200,
    230,
    201,
  ); // Green 300
  final Color _failLight = const Color.fromARGB(255, 255, 205, 210); // Red 300

  @override
  void initState() {
    super.initState();
    _isPassed = QuestionManager.isLessonPassed(widget.score, widget.lessonId);
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    // Start animations
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        _controller.forward();
        setState(() => _showContent = true);
      }
    });

    // Start countdown
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
        _navigateBackToLessons();
      }
    });
  }

  void _navigateBackToLessons() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const AudioLessonsScreen()),
      (Route<dynamic> route) => false,
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
    final percentage =
        widget.totalQuestions > 0
            ? (widget.score / widget.totalQuestions) * 100
            : 0.0;
    final backgroundColor = _isPassed ? _passColor : _failColor;
    final progressColor = _isPassed ? _passLight : _failLight;
    final requiredScore = _getRequiredScore();

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

            // Confetti animation for success
            if (_isPassed)
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
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  // Header
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_back_rounded,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          _timer.cancel();
                          _navigateBackToLessons();
                        },
                      ),
                      const Spacer(),
                      Text(
                        'Lesson ${widget.lessonId} Results',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                        ),
                      ),
                      const Spacer(),
                      const SizedBox(width: 48),
                    ],
                  ),

                  const SizedBox(height: 40),

                  // Progress circle
                  FadeIn(
                    delay: const Duration(milliseconds: 200),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.1),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 20,
                          ),
                        ],
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(
                            width: 160,
                            height: 160,
                            child: CircularProgressIndicator(
                              value: percentage / 100,
                              strokeWidth: 12,
                              backgroundColor: Colors.white.withOpacity(0.1),
                              valueColor: AlwaysStoppedAnimation(progressColor),
                            ),
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '${percentage.toStringAsFixed(0)}%',
                                style: GoogleFonts.poppins(
                                  fontSize: 36,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                '${widget.score}/${widget.totalQuestions}',
                                style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  color: Colors.white.withOpacity(0.8),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Pass/Fail status
                  SlideInUp(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: progressColor.withOpacity(0.6),
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Text(
                        _isPassed ? 'PASSED' : 'FAILED',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: progressColor,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Stats cards
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
                    const SizedBox(height: 16),
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

                  const Spacer(),

                  // Feedback message
                  if (_showContent)
                    FadeInUp(
                      delay: const Duration(milliseconds: 600),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          _isPassed
                              ? 'You unlocked the next lesson!'
                              : 'Need $requiredScore+ correct answers to pass',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),

                  const SizedBox(height: 24),

                  // Countdown
                  if (_showContent)
                    FadeIn(
                      delay: const Duration(milliseconds: 700),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.timer_outlined,
                            color: Colors.white,
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Redirecting in $_countdown seconds',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
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
  }

  Widget _buildStatCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 16),
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
    if (widget.lessonId == 1) return 0; // Lesson 1 has no questions
    if (widget.lessonId <= 10) return 6; // Group 1: Lessons 2-10, 10 questions
    if (widget.lessonId <= 20) return 8; // Group 2: Lessons 11-20, 12 questions
    if (widget.lessonId <= 30) return 9; // Group 3: Lessons 21-30, 14 questions
    if (widget.lessonId <= 40) {
      return 11; // Group 4: Lessons 31-40, 16 questions
    }
    return 14; // Group 5: Lessons 41-50, 20 questions
  }
}
