import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';

class OetListeningScreen extends StatelessWidget {
  const OetListeningScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          "OET Listening",
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
                colors: [Color(0xFF00897B), Color(0xFF00ACC1)],
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

                // Listening Sections (Modern Cards)
                _buildSectionCard(
                  context,
                  "🎧 Part A: Consultation Extracts",
                  "Listen to patient-doctor interactions and complete notes.",
                  Colors.blue,
                ),
                _buildSectionCard(
                  context,
                  "🎧 Part B: Short Workplace Extracts",
                  "Understand conversations between healthcare professionals.",
                  Colors.orange,
                ),
                _buildSectionCard(
                  context,
                  "🎧 Part C: Presentation Extracts",
                  "Interpret healthcare lectures or interviews.",
                  Colors.purple,
                ),

                const SizedBox(height: 20),

                // AI Listening Practice Button
                FadeInUp(
                  child: Center(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // Future AI Listening Practice Logic
                      },
                      icon: const Icon(Icons.headset_mic, color: Colors.white),
                      label: Text(
                        "AI Listening Practice",
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
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
          colors: [Color(0xFF00897B), Color(0xFF00ACC1)],
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
          Icon(Icons.hearing, size: 60, color: Colors.white),
          const SizedBox(height: 10),
          Text(
            "Boost Your OET Listening Skills!",
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 5),
          Text(
            "Practice real OET listening scenarios with structured guidance.",
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
  ) {
    return BounceInUp(
      duration: const Duration(milliseconds: 500),
      child: GestureDetector(
        onTap: () {
          // Add Navigation Logic (Example: Navigate to Listening Practice Screen)
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
