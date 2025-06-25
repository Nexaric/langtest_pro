import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:langtest_pro/controller/listening/listening_controller.dart';
import 'package:langtest_pro/controller/reading/reading_controller.dart';
import 'package:langtest_pro/controller/speaking_progress_provider.dart';
import 'package:langtest_pro/controller/writing/writing_controller.dart';
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
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                centerTitle: true,
                elevation: 0,
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Skill Progress",
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 10),
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
            completed: listeningProgress.completedLessons,
            total: ListeningProgressController.totalLessons,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: ProgressCard(
            title: "Reading",
            completed: completedReadingLessons,
            total: totalReadingLessons,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: ProgressCard(
            title: "Writing",
            completed: writingProgress.completedLessons,
            total: WritingProgressController.totalLessons,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: ProgressCard(
            title: "Speaking",
            completed: speakingProgress.completedLessons,
            total: SpeakingProgressController.totalLessons,
          ),
        ),
      ],
    );
  }
}
