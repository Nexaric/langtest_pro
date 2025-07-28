import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';

class FeedbackScreen extends StatelessWidget {
  const FeedbackScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock data
    const lessonProgress = 32;
    const testProgress = 2;
    const totalProgress = 0.68; // 68%
    const totalLessons = 50;
    const totalTests = 4;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF3E1E68), Color.fromARGB(255, 84, 65, 228)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.0, 1.0],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // App Bar Section
                  Row(
                    children: [
                      ElasticInLeft(
                        child: IconButton(
                          icon: const Icon(
                            Icons.arrow_back_ios_new_rounded,
                            size: 20,
                            color: Colors.white,
                          ),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                      Expanded(
                        child: BounceInDown(
                          child: Text(
                            "Listening Progress",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              fontSize: 22,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 40), // Balance for back button
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Header
                  FadeInDown(
                    from: 30,
                    duration: const Duration(milliseconds: 800),
                    child: Text(
                      "Your Listening Path",
                      style: GoogleFonts.poppins(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Overall Progress Card
                  ElasticIn(
                    duration: const Duration(milliseconds: 1000),
                    child: Container(
                      width: double.infinity,
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
                              "Overall Progress",
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
                                width: 150,
                                height: 150,
                                child: CircularProgressIndicator(
                                  value: totalProgress.clamp(0.0, 1.0),
                                  strokeWidth: 12,
                                  backgroundColor: Colors.white.withOpacity(0.2),
                                  color: Colors.amberAccent,
                                ),
                              ),
                              BounceIn(
                                duration: const Duration(milliseconds: 1500),
                                child: Column(
                                  children: [
                                    Text(
                                      "${(totalProgress * 100).toStringAsFixed(0)}%",
                                      style: GoogleFonts.poppins(
                                        fontSize: 32,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Text(
                                      "${lessonProgress + testProgress} / ${totalLessons + totalTests}",
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

                  // Progress Breakdown
                  FadeInUp(
                    delay: const Duration(milliseconds: 100),
                    duration: const Duration(milliseconds: 800),
                    child: Row(
                      children: [
                        Expanded(
                          child: _buildProgressCard(
                            "Lessons",
                            "$lessonProgress / $totalLessons",
                            Colors.blueAccent,
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: _buildProgressCard(
                            "Tests",
                            "$testProgress / $totalTests",
                            Colors.greenAccent,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Feedback Section
                  FlipInX(
                    delay: const Duration(milliseconds: 200),
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
                                  "Your Feedback",
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
                              _getFeedbackMessage(lessonProgress, testProgress),
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                color: Colors.white.withOpacity(0.9),
                                height: 1.6,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Motivational Quote
                  FadeInUp(
                    delay: const Duration(milliseconds: 400),
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
                          JelloIn(
                            child: const Icon(
                              Icons.auto_awesome_rounded,
                              color: Colors.amber,
                              size: 36,
                            ),
                          ),
                          const SizedBox(height: 15),
                          Text(
                            "Tune your ears, conquer the test!",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                              fontStyle: FontStyle.italic,
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
        ),
      ),
    );
  }

  Widget _buildProgressCard(
    String title,
    String progress,
    Color color,
  ) {
    return ElasticIn(
      duration: const Duration(milliseconds: 800),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withOpacity(0.3)),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.1),
              blurRadius: 10,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Column(
          children: [
            SlideInLeft(
              child: Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
            ),
            const SizedBox(height: 10),
            BounceIn(
              delay: const Duration(milliseconds: 300),
              child: Text(
                progress,
                style: GoogleFonts.poppins(
                  fontSize: 22,
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

  String _getFeedbackMessage(int lessonProgress, int testProgress) {
    if (lessonProgress < 15) {
      return "Great start! Keep practicing audio lessons to sharpen your listening skills.";
    } else if (testProgress < 2) {
      return "You're making progress! Try tackling more practice tests to get exam-ready.";
    } else {
      return "Fantastic work! Stay consistent to master the IELTS Listening section.";
    }
  }
}