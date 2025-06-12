import 'package:get/get.dart';
import 'package:langtest_pro/res/routes/routes_name.dart';
import 'package:langtest_pro/view/auth/login_screen.dart';
import 'package:langtest_pro/view/exams/ielts/ielts_listening.dart';
import 'package:langtest_pro/view/exams/ielts/ielts_reading.dart';
import 'package:langtest_pro/view/exams/ielts/ielts_screen.dart';
import 'package:langtest_pro/view/exams/ielts/ielts_speaking.dart';
import 'package:langtest_pro/view/exams/ielts/ielts_writing.dart';
import 'package:langtest_pro/view/exams/ielts/listening/audio_lessons/audio_lessons.dart';
import 'package:langtest_pro/view/exams/ielts/listening/audio_lessons/audio_result.dart';
import 'package:langtest_pro/view/exams/ielts/listening/audio_lessons/audio_screen.dart';
import 'package:langtest_pro/view/exams/ielts/listening/practice_tests/practice_test_questions_screen.dart';
import 'package:langtest_pro/view/exams/ielts/listening/practice_tests/practice_test_result.dart';
import 'package:langtest_pro/view/exams/ielts/listening/practice_tests/practice_test_screen.dart';
import 'package:langtest_pro/view/exams/ielts/listening/strategies_tips.dart';
import 'package:langtest_pro/view/exams/ielts/reading/academic/academic_lessons.dart';
import 'package:langtest_pro/view/exams/ielts/reading/academic/lesson_screen.dart';
import 'package:langtest_pro/view/exams/ielts/reading/general/general_lessons.dart';
import 'package:langtest_pro/view/exams/ielts/reading/general/general_screen.dart';
import 'package:langtest_pro/view/exams/ielts/writing/lessons/lesson_list_screen.dart';
import 'package:langtest_pro/view/exams/ielts/writing/lessons/writing_lesson_1.dart';
import 'package:langtest_pro/view/exams/ielts/writing/lessons/writing_lesson_10.dart';
import 'package:langtest_pro/view/exams/ielts/writing/lessons/writing_lesson_11.dart';
import 'package:langtest_pro/view/exams/ielts/writing/lessons/writing_lesson_12.dart';
import 'package:langtest_pro/view/exams/ielts/writing/lessons/writing_lesson_13.dart';
import 'package:langtest_pro/view/exams/ielts/writing/lessons/writing_lesson_14.dart';
import 'package:langtest_pro/view/exams/ielts/writing/lessons/writing_lesson_15.dart';
import 'package:langtest_pro/view/exams/ielts/writing/lessons/writing_lesson_16.dart';
import 'package:langtest_pro/view/exams/ielts/writing/lessons/writing_lesson_17.dart';
import 'package:langtest_pro/view/exams/ielts/writing/lessons/writing_lesson_18.dart';
import 'package:langtest_pro/view/exams/ielts/writing/lessons/writing_lesson_19.dart';
import 'package:langtest_pro/view/exams/ielts/writing/lessons/writing_lesson_2.dart';
import 'package:langtest_pro/view/exams/ielts/writing/lessons/writing_lesson_20.dart';
import 'package:langtest_pro/view/exams/ielts/writing/lessons/writing_lesson_21.dart';
import 'package:langtest_pro/view/exams/ielts/writing/lessons/writing_lesson_22.dart';
import 'package:langtest_pro/view/exams/ielts/writing/lessons/writing_lesson_23.dart';
import 'package:langtest_pro/view/exams/ielts/writing/lessons/writing_lesson_24.dart';
import 'package:langtest_pro/view/exams/ielts/writing/lessons/writing_lesson_25.dart';
import 'package:langtest_pro/view/exams/ielts/writing/lessons/writing_lesson_26.dart';
import 'package:langtest_pro/view/exams/ielts/writing/lessons/writing_lesson_27.dart';
import 'package:langtest_pro/view/exams/ielts/writing/lessons/writing_lesson_28.dart';
import 'package:langtest_pro/view/exams/ielts/writing/lessons/writing_lesson_29.dart';
import 'package:langtest_pro/view/exams/ielts/writing/lessons/writing_lesson_30.dart';
import 'package:langtest_pro/view/exams/ielts/writing/lessons/writing_lesson_31.dart';
import 'package:langtest_pro/view/exams/ielts/writing/lessons/writing_lesson_32.dart';
import 'package:langtest_pro/view/exams/ielts/writing/lessons/writing_lesson_33.dart';
import 'package:langtest_pro/view/exams/ielts/writing/lessons/writing_lesson_34.dart';
import 'package:langtest_pro/view/exams/ielts/writing/lessons/writing_lesson_35.dart';
import 'package:langtest_pro/view/exams/ielts/writing/lessons/writing_lesson_36.dart';
import 'package:langtest_pro/view/exams/ielts/writing/lessons/writing_lesson_37.dart';
import 'package:langtest_pro/view/exams/ielts/writing/lessons/writing_lesson_38.dart';
import 'package:langtest_pro/view/exams/ielts/writing/lessons/writing_lesson_39.dart';
import 'package:langtest_pro/view/exams/ielts/writing/lessons/writing_lesson_4.dart';
import 'package:langtest_pro/view/exams/ielts/writing/lessons/writing_lesson_40.dart';
import 'package:langtest_pro/view/exams/ielts/writing/lessons/writing_lesson_5.dart';
import 'package:langtest_pro/view/exams/ielts/writing/lessons/writing_lesson_6.dart';
import 'package:langtest_pro/view/exams/ielts/writing/lessons/writing_lesson_7.dart';
import 'package:langtest_pro/view/exams/ielts/writing/lessons/writing_lesson_8.dart';
import 'package:langtest_pro/view/exams/ielts/writing/lessons/writing_lesson_9.dart';
import 'package:langtest_pro/view/exams/ielts/writing/letters/formal_letter/formal_letter_1.dart';
import 'package:langtest_pro/view/exams/ielts/writing/letters/formal_letter/formal_letter_2.dart';
import 'package:langtest_pro/view/exams/ielts/writing/letters/formal_letter/formal_letter_3.dart';
import 'package:langtest_pro/view/exams/ielts/writing/letters/formal_letter/formal_letter_4.dart';
import 'package:langtest_pro/view/exams/ielts/writing/letters/formal_letter/formal_letter_5.dart';
import 'package:langtest_pro/view/exams/ielts/writing/letters/formal_letter/formal_letter_6.dart';
import 'package:langtest_pro/view/exams/ielts/writing/letters/formal_letter/formal_letter_7.dart';
import 'package:langtest_pro/view/exams/ielts/writing/letters/informal_letter/informal_letter_1.dart';
import 'package:langtest_pro/view/exams/ielts/writing/letters/informal_letter/informal_letter_2.dart';
import 'package:langtest_pro/view/exams/ielts/writing/letters/informal_letter/informal_letter_3.dart';
import 'package:langtest_pro/view/exams/ielts/writing/letters/informal_letter/informal_letter_4.dart';
import 'package:langtest_pro/view/exams/ielts/writing/letters/informal_letter/informal_letter_5.dart';
import 'package:langtest_pro/view/exams/ielts/writing/letters/informal_letter/informal_letter_6.dart';
import 'package:langtest_pro/view/exams/ielts/writing/letters/informal_letter/informal_letter_7.dart';
import 'package:langtest_pro/view/exams/ielts/writing/letters/letter_list_screen.dart';
import 'package:langtest_pro/view/exams/ielts/writing/writing_result.dart';
import 'package:langtest_pro/view/home/dashboard.dart';
import 'package:langtest_pro/view/home/home_screen.dart';
import 'package:langtest_pro/view/home/side_menu/about_us.dart';
import 'package:langtest_pro/view/home/side_menu/menu_screen.dart';
import 'package:langtest_pro/view/home/side_menu/rate_our_app.dart';
import 'package:langtest_pro/view/home/side_menu/share_app.dart';
import 'package:langtest_pro/view/payment/payment_successful.dart';
import 'package:langtest_pro/view/profile/Help%20&%20Support/help_support.dart';
import 'package:langtest_pro/view/profile/Help%20&%20Support/report_problem.dart';
import 'package:langtest_pro/view/profile/Help%20&%20Support/terms_policies.dart';
import 'package:langtest_pro/view/profile/edit_profile.dart';
import 'package:langtest_pro/view/profile/my_courses.dart';
import 'package:langtest_pro/view/profile/notifications_settings.dart';
import 'package:langtest_pro/view/profile/user_info_screen.dart';
import 'package:langtest_pro/view/home/notification_screen.dart';
import 'package:langtest_pro/view/payment/loading_screen.dart';
import 'package:langtest_pro/view/payment/payment_screen.dart';
import 'package:langtest_pro/view/profile/preferences_screen.dart';
import 'package:langtest_pro/view/profile/profile_screen.dart';
import 'package:langtest_pro/view/subscriptions/subscription_screen.dart';

