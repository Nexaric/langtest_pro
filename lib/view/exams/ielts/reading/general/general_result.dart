import 'dart:math';
import 'package:animate_do/animate_do.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:langtest_pro/controller/reading_controller.dart';
import 'package:langtest_pro/view/exams/ielts/reading/general/general_screen.dart';
import 'package:langtest_pro/view/exams/ielts/reading/general/general_lessons.dart';

class GeneralResult extends StatefulWidget {
  final int lessonId;
  final String score;
  final bool passed;
  final int correctAnswers;
  final int totalQuestions;
  final int requiredCorrectAnswers;
  final VoidCallback onComplete;

  const GeneralResult({
    super.key,
    required this.lessonId,
    required this.score,
    required this.passed,
    required this.correctAnswers,
    required this.totalQuestions,
    required this.requiredCorrectAnswers,
    required this.onComplete,
  });

  @override
  State<GeneralResult> createState() => _GeneralResultState();
}

class _GeneralResultState extends State<GeneralResult>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late ConfettiController _confettiController;
  late Animation<double> _scaleAnimation;

  final Color _gradientStart = const Color(0xFF3E1E68);
  final Color _gradientEnd = const Color.fromARGB(255, 84, 65, 228);
  final Color _accentColor = const Color(0xFF00BFA6);
  final Color _textLight = const Color.fromARGB(255, 255, 255, 255);
  final Color _glowColor = const Color(0xFFBB86FC);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut));
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 3),
    );

    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        _controller.forward();
        if (widget.passed) {
          _confettiController.play();
        } else {
          _controller.repeat(
            reverse: true,
            period: const Duration(milliseconds: 500),
          );
          Future.delayed(const Duration(seconds: 2), () {
            if (mounted) _controller.stop();
          });
        }
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  Widget _buildStatCard(
    String label,
    String value,
    Color gradientStart,
    IconData icon,
  ) {
    return FadeInUp(
      delay: Duration(
        milliseconds:
            600 +
            (label == 'Correct'
                ? 0
                : label == 'Wrong'
                ? 200
                : 400),
      ),
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [gradientStart, gradientStart.withOpacity(0.7)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: _textLight, size: 24),
            const SizedBox(height: 4),
            Text(
              value,
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: _textLight,
              ),
            ),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: _textLight.withOpacity(0.8),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final percentage =
        widget.totalQuestions > 0
            ? (widget.correctAnswers / widget.totalQuestions) * 100
            : 0.0;
    final wrongAnswers = widget.totalQuestions - widget.correctAnswers;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [_gradientStart, _gradientEnd],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              ConfettiWidget(
                confettiController: _confettiController,
                blastDirectionality: BlastDirectionality.explosive,
                colors: const [
                  Colors.red,
                  Colors.blue,
                  Colors.green,
                  Colors.yellow,
                ],
                numberOfParticles: 20,
                maxBlastForce: 50,
                minBlastForce: 20,
              ),
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FadeInDown(
                      duration: const Duration(milliseconds: 500),
                      child: Text(
                        widget.passed ? 'Well Done!' : 'Keep Practicing!',
                        style: GoogleFonts.poppins(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: _textLight,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    FadeIn(
                      duration: const Duration(milliseconds: 600),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: size.width * 0.5,
                            height: size.width * 0.5,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: RadialGradient(
                                colors: [
                                  _glowColor.withOpacity(0.3),
                                  Colors.transparent,
                                ],
                                radius: 0.8,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: size.width * 0.4,
                            height: size.width * 0.4,
                            child: CustomPaint(
                              painter: ProgressRingPainter(
                                progress: percentage / 100,
                                color: _accentColor,
                                backgroundColor: _textLight.withOpacity(0.2),
                              ),
                              child: Center(
                                child: ScaleTransition(
                                  scale: _scaleAnimation,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        '${percentage.toStringAsFixed(0)}%',
                                        style: GoogleFonts.poppins(
                                          fontSize: 34,
                                          fontWeight: FontWeight.bold,
                                          color: _textLight,
                                        ),
                                      ),
                                      Text(
                                        widget.score,
                                        style: GoogleFonts.poppins(
                                          fontSize: 16,
                                          color: _textLight.withOpacity(0.8),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildStatCard(
                          'Correct',
                          '${widget.correctAnswers}',
                          _accentColor,
                          Icons.check_circle,
                        ),
                        _buildStatCard(
                          'Wrong',
                          '$wrongAnswers',
                          const Color(0xFFFF6B6B),
                          Icons.cancel,
                        ),
                        _buildStatCard(
                          'Required',
                          '${widget.requiredCorrectAnswers}',
                          const Color(0xFFBB86FC),
                          Icons.star,
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    FadeInUp(
                      delay: const Duration(milliseconds: 800),
                      child: Text(
                        widget.passed
                            ? 'You’ve passed Lesson ${widget.lessonId}! Keep up the great work!'
                            : 'You need ${widget.requiredCorrectAnswers} correct answers to pass. Try again!',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: _textLight.withOpacity(0.9),
                          height: 1.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        FadeInLeft(
                          delay: const Duration(milliseconds: 1000),
                          child: ElevatedButton(
                            onPressed: () {
                              try {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) => GeneralScreen(
                                          lessonId: widget.lessonId,
                                          onComplete: widget.onComplete,
                                        ),
                                  ),
                                );
                              } catch (e) {
                                Get.snackbar(
                                  'Error',
                                  'Failed to navigate to lesson: $e',
                                  backgroundColor: Colors.red,
                                  colorText: _textLight,
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _accentColor,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 16,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 5,
                            ),
                            child: Text(
                              'Retry Lesson',
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: _textLight,
                              ),
                            ),
                          ),
                        ),
                        FadeInRight(
                          delay: const Duration(milliseconds: 1000),
                          child: ElevatedButton(
                            onPressed: () async {
                              try {
                                await Get.find<ReadingController>()
                                    .refreshProgress();
                                widget.onComplete();
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) =>
                                            const GeneralLessonsScreen(),
                                  ),
                                );
                              } catch (e) {
                                Get.snackbar(
                                  'Error',
                                  'Failed to navigate to lessons: $e',
                                  backgroundColor: Colors.red,
                                  colorText: _textLight,
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _gradientStart.withOpacity(0.8),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 16,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 5,
                            ),
                            child: Text(
                              widget.passed ? 'Next Lesson' : 'Back to Lessons',
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: _textLight,
                              ),
                            ),
                          ),
                        ),
                      ],
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
}

class ProgressRingPainter extends CustomPainter {
  final double progress;
  final Color color;
  final Color backgroundColor;

  ProgressRingPainter({
    required this.progress,
    required this.color,
    required this.backgroundColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    const strokeWidth = 12.0;

    // Draw background circle
    final backgroundPaint =
        Paint()
          ..color = backgroundColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth
          ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, backgroundPaint);

    // Draw progress arc
    final progressPaint =
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth
          ..strokeCap = StrokeCap.round;

    final sweepAngle = 2 * pi * progress;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
