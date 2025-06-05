import 'package:animate_do/animate_do.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:langtest_pro/exams/ielts/reading/academic/lesson_screen.dart';
import 'package:langtest_pro/exams/ielts/reading/academic/academic_lessons.dart';

class AcademicResult extends StatefulWidget {
  final int totalQuestions;
  final int correctAnswers;
  final List<int> selectedAnswers;
  final List<Map<String, dynamic>> questions;
  final VoidCallback onComplete;
  final int lessonId;

  const AcademicResult({
    super.key,
    required this.totalQuestions,
    required this.correctAnswers,
    required this.selectedAnswers,
    required this.questions,
    required this.onComplete,
    required this.lessonId,
  });

  @override
  State<AcademicResult> createState() => _AcademicResultState();
}

class _AcademicResultState extends State<AcademicResult>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late ConfettiController _confettiController;
  late Animation<double> _scaleAnimation;
  bool _isPassed = false;

  final Color _gradientStart = const Color(0xFF3E1E68);
  final Color _gradientEnd = const Color.fromARGB(255, 84, 65, 228);
  final Color _accentColor = const Color(0xFF00BFA6);
  final Color _textLight = const Color.fromARGB(255, 255, 255, 255);
  final Color _glowColor = const Color(0xFFBB86FC);

  @override
  void initState() {
    super.initState();
    final requiredCorrectAnswers = _getRequiredScore();
    _isPassed = widget.correctAnswers >= requiredCorrectAnswers;

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
        if (_isPassed) {
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

  int _getRequiredScore() {
    if (widget.lessonId <= 10) return 5;
    if (widget.lessonId <= 20) return 7;
    if (widget.lessonId <= 30) return 10;
    return 13;
  }

  void _navigateBackToLessons() {
    widget.onComplete();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const AcademicLessonsScreen()),
    );
  }

  void _retryLesson() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder:
            (context) => LessonScreen(
              lessonId: widget.lessonId,
              onComplete: widget.onComplete,
            ),
      ),
    );
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
    final requiredScore = _getRequiredScore();
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
              ),
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FadeInDown(
                      child: Text(
                        _isPassed ? 'Well Done!' : 'Keep Practicing!',
                        style: GoogleFonts.poppins(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: _textLight,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    FadeIn(
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
                                      Icon(
                                        _isPassed
                                            ? Icons.check_circle
                                            : Icons.close,
                                        color: _textLight,
                                        size: 40,
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
                          Icons.check,
                        ),
                        _buildStatCard(
                          'Wrong',
                          '$wrongAnswers',
                          Colors.redAccent,
                          Icons.close,
                        ),
                        _buildStatCard(
                          'Total',
                          '${widget.totalQuestions}',
                          Colors.blueAccent,
                          Icons.list,
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    FadeInUp(
                      delay: const Duration(milliseconds: 800),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: _accentColor.withOpacity(0.3),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Text(
                          _isPassed
                              ? 'Great job! You’re ready for the next challenge!'
                              : 'Need $requiredScore correct answers to pass. You’ll get there!',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            color: _textLight,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    FadeInUp(
                      delay: const Duration(milliseconds: 1000),
                      child: Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: _navigateBackToLessons,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [_accentColor, _gradientEnd],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      blurRadius: 8,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Text(
                                  'Back to Lessons',
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: _textLight,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: GestureDetector(
                              onTap: _retryLesson,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      _isPassed
                                          ? _accentColor
                                          : Colors.blueAccent,
                                      _gradientEnd,
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      blurRadius: 8,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Text(
                                  'Retry Lesson',
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: _textLight,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
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
    final strokeWidth = 12.0;

    // Background ring
    final backgroundPaint =
        Paint()
          ..color = backgroundColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth;
    canvas.drawCircle(center, radius, backgroundPaint);

    // Progress arc
    final progressPaint =
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth
          ..strokeCap = StrokeCap.round;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -3.14 / 2,
      2 * 3.14 * progress,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
