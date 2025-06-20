import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:langtest_pro/res/routes/routes_name.dart';
import 'package:langtest_pro/view/subscriptions/offer_timer_manager.dart';

class OneTimeOfferPopup extends StatefulWidget {
  final VoidCallback onClose;

  const OneTimeOfferPopup({super.key, required this.onClose});

  @override
  State<OneTimeOfferPopup> createState() => _OneTimeOfferPopupState();
}

class _OneTimeOfferPopupState extends State<OneTimeOfferPopup>
    with TickerProviderStateMixin {
  late AnimationController _openAnimationController;
  late Animation<double> _scaleAnimation;
  final String _offerPrice = '₹49'; // Define the offer price
  bool _isTimerActive = false; // Track timer state to prevent recursion

  @override
  void initState() {
    super.initState();
    // Setup for popup opening animation
    _openAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _openAnimationController,
        curve: Curves.easeOutBack,
      ),
    );
    _openAnimationController.forward();

    // Start countdown only if not already active
    if (!_isTimerActive) {
      _isTimerActive = true;
      OfferTimerManager().startCountdown(
        onUpdate: () {
          if (mounted && _isTimerActive) {
            setState(() {}); // Update UI for timer changes
            if (OfferTimerManager().isOfferExpired) {
              _isTimerActive = false;
              widget.onClose(); // Notify parent when timer ends
              if (mounted && Navigator.of(context).canPop()) {
                Navigator.of(context).pop(); // Auto-dismiss popup
              }
            }
          }
        },
      );
    }
  }

  @override
  void dispose() {
    _isTimerActive = false; // Ensure timer stops on dispose
    OfferTimerManager().stopCountdown();
    _openAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int minutes = (OfferTimerManager().remainingSeconds ~/ 60) % 60;
    int seconds = OfferTimerManager().remainingSeconds % 60;

    const List<Color> mainGradientColors = [
      Color(0xFF3E1E68),
      Color(0xFF6A5AE0),
    ];

    return Center(
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.symmetric(horizontal: 20.w),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20.r),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
              child: Container(
                width: 0.9.sw, // 90% of screen width
                constraints: BoxConstraints(
                  maxHeight: 0.6.sh, // Max 60% of screen height
                  minHeight: 300.h, // Minimum height for content
                ),
                padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 20.h),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.2),
                    width: 1.5.w,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10.w,
                      spreadRadius: 2.w,
                      offset: Offset(0, 5.h),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    Positioned(
                      top: 0,
                      right: 0,
                      child: IconButton(
                        icon: Icon(
                          Icons.close,
                          color: Colors.white70,
                          size: 24.sp,
                        ),
                        onPressed: () {
                          _isTimerActive = false;
                          OfferTimerManager().stopCountdown(); // Stop timer
                          widget.onClose(); // Notify parent
                          if (Navigator.of(context).canPop()) {
                            Navigator.of(context).pop(); // Dismiss dialog
                          }
                        },
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(height: 20.h),
                        Text(
                          'One Time Offer',
                          style: GoogleFonts.montserrat(
                            fontSize: 26.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          '50% OFF',
                          style: GoogleFonts.montserrat(
                            fontSize: 36.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 20.h),
                        Text(
                          'Limited Time Offer',
                          style: GoogleFonts.montserrat(
                            fontSize: 14.sp,
                            color: Colors.white70,
                          ),
                        ),
                        SizedBox(height: 10.h),
                        _buildTimerRow(minutes, seconds),
                        SizedBox(height: 25.h),
                        _buildPriceComparison(),
                        SizedBox(height: 30.h),
                        _buildClaimOfferButton(mainGradientColors, context),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTimerRow(int minutes, int seconds) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildTimerDigit((minutes ~/ 10).toString()),
        _buildTimerDigit((minutes % 10).toString()),
        Text(
          ':',
          style: GoogleFonts.montserrat(fontSize: 24.sp, color: Colors.white70),
        ),
        _buildTimerDigit((seconds ~/ 10).toString()),
        _buildTimerDigit((seconds % 10).toString()),
      ],
    );
  }

  Widget _buildTimerDigit(String digit) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Text(
        digit,
        style: GoogleFonts.montserrat(
          fontSize: 24.sp,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildPriceComparison() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(15.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Original Price',
                  style: GoogleFonts.montserrat(
                    fontSize: 16.sp,
                    color: Colors.white70,
                  ),
                ),
                SizedBox(height: 5.h),
                Text(
                  '₹99',
                  style: GoogleFonts.montserrat(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    decoration: TextDecoration.lineThrough,
                    decorationColor: Colors.white,
                    decorationThickness: 2,
                  ),
                ),
                Text(
                  'per month',
                  style: GoogleFonts.montserrat(
                    fontSize: 12.sp,
                    color: Colors.white54,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: Icon(
              Icons.arrow_forward,
              color: Colors.white70,
              size: 30.sp,
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Offer Price',
                  style: GoogleFonts.montserrat(
                    fontSize: 16.sp,
                    color: Colors.white70,
                  ),
                ),
                SizedBox(height: 5.h),
                Text(
                  _offerPrice,
                  style: GoogleFonts.montserrat(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'per month',
                  style: GoogleFonts.montserrat(
                    fontSize: 12.sp,
                    color: Colors.white54,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClaimOfferButton(
    List<Color> gradientColors,
    BuildContext context,
  ) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30.r),
        gradient: LinearGradient(
          colors: gradientColors,
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6A5AE0).withOpacity(0.5),
            blurRadius: 10.w,
            spreadRadius: 1.w,
            offset: Offset(0, 5.h),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(30.r),
          onTap: () {
            _isTimerActive = false;
            OfferTimerManager().stopCountdown(); // Stop timer
            widget.onClose(); // Notify parent
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop(); // Dismiss dialog
            }
            Get.toNamed(
              RoutesName.paymentScreen,
              arguments: {
                'price': _offerPrice,
                'plan': 'One-Time Offer',
                'duration': const Duration(days: 30),
              },
            );
          },
          child: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 15.h),
              child: Text(
                'Buy Now',
                style: GoogleFonts.montserrat(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
