import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/widgets/progress_bar.dart';
import '../../controller/listening_progress_provider.dart';
import '../../controller/reading_progress_provider.dart';
import '../../controller/writing_progress_provider.dart';
import '../../controller/speaking_progress_provider.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final listeningProgress = Provider.of<ListeningProgressProvider>(context);
    final readingProgress = Provider.of<ReadingProgressProvider>(context);
    final writingProgress = Provider.of<WritingProgressProvider>(context);
    final speakingProgress = Provider.of<SpeakingProgressProvider>(context);

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
                      _buildSkillProgress(
                        listeningProgress: listeningProgress,
                        readingProgress: readingProgress,
                        writingProgress: writingProgress,
                        speakingProgress: speakingProgress,
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
    required ListeningProgressProvider listeningProgress,
    required ReadingProgressProvider readingProgress,
    required WritingProgressProvider writingProgress,
    required SpeakingProgressProvider speakingProgress,
  }) {
    final completedReadingLessons =
        readingProgress.completedAcademicLessons +
        readingProgress.completedGeneralLessons;
    final totalReadingLessons =
        ReadingProgressProvider.totalAcademicLessons +
        ReadingProgressProvider.totalGeneralLessons;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: ProgressCard(
            title: "Listening",
            completed: listeningProgress.completedLessons,
            total: ListeningProgressProvider.totalLessons,
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
            total: WritingProgressProvider.totalLessons,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: ProgressCard(
            title: "Speaking",
            completed: speakingProgress.completedLessons,
            total: SpeakingProgressProvider.totalLessons,
          ),
        ),
      ],
    );
  }
}
