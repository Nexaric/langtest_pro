import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import 'package:langtest_pro/view/exams/ielts/speaking/part1_introduction_interview.dart';
import 'package:langtest_pro/view/exams/ielts/speaking/part2_cue_card.dart';
import 'package:langtest_pro/view/exams/ielts/speaking/part3_discussion.dart';

class IeltsSpeakingScreen extends StatelessWidget {
  const IeltsSpeakingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          "IELTS Speaking",
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

                // Header Section
                FadeInDown(child: _buildHeader()),

                const SizedBox(height: 20),

                // Speaking Sections (Modern Cards)
                _buildSectionCard(
                  context,
                  "🗣 Part 1: Introduction & Interview",
                  "Practice answering common personal questions.",
                  Colors.blue,
                  Part1IntroductionInterviewScreen(), // Navigation to Part 1
                ),
                _buildSectionCard(
                  context,
                  "🎤 Part 2: Cue Card",
                  "Prepare and speak on a given topic within 2 minutes.",
                  Colors.green,
                  Part2CueCardScreen(), // Navigation to Part 2
                ),
                _buildSectionCard(
                  context,
                  "💬 Part 3: Discussion",
                  "Discuss abstract ideas related to Part 2 topic.",
                  Colors.orange,
                  Part3DiscussionScreen(), // Navigation to Part 3
                ),
                const SizedBox(height: 20),

                // AI Speaking Practice Button
                FadeInUp(
                  child: Center(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // TODO: Navigate to AI Speaking Practice
                      },
                      icon: const Icon(Icons.mic, color: Colors.white),
                      label: Text(
                        "Start AI Speaking Practice",
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        padding: const EdgeInsets.symmetric(
                          vertical: 14,
                          horizontal: 20,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Header Section with a Gradient Background
  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF1F1C2C), // Deep Indigo
            Color(0xFF928DAB), // Soft Lavender Gray
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 10, spreadRadius: 2),
        ],
      ),
      child: Column(
        children: [
          Icon(Icons.record_voice_over, size: 60, color: Colors.white),
          const SizedBox(height: 10),
          Text(
            "Master IELTS Speaking!",
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 5),
          Text(
            "Improve fluency, coherence, and pronunciation with guided practice.",
            style: GoogleFonts.poppins(fontSize: 14, color: Colors.white70),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // Modern Section Layout with Interactive Buttons
  Widget _buildSectionCard(
    BuildContext context,
    String title,
    String subtitle,
    Color color,
    Widget screen, // Screen to navigate to
  ) {
    return BounceInUp(
      duration: const Duration(milliseconds: 500),
      child: GestureDetector(
        onTap: () {
          // Navigate to the respective screen
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => screen),
          );
        },
        child: Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(vertical: 10),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(color: Colors.black12, blurRadius: 8, spreadRadius: 2),
            ],
          ),
          child: Row(
            children: [
              Icon(Icons.check_circle, size: 40, color: color),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      subtitle,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, color: Colors.black54),
            ],
          ),
        ),
      ),
    );
  }
}
