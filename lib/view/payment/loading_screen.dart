import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart'; // Add for date formatting
import 'package:langtest_pro/res/routes/routes_name.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args =
        Get.arguments ??
        {
          'price': '₹99',
          'plan': 'Monthly',
          'duration': const Duration(days: 30),
        };
    final DateTime? newExpiryDate = args['newExpiryDate']; // Add newExpiryDate

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(seconds: 2), () {
        Get.offNamed(
          RoutesName.paymentSuccessfulScreen,
          arguments: args, // Pass all arguments including newExpiryDate
        );
      });
    });

    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF3E1E68), Color(0xFF6A5AE0)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/shopping_cart_animation.png',
                  height: 150.h,
                  width: 150.w,
                ),
                SizedBox(height: 30.h),
                Text(
                  'Confirming Payment',
                  style: GoogleFonts.montserrat(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 10.h),
                Text(
                  'This will only take a few seconds.',
                  style: GoogleFonts.montserrat(
                    fontSize: 16.sp,
                    color: Colors.white70,
                  ),
                ),
                if (newExpiryDate != null) // Display new expiry date
                  Padding(
                    padding: EdgeInsets.only(top: 10.h),
                    child: Text(
                      'New Expiry: ${DateFormat('MMM d, y').format(newExpiryDate)}',
                      style: GoogleFonts.montserrat(
                        fontSize: 14.sp,
                        color: Colors.white70,
                      ),
                    ),
                  ),
                SizedBox(height: 50.h),
                Image.asset('assets/razorpay_logo.png', height: 30.h),
                SizedBox(height: 5.h),
                Text(
                  'Secured by Razorpay',
                  style: GoogleFonts.montserrat(
                    fontSize: 14.sp,
                    color: Colors.white70,
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
