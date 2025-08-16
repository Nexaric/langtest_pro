// lib/view/exams/ielts/listening/strategies_tips.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/utils.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../ielts_listening.dart';

class StrategiesTipsScreen extends StatelessWidget {
  static const List<Map<String, dynamic>> strategiesTips = [
    {
      "category": "Note-Taking",
      "color": Color(0xFF6C5CE7),
      "icon": Icons.edit_note_rounded,
      "tips": [
        {
          "title": "Use Abbreviations",
          "description":
              "Use abbreviations and symbols to write faster and capture key points.",
          "icon": Icons.short_text_rounded,
        },
        {
          "title": "Focus on Keywords",
          "description":
              "Listen for keywords and phrases that convey the main ideas.",
          "icon": Icons.key_rounded,
        },
        {
          "title": "Organize Notes by Question Number",
          "description":
              "Align your notes with question numbers to quickly refer back during answers.",
          "icon": Icons.format_list_numbered_rtl_rounded,
        },
        {
          "title": "Use Bullet Points",
          "description":
              "Structure your notes with bullet points to keep them clear and concise.",
          "icon": Icons.format_list_bulleted_rounded,
        },
        {
          "title": "Highlight Repeated Information",
          "description":
              "Mark information that is repeated in the audio, as it's often important.",
          "icon": Icons.repeat_rounded,
        },
      ],
    },
    {
      "category": "Time Management",
      "color": Color(0xFF00B894),
      "icon": Icons.timer_rounded,
      "tips": [
        {
          "title": "Preview Questions",
          "description":
              "Use the time before the audio starts to preview the questions.",
          "icon": Icons.visibility_rounded,
        },
        {
          "title": "Stay Ahead",
          "description":
              "Answer questions as you listen, and don't get stuck on one question.",
          "icon": Icons.fast_forward_rounded,
        },
        {
          "title": "Use Pauses Wisely",
          "description":
              "Utilize pauses between sections to review answers or prepare for the next part.",
          "icon": Icons.pause_circle_filled_rounded,
        },
        {
          "title": "Prioritize Easy Questions",
          "description":
              "Answer straightforward questions first to secure quick points.",
          "icon": Icons.low_priority_rounded,
        },
        {
          "title": "Track Audio Progress",
          "description":
              "Monitor section transitions to stay aligned with question sets.",
          "icon": Icons.timeline_rounded,
        },
      ],
    },
    {
      "category": "Understanding Accents",
      "color": Color(0xFFFD79A8),
      "icon": Icons.language_rounded,
      "tips": [
        {
          "title": "Practice Different Accents",
          "description":
              "Listen to audio materials with different English accents (e.g., British, Australian, American).",
          "icon": Icons.record_voice_over_rounded,
        },
        {
          "title": "Focus on Context",
          "description":
              "Use the context of the conversation to understand unfamiliar accents.",
          "icon": Icons.psychology_rounded,
        },
        {
          "title": "Mimic Native Speakers",
          "description":
              "Practice repeating phrases to get accustomed to different pronunciations.",
          "icon": Icons.mic_rounded,
        },
        {
          "title": "Watch Subtitled Media",
          "description":
              "Use English media with subtitles to connect accents with written words.",
          "icon": Icons.subtitles_rounded,
        },
        {
          "title": "Learn Common Phonetic Patterns",
          "description":
              "Study typical sound patterns in different accents to anticipate variations.",
          "icon": Icons.graphic_eq_rounded,
        },
      ],
    },
    {
      "category": "Question Types",
      "color": Color(0xFFFDCB6E),
      "icon": Icons.help_center_rounded,
      "tips": [
        {
          "title": "Predict Answers",
          "description":
              "Anticipate possible answers based on question types (e.g., multiple choice, gap-fill).",
          "icon": Icons.psychology_outlined,
        },
        {
          "title": "Identify Distractors",
          "description":
              "Be aware of misleading information designed to confuse you.",
          "icon": Icons.warning_rounded,
        },
        {
          "title": "Understand Question Formats",
          "description":
              "Familiarize yourself with formats like matching, labeling, or sentence completion.",
          "icon": Icons.format_align_left_rounded,
        },
        {
          "title": "Check Answer Limits",
          "description":
              "Pay attention to word or number limits for gap-fill answers.",
          "icon": Icons.format_size_rounded,
        },
      ],
    },
    {
      "category": "Concentration",
      "color": Color(0xFF0984E3),
      "icon": Icons.self_improvement_rounded,
      "tips": [
        {
          "title": "Eliminate Distractions",
          "description":
              "Practice in a quiet environment to improve focus during the test.",
          "icon": Icons.noise_aware_rounded,
        },
        {
          "title": "Practice Active Listening",
          "description":
              "Engage with the audio by summarizing key points mentally.",
          "icon": Icons.hearing_rounded,
        },
        {
          "title": "Use Breathing Techniques",
          "description":
              "Apply simple breathing exercises to stay calm and focused.",
          "icon": Icons.air_rounded,
        },
        {
          "title": "Take Practice Tests",
          "description":
              "Simulate test conditions to build stamina and concentration.",
          "icon": Icons.assignment_rounded,
        },
      ],
    },
  ];

