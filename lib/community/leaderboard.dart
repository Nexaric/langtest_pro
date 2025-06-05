import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LeaderboardScreen extends StatelessWidget {
  final List<Map<String, dynamic>> users = [
    {"name": "John Doe", "score": 95, "avatar": "assets/images/user1.png"},
    {"name": "Jane Smith", "score": 90, "avatar": "assets/images/user2.png"},
    {"name": "Alex Johnson", "score": 85, "avatar": "assets/images/user3.png"},
  ];

  LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Leaderboard",
          style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF6A5AE0),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: users.length,
        itemBuilder: (context, index) {
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 5,
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: AssetImage(users[index]['avatar']),
              ),
              title: Text(
                users[index]['name'],
                style: GoogleFonts.poppins(fontSize: 18),
              ),
              trailing: Text(
                "Score: ${users[index]['score']}",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
