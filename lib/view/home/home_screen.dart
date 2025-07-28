import 'dart:ui';
import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import 'package:langtest_pro/controller/push_notification/notification_controller.dart';
import 'package:langtest_pro/core/loading/404.dart';
import 'package:langtest_pro/res/colors/app_colors.dart';
import 'package:langtest_pro/utils/utils.dart';
import 'package:langtest_pro/view/home/notification_screen.dart';
import 'package:langtest_pro/view/home/quick_access/practice_test.dart';
import 'package:langtest_pro/view/home/quick_access/speaking_practice.dart';
import 'package:langtest_pro/view/home/quick_access/vocabulary.dart';
import 'package:langtest_pro/view/profile/profile_screen.dart';
import 'package:langtest_pro/view/exams/ielts/ielts_screen.dart';
import 'package:langtest_pro/view/exams/oet/oet_screen.dart';
import 'package:langtest_pro/view/exams/pte/pte_screen.dart';
import 'package:langtest_pro/view/exams/toefl/toefl_screen.dart';
import 'package:langtest_pro/view/subscriptions/subscription_screen.dart';
import 'package:shimmer/shimmer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  final NotificationController pushController = Get.put(NotificationController());
  final PageController pageController = PageController(initialPage: 0);
  final NotchBottomBarController notchController = NotchBottomBarController(index: 0);
  final ValueNotifier<String> appBarTitle = ValueNotifier<String>('Home');

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _animationController.forward();
    // _initializeUser();
  }

  void _initializeUser() async {
    final userId = await Utils.getString('userId');
    if (userId != null) {
      pushController.requestPermissionForFcm(userId: userId);
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF3E1E68), Color(0xFF6A5AE0)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Column(
            children: [
              // Dynamic App Bar
              ValueListenableBuilder<String>(
                valueListenable: appBarTitle,
                builder: (context, title, child) {
                  return AppBar(
                    elevation: 0,
                    backgroundColor: Colors.transparent,
                    title: FadeIn(
                      duration: const Duration(milliseconds: 500),
                      child: Text(
                        title,
                        style: GoogleFonts.poppins(
                          fontSize: 22.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    actions: [
                      IconButton(
                        icon: FadeInRight(
                          duration: const Duration(milliseconds: 600),
                          child: const Icon(Icons.notifications_none_rounded, color: Colors.white),
                        ),
                        onPressed: () => Get.to(() => const NotificationScreen()),
                      ),
                    ],
                  );
                },
              ),
              
              // Main Content Area
              Expanded(
                child: PageView(
                  controller: pageController,
                  // physics: const NeverScrollableScrollPhysics(),
                  onPageChanged: (index) {
                    notchController.index = index;
                    appBarTitle.value = ['Home', 'Subscription', 'Profile'][index];
                  },
                  children: [
                    const HomeContent(),
                    const SubscriptionContent(),
                    ProfileScreen(),
                  ],
                ),
              ),
            ],
          ),
        ),
        
        // Custom Bottom Navigation Bar
        bottomNavigationBar: FadeInUp(
          duration: const Duration(milliseconds: 800),
          child: AnimatedNotchBottomBar(
            notchBottomBarController: notchController,
            color: Colors.white,
            showLabel: true,
            notchColor: const Color(0xFF6A5AE0),
            bottomBarItems: [
              BottomBarItem(
                inActiveItem: Icon(Icons.home_filled, color: Colors.grey, ),
                activeItem: Icon(Icons.home_filled, color:  AppColors.whiteColor, ),
                itemLabel: 'Home',
              ),
              BottomBarItem(
                inActiveItem: Icon(Icons.diamond_outlined, color: Colors.grey, ),
                activeItem: Icon(Icons.diamond, color: AppColors.whiteColor, ),
                itemLabel: 'Subscriptions',
              ),
              BottomBarItem(
                inActiveItem: Icon(Icons.person_rounded, color: Colors.grey, ),
                activeItem: Icon(Icons.person_rounded, color: AppColors.whiteColor, ),
                itemLabel: 'Profile',
              ),
            ],
            onTap: (index) {
              pageController.jumpToPage(index);
              notchController.index = index;
            },
            kIconSize: 24.sp,
            kBottomRadius: 24.r,
          ),
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
          // Welcome Card with Progress
          FadeInDown(
            from: 20,
            duration: const Duration(milliseconds: 500),
            child: _buildWelcomeCard(),
          ),
          
          SizedBox(height: 28.h),
          
          // My Courses Section
          FadeInLeft(
            duration: const Duration(milliseconds: 500),
            child: _buildSectionTitle("My Courses"),
          ),
          
          SizedBox(height: 16.h),
          
          // Courses Horizontal List
          SizedBox(
            height: 200.h,
            child: ListView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              children: [
                _buildCourseCard(
                  "IELTS",
                  "International English Language Testing System",
                  const Color(0xFF4E7AFF),
                  const IeltsScreen(),
                  isAvailable: true,
                ),
                _buildCourseCard(
                  "OET",
                  "Occupational English Test",
                  const Color(0xFF4CAF50),
                  const OetScreen(),
                  isAvailable: false,
                ),
                _buildCourseCard(
                  "PTE",
                  "Pearson Test of English",
                  const Color(0xFFFF9800),
                  const PteScreen(),
                  isAvailable: false,
                ),
                _buildCourseCard(
                  "TOEFL",
                  "Test of English as a Foreign Language",
                  const Color(0xFF9C27B0),
                  const ToeflScreen(),
                  isAvailable: false,
                ),
              ].map((card) => Padding(
                padding: EdgeInsets.only(right: 16.w),
                child: SlideInUp(duration: const Duration(milliseconds: 500), child: card),
              )).toList(),
            ),
          ),
          
          SizedBox(height: 28.h),
          
          // Quick Access Section
          FadeInLeft(
            duration: const Duration(milliseconds: 500),
            child: _buildSectionTitle("Quick Access"),
          ),
          
          SizedBox(height: 16.h),
          
          // Quick Access Grid
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 16.w,
            mainAxisSpacing: 16.h,
            childAspectRatio: 1.1,
            children: [
              _buildQuickAccessTile(
                "Practice Test",
                Icons.assignment_turned_in_rounded,
                const Color(0xFF4E7AFF),
                const PracticeTestScreen(),
              ),
              _buildQuickAccessTile(
                "AI Tutor",
                Icons.smart_toy_rounded,
                const Color(0xFF4CAF50),
                const Error404Screen(),
              ),
              _buildQuickAccessTile(
                "Vocabulary",
                Icons.menu_book_rounded,
                const Color(0xFFFF9800),
                const VocabularyScreen(),
              ),
              _buildQuickAccessTile(
                "Speaking Practice",
                Icons.mic_rounded,
                const Color(0xFFF44336),
                const SpeakingPracticeScreen(),
              ),
            ].map((tile) => FadeInUp(duration: const Duration(milliseconds: 500), child: tile)).toList(),
          ),
          
          SizedBox(height: 20.h),
        ],
      ),
    );
  }

  Widget _buildWelcomeCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF5441E4), Color(0xFF7E6BFF)],
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
          Row(
            children: [
              Expanded(
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
                  ],
                ),
              ),
              Shimmer.fromColors(
                baseColor: Colors.white,
                highlightColor: Colors.yellow,
                child: const Icon(Icons.star_rounded, color: Colors.white),
              ),
            ],
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
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.poppins(
        fontSize: 20.sp,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
    );
  }

  Widget _buildCourseCard(
    String title,
    String subtitle,
    Color color,
    Widget screen, {
    required bool isAvailable,
  }) {
    return GestureDetector(
      onTap: isAvailable ? () => _navigateTo(screen) : null,
      child: Stack(
        children: [
          Container(
            width: 180.w,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20.w,
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
                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
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
          if (!isAvailable) ...[
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
        ],
      ),
    );
  }

  Widget _buildQuickAccessTile(
    String title,
    IconData icon,
    Color color,
    Widget screen,
  ) {
    return GestureDetector(
      onTap: () => _navigateTo(screen),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 15.w,
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

  void _navigateTo(Widget screen) {
    Get.to(
      () => screen,
      transition: Transition.rightToLeft,
      duration: const Duration(milliseconds: 400),
    );
  }
}