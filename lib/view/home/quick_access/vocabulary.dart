import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flip_card/flip_card.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class VocabularyScreen extends StatefulWidget {
  const VocabularyScreen({super.key});

  @override
  _VocabularyScreenState createState() => _VocabularyScreenState();
}

class _VocabularyScreenState extends State<VocabularyScreen> {
  final List<Map<String, String>> words = [
    {
      "word": "Eloquent",
      "meaning": "Fluent or persuasive in speaking or writing.",
      "example": "She gave an eloquent speech about climate change.",
      "synonym": "Expressive, Persuasive",
      "antonym": "Inarticulate",
    },
    {
      "word": "Tenacious",
      "meaning": "Holding firmly; persistent.",
      "example": "His tenacious spirit helped him succeed.",
      "synonym": "Determined, Resolute",
      "antonym": "Weak-willed",
    },
    {
      "word": "Meticulous",
      "meaning": "Showing great attention to detail.",
      "example": "He is meticulous about keeping his desk clean.",
      "synonym": "Precise, Thorough",
      "antonym": "Careless",
    },
  ];

  int currentWordIndex = 0;

  void nextWord() {
    setState(() {
      currentWordIndex = (currentWordIndex + 1) % words.length;
    });
  }

  void previousWord() {
    setState(() {
      currentWordIndex = (currentWordIndex - 1 + words.length) % words.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    var wordData = words[currentWordIndex];

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          "Vocabulary Booster",
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // Gradient Background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF6A5AE0), Color(0xFF9B78FF)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 80),

                // Skill Progress Overview
                FadeInDown(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        Text(
                          "Vocabulary Mastery",
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 10),
                        CircularPercentIndicator(
                          radius: 50,
                          lineWidth: 8,
                          percent: 0.7, // Example progress
                          center: Text(
                            "70%",
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          progressColor: Colors.white,
                          backgroundColor: Colors.white.withOpacity(0.3),
                          circularStrokeCap: CircularStrokeCap.round,
                          animation: true,
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // Word of the Day
                FlipCard(
                  direction: FlipDirection.HORIZONTAL,
                  front: _buildWordCard(
                    wordData['word']!,
                    "Tap to see meaning",
                  ),
                  back: _buildWordCard(
                    wordData['meaning']!,
                    "Example: ${wordData['example']}\nSynonyms: ${wordData['synonym']}\nAntonyms: ${wordData['antonym']}",
                  ),
                ),

                const SizedBox(height: 20),

                // Navigation Buttons for Next/Previous Word
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: previousWord,
                      child: const Icon(Icons.arrow_back),
                    ),
                    ElevatedButton(
                      onPressed: nextWord,
                      child: const Icon(Icons.arrow_forward),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Vocabulary Quiz Section
                BounceInUp(
                  child: ElevatedButton(
                    onPressed: () {
                      // Navigate to vocabulary quiz
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 40,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      "Take a Quiz",
                      style: GoogleFonts.poppins(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWordCard(String title, String subtitle) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(fontSize: 16, color: Colors.black54),
          ),
        ],
      ),
    );
  }
}
