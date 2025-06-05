import 'package:speech_to_text/speech_to_text.dart' as stt;

class SpeechToTextService {
  final stt.SpeechToText _speech = stt.SpeechToText();

  // Initialize Speech-to-Text
  Future<bool> initialize() async {
    return await _speech.initialize();
  }

  // Start Listening
  Future<void> startListening(Function(String) onResult) async {
    await _speech.listen(
      onResult: (result) {
        onResult(result.recognizedWords);
      },
    );
  }

  // Stop Listening
  Future<void> stopListening() async {
    await _speech.stop();
  }
}
