import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:langtest_pro/controller/auth/auth_controller.dart';
import 'package:langtest_pro/res/colors/app_colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
final authController = Get.put(AuthController());

@override
  void initState() {
    super.initState();
    authController.checkLogin();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      //you can change the body to edit the splash screen 

      
      body: Center(
        child: CircularProgressIndicator(color: AppColors.primaryColor),
      ),
    );
  }
}
