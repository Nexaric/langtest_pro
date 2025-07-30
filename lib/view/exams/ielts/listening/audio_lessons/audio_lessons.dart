import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import 'package:langtest_pro/controller/listening/listening_controller.dart';
import 'package:langtest_pro/model/progress_model.dart';
import 'package:langtest_pro/utils/utils.dart';

class AudioLessonsScreen extends StatefulWidget {
  const AudioLessonsScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AudioLessonsScreenState createState() => _AudioLessonsScreenState();
}

class _AudioLessonsScreenState extends State<AudioLessonsScreen> {
  final Color _gradientStart = const Color(0xFF3E1E68);
  final Color _gradientEnd = const Color.fromARGB(255, 84, 65, 228);
  final Color _accentColor = const Color(0xFF00BFA6);
  final Color _textLight = const Color.fromARGB(255, 255, 255, 255);
  final Color _lockedColor = const Color(0xFFA5A6C4);
  final Color _unlockedStart = const Color(0xFF6D28D9);
  final Color _unlockedEnd = const Color(0xFF9333EA);
  final progressController = Get.put(ListeningController());

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
      "isIntroduction": true,
    },
    // Section 1: Everyday Conversations (Lessons 2-10)
    {
      "title": "Lesson 2: Booking a Hotel Room",
      "progress": 0.0,
      "isLocked": false,
      "lessonId": 2,
      "isIntroduction": false,
    },
    {
      "title": "Lesson 3: Renting an Apartment",
      "progress": 0.0,
      "isLocked": true,
      "lessonId": 3,
      "isIntroduction": false,
    },
    {
      "title": "Lesson 4: Ordering Food at a Restaurant",
      "progress": 0.0,
      "isLocked": true,
      "lessonId": 4,
      "isIntroduction": false,
    },
    {
      "title": "Lesson 5: Making Travel Arrangements",
      "progress": 0.0,
      "isLocked": true,
      "lessonId": 5,
      "isIntroduction": false,
    },
    {
      "title": "Lesson 6: Joining a Gym",
      "progress": 0.0,
      "isLocked": true,
      "lessonId": 6,
      "isIntroduction": false,
    },
    {
      "title": "Lesson 7: Shopping for Clothes",
      "progress": 0.0,
      "isLocked": true,
      "lessonId": 7,
      "isIntroduction": false,
    },
    {
      "title": "Lesson 8: Reporting a Problem to Customer Service",
      "progress": 0.0,
      "isLocked": true,
      "lessonId": 8,
      "isIntroduction": false,
    },
    {
      "title": "Lesson 9: Planning a Social Event",
      "progress": 0.0,
      "isLocked": true,
      "lessonId": 9,
      "isIntroduction": false,
    },
    {
      "title": "Lesson 10: Asking for Directions",
      "progress": 0.0,
      "isLocked": true,
      "lessonId": 10,
      "isIntroduction": false,
    },
    {
      "title": "Lesson 11: A University Campus Tour",
      "progress": 0.0,
      "isLocked": true,
      "lessonId": 11,
      "isIntroduction": false,
    },
    {
      "title": "Lesson 12: A Museum Guide",
      "progress": 0.0,
      "isLocked": true,
      "lessonId": 12,
      "isIntroduction": false,
    },
    {
      "title": "Lesson 13: A Public Transport Announcement",
      "progress": 0.0,
      "isLocked": true,
      "lessonId": 13,
      "isIntroduction": false,
    },
    {
      "title": "Lesson 14: A Weather Forecast",
      "progress": 0.0,
      "isLocked": true,
      "lessonId": 14,
      "isIntroduction": false,
    },
    {
      "title": "Lesson 15: A Job Interview Overview",
      "progress": 0.0,
      "isLocked": true,
      "lessonId": 15,
      "isIntroduction": false,
    },
    {
      "title": "Lesson 16: A Library Orientation",
      "progress": 0.0,
      "isLocked": true,
      "lessonId": 16,
      "isIntroduction": false,
    },
    {
      "title": "Lesson 17: A Health and Safety Briefing",
      "progress": 0.0,
      "isLocked": true,
      "lessonId": 17,
      "isIntroduction": false,
    },
    {
      "title": "Lesson 18: A Local Festival Announcement",
      "progress": 0.0,
      "isLocked": true,
      "lessonId": 18,
      "isIntroduction": false,
    },
    {
      "title": "Lesson 19: A Radio Advertisement",
      "progress": 0.0,
      "isLocked": true,
      "lessonId": 19,
      "isIntroduction": false,
    },
    {
      "title": "Lesson 20: A Community Event Speech",
      "progress": 0.0,
      "isLocked": true,
      "lessonId": 20,
      "isIntroduction": false,
    },
    {
      "title": "Lesson 21: Discussing a Group Assignment",
      "progress": 0.0,
      "isLocked": true,
      "lessonId": 21,
      "isIntroduction": false,
    },
    {
      "title": "Lesson 22: A Lecture on Environmental Science",
      "progress": 0.0,
      "isLocked": true,
      "lessonId": 22,
      "isIntroduction": false,
    },
    {
      "title": "Lesson 23: A Tutorial on History",
      "progress": 0.0,
      "isLocked": true,
      "lessonId": 23,
      "isIntroduction": false,
    },
    {
      "title": "Lesson 24: A Debate on Technology",
      "progress": 0.0,
      "isLocked": true,
      "lessonId": 24,
      "isIntroduction": false,
    },
    {
      "title": "Lesson 25: A Presentation on Business Strategies",
      "progress": 0.0,
      "isLocked": true,
      "lessonId": 25,
      "isIntroduction": false,
    },
    {
      "title": "Lesson 26: A Conversation About Research Methods",
      "progress": 0.0,
      "isLocked": true,
      "lessonId": 26,
      "isIntroduction": false,
    },
    {
      "title": "Lesson 27: A Discussion on Literature",
      "progress": 0.0,
      "isLocked": true,
      "lessonId": 27,
      "isIntroduction": false,
    },
    {
      "title": "Lesson 28: A Seminar on Psychology",
      "progress": 0.0,
      "isLocked": true,
      "lessonId": 28,
      "isIntroduction": false,
    },
    {
      "title": "Lesson 29: A Talk on Global Economics",
      "progress": 0.0,
      "isLocked": true,
      "lessonId": 29,
      "isIntroduction": false,
    },
    {
      "title": "Lesson 30: A Workshop on Creative Writing",
      "progress": 0.0,
      "isLocked": true,
      "lessonId": 30,
      "isIntroduction": false,
    },
    {
      "title": "Lesson 31: A Lecture on Climate Change",
      "progress": 0.0,
      "isLocked": true,
      "lessonId": 31,
      "isIntroduction": false,
    },
    {
      "title": "Lesson 32: A Talk on Space Exploration",
      "progress": 0.0,
      "isLocked": true,
      "lessonId": 32,
      "isIntroduction": false,
    },
    {
      "title": "Lesson 33: A Presentation on Ancient Civilizations",
      "progress": 0.0,
      "isLocked": true,
      "lessonId": 33,
      "isIntroduction": false,
    },
    {
      "title": "Lesson 34: A Speech on Renewable Energy",
      "progress": 0.0,
      "isLocked": true,
      "lessonId": 34,
      "isIntroduction": false,
    },
    {
      "title": "Lesson 35: A Discussion on Artificial Intelligence",
      "progress": 0.0,
      "isLocked": true,
      "lessonId": 35,
      "isIntroduction": false,
    },
    {
      "title": "Lesson 36: A Lecture on Marine Biology",
      "progress": 0.0,
      "isLocked": true,
      "lessonId": 36,
      "isIntroduction": false,
    },
    {
      "title": "Lesson 37: A Talk on Urban Planning",
      "progress": 0.0,
      "isLocked": true,
      "lessonId": 37,
      "isIntroduction": false,
    },
    {
      "title": "Lesson 38: A Presentation on Cultural Diversity",
      "progress": 0.0,
      "isLocked": true,
      "lessonId": 38,
      "isIntroduction": false,
    },
    {
      "title": "Lesson 39: A Lecture on Medical Advancements",
      "progress": 0.0,
      "isLocked": true,
      "lessonId": 39,
      "isIntroduction": false,
    },
    {
      "title": "Lesson 40: A Discussion on Education Systems",
      "progress": 0.0,
      "isLocked": true,
      "lessonId": 40,
      "isIntroduction": false,
    },
    {
      "title": "Lesson 41: Multiple Choice Questions Practice",
      "progress": 0.0,
      "isLocked": true,
      "lessonId": 41,
      "isIntroduction": false,
    },
    {
      "title": "Lesson 42: Map and Diagram Labelling Practice",
      "progress": 0.0,
      "isLocked": true,
      "lessonId": 42,
      "isIntroduction": false,
    },
    {
      "title": "Lesson 43: Form and Note Completion Practice",
      "progress": 0.0,
      "isLocked": true,
      "lessonId": 43,
      "isIntroduction": false,
    },
    {
      "title": "Lesson 44: Sentence Completion Practice",
      "progress": 0.0,
      "isLocked": true,
      "lessonId": 44,
      "isIntroduction": false,
    },
    {
      "title": "Lesson 45: Matching Information Practice",
      "progress": 0.0,
      "isLocked": true,
      "lessonId": 45,
      "isIntroduction": false,
    },
    {
      "title": "Lesson 46: Short Answer Questions Practice",
      "progress": 0.0,
      "isLocked": true,
      "lessonId": 46,
      "isIntroduction": false,
    },
    {
      "title": "Lesson 47: Summary Completion Practice",
      "progress": 0.0,
      "isLocked": true,
      "lessonId": 47,
      "isIntroduction": false,
    },
    {
      "title": "Lesson 48: True/False/Not Given Practice",
      "progress": 0.0,
      "isLocked": true,
      "lessonId": 48,
      "isIntroduction": false,
    },
    {
      "title": "Lesson 49: Mixed Question Types Practice",
      "progress": 0.0,
      "isLocked": true,
      "lessonId": 49,
      "isIntroduction": false,
    },
    {
      "title": "Lesson 50: Full-Length Mock Listening Test",
      "progress": 0.0,
      "isLocked": true,
      "lessonId": 50,
      "isIntroduction": false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              title: InkWell(
                onDoubleTap: () {},
                child: Text(
                  "IELTS Listening Lessons",
                  style: GoogleFonts.poppins(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w600,
                    color: _textLight,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              centerTitle: true,
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.white, size: 24.sp),
                onPressed: () {
                  Get.back();
                },
              ),
              pinned: true,
              floating: false,
              snap: false,
              expandedHeight: 0,
              toolbarHeight: kToolbarHeight,
            ),
            SliverPadding(padding: EdgeInsets.only(top: 10.h)),
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate((context, sectionIndex) {
                  final section = _sections[sectionIndex];
                  final startIndex = int.parse(section["start"].toString()) - 1;
                  final endIndex = int.parse(section["end"].toString()) - 1;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 10.h),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              section["title"],
                              style: GoogleFonts.poppins(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.bold,
                                color: _textLight,
                              ),
                            ),
                            Text(
                              section["description"],
                              style: GoogleFonts.poppins(
                                fontSize: 14.sp,
                                color: _textLight.withOpacity(0.7),
                              ),
                            ),
                          ],
                        ),
                      ),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 20.w,
                          mainAxisSpacing: 20.h,
                          childAspectRatio: 0.85,
                        ),
                        itemCount: endIndex - startIndex + 1,
                        itemBuilder: (context, index) {
                          final lessonIndex = startIndex + index;
                          final lesson = audioLessons[lessonIndex];
                          final isLocked = lesson["isLocked"] as bool;
                          final progress = lesson["progress"] as double;
                          final isIntroduction =
                              lesson["isIntroduction"] as bool;

                          return FadeInUp(
                            delay: Duration(milliseconds: 100 * index),
                            child: _buildLessonCard(
                              context,
                              lesson: lesson,
                              isLocked:
                                  lesson == 1
                                      ? false
                                      : progressController
                                          .progressList
                                          .value[index]['isLocked'],

                              progress: progress,
                              isIntroduction: isIntroduction,
                            ),
                          );
                        },
                      ),
                      SizedBox(height: 20.h),
                    ],
                  );
                }, childCount: _sections.length),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLessonCard(
    BuildContext context, {
    required Map<String, dynamic> lesson,
    required bool isLocked,
    required double progress,
    required bool isIntroduction,
  }) {
    return Material(
      color: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.r),
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
              blurRadius: 10.r,
              offset: Offset(0, 4.h),
            ),
          ],
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(20.r),
          onTap: () async {
            final uid = await Utils.getString("userId");
            final dataModel = ProgressModel(
              uid: uid!,
              progress: [
                LessonProgress(
                  lesson: lesson["lessonId"],
                  isPassed: false,
                  isLocked: false,
                  progress: 50,
                ),
              ],
            );

            if (context.mounted) {
              progressController.initializeProgress(
                progressModel: dataModel,
                context: context,
              );
            }

            // Get.off(AudioScreen(lesson: lesson, onComplete: (){}));
          },
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isIntroduction
                          ? "Introduction"
                          : "Lesson ${lesson["lessonId"]}",
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: _textLight.withOpacity(0.8),
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      lesson["title"].toString().split(":").length > 1
                          ? lesson["title"].toString().split(":")[1].trim()
                          : lesson["title"].toString(),
                      style: GoogleFonts.poppins(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: _textLight,
                        height: 1.3,
                      ),
                      // maxLines: 2,
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
                      minHeight: 6.h,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      isLocked
                          ? "Complete previous lesson"
                          : progress == 1.0
                          ? isIntroduction
                              ? "Completed 🎧"
                              : "Completed ✅"
                          : "${(progress * 100).toStringAsFixed(0)}% complete",
                      style: GoogleFonts.poppins(
                        fontSize: 12.sp,
                        color: _textLight.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
                Center(
                  child:
                      isLocked
                          ? Container(
                            padding: EdgeInsets.all(10.w),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _textLight.withOpacity(0.1),
                            ),
                            child: Icon(
                              Icons.lock_outline,
                              color: _textLight.withOpacity(0.7),
                              size: 24.sp,
                            ),
                          )
                          : Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 10.h,
                            ),
                            decoration: BoxDecoration(
                              color: _textLight.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(20.r),
                              border: Border.all(
                                color: _textLight.withOpacity(0.3),
                                width: 1.w,
                              ),
                            ),
                            child: Text(
                              "Start Now",
                              style: GoogleFonts.poppins(
                                fontSize: 14.sp,
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
