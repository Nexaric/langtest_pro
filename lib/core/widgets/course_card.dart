import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CourseCard extends StatelessWidget {
  final String title;
  final double progress;
  final bool unlocked;
  final VoidCallback onTap;

  const CourseCard({
    super.key,
    required this.title,
    required this.progress,
    required this.unlocked,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: unlocked ? onTap : null, // 🔹 Navigate only if unlocked
      child: Stack(
        children: [
          Container(
            width: 160,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8,
                  spreadRadius: 2,
                ),
              ],
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: unlocked ? Colors.black : Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text(
                  "${(progress * 100).toStringAsFixed(0)}% Completed",
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: unlocked ? Colors.black : Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          if (!unlocked)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(Icons.lock, size: 40, color: Colors.grey),
              ),
            ),
        ],
      ),
    );
  }
}
