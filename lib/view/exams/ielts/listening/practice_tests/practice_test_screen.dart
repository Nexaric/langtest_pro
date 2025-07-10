import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import 'package:get/get.dart';
import 'package:langtest_pro/controller/listening_controller.dart';
import 'package:langtest_pro/view/exams/ielts/ielts_listening.dart';
import 'practice_test_questions_screen.dart';

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
      "lessonId": 1,
    },
    {
      "title": "Practice Test 2: Part 2",
      "part": "Part 2",
      "description": "Monologues and informational audio",
      "lessonId": 2,
    },
    {
      "title": "Practice Test 3: Part 3",
      "part": "Part 3",
      "description": "Academic discussions",
      "lessonId": 3,
    },
    {
      "title": "Practice Test 4: Part 4",
      "part": "Part 4",
      "description": "Complex lectures and scenarios",
      "lessonId": 4,
    },
  ];

  @override
  void initState() {
    super.initState();
    if (!Get.isRegistered<ListeningController>()) {
      Get.put(ListeningController());
    }
    final progressController = Get.find<ListeningController>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      progressController.refreshProgress();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return WillPopScope(
          onWillPop: () async {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const IeltsListeningScreen(),
              ),
            );
            return false;
          },
          child: Scaffold(
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
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const IeltsListeningScreen(),
                          ),
                        );
                      },
                    ),
                    pinned: true,
                    floating: false,
                    snap: false,
                    expandedHeight: 0,
                    toolbarHeight: kToolbarHeight,
                  ),
                  SliverPadding(padding: EdgeInsets.only(top: 10.h)),
                  Obx(() {
                    final progressController = Get.find<ListeningController>();
                    if (progressController.isLoading) {
                      return SliverFillRemaining(
                        child: Center(
                          child: CircularProgressIndicator(
                            color: _gradientStart,
                          ),
                        ),
                      );
                    }

                    if (progressController.hasError) {
                      return SliverFillRemaining(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                progressController.errorMessage ??
                                    'Error loading progress',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(
                                  fontSize: 16.sp,
                                  color: _textLight,
                                ),
                              ),
                              SizedBox(height: 16.h),
                              ElevatedButton(
                                onPressed: () async {
                                  await progressController.refreshProgress();
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: _accentColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.r),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 16.w,
                                    vertical: 10.h,
                                  ),
                                ),
                                child: Text(
                                  'Retry',
                                  style: GoogleFonts.poppins(
                                    fontSize: 14.sp,
                                    color: _textLight,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    return SliverPadding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate((context, index) {
                          final test = _practiceTests[index];
                          return FutureBuilder<bool>(
                            future:
                                index == 0
                                    ? Future.value(true)
                                    : progressController
                                        .isPracticeTestAccessible(
                                          test['lessonId'] - 1,
                                        ),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.w,
                                    color: _gradientStart,
                                  ),
                                );
                              }
                              final isLocked = index > 0 && !snapshot.data!;
                              final isCompleted =
                                  progressController.getPracticeTestProgress(
                                    test['lessonId'],
                                  ) ==
                                  100;

                              return Obx(
                                () => FadeInUp(
                                  delay: Duration(milliseconds: 100 * index),
                                  child: _buildTestCard(
                                    context,
                                    test: test,
                                    isLocked: isLocked,
                                    isCompleted: isCompleted,
                                    progressController: progressController,
                                  ),
                                ),
                              );
                            },
                          );
                        }, childCount: _practiceTests.length),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTestCard(
    BuildContext context, {
    required Map<String, dynamic> test,
    required bool isLocked,
    required bool isCompleted,
    required ListeningController progressController,
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
              isLocked
                  ? LinearGradient(
                    colors: [_lockedColor.withOpacity(0.7), _lockedColor],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                  : LinearGradient(
                    colors:
                        isCompleted
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
          onTap:
              isLocked
                  ? null
                  : () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) =>
                                PracticeTestQuestionsScreen(part: test['part']),
                      ),
                    );
                  },
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
                    if (isCompleted)
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
                  child:
                      isLocked
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
                              isCompleted ? "Review" : "Start Test",
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
