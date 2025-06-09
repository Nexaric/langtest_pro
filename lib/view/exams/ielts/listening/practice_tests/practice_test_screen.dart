// lib/exams/ielts/listening/practice_tests/practice_test_screen.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import 'package:langtest_pro/view/exams/ielts/ielts_listening.dart';
import 'package:provider/provider.dart';
import '../../../../../controller/listening_progress_provider.dart';
import 'practice_test_questions_screen.dart';

class PracticeTestScreen extends StatefulWidget {
  const PracticeTestScreen({super.key});

  @override
  _PracticeTestScreenState createState() => _PracticeTestScreenState();
}

class _PracticeTestScreenState extends State<PracticeTestScreen> {
  final Color _primaryColor = const Color(0xFF6A5AE0);
  final Color _secondaryColor = const Color(0xFF5441E4);
  final Color _darkPurple = const Color(0xFF3E1E68);
  final Color _textLight = Colors.white;
  final Color _lockedColor = const Color(0xFFA5A6C4);
  final Color _completedColor = const Color(0xFF4CAF50);

  final List<Map<String, dynamic>> testParts = [
    {
      "title": "Part 1: Social Conversation",
      "description": "Conversation between two people in a social context",
      "partId": "Part 1",
      "isLocked": false,
      "icon": Icons.chat_bubble_outline,
      "duration": "5 min",
    },
    {
      "title": "Part 2: Monologue",
      "description": "Monologue in a social context (e.g., speech)",
      "partId": "Part 2",
      "isLocked": true,
      "icon": Icons.record_voice_over,
      "duration": "10 min",
    },
    {
      "title": "Part 3: Educational Discussion",
      "description":
          "Conversation between multiple people in an educational context",
      "partId": "Part 3",
      "isLocked": true,
      "icon": Icons.school_outlined,
      "duration": "15 min",
    },
    {
      "title": "Part 4: Academic Lecture",
      "description": "Academic lecture or talk",
      "partId": "Part 4",
      "isLocked": true,
      "icon": Icons.menu_book_outlined,
      "duration": "20 min",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder:
                (context, animation, secondaryAnimation) =>
                    const IeltsListeningScreen(),
            transitionsBuilder: (
              context,
              animation,
              secondaryAnimation,
              child,
            ) {
              return FadeTransition(opacity: animation, child: child);
            },
          ),
        );
        return false;
      },
      child: Scaffold(
        backgroundColor: _darkPurple,
        appBar: AppBar(
          title: FadeIn(
            child: Text(
              "IELTS Listening Practice",
              style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: _textLight,
              ),
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                PageRouteBuilder(
                  pageBuilder:
                      (context, animation, secondaryAnimation) =>
                          const IeltsListeningScreen(),
                  transitionsBuilder: (
                    context,
                    animation,
                    secondaryAnimation,
                    child,
                  ) {
                    return SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(-1, 0),
                        end: Offset.zero,
                      ).animate(animation),
                      child: child,
                    );
                  },
                ),
              );
            },
          ),
        ),
        body: Consumer<ListeningProgressProvider>(
          builder: (context, progressProvider, _) {
            if (progressProvider.isLoading) {
              return Center(
                child: Bounce(
                  infinite: true,
                  child: const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
              );
            }

            return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [_darkPurple, _secondaryColor],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: const [0.3, 0.9],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
                    child: FadeInDown(
                      child: Text(
                        "Practice Tests",
                        style: GoogleFonts.poppins(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: _textLight,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: FadeInDown(
                      delay: const Duration(milliseconds: 100),
                      child: Text(
                        "Complete each part to unlock the next level",
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: _textLight.withOpacity(0.8),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      itemCount: testParts.length,
                      itemBuilder: (context, index) {
                        final part = testParts[index];
                        final isLocked =
                            index > 0 &&
                            !progressProvider.isPracticeTestComplete(
                              testParts[index - 1]["partId"],
                            );
                        return ElasticIn(
                          delay: Duration(milliseconds: 150 * index),
                          child: _buildTestCard(context, {
                            ...part,
                            "isLocked": isLocked,
                          }, progressProvider),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildTestCard(
    BuildContext context,
    Map<String, dynamic> part,
    ListeningProgressProvider progressProvider,
  ) {
    final isLocked = part["isLocked"] as bool? ?? false;
    final isCompleted = progressProvider.isPracticeTestComplete(
      part["partId"] as String,
    );
    final icon =
        part["icon"] as IconData? ?? Icons.help_outline; // Default icon if null
    final duration =
        part["duration"] as String? ?? ""; // Default empty string if null

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap:
              isLocked
                  ? null
                  : () async {
                    final shouldStart = await _showStartDialog(context, part);
                    if (shouldStart == true) {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  PracticeTestQuestionsScreen(
                                    part: part["partId"] as String,
                                    onTestCompleted: (
                                      score,
                                      totalQuestions,
                                      unlockedNextPart,
                                    ) async {
                                      if (unlockedNextPart) {
                                        await progressProvider
                                            .completePracticeTest(
                                              part["partId"] as String,
                                            );
                                      }
                                    },
                                  ),
                          transitionsBuilder: (
                            context,
                            animation,
                            secondaryAnimation,
                            child,
                          ) {
                            return SlideTransition(
                              position: Tween<Offset>(
                                begin: const Offset(1, 0),
                                end: Offset.zero,
                              ).animate(animation),
                              child: child,
                            );
                          },
                        ),
                      );
                    }
                  },
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color:
                  isLocked
                      ? _lockedColor.withOpacity(0.2)
                      : isCompleted
                      ? _completedColor.withOpacity(0.2)
                      : Colors.white.withOpacity(0.1),
              border: Border.all(
                color:
                    isLocked
                        ? _lockedColor.withOpacity(0.5)
                        : isCompleted
                        ? _completedColor.withOpacity(0.5)
                        : _primaryColor.withOpacity(0.5),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color:
                        isLocked
                            ? _lockedColor.withOpacity(0.3)
                            : isCompleted
                            ? _completedColor
                            : _primaryColor,
                  ),
                  child: Icon(icon, color: _textLight, size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        part["title"] as String? ??
                            "Untitled", // Safe cast with default
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color:
                              isLocked
                                  ? _textLight.withOpacity(0.5)
                                  : _textLight,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        part["description"] as String? ??
                            "", // Safe cast with default
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color:
                              isLocked
                                  ? _textLight.withOpacity(0.4)
                                  : _textLight.withOpacity(0.7),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        duration,
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color:
                              isLocked
                                  ? _textLight.withOpacity(0.4)
                                  : _primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                if (isLocked)
                  const Icon(Icons.lock_outline_rounded, color: Colors.white54)
                else if (isCompleted)
                  const Icon(Icons.check_circle_rounded, color: Colors.green)
                else
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _primaryColor.withOpacity(0.3),
                    ),
                    child: const Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<bool?> _showStartDialog(
    BuildContext context,
    Map<String, dynamic> part,
  ) {
    return showDialog<bool>(
      context: context,
      builder:
          (context) => Dialog(
            backgroundColor: _darkPurple,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Start ${part["title"] as String? ?? "Test"}?", // Safe cast with default
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: _textLight,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "This test will take approximately ${part["duration"] as String? ?? "some time"}.", // Safe cast with default
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: _textLight.withOpacity(0.8),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: BorderSide(color: _primaryColor),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                        ),
                        onPressed: () => Navigator.pop(context, false),
                        child: Text(
                          "Cancel",
                          style: GoogleFonts.poppins(
                            color: _primaryColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                        ),
                        onPressed: () => Navigator.pop(context, true),
                        child: Text(
                          "Start Now",
                          style: GoogleFonts.poppins(
                            color: _textLight,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
    );
  }
}
