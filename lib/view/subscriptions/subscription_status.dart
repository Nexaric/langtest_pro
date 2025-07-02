import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:intl/intl.dart';
import 'package:langtest_pro/view/home/home_screen.dart';
import 'package:langtest_pro/view/profile/profile_screen.dart';

class SubscriptionStatusScreen extends StatefulWidget {
  const SubscriptionStatusScreen({super.key});

  @override
  State<SubscriptionStatusScreen> createState() =>
      _SubscriptionStatusScreenState();
}

class _SubscriptionStatusScreenState extends State<SubscriptionStatusScreen> {
  final PageController _pageController = PageController(initialPage: 1);
  final NotchBottomBarController _notchController = NotchBottomBarController(
    index: 1,
  );
  final ValueNotifier<String> _appBarTitle = ValueNotifier<String>(
    'Subscription Status',
  );

  @override
  void dispose() {
    _pageController.dispose();
    _notchController.dispose();
    _appBarTitle.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                valueListenable: _appBarTitle,
                builder: (context, title, child) {
                  return AppBar(
                    elevation: 0,
                    backgroundColor: Colors.transparent,
                    title: Text(
                      title,
                      style: GoogleFonts.poppins(
                        fontSize: 22.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    centerTitle: true,
                    iconTheme: const IconThemeData(color: Colors.white),
                  );
                },
              ),
              Expanded(
                child: PageView(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  onPageChanged: (index) {
                    _notchController.index = index;
                    _appBarTitle.value =
                        index == 0
                            ? 'Home'
                            : index == 1
                            ? 'Subscription Status'
                            : 'Profile';
                  },
                  children: [
                    const HomeContent(),
                    const SubscriptionStatusContent(),
                    ProfileScreen(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        color: const Color(0xFF6959DC), // RGBA(105, 89, 220, 255)
        child: AnimatedNotchBottomBar(
          notchBottomBarController: _notchController,
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
            _notchController.index = index;
            _pageController.jumpToPage(index);
          },
          kIconSize: 24.sp,
          kBottomRadius: 0,
        ),
      ),
    );
  }
}

class SubscriptionStatusContent extends StatelessWidget {
  const SubscriptionStatusContent({super.key});

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments ?? {};
    final String currentPlan = args['plan'] ?? 'Monthly';
    final String currentPrice = args['price'] ?? '₹99';
    final Duration duration = args['duration'] ?? const Duration(days: 30);
    final bool isLifetime = duration.inDays > 365 * 50;
    final DateTime expiryDate =
        isLifetime
            ? DateTime.now().add(const Duration(days: 365 * 100))
            : DateTime.now().add(duration);
    const bool isActive = true;

    final List<Map<String, dynamic>> plans = [
      {
        'title': 'Monthly',
        'price': '₹99',
        'period': '/month',
        'duration': const Duration(days: 30),
        'description': 'Billed monthly',
        'isRecommended': false,
      },
      {
        'title': 'Yearly',
        'price': '₹599',
        'period': '/year',
        'duration': const Duration(days: 365),
        'description': 'Billed yearly (Save 40%)',
        'isRecommended': true,
      },
    ];

    return SingleChildScrollView(
      padding: EdgeInsets.all(20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(color: Colors.white.withOpacity(0.2)),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      currentPlan,
                      style: GoogleFonts.montserrat(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 6.h,
                      ),
                      decoration: BoxDecoration(
                        color:
                            isActive
                                ? Colors.green.withOpacity(0.2)
                                : Colors.grey.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Text(
                        isActive ? 'ACTIVE' : 'EXPIRED',
                        style: GoogleFonts.montserrat(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold,
                          color:
                              isActive ? Colors.green[200] : Colors.grey[200],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Plan Price',
                            style: GoogleFonts.montserrat(
                              fontSize: 14.sp,
                              color: Colors.white.withOpacity(0.7),
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            currentPrice,
                            style: GoogleFonts.montserrat(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isLifetime ? 'Status' : 'Expiry Date',
                            style: GoogleFonts.montserrat(
                              fontSize: 14.sp,
                              color: Colors.white.withOpacity(0.7),
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            DateFormat('MMM d, y').format(expiryDate),
                            style: GoogleFonts.montserrat(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  
}
