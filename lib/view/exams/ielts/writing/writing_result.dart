import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:langtest_pro/view/exams/ielts/writing/letters/letter_list_screen.dart';
import 'package:lottie/lottie.dart';
import 'package:langtest_pro/view/exams/ielts/writing/letters/formal_letter/formal_letter_1.dart';
import 'package:langtest_pro/view/exams/ielts/writing/letters/formal_letter/formal_letter_2.dart';
import 'package:langtest_pro/view/exams/ielts/writing/letters/formal_letter/formal_letter_3.dart';
import 'package:langtest_pro/view/exams/ielts/writing/letters/formal_letter/formal_letter_4.dart';
import 'package:langtest_pro/view/exams/ielts/writing/letters/formal_letter/formal_letter_5.dart';
import 'package:langtest_pro/view/exams/ielts/writing/letters/formal_letter/formal_letter_6.dart';
import 'package:langtest_pro/view/exams/ielts/writing/letters/formal_letter/formal_letter_7.dart';
import 'package:langtest_pro/view/exams/ielts/writing/letters/informal_letter/informal_letter_1.dart';
import 'package:langtest_pro/view/exams/ielts/writing/letters/informal_letter/informal_letter_2.dart';
import 'package:langtest_pro/view/exams/ielts/writing/letters/informal_letter/informal_letter_3.dart';
import 'package:langtest_pro/view/exams/ielts/writing/letters/informal_letter/informal_letter_4.dart';
import 'package:langtest_pro/view/exams/ielts/writing/letters/informal_letter/informal_letter_5.dart';
import 'package:langtest_pro/view/exams/ielts/writing/letters/informal_letter/informal_letter_6.dart';
import 'package:langtest_pro/view/exams/ielts/writing/letters/informal_letter/informal_letter_7.dart';

class WritingResultScreen extends StatelessWidget {
  final double score;
  final String feedback;
  final String taskType;
  final int wordCount;
  final Map<String, dynamic> lessonData;

  const WritingResultScreen({
    super.key,
    required this.score,
    required this.feedback,
    required this.taskType,
    this.wordCount = 0,
    required this.lessonData,
    required resultData,
  });

  Widget getCurrentLessonWidget() {
    switch (lessonData['id']) {
      case 'formal_letter_1':
        return FormalLetterLesson1(lessonData: lessonData);
      case 'formal_letter_2':
        return FormalLetterLesson2(lessonData: lessonData);
      case 'formal_letter_3':
        return FormalLetterLesson3(lessonData: lessonData);
      case 'formal_letter_4':
        return FormalLetterLesson4(lessonData: lessonData);
      case 'formal_letter_5':
        return FormalLetterLesson5(lessonData: lessonData);
      case 'formal_letter_6':
        return FormalLetterLesson6(lessonData: lessonData);
      case 'formal_letter_7':
        return FormalLetterLesson7(lessonData: lessonData);
      case 'informal_letter_1':
        return InformalLetterLesson1(lessonData: lessonData);
      case 'informal_letter_2':
        return InformalLetterLesson2(lessonData: lessonData);
      case 'informal_letter_3':
        return InformalLetterLesson3(lessonData: lessonData);
      case 'informal_letter_4':
        return InformalLetterLesson4(lessonData: lessonData);
      case 'informal_letter_5':
        return InformalLetterLesson5(lessonData: lessonData);
      case 'informal_letter_6':
        return InformalLetterLesson6(lessonData: lessonData);
      case 'informal_letter_7':
        return InformalLetterLesson7(lessonData: lessonData);
      default:
        return Container();
    }
  }

  Widget? getNextLessonWidget() {
    final currentId = lessonData['id'] as String;
    final lessonNumber = int.parse(currentId.split('_').last);
    final isFormal = currentId.startsWith('formal_letter_');

    if (isFormal) {
      if (lessonNumber < 7) {
        return _getFormalLessonWidget(lessonNumber + 1);
      } else {
        return InformalLetterLesson1(
          lessonData: {
            'id': 'informal_letter_1',
            'title': 'Inviting a Friend',
            'subtitle': 'Write a friendly invitation letter.',
            'duration': '15 min',
            'intId': 8,
          },
        );
      }
    } else {
      if (lessonNumber < 7) {
        return _getInformalLessonWidget(lessonNumber + 1);
      } else {
        return null; // No next lesson after informal_letter_7
      }
    }
  }

