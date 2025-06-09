import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:langtest_pro/view/exams/ielts/ielts_reading.dart';

class StrategiesTipsScreen extends StatelessWidget {
  final List<Map<String, dynamic>> strategiesTips = [
    {
      "category": "Skimming and Scanning",
      "color": Color(0xFF6C5CE7),
      "icon": Icons.search_rounded,
      "tips": [
        {
          "title": "Skim for Main Ideas",
          "description":
              "Quickly read headings and first sentences to grasp the passage's main ideas.",
          "icon": Icons.text_snippet_rounded,
        },
        {
          "title": "Scan for Specific Details",
          "description":
              "Look for keywords or numbers to locate specific information quickly.",
          "icon": Icons.find_in_page_rounded,
        },
        {
          "title": "Practice Speed Reading",
          "description":
              "Train to read faster while retaining comprehension to manage time effectively.",
          "icon": Icons.speed_rounded,
        },
        {
          "title": "Identify Paragraph Structure",
          "description":
              "Understand how paragraphs are organized to predict where answers might be.",
          "icon": Icons.format_indent_increase_rounded,
        },
        {
          "title": "Highlight Key Terms",
          "description":
              "Mark or mentally note keywords that relate to the questions.",
          "icon": Icons.highlight_rounded,
        },
      ],
    },
    {
      "category": "Time Management",
      "color": Color(0xFF00B894),
      "icon": Icons.timer_rounded,
      "tips": [
        {
          "title": "Allocate Time per Passage",
          "description":
              "Spend about 20 minutes per passage to complete all three in 60 minutes.",
          "icon": Icons.schedule_rounded,
        },
        {
          "title": "Prioritize Easy Questions",
          "description":
              "Answer straightforward questions first to secure quick points.",
          "icon": Icons.low_priority_rounded,
        },
        {
          "title": "Skip and Return",
          "description":
              "Move on from difficult questions and return if time allows.",
          "icon": Icons.skip_next_rounded,
        },
        {
          "title": "Preview Questions First",
          "description":
              "Read questions before the passage to know what to look for while reading.",
          "icon": Icons.visibility_rounded,
        },
        {
          "title": "Track Time",
          "description":
              "Monitor your pace to ensure you complete all sections.",
          "icon": Icons.watch_later_rounded,
        },
      ],
    },
    {
      "category": "Understanding Question Types",
      "color": Color(0xFFFD79A8),
      "icon": Icons.help_center_rounded,
      "tips": [
        {
          "title": "Master True/False/Not Given",
          "description":
              "Distinguish between information present, contradicted, or not mentioned.",
          "icon": Icons.check_circle_outline_rounded,
        },
        {
          "title": "Practice Matching Headings",
          "description":
              "Match headings to paragraphs by identifying the main idea of each.",
          "icon": Icons.format_list_numbered_rounded,
        },
        {
          "title": "Handle Summary Completion",
          "description":
              "Use synonyms and paraphrasing to find correct words for gaps.",
          "icon": Icons.short_text_rounded,
        },
        {
          "title": "Understand Multiple Choice",
          "description":
              "Eliminate incorrect options to narrow down the correct answer.",
          "icon": Icons.radio_button_checked_rounded,
        },
        {
          "title": "Check Word Limits",
          "description":
              "Adhere to word or number limits for answers like sentence completion.",
          "icon": Icons.format_size_rounded,
        },
      ],
    },
    {
      "category": "Vocabulary Building",
      "color": Color(0xFFFDCB6E),
      "icon": Icons.book_rounded,
      "tips": [
        {
          "title": "Learn Synonyms",
          "description":
              "Study synonyms to recognize paraphrased answers in passages.",
          "icon": Icons.translate_rounded,
        },
        {
          "title": "Use Context Clues",
          "description":
              "Infer meanings of unfamiliar words from surrounding text.",
          "icon": Icons.psychology_rounded,
        },
        {
          "title": "Read Diverse Texts",
          "description":
              "Practice with academic and general texts to expand vocabulary.",
          "icon": Icons.library_books_rounded,
        },
        {
          "title": "Keep a Vocabulary Notebook",
          "description":
              "Record new words and review them regularly to improve retention.",
          "icon": Icons.note_rounded,
        },
        {
          "title": "Practice Word Forms",
          "description":
              "Learn different forms of words (e.g., noun, verb, adjective) for gap-fills.",
          "icon": Icons.text_format_rounded,
        },
      ],
    },
    {
      "category": "Concentration",
      "color": Color(0xFF0984E3),
      "icon": Icons.self_improvement_rounded,
      "tips": [
        {
          "title": "Minimize Distractions",
          "description":
              "Practice in a quiet environment to enhance focus during reading.",
          "icon": Icons.noise_aware_rounded,
        },
        {
          "title": "Active Reading",
          "description":
              "Engage with the text by summarizing paragraphs mentally.",
          "icon": Icons.menu_book_rounded,
        },
        {
          "title": "Use Breathing Exercises",
          "description":
              "Apply breathing techniques to stay calm and focused under pressure.",
          "icon": Icons.air_rounded,
        },
        {
          "title": "Simulate Test Conditions",
          "description":
              "Take timed practice tests to build stamina and concentration.",
          "icon": Icons.assignment_rounded,
        },
        {
          "title": "Break Down Passages",
          "description":
              "Divide long passages into manageable sections to maintain focus.",
          "icon": Icons.segment_rounded,
        },
      ],
    },
  ];

  StrategiesTipsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF3E1E68), Color(0xFF6C5CE7)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              AppBar(
                title: Text(
                  "Reading Strategies & Tips",
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                centerTitle: true,
                backgroundColor: Colors.transparent,
                elevation: 0,
                leading: IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const IeltsReadingScreen(),
                      ),
                    );
                  },
                ),
                actions: const [
                  Padding(
                    padding: EdgeInsets.only(right: 16.0),
                    child: Icon(Icons.search_rounded, color: Colors.white),
                  ),
                ],
              ),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      FadeIn(
                        duration: const Duration(milliseconds: 500),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Color(0xFF6C5CE7).withOpacity(0.8),
                                Color(0xFF6C5CE7).withOpacity(0.8),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Master IELTS Reading",
                                style: GoogleFonts.poppins(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "Proven strategies to boost your reading score. Practice these tips to improve your performance.",
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white.withOpacity(0.9),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      AnimationLimiter(
                        child: ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: strategiesTips.length,
                          itemBuilder: (context, index) {
                            final category = strategiesTips[index];
                            return AnimationConfiguration.staggeredList(
                              position: index,
                              duration: const Duration(milliseconds: 500),
                              child: SlideAnimation(
                                verticalOffset: 50.0,
                                child: FadeInAnimation(
                                  child: _buildCategoryCard(category),
                                ),
                              ),
                            );
                          },
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
    );
  }

  Widget _buildCategoryCard(Map<String, dynamic> category) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          leading: Icon(category['icon'], color: category['color']),
          title: Text(
            category['category'],
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
          ),
          children: List.generate(category['tips'].length, (tipIndex) {
            final tip = category['tips'][tipIndex];
            return ListTile(
              leading: Icon(tip['icon'], color: category['color']),
              title: Text(
                tip['title'],
                style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
              ),
              subtitle: Text(
                tip['description'],
                style: GoogleFonts.poppins(fontSize: 13),
              ),
            );
          }),
        ),
      ),
    );
  }
}
