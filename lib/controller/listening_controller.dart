// lib/controller/listening_controller.dart

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:langtest_pro/repo/listening/listening_auth_facade.dart';
import 'package:langtest_pro/repo/listening/listening_impl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ListeningProgressController extends GetxController {
  static const int totalLessons = 50;
  static const int totalTests = 4;
  final _progressMap =
      <String, double>{}.obs; // lesson_id or practice_part -> progress
  final _completedLessons = <String>{}.obs; // Track completed lessons/parts
  final _isLoading = false.obs;
  final _hasError = false.obs;
  final _errorMessage = Rx<String?>(null);
  final ListeningAuthFacade _authFacade;
  Box? _progressBox;

  ListeningProgressController({ListeningAuthFacade? authFacade})
    : _authFacade = authFacade ?? ListeningImpl(Supabase.instance.client) {
    _initialize();
  }

  // Getter to check if user is authenticated
  bool get isAuthenticated => Supabase.instance.client.auth.currentUser != null;

  // Initialize Hive and load progress
  Future<void> _initialize() async {
    await _initHive();
    await _loadProgress();
  }

  // Initialize Hive box for local storage
  Future<void> _initHive() async {
    try {
      _progressBox = await Hive.openBox('listening_progress');
    } catch (e) {
      _hasError.value = true;
      _errorMessage.value = 'Failed to initialize Hive: $e';
      debugPrint('Hive initialization error: $e');
      update();
    }
  }

  // Getters
  double getProgress(String key) => _progressMap[key] ?? 0.0;
  double get lessonProgressPercentage =>
      (_completedLessons.length / totalLessons) * 100;
  double get testProgressPercentage {
    int completedTests = 0;
    for (String part in ['part1', 'part2', 'part3', 'part4']) {
      if (isPracticeTestComplete(part)) {
        completedTests++;
      }
    }
    return (completedTests / totalTests) * 100;
  }

  bool get isLoading => _isLoading.value;
  bool get hasError => _hasError.value;
  String? get errorMessage => _errorMessage.value;
  int get completedLessons => _completedLessons.length;

  // Check if a practice test part is complete
  bool isPracticeTestComplete(String part) {
    if (!_isValidPart(part)) return false;
    final progressKey = 'practice_${part.toLowerCase()}';
    return _progressMap[progressKey] == 1.0;
  }

  // Load progress from Hive and Supabase
  Future<void> _loadProgress() async {
    _isLoading.value = true;
    try {
      // Load from Hive
      if (_progressBox != null && _progressBox!.isOpen) {
        final savedProgress = _progressBox!.get('progress', defaultValue: {});
        if (savedProgress is Map) {
          _progressMap.assignAll(savedProgress.cast<String, double>());
          _completedLessons.addAll(
            _progressMap.keys.where((key) => _progressMap[key] == 1.0),
          );
        }
      }

      // Sync with Supabase if authenticated
      if (isAuthenticated) {
        final userId = Supabase.instance.client.auth.currentUser!.id;
        final cloudProgress = await _authFacade.fetchProgress(userId);
        for (var entry in cloudProgress) {
          final parts = entry.split(':');
          if (parts.length == 2) {
            final key = parts[0];
            final value = double.tryParse(parts[1]) ?? 0.0;
            _progressMap[key] = value;
            if (value == 1.0) {
              _completedLessons.add(key);
            }
          }
        }
        await _saveLocalProgress();
      }
    } catch (e) {
      _hasError.value = true;
      _errorMessage.value = 'Failed to load progress: $e';
      debugPrint('Progress loading error: $e');
    } finally {
      _isLoading.value = false;
      update();
    }
  }

  // Update progress for a lesson
  Future<void> updateLessonProgress(String lessonId, String status) async {
    if (!_isValidLessonId(lessonId)) {
      debugPrint('Invalid lessonId: $lessonId');
      return;
    }

    try {
      double newProgress = _progressMap[lessonId] ?? 0.0;
      switch (status) {
        case 'audio_started':
          if (newProgress < 0.5) newProgress = 0.5; // 50%
          break;
        case 'question_opened':
          if (newProgress < 0.75) newProgress = 0.75; // 50% + 25%
          break;
        case 'lesson_completed':
          newProgress = 1.0; // 100%
          _completedLessons.add(lessonId); // Add to completed lessons
          // Unlock next lesson
          final nextLessonId =
              (int.parse(lessonId.replaceAll('lesson', '')) + 1).toString();
          if (_isValidLessonId('lesson$nextLessonId') &&
              !_progressMap.containsKey('lesson$nextLessonId')) {
            _progressMap['lesson$nextLessonId'] = 0.0;
          }
          break;
        default:
          debugPrint('Invalid status: $status');
          return;
      }

      if (newProgress > (_progressMap[lessonId] ?? 0.0)) {
        _progressMap[lessonId] = newProgress;
        await _saveLocalProgress();
        await _syncToSupabase();
      }

      update(); // Notify UI
    } catch (e) {
      _hasError.value = true;
      _errorMessage.value = 'Failed to update lesson progress: $e';
      debugPrint('Progress update error: $e');
      update();
    }
  }

  // Update progress for a practice test part
  Future<void> updatePracticeTestProgress(String part, String status) async {
    if (!_isValidPart(part)) {
      debugPrint('Invalid part: $part');
      return;
    }

    try {
      final progressKey = 'practice_${part.toLowerCase()}';
      double newProgress = _progressMap[progressKey] ?? 0.0;
      switch (status) {
        case 'audio_started':
          if (newProgress < 0.5) newProgress = 0.5; // 50%
          break;
        case 'question_opened':
          if (newProgress < 0.75) newProgress = 0.75; // 50% + 25%
          break;
        case 'test_completed':
          newProgress = 1.0; // 100%
          _completedLessons.add(progressKey); // Add to completed parts
          break;
        default:
          debugPrint('Invalid status: $status');
          return;
      }

      if (newProgress > (_progressMap[progressKey] ?? 0.0)) {
        _progressMap[progressKey] = newProgress;
        await _saveLocalProgress();
        await _syncToSupabase();
      }

      update(); // Notify UI
    } catch (e) {
      _hasError.value = true;
      _errorMessage.value = 'Failed to update practice test progress: $e';
      debugPrint('Progress update error: $e');
      update();
    }
  }

  // Validate lesson ID
  bool _isValidLessonId(String lessonId) {
    final lessonNum = int.tryParse(lessonId.replaceAll('lesson', '')) ?? 0;
    return lessonId.startsWith('lesson') &&
        lessonNum >= 1 &&
        lessonNum <= totalLessons;
  }

  // Validate practice test part
  bool _isValidPart(String part) {
    return ['part1', 'part2', 'part3', 'part4'].contains(part.toLowerCase());
  }

  // Save progress to Hive
  Future<void> _saveLocalProgress() async {
    if (_progressBox != null && _progressBox!.isOpen) {
      await _progressBox!.put('progress', _progressMap());
    }
  }

  // Sync progress to Supabase
  Future<void> _syncToSupabase() async {
    if (!isAuthenticated) return;

    try {
      final userId = Supabase.instance.client.auth.currentUser!.id;
      final progressList =
          _progressMap.entries.map((e) => '${e.key}:${e.value}').toList();
      await _authFacade.updateProgress(userId, progressList);
    } catch (e) {
      debugPrint('Supabase sync error: $e');
      throw Exception('Failed to sync with Supabase: $e');
    }
  }

  // Restore progress from Supabase
  Future<void> restoreFromCloud() async {
    _isLoading.value = true;
    _hasError.value = false;
    _errorMessage.value = null;
    update();

    if (!isAuthenticated) {
      _isLoading.value = false;
      _hasError.value = true;
      _errorMessage.value = 'No authenticated user found';
      update();
      return;
    }

    try {
      final userId = Supabase.instance.client.auth.currentUser!.id;
      final cloudProgress = await _authFacade.fetchProgress(userId);
      _progressMap.clear();
      _completedLessons.clear();
      for (var entry in cloudProgress) {
        final parts = entry.split(':');
        if (parts.length == 2) {
          final key = parts[0];
          final value = double.tryParse(parts[1]) ?? 0.0;
          _progressMap[key] = value;
          if (value == 1.0) {
            _completedLessons.add(key);
          }
        }
      }
      await _saveLocalProgress();
    } catch (e) {
      _hasError.value = true;
      _errorMessage.value = 'Failed to restore from cloud: $e';
      debugPrint('Cloud restore error: $e');
    } finally {
      _isLoading.value = false;
      update();
    }
  }

  // Reset all progress
  Future<void> resetProgress() async {
    try {
      _progressMap.clear();
      _completedLessons.clear();
      await _saveLocalProgress();
      if (isAuthenticated) {
        final userId = Supabase.instance.client.auth.currentUser!.id;
        await _authFacade.resetProgress(userId);
      }
      update();
    } catch (e) {
      _hasError.value = true;
      _errorMessage.value = 'Failed to reset progress: $e';
      debugPrint('Progress reset error: $e');
      update();
    }
  }
}