  const StrategiesTipsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return Scaffold(
          extendBodyBehindAppBar: true,
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF3E1E68), Color.fromARGB(255, 84, 65, 228)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [0.1, 0.9],
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  AppBar(
                    title: Text(
                      "Listening Strategies & Tips",
                      style: GoogleFonts.poppins(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    centerTitle: true,
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    leading: IconButton(
                      icon: Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: Colors.white,
                        size: 20.sp,
                      ),
                      onPressed: () {
                       Get.back();
                      },
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: EdgeInsets.all(16.w),
                      child: Column(
                        children: [
                          FadeIn(
                            duration: const Duration(milliseconds: 500),
                            child: Container(
                              width: double.infinity,
                              padding: EdgeInsets.all(20.w),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Color(0xFF6C5CE7).withOpacity(0.8),
                                    Color(0xFF6C5CE7).withOpacity(0.8),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(16.r),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 10.r,
                                    offset: Offset(0, 4.h),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Master IELTS Listening",
                                    style: GoogleFonts.poppins(
                                      fontSize: 22.sp,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(height: 8.h),
                                  Text(
                                    "Proven strategies to boost your listening score. Practice these tips to improve your performance.",
                                    style: GoogleFonts.poppins(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.white.withOpacity(0.9),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 24.h),
                          AnimationLimiter(
                            child: ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: strategiesTips.length,
                              itemBuilder: (context, index) {
                                final category = strategiesTips[index];
                                return AnimationConfiguration.staggeredList(
                                  position: index,
                                  duration: const Duration(milliseconds: 500),
                                  child: SlideAnimation(
                                    verticalOffset: 50.0,
                                    child: FadeInAnimation(
                                      child: _buildCategoryCard(category),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCategoryCard(Map<String, dynamic> category) {
    return Container(
      margin: EdgeInsets.only(bottom: 20.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10.r,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        child: ExpansionTile(
          tilePadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
          leading: Icon(
            category['icon'],
            color: category['color'],
            size: 24.sp,
          ),
          title: Text(
            category['category'],
            style: GoogleFonts.poppins(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          children: List.generate(category['tips'].length, (tipIndex) {
            final tip = category['tips'][tipIndex];
            return ListTile(
              leading: Icon(tip['icon'], color: category['color'], size: 20.sp),
              title: Text(
                tip['title'],
                style: GoogleFonts.poppins(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              subtitle: Text(
                tip['description'],
                style: GoogleFonts.poppins(fontSize: 13.sp),
              ),
            );
          }),
        ),
      ),
    );
  }
}
