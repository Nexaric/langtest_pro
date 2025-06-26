import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:intl/intl.dart';
import 'package:langtest_pro/res/colors/app_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Utils {


   static void navigateTo(BuildContext context, Widget screen) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => screen));
  }

  static snakBar(String title, String message) {
    Get.snackbar(title, message,colorText: AppColors.whiteColor);
  }

   static String formatDate(DateTime date) {
    return DateFormat('dd-MM-yyyy').format(date);
  }

  // Convert DateTime to "HH:mm:ss" format
  static String formatTime(DateTime time) {
    return DateFormat('HH:mm:ss').format(time);
  }

   static Future<void> saveString(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  // Retrieve a String from local storage
  static Future<String?> getString(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  // Clear Local Storage
  static Future<void> clearStorage() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
  

}
