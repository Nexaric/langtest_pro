import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DiscussionForum extends StatelessWidget {
  final List<Map<String, String>> posts = [
    {"title": "How to improve IELTS Speaking?", "author": "User123"},
    {"title": "Best strategies for OET Reading?", "author": "Nurse_Expert"},
  ];

  DiscussionForum({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Discussion Forum",
          style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF6A5AE0),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: posts.length,
        itemBuilder: (context, index) {
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 5,
            child: ListTile(
              title: Text(
                posts[index]['title']!,
                style: GoogleFonts.poppins(fontSize: 18),
              ),
              subtitle: Text(
                "Posted by ${posts[index]['author']}",
                style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey),
              ),
              trailing: const Icon(Icons.arrow_forward_ios, size: 18),
              onTap: () {},
            ),
          );
        },
      ),
    );
  }
}
