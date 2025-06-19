/*import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SubscriptionController extends GetxController {
  // Current subscription data
  var isActive = true.obs;
  var currentPlan = 'Monthly'.obs;
  var daysLeft = 15.obs;
  var expiryDate = ''.obs;

  // Available plans
  final List<Map<String, dynamic>> plans = [
    {
      'title': 'Monthly',
      'price': '₹99',
      'period': '/month',
      'description': 'Billed monthly',
      'isRecommended': false,
    },
    {
      'title': 'Yearly',
      'price': '₹599',
      'period': '/year',
      'description': 'Billed yearly (Save 40%)',
      'isRecommended': true,
    },
    {
      'title': 'Lifetime',
      'price': '₹1599',
      'period': '',
      'description': 'One-time payment',
      'isRecommended': false,
    },
  ];

  @override
  void onInit() {
    super.onInit();
    _calculateExpiryDate();
  }

  void _calculateExpiryDate() {
    final now = DateTime.now();
    final expiry = now.add(Duration(days: daysLeft.value));
    expiryDate.value = '${expiry.day}/${expiry.month}/${expiry.year}';
  }

  void upgradePlan(String newPlan, String newPrice) {
    currentPlan.value = newPlan;

    // Update days left based on new plan
    if (newPlan == 'Monthly') {
      daysLeft.value = 30;
    } else if (newPlan == 'Yearly') {
      daysLeft.value = 365;
    } else {
      daysLeft.value = 9999; // Lifetime
    }

    _calculateExpiryDate();

    Get.snackbar(
      'Plan Upgraded',
      'You have successfully upgraded to $newPlan plan',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }
}*/
