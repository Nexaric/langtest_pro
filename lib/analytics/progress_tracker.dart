import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProgressTracker extends StatelessWidget {
  final double listeningProgress;
  final double readingProgress;
  final double writingProgress;
  final double speakingProgress;

  const ProgressTracker({
    super.key,
    required this.listeningProgress,
    required this.readingProgress,
    required this.writingProgress,
    required this.speakingProgress,
  });

  Widget _buildProgressCard(String title, double progress, Color color) {
    return Column(
      children: [
        CircularProgressIndicator(
          value: progress,
          strokeWidth: 8,
          backgroundColor: Colors.grey[300],
          valueColor: AlwaysStoppedAnimation<Color>(color),
        ),
        const SizedBox(height: 10),
        Text(
          "$title: ${(progress * 100).toStringAsFixed(1)}%",
          style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

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
              "Skill Progress Overview",
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildProgressCard("Listening", listeningProgress, Colors.blue),
                _buildProgressCard("Reading", readingProgress, Colors.green),
                _buildProgressCard("Writing", writingProgress, Colors.orange),
                _buildProgressCard("Speaking", speakingProgress, Colors.purple),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