  Widget _getFormalLessonWidget(int lessonNumber) {
    final lessonDataMap = {
      'id': 'formal_letter_$lessonNumber',
      'title':
          lessonNumber == 2
              ? 'Request for Information'
              : lessonNumber == 3
              ? 'Job Application'
              : lessonNumber == 4
              ? 'Reporting a Problem'
              : lessonNumber == 5
              ? 'Making a Recommendation'
              : lessonNumber == 6
              ? 'Requesting Permission'
              : 'Giving Feedback',
      'subtitle':
          lessonNumber == 2
              ? 'Practice requesting information formally.'
              : lessonNumber == 3
              ? 'Craft a professional job application letter.'
              : lessonNumber == 4
              ? 'Report issues in a formal tone.'
              : lessonNumber == 5
              ? 'Write a formal recommendation letter.'
              : lessonNumber == 6
              ? 'Request permission formally.'
              : 'Provide formal feedback effectively.',
      'duration': lessonNumber == 3 ? '25 min' : '20 min',
      'intId': lessonNumber,
    };
    switch (lessonNumber) {
      case 2:
        return FormalLetterLesson2(lessonData: lessonDataMap);
      case 3:
        return FormalLetterLesson3(lessonData: lessonDataMap);
      case 4:
        return FormalLetterLesson4(lessonData: lessonDataMap);
      case 5:
        return FormalLetterLesson5(lessonData: lessonDataMap);
      case 6:
        return FormalLetterLesson6(lessonData: lessonDataMap);
      case 7:
        return FormalLetterLesson7(lessonData: lessonDataMap);
      default:
        return Container();
    }
  }

  Widget _getInformalLessonWidget(int lessonNumber) {
    final lessonDataMap = {
      'id': 'informal_letter_$lessonNumber',
      'title':
          lessonNumber == 1
              ? 'Inviting a Friend'
              : lessonNumber == 2
              ? 'Thanking a Friend'
              : lessonNumber == 3
              ? 'Apologizing'
              : lessonNumber == 4
              ? 'Giving Advice'
              : lessonNumber == 5
              ? 'Sharing News'
              : lessonNumber == 6
              ? 'Requesting a Favor'
              : 'Reconnecting with an Old Friend',
      'subtitle':
          lessonNumber == 1
              ? 'Write a friendly invitation letter.'
              : lessonNumber == 2
              ? 'Express gratitude in an informal letter.'
              : lessonNumber == 3
              ? 'Write an informal apology letter.'
              : lessonNumber == 4
              ? 'Offer advice in a friendly tone.'
              : lessonNumber == 5
              ? 'Share personal updates informally.'
              : lessonNumber == 6
              ? 'Ask for a favor in an informal way.'
              : 'Reconnect with a friend informally.',
      'duration': '15 min',
      'intId': lessonNumber + 7,
    };
    switch (lessonNumber) {
      case 1:
        return InformalLetterLesson1(lessonData: lessonDataMap);
      case 2:
        return InformalLetterLesson2(lessonData: lessonDataMap);
      case 3:
        return InformalLetterLesson3(lessonData: lessonDataMap);
      case 4:
        return InformalLetterLesson4(lessonData: lessonDataMap);
      case 5:
        return InformalLetterLesson5(lessonData: lessonDataMap);
      case 6:
        return InformalLetterLesson6(lessonData: lessonDataMap);
      case 7:
        return InformalLetterLesson7(lessonData: lessonDataMap);
      default:
        return Container();
    }
  }

