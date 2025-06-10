import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';
import 'package:get/get.dart';

class ListeningProgressController extends GetxController {
  // Lesson progress constants
  static const int totalLessons = 50;
  int _completedLessons = 0;
  double _currentLessonProgress = 0.0;

  // Practice test progress tracking
  final Map<String, bool> _practiceTestCompletion =
      {'Part 1': false, 'Part 2': false, 'Part 3': false, 'Part 4': false}.obs;

  // Loading and error states
  final _isLoading = false.obs;
  final _hasError = false.obs;
  final _errorMessage = Rx<String?>(null);

  // Hive box for local storage
  Box? _progressBox;

  ListeningProgressController() {
    _initialize();
  }

  // Initialize Hive and load progress
  Future<void> _initialize() async {
    await _initHive();
    await _loadProgress();
  }

  // Initialize Hive
  Future<void> _initHive() async {
    try {
      if (!Hive.isBoxOpen('listening_progress')) {
        _progressBox = await Hive.openBox('listening_progress');
      } else {
        _progressBox = Hive.box('listening_progress');
      }
    } catch (e) {
      _hasError.value = true;
      _errorMessage.value = 'Failed to initialize Hive: $e';
      if (kDebugMode) print('Hive initialization error: $e');
      update();
    }
  }

  // Getters
  int get completedLessons => _completedLessons;
  double get currentLessonProgress => _currentLessonProgress;
  double get lessonProgressPercentage =>
      (_completedLessons / totalLessons) * 100;
  double get progress => _completedLessons / totalLessons; // For compatibility
  bool get isLoading => _isLoading.value;
  bool get hasError => _hasError.value;
  String? get errorMessage => _errorMessage.value;

  bool isPracticeTestComplete(String part) =>
      _practiceTestCompletion[part] ?? false;

  double get overallProgress {
    const double lessonWeight = 0.6; // 60% weight to lessons
    const double testWeight = 0.4; // 40% weight to tests
    final double testProgress =
        _practiceTestCompletion.values.where((v) => v).length *
        0.25 *
        testWeight;
    return ((lessonProgressPercentage / 100) * lessonWeight) + testProgress;
  }

  double get testProgressPercentage =>
      _practiceTestCompletion.values.where((v) => v).length * 25.0;

