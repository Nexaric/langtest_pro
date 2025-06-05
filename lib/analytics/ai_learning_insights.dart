import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AiLearningInsights extends StatelessWidget {
  final String suggestion;

  const AiLearningInsights({super.key, required this.suggestion});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              "AI Learning Insights",
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              suggestion,
              style: GoogleFonts.poppins(fontSize: 16, color: Colors.black87),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Icon(Icons.lightbulb, color: Colors.yellow[700], size: 40),
          ],
        ),
      ),
    );
  }
}
