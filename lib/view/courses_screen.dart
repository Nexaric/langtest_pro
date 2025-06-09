/*import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:animate_do/animate_do.dart';
import 'dart:async';
import '../payment/payment_screen.dart';

class CourseScreen extends StatefulWidget {
  const CourseScreen({super.key});

  @override
  _CourseScreenState createState() => _CourseScreenState();
}

class _CourseScreenState extends State<CourseScreen> {
  final List<Map<String, dynamic>> exams = [
    {
      "name": "IELTS",
      "icon": Icons.school,
      "color": Colors.blue,
      "description": "International English Language Testing System",
      "details":
          "✔ Academic & General Training\n✔ Improve your Band Score with AI-powered feedback\n✔ Full-length Mock Tests & AI-assisted Writing Evaluations\n✔ Speaking Practice with Real-time Pronunciation Analysis\n✔ Interactive Lessons & Vocabulary Builder\n✔ Expert Tips & Exam Strategies",
    },
    {
      "name": "OET",
      "icon": Icons.local_hospital,
      "color": Colors.green,
      "description": "Occupational English Test for healthcare professionals",
      "details":
          "✔ Designed for Healthcare Professionals (Doctors, Nurses, Pharmacists)\n✔ Real-life Medical Case Studies & Role-play Scenarios\n✔ Writing Assistance with Profession-Specific Reports\n✔ Listening & Reading Enhancements with Industry-Focused Content\n✔ AI-Based Pronunciation & Fluency Checker\n✔ Personalized Study Plans & Performance Analytics",
    },
    {
      "name": "PTE",
      "icon": Icons.book,
      "color": Colors.orange,
      "description": "Pearson Test of English, computer-based",
      "details":
          "✔ Fully AI-Scored Exam with Instant Feedback\n✔ Real-Time Mock Tests & Performance Reports\n✔ Automated Speaking Practice with Fluency Checker\n✔ Writing Assistant with Grammar & Lexical Resource Enhancements\n✔ Interactive Learning Modules & Adaptive Study Plans\n✔ Exclusive PTE Tips & Tricks",
    },
    {
      "name": "TOEFL",
      "icon": Icons.translate,
      "color": Colors.purple,
      "description": "Test of English as a Foreign Language",
      "details":
          "✔ Ideal for University Admissions & Academic Success\n✔ AI-Powered Speaking Evaluations & Fluency Reports\n✔ Writing Analysis with Instant Scoring & Feedback\n✔ Full-Length Practice Tests & Listening Exercises\n✔ Smart Vocabulary Expansion & Grammar Refinement\n✔ Time-Management Strategies for High Scores",
    },
  ];

  void showExamDetails(BuildContext context, Map<String, dynamic> exam) {
    int secondsRemaining = 600;
    Timer? timer;

    showDialog(
      context: context,
      builder: (context) {
        timer = Timer.periodic(const Duration(seconds: 1), (t) {
          if (secondsRemaining > 0) {
            setState(() {
              secondsRemaining--;
            });
          } else {
            t.cancel();
          }
        });

        return ZoomIn(
          child: Dialog(
            backgroundColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: GlassmorphicContainer(
              width: MediaQuery.of(context).size.width * 0.9,
              height: MediaQuery.of(context).size.height * 0.75,
              borderRadius: 20,
              blur: 25,
              border: 2,
              linearGradient: LinearGradient(
                colors: [
                  Colors.white.withOpacity(0.3),
                  Colors.white.withOpacity(0.1),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderGradient: LinearGradient(
                colors: [
                  Colors.white.withOpacity(0.5),
                  Colors.white.withOpacity(0.1),
                ],
              ),
              child: ShakeY(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "${exam['name']} Exam Benefits",
                        style: GoogleFonts.poppins(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Text(
                            exam['details'],
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              color: Colors.white70,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        secondsRemaining > 0
                            ? "Limited Time Offer: ₹8 (Ends in ${secondsRemaining ~/ 60}:${secondsRemaining % 60})"
                            : "Original Price: ₹199",
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: Colors.redAccent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const PaymentScreen(),
                            ),
                          );
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
                          "Proceed to Payment",
                          style: GoogleFonts.poppins(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          timer?.cancel();
                        },
                        child: Text(
                          "Close",
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    ).then((_) => timer?.cancel());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          "Exam Preparation",
          style: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.transparent,
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

          // Course Cards Grid
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.85,
              ),
              itemCount: exams.length,
              itemBuilder: (context, index) {
                return FadeInUp(
                  delay: Duration(milliseconds: 400 + (index * 100)),
                  child: GestureDetector(
                    onTap: () => showExamDetails(context, exams[index]),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 8,
                      color: Colors.white.withOpacity(0.95),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            exams[index]['icon'],
                            size: 50,
                            color: exams[index]['color'],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            exams[index]['name'],
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            exams[index]['description'],
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
*/