  // Load progress from local storage and sync with Firestore
  Future<void> _loadProgress() async {
    if (_isLoading.value) return;

    _isLoading.value = true;
    _hasError.value = false;
    _errorMessage.value = null;
    update();

    try {
      // Load from Hive if available
      if (_progressBox != null && _progressBox!.isOpen) {
        _completedLessons =
            _progressBox!.get('completedLessons', defaultValue: 0) as int;
        _currentLessonProgress =
            _progressBox!.get('currentLessonProgress', defaultValue: 0.0)
                as double;
        _practiceTestCompletion['Part 1'] =
            _progressBox!.get('practice_test_part1', defaultValue: false)
                as bool;
        _practiceTestCompletion['Part 2'] =
            _progressBox!.get('practice_test_part2', defaultValue: false)
                as bool;
        _practiceTestCompletion['Part 3'] =
            _progressBox!.get('practice_test_part3', defaultValue: false)
                as bool;
        _practiceTestCompletion['Part 4'] =
            _progressBox!.get('practice_test_part4', defaultValue: false)
                as bool;
      } else {
        // Fallback to SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        _completedLessons = prefs.getInt('completedLessons') ?? 0;
        _currentLessonProgress =
            prefs.getDouble('currentLessonProgress') ?? 0.0;
        _practiceTestCompletion['Part 1'] =
            prefs.getBool('practice_test_part1') ?? false;
        _practiceTestCompletion['Part 2'] =
            prefs.getBool('practice_test_part2') ?? false;
        _practiceTestCompletion['Part 3'] =
            prefs.getBool('practice_test_part3') ?? false;
        _practiceTestCompletion['Part 4'] =
            prefs.getBool('practice_test_part4') ?? false;
      }

      // Sync with Firestore if user is authenticated
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await _syncFromFirestore();
      }
    } catch (e) {
      _hasError.value = true;
      _errorMessage.value = 'Failed to load progress: $e';
      if (kDebugMode) print('Progress loading error: $e');
    } finally {
      _isLoading.value = false;
      update();
    }
  }

  // Complete a lesson and save progress
  Future<void> completeLesson() async {
    if (_completedLessons >= totalLessons) return;

    try {
      _completedLessons++;
      _currentLessonProgress = 1.0;
      await _saveProgress();
    } catch (e) {
      _hasError.value = true;
      _errorMessage.value = 'Failed to complete lesson: $e';
      if (kDebugMode) print('Lesson completion error: $e');
      update();
    }
  }

  // Update lesson progress
  void updateProgress(double progress) {
    if (_completedLessons >= totalLessons) return;

    try {
      _currentLessonProgress = progress.clamp(0.0, 1.0);
      _saveProgressSilently();
      update();
    } catch (e) {
      if (kDebugMode) print('Progress update error: $e');
    }
  }

  // Mark a practice test as complete
  Future<void> completePracticeTest(String part) async {
    if (_practiceTestCompletion[part] == true ||
        !_practiceTestCompletion.containsKey(part)) {
      return;
    }

    try {
      _practiceTestCompletion[part] = true;
      await _saveProgress();
    } catch (e) {
      _hasError.value = true;
      _errorMessage.value = 'Failed to complete practice test: $e';
      if (kDebugMode) print('Practice test completion error: $e');
      update();
    }
  }

  // Save progress to local storage and Firestore
  Future<void> _saveProgress() async {
    try {
      // Save to Hive
      if (_progressBox != null && _progressBox!.isOpen) {
        await _progressBox!.put('completedLessons', _completedLessons);
        await _progressBox!.put(
          'currentLessonProgress',
          _currentLessonProgress,
        );
        await _progressBox!.put(
          'practice_test_part1',
          _practiceTestCompletion['Part 1']!,
        );
        await _progressBox!.put(
          'practice_test_part2',
          _practiceTestCompletion['Part 2']!,
        );
        await _progressBox!.put(
          'practice_test_part3',
          _practiceTestCompletion['Part 3']!,
        );
        await _progressBox!.put(
          'practice_test_part4',
          _practiceTestCompletion['Part 4']!,
        );
      }

      // Save to SharedPreferences as fallback
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('completedLessons', _completedLessons);
      await prefs.setDouble('currentLessonProgress', _currentLessonProgress);
      await prefs.setBool(
        'practice_test_part1',
        _practiceTestCompletion['Part 1']!,
      );
      await prefs.setBool(
        'practice_test_part2',
        _practiceTestCompletion['Part 2']!,
      );
      await prefs.setBool(
        'practice_test_part3',
        _practiceTestCompletion['Part 3']!,
      );
      await prefs.setBool(
        'practice_test_part4',
        _practiceTestCompletion['Part 4']!,
      );

      // Sync with Firestore if user is authenticated
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await _syncToFirestore();
      }
    } catch (e) {
      _hasError.value = true;
      _errorMessage.value = 'Failed to save progress: $e';
      if (kDebugMode) print('Progress saving error: $e');
      throw Exception('Failed to save progress: $e');
    }
  }

  // Save progress silently (without notifying listeners)
  Future<void> _saveProgressSilently() async {
    try {
      // Save to Hive
      if (_progressBox != null && _progressBox!.isOpen) {
        await _progressBox!.put(
          'currentLessonProgress',
          _currentLessonProgress,
        );
      }

      // Save to SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setDouble('currentLessonProgress', _currentLessonProgress);

      // Sync with Firestore if user is authenticated
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await _syncToFirestore();
      }
    } catch (e) {
      if (kDebugMode) print('Silent progress saving error: $e');
    }
  }

  // Sync progress to Firestore
  Future<void> _syncToFirestore() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      final progressDoc = FirebaseFirestore.instance
          .collection('user')
          .doc(user.uid)
          .collection('progress')
          .doc('ielts_listening');

      await progressDoc.set({
        'completedLessons': _completedLessons,
        'currentLessonProgress': _currentLessonProgress,
        'practiceTests': _practiceTestCompletion,
        'lastUpdated': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      if (kDebugMode) print('Firestore sync error: $e');
      // Non-fatal error, local progress is still saved
    }
  }

  // Sync progress from Firestore
  Future<void> _syncFromFirestore() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      final doc =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .collection('progress')
              .doc('ielts_listening')
              .get();

      if (doc.exists) {
        final data = doc.data();
        if (data != null) {
          _completedLessons =
              (data['completedLessons'] as num?)?.toInt() ?? _completedLessons;
          _currentLessonProgress =
              (data['currentLessonProgress'] as num?)?.toDouble() ??
              _currentLessonProgress;
          final cloudTests =
              data['practiceTests'] as Map<String, dynamic>? ?? {};
          _practiceTestCompletion['Part 1'] =
              (cloudTests['Part 1'] as bool?) ??
              _practiceTestCompletion['Part 1']!;
          _practiceTestCompletion['Part 2'] =
              (cloudTests['Part 2'] as bool?) ??
              _practiceTestCompletion['Part 2']!;
          _practiceTestCompletion['Part 3'] =
              (cloudTests['Part 3'] as bool?) ??
              _practiceTestCompletion['Part 3']!;
          _practiceTestCompletion['Part 4'] =
              (cloudTests['Part 4'] as bool?) ??
              _practiceTestCompletion['Part 4']!;
          await _saveProgress();
        }
      }
    } catch (e) {
      if (kDebugMode) print('Firestore sync from cloud error: $e');
      // Non-fatal error, continue with local progress
    }
  }

  // Restore progress from Firestore
  Future<void> restoreFromCloud() async {
    _isLoading.value = true;
    _hasError.value = false;
    _errorMessage.value = null;
    update();

    try {
      await _syncFromFirestore();
    } catch (e) {
      _hasError.value = true;
      _errorMessage.value = 'Failed to restore from cloud: $e';
      if (kDebugMode) print('Cloud restore error: $e');
    } finally {
      _isLoading.value = false;
      update();
    }
  }

  // Reset all progress
  Future<void> resetProgress() async {
    try {
      _completedLessons = 0;
      _currentLessonProgress = 0.0;
      _practiceTestCompletion.updateAll((_, __) => false);
      await _saveProgress();
    } catch (e) {
      _hasError.value = true;
      _errorMessage.value = 'Failed to reset progress: $e';
      if (kDebugMode) print('Progress reset error: $e');
      update();
    }
  }
}
