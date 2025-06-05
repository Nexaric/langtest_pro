import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';

class OetReadingScreen extends StatelessWidget {
  const OetReadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          "OET Reading",
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
                colors: [Color(0xFF1565C0), Color(0xFF42A5F5)],
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

                // Reading Sections (Modern Cards)
                _buildSectionCard(
                  context,
                  "📖 Part A: Rapid Information Retrieval",
                  "Read and extract key information from short texts.",
                  Colors.blue,
                ),
                _buildSectionCard(
                  context,
                  "📖 Part B: Workplace Comprehension",
                  "Understand short texts from healthcare workplaces.",
                  Colors.orange,
                ),
                _buildSectionCard(
                  context,
                  "📖 Part C: Academic Texts",
                  "Analyze longer texts with multiple viewpoints.",
                  Colors.green,
                ),

                const SizedBox(height: 20),

                // AI Reading Practice Button
                FadeInUp(
                  child: Center(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // Future AI Reading Analysis Logic
                      },
                      icon: const Icon(Icons.menu_book, color: Colors.white),
                      label: Text(
                        "Start AI Reading Practice",
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
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
          colors: [Color(0xFF1565C0), Color(0xFF42A5F5)],
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
          Icon(Icons.menu_book, size: 60, color: Colors.white),
          const SizedBox(height: 10),
          Text(
            "Enhance Your OET Reading Skills!",
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 5),
          Text(
            "Practice structured reading exercises designed for OET success.",
            style: GoogleFonts.poppins(fontSize: 14, color: Colors.white70),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // Modern Section Layout with Interactive Cards
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
          // Add Navigation Logic (Example: Navigate to Reading Practice Screen)
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
