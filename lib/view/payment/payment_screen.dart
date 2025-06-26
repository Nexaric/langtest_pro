import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:langtest_pro/res/routes/routes_name.dart';

class PaymentScreen extends StatelessWidget {
  const PaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args =
        Get.arguments ??
        {
          'price': '₹99',
          'plan': 'Monthly',
          'duration': const Duration(days: 30),
        };
    final String price = args['price'];
    final TextEditingController upiIdController = TextEditingController(
      text: 'gauravkumar@okhdfcbank',
    );
    final isLoading = ValueNotifier<bool>(false);

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
          child: Column(
            children: [
              AppBar(
                elevation: 0,
                backgroundColor: Colors.transparent,
                title: Text(
                  'Payment',
                  style: GoogleFonts.montserrat(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                centerTitle: true,
                automaticallyImplyLeading: false, // Remove back icon
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'UPI',
                        style: GoogleFonts.montserrat(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 30.h),
                      Text(
                        'UPI Apps',
                        style: GoogleFonts.montserrat(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 10.h),
                      LayoutBuilder(
                        builder: (context, constraints) {
                          final itemWidth = (constraints.maxWidth / 2) - 10.w;
                          return Wrap(
                            spacing: 20.w,
                            runSpacing: 10.h,
                            children: [
                              _buildUpiAppButton(
                                'Google Pay',
                                'assets/google_pay_logo.png',
                                itemWidth,
                              ),
                              _buildUpiAppButton(
                                'PhonePe',
                                'assets/phonepe_logo.png',
                                itemWidth,
                              ),
                              _buildUpiAppButton(
                                'PayTM',
                                'assets/paytm_logo.png',
                                itemWidth,
                              ),
                              _buildUpiAppButton(
                                'BHIM',
                                'assets/bhim_logo.png',
                                itemWidth,
                              ),
                            ],
                          );
                        },
                      ),
                      SizedBox(height: 30.h),
                      Text(
                        'UPI ID / Number',
                        style: GoogleFonts.montserrat(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.white.withOpacity(0.5),
                          ),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: TextField(
                          controller: upiIdController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            suffixIcon: Icon(
                              Icons.copy,
                              color: Colors.white70,
                              size: 20.sp,
                            ),
                          ),
                          style: GoogleFonts.montserrat(
                            fontSize: 14.sp,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              _buildBottomBar(context, price, isLoading),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUpiAppButton(String title, String imagePath, double itemWidth) {
    return SizedBox(
      width: itemWidth,
      child: OutlinedButton(
        onPressed: () {
          debugPrint('$title clicked!');
        },
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 15.h),
          side: BorderSide(color: Colors.white.withOpacity(0.5)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.r),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(imagePath, height: 24.h, width: 24.w),
            SizedBox(width: 8.w),
            Text(
              title,
              style: GoogleFonts.montserrat(
                fontSize: 14.sp,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomBar(
    BuildContext context,
    String price,
    ValueNotifier<bool> isLoading,
  ) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2.w,
            blurRadius: 5.w,
            offset: Offset(0, -3.h),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                price,
                style: GoogleFonts.montserrat(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: Row(
                  children: [
                    Text(
                      'View Details',
                      style: GoogleFonts.montserrat(
                        fontSize: 14.sp,
                        color: Colors.grey,
                      ),
                    ),
                    Icon(
                      Icons.keyboard_arrow_up,
                      color: Colors.grey,
                      size: 16.sp,
                    ),
                  ],
                ),
              ),
            ],
          ),
          ValueListenableBuilder<bool>(
            valueListenable: isLoading,
            builder: (context, loading, child) {
              return ElevatedButton(
                onPressed:
                    loading
                        ? null
                        : () {
                          isLoading.value = true;
                          Future.delayed(const Duration(seconds: 2), () {
                            isLoading.value = false;
                            Get.toNamed(
                              RoutesName.loadingScreen,
                              arguments: Get.arguments, // Pass plan details
                            );
                          });
                        },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0D47A1),
                  padding: EdgeInsets.symmetric(
                    horizontal: 50.w,
                    vertical: 15.h,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
                child:
                    loading
                        ? SizedBox(
                          width: 40.w,
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: const [_Dot(), _Dot(), _Dot()],
                            ),
                          ),
                        )
                        : Text(
                          'Continue',
                          style: GoogleFonts.montserrat(
                            color: Colors.white,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _Dot extends StatefulWidget {
  const _Dot();

  @override
  State<_Dot> createState() => _DotState();
}

class _DotState extends State<_Dot> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Opacity(
          opacity: _animation.value,
          child: Container(
            width: 8.w,
            height: 8.h,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          ),
        );
      },
    );
  }
}
