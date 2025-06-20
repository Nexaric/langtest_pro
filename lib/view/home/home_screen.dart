import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:langtest_pro/controller/push_notification/notification_controller.dart';
import 'package:langtest_pro/core/loading/404.dart';
import 'package:langtest_pro/utils/utils.dart';
import 'package:langtest_pro/view/home/side_menu/menu_screen.dart';
import 'package:langtest_pro/view/home/quick_access/practice_test.dart';
import 'package:langtest_pro/view/home/quick_access/speaking_practice.dart';
import 'package:langtest_pro/view/home/quick_access/vocabulary.dart';
import 'package:langtest_pro/view/profile/profile_screen.dart';
import 'package:langtest_pro/view/home/notification_screen.dart';
import 'package:langtest_pro/view/exams/ielts/ielts_screen.dart';
import 'package:langtest_pro/view/exams/oet/oet_screen.dart';
import 'package:langtest_pro/view/exams/pte/pte_screen.dart';
import 'package:langtest_pro/view/exams/toefl/toefl_screen.dart';
import 'package:langtest_pro/view/subscriptions/subscription_screen.dart';

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final pushController = Get.put(NotificationController());
    final pageController = PageController(initialPage: 0); // Home is index 0
    final notchController = NotchBottomBarController(index: 0);
    final appBarTitle = ValueNotifier<String>('Home'); // Dynamic title

    void getUserId() async {
      final userId = await Utils.getString('userId');
      if (userId != null) {
        pushController.requestPermissionForFcm(userId: userId);
      }
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      getUserId();
    });

    return Container(
      color: const Color(0xFF6959DC), // Set the custom background color
      child: Scaffold(
        backgroundColor:
            Colors
                .transparent, // Make Scaffold transparent to show Container's color
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF3E1E68), Color(0xFF6A5AE0)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                ValueListenableBuilder<String>(
                  valueListenable: appBarTitle,
                  builder: (context, title, child) {
                    return AppBar(
                      elevation: 0,
                      backgroundColor: Colors.transparent,
                      leading: IconButton(
                        icon: Container(
                          padding: EdgeInsets.all(8.w),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.menu_rounded,
                            color: Colors.white,
                            size: 24.sp,
                          ),
                        ),
                        onPressed: () {
                          Get.to(
                            () => const MenuScreen(),
                            transition: Transition.leftToRight,
                          );
                        },
                      ),
                      title: Text(
                        title,
                        style: GoogleFonts.poppins(
                          fontSize: 22.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      actions: [
                        IconButton(
                          icon: Container(
                            padding: EdgeInsets.all(8.w),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.notifications_rounded,
                              color: Colors.white,
                              size: 24.sp,
                            ),
                          ),
                          onPressed: () {
                            Get.to(
                              () => const NotificationScreen(),
                              transition: Transition.rightToLeft,
                            );
                          },
                        ),
                      ],
                      centerTitle: true,
                    );
                  },
                ),
                Expanded(
                  child: PageView(
                    controller: pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    onPageChanged: (index) {
                      notchController.index = index;
                      appBarTitle.value =
                          index == 0
                              ? 'Home'
                              : index == 1
                              ? 'Subscription'
                              : 'Profile';
                    },
                    children: const [
                      HomeContent(),
                      SubscriptionContent(),
                      ProfileScreen(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: AnimatedNotchBottomBar(
          notchBottomBarController: notchController,
          color: Colors.white,
          showLabel: true,
          bottomBarItems: [
            BottomBarItem(
              inActiveItem: Icon(
                Icons.home_filled,
                color: Colors.grey,
                size: 24.sp,
              ),
              activeItem: Icon(
                Icons.home_filled,
                color: const Color(0xFF6A5AE0),
                size: 24.sp,
              ),
              itemLabel: 'Home',
            ),
            BottomBarItem(
              inActiveItem: Icon(
                Icons.diamond_outlined,
                color: Colors.grey,
                size: 24.sp,
              ),
              activeItem: Icon(
                Icons.diamond,
                color: const Color(0xFF6A5AE0),
                size: 24.sp,
              ),
              itemLabel: 'Subscriptions',
            ),
            BottomBarItem(
              inActiveItem: Icon(
                Icons.person_rounded,
                color: Colors.grey,
                size: 24.sp,
              ),
              activeItem: Icon(
                Icons.person_rounded,
                color: const Color(0xFF6A5AE0),
                size: 24.sp,
              ),
              itemLabel: 'Profile',
            ),
          ],
          onTap: (index) {
            notchController.index = index;
            pageController.jumpToPage(index);
          },
          kIconSize: 24.sp,
          kBottomRadius: 0,
        ),
      ),
    );
  }
}

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FadeInDown(
            from: 20,
            duration: const Duration(milliseconds: 500),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF5441E4), Color(0xFF5441E4)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20.r),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF3E1E68).withOpacity(0.4),
                    blurRadius: 20.w,
                    offset: Offset(0, 10.h),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Welcome Back! 👋",
                    style: GoogleFonts.poppins(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    "Your daily learning streak: 3 Days 🔥",
                    style: GoogleFonts.poppins(
                      fontSize: 14.sp,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  LinearProgressIndicator(
                    value: 0.6,
                    backgroundColor: Colors.white.withOpacity(0.3),
                    color: Colors.white,
                    minHeight: 6.h,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "60% of weekly goal",
                        style: GoogleFonts.poppins(
                          fontSize: 12.sp,
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                      Text(
                        "3/5 days",
                        style: GoogleFonts.poppins(
                          fontSize: 12.sp,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 28.h),
          FadeInLeft(
            duration: const Duration(milliseconds: 500),
            child: Text(
              "My Courses",
              style: GoogleFonts.poppins(
                fontSize: 20.sp,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(height: 16.h),
          SizedBox(
            height: 200.h,
            child: ListView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              children:
                  [
                        _buildCourseCard(
                          context,
                          "IELTS",
                          "International English Language Testing System",
                          const Color(0xFF4E7AFF),
                          const IeltsScreen(),
                          isAvailable: true,
                        ),
                        _buildCourseCard(
                          context,
                          "OET",
                          "Occupational English Test (Healthcare Focused)",
                          const Color(0xFF4CAF50),
                          const OetScreen(),
                          isAvailable: false,
                        ),
                        _buildCourseCard(
                          context,
                          "PTE",
                          "Pearson Test of English (Academic & General)",
                          const Color(0xFFFF9800),
                          const PteScreen(),
                          isAvailable: false,
                        ),
                        _buildCourseCard(
                          context,
                          "TOEFL",
                          "Test of English as a Foreign Language",
                          const Color(0xFF9C27B0),
                          const ToeflScreen(),
                          isAvailable: false,
                        ),
                      ]
                      .map(
                        (card) => SlideInUp(
                          duration: const Duration(milliseconds: 500),
                          child: card,
                        ),
                      )
                      .toList(),
            ),
          ),
          SizedBox(height: 28.h),
          FadeInLeft(
            duration: const Duration(milliseconds: 500),
            child: Text(
              "Quick Access",
              style: GoogleFonts.poppins(
                fontSize: 20.sp,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(height: 16.h),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 16.w,
            mainAxisSpacing: 16.h,
            childAspectRatio: 1.1,
            children:
                [
                      _buildQuickAccessTile(
                        context,
                        "Practice Test",
                        Icons.assignment_turned_in_rounded,
                        const Color(0xFF4E7AFF),
                        const PracticeTestScreen(),
                      ),
                      _buildQuickAccessTile(
                        context,
                        "AI Tutor",
                        Icons.smart_toy_rounded,
                        const Color(0xFF4CAF50),
                        const Error404Screen(),
                      ),
                      _buildQuickAccessTile(
                        context,
                        "Vocabulary",
                        Icons.menu_book_rounded,
                        const Color(0xFFFF9800),
                        const VocabularyScreen(),
                      ),
                      _buildQuickAccessTile(
                        context,
                        "Speaking Practice",
                        Icons.mic_rounded,
                        const Color(0xFFF44336),
                        const SpeakingPracticeScreen(),
                      ),
                    ]
                    .map(
                      (tile) => FadeInUp(
                        duration: const Duration(milliseconds: 500),
                        child: tile,
                      ),
                    )
                    .toList(),
          ),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }

  Widget _buildCourseCard(
    BuildContext context,
    String title,
    String subtitle,
    Color color,
    Widget screen, {
    required bool isAvailable,
  }) {
    return GestureDetector(
      onTap:
          isAvailable
              ? () {
                Get.to(
                  () => screen,
                  transition: Transition.fade,
                  duration: const Duration(milliseconds: 300),
                );
              }
              : null,
      child: Stack(
        children: [
          Container(
            width: 180.w,
            margin: EdgeInsets.only(right: 16.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20.w,
                  spreadRadius: 2.w,
                  offset: Offset(0, 10.h),
                ),
              ],
            ),
            padding: EdgeInsets.all(16.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Icon(Icons.school_rounded, size: 28.sp, color: color),
                ),
                SizedBox(height: 12.h),
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF2D3748),
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  subtitle,
                  style: GoogleFonts.poppins(
                    fontSize: 12.sp,
                    color: const Color(0xFF718096),
                    height: 1.4,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 8.h),
                Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Text(
                      isAvailable ? "Start" : "Coming Soon",
                      style: GoogleFonts.poppins(
                        fontSize: 12.sp,
                        color: color,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (!isAvailable)
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20.r),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                  child: Container(
                    color: Colors.black.withOpacity(0.3),
                    child: Center(
                      child: Text(
                        'Coming Soon',
                        style: GoogleFonts.poppins(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildQuickAccessTile(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    Widget screen,
  ) {
    return GestureDetector(
      onTap: () {
        Get.to(
          () => screen,
          transition: Transition.downToUp,
          duration: const Duration(milliseconds: 400),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 15.w,
              spreadRadius: 1.w,
              offset: Offset(0, 5.h),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 28.sp, color: color),
            ),
            SizedBox(height: 12.h),
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF2D3748),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ShimmeringWaveText extends StatelessWidget {
  final String text;
  final TextStyle textStyle;

  const ShimmeringWaveText({
    super.key,
    required this.text,
    required this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Text(text, style: textStyle.copyWith(color: Colors.white));
  }
}
