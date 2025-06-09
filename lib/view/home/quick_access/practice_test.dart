import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:animate_do/animate_do.dart';

class PracticeTestScreen extends StatelessWidget {
  const PracticeTestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          "Practice Tests",
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // Gradient Background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF6A5AE0), Color(0xFF9B78FF)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          // Main Content
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 80),
                // Skill Progress Overview
                FadeInDown(
                  delay: const Duration(milliseconds: 500),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Your Test Progress",
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildProgressCircle("IELTS", 0.72),
                            _buildProgressCircle("OET", 0.63),
                            _buildProgressCircle("PTE", 0.51),
                            _buildProgressCircle("TOEFL", 0.78),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Test Selection Cards
                FadeInUp(
                  delay: const Duration(milliseconds: 600),
                  child: Column(
                    children: [
                      _buildTestCard(
                        context,
                        "📘 IELTS Test",
                        "Simulated IELTS exam with AI scoring",
                        Colors.blue,
                      ),
                      _buildTestCard(
                        context,
                        "🏥 OET Test",
                        "Practice for healthcare English exams",
                        Colors.green,
                      ),
                      _buildTestCard(
                        context,
                        "📖 PTE Test",
                        "Computer-based test with instant feedback",
                        Colors.orange,
                      ),
                      _buildTestCard(
                        context,
                        "🗣 TOEFL Test",
                        "Academic English exam practice",
                        Colors.purple,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Circular Progress Indicator
  Widget _buildProgressCircle(String skill, double progress) {
    return Column(
      children: [
        CircularPercentIndicator(
          radius: 40,
          lineWidth: 8,
          percent: progress,
          center: Text(
            "${(progress * 100).toInt()}%",
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          progressColor: Colors.white,
          backgroundColor: Colors.white.withOpacity(0.3),
          circularStrokeCap: CircularStrokeCap.round,
          animation: true,
        ),
        const SizedBox(height: 5),
        Text(
          skill,
          style: GoogleFonts.poppins(fontSize: 14, color: Colors.white),
        ),
      ],
    );
  }

  // Test Selection Cards
  Widget _buildTestCard(
    BuildContext context,
    String title,
    String subtitle,
    Color color,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const PracticeTestScreen()),
        );
      },
      child: Card(
        color: Colors.white.withOpacity(0.95),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 8,
        margin: const EdgeInsets.symmetric(vertical: 10),
        child: ListTile(
          leading: Icon(Icons.check_circle, size: 40, color: color),
          title: Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          subtitle: Text(
            subtitle,
            style: GoogleFonts.poppins(fontSize: 14, color: Colors.black54),
          ),
          trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey),
        ),
      ),
    );
  }
}
