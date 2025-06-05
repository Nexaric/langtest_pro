import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AiWritingFeedback extends StatefulWidget {
  const AiWritingFeedback({super.key});

  @override
  _AiWritingFeedbackState createState() => _AiWritingFeedbackState();
}

class _AiWritingFeedbackState extends State<AiWritingFeedback> {
  final TextEditingController _controller = TextEditingController();
  String _feedback = "";

  void _analyzeWriting() {
    setState(() {
      _feedback =
          "Your writing is well-structured but needs minor grammar improvements.";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("AI Writing Feedback", style: GoogleFonts.poppins()),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              maxLines: 6,
              decoration: InputDecoration(
                hintText: "Write your essay here...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _analyzeWriting,
              child: Text("Analyze Writing"),
            ),
            const SizedBox(height: 20),
            Text(
              _feedback,
              style: GoogleFonts.poppins(fontSize: 16, color: Colors.green),
            ),
          ],
        ),
      ),
    );
  }
}
