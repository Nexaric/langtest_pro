import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:animate_do/animate_do.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';

import 'package:langtest_pro/exams/ielts/listening/listening_progress_provider.dart';
import 'package:langtest_pro/exams/ielts/reading/reading_progress_provider.dart';
import 'package:langtest_pro/exams/ielts/speaking/speaking_progress_provider.dart';
import 'package:langtest_pro/exams/ielts/writing/writing_progress_provider.dart';

import 'ielts_listening.dart';
import 'ielts_reading.dart';
import 'ielts_writing.dart';
import 'ielts_speaking.dart';

class IeltsScreen extends StatelessWidget {
  const IeltsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          "IELTS Preparation",
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
                colors: [Color(0xFF3E1E68), Color(0xFF6A5AE0)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          // Content Scroll View
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Column(
                children: [
                  // Skill Progress Overview
                  FadeInDown(
                    delay: const Duration(milliseconds: 300),
                    child: _buildProgressOverview(context),
                  ),
                  const SizedBox(height: 30),

                  // IELTS Modules Grid
                  ZoomIn(
                    duration: const Duration(milliseconds: 600),
                    child: _buildModulesGrid(context, size),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressOverview(BuildContext context) {
    return Consumer4<
      ListeningProgressProvider,
      ReadingProgressProvider,
      WritingProgressProvider,
      SpeakingProgressProvider
    >(
      builder: (context, listening, reading, writing, speaking, _) {
        return GlassmorphicContainer(
          width: double.infinity,
          height: 200,
          borderRadius: 20,
          blur: 20,
          alignment: Alignment.center,
          linearGradient: LinearGradient(
            colors: [
              Colors.white.withOpacity(0.1),
              Colors.white.withOpacity(0.05),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: 1,
          borderGradient: LinearGradient(
            colors: [
              Colors.white.withOpacity(0.4),
              Colors.white.withOpacity(0.1),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                  "📊 Skill Progress",
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildProgressCircle("Listening", listening.progress),
                    _buildProgressCircle("Reading", reading.progress),
                    _buildProgressCircle("Writing", writing.progress),
                    _buildProgressCircle("Speaking", speaking.progress),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildProgressCircle(String skill, double progress) {
    return Column(
      children: [
        CircularPercentIndicator(
          radius: 35,
          lineWidth: 6,
          percent: progress,
          animation: true,
          circularStrokeCap: CircularStrokeCap.round,
          center: Text(
            "${(progress * 100).toInt()}%",
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          progressColor: Colors.white,
          backgroundColor: Colors.white24,
        ),
        const SizedBox(height: 4),
        Text(
          skill,
          style: GoogleFonts.poppins(color: Colors.white, fontSize: 13),
        ),
      ],
    );
  }

  Widget _buildModulesGrid(BuildContext context, Size size) {
    final isTablet = size.width > 600;

    return GlassmorphicContainer(
      width: double.infinity,
      height: isTablet ? 550 : 450,
      borderRadius: 20,
      blur: 20,
      alignment: Alignment.center,
      linearGradient: LinearGradient(
        colors: [
          Colors.white.withOpacity(0.15),
          Colors.white.withOpacity(0.05),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      border: 1,
      borderGradient: LinearGradient(
        colors: [Colors.white.withOpacity(0.3), Colors.white.withOpacity(0.1)],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              "📚 IELTS Modules",
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 30),
            Expanded(
              child: GridView.count(
                crossAxisCount: isTablet ? 3 : 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                children: [
                  _buildModuleCard(
                    context,
                    "🎧 Listening",
                    "Practice exercises",
                    Colors.blue,
                    const IeltsListeningScreen(),
                  ),
                  _buildModuleCard(
                    context,
                    "📖 Reading",
                    "Comprehension practice",
                    Colors.green,
                    const IeltsReadingScreen(),
                  ),
                  _buildModuleCard(
                    context,
                    "✍ Writing",
                    "Practice tasks",
                    Colors.orange,
                    const IeltsWritingScreen(),
                  ),
                  _buildModuleCard(
                    context,
                    "🗣 Speaking",
                    "Fluency practice",
                    Colors.purple,
                    const IeltsSpeakingScreen(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModuleCard(
    BuildContext context,
    String title,
    String subtitle,
    Color color,
    Widget screen,
  ) {
    return GestureDetector(
      onTap:
          () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => screen),
          ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.92),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(color: Colors.black12, blurRadius: 6, spreadRadius: 2),
          ],
        ),
        padding: const EdgeInsets.all(14),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.school_rounded, color: color, size: 40),
            const SizedBox(height: 10),
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            Text(
              subtitle,
              style: GoogleFonts.poppins(fontSize: 13, color: Colors.black54),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
