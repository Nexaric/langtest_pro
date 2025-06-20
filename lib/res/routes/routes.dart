import 'package:get/get.dart';
import 'package:langtest_pro/res/routes/routes_name.dart';
import 'package:langtest_pro/view/auth/login_screen.dart';
import 'package:langtest_pro/view/home/home_screen.dart';
import 'package:langtest_pro/view/home/side_menu/about_us.dart';
import 'package:langtest_pro/view/home/side_menu/rate_our_app.dart';
import 'package:langtest_pro/view/home/side_menu/share_app.dart';
import 'package:langtest_pro/view/profile/edit_profile.dart';
import 'package:langtest_pro/view/profile/my_courses.dart';
import 'package:langtest_pro/view/profile/notifications_settings.dart';
import 'package:langtest_pro/view/profile/preferences_screen.dart';
import 'package:langtest_pro/view/profile/profile_screen.dart';
import 'package:langtest_pro/view/profile/Help%20&%20Support/help_support.dart';
import 'package:langtest_pro/view/profile/Help%20&%20Support/report_problem.dart';
import 'package:langtest_pro/view/profile/Help%20&%20Support/terms_policies.dart';
import 'package:langtest_pro/view/profile/user_info_screen.dart';
import 'package:langtest_pro/view/splash/splash_screen.dart';
import 'package:langtest_pro/view/subscriptions/subscription_screen.dart';
import 'package:langtest_pro/view/payment/loading_screen.dart';
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
    GetPage(name: RoutesName.paymentScreen, page: () => const PaymentScreen()),
    GetPage(name: RoutesName.loadingScreen, page: () => const LoadingScreen()),
    GetPage(
      name: RoutesName.paymentSuccessfulScreen,
      page: () => const PaymentSuccessfulScreen(),
    ),
    GetPage(
      name: RoutesName.subscriptionStatusScreen,
      page: () => const SubscriptionStatusScreen(),
    ),
    GetPage(name: RoutesName.profileScreen, page: () => const ProfileScreen()),
    GetPage(
      name: RoutesName.editProfileScreen,
      page: () => const EditProfileScreen(),
    ),
    GetPage(
      name: RoutesName.myCoursesScreen,
      page: () => const MyCoursesScreen(),
    ),
    GetPage(
      name: RoutesName.notificationSettingsScreen,
      page: () => const NotificationSettingsScreen(),
    ),
    GetPage(
      name: RoutesName.preferencesScreen,
      page: () => const PreferencesScreen(),
    ),
    GetPage(
      name: RoutesName.helpSupportScreen,
      page: () => const HelpSupportScreen(),
    ),
    GetPage(
      name: RoutesName.reportProblemScreen,
      page: () => const ReportProblemScreen(),
    ),
    GetPage(
      name: RoutesName.termsPoliciesScreen,
      page: () => const TermsPoliciesScreen(),
    ),
    GetPage(
      name: RoutesName.shareAppScreen,
      page: () => const ShareAppScreen(),
    ),
    GetPage(
      name: RoutesName.rateOurAppScreen,
      page: () => const RateOurAppScreen(),
    ),
    GetPage(name: RoutesName.aboutUsScreen, page: () => const AboutUsScreen()),
  ];
}
