import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import '../exams/ielts/ielts_screen.dart';
import '../exams/oet/oet_screen.dart';
import '../exams/pte/pte_screen.dart';
import '../exams/toefl/toefl_screen.dart';

class MyCoursesController extends GetxController {
  var purchasedCourses = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    // Simulate loading purchased courses
    // purchasedCourses.addAll(['IELTS', 'TOEFL']);
  }
}

class MyCoursesScreen extends StatelessWidget {
  const MyCoursesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MyCoursesController());

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "My Courses",
          style: GoogleFonts.poppins(
            fontSize: 22.sp,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.arrow_back, color: Colors.white),
          ),
          onPressed: () => Get.back(),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF3E1E68), Color(0xFF6A5AE0)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FadeInDown(
                child: Text(
                  "Your Purchased Courses",
                  style: GoogleFonts.poppins(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              Expanded(
                child: Obx(
                  () =>
                      controller.purchasedCourses.isEmpty
                          ? Center(
                            child: Text(
                              "No courses purchased yet!",
                              style: GoogleFonts.poppins(
                                fontSize: 16.sp,
                                color: Colors.white.withOpacity(0.7),
                              ),
                            ),
                          )
                          : GridView.count(
                            crossAxisCount: 2,
                            crossAxisSpacing: 16.w,
                            mainAxisSpacing: 16.h,
                            childAspectRatio: 0.8,
                            children:
                                controller.purchasedCourses
                                    .map(
                                      (course) =>
                                          _buildCourseCard(context, course),
                                    )
                                    .toList(),
                          ),
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
          () => Get.to(
            () => courseData['screen'],
            transition: Transition.fade,
            duration: const Duration(milliseconds: 300),
          ),
      child: BounceInUp(
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          elevation: 8,
          color: Colors.white.withOpacity(0.95),
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  courseData['icon'],
                  size: 40.sp,
                  color: courseData['color'],
                ),
                SizedBox(height: 12.h),
                Text(
                  courseData['name'],
                  style: GoogleFonts.poppins(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF2D3748),
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8.h),
                Text(
                  courseData['description'],
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 12.sp,
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
