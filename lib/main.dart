// lib/main.dart

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:langtest_pro/firebase_options.dart';
import 'package:provider/provider.dart';
import 'package:langtest_pro/auth/login_screen.dart';
import 'package:langtest_pro/exams/ielts/listening/listening_progress_provider.dart';
import 'package:langtest_pro/exams/ielts/reading/reading_progress_provider.dart';
import 'package:langtest_pro/exams/ielts/writing/writing_progress_provider.dart';
import 'package:langtest_pro/exams/ielts/speaking/speaking_progress_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
);

  // Initialize Hive for Flutter
  await Hive.initFlutter();

  // Optionally open Hive boxes used by providers
  await Hive.openBox('listening_progress');
  await Hive.openBox('reading_progress');
  await Hive.openBox('writing_progress');
  await Hive.openBox('speaking_progress');

  runApp(
    MultiProvider(
      providers: [
        // IELTS Progress Providers
        ChangeNotifierProvider(create: (_) => ListeningProgressProvider()),
        ChangeNotifierProvider(create: (_) => ReadingProgressProvider()),
        ChangeNotifierProvider(create: (_) => WritingProgressProvider()),
        ChangeNotifierProvider(create: (_) => SpeakingProgressProvider()),
        // Add authentication provider if needed
        // ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'LangTest Pro',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Poppins', // Consistent with other screens
      ),
      home: const LoginScreen(),
    );
  }
}
