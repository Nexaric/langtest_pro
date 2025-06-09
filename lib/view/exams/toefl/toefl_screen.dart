import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:animate_do/animate_do.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'toefl_listening.dart';
import 'toefl_reading.dart';
import 'toefl_writing.dart';
import 'toefl_speaking.dart';

class ToeflScreen extends StatelessWidget {
  const ToeflScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          "TOEFL Preparation",
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
                colors: [Color(0xFF6A1B9A), Color(0xFF8E24AA)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
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

                // Skill Progress Overview (Animated FadeInDown)
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
                          "📊 Skill Progress Overview",
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
                            _buildProgressCircle("Listening", 0.78),
                            _buildProgressCircle("Reading", 0.65),
                            _buildProgressCircle("Writing", 0.54),
                            _buildProgressCircle("Speaking", 0.80),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // TOEFL Modules Section (Glassmorphic Effect + ZoomIn Animation)
                ZoomIn(
                  duration: const Duration(milliseconds: 800),
                  child: GlassmorphicContainer(
                    width: double.infinity,
                    borderRadius: 20,
                    blur: 25,
                    alignment: Alignment.center,
                    border: 2,
                    linearGradient: LinearGradient(
                      colors: [
                        Colors.white.withOpacity(0.2),
                        Colors.white.withOpacity(0.05),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderGradient: LinearGradient(
                      colors: [
                        Colors.white.withOpacity(0.5),
                        Colors.white.withOpacity(0.1),
                      ],
                    ),
                    height: 500,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FadeInDown(
                            delay: const Duration(milliseconds: 600),
                            child: Text(
                              "📘 TOEFL Modules",
                              style: GoogleFonts.poppins(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          GridView.count(
                            crossAxisCount: 2,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                            children: [
                              // Animated Feature Cards - Smooth Entry Effects
                              FadeInLeft(
                                delay: const Duration(milliseconds: 600),
                                child: _buildModuleCard(
                                  context,
                                  "🎧 Listening",
                                  "University lectures & MCQs",
                                  Colors.blue,
                                  const ToeflListeningScreen(),
                                ),
                              ),
                              FadeInRight(
                                delay: const Duration(milliseconds: 700),
                                child: _buildModuleCard(
                                  context,
                                  "📖 Reading",
                                  "Academic comprehension tests",
                                  Colors.green,
                                  const ToeflReadingScreen(),
                                ),
                              ),
                              FadeInLeft(
                                delay: const Duration(milliseconds: 800),
                                child: _buildModuleCard(
                                  context,
                                  "✍ Writing",
                                  "Integrated & independent tasks",
                                  Colors.orange,
                                  const ToeflWritingScreen(),
                                ),
                              ),
                              FadeInRight(
                                delay: const Duration(milliseconds: 900),
                                child: _buildModuleCard(
                                  context,
                                  "🗣 Speaking",
                                  "Task-based AI evaluation",
                                  Colors.purple,
                                  const ToeflSpeakingScreen(),
                                ),
                              ),
                            ],
                          ),
                        ],
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

  // Skill Progress Overview (Circular Progress Indicators)
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

  // Modern Animated Module Cards
  Widget _buildModuleCard(
    BuildContext context,
    String title,
    String subtitle,
    Color color,
    Widget screen,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => screen),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.95),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(color: Colors.black12, blurRadius: 8, spreadRadius: 2),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle, size: 40, color: color),
            const SizedBox(height: 10),
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(fontSize: 14, color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}
