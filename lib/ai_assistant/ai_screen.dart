import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'ai_chat_screen.dart';
import 'ai_voice_assist.dart';
import 'ai_writing_feedback.dart';

class AiScreen extends StatelessWidget {
  const AiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "AI Assistant",
          style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF6A5AE0),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildAiOption(
              context,
              "AI Chat",
              Icons.chat,
              const AiChatScreen(),
            ),
            _buildAiOption(
              context,
              "Voice Assistant",
              Icons.mic,
              const AiVoiceAssist(),
            ),
            _buildAiOption(
              context,
              "Writing Feedback",
              Icons.edit,
              const AiWritingFeedback(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAiOption(
    BuildContext context,
    String title,
    IconData icon,
    Widget screen,
  ) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 5,
      child: ListTile(
        leading: Icon(icon, size: 30, color: const Color(0xFF6A5AE0)),
        title: Text(
          title,
          style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 18),
        onTap:
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => screen),
            ),
      ),
    );
  }
}
