import 'dart:convert';
import 'package:http/http.dart' as http;

class AiApiService {
  final String apiKey = "YOUR_OPENAI_OR_DIALOGFLOW_API_KEY";

  // Chatbot AI Response
  Future<String> fetchChatResponse(String userMessage) async {
    final url = Uri.parse("https://api.openai.com/v1/chat/completions");
    final response = await http.post(
      url,
      headers: {
        "Authorization": "Bearer $apiKey",
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "model": "gpt-4",
        "messages": [
          {"role": "user", "content": userMessage},
        ],
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data["choices"][0]["message"]["content"].trim();
    } else {
      return "Error fetching AI response.";
    }
  }

  // AI Text-to-Speech (TTS)
  Future<String> fetchTextToSpeech(String text) async {
    final url = Uri.parse("https://api.openai.com/v1/text-to-speech");
    final response = await http.post(
      url,
      headers: {
        "Authorization": "Bearer $apiKey",
        "Content-Type": "application/json",
      },
      body: jsonEncode({"text": text, "voice": "en-US-Wavenet-D"}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data["audioUrl"]; // This URL can be used to play AI-generated speech.
    } else {
      return "Error generating speech.";
    }
  }
}
