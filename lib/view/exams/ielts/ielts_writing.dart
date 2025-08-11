import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import 'package:langtest_pro/view/exams/ielts/writing/lessons/lesson_list_screen.dart';
import 'package:langtest_pro/view/exams/ielts/writing/letters/letter_list_screen.dart';
import 'package:langtest_pro/view/exams/ielts/writing/feedback.dart';
import 'package:langtest_pro/view/exams/ielts/writing/strategies_tips.dart';

class IeltsWritingScreen extends StatelessWidget {
  const IeltsWritingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: _buildAppBar(context),
      body: _buildBackground(
        SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FadeInDown(child: _buildHeader()),
                const SizedBox(height: 28),
                _buildSectionTitle("Explore Writing Modules"),
                const SizedBox(height: 12),
                _buildFeatureGrid(context),
                const SizedBox(height: 28),
              ],
            ),
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text(
        "IELTS Writing",
        style: GoogleFonts.poppins(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      leading: Navigator.canPop(context)
          ? IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 20,
                color: Colors.white,
              ),
              onPressed: () => Navigator.pop(context),
            )
          : null,
    );
  }

  Widget _buildBackground(Widget child) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF3E1E68), Color.fromARGB(255, 84, 65, 228)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: [0.1, 0.9],
        ),
      ),
      child: child,
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Colors.white.withOpacity(0.9),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    // Static progress value for UI demo
    final progress = 0.65; // 65%

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 100,
                height: 100,
                child: CircularProgressIndicator(
                  value: progress.clamp(0.0, 1.0),
                  strokeWidth: 8,
                  backgroundColor: Colors.white.withOpacity(0.2),
                  color: Colors.white,
                ),
              ),
              Column(
                children: [
                  Text(
                    "${(progress * 100).toStringAsFixed(0)}%",
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    "Complete",
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            "Master IELTS Writing",
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Practice makes perfect! Complete lessons and track your progress.",
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.white.withOpacity(0.8),
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureGrid(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 0.85,
      children: [
        _buildAnimatedCard(
          delay: Duration.zero,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const LessonListScreen()),
          ),
          icon: Icons.school_rounded,
          title: "Lessons",
          color: Colors.blue.shade200,
          description: "Structured learning path",
        ),
        _buildAnimatedCard(
          delay: const Duration(milliseconds: 50),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const LetterListScreen()),
          ),
          icon: Icons.mail_rounded,
          title: "Letters",
          color: Colors.green.shade200,
          description: "Formal & informal practice",
        ),
        _buildAnimatedCard(
          delay: const Duration(milliseconds: 100),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const FeedbackScreen()),
          ),
          icon: Icons.feedback_rounded,
          title: "Feedback",
          color: Colors.orange.shade200,
          description: "Get expert evaluation",
        ),
        _buildAnimatedCard(
          delay: const Duration(milliseconds: 150),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const StrategiesTipsScreen()),
          ),
          icon: Icons.lightbulb_rounded,
          title: "Tips",
          color: Colors.purple.shade200,
          description: "Expert strategies",
        ),
      ],
    );
  }

  Widget _buildAnimatedCard({
    required Duration delay,
    required VoidCallback onTap,
    required IconData icon,
    required String title,
    required Color color,
    required String description,
  }) {
    return FadeInUp(
      delay: delay,
      child: GestureDetector(
        onTap: onTap,
        child: _buildFeatureCard(icon, title, color, description),
      ),
    );
  }

  Widget _buildFeatureCard(
    IconData icon,
    String title,
    Color iconColor,
    String description,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.15)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 28, color: iconColor),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Text(
              description,
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: Colors.white.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