class AppRoutes {
  static List<GetPage> appRoutes() => [
    // GetPage(name: RoutesName.splashScreen, page: () => const SplashScreen()),
    GetPage(name: RoutesName.loginScreen, page: () => const LoginScreen()),
    GetPage(
      name: RoutesName.userDetailsScreen,
      page: () => UserInfoScreen(userCredentials: Get.arguments),
    ),
    GetPage(name: RoutesName.homeScreen, page: () => const HomeScreen()),
    GetPage(name: RoutesName.ieltsScreen, page: () => const IeltsScreen()),
    GetPage(
      name: RoutesName.ieltsListeningScreen,
      page: () => IeltsListeningScreen(sectionData: Get.arguments),
    ),
    GetPage(
      name: RoutesName.ieltsReadingScreen,
      page: () => IeltsReadingScreen(sectionData: Get.arguments),
    ),
    GetPage(
      name: RoutesName.ieltsSpeakingScreen,
      page: () => IeltsSpeakingScreen(sectionData: Get.arguments),
    ),
    GetPage(
      name: RoutesName.ieltsWritingScreen,
      page: () => IeltsWritingScreen(sectionData: Get.arguments),
    ),
    GetPage(
      name: RoutesName.listeningFeedbackScreen,
      page: () => ListeningFeedbackScreen(feedbackData: Get.arguments),
    ),
    GetPage(
      name: RoutesName.listeningStrategiesTipsScreen,
      page: () => StrategiesTipsScreen(),
    ),
    GetPage(
      name: RoutesName.audioLessonsScreen,
      page: () => AudioLessonsScreen(lessonData: Get.arguments),
    ),
    GetPage(
      name: RoutesName.audioResultScreen,
      page: () => AudioResultScreen(resultData: Get.arguments),
    ),
    GetPage(
      name: RoutesName.audioScreen,
      page: () => AudioScreen(audioData: Get.arguments),
    ),
    GetPage(
      name: RoutesName.practiceTestAudioScreen,
      page: () => PracticeTestAudioScreen(testData: Get.arguments),
    ),
    GetPage(
      name: RoutesName.practiceTestQuestionsScreen,
      page: () => PracticeTestQuestionsScreen(questionData: Get.arguments),
    ),
    GetPage(
      name: RoutesName.practiceTestResultScreen,
      page:
          () => PracticeTestResultScreen(
            resultData: Get.arguments,
            score: 7,
            totalQuestions: 15,
            unlockedNextPart: 7,
            timeExpired: 5,
          ),
    ),
    GetPage(
      name: RoutesName.practiceTestScreen,
      page: () => PracticeTestScreen(testData: Get.arguments),
    ),
    GetPage(
      name: RoutesName.practiceTestTimerScreen,
      page: () => PracticeTestTimerScreen(timerData: Get.arguments),
    ),
    GetPage(
      name: RoutesName.readingFeedbackScreen,
      page: () => ReadingFeedbackScreen(feedbackData: Get.arguments),
    ),
    GetPage(
      name: RoutesName.readingStrategiesTipsScreen,
      page: () => StrategiesTipsScreen(),
    ),
    GetPage(
      name: RoutesName.academicLessonsScreen,
      page: () => AcademicLessonsScreen(lessonData: Get.arguments),
    ),
    GetPage(
      name: RoutesName.academicResultScreen,
      page: () => AcademicResultScreen(resultData: Get.arguments),
    ),
    GetPage(
      name: RoutesName.lessonScreen,
      page: () => LessonScreen(lessonData: Get.arguments),
    ),
    GetPage(
      name: RoutesName.generalLessonsScreen,
      page: () => GeneralLessonsScreen(lessonData: Get.arguments),
    ),
    GetPage(
      name: RoutesName.generalResultScreen,
      page: () => GeneralResultScreen(resultData: Get.arguments),
    ),
    GetPage(
      name: RoutesName.generalScreen,
      page: () => GeneralScreen(data: Get.arguments),
    ),
    GetPage(
      name: RoutesName.speakingFeedbackScreen,
      page: () => SpeakingFeedbackScreen(feedbackData: Get.arguments),
    ),
    GetPage(
      name: RoutesName.speakingStrategiesTipsScreen,
      page: () => StrategiesTipsScreen(),
    ),
    GetPage(
      name: RoutesName.writingFeedbackScreen,
      page: () => WritingFeedbackScreen(feedbackData: Get.arguments),
    ),
    GetPage(
      name: RoutesName.writingStrategiesTipsScreen,
      page: () => StrategiesTipsScreen(),
    ),
    GetPage(
      name: RoutesName.writingResultScreen,
      page: () => WritingResultScreen(resultData: Get.arguments),
    ),
    GetPage(
      name: RoutesName.lessonListScreen,
      page: () => LessonListScreen(listData: Get.arguments),
    ),
    GetPage(
      name: RoutesName.lessonResultScreen,
      page: () => LessonResultScreen(resultData: Get.arguments),
    ),
    GetPage(
      name: RoutesName.letterListScreen,
      page: () => LetterListScreen(listData: Get.arguments),
    ),
    GetPage(
      name: RoutesName.formalLetterLesson1Screen,
      page: () => FormalLetterLesson1(lessonData: Get.arguments),
    ),
    GetPage(
      name: RoutesName.formalLetterLesson2Screen,
      page: () => FormalLetterLesson2(lessonData: Get.arguments),
    ),
    GetPage(
      name: RoutesName.formalLetterLesson3Screen,
      page: () => FormalLetterLesson3(lessonData: Get.arguments),
    ),
    GetPage(
      name: RoutesName.formalLetterLesson4Screen,
      page: () => FormalLetterLesson4(lessonData: Get.arguments),
    ),
    GetPage(
      name: RoutesName.formalLetterLesson5Screen,
      page: () => FormalLetterLesson5(lessonData: Get.arguments),
    ),
    GetPage(
      name: RoutesName.formalLetterLesson6Screen,
      page: () => FormalLetterLesson6(lessonData: Get.arguments),
    ),
    GetPage(
      name: RoutesName.formalLetterLesson7Screen,
      page: () => FormalLetterLesson7(lessonData: Get.arguments),
    ),
    GetPage(
      name: RoutesName.informalLetterLesson1Screen,
      page: () => InformalLetterLesson1(lessonData: Get.arguments),
    ),
    GetPage(
      name: RoutesName.informalLetterLesson2Screen,
      page: () => InformalLetterLesson2(lessonData: Get.arguments),
    ),
    GetPage(
      name: RoutesName.informalLetterLesson3Screen,
      page: () => InformalLetterLesson3(lessonData: Get.arguments),
    ),
    GetPage(
      name: RoutesName.informalLetterLesson4Screen,
      page: () => InformalLetterLesson4(lessonData: Get.arguments),
    ),
    GetPage(
      name: RoutesName.informalLetterLesson5Screen,
      page: () => InformalLetterLesson5(lessonData: Get.arguments),
    ),
    GetPage(
      name: RoutesName.informalLetterLesson6Screen,
      page: () => InformalLetterLesson6(lessonData: Get.arguments),
    ),
    GetPage(
      name: RoutesName.informalLetterLesson7Screen,
      page: () => InformalLetterLesson7(lessonData: Get.arguments),
    ),
    GetPage(
      name: RoutesName.writingLesson1Screen,
      page: () => WritingLesson1(lessonData: Get.arguments),
    ),
    GetPage(
      name: RoutesName.writingLesson2Screen,
      page: () => WritingLesson2(lessonData: Get.arguments),
    ),
    GetPage(
      name: RoutesName.writingLesson4Screen,
      page: () => WritingLesson4(lessonData: Get.arguments),
    ),
    GetPage(
      name: RoutesName.writingLesson5Screen,
      page: () => WritingLesson5(lessonData: Get.arguments),
    ),
    GetPage(
      name: RoutesName.writingLesson6Screen,
      page: () => WritingLesson6(lessonData: Get.arguments),
    ),
    GetPage(
      name: RoutesName.writingLesson7Screen,
      page: () => WritingLesson7(lessonData: Get.arguments),
    ),
    GetPage(
      name: RoutesName.writingLesson8Screen,
      page: () => WritingLesson8(lessonData: Get.arguments),
    ),
    GetPage(
      name: RoutesName.writingLesson9Screen,
      page: () => WritingLesson9(lessonData: Get.arguments),
    ),
    GetPage(
      name: RoutesName.writingLesson10Screen,
      page: () => WritingLesson10(lessonData: Get.arguments),
    ),
    GetPage(
      name: RoutesName.writingLesson11Screen,
      page: () => WritingLesson11(lessonData: Get.arguments),
    ),
    GetPage(
      name: RoutesName.writingLesson12Screen,
      page: () => WritingLesson12(lessonData: Get.arguments),
    ),
    GetPage(
      name: RoutesName.writingLesson13Screen,
      page: () => WritingLesson13(lessonData: Get.arguments),
    ),
    GetPage(
      name: RoutesName.writingLesson14Screen,
      page: () => WritingLesson14(lessonData: Get.arguments),
    ),
    GetPage(
      name: RoutesName.writingLesson15Screen,
      page: () => WritingLesson15(lessonData: Get.arguments),
    ),
    GetPage(
      name: RoutesName.writingLesson16Screen,
      page: () => WritingLesson16(lessonData: Get.arguments),
    ),
    GetPage(
      name: RoutesName.writingLesson17Screen,
      page: () => WritingLesson17(lessonData: Get.arguments),
    ),
    GetPage(
      name: RoutesName.writingLesson18Screen,
      page: () => WritingLesson18(lessonData: Get.arguments),
    ),
    GetPage(
      name: RoutesName.writingLesson19Screen,
      page: () => WritingLesson19(lessonData: Get.arguments),
    ),
    GetPage(
      name: RoutesName.writingLesson20Screen,
      page: () => WritingLesson20(lessonData: Get.arguments),
    ),
    GetPage(
      name: RoutesName.writingLesson21Screen,
      page: () => WritingLesson21(lessonData: Get.arguments),
    ),
    GetPage(
      name: RoutesName.writingLesson22Screen,
      page: () => WritingLesson22(lessonData: Get.arguments),
    ),
    GetPage(
      name: RoutesName.writingLesson23Screen,
      page: () => WritingLesson23(lessonData: Get.arguments),
    ),
    GetPage(
      name: RoutesName.writingLesson24Screen,
      page: () => WritingLesson24(lessonData: Get.arguments),
    ),
    GetPage(
      name: RoutesName.writingLesson25Screen,
      page: () => WritingLesson25(lessonData: Get.arguments),
    ),
    GetPage(
      name: RoutesName.writingLesson26Screen,
      page: () => WritingLesson26(lessonData: Get.arguments),
    ),
    GetPage(
      name: RoutesName.writingLesson27Screen,
      page: () => WritingLesson27(lessonData: Get.arguments),
    ),
    GetPage(
      name: RoutesName.writingLesson28Screen,
      page: () => WritingLesson28(lessonData: Get.arguments),
    ),
    GetPage(
      name: RoutesName.writingLesson29Screen,
      page: () => WritingLesson29(lessonData: Get.arguments),
    ),
    GetPage(
      name: RoutesName.writingLesson30Screen,
      page: () => WritingLesson30(lessonData: Get.arguments),
    ),
    GetPage(
      name: RoutesName.writingLesson31Screen,
      page: () => WritingLesson31(lessonData: Get.arguments),
    ),
    GetPage(
      name: RoutesName.writingLesson32Screen,
      page: () => WritingLesson32(lessonData: Get.arguments),
    ),
    GetPage(
      name: RoutesName.writingLesson33Screen,
      page: () => WritingLesson33(lessonData: Get.arguments),
    ),
    GetPage(
      name: RoutesName.writingLesson34Screen,
      page: () => WritingLesson34(lessonData: Get.arguments),
    ),
    GetPage(
      name: RoutesName.writingLesson35Screen,
      page: () => WritingLesson35(lessonData: Get.arguments),
    ),
    GetPage(
      name: RoutesName.writingLesson36Screen,
      page: () => WritingLesson36(lessonData: Get.arguments),
    ),
    GetPage(
      name: RoutesName.writingLesson37Screen,
      page: () => WritingLesson37(lessonData: Get.arguments),
    ),
    GetPage(
      name: RoutesName.writingLesson38Screen,
      page: () => WritingLesson38(lessonData: Get.arguments),
    ),
    GetPage(
      name: RoutesName.writingLesson39Screen,
      page: () => WritingLesson39(lessonData: Get.arguments),
    ),
    GetPage(
      name: RoutesName.writingLesson40Screen,
      page: () => WritingLesson40(lessonData: Get.arguments),
    ),
    GetPage(
      name: RoutesName.dashboardScreen,
      page: () => DashboardScreen(dashboardData: Get.arguments),
    ),
    GetPage(
      name: RoutesName.notificationScreen,
      page: () => NotificationScreen(notificationData: Get.arguments),
    ),
    GetPage(name: RoutesName.aboutUsScreen, page: () => const AboutUsScreen()),
    GetPage(name: RoutesName.menuScreen, page: () => const MenuScreen()),
    GetPage(
      name: RoutesName.rateOurAppScreen,
      page: () => const RateOurAppScreen(),
    ),
    GetPage(
      name: RoutesName.shareAppScreen,
      page: () => const ShareAppScreen(),
    ),
    GetPage(name: RoutesName.loadingScreen, page: () => const LoadingScreen()),
    GetPage(
      name: RoutesName.paymentScreen,
      page: () => PaymentScreen(paymentData: Get.arguments, price: '99'),
    ),
    GetPage(
      name: RoutesName.paymentSuccessfulScreen,
      page: () => PaymentSuccessfulScreen(paymentStatus: Get.arguments),
    ),
    GetPage(
      name: RoutesName.editProfileScreen,
      page: () => EditProfileScreen(userData: Get.arguments),
    ),
    GetPage(
      name: RoutesName.myCoursesScreen,
      page: () => MyCoursesScreen(courseData: Get.arguments),
    ),
    GetPage(
      name: RoutesName.notificationSettingsScreen,
      page: () => NotificationSettingsScreen(settingsData: Get.arguments),
    ),
    GetPage(
      name: RoutesName.preferencesScreen,
      page: () => PreferencesScreen(preferencesData: Get.arguments),
    ),
    GetPage(
      name: RoutesName.profileScreen,
      page: () => ProfileScreen(userData: Get.arguments),
    ),
    GetPage(
      name: RoutesName.helpSupportScreen,
      page: () => const HelpSupportScreen(),
    ),
    GetPage(
      name: RoutesName.reportProblemScreen,
      page: () => ReportProblemScreen(problemData: Get.arguments),
    ),
    GetPage(
      name: RoutesName.termsPoliciesScreen,
      page: () => const TermsPoliciesScreen(),
    ),
    GetPage(
      name: RoutesName.oneTimeOfferScreen,
      page: () => OneTimeOfferScreen(offerData: Get.arguments),
    ),
    GetPage(
      name: RoutesName.subscriptionScreen,
      page: () => SubscriptionScreen(subscriptionData: Get.arguments),
    ),
    GetPage(
      name: RoutesName.subscriptionStatusScreen,
      page: () => SubscriptionStatusScreen(statusData: Get.arguments),
    ),
  ];
}
