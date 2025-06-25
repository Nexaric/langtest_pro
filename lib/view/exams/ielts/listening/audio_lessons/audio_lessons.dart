// lib/exams/ielts/listening/audio_lessons/audio_lessons.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import 'package:get/get.dart';
import 'package:langtest_pro/controller/listening/listening_controller.dart';
import 'package:langtest_pro/view/exams/ielts/ielts_listening.dart';
import 'audio_screen.dart';

class AudioLessonsScreen extends StatefulWidget {
  const AudioLessonsScreen({super.key});

  @override
  _AudioLessonsScreenState createState() => _AudioLessonsScreenState();
}

class _AudioLessonsScreenState extends State<AudioLessonsScreen> {
  // Gradient colors for the screen background
  final Color _gradientStart = const Color(0xFF3E1E68);
  final Color _gradientEnd = const Color.fromARGB(255, 84, 65, 228);
  // Color for completed lessons
  final Color _accentColor = const Color(0xFF00BFA6);
  // Color for text
  final Color _textLight = const Color.fromARGB(255, 255, 255, 255);
  // Color for locked lessons
  final Color _lockedColor = const Color(0xFFA5A6C4);
  // Gradient colors for unlocked, incomplete lessons
  final Color _unlockedStart = const Color(0xFF6D28D9);
  final Color _unlockedEnd = const Color(0xFF9333EA);

  // Section definitions aligned with group structure
  final List<Map<String, dynamic>> _sections = [
    {
      "title": "Introduction",
      "start": 1,
      "end": 1,
      "description": "Get started with IELTS Listening basics",
    },
    {
      "title": "Everyday Conversations",
      "start": 2,
      "end": 10,
      "description": "Practice common daily interactions",
    },
    {
      "title": "Monologues and Information",
      "start": 11,
      "end": 20,
      "description": "Focus on informational listening",
    },
    {
      "title": "Academic Discussions",
      "start": 21,
      "end": 30,
      "description": "Enhance academic listening skills",
    },
    {
      "title": "Lectures and Complex Audio",
      "start": 31,
      "end": 40,
      "description": "Master complex listening scenarios",
    },
    {
      "title": "Practice and Advanced Scenarios",
      "start": 41,
      "end": 50,
      "description": "Final test preparation",
    },
  ];

