import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DailyChallengesScreen extends StatelessWidget {
  final List<Map<String, String>> challenges = [
    {"title": "Complete a Listening Test", "reward": "10 XP"},
    {"title": "Speak for 2 minutes on a topic", "reward": "15 XP"},
  ];

  DailyChallengesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Daily Challenges",
          style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF6A5AE0),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: challenges.length,
        itemBuilder: (context, index) {
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 5,
            child: ListTile(
              title: Text(
                challenges[index]['title']!,
                style: GoogleFonts.poppins(fontSize: 18),
              ),
              trailing: Text(
                challenges[index]['reward']!,
                style: GoogleFonts.poppins(fontSize: 16, color: Colors.green),
              ),
              onTap: () {},
            ),
          );
        },
      ),
    );
  }
}
