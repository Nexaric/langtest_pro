import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import 'package:get/get.dart';
import 'package:langtest_pro/controller/reading_progress_provider.dart';

import 'general_screen.dart';
import 'package:langtest_pro/view/exams/ielts/ielts_reading.dart';

class GeneralLessonsScreen extends StatefulWidget {
  const GeneralLessonsScreen({super.key, required lessonData});

  @override
  State<GeneralLessonsScreen> createState() => _GeneralLessonsScreenState();
}

class _GeneralLessonsScreenState extends State<GeneralLessonsScreen> {
  final Color _gradientStart = const Color(0xFF3E1E68);
  final Color _gradientEnd = const Color.fromARGB(255, 84, 65, 228);
  final Color _accentColor = const Color(0xFF00BFA6);
  final Color _textLight = const Color.fromARGB(255, 255, 255, 255);
  final Color _lockedColor = const Color(0xFFA5A6C4);
  final Color _unlockedStart = const Color(0xFF6D28D9);
  final Color _unlockedEnd = const Color(0xFF9333EA);

  final List<Map<String, dynamic>> _sections = [
    {
      "title": "Workplace and Consumer Skills",
      "start": 1,
      "end": 5,
      "description":
          "Learn about flexible work, consumer rights, and workplace safety",
    },
    {
      "title": "Travel and Community",
      "start": 6,
      "end": 10,
      "description":
          "Explore volunteering, travel itineraries, and community initiatives",
    },
    {
      "title": "Finance and Business",
      "start": 11,
      "end": 14,
      "description":
          "Understand budgeting, digital banking, and small business basics",
    },
  ];

  final List<Map<String, dynamic>> lessons = [
    {'title': 'Lesson 1: Flexible Working Arrangements', 'lessonId': 1},
    {'title': 'Lesson 2: Exploring New Zealand’s South Island', 'lessonId': 2},
    {'title': 'Lesson 3: Consumer Rights', 'lessonId': 3},
    {'title': 'Lesson 4: Community Gardens', 'lessonId': 4},
    {'title': 'Lesson 5: Smart Home Devices', 'lessonId': 5},
    {'title': 'Lesson 6: Volunteering Abroad', 'lessonId': 6},
    {'title': 'Lesson 7: Budgeting for Beginners', 'lessonId': 7},
    {'title': 'Lesson 8: Public Transport in Sydney', 'lessonId': 8},
    {'title': 'Lesson 9: Starting a Small Business', 'lessonId': 9},
    {'title': 'Lesson 10: Healthy Eating on a Budget', 'lessonId': 10},
    {'title': 'Lesson 11: Workplace Safety', 'lessonId': 11},
    {
      'title': 'Lesson 12: Understanding Your Employment Contract',
      'lessonId': 12,
    },
    {'title': 'Lesson 13: Eco-Tourism in Costa Rica', 'lessonId': 13},
    {'title': 'Lesson 14: Digital Banking', 'lessonId': 14},
  ];

  @override
  void initState() {
    super.initState();
    if (!Get.isRegistered<ReadingProgressController>()) {
      Get.put(ReadingProgressController());
    }
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );
  }

  @override
  void dispose() {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: null,
        systemNavigationBarColor: null,
      ),
    );
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const IeltsReadingScreen()),
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
                  "General Training Lessons",
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: _textLight,
                    letterSpacing: 0.5,
                  ),
                ),
                centerTitle: true,
                backgroundColor: const Color(0xFF402175),
                elevation: 0,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const IeltsReadingScreen(),
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
              SliverToBoxAdapter(
                child: Obx(() {
                  final progressController =
                      Get.find<ReadingProgressController>();
                  if (progressController.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (progressController.hasError) {
                    return Center(
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
                    );
                  }

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: List.generate(_sections.length, (sectionIndex) {
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
                            if (section["start"] > 3)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: Text(
                                  "Note: Lessons ${section["start"]}–${section["end"]} are under development and use placeholder content.",
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    color: _textLight.withOpacity(0.8),
                                    fontStyle: FontStyle.italic,
                                  ),
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
                                final lesson = lessons[lessonIndex];

                                return FadeInUp(
                                  delay: Duration(milliseconds: 100 * index),
                                  child: _buildLessonCard(
                                    context,
                                    lesson: lesson,
                                    lessonIndex: lessonIndex,
                                    progressController: progressController,
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 20),
                          ],
                        );
                      }),
                    ),
                  );
                }),
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
    required ReadingProgressController progressController,
  }) {
    final lessonNumber = lessonIndex + 1;
    final isLocked =
        !progressController.isGeneralLessonAccessible(lessonNumber);
    final progress =
        lessonNumber <= progressController.completedGeneralLessons
            ? 1.0
            : (lessonNumber == progressController.completedGeneralLessons + 1
                ? progressController.currentLessonProgress
                : 0.0);
    final lessonId = lesson['lessonId'] as int?;

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
              isLocked || lessonId == null
                  ? null
                  : () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => GeneralScreen(
                              lessonId: lessonId,
                              onComplete: () async {
                                await progressController.completeGeneralLesson(
                                  lessonId: lessonId,
                                  score:
                                      progressController
                                          .generalLessonScores[lessonId] ??
                                      '0/0',
                                );
                                setState(() {}); // Refresh lock status
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
                      "Lesson $lessonNumber",
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