  final List<Map<String, dynamic>> audioLessons = [
    // Section 0: Introduction (Lesson 1)
    {
      "title": "Lesson 1: Introduction to IELTS Listening",
      "progress": 0.0,
      "isLocked": false,
      "lessonId": 1,
    },
    // Section 1: Everyday Conversations (Lessons 2-10)
    {
      "title": "Lesson 2: Booking a Hotel Room",
      "progress": 0.0,
      "isLocked": true,
      "lessonId": 2,
    },
    {
      "title": "Lesson 3: Renting an Apartment",
      "progress": 0.0,
      "isLocked": true,
      "lessonId": 3,
    },
    {
      "title": "Lesson 4: Ordering Food at a Restaurant",
      "progress": 0.0,
      "isLocked": true,
      "lessonId": 4,
    },
    {
      "title": "Lesson 5: Making Travel Arrangements",
      "progress": 0.0,
      "isLocked": true,
      "lessonId": 5,
    },
    {
      "title": "Lesson 6: Joining a Gym",
      "progress": 0.0,
      "isLocked": true,
      "lessonId": 6,
    },
    {
      "title": "Lesson 7: Shopping for Clothes",
      "progress": 0.0,
      "isLocked": true,
      "lessonId": 7,
    },
    {
      "title": "Lesson 8: Reporting a Problem to Customer Service",
      "progress": 0.0,
      "isLocked": true,
      "lessonId": 8,
    },
    {
      "title": "Lesson 9: Planning a Social Event",
      "progress": 0.0,
      "isLocked": true,
      "lessonId": 9,
    },
    {
      "title": "Lesson 10: Asking for Directions",
      "progress": 0.0,
      "isLocked": true,
      "lessonId": 10,
    },
    // Section 2: Monologues and Information-Based Audio (Lessons 11-20)
    {
      "title": "Lesson 11: A University Campus Tour",
      "progress": 0.0,
      "isLocked": true,
      "lessonId": 11,
    },
    {
      "title": "Lesson 12: A Museum Guide",
      "progress": 0.0,
      "isLocked": true,
      "lessonId": 12,
    },
    {
      "title": "Lesson 13: A Public Transport Announcement",
      "progress": 0.0,
      "isLocked": true,
      "lessonId": 13,
    },
    {
      "title": "Lesson 14: A Weather Forecast",
      "progress": 0.0,
      "isLocked": true,
      "lessonId": 14,
    },
    {
      "title": "Lesson 15: A Job Interview Overview",
      "progress": 0.0,
      "isLocked": true,
      "lessonId": 15,
    },
    {
      "title": "Lesson 16: A Library Orientation",
      "progress": 0.0,
      "isLocked": true,
      "lessonId": 16,
    },
    {
      "title": "Lesson 17: A Health and Safety Briefing",
      "progress": 0.0,
      "isLocked": true,
      "lessonId": 17,
    },
    {
      "title": "Lesson 18: A Local Festival Announcement",
      "progress": 0.0,
      "isLocked": true,
      "lessonId": 18,
    },
    {
      "title": "Lesson 19: A Radio Advertisement",
      "progress": 0.0,
      "isLocked": true,
      "lessonId": 19,
    },
    {
      "title": "Lesson 20: A Community Event Speech",
      "progress": 0.0,
      "isLocked": true,
      "lessonId": 20,
    },
    // Section 3: Academic Discussions (Lessons 21-30)
    {
      "title": "Lesson 21: Discussing a Group Assignment",
      "progress": 0.0,
      "isLocked": true,
      "lessonId": 21,
    },
    {
      "title": "Lesson 22: A Lecture on Environmental Science",
      "progress": 0.0,
      "isLocked": true,
      "lessonId": 22,
    },
    {
      "title": "Lesson 23: A Tutorial on History",
      "progress": 0.0,
      "isLocked": true,
      "lessonId": 23,
    },
    {
      "title": "Lesson 24: A Debate on Technology",
      "progress": 0.0,
      "isLocked": true,
      "lessonId": 24,
    },
    {
      "title": "Lesson 25: A Presentation on Business Strategies",
      "progress": 0.0,
      "isLocked": true,
      "lessonId": 25,
    },
    {
      "title": "Lesson 26: A Conversation About Research Methods",
      "progress": 0.0,
      "isLocked": true,
      "lessonId": 26,
    },
    {
      "title": "Lesson 27: A Discussion on Literature",
      "progress": 0.0,
      "isLocked": true,
      "lessonId": 27,
    },
    {
      "title": "Lesson 28: A Seminar on Psychology",
      "progress": 0.0,
      "isLocked": true,
      "lessonId": 28,
    },
    {
      "title": "Lesson 29: A Talk on Global Economics",
      "progress": 0.0,
      "isLocked": true,
      "lessonId": 29,
    },
    {
      "title": "Lesson 30: A Workshop on Creative Writing",
      "progress": 0.0,
      "isLocked": true,
      "lessonId": 30,
    },
    // Section 4: Lectures and Complex Audio (Lessons 31-40)
    {
      "title": "Lesson 31: A Lecture on Climate Change",
      "progress": 0.0,
      "isLocked": true,
      "lessonId": 31,
    },
    {
      "title": "Lesson 32: A Talk on Space Exploration",
      "progress": 0.0,
      "isLocked": true,
      "lessonId": 32,
    },
    {
      "title": "Lesson 33: A Presentation on Ancient Civilizations",
      "progress": 0.0,
      "isLocked": true,
      "lessonId": 33,
    },
    {
      "title": "Lesson 34: A Speech on Renewable Energy",
      "progress": 0.0,
      "isLocked": true,
      "lessonId": 34,
    },
    {
      "title": "Lesson 35: A Discussion on Artificial Intelligence",
      "progress": 0.0,
      "isLocked": true,
      "lessonId": 35,
    },
    {
      "title": "Lesson 36: A Lecture on Marine Biology",
      "progress": 0.0,
      "isLocked": true,
      "lessonId": 36,
    },
    {
      "title": "Lesson 37: A Talk on Urban Planning",
      "progress": 0.0,
      "isLocked": true,
      "lessonId": 37,
    },
    {
      "title": "Lesson 38: A Presentation on Cultural Diversity",
      "progress": 0.0,
      "isLocked": true,
      "lessonId": 38,
    },
    {
      "title": "Lesson 39: A Lecture on Medical Advancements",
      "progress": 0.0,
      "isLocked": true,
      "lessonId": 39,
    },
    {
      "title": "Lesson 40: A Discussion on Education Systems",
      "progress": 0.0,
      "isLocked": true,
      "lessonId": 40,
    },
    // Section 5: Practice and Advanced Scenarios (Lessons 41-50)
    {
      "title": "Lesson 41: Multiple Choice Questions Practice",
      "progress": 0.0,
      "isLocked": true,
      "lessonId": 41,
    },
    {
      "title": "Lesson 42: Map and Diagram Labelling Practice",
      "progress": 0.0,
      "isLocked": true,
      "lessonId": 42,
    },
    {
      "title": "Lesson 43: Form and Note Completion Practice",
      "progress": 0.0,
      "isLocked": true,
      "lessonId": 43,
    },
    {
      "title": "Lesson 44: Sentence Completion Practice",
      "progress": 0.0,
      "isLocked": true,
      "lessonId": 44,
    },
    {
      "title": "Lesson 45: Matching Information Practice",
      "progress": 0.0,
      "isLocked": true,
      "lessonId": 45,
    },
    {
      "title": "Lesson 46: Short Answer Questions Practice",
      "progress": 0.0,
      "isLocked": true,
      "lessonId": 46,
    },
    {
      "title": "Lesson 47: Summary Completion Practice",
      "progress": 0.0,
      "isLocked": true,
      "lessonId": 47,
    },
    {
      "title": "Lesson 48: True/False/Not Given Practice",
      "progress": 0.0,
      "isLocked": true,
      "lessonId": 48,
    },
    {
      "title": "Lesson 49: Mixed Question Types Practice",
      "progress": 0.0,
      "isLocked": true,
      "lessonId": 49,
    },
    {
      "title": "Lesson 50: Full-Length Mock Listening Test",
      "progress": 0.0,
      "isLocked": true,
      "lessonId": 50,
    },
  ];

