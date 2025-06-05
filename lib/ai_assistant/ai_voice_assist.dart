import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart';
import 'package:google_fonts/google_fonts.dart';

class AiVoiceAssist extends StatefulWidget {
  const AiVoiceAssist({super.key});

  @override
  _AiVoiceAssistState createState() => _AiVoiceAssistState();
}

class _AiVoiceAssistState extends State<AiVoiceAssist> {
  final stt.SpeechToText _speech = stt.SpeechToText();
  final FlutterTts _tts = FlutterTts();
  bool _isListening = false;
  String _spokenText = "Tap the mic and start speaking";

  void _startListening() async {
    bool available = await _speech.initialize();
    if (available) {
      setState(() => _isListening = true);
      _speech.listen(
        onResult: (result) {
          setState(() => _spokenText = result.recognizedWords);
        },
      );
    }
  }

  void _stopListening() async {
    setState(() => _isListening = false);
    _speech.stop();
  }

  void _speakText() async {
    await _tts.speak(_spokenText);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("AI Voice Assistant", style: GoogleFonts.poppins()),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _spokenText,
              style: GoogleFonts.poppins(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _isListening ? _stopListening : _startListening,
              icon: Icon(_isListening ? Icons.mic_off : Icons.mic),
              label: Text(_isListening ? "Stop" : "Speak"),
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: _speakText,
              icon: const Icon(Icons.volume_up),
              label: const Text("Hear Response"),
            ),
          ],
        ),
      ),
    );
  }
}
