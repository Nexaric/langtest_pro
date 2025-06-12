import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import 'package:get/get.dart';
import 'package:langtest_pro/controller/reading_progress_provider.dart';
import 'package:langtest_pro/view/exams/ielts/reading/general/general_lessons.dart';
import 'package:langtest_pro/view/exams/ielts/reading/academic/academic_lessons.dart';
import 'package:langtest_pro/view/exams/ielts/reading/feedback.dart';
import 'package:langtest_pro/view/exams/ielts/reading/strategies_tips.dart';

class IeltsReadingScreen extends StatelessWidget {
  const IeltsReadingScreen({super.key, required sectionData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          "IELTS Reading",
          style: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading:
            Navigator.canPop(context)
                ? IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    size: 20,
                    color: Colors.white,
                  ),
                  onPressed: () => Navigator.pop(context),
                )
                : null,
      ),
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
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FadeInDown(child: _buildHeader(context)),
                const SizedBox(height: 28),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    "Explore Reading Modules",
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 0.85,
                  children: [
                    FadeInUp(
                      child: GestureDetector(
                        onTap:
                            () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => const AcademicLessonsScreen(),
                              ),
                            ),
                        child: _buildFeatureCard(
                          Icons.book_rounded,
                          "Academic Reading",
                          Colors.blue.shade200,
                          "Practice with real IELTS passages",
                        ),
                      ),
                    ),
                    FadeInUp(
                      delay: const Duration(milliseconds: 50),
                      child: GestureDetector(
                        onTap:
                            () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => const GeneralLessonsScreen(),
                              ),
                            ),
                        child: _buildFeatureCard(
                          Icons.description_rounded,
                          "General Training",
                          Colors.green.shade200,
                          "Structured comprehension exercises",
                        ),
                      ),
                    ),
                    FadeInUp(
                      delay: const Duration(milliseconds: 100),
                      child: GestureDetector(
                        onTap:
                            () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const FeedbackScreen(),
                              ),
                            ),
                        child: _buildFeatureCard(
                          Icons.feedback_rounded,
                          "Feedback",
                          Colors.orange.shade200,
                          "Get expert evaluation",
                        ),
                      ),
                    ),
                    FadeInUp(
                      delay: const Duration(milliseconds: 150),
                      child: GestureDetector(
                        onTap:
                            () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => StrategiesTipsScreen(),
                              ),
                            ),
                        child: _buildFeatureCard(
                          Icons.lightbulb_rounded,
                          "Tips",
                          Colors.purple.shade200,
                          "Expert reading strategies",
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 28),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final progressController = Get.find<ReadingProgressController>();
    const totalLessons = 54; // 40 Academic + 14 General

    return Obx(() {
      final progress =
          (progressController.completedAcademicLessons +
              progressController.completedGeneralLessons) /
          totalLessons;

      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.12),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withOpacity(0.2)),
        ),
        child: Column(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 100,
                  height: 100,
                  child: CircularProgressIndicator(
                    value: progress.clamp(0.0, 1.0),
                    strokeWidth: 8,
                    backgroundColor: Colors.white.withOpacity(0.2),
                    color: Colors.white,
                  ),
                ),
                Column(
                  children: [
                    Text(
                      "${(progress * 100).toStringAsFixed(0)}%",
                      style: GoogleFonts.poppins(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      "Complete",
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              "Master IELTS Reading",
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Practice makes perfect! Complete lessons and track your progress.",
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.white.withOpacity(0.8),
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    });
  }

  Widget _buildFeatureCard(
    IconData icon,
    String title,
    Color iconColor,
    String description,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.15)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 28, color: iconColor),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Text(
              description,
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: Colors.white.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
