import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          "About Us",
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF3E1E68), Color.fromARGB(255, 84, 65, 228)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: FadeInDown(
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: const AssetImage("assets/logo.png"),
                      backgroundColor: Colors.white24,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                FadeInUp(
                  child: Text(
                    "Welcome to LangTest Pro!",
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 12),
                FadeInUp(
                  delay: const Duration(milliseconds: 300),
                  child: Text(
                    "LangTest Pro is your AI-powered companion for mastering IELTS, OET, PTE, and TOEFL exams with tools like AI-driven speaking evaluations, writing feedback, and interactive lessons.",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 24),
                FadeInLeft(
                  child: Text(
                    "🚀 Our Mission",
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                FadeInLeft(
                  delay: const Duration(milliseconds: 400),
                  child: Text(
                    "Empowering students globally with AI-driven learning to achieve top scores in English proficiency exams.",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                FadeInRight(
                  child: Text(
                    "✨ Key Features",
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                FadeInRight(
                  delay: const Duration(milliseconds: 400),
                  child: _buildBulletPoint("AI-Powered Exam Preparation"),
                ),
                FadeInRight(
                  delay: const Duration(milliseconds: 500),
                  child: _buildBulletPoint(
                    "Interactive Speaking & Writing Evaluations",
                  ),
                ),
                FadeInRight(
                  delay: const Duration(milliseconds: 600),
                  child: _buildBulletPoint("Personalized Learning Paths"),
                ),
                FadeInRight(
                  delay: const Duration(milliseconds: 700),
                  child: _buildBulletPoint(
                    "Mock Tests & Performance Analytics",
                  ),
                ),
                const SizedBox(height: 24),
                FadeInLeft(
                  child: Text(
                    "📞 Contact Us",
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                FadeInLeft(
                  delay: const Duration(milliseconds: 400),
                  child: Text(
                    "For support, reach out at:\n📧 support@langtestpro.com\n🌐 www.langtestpro.com",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 12, top: 8),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: Colors.white70, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.poppins(fontSize: 16, color: Colors.white70),
            ),
          ),
        ],
      ),
    );
  }
}
