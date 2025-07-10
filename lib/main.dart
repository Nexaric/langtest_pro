import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:langtest_pro/controller/listening_controller.dart';
import 'package:langtest_pro/controller/reading_controller.dart';
import 'package:langtest_pro/controller/speaking_progress_provider.dart';
import 'package:langtest_pro/controller/writing_controller.dart';
import 'package:langtest_pro/res/routes/routes.dart';
import 'package:langtest_pro/res/routes/routes_name.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase (optional, remove if not used)
  try {
    await Firebase.initializeApp();
    debugPrint('Firebase initialized successfully');
  } catch (e) {
    debugPrint('Firebase initialization error: $e');
    // Handle Firebase failure gracefully if not critical
  }

  // Initialize Supabase
  try {
    await Supabase.initialize(
      url: 'https://xrcrymvcztdjduazxzzi.supabase.co',
      anonKey:
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InhyY3J5bXZjenRkamR1YXp4enppIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDk4MzI2OTYsImV4cCI6MjA2NTQwODY5Nn0.rRSGWB4aPkifmL8_z22B4OTu8Hv0opJc-YzrxH-qKpQ',
      authOptions: const FlutterAuthClientOptions(
        authFlowType: AuthFlowType.implicit,
      ),
    );
    debugPrint('Supabase initialized successfully');
  } catch (e) {
    debugPrint('Supabase initialization error: $e');
    // Consider showing an error screen if Supabase is critical
  }

  // Initialize Hive (optional, remove if not used for caching)
  try {
    await Hive.initFlutter();
    await Hive.openBox('listening_progress');
    await Hive.openBox('reading_progress');
    await Hive.openBox('writing_progress');
    await Hive.openBox('speaking_progress');
    debugPrint('Hive initialized successfully');
  } catch (e) {
    debugPrint('Hive initialization error: $e');
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'LangTest Pro',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF6A5AE0),
              brightness: Brightness.light,
              primary: const Color(0xFF6A5AE0),
              onPrimary: Colors.white,
              secondary: const Color(0xFF3E1E68),
              onSecondary: Colors.white,
              surface: Colors.white,
              onSurface: const Color(0xFF1A1D21),
              background: Colors.white,
              onBackground: const Color(0xFF1A1D21),
              error: const Color(0xFFEF4444),
              onError: Colors.white,
            ),
            scaffoldBackgroundColor: Colors.white,
            // Use GoogleFonts.poppins to match other screens
            textTheme: GoogleFonts.poppinsTextTheme(
              Theme.of(context).textTheme.copyWith(
                displayLarge: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  height: 1.2,
                ),
                displayMedium: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
                bodyLarge: const TextStyle(
                  fontSize: 16,
                  color: Color(0xFFE2E8F0),
                  height: 1.5,
                ),
                labelLarge: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.transparent,
              elevation: 0,
              centerTitle: true,
              titleTextStyle: TextStyle(
                fontFamily: 'Poppins',
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00BFA6),
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 18.h, horizontal: 24.w),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.r),
                ),
                elevation: 4,
                shadowColor: Colors.black.withOpacity(0.1),
              ),
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors.white.withOpacity(0.8),
                textStyle: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  decoration: TextDecoration.underline,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
            ),
          ),
          getPages: AppRoutes.appRoutes(),
          initialRoute: RoutesName.splashScreen,
          initialBinding: BindingsBuilder(() {
            Get.lazyPut<ListeningController>(() => ListeningController());
            Get.lazyPut<ReadingController>(() => ReadingController());
            Get.lazyPut<WritingController>(() => WritingController());
            Get.lazyPut<SpeakingProgressController>(
              () => SpeakingProgressController(),
            );
          }),
        );
      },
    );
  }
}
