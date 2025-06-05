import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';

class Part3DiscussionScreen extends StatelessWidget {
  final List<Map<String, dynamic>> tasks = [
    {
      "title": "Task 1: Discuss Education",
      "description": "Talk about the importance of education in society.",
      "completed": true,
      "score": 8.5,
    },
    {
      "title": "Task 2: Discuss Technology",
      "description": "Discuss the impact of technology on daily life.",
      "completed": false,
      "score": null,
    },
    {
      "title": "Task 3: Discuss Environment",
      "description": "Talk about environmental issues and solutions.",
      "completed": false,
      "score": null,
    },
  ];

  Part3DiscussionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Part 3: Discussion",
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF6A5AE0),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        color: Colors.grey[50],
        padding: const EdgeInsets.all(16),
        child: ListView.builder(
          itemCount: tasks.length,
          itemBuilder: (context, index) {
            final task = tasks[index];
            return FadeInUp(
              delay: Duration(milliseconds: 100 * index),
              child: _buildTaskCard(context, task),
            );
          },
        ),
      ),
    );
  }

  Widget _buildTaskCard(BuildContext context, Map<String, dynamic> task) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () {
          // TODO: Navigate to the task screen
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Task Title
              Text(
                task["title"],
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),

              // Task Description
              Text(
                task["description"],
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 12),

              // Progress and Score
              if (task["completed"])
                Row(
                  children: [
                    Icon(Icons.emoji_events, size: 16, color: Colors.amber),
                    const SizedBox(width: 4),
                    Text(
                      "Score: ${task["score"]}",
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.green[600],
                      ),
                    ),
                  ],
                ),
              const SizedBox(height: 12),

              // Start/Retake Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: Navigate to the task screen
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6A5AE0),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    task["completed"] ? "Retake Task" : "Start Task",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
