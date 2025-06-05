import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';

class StrategiesTipsScreen extends StatelessWidget {
  const StrategiesTipsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF3E1E68), Color.fromARGB(255, 84, 65, 228)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.0, 1.0],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // App Bar Section
                Row(
                  children: [
                    ElasticInLeft(
                      delay: const Duration(milliseconds: 200),
                      child: IconButton(
                        icon: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          size: 20,
                          color: Colors.white,
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    Expanded(
                      child: BounceInDown(
                        delay: const Duration(milliseconds: 100),
                        child: Text(
                          "Strategies & Tips",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Main Title
                FadeInDown(
                  from: 30,
                  duration: const Duration(milliseconds: 800),
                  child: Text(
                    "IELTS Writing Mastery",
                    style: GoogleFonts.poppins(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                FadeInDown(
                  delay: const Duration(milliseconds: 100),
                  child: Text(
                    "Essential strategies for high scores",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                ),
                const SizedBox(height: 30),

                // Task 1 Tips
                SlideInLeft(
                  duration: const Duration(milliseconds: 700),
                  child: Text(
                    "Task 1 (Letter Writing)",
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.tealAccent,
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                _buildTipCard(
                  "Plan Before You Write",
                  "Spend 2-3 minutes analyzing the prompt and planning your response. Identify the letter type (formal/semi-formal/informal) and key points to include.",
                  Icons.edit_note_rounded,
                  Colors.blueAccent,
                ),
                _buildTipCard(
                  "Structure Matters",
                  "Use clear paragraphs: Introduction (purpose), Body (details), Conclusion (closing remarks). Formal letters should include addresses and date.",
                  Icons.format_list_bulleted_rounded,
                  Colors.greenAccent,
                ),
                _buildTipCard(
                  "Tone & Style",
                  "Match your language to the recipient. Formal letters require professional language, while informal letters can use contractions and casual phrases.",
                  Icons.record_voice_over_rounded,
                  Colors.purpleAccent,
                ),
                _buildTipCard(
                  "Word Count Awareness",
                  "Aim for 150+ words. Writing significantly less will lower your score, but don't waste time writing much more than required.",
                  Icons.format_size_rounded,
                  Colors.orangeAccent,
                ),
                _buildTipCard(
                  "Common Phrases",
                  "Learn standard openings/closings for different letter types. For formal letters: 'Dear Sir/Madam', 'Yours faithfully'. For informal: 'Dear [Name]', 'Best wishes'.",
                  Icons.article_rounded,
                  Colors.lightGreenAccent,
                ),
                _buildTipCard(
                  "Purpose Clarity",
                  "Clearly state the purpose of your letter in the first paragraph. Don't make the examiner guess why you're writing.",
                  Icons.visibility_rounded,
                  Colors.amberAccent,
                ),

                // Task 2 Tips
                const SizedBox(height: 30),
                SlideInLeft(
                  delay: const Duration(milliseconds: 100),
                  duration: const Duration(milliseconds: 700),
                  child: Text(
                    "Task 2 (Essay Writing)",
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.tealAccent,
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                _buildTipCard(
                  "Understand the Question",
                  "Carefully analyze what's being asked. Identify if it's opinion, discussion, problem/solution, or advantage/disadvantage type.",
                  Icons.lightbulb_rounded,
                  Colors.tealAccent,
                ),
                _buildTipCard(
                  "Essay Structure",
                  "4-paragraph structure works best: Introduction, 2 Body paragraphs (with examples), Conclusion. Each paragraph should have one main idea.",
                  Icons.account_tree_rounded,
                  Colors.pinkAccent,
                ),
                _buildTipCard(
                  "Time Management",
                  "Spend 40 minutes: 5 min planning, 30 min writing, 5 min checking. Task 2 carries more weight, so prioritize it.",
                  Icons.timer_rounded,
                  Colors.lightBlueAccent,
                ),
                _buildTipCard(
                  "Vocabulary & Grammar",
                  "Show range in vocabulary but prioritize accuracy. Complex sentences should be error-free. Avoid memorized phrases.",
                  Icons.g_translate_rounded,
                  Colors.limeAccent,
                ),
                _buildTipCard(
                  "Thesis Statement",
                  "Your introduction must contain a clear thesis statement that outlines your position or main argument.",
                  Icons.format_quote_rounded,
                  Colors.deepPurpleAccent,
                ),
                _buildTipCard(
                  "Cohesive Devices",
                  "Use linking words appropriately (however, furthermore, consequently) but don't overuse them. They should enhance clarity, not distract.",
                  Icons.link_rounded,
                  Colors.cyanAccent,
                ),
                _buildTipCard(
                  "Balanced Argument",
                  "For discussion essays, present both sides fairly before giving your opinion. Show you can see multiple perspectives.",
                  Icons.balance_rounded,
                  Colors.indigoAccent,
                ),

                // General Tips
                const SizedBox(height: 30),
                SlideInLeft(
                  delay: const Duration(milliseconds: 200),
                  duration: const Duration(milliseconds: 700),
                  child: Text(
                    "General Writing Tips",
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.tealAccent,
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                _buildTipCard(
                  "Practice Regularly",
                  "Write at least 2-3 essays and letters per week under timed conditions. Review model answers to understand expectations.",
                  Icons.repeat_rounded,
                  Colors.cyanAccent,
                ),
                _buildTipCard(
                  "Feedback is Key",
                  "Have a teacher or native speaker review your writing. Focus on recurring mistakes to improve faster.",
                  Icons.feedback_rounded,
                  Colors.deepOrangeAccent,
                ),
                _buildTipCard(
                  "Read Sample Answers",
                  "Analyze high-scoring responses to understand what examiners look for in terms of structure, vocabulary and ideas.",
                  Icons.auto_stories_rounded,
                  Colors.indigoAccent,
                ),
                _buildTipCard(
                  "Stay Updated",
                  "Familiarize yourself with common IELTS topics: education, technology, environment, health, and society.",
                  Icons.update_rounded,
                  Colors.redAccent,
                ),
                _buildTipCard(
                  "Handwriting Matters",
                  "If taking the paper test, ensure your writing is legible. Examiners can't award marks for what they can't read.",
                  Icons.draw_rounded,
                  Colors.purpleAccent,
                ),
                _buildTipCard(
                  "Avoid Repetition",
                  "Use synonyms and varied sentence structures to demonstrate language range. Don't repeat the same words or phrases.",
                  Icons.repeat_one_rounded,
                  Colors.blueGrey,
                ),
                _buildTipCard(
                  "Final Check",
                  "Always reserve 2-3 minutes to proofread for spelling, grammar, and punctuation errors that could lower your score.",
                  Icons.check_circle_rounded,
                  Colors.lightGreenAccent,
                ),

                // Motivational Section
                const SizedBox(height: 30),
                FadeInUp(
                  delay: const Duration(milliseconds: 300),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white.withOpacity(0.3)),
                      gradient: LinearGradient(
                        colors: [
                          Colors.teal.withOpacity(0.2),
                          Colors.blue.withOpacity(0.2),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Column(
                      children: [
                        JelloIn(
                          delay: const Duration(milliseconds: 400),
                          child: const Icon(
                            Icons.auto_awesome_rounded,
                            color: Colors.tealAccent,
                            size: 36,
                          ),
                        ),
                        const SizedBox(height: 15),
                        BounceInUp(
                          delay: const Duration(milliseconds: 500),
                          child: Text(
                            "Remember: Consistent practice and proper strategy will significantly improve your writing score!",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        FadeInUp(
                          delay: const Duration(milliseconds: 600),
                          child: Text(
                            "Band 7+ Achievable!",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.tealAccent,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTipCard(
    String title,
    String description,
    IconData icon,
    Color color,
  ) {
    return FlipInX(
      duration: const Duration(milliseconds: 800),
      delay: const Duration(milliseconds: 100),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withOpacity(0.3)),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.2),
              blurRadius: 10,
              spreadRadius: 2,
              offset: const Offset(0, 3),
            ),
          ],
          gradient: LinearGradient(
            colors: [color.withOpacity(0.1), Colors.transparent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BounceIn(
              delay: const Duration(milliseconds: 150),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SlideInLeft(
                    delay: const Duration(milliseconds: 200),
                    child: Text(
                      title,
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  FadeIn(
                    delay: const Duration(milliseconds: 250),
                    child: Text(
                      description,
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
