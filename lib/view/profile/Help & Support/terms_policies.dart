import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TermsPoliciesScreen extends StatelessWidget {
  const TermsPoliciesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "Terms & Policies",
          style: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // Background Gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF6A5AE0), Color(0xFF9B78FF)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const SizedBox(height: 80),

                // Terms & Conditions Box
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSectionTitle("📜 Terms of Service"),
                          _buildBulletPoint(
                            "You must be at least 18 years old or have parental consent.",
                          ),
                          _buildBulletPoint(
                            "Unauthorized access to accounts is strictly prohibited.",
                          ),
                          _buildBulletPoint(
                            "Use of this platform must be in compliance with local laws.",
                          ),
                          const SizedBox(height: 20),

                          _buildSectionTitle("🔒 Privacy Policy"),
                          _buildBulletPoint(
                            "We collect data to improve user experience.",
                          ),
                          _buildBulletPoint(
                            "Your data is securely stored and never sold.",
                          ),
                          _buildBulletPoint(
                            "You can request data deletion at any time.",
                          ),
                          const SizedBox(height: 20),

                          _buildSectionTitle("🚀 User Responsibilities"),
                          _buildBulletPoint(
                            "Do not share your account with others.",
                          ),
                          _buildBulletPoint(
                            "Respect other users and avoid inappropriate content.",
                          ),
                          _buildBulletPoint(
                            "Violating policies may result in account suspension.",
                          ),
                          const SizedBox(height: 20),

                          _buildSectionTitle("⚖ Changes & Updates"),
                          _buildBulletPoint(
                            "We may update these terms occasionally.",
                          ),
                          _buildBulletPoint(
                            "You will be notified of significant changes.",
                          ),
                          _buildBulletPoint(
                            "Continued use means acceptance of new terms.",
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Accept Button
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.greenAccent,
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 40,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    "Accept & Continue",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
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

  // Section Title
  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.poppins(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }

  // Bullet Point Text
  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle, color: Colors.white, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.poppins(fontSize: 14, color: Colors.white70),
            ),
          ),
        ],
      ),
    );
  }
}
