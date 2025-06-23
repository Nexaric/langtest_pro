import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:langtest_pro/res/routes/routes_name.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF3E1E68), Color(0xFF6A5AE0)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: SlideInLeft(
                  duration: const Duration(milliseconds: 500),
                  child: GlassmorphicContainer(
                    width: MediaQuery.of(context).size.width * 0.75,
                    height: MediaQuery.of(context).size.height,
                    borderRadius: 20.r,
                    blur: 20,
                    alignment: Alignment.center,
                    border: 2,
                    linearGradient: LinearGradient(
                      colors: [
                        Colors.white.withOpacity(0.2),
                        Colors.white.withOpacity(0.05),
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
                    child: Padding(
                      padding: EdgeInsets.all(20.sp),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildMenuHeader(),
                          SizedBox(height: 24.h),
                          _buildMenuOption(
                            context,
                            "🏠 Home",
                            Icons.home_filled,
                            RoutesName.homeScreen,
                          ),
                          _buildMenuOption(
                            context,
                            "👤 My Profile",
                            Icons.person,
                            RoutesName.profileScreen,
                          ),
                          _buildMenuOption(
                            context,
                            "📜 Subscriptions",
                            Icons.subscriptions,
                            RoutesName.subscriptionScreen,
                          ),
                          _buildMenuOption(
                            context,
                            "📤 Share App",
                            Icons.share,
                            RoutesName.shareAppScreen,
                          ),
                          _buildMenuOption(
                            context,
                            "ℹ About Us",
                            Icons.info_outline,
                            RoutesName.aboutUsScreen,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: MediaQuery.of(context).size.width * 0.75 - 20.w,
                top: MediaQuery.of(context).size.height * 0.45,
                child: GestureDetector(
                  onTap: () => Get.back(),
                  child: Container(
                    width: 40.w,
                    height: 40.h,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white,
                      size: 20.sp,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuHeader() {
    return FadeInDown(
      child: Row(
        children: [
          CircleAvatar(
            radius: 30.r,
            backgroundColor: Colors.white.withOpacity(0.2),
            backgroundImage: const AssetImage("assets/profile/avatar.png"),
          ),
          SizedBox(width: 12.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Hello, User!",
                style: GoogleFonts.poppins(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              Text(
                "View Profile",
                style: GoogleFonts.poppins(
                  fontSize: 14.sp,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMenuOption(
    BuildContext context,
    String title,
    IconData icon,
    String route,
  ) {
    return BounceInLeft(
      child: ListTile(
        leading: Icon(icon, color: Colors.white, size: 24.sp),
        title: Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 16.sp,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        onTap: () {
          Get.offNamed(route);
        },
      ),
    );
  }
}
