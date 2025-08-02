// lib/routes.dart

import 'package:get/get.dart';
import 'package:langtest_pro/res/routes/routes_name.dart';
import 'package:langtest_pro/view/auth/login_screen.dart';
import 'package:langtest_pro/view/exams/ielts/listening/audio_lessons/audio_lessons.dart';
import 'package:langtest_pro/view/exams/ielts/listening/audio_lessons/audio_result.dart';
import 'package:langtest_pro/view/exams/ielts/listening/audio_lessons/audio_screen.dart';
import 'package:langtest_pro/view/exams/ielts/listening/practice_tests/practice_test_screen.dart';
import 'package:langtest_pro/view/home/home_screen.dart';
import 'package:langtest_pro/view/home/side_menu/about_us.dart';
import 'package:langtest_pro/view/home/side_menu/rate_our_app.dart';
import 'package:langtest_pro/view/home/side_menu/share_app.dart';
import 'package:langtest_pro/view/profile/edit_profile.dart';
import 'package:langtest_pro/view/profile/my_courses.dart';
import 'package:langtest_pro/view/profile/Help%20&%20Support/help_support.dart';
import 'package:langtest_pro/view/profile/Help%20&%20Support/report_problem.dart';
import 'package:langtest_pro/view/profile/Help%20&%20Support/terms_policies.dart';
import 'package:langtest_pro/view/profile/profile_screen.dart';
import 'package:langtest_pro/view/profile/user_info_screen.dart';
import 'package:langtest_pro/view/splash/splash_screen.dart';
import 'package:langtest_pro/view/subscriptions/subscription_screen.dart';
import 'package:langtest_pro/view/payment/loading_screen.dart';
import 'package:langtest_pro/view/payment/payment_screen.dart';
import 'package:langtest_pro/view/payment/payment_successful.dart';
import 'package:langtest_pro/view/subscriptions/subscription_status.dart';
import 'package:langtest_pro/view/exams/ielts/ielts_listening.dart';
import 'package:langtest_pro/view/exams/ielts/listening/feedback.dart';
import 'package:langtest_pro/view/exams/ielts/listening/strategies_tips.dart';

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
    GetPage(name: RoutesName.profileScreen, page: () => ProfileScreen()),
    GetPage(
      name: RoutesName.editProfileScreen,
      page: () => EditProfileScreen(usrModel: Get.arguments),
    ),
    GetPage(
      name: RoutesName.myCoursesScreen,
      page: () => const MyCoursesScreen(),
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
    GetPage(
      name: RoutesName.ieltsListeningScreen,
      page: () => IeltsListeningScreen(),
    ),
    GetPage(
      name: RoutesName.audioLessonsScreen,
      page: () =>  AudioLessonsScreen(),
    ),
    GetPage(
      name: RoutesName.practiceTestScreen,
      page: () => const PracticeTestScreen(),
    ),
    GetPage(
      name: RoutesName.feedbackScreen,
      page: () => const FeedbackScreen(),
    ),
    GetPage(
      name: RoutesName.strategiesTipsScreen,
      page: () => const StrategiesTipsScreen(),
    ),
    GetPage(
      name: RoutesName.audioScreen,
      page: () {
        final args = Get.arguments as Map<String, dynamic>;
        return AudioScreen(
          lesson: args['lesson'],
          onComplete: args['onComplete'],
        );
      },
    ),

    GetPage(
      name: RoutesName.audioResultScreen,
      page: () {
        final args = Get.arguments as Map<String, dynamic>;
        return AudioResultScreen(
          isPassed: args['isPassed'],
          score: args['score'],
          totalQuestions: args['totalQuestions'],
          correctAnswers: args['correctAnswers'],
          wrongAnswers: args['wrongAnswers'],
          lessonId: args['lessonId'],
          onComplete: () {},
        );
      },
    ),
  ];
}
