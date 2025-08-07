import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import 'package:langtest_pro/controller/reading/reading_controller.dart';
import 'package:langtest_pro/view/exams/ielts/ielts_reading.dart';
import 'package:langtest_pro/view/exams/ielts/reading/academic/lesson_screen.dart';

class AcademicLessonsScreen extends StatefulWidget {
  const AcademicLessonsScreen({super.key});

  @override
  State<AcademicLessonsScreen> createState() => _AcademicLessonsScreenState();
}

class _AcademicLessonsScreenState extends State<AcademicLessonsScreen> {
  final readingProgressController = Get.find<ReadingController>();
  final Color _gradientStart = const Color(0xFF3E1E68);
  final Color _gradientEnd = const Color.fromARGB(255, 84, 65, 228);
  final Color _accentColor = const Color(0xFF00BFA6);
  final Color _textLight = const Color.fromARGB(255, 255, 255, 255);
  final Color _lockedColor = const Color(0xFFA5A6C4);
  final Color _unlockedStart = const Color(0xFF6D28D9);
  final Color _unlockedEnd = const Color(0xFF9333EA);

  final List<Map<String, dynamic>> _sections = [
    {
      "title": "Foundations of Knowledge",
      "start": 1,
      "end": 10,
      "description": "Explore core concepts in history, science, and culture",
    },
    {
      "title": "Environmental and Technological Advances",
      "start": 11,
      "end": 20,
      "description": "Dive into climate, tech, and medical innovations",
    },
    {
      "title": "Human and Social Sciences",
      "start": 21,
      "end": 30,
      "description": "Understand human behavior and society",
    },
    {
      "title": "Future and Beyond",
      "start": 31,
      "end": 40,
      "description": "Look at emerging trends and scientific frontiers",
    },
  ];

  final List<Map<String, dynamic>> lessons = [
    {
      'title': 'Lesson 1: The Origins of Human Language',
      'progress': 0.0,
      'isLocked': false,
      'lessonId': 1,
    },
    {
      'title': 'Lesson 2: The Rise of Urban Farming',
      'progress': 0.0,
      'isLocked': true,
      'lessonId': 2,
    },
    {
      'title': 'Lesson 3: Understanding Ecosystems',
      'progress': 0.0,
      'isLocked': true,
      'lessonId': 3,
    },
    {
      'title': 'Lesson 4: History of the Printing Press',
      'progress': 0.0,
      'isLocked': true,
      'lessonId': 4,
    },
    {
      'title': 'Lesson 5: The Psychology of Color',
      'progress': 0.0,
      'isLocked': true,
      'lessonId': 5,
    },
    {
      'title': 'Lesson 6: The Global Water Crisis',
      'progress': 0.0,
      'isLocked': true,
      'lessonId': 6,
    },
    {
      'title': 'Lesson 7: Space Exploration and Satellites',
      'progress': 0.0,
      'isLocked': true,
      'lessonId': 7,
    },
    {
      'title': 'Lesson 8: Marine Life in Deep Oceans',
      'progress': 0.0,
      'isLocked': true,
      'lessonId': 8,
    },
    {
      'title': 'Lesson 9: Innovations in Agriculture',
      'progress': 0.0,
      'isLocked': true,
      'lessonId': 9,
    },
    {
      'title': 'Lesson 10: The Rise of Artificial Intelligence',
      'progress': 0.0,
      'isLocked': true,
      'lessonId': 10,
    },
    {
      'title': 'Lesson 11: Climate Change and Its Impact',
      'progress': 0.0,
      'isLocked': true,
      'lessonId': 11,
    },
    {
      'title': 'Lesson 12: The Science of Memory',
      'progress': 0.0,
      'isLocked': true,
      'lessonId': 12,
    },
    {
      'title': 'Lesson 13: Ancient Egyptian Engineering',
      'progress': 0.0,
      'isLocked': true,
      'lessonId': 13,
    },
    {
      'title': 'Lesson 14: The Story of Flight',
      'progress': 0.0,
      'isLocked': true,
      'lessonId': 14,
    },
    {
      'title': 'Lesson 15: Ocean Currents and Weather Patterns',
      'progress': 0.0,
      'isLocked': true,
      'lessonId': 15,
    },
    {
      'title': 'Lesson 16: Endangered Languages',
      'progress': 0.0,
      'isLocked': true,
      'lessonId': 16,
    },
    {
      'title': 'Lesson 17: Renewable Energy Sources',
      'progress': 0.0,
      'isLocked': true,
      'lessonId': 17,
    },
    {
      'title': 'Lesson 18: The Internet and Education',
      'progress': 0.0,
      'isLocked': true,
      'lessonId': 18,
    },
    {
      'title': 'Lesson 19: Robotic Surgery',
      'progress': 0.0,
      'isLocked': true,
      'lessonId': 19,
    },
    {
      'title': 'Lesson 20: The Science of Sleep',
      'progress': 0.0,
      'isLocked': true,
      'lessonId': 20,
    },
    {
      'title': 'Lesson 21: History of Timekeeping',
      'progress': 0.0,
      'isLocked': true,
      'lessonId': 21,
    },
    {
      'title': 'Lesson 22: The Human Brain',
      'progress': 0.0,
      'isLocked': true,
      'lessonId': 22,
    },
    {
      'title': 'Lesson 23: Urban Planning and Green Cities',
      'progress': 0.0,
      'isLocked': true,
      'lessonId': 23,
    },
    {
      'title': 'Lesson 24: Plastic Pollution in the Oceans',
      'progress': 0.0,
      'isLocked': true,
      'lessonId': 24,
    },
    {
      'title': 'Lesson 25: The Evolution of Music',
      'progress': 0.0,
      'isLocked': true,
      'lessonId': 25,
    },
    {
      'title': 'Lesson 26: The Industrial Revolution',
      'progress': 0.0,
      'isLocked': true,
      'lessonId': 26,
    },
    {
      'title': 'Lesson 27: The Future of Transportation',
      'progress': 0.0,
      'isLocked': true,
      'lessonId': 27,
    },
    {
      'title': 'Lesson 28: How Volcanoes Work',
      'progress': 0.0,
      'isLocked': true,
      'lessonId': 28,
    },
    {
      'title': 'Lesson 29: The World of Microorganisms',
      'progress': 0.0,
      'isLocked': true,
      'lessonId': 29,
    },
    {
      'title': 'Lesson 30: Space Tourism',
      'progress': 0.0,
      'isLocked': true,
      'lessonId': 30,
    },
    {
      'title': 'Lesson 31: Animal Intelligence',
      'progress': 0.0,
      'isLocked': true,
      'lessonId': 31,
    },
    {
      'title': 'Lesson 32: Renewable vs Non-renewable Energy',
      'progress': 0.0,
      'isLocked': true,
      'lessonId': 32,
    },
    {
      'title': 'Lesson 33: Artificial Photosynthesis',
      'progress': 0.0,
      'isLocked': true,
      'lessonId': 33,
    },
    {
      'title': 'Lesson 34: Climate Migration',
      'progress': 0.0,
      'isLocked': true,
      'lessonId': 34,
    },
    {
      'title': 'Lesson 35: The Structure of DNA',
      'progress': 0.0,
      'isLocked': true,
      'lessonId': 35,
    },
    {
      'title': 'Lesson 36: Historical Trade Routes',
      'progress': 0.0,
      'isLocked': true,
      'lessonId': 36,
    },
    {
      'title': 'Lesson 37: Pollution and Public Health',
      'progress': 0.0,
      'isLocked': true,
      'lessonId': 37,
    },
    {
      'title': 'Lesson 38: The Deep Web',
      'progress': 0.0,
      'isLocked': true,
      'lessonId': 38,
    },
    {
      'title': 'Lesson 39: Architecture of the Future',
      'progress': 0.0,
      'isLocked': true,
      'lessonId': 39,
    },
    {
      'title': 'Lesson 40: Space-Time and Relativity',
      'progress': 0.0,
      'isLocked': true,
      'lessonId': 40,
    },
  ];

  // Mock progress data
  int completedAcademicLessons = 1;
  double currentLessonProgress = 0.3;
  Map<int, String> academicLessonScores = {1: "8/10"};

  @override
  void initState() {
    super.initState();
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
        // Keep your navigation logic exactly as is
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
                  "Academic Reading Lessons",
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: _textLight,
                    letterSpacing: 0.5,
                  ),
                ),
                centerTitle: true,
                backgroundColor: Color(0xFF402175),
                elevation: 0,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    // Keep your navigation logic exactly as is
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
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate((context, sectionIndex) {
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
                        if (section["start"] > 10)
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

                            final lessonAddress = lessons[lessonIndex];

                            return Obx(() {
                              final lesson =
                                  readingProgressController
                                      .progressList[lessonIndex];
                                      // print(object)
                              return FadeInUp(
                                delay: Duration(milliseconds: 100 * index),
                                child: _buildLessonCard(
                                  context,
                                  lessonLocal: lessonAddress,
                                  lessonCloud:  lesson,
                                  lessonIndex: lessonIndex,
                                ),
                              );
                            });
                          },
                        ),

                        const SizedBox(height: 20),
                      ],
                    );
                  }, childCount: _sections.length),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLessonCard(
    BuildContext context, {
    required Map<String, dynamic> lessonLocal,
    required Map<String, dynamic> lessonCloud,
    required int lessonIndex,
  }) {
    final lessonNumber = lessonIndex + 1;
    final isLocked = lessonCloud['isLocked'];
    final progress = lessonCloud['progress']/100;
    final lessonId = lessonLocal['lessonId'] as int?;

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
                    // Keep your navigation logic exactly as is
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => LessonScreen(
                              lessonId: lessonId,
                              onComplete: () {
                                // Mock completion logic
                                setState(() {
                                  if (lessonNumber ==
                                      completedAcademicLessons + 1) {
                                    completedAcademicLessons++;
                                    currentLessonProgress = 0.0;
                                    academicLessonScores[lessonId] = "8/10";
                                  }
                                });
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
                      lessonLocal["title"].toString().split(":").length > 1
                          ? lessonLocal["title"].toString().split(":")[1].trim()
                          : lessonLocal["title"].toString(),
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
