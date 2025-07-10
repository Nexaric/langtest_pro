import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:langtest_pro/controller/payments/payment_controller.dart';
import 'package:langtest_pro/model/payments_model.dart';
import 'package:langtest_pro/utils/utils.dart';
import 'package:langtest_pro/view/home/home_screen.dart';
import 'package:langtest_pro/view/profile/profile_screen.dart';
import 'package:langtest_pro/view/subscriptions/onetime_offer.dart';
import 'package:langtest_pro/view/subscriptions/offer_timer_manager.dart';

class SubscriptionScreen extends StatelessWidget {
  const SubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final pageController = PageController(
      initialPage: 1,
    ); // Subscription is index 1
    final notchController = NotchBottomBarController(index: 1);
    final selectedPlanIndex = ValueNotifier<int>(0); // Default to Monthly plan
    final appBarTitle = ValueNotifier<String>('Subscription'); // Dynamic title

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
          child: Column(
            children: [
              ValueListenableBuilder<String>(
                valueListenable: appBarTitle,
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
                    automaticallyImplyLeading: false, // Remove back icon
                  );
                },
              ),
              Expanded(
                child: PageView(
                  controller: pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  onPageChanged: (index) {
                    notchController.index = index;
                    appBarTitle.value =
                        index == 0
                            ? 'Home'
                            : index == 1
                            ? 'Subscription'
                            : 'Profile';
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
      ),
      bottomNavigationBar: AnimatedNotchBottomBar(
        notchBottomBarController: notchController,
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
          notchController.index = index;
          pageController.jumpToPage(index);
        },
        kIconSize: 24.sp,
        kBottomRadius: 0,
      ),
    );
  }
}

class SubscriptionContent extends StatelessWidget {
  const SubscriptionContent({super.key});

  @override
  Widget build(BuildContext context) {
    final payController = Get.put(PaymentController());
    final selectedPlanIndex = ValueNotifier<int>(0); // Default to Monthly plan

    return SingleChildScrollView(
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
            style: GoogleFonts.montserrat(
              color: Colors.white,
              fontSize: 28.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Unlock all features',
            style: GoogleFonts.montserrat(
              color: Colors.white.withOpacity(0.7),
              fontSize: 16.sp,
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
                    title: 'Monthly',
                    description: 'Billed monthly',
                    price: '₹99',
                    pricePeriod: '/month',
                    isRecommended: true,
                    isSelected: value == 0,
                    onTap: () => selectedPlanIndex.value = 0,
                  ),
                  SizedBox(height: 16.h),
                  _buildPlanOption(
                    context,
                    index: 1,
                    title: 'Yearly',
                    description: 'Billed yearly (Save 40%)',
                    price: '₹599',
                    pricePeriod: '/year',
                    isRecommended: false,
                    isSelected: value == 1,
                    onTap: () => selectedPlanIndex.value = 1,
                  ),

                  SizedBox(height: 20.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    child: SizedBox(
                      width: double.infinity,
                      height: 55.h,
                      child: Obx(
                        () =>
                            payController.isLoading.value
                                ? Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.blueAccent,
                                  ),
                                )
                                : ElevatedButton(
                                  onPressed: () async {
                                    final phone = await Utils.getString(
                                      'phone',
                                    );
                                    final email = await Utils.getString(
                                      'email',
                                    );
                                    final amount =
                                        _getPlanPriceText(
                                          selectedPlanIndex.value,
                                        ) *
                                        100;

                                    final String period =
                                        selectedPlanIndex.value == 0
                                            ? 'monthly'
                                            : 'yearly';

                                    final model = PaymentModel(
                                      key:
                                          'rzp_test_7iG4y8agXMTCV0', // replace with your key
                                      amount: amount, // ₹1.00
                                      name: 'LangTest Pro',
                                      description: 'IELTS Practice Cource',
                                      retry: {'enabled': true, 'max_count': 1},
                                      sendSmsHash: true,
                                      prefill: {
                                        'contact': phone ?? '',
                                        'email': email ?? "",
                                      },
                                      paymentModelExternal: {
                                        'wallets': ['paytm'],
                                      },
                                    );
                                    payController.makePayment(
                                      model: model,
                                      period: period,
                                    );

                                    //   final planDetails =
                                    //       value == 0
                                    //           ? {
                                    //             'price': '₹99',
                                    //             'plan': 'Monthly',
                                    //             'duration': const Duration(days: 30),
                                    //           }
                                    //           : {
                                    //             'price': '₹599',
                                    //             'plan': 'Yearly',
                                    //             'duration': const Duration(days: 365),
                                    //           };
                                    //   Get.toNamed(
                                    //     RoutesName.paymentScreen,
                                    //     arguments: planDetails,
                                    //   );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF6B48EE),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12.r),
                                    ),
                                  ),
                                  child: Text(
                                    'Continue with ${_getPlanPriceText(value)}',
                                    style: GoogleFonts.montserrat(
                                      color: Colors.white,
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
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
    );
  }

  int _getPlanPriceText(int index) {
    switch (index) {
      case 0:
        return 99;
      case 1:
        return 599;
      default:
        return 99;
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
                      style: GoogleFonts.montserrat(
                        color: Colors.white,
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      description,
                      style: GoogleFonts.montserrat(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 14.sp,
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
                        style: GoogleFonts.montserrat(
                          color: Colors.white,
                          fontSize: 10.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  if (isRecommended) SizedBox(height: 4.h),
                  Row(
                    children: [
                      Text(
                        price,
                        style: GoogleFonts.montserrat(
                          color: Colors.white,
                          fontSize: 22.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        pricePeriod,
                        style: GoogleFonts.montserrat(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 18.sp,
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
