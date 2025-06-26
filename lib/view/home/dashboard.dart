import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:langtest_pro/controller/listening_controller.dart';
import 'package:langtest_pro/controller/reading_progress_provider.dart';
import 'package:langtest_pro/controller/speaking_progress_provider.dart';
import 'package:langtest_pro/controller/writing_progress_provider.dart';
import '../../core/widgets/progress_bar.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final listeningProgress = Get.find<ListeningProgressController>();
    final readingProgress = Get.find<ReadingProgressController>();
    final writingProgress = Get.find<WritingProgressController>();
    final speakingProgress = Get.find<SpeakingProgressController>();

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF3E1E68), Color.fromARGB(255, 84, 65, 228)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              AppBar(
                backgroundColor: Colors.transparent,
                title: Text(
                  "Dashboard",
                  style: GoogleFonts.poppins(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                centerTitle: true,
                elevation: 0,
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Skill Progress",
                        style: GoogleFonts.poppins(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Obx(
                        () => _buildSkillProgress(
                          listeningProgress: listeningProgress,
                          readingProgress: readingProgress,
                          writingProgress: writingProgress,
                          speakingProgress: speakingProgress,
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
  }

  Widget _buildSkillProgress({
    required ListeningProgressController listeningProgress,
    required ReadingProgressController readingProgress,
    required WritingProgressController writingProgress,
    required SpeakingProgressController speakingProgress,
  }) {
    final completedReadingLessons =
        readingProgress.completedAcademicLessons +
        readingProgress.completedGeneralLessons;
    final totalReadingLessons =
        ReadingProgressController.totalAcademicLessons +
        ReadingProgressController.totalGeneralLessons;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: ProgressCard(
            title: "Listening",
            completed:
                (listeningProgress.lessonProgressPercentage /
                        100 *
                        ListeningProgressController.totalLessons)
                    .round(),
            total: ListeningProgressController.totalLessons,
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: ProgressCard(
            title: "Reading",
            completed: completedReadingLessons,
            total: totalReadingLessons,
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: ProgressCard(
            title: "Writing",
            completed:
                (writingProgress.progress *
                        WritingProgressController.totalLessons)
                    .round(),
            total: WritingProgressController.totalLessons,
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: ProgressCard(
            title: "Speaking",
            completed:
                (speakingProgress.progress *
                        SpeakingProgressController.totalLessons)
                    .round(),
            total: SpeakingProgressController.totalLessons,
          ),
        ),
      ],
    );
  }
}
