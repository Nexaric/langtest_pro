import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProgressCard extends StatelessWidget {
  final String title;
  final int completed;
  final int total;

  const ProgressCard({
    super.key,
    required this.title,
    required this.completed,
    required this.total,
  });

  double get progress => total > 0 ? completed / total : 0;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey.shade300,
              color: Colors.blueAccent,
              minHeight: 6,
            ),
            const SizedBox(height: 4),
            Text(
              "$completed/$total (${(progress * 100).toStringAsFixed(0)}%)",
              style: GoogleFonts.poppins(fontSize: 14, color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}
