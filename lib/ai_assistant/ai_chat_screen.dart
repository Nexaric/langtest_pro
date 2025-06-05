import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AiChatScreen extends StatelessWidget {
  const AiChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("AI Chat", style: GoogleFonts.poppins())),
      body: Center(
        child: Text(
          "AI Chatbot Coming Soon!",
          style: GoogleFonts.poppins(fontSize: 18),
        ),
      ),
    );
  }
}
