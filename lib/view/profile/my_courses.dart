import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import '../exams/ielts/ielts_screen.dart';
import '../exams/oet/oet_screen.dart';
import '../exams/pte/pte_screen.dart';
import '../exams/toefl/toefl_screen.dart';

class MyCoursesScreen extends StatefulWidget {
  const MyCoursesScreen({super.key});

  @override
  _MyCoursesScreenState createState() => _MyCoursesScreenState();
}

class _MyCoursesScreenState extends State<MyCoursesScreen> {
  List<String> purchasedCourses = [];

  @override
  void initState() {
    super.initState();
    // _loadPurchasedCourses();
  }

  // Future<void> _loadPurchasedCourses() async {
  //   List<String> courses = await FirebaseService().getUserPurchasedCourses();
  //   setState(() {
  //     purchasedCourses = courses;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "My Courses",
          style: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.arrow_back, color: Colors.white),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF3E1E68), Color.fromARGB(255, 84, 65, 228)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF3E1E68), Color.fromARGB(255, 84, 65, 228)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FadeInDown(
                child: Text(
                  "Your Purchased Courses",
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child:
                    purchasedCourses.isEmpty
                        ? Center(
                          child: Text(
                            "No courses purchased yet!",
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              color: Colors.white.withOpacity(0.7),
                            ),
                          ),
                        )
                        : GridView.count(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 0.8,
                          children:
                              purchasedCourses
                                  .map(
                                    (course) =>
                                        _buildCourseCard(context, course),
                                  )
                                  .toList(),
                        ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCourseCard(BuildContext context, String course) {
    Map<String, dynamic> courseData = _getCourseData(course);
    return GestureDetector(
      onTap:
          () => Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder:
                  (context, animation, secondaryAnimation) =>
                      courseData['screen'],
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) =>
                      FadeTransition(opacity: animation, child: child),
              transitionDuration: const Duration(milliseconds: 300),
            ),
          ),
      child: BounceInUp(
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 8,
          color: Colors.white.withOpacity(0.95),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(courseData['icon'], size: 40, color: courseData['color']),
                const SizedBox(height: 12),
                Text(
                  courseData['name'],
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF2D3748),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  courseData['description'],
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: const Color(0xFF718096),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Map<String, dynamic> _getCourseData(String course) {
    Map<String, dynamic> courses = {
      "IELTS": {
        "name": "IELTS",
        "icon": Icons.school,
        "color": const Color(0xFF3E1E68),
        "description": "International English Language Testing System",
        "screen": const IeltsScreen(),
      },
      "OET": {
        "name": "OET",
        "icon": Icons.local_hospital,
        "color": const Color(0xFF3E1E68),
        "description": "Occupational English Test for healthcare professionals",
        "screen": const OetScreen(),
      },
      "PTE": {
        "name": "PTE",
        "icon": Icons.book,
        "color": const Color(0xFF3E1E68),
        "description": "Pearson Test of English, AI-powered evaluation",
        "screen": const PteScreen(),
      },
      "TOEFL": {
        "name": "TOEFL",
        "icon": Icons.translate,
        "color": const Color(0xFF3E1E68),
        "description": "Test of English as a Foreign Language",
        "screen": const ToeflScreen(),
      },
    };
    return courses[course] ??
        {
          "name": "Unknown Course",
          "icon": Icons.help,
          "color": Colors.grey,
          "description": "No details available",
          "screen": const Scaffold(),
        };
  }
}
