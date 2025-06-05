import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';

class PteListeningScreen extends StatelessWidget {
  const PteListeningScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          "PTE Listening",
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

                // Listening Practice Sections
                _buildSectionCard(
                  context,
                  "🎧 Summarize Spoken Text",
                  "Listen to a recording and summarize it in your own words.",
                  Colors.blueAccent,
                ),
                _buildSectionCard(
                  context,
                  "📝 Fill in the Blanks",
                  "Complete the transcript by filling in the missing words.",
                  Colors.deepPurple,
                ),
                _buildSectionCard(
                  context,
                  "🎯 Highlight Correct Summary",
                  "Choose the best summary for the given audio.",
                  Colors.orange,
                ),
                _buildSectionCard(
                  context,
                  "❓ Multiple Choice Questions",
                  "Answer MCQs based on the listening task.",
                  Colors.redAccent,
                ),

                const SizedBox(height: 20),

                // Listening Player
                FadeInUp(child: _buildListeningPlayer()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Header Section with a Modern Look
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
          Icon(Icons.headphones, size: 60, color: Colors.white),
          const SizedBox(height: 10),
          Text(
            "Boost Your PTE Listening Skills! 🎧",
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 5),
          Text(
            "Improve comprehension and answer questions accurately.",
            style: GoogleFonts.poppins(fontSize: 14, color: Colors.white70),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // Interactive Section Cards for Listening Practice
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
          // Add Navigation Logic (Example: Navigate to Listening Task Screen)
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

  // Listening Player UI
  Widget _buildListeningPlayer() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 8, spreadRadius: 2),
        ],
      ),
      child: Column(
        children: [
          Text(
            "🔊 Listening Practice Player",
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.replay_10, size: 30, color: Colors.blue),
                onPressed: () {
                  // Rewind 10 seconds logic
                },
              ),
              IconButton(
                icon: const Icon(
                  Icons.play_circle_fill,
                  size: 50,
                  color: Colors.green,
                ),
                onPressed: () {
                  // Play audio logic
                },
              ),
              IconButton(
                icon: const Icon(
                  Icons.forward_10,
                  size: 30,
                  color: Colors.blue,
                ),
                onPressed: () {
                  // Forward 10 seconds logic
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
