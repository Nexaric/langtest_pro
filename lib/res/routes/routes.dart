import 'package:get/get.dart';
import 'package:langtest_pro/res/routes/routes_name.dart';
import 'package:langtest_pro/view/auth/login_screen.dart';
import 'package:langtest_pro/view/home/home_screen.dart';
import 'package:langtest_pro/view/profile/user_info_screen.dart';
import 'package:langtest_pro/view/splash/splash_screen.dart';
import 'package:langtest_pro/view/subscriptions/subscription_screen.dart';
import 'package:langtest_pro/view/payment/payment_screen.dart';
import 'package:langtest_pro/view/payment/payment_successful.dart';
import 'package:langtest_pro/view/subscriptions/subscription_status.dart';

class AppRoutes {
  static appRoutes() => [
    GetPage(name: RoutesName.splashScreen, page: () => const SplashScreen()),
    GetPage(name: RoutesName.loginScreen, page: () => const LoginScreen()),
    GetPage(
      name: RoutesName.userDetailsScreen,
      page: () => UserInfoScreen(userCred: Get.arguments),
    ),
    GetPage(name: RoutesName.homeScreen, page: () => const HomeScreen()),
    GetPage(
      name: RoutesName.subscriptionScreen,
      page: () => const SubscriptionScreen(),
    ),
    GetPage(
      name: RoutesName.paymentScreen,
      page: () => PaymentScreen(price: Get.arguments['price']),
    ),
    GetPage(
      name: RoutesName.paymentSuccessfulScreen,
      page: () => const PaymentSuccessfulScreen(),
    ),
    GetPage(
      name: RoutesName.subscriptionStatusScreen,
      page: () => const SubscriptionStatusScreen(),
    ),
  ];
}
