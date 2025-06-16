import 'package:get/get.dart';
import 'package:langtest_pro/res/routes/routes_name.dart';
import 'package:langtest_pro/view/auth/login_screen.dart';
import 'package:langtest_pro/view/home/home_screen.dart';
import 'package:langtest_pro/view/profile/user_info_screen.dart';
import 'package:langtest_pro/view/splash/splash_screen.dart';

class AppRoutes {
  static appRoutes() => [
    GetPage(name: RoutesName.splashScreen, page: () => const SplashScreen()),

    GetPage(name: RoutesName.loginScreen, page: () => LoginScreen()),

    GetPage(
      name: RoutesName.userDetailsScreen,
      page: () => UserInfoScreen(userCred: Get.arguments),
    ),

    GetPage(name: RoutesName.homeScreen, page: () => const HomeScreen()),
  ];
}
