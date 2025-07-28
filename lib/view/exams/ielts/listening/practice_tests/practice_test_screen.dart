import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';

class PracticeTestScreen extends StatefulWidget {
  const PracticeTestScreen({super.key});

  @override
  _PracticeTestScreenState createState() => _PracticeTestScreenState();
}

class _PracticeTestScreenState extends State<PracticeTestScreen> {
  final Color _gradientStart = const Color(0xFF3E1E68);
  final Color _gradientEnd = const Color.fromARGB(255, 84, 65, 228);
  final Color _accentColor = const Color(0xFF00BFA6);
  final Color _textLight = const Color.fromARGB(255, 255, 255, 255);
  final Color _lockedColor = const Color(0xFFA5A6C4);
  final Color _unlockedStart = const Color(0xFF6D28D9);
  final Color _unlockedEnd = const Color(0xFF9333EA);

  final List<Map<String, dynamic>> _practiceTests = [
    {
      "title": "Practice Test 1: Part 1",
      "part": "Part 1",
      "description": "Everyday conversations and basic comprehension",
      "isLocked": false,
      "isCompleted": false,
    },
    {
      "title": "Practice Test 2: Part 2",
      "part": "Part 2",
      "description": "Monologues and informational audio",
      "isLocked": false,
      "isCompleted": true,
    },
    {
      "title": "Practice Test 3: Part 3",
      "part": "Part 3",
      "description": "Academic discussions",
      "isLocked": true,
      "isCompleted": false,
    },
    {
      "title": "Practice Test 4: Part 4",
      "part": "Part 4",
      "description": "Complex lectures and scenarios",
      "isLocked": true,
      "isCompleted": false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return Scaffold(
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [_gradientStart, _gradientEnd],
              ),
            ),
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverAppBar(
                  title: Text(
                    "IELTS Practice Tests",
                    style: GoogleFonts.poppins(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w600,
                      color: _textLight,
                      letterSpacing: 0.5,
                    ),
                  ),
                  centerTitle: true,
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  leading: IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: 24.sp,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                  pinned: true,
                  floating: false,
                  snap: false,
                  expandedHeight: 0,
                  toolbarHeight: kToolbarHeight,
                ),
                SliverPadding(padding: EdgeInsets.only(top: 10.h)),
                SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate((
                      context,
                      index,
                    ) {
                      final test = _practiceTests[index];
                      return FadeInUp(
                        delay: Duration(milliseconds: 100 * index),
                        child: _buildTestCard(
                          context,
                          test: test,
                        ),
                      );
                    }, childCount: _practiceTests.length),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTestCard(
    BuildContext context, {
    required Map<String, dynamic> test,
  }) {
    return Material(
      elevation: 4,
      borderRadius: BorderRadius.circular(20.r),
      color: Colors.transparent,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.r),
          gradient:
              test['isLocked']
                  ? LinearGradient(
                    colors: [_lockedColor.withOpacity(0.7), _lockedColor],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                  : LinearGradient(
                    colors: test['isCompleted']
                        ? [_accentColor.withOpacity(0.8), _accentColor]
                        : [_unlockedStart, _unlockedEnd],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10.r,
              offset: Offset(0, 4.h),
            ),
          ],
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(20.r),
          onTap: test['isLocked'] ? null : () {},
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        test['title'],
                        style: GoogleFonts.poppins(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: _textLight,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (test['isCompleted'])
                      Icon(
                        Icons.check_circle,
                        color: Colors.white,
                        size: 20.sp,
                      ),
                  ],
                ),
                SizedBox(height: 8.h),
                Text(
                  test['description'],
                  style: GoogleFonts.poppins(
                    fontSize: 12.sp,
                    color: _textLight.withOpacity(0.7),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 12.h),
                Center(
                  child: test['isLocked']
                      ? Container(
                          padding: EdgeInsets.all(10.w),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _textLight.withOpacity(0.1),
                          ),
                          child: Icon(
                            Icons.lock_outline,
                            color: _textLight.withOpacity(0.7),
                            size: 24.sp,
                          ),
                        )
                      : Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 10.h,
                          ),
                          decoration: BoxDecoration(
                            color: _textLight.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(20.r),
                            border: Border.all(
                              color: _textLight.withOpacity(0.3),
                              width: 1.w,
                            ),
                          ),
                          child: Text(
                            test['isCompleted'] ? "Review" : "Start Test",
                            style: GoogleFonts.poppins(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: _textLight,
                              letterSpacing: 0.5,
                            ),
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
}