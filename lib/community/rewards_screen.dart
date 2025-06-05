import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RewardsScreen extends StatelessWidget {
  final List<Map<String, String>> rewards = [
    {"title": "7-Day Learning Streak", "badge": "🔥"},
    {"title": "Completed 5 Mock Tests", "badge": "🏆"},
  ];

  RewardsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "My Rewards",
          style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF6A5AE0),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: rewards.length,
        itemBuilder: (context, index) {
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 5,
            child: ListTile(
              title: Text(
                rewards[index]['title']!,
                style: GoogleFonts.poppins(fontSize: 18),
              ),
              trailing: Text(
                rewards[index]['badge']!,
                style: const TextStyle(fontSize: 24),
              ),
            ),
          );
        },
      ),
    );
  }
}
