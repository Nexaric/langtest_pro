import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart';
import 'package:google_fonts/google_fonts.dart';

class AiPronunciationChecker extends StatefulWidget {
  const AiPronunciationChecker({super.key});

  @override
  _AiPronunciationCheckerState createState() => _AiPronunciationCheckerState();
}

class _AiPronunciationCheckerState extends State<AiPronunciationChecker> {
  final stt.SpeechToText _speech = stt.SpeechToText();
  final FlutterTts _tts = FlutterTts();

  bool _isListening = false;
  String _spokenText = "";
  final String _targetSentence = "The quick brown fox jumps over the lazy dog";

  @override
  void initState() {
    super.initState();
    _initSpeech();
  }

  // Initialize Speech Recognition
  void _initSpeech() async {
    bool available = await _speech.initialize();
    if (!available) {
      debugPrint("Speech recognition not available");
    }
  }

  // Start Listening
  void _startListening() async {
    setState(() => _isListening = true);
    await _speech.listen(
      onResult: (result) {
        setState(() {
          _spokenText = result.recognizedWords;
        });
      },
    );
  }

  // Stop Listening
  void _stopListening() async {
    setState(() => _isListening = false);
    await _speech.stop();
  }

  // Text-to-Speech (TTS) - Read the Target Sentence
  void _speakSentence() async {
    await _tts.speak(_targetSentence);
  }

  // AI-Based Pronunciation Analysis (Simple Match %)
  double _calculateAccuracy() {
    if (_spokenText.isEmpty) return 0.0;
    List<String> targetWords = _targetSentence.toLowerCase().split(" ");
    List<String> spokenWords = _spokenText.toLowerCase().split(" ");

    int matchedWords = 0;
    for (var word in spokenWords) {
      if (targetWords.contains(word)) {
        matchedWords++;
      }
    }
    return (matchedWords / targetWords.length) * 100;
  }

  @override
  Widget build(BuildContext context) {
    double accuracy = _calculateAccuracy();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "AI Pronunciation Checker",
          style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF6A5AE0),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Listen & Repeat:",
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),

            // Target Sentence Display
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.deepPurpleAccent.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                _targetSentence,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 20),

            // Speak & Listen Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: _speakSentence,
                  icon: const Icon(Icons.volume_up_rounded),
                  label: Text(
                    "Listen",
                    style: GoogleFonts.poppins(fontSize: 16),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                ),
                const SizedBox(width: 20),
                ElevatedButton.icon(
                  onPressed: _isListening ? _stopListening : _startListening,
                  icon: Icon(_isListening ? Icons.mic_off : Icons.mic),
                  label: Text(
                    _isListening ? "Stop" : "Speak",
                    style: GoogleFonts.poppins(fontSize: 16),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Spoken Text Display
            Text(
              "Your Speech:",
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              _spokenText.isEmpty ? "Press Speak to record" : _spokenText,
              style: GoogleFonts.poppins(fontSize: 16, color: Colors.black54),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),

            // Accuracy Score
            Text(
              "Pronunciation Accuracy: ${accuracy.toStringAsFixed(1)}%",
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: accuracy > 80 ? Colors.green : Colors.red,
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
