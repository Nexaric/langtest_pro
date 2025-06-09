import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:langtest_pro/view/home/side_menu/menu_screen.dart';
import 'package:langtest_pro/view/home/quick_access/practice_test.dart';
import 'package:langtest_pro/view/home/quick_access/speaking_practice.dart';
import 'package:langtest_pro/view/home/quick_access/vocabulary.dart';
import 'package:langtest_pro/loading/404.dart';
import 'package:langtest_pro/view/profile/profile_screen.dart';
import 'package:langtest_pro/view/home/notification_screen.dart';
import 'package:langtest_pro/view/exams/ielts/ielts_screen.dart';
import 'package:langtest_pro/view/exams/oet/oet_screen.dart';
import 'package:langtest_pro/view/exams/pte/pte_screen.dart';
import 'package:langtest_pro/view/exams/toefl/toefl_screen.dart';
import 'package:langtest_pro/view/subscriptions/subscription_screen.dart';

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<String> purchasedCourses = [];
  final _pageController = PageController(initialPage: 0);
  final _controller = NotchBottomBarController(index: 0);

  final List<Widget> _pages = [
    const HomeContent(),
    const SubscriptionScreen(),
    const ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    // _loadPurchasedCourses();
  }

  // Future<void> _loadPurchasedCourses() async {
  //   List<String> courses = await FirebaseService().getUserPurchasedCourses();
  //   if (mounted) {
  //     setState(() {
  //       purchasedCourses = courses;
  //     });
  //   }
  // }

  @override
  void dispose() {
    _pageController.dispose();
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
              AppBar(
                elevation: 0,
                backgroundColor: Colors.transparent,
                leading: IconButton(
                  icon: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.menu_rounded, color: Colors.white),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MenuScreen(),
                      ),
                    );
                  },
                ),
                title: Text(
                  "LangTest Pro",
                  style: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                actions: [
                  IconButton(
                    icon: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.notifications_rounded,
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const NotificationScreen(),
                        ),
                      );
                    },
                  ),
                ],
                centerTitle: true,
              ),
              Expanded(
                child: PageView(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  onPageChanged: (index) {
                    setState(() {
                      _controller.index = index; // Sync bottom bar with page
                    });
                  },
                  children: _pages,
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: AnimatedNotchBottomBar(
        notchBottomBarController: _controller,
        color: Colors.white,
        showLabel: true,
        bottomBarItems: [
          BottomBarItem(
            inActiveItem: Icon(Icons.home_filled, color: Colors.grey),
            activeItem: Icon(Icons.home_filled, color: const Color(0xFF6A5AE0)),
            itemLabel: 'Home',
          ),
          BottomBarItem(
            inActiveItem: Icon(Icons.diamond_outlined, color: Colors.grey),
            activeItem: Icon(Icons.diamond, color: const Color(0xFF6A5AE0)),
            itemLabel: 'Subscriptions',
          ),
          BottomBarItem(
            inActiveItem: Icon(Icons.person_rounded, color: Colors.grey),
            activeItem: Icon(
              Icons.person_rounded,
              color: const Color(0xFF6A5AE0),
            ),
            itemLabel: 'Profile',
          ),
        ],
        onTap: (index) {
          setState(() {
            _controller.index = index; // Update controller
            _pageController.jumpToPage(index); // Jump to page
          });
        },
        kIconSize: 24.0,
        kBottomRadius: 0,
      ),
    );
  }
}

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FadeInDown(
            from: 20,
            duration: const Duration(milliseconds: 500),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color.fromARGB(255, 84, 65, 228),
                    Color.fromARGB(255, 84, 65, 228),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF3E1E68).withOpacity(0.4),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Welcome Back! 👋",
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Your daily learning streak: 3 Days 🔥",
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                  const SizedBox(height: 16),
                  LinearProgressIndicator(
                    value: 0.6,
                    backgroundColor: Colors.white.withOpacity(0.3),
                    color: Colors.white,
                    minHeight: 6,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "60% of weekly goal",
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                      Text(
                        "3/5 days",
                        style: GoogleFonts.poppins(
                          fontSize: 12,
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
          const SizedBox(height: 28),
          FadeInLeft(
            duration: const Duration(milliseconds: 500),
            child: Text(
              "My Courses",
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 200,
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
          const SizedBox(height: 28),
          FadeInLeft(
            duration: const Duration(milliseconds: 500),
            child: Text(
              "Quick Access",
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 16),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
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
          const SizedBox(height: 20),
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
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder:
                        (context, animation, secondaryAnimation) => screen,
                    transitionsBuilder: (
                      context,
                      animation,
                      secondaryAnimation,
                      child,
                    ) {
                      return FadeTransition(opacity: animation, child: child);
                    },
                    transitionDuration: const Duration(milliseconds: 300),
                  ),
                );
              }
              : null,
      child: Stack(
        children: [
          Container(
            width: 180,
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  spreadRadius: 2,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.school_rounded, size: 28, color: color),
                ),
                const SizedBox(height: 12),
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF2D3748),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: const Color(0xFF718096),
                    height: 1.4,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      isAvailable ? "Start" : "Coming Soon",
                      style: GoogleFonts.poppins(
                        fontSize: 12,
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
                borderRadius: BorderRadius.circular(20),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                  child: Container(
                    color: Colors.black.withOpacity(0.3),
                    child: Center(
                      child: ShimmeringWaveText(
                        text: 'Coming Soon',
                        textStyle: GoogleFonts.poppins(
                          fontSize: 16,
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
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => screen,
            transitionsBuilder: (
              context,
              animation,
              secondaryAnimation,
              child,
            ) {
              var begin = const Offset(0.0, 0.3);
              var end = Offset.zero;
              var curve = Curves.easeOutQuart;
              var tween = Tween(
                begin: begin,
                end: end,
              ).chain(CurveTween(curve: curve));
              return SlideTransition(
                position: animation.drive(tween),
                child: child,
              );
            },
            transitionDuration: const Duration(milliseconds: 400),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 15,
              spreadRadius: 1,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 28, color: color),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 16,
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

class ShimmeringWaveText extends StatefulWidget {
  final String text;
  final TextStyle textStyle;

  const ShimmeringWaveText({
    super.key,
    required this.text,
    required this.textStyle,
  });

  @override
  State<ShimmeringWaveText> createState() => _ShimmeringWaveTextState();
}

class _ShimmeringWaveTextState extends State<ShimmeringWaveText>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              colors: const [
                Colors.white,
                Color.fromARGB(255, 84, 65, 228),
                Colors.white,
              ],
              stops: const [0.0, 0.5, 1.0],
              begin: Alignment(-1.0 + (_controller.value * 2), 0.0),
              end: Alignment(1.0 + (_controller.value * 2), 0.0),
            ).createShader(bounds);
          },
          child: Text(
            widget.text,
            style: widget.textStyle.copyWith(color: Colors.white),
          ),
        );
      },
    );
  }
}
