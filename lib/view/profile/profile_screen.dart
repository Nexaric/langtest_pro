import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import 'package:get/get.dart';
import 'package:langtest_pro/controller/profile/profile_controller.dart';
import 'package:langtest_pro/core/loading/loader_screen.dart';
import 'package:langtest_pro/res/routes/routes_name.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});

  final ProfileController profileController = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    // Initialize profile data after first frame is rendered
    WidgetsBinding.instance.addPostFrameCallback((_) {
     
        profileController.getProfile();
      
    });

    return Scaffold(
      body: Obx(() {
        if (profileController.isLoading.value) {
          return const LoaderScreen();
        }

        final userData = profileController.userData.value;
        if (userData == null) {
          return Center(
            child: Text(
              'No profile data available',
              style: GoogleFonts.poppins(color: Colors.white),
            ),
          );
        }

        return Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF3E1E68), Color(0xFF6A5AE0)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 220.h,
                floating: false,
                pinned: true,
                backgroundColor: Colors.transparent,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    child: SafeArea(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(height: 30.h),
                          Bounce(
                            infinite: true,
                            from: 10,
                            duration: const Duration(seconds: 2),
                            child: ZoomIn(
                              child: Container(
                                width: 100.w,
                                height: 100.h,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      blurRadius: 10.w,
                                      spreadRadius: 2.w,
                                    ),
                                  ],
                                ),
                                child: ClipOval(
                                  child: Image.asset(
                                    "assets/profile/avatar.png",
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 16.h),
                          FadeInDown(
                            child: Text(
                              userData.firstName,
                              style: GoogleFonts.poppins(
                                fontSize: 22.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          FadeInUp(
                            child: Text(
                              userData.email,
                              style: GoogleFonts.poppins(
                                fontSize: 14.sp,
                                color: Colors.white.withOpacity(0.9),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.only(
                    top: 20.h,
                    left: 20.w,
                    right: 20.w,
                    bottom: 20.h,
                  ),
                  child: Column(
                    children: [
                      SlideInLeft(
                        child: Row(
                          children: [
                            Expanded(
                              child: _buildQuickAction(
                                icon: Icons.edit,
                                label: "Edit",
                                color: Colors.white,
                                iconColor: const Color(0xFF3E1E68),
                                onTap: () => Get.toNamed(
                                  RoutesName.editProfileScreen,
                                  arguments: userData,
                                ),
                              ),
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: _buildQuickAction(
                                icon: Icons.settings,
                                label: "Settings",
                                color: Colors.white,
                                iconColor: const Color(0xFF3E1E68),
                                onTap: () => Get.toNamed(
                                  RoutesName.notificationSettingsScreen,
                                ),
                              ),
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: _buildQuickAction(
                                icon: Icons.book,
                                label: "Courses",
                                color: Colors.white,
                                iconColor: const Color(0xFF3E1E68),
                                onTap: () => Get.toNamed(
                                  RoutesName.myCoursesScreen,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 30.h),
                      SlideInRight(
                        child: Column(
                          children: [
                            _buildModernCard(
                              title: "Support",
                              children: [
                                _buildListTile(
                                  icon: Icons.help_outline,
                                  title: "Help Center",
                                  subtitle: "Get assistance",
                                  color: const Color(0xFF9C27B0),
                                  onTap: () => Get.toNamed(
                                    RoutesName.helpSupportScreen,
                                  ),
                                ),
                                _buildListTile(
                                  icon: Icons.privacy_tip,
                                  title: "Privacy Policy",
                                  subtitle: "Read our terms",
                                  color: const Color(0xFF3F51B5),
                                  onTap: () => Get.toNamed(
                                    RoutesName.termsPoliciesScreen,
                                  ),
                                ),
                                _buildListTile(
                                  icon: Icons.report,
                                  title: "Report Issue",
                                  subtitle: "Found a problem?",
                                  color: const Color(0xFFF44336),
                                  onTap: () => Get.toNamed(
                                    RoutesName.reportProblemScreen,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 30.h),
                      FadeInUp(
                        child: SizedBox(
                          width: double.infinity,
                          child: OutlinedButton(
                            onPressed: () {
                              // Handle logout
                              Get.snackbar(
                                'Logout',
                                'Logged out successfully!',
                                backgroundColor: const Color(0xFF3E1E68),
                                colorText: Colors.white,
                              );
                            },
                            style: OutlinedButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 16.h),
                              side: const BorderSide(color: Colors.white),
                              backgroundColor: Colors.white.withOpacity(0.1),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                            ),
                            child: Text(
                              "Logout",
                              style: GoogleFonts.poppins(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildQuickAction({
    required IconData icon,
    required String label,
    required Color color,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16.h),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10.w,
              offset: Offset(0, 4.h),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: iconColor, size: 24.sp),
            SizedBox(height: 8.h),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: iconColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModernCard({
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.white.withOpacity(0.3), width: 1.w),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 15.w,
            offset: Offset(0, 5.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 8.h),
            child: Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
          ...children,
        ],
      ),
    );
  }

  Widget _buildListTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        width: 40.w,
        height: 40.h,
        decoration: BoxDecoration(
          color: color.withOpacity(0.2),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: color, size: 20.sp),
      ),
      title: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 15.sp,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: GoogleFonts.poppins(
          fontSize: 12.sp,
          color: Colors.white.withOpacity(0.7),
        ),
      ),
      trailing: Icon(
        Icons.chevron_right,
        color: Colors.white.withOpacity(0.6),
        size: 20.sp,
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
    );
  }
}