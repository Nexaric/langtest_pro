// lib/main.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:langtest_pro/controller/push_notification/notification_controller.dart';
import 'package:langtest_pro/res/routes/routes.dart';
import 'package:langtest_pro/res/routes/routes_name.dart';

void main() async {
  debugDisableShadows = false;
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  try {
    await Firebase.initializeApp();
    debugPrint('Firebase initialized successfully');
  } catch (e) {
    debugPrint('Firebase initialization error: $e');
  }

  // Initialize Supabase
  try {
    await Supabase.initialize(
      url: 'https://xrcrymvcztdjduazxzzi.supabase.co',
      anonKey:
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InhyY3J5bXZjenRkamR1YXp4enppIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDk4MzI2OTYsImV4cCI6MjA2NTQwODY5Nn0.rRSGWB4aPkifmL8_z22B4OTu8Hv0opJc-YzrxH-qKpQ',
      authOptions: FlutterAuthClientOptions(
        authFlowType: AuthFlowType.implicit,
      ),
    );
    debugPrint('Supabase initialized successfully');
  } catch (e) {
    debugPrint('Supabase initialization error: $e');
  }

  // Initialize Hive and other services
  await initialise();

  runApp(const MyApp());
}

Future<void> initialise() async {

  // final notificationController = Get.put(NotificationController());
  // Initialize Hive
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
            fontFamily: 'Inter',
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.white,
              elevation: 0,
              centerTitle: true,
              titleTextStyle: TextStyle(
                color: Color(0xFF1A1D21),
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            textTheme: const TextTheme(
              displayLarge: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                height: 1.2,
              ),
              displayMedium: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
              bodyLarge: TextStyle(
                fontSize: 16,
                color: Color(0xFFE2E8F0),
                height: 1.5,
              ),
              labelLarge: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFF3E1E68),
                padding: const EdgeInsets.symmetric(
                  vertical: 18,
                  horizontal: 24,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 4,
                shadowColor: Colors.black.withOpacity(0.1),
              ),
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors.white.withOpacity(0.8),
                textStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  decoration: TextDecoration.underline,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          getPages: AppRoutes.appRoutes(),
          initialRoute: RoutesName.splashScreen,
         
        );
      },
    );
  }
}
