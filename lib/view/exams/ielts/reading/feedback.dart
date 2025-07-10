import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:langtest_pro/controller/reading_controller.dart';
import 'package:langtest_pro/view/exams/ielts/reading/general/general_lessons.dart';

class FeedbackScreen extends StatelessWidget {
  const FeedbackScreen({super.key});

  Widget _buildProgressCard(String label, String value, Color color) {
    return ElasticIn(
      duration: const Duration(milliseconds: 800),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withOpacity(0.3)),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.2),
              blurRadius: 10,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Column(
          children: [
            SlideInLeft(
              child: Text(
                label,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
            ),
            const SizedBox(height: 8),
            BounceIn(
              delay: const Duration(milliseconds: 300),
              child: Text(
                value,
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final progressController = Get.find<ReadingController>();
    const totalLessons = 54; // 40 Academic + 14 General
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF3E1E66), Color(0xFF5441E4)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Obx(() {
              if (progressController.isLoading) {
                return const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                );
              }

              if (progressController.hasError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        progressController.errorMessage,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () async {
                          await progressController.refreshProgress();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF00BFA6),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 16,
                          ),
                        ),
                        child: Text(
                          'Retry',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }

              final academicProgress =
                  progressController.completedAcademicLessons;
              final generalProgress =
                  progressController.completedGeneralLessons;
              final totalProgress = academicProgress + generalProgress;
              final overallPercentage =
                  totalLessons > 0 ? (totalProgress / totalLessons) * 100 : 0.0;

              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.arrow_back_ios,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            try {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => const GeneralLessonsScreen(),
                                ),
                              );
                            } catch (e) {
                              Get.snackbar(
                                'Error',
                                'Failed to navigate back: $e',
                                backgroundColor: Colors.red,
                                colorText: Colors.white,
                              );
                            }
                          },
                        ),
                        Expanded(
                          child: Text(
                            'Progress & Feedback',
                            style: GoogleFonts.poppins(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.refresh, color: Colors.white),
                          onPressed: () async {
                            try {
                              await progressController.refreshProgress();
                            } catch (e) {
                              Get.snackbar(
                                'Error',
                                'Failed to refresh progress: $e',
                                backgroundColor: Colors.red,
                                colorText: Colors.white,
                              );
                            }
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    ElasticIn(
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.3),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 20,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            SlideInLeft(
                              child: Text(
                                'Overall Progress',
                                style: GoogleFonts.poppins(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                SizedBox(
                                  width: size.width * 0.4,
                                  height: size.width * 0.4,
                                  child: CircularProgressIndicator(
                                    value: overallPercentage / 100,
                                    strokeWidth: 12,
                                    backgroundColor: Colors.white.withOpacity(
                                      0.2,
                                    ),
                                    valueColor:
                                        const AlwaysStoppedAnimation<Color>(
                                          Color(0xFF00BFA6),
                                        ),
                                  ),
                                ),
                                BounceIn(
                                  duration: const Duration(milliseconds: 1500),
                                  child: Column(
                                    children: [
                                      Text(
                                        '${overallPercentage.toStringAsFixed(0)}%',
                                        style: GoogleFonts.poppins(
                                          fontSize: 32,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Text(
                                        '$totalProgress / $totalLessons',
                                        style: GoogleFonts.poppins(
                                          fontSize: 16,
                                          color: Colors.white.withOpacity(0.8),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    FadeInUp(
                      delay: const Duration(milliseconds: 100),
                      duration: const Duration(milliseconds: 800),
                      child: Row(
                        children: [
                          Expanded(
                            child: _buildProgressCard(
                              'Academic Reading',
                              '$academicProgress / 40',
                              Colors.blueAccent,
                            ),
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: _buildProgressCard(
                              'General Training',
                              '$generalProgress / 14',
                              Colors.greenAccent,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    FlipInX(
                      delay: const Duration(milliseconds: 200),
                      duration: const Duration(milliseconds: 800),
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.3),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 15,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                ElasticIn(
                                  child: Icon(
                                    Icons.feedback_rounded,
                                    color: Colors.orange.shade200,
                                    size: 28,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                SlideInRight(
                                  child: Text(
                                    'Recent Feedback',
                                    style: GoogleFonts.poppins(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 15),
                            FadeIn(
                              delay: const Duration(milliseconds: 300),
                              child: Text(
                                _getFeedbackMessage(
                                  academicProgress,
                                  generalProgress,
                                ),
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  color: Colors.white.withOpacity(0.9),
                                  height: 1.6,
                                ),
                              ),
                            ),
                            const SizedBox(height: 15),
                            Text(
                              'Recent Academic Scores',
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                            if (progressController.academicLessonScores.isEmpty)
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 4,
                                ),
                                child: Text(
                                  'No scores available yet.',
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    color: Colors.white.withOpacity(0.8),
                                  ),
                                ),
                              )
                            else
                              ...progressController.academicLessonScores.entries
                                  .take(5)
                                  .map(
                                    (entry) => Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 4,
                                      ),
                                      child: Text(
                                        'Lesson ${entry.key}: ${entry.value}',
                                        style: GoogleFonts.poppins(
                                          fontSize: 14,
                                          color: Colors.white.withOpacity(0.8),
                                        ),
                                      ),
                                    ),
                                  ),
                            const SizedBox(height: 15),
                            Text(
                              'Recent General Training Scores',
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                            if (progressController.generalLessonScores.isEmpty)
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 4,
                                ),
                                child: Text(
                                  'No scores available yet.',
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    color: Colors.white.withOpacity(0.8),
                                  ),
                                ),
                              )
                            else
                              ...progressController.generalLessonScores.entries
                                  .take(5)
                                  .map(
                                    (entry) => Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 4,
                                      ),
                                      child: Text(
                                        'Lesson ${entry.key}: ${entry.value}',
                                        style: GoogleFonts.poppins(
                                          fontSize: 14,
                                          color: Colors.white.withOpacity(0.8),
                                        ),
                                      ),
                                    ),
                                  ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    FadeInUp(
                      delay: const Duration(milliseconds: 300),
                      duration: const Duration(milliseconds: 800),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.3),
                          ),
                        ),
                        child: Column(
                          children: [
                            SlideInRight(
                              child: Text(
                                'Keep Going!',
                                style: GoogleFonts.poppins(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              '"Success is the sum of small efforts, repeated day in and day out."',
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontStyle: FontStyle.italic,
                                color: Colors.white.withOpacity(0.9),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ),
      ),
    );
  }

  String _getFeedbackMessage(int academicProgress, int generalProgress) {
    if (academicProgress < 0 || generalProgress < 0) {
      return 'Error: Invalid progress data. Please refresh.';
    }
    if (academicProgress < 10 && generalProgress < 5) {
      return 'Focus on completing more lessons to get detailed feedback.';
    } else if (generalProgress < 5) {
      return 'Great start on Academic Reading! Try completing more General Training lessons.';
    } else if (academicProgress < 10) {
      return 'Good work on General Training! Complete more Academic Reading lessons to balance your progress.';
    } else {
      return 'Excellent progress! Keep practicing to maintain your high performance.';
    }
  }
}