  @override
  void initState() {
    super.initState();
    Get.put(ListeningProgressController());
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const IeltsListeningScreen()),
        );
        return false;
      },
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [_gradientStart, _gradientEnd],
            ),
          ),
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverAppBar(
                title: Text(
                  "IELTS Listening Lessons",
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: _textLight,
                    letterSpacing: 0.5,
                  ),
                ),
                centerTitle: true,
                backgroundColor: Colors.transparent,
                elevation: 0,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const IeltsListeningScreen(),
                      ),
                    );
                  },
                ),
                pinned: true,
                floating: false,
                snap: false,
                expandedHeight: 0,
                toolbarHeight: kToolbarHeight,
              ),
              const SliverPadding(padding: EdgeInsets.only(top: 10)),
              GetBuilder<ListeningProgressController>(
                builder: (progressController) {
                  if (progressController.isLoading) {
                    return const SliverFillRemaining(
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }

                  if (progressController.hasError) {
                    return SliverFillRemaining(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              progressController.errorMessage ??
                                  'Error loading progress',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                color: _textLight,
                              ),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () async {
                                await progressController.restoreFromCloud();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _accentColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              child: Text(
                                'Retry',
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  color: _textLight,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  return SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate((
                        context,
                        sectionIndex,
                      ) {
                        final section = _sections[sectionIndex];
                        final startIndex = section["start"] - 1;
                        final endIndex = section["end"] - 1;

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    section["title"],
                                    style: GoogleFonts.poppins(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: _textLight,
                                    ),
                                  ),
                                  Text(
                                    section["description"],
                                    style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      color: _textLight.withOpacity(0.7),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 20,
                                    mainAxisSpacing: 20,
                                    childAspectRatio: 0.85,
                                  ),
                              itemCount: endIndex - startIndex + 1,
                              itemBuilder: (context, index) {
                                final lessonIndex = startIndex + index;
                                final lesson = audioLessons[lessonIndex];

                                return FadeInUp(
                                  delay: Duration(milliseconds: 100 * index),
                                  child: _buildLessonCard(
                                    context,
                                    lesson: lesson,
                                    lessonIndex: lessonIndex,
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 20),
                          ],
                        );
                      }, childCount: _sections.length),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLessonCard(
    BuildContext context, {
    required Map<String, dynamic> lesson,
    required int lessonIndex,
  }) {
    final progressController = Get.find<ListeningProgressController>();
    // Lock lesson if its index is greater than completed lessons + 1
    final isLocked = lessonIndex > progressController.completedLessons;
    final progress =
        lessonIndex < progressController.completedLessons
            ? 1.0
            : (lessonIndex == progressController.completedLessons
                ? progressController.currentLessonProgress
                : 0.0);

    return Material(
      elevation: 4,
      borderRadius: BorderRadius.circular(20),
      color: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient:
              isLocked
                  ? LinearGradient(
                    colors: [_lockedColor.withOpacity(0.7), _lockedColor],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                  : LinearGradient(
                    colors:
                        progress == 1.0
                            ? [_accentColor.withOpacity(0.8), _accentColor]
                            : [_unlockedStart, _unlockedEnd],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap:
              isLocked
                  ? null
                  : () {
                    debugPrint(lesson.toString());
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => AudioScreen(
                              lesson: {
                                ...lesson,
                                "isLocked": isLocked,
                                "progress": progress,
                              },
                              onComplete: () async {
                                await progressController.completeLesson();
                                // Trigger UI rebuild to update isLocked states
                              },
                              onProgressUpdate: (progress) {
                                progressController.updateProgress(progress);
                              },
                            ),
                      ),
                    );
                  },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Lesson ${lesson["lessonId"]}",
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: _textLight.withOpacity(0.8),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      lesson["title"].toString().split(":").length > 1
                          ? lesson["title"].toString().split(":")[1].trim()
                          : lesson["title"].toString(),
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: _textLight,
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
                Column(
                  children: [
                    LinearProgressIndicator(
                      value: progress,
                      backgroundColor: _textLight.withOpacity(0.2),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        _textLight.withOpacity(0.8),
                      ),
                      minHeight: 6,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      isLocked
                          ? "Complete previous lesson"
                          : progress == 1.0
                          ? "Completed ✓"
                          : "${(progress * 100).toStringAsFixed(0)}% complete",
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: _textLight.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
                Center(
                  child:
                      isLocked
                          ? Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _textLight.withOpacity(0.1),
                            ),
                            child: Icon(
                              Icons.lock_outline,
                              color: _textLight.withOpacity(0.7),
                              size: 24,
                            ),
                          )
                          : Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: _textLight.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: _textLight.withOpacity(0.3),
                                width: 1,
                              ),
                            ),
                            child: Text(
                              progress == 1.0 ? "Review" : "Start Now",
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: _textLight,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
