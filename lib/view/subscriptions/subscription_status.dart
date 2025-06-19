import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class SubscriptionStatusScreen extends StatelessWidget {
  const SubscriptionStatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Current subscription data
    final expiryDate = DateTime.now().add(const Duration(days: 30));
    const currentPlan = 'Monthly';
    const currentPrice = '₹99';
    const isActive = true;
    const isLifetime = false;

    // Available plans
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
      {
        'title': 'Lifetime',
        'price': '₹1999',
        'period': '',
        'duration': const Duration(days: 365 * 100),
        'description': 'One-time payment',
        'isRecommended': false,
      },
    ];

    void extendSubscription(Duration duration) {
      DateTime newExpiryDate;
      String newPlan;
      String newPrice;
      bool newIsLifetime;

      if (duration.inDays > 365 * 50) {
        newExpiryDate = DateTime.now().add(Duration(days: 365 * 100));
        newPlan = 'Lifetime';
        newPrice = '₹1999';
        newIsLifetime = true;
      } else {
        final extendFrom =
            expiryDate.isAfter(DateTime.now()) ? expiryDate : DateTime.now();
        newExpiryDate = extendFrom.add(duration);
        newIsLifetime = false;
        if (duration.inDays >= 365) {
          newPlan = 'Yearly';
          newPrice = '₹599';
        } else {
          newPlan = 'Monthly';
          newPrice = '₹99';
        }
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            newIsLifetime
                ? 'Lifetime subscription activated!'
                : 'Subscription extended to ${DateFormat('MMM d, y').format(newExpiryDate)}',
          ),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
        ),
      );
    }

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
                title: Text(
                  'Subscription Status',
                  style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    fontSize: 20.sp,
                  ),
                ),
                centerTitle: true,
                elevation: 0,
                backgroundColor: Colors.transparent,
                iconTheme: const IconThemeData(color: Colors.white),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(20.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.all(20.w),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16.r),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.2),
                          ),
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
                                          isActive
                                              ? Colors.green[200]
                                              : Colors.grey[200],
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                        isLifetime
                                            ? 'Lifetime'
                                            : DateFormat(
                                              'MMM d, y',
                                            ).format(expiryDate),
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
                      if (!isLifetime) ...[
                        SizedBox(height: 32.h),
                        Text(
                          'Extend Your Plan',
                          style: GoogleFonts.montserrat(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 12.h),
                        Text(
                          'Choose a plan to add to your current subscription',
                          style: GoogleFonts.montserrat(
                            fontSize: 14.sp,
                            color: Colors.white.withOpacity(0.7),
                          ),
                        ),
                        SizedBox(height: 20.h),
                        ...plans.map(
                          (plan) => _buildPlanCard(plan, extendSubscription),
                        ),
                        SizedBox(height: 24.h),
                        Text(
                          'Your subscription will automatically renew unless canceled at least 24 hours before the end of the current period.',
                          style: GoogleFonts.montserrat(
                            fontSize: 12.sp,
                            color: Colors.white.withOpacity(0.5),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlanCard(
    Map<String, dynamic> plan,
    Function(Duration) extendSubscription,
  ) {
    final bool isLifetimePlan = plan['duration'].inDays > 365 * 50;

    return GestureDetector(
      onTap: () => extendSubscription(plan['duration']),
      child: Container(
        margin: EdgeInsets.only(bottom: 16.h),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color:
                plan['isRecommended']
                    ? Colors.white
                    : Colors.white.withOpacity(0.2),
            width: plan['isRecommended'] ? 1.5.w : 1.w,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    plan['title'],
                    style: GoogleFonts.montserrat(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    plan['description'],
                    style: GoogleFonts.montserrat(
                      fontSize: 13.sp,
                      color: Colors.white.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (plan['isRecommended'])
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                    child: Text(
                      'SAVE ${plan['title'] == 'Yearly' ? '40%' : ''}',
                      style: GoogleFonts.montserrat(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                if (plan['isRecommended']) SizedBox(height: 6.h),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      plan['price'],
                      style: GoogleFonts.montserrat(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    if (!isLifetimePlan)
                      Text(
                        plan['period'],
                        style: GoogleFonts.montserrat(
                          fontSize: 14.sp,
                          color: Colors.white.withOpacity(0.7),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