  void _showCompletionDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Text(
              "Congratulations!",
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Lottie.asset(
                  'assets/animations/success.json', // Using success.json for celebration
                  height: 120,
                  repeat: false,
                ),
                const SizedBox(height: 16),
                Text(
                  "You've completed all 14 letter lessons!",
                  style: GoogleFonts.poppins(fontSize: 16, height: 1.5),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  "Amazing work mastering IELTS Writing Task 1!",
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LetterListScreen(),
                    ),
                  );
                },
                child: Text(
                  "Back to Letter List",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isHighScore = score >= 7.0;
    final isLetterLesson = taskType == "Letter";
    final points = isLetterLesson && wordCount > 0 ? wordCount ~/ 5 : 0;

    // Show completion dialog for the 14th lesson
    if (isLetterLesson && lessonData['intId'] == 14) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showCompletionDialog(context);
      });
    }

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.topRight,
            radius: 1.5,
            colors: [
              colorScheme.primary.withOpacity(0.1),
              colorScheme.primary.withOpacity(0.05),
              Colors.transparent,
            ],
            stops: const [0.1, 0.4, 1.0],
          ),
        ),
        child: Stack(
          children: [
            // Background elements
            Positioned(
              top: -50,
              right: -50,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      colorScheme.primary.withOpacity(0.15),
                      Colors.transparent,
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ),

            // Main content
            Column(
              children: [
                // Top bar
                Container(
                  padding: const EdgeInsets.fromLTRB(16, 40, 16, 16),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF3E1E68), Color(0xFF6A5AE0)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_back_rounded,
                          color: Colors.white,
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                      Text(
                        "Writing Result",
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 48), // For balance
                    ],
                  ),
                ),

                // Main content
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 24),

                        // Score card with glassmorphism
                        FadeInUp(
                          delay: const Duration(milliseconds: 100),
                          child: GlassCard(
                            child: Padding(
                              padding: const EdgeInsets.all(24),
                              child: Column(
                                children: [
                                  Text(
                                    "Your IELTS Writing Score",
                                    style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: colorScheme.onSurface.withOpacity(
                                        0.8,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 16),

                                  // Animated score display
                                  Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      SizedBox(
                                        width: 180,
                                        height: 180,
                                        child: CircularProgressIndicator(
                                          value: score / 9.0,
                                          strokeWidth: 12,
                                          backgroundColor: colorScheme.surface
                                              .withOpacity(0.3),
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                isHighScore
                                                    ? const Color(0xFF4CAF50)
                                                    : const Color(0xFF2196F3),
                                              ),
                                        ),
                                      ),
                                      Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            score.toStringAsFixed(1),
                                            style: GoogleFonts.poppins(
                                              fontSize: 48,
                                              fontWeight: FontWeight.bold,
                                              color: colorScheme.onSurface,
                                            ),
                                          ),
                                          Text(
                                            "Band Score",
                                            style: GoogleFonts.poppins(
                                              fontSize: 14,
                                              color: colorScheme.onSurface
                                                  .withOpacity(0.6),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: 24),

                                  // Task info
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 12,
                                    ),
                                    decoration: BoxDecoration(
                                      color: colorScheme.surface.withOpacity(
                                        0.3,
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Task Type",
                                              style: GoogleFonts.poppins(
                                                fontSize: 12,
                                                color: colorScheme.onSurface
                                                    .withOpacity(0.6),
                                              ),
                                            ),
                                            Text(
                                              taskType,
                                              style: GoogleFonts.poppins(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            if (wordCount > 0) ...[
                                              Text(
                                                "Word Count",
                                                style: GoogleFonts.poppins(
                                                  fontSize: 12,
                                                  color: colorScheme.onSurface
                                                      .withOpacity(0.6),
                                                ),
                                              ),
                                              Text(
                                                "$wordCount",
                                                style: GoogleFonts.poppins(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                            if (isLetterLesson && wordCount > 0)
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
                                                  Text(
                                                    "Points Earned",
                                                    style: GoogleFonts.poppins(
                                                      fontSize: 12,
                                                      color: colorScheme
                                                          .onSurface
                                                          .withOpacity(0.6),
                                                    ),
                                                  ),
                                                  Text(
                                                    "$points",
                                                    style: GoogleFonts.poppins(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color:
                                                          colorScheme.primary,
                                                    ),
                                                  ),
                                                ],
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
                        ),

                        const SizedBox(height: 24),

                        // Feedback section
                        FadeInUp(
                          delay: const Duration(milliseconds: 200),
                          child: GlassCard(
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      SvgPicture.asset(
                                        'assets/icons/feedback.svg',
                                        width: 24,
                                        color: colorScheme.primary,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        "Expert Feedback",
                                        style: GoogleFonts.poppins(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    feedback,
                                    style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      height: 1.6,
                                      color: colorScheme.onSurface.withOpacity(
                                        0.8,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 32),

                        // Score interpretation
                        if (isHighScore)
                          FadeInUp(
                            delay: const Duration(milliseconds: 300),
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: const Color(0xFF4CAF50).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: const Color(
                                    0xFF4CAF50,
                                  ).withOpacity(0.3),
                                ),
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.celebration_rounded,
                                    color: Color(0xFF4CAF50),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      "Excellent! Your score meets most university requirements.",
                                      style: GoogleFonts.poppins(
                                        color: const Color(0xFF4CAF50),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        else
                          FadeInUp(
                            delay: const Duration(milliseconds: 300),
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: const Color(0xFF2196F3).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: const Color(
                                    0xFF2196F3,
                                  ).withOpacity(0.3),
                                ),
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.lightbulb_outline_rounded,
                                    color: Color(0xFF2196F3),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      "Good attempt! Focus on the feedback to improve further.",
                                      style: GoogleFonts.poppins(
                                        color: const Color(0xFF2196F3),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                        const SizedBox(height: 32),

                        // Action buttons
                        FadeInUp(
                          delay: const Duration(milliseconds: 400),
                          child: Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    final nextLesson = getNextLessonWidget();
                                    if (nextLesson != null) {
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => nextLesson,
                                        ),
                                      );
                                    } else {
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder:
                                              (_) => const LetterListScreen(),
                                        ),
                                      );
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: colorScheme.primary,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 16,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    elevation: 0,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        Icons.arrow_forward_rounded,
                                        size: 20,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        lessonData['intId'] == 14
                                            ? "Back to Letter List"
                                            : "Next Lesson",
                                        style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.w500,
                                          color: colorScheme.onPrimary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),

                        FadeInUp(
                          delay: const Duration(milliseconds: 500),
                          child: TextButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => getCurrentLessonWidget(),
                                ),
                              );
                            },
                            child: Text(
                              "Try Again",
                              style: GoogleFonts.poppins(
                                color: colorScheme.primary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Glassmorphism card widget
class GlassCard extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final double padding;

  const GlassCard({
    super.key,
    required this.child,
    this.borderRadius = 20,
    this.padding = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface.withOpacity(0.4),
              borderRadius: BorderRadius.circular(borderRadius),
              border: Border.all(
                color: Theme.of(context).colorScheme.surface.withOpacity(0.2),
                width: 1,
              ),
            ),
            padding: EdgeInsets.all(padding),
            child: child,
          ),
        ),
      ),
    );
  }
}
