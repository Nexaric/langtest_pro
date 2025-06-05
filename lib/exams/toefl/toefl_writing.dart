import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';

class ToeflWritingScreen extends StatelessWidget {
  const ToeflWritingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          "TOEFL Writing",
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
                colors: [Color(0xFF4A90E2), Color(0xFF007AFF)],
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

                // Writing Task Sections
                _buildSectionCard(
                  context,
                  "📝 Integrated Writing Task",
                  "Summarize a reading and listening passage.",
                  Colors.orange,
                ),
                _buildSectionCard(
                  context,
                  "✍ Independent Writing Task",
                  "Write an essay on a given topic.",
                  Colors.green,
                ),
                _buildSectionCard(
                  context,
                  "📊 AI Writing Feedback",
                  "Get AI-based grammar and coherence analysis.",
                  Colors.blueAccent,
                ),
                _buildSectionCard(
                  context,
                  "⏱ Timed Writing Practice",
                  "Simulate real TOEFL exam conditions with timers.",
                  Colors.purple,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Header Section with Modern Look
  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0D47A1), Color(0xFF1976D2)],
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
          Icon(Icons.edit_note, size: 60, color: Colors.white),
          const SizedBox(height: 10),
          Text(
            "Master Your Writing Skills! ✍",
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 5),
          Text(
            "Practice with AI, enhance coherence, and prepare for TOEFL.",
            style: GoogleFonts.poppins(fontSize: 14, color: Colors.white70),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // Interactive Section Cards for Writing Practice
  Widget _buildSectionCard(
    BuildContext context,
    String title,
    String subtitle,
    Color color,
  ) {
    return SlideInLeft(
      duration: const Duration(milliseconds: 500),
      child: GestureDetector(
        onTap: () {
          // Add Navigation Logic (Example: Navigate to Writing Task Screen)
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
