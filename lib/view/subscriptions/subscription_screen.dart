import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:langtest_pro/res/routes/routes_name.dart';
import 'package:langtest_pro/view/subscriptions/onetime_offer.dart';
import 'package:langtest_pro/view/subscriptions/offer_timer_manager.dart';

class SubscriptionScreen extends StatelessWidget {
  const SubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<int> selectedPlanIndex = ValueNotifier<int>(
      1,
    ); // Default to Monthly plan

    void showOfferPopup() {
      if (OfferTimerManager().isOfferExpired) return;
      OfferTimerManager().startCountdown(onUpdate: () {});
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return OneTimeOfferPopup(
            onClose: () {
              OfferTimerManager().stopCountdown();
            },
          );
        },
      );
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      showOfferPopup();
    });

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
          child: SingleChildScrollView(
            padding: EdgeInsets.only(bottom: 20.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 20.h),
                Icon(
                  Icons.card_giftcard,
                  color: Colors.white.withOpacity(0.8),
                  size: 80.sp,
                ),
                SizedBox(height: 20.h),
                Text(
                  'Choose your plan',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28.sp,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Montserrat',
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  '3 DAY FREE TRIAL',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 16.sp,
                    fontFamily: 'Montserrat',
                  ),
                ),
                SizedBox(height: 40.h),
                ValueListenableBuilder<int>(
                  valueListenable: selectedPlanIndex,
                  builder: (context, value, child) {
                    return Column(
                      children: [
                        _buildPlanOption(
                          context,
                          index: 0,
                          title: '3 days',
                          description: 'Billed monthly no trial',
                          price: '₹FREE',
                          pricePeriod: '/Trial',
                          isRecommended: false,
                          isSelected: value == 0,
                          onTap: () => selectedPlanIndex.value = 0,
                        ),
                        SizedBox(height: 16.h),
                        _buildPlanOption(
                          context,
                          index: 1,
                          title: 'Monthly',
                          description: 'Billed monthly no trial',
                          price: '₹99',
                          pricePeriod: '/month',
                          isRecommended: true,
                          isSelected: value == 1,
                          onTap: () => selectedPlanIndex.value = 1,
                        ),
                        SizedBox(height: 16.h),
                        _buildPlanOption(
                          context,
                          index: 2,
                          title: 'Yearly',
                          description: 'Billed yearly no trial',
                          price: '₹599',
                          pricePeriod: '/year',
                          isRecommended: false,
                          isSelected: value == 2,
                          onTap: () => selectedPlanIndex.value = 2,
                        ),
                        SizedBox(height: 20.h),
                        Text(
                          'Cancel anytime in the App store',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.6),
                            fontSize: 14.sp,
                            fontFamily: 'Montserrat',
                          ),
                        ),
                        SizedBox(height: 20.h),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 24.w),
                          child: SizedBox(
                            width: double.infinity,
                            height: 55.h,
                            child: ElevatedButton(
                              onPressed: () {
                                String price;
                                switch (value) {
                                  case 0:
                                    price = 'FREE';
                                    break;
                                  case 1:
                                    price = '₹99';
                                    break;
                                  case 2:
                                    price = '₹599';
                                    break;
                                  default:
                                    price = '₹99';
                                }
                                Get.toNamed(
                                  RoutesName.paymentScreen,
                                  arguments: {'price': price},
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF6B48EE),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                              ),
                              child: Text(
                                value == 0
                                    ? 'Continue with FREE trial'
                                    : 'Continue with ${_getPlanPriceText(value)}',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Montserrat',
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getPlanPriceText(int index) {
    switch (index) {
      case 0:
        return 'FREE trial';
      case 1:
        return '₹99/month';
      case 2:
        return '₹599/year';
      default:
        return '';
    }
  }

  Widget _buildPlanOption(
    BuildContext context, {
    required int index,
    required String title,
    required String description,
    required String price,
    required String pricePeriod,
    required bool isRecommended,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
          decoration: BoxDecoration(
            color:
                isSelected ? const Color(0xFF4A2F7C) : const Color(0xFF2A1C49),
            borderRadius: BorderRadius.circular(15.r),
            border:
                isSelected
                    ? Border.all(color: const Color(0xFF6B48EE), width: 3.w)
                    : Border.all(color: Colors.transparent),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Montserrat',
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      description,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 14.sp,
                        fontFamily: 'Montserrat',
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (isRecommended)
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF6B48EE),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Text(
                        'RECOMMENDED',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10.sp,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Montserrat',
                        ),
                      ),
                    ),
                  if (isRecommended) SizedBox(height: 4.h),
                  Row(
                    children: [
                      Text(
                        price,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22.sp,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Montserrat',
                        ),
                      ),
                      Text(
                        pricePeriod,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 18.sp,
                          fontFamily: 'Montserrat',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
