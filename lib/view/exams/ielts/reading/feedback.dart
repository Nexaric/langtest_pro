import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FeedbackScreen extends StatelessWidget {
  const FeedbackScreen({super.key});

  Widget _buildProgressCard(
    String label,
    String value,
    Color color,
    BuildContext context,
  ) {
    final isSmallScreen = MediaQuery.of(context).size.width < 400;

    return ElasticIn(
      duration: const Duration(milliseconds: 800),
      child: Container(
        padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withOpacity(0.3)),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.2),
              blurRadius: 10,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SlideInLeft(
              child: Text(
                label,
                style: GoogleFonts.poppins(
                  fontSize: isSmallScreen ? 14 : 16,
                  color: Colors.white.withOpacity(0.9),
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 8),
            BounceIn(
              delay: const Duration(milliseconds: 300),
              child: Text(
                value,
                style: GoogleFonts.poppins(
                  fontSize: isSmallScreen ? 18 : 20,
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

  @override
  Widget build(BuildContext context) {
    // Mock data
    const totalLessons = 54;
    final academicProgress = 12;
    final generalProgress = 5;
    final totalProgress = academicProgress + generalProgress;
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 400;
    final isMediumScreen = size.width < 600;

    return Scaffold(
      body: Container(
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF3E1E66), Color(0xFF5441E4)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isSmallScreen ? 12 : 20,
              vertical: isSmallScreen ? 12 : 20,
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                          size: 20,
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                      Expanded(
                        child: Text(
                          'Progress & Feedback',
                          style: GoogleFonts.poppins(
                            fontSize: isSmallScreen ? 18 : 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(width: 48),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Main Progress Card
                  ElasticIn(
                    child: Container(
                      width: double.infinity, // Takes full width
                      padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
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
                              'Overall Progress',
                              style: GoogleFonts.poppins(
                                fontSize: isSmallScreen ? 18 : 20,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          LayoutBuilder(
                            builder: (context, constraints) {
                              // Calculate size based on available width while maintaining aspect ratio
                              final progressSize = constraints.maxWidth * 0.6;
                              return SizedBox(
                                width: progressSize,
                                height: progressSize,
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    CircularProgressIndicator(
                                      value: totalProgress / totalLessons,
                                      strokeWidth: isSmallScreen ? 100 : 170,
                                      backgroundColor: Colors.white.withOpacity(
                                        0.2,
                                      ),
                                      valueColor:
                                          const AlwaysStoppedAnimation<Color>(
                                            Colors.greenAccent,
                                          ),
                                    ),
                                    BounceIn(
                                      duration: const Duration(
                                        milliseconds: 1500,
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            '${((totalProgress / totalLessons) * 100).toStringAsFixed(0)}%',
                                            style: GoogleFonts.poppins(
                                              fontSize:
                                                  progressSize *
                                                  0.15, // Responsive font size
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            '$totalProgress / $totalLessons',
                                            style: GoogleFonts.poppins(
                                              fontSize:
                                                  progressSize *
                                                  0.07, // Responsive font size
                                              color: Colors.white.withOpacity(
                                                0.8,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: isSmallScreen ? 20 : 30),

                  // Progress Cards Row
                  FadeInUp(
                    delay: const Duration(milliseconds: 100),
                    duration: const Duration(milliseconds: 800),
                    child:
                        isMediumScreen
                            ? Row(
                              children: [
                                _buildProgressCard(
                                  'Academic Reading',
                                  '$academicProgress / 40',
                                  Colors.blueAccent,
                                  context,
                                ),
                                Spacer(),
                                const SizedBox(height: 15),
                                _buildProgressCard(
                                  'General Training',
                                  '$generalProgress / 14',
                                  Colors.greenAccent,
                                  context,
                                ),
                              ],
                            )
                            : Row(
                              children: [
                                Expanded(
                                  child: _buildProgressCard(
                                    'Academic Reading',
                                    '$academicProgress / 40',
                                    Colors.blueAccent,
                                    context,
                                  ),
                                ),
                                const SizedBox(width: 15),
                                Expanded(
                                  child: _buildProgressCard(
                                    'General Training',
                                    '$generalProgress / 14',
                                    Colors.greenAccent,
                                    context,
                                  ),
                                ),
                              ],
                            ),
                  ),
                  SizedBox(height: isSmallScreen ? 20 : 30),

                  // Motivation Card
                  FadeInUp(
                    delay: const Duration(milliseconds: 300),
                    duration: const Duration(milliseconds: 800),
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                        ),
                      ),
                      child: Column(
                        children: [
                          SlideInRight(
                            child: Text(
                              'Keep Going!',
                              style: GoogleFonts.poppins(
                                fontSize: isSmallScreen ? 18 : 20,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            '"Success is the sum of small efforts, repeated day in and day out."',
                            style: GoogleFonts.poppins(
                              fontSize: isSmallScreen ? 14 : 16,
                              fontStyle: FontStyle.italic,
                              color: Colors.white.withOpacity(0.9),
                            ),
                            textAlign: TextAlign.center,
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
}
