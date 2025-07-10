import 'package:get/get.dart';
import 'dart:async';
import 'package:langtest_pro/repo/writing/writing_auth_facade.dart';
import 'package:langtest_pro/repo/writing/writing_impl.dart';
import 'package:langtest_pro/view/exams/ielts/writing/lessons/writing_data.dart';
import 'package:langtest_pro/view/exams/ielts/writing/letters/letter_data.dart';
import 'package:flutter/foundation.dart';

class WritingController extends GetxController {
  late final WritingAuthFacade _writingAuthFacade;

  final RxBool _isLoading = false.obs;
  final RxBool _hasError = false.obs;
  final RxString _errorMessage = ''.obs;
  final RxBool _isAuthenticated = false.obs;

  final RxMap<int, int> _lessonsProgress = <int, int>{}.obs;
  final RxInt _completedLessons = 0.obs;
  final RxInt _currentLesson = 1.obs;
  final RxInt _currentLessonProgress = 0.obs;

  final RxMap<int, int> _lettersProgress = <int, int>{}.obs;
  final RxInt _completedLetters = 0.obs;
  final RxInt _currentLetter = 1.obs;
  final RxInt _currentLetterProgress = 0.obs;

  final RxDouble _overallProgress = 0.0.obs;
  final RxDouble _lessonsProgressPercentage = 0.0.obs;
  final RxDouble _lettersProgressPercentage = 0.0.obs;

  StreamSubscription<bool>? _authSubscription;

  bool get isLoading => _isLoading.value;
  bool get hasError => _hasError.value;
  String get errorMessage => _errorMessage.value;
  bool get isAuthenticated => _isAuthenticated.value;

  Map<int, int> get lessonsProgress => _lessonsProgress;
  int get completedLessons => _completedLessons.value;
  int get currentLesson => _currentLesson.value;
  int get currentLessonProgress => _currentLessonProgress.value;

  Map<int, int> get lettersProgress => _lettersProgress;
  int get completedLetters => _completedLetters.value;
  int get currentLetter => _currentLetter.value;
  int get currentLetterProgress => _currentLetterProgress.value;

  double get overallProgress => _overallProgress.value;
  double get lessonsProgressPercentage => _lessonsProgressPercentage.value;
  double get lettersProgressPercentage => _lettersProgressPercentage.value;

  static int get totalWritingLessons => WritingData.lessons.length;
  static int get totalLetterLessons => letterLessons.length;
  static int get totalLessons =>
      WritingData.lessons.length + letterLessons.length;

  double get progress => _overallProgress.value / 100;

  @override
  void onInit() {
    super.onInit();
    _writingAuthFacade = Get.put<WritingAuthFacade>(WritingImpl());
    _authSubscription = _writingAuthFacade.authStateChanges.listen((
      isAuthenticated,
    ) {
      _isAuthenticated.value = isAuthenticated;
      if (isAuthenticated) {
        _loadAllProgress();
      } else {
        _clearProgress();
      }
    });

    if (_writingAuthFacade.isUserAuthenticated()) {
      _isAuthenticated.value = true;
      _loadAllProgress();
    }
  }

  @override
  void onClose() {
    _authSubscription?.cancel();
    if (_writingAuthFacade is WritingImpl) {
      (_writingAuthFacade as WritingImpl).dispose();
    }
    super.onClose();
  }

  Future<void> _loadAllProgress() async {
    _setLoading(true);
    _clearError();
    final userId = _writingAuthFacade.getCurrentUserId();

    if (userId == null) {
      _setError('User not authenticated');
      _setLoading(false);
      return;
    }

    try {
      final lessonsResult = await _writingAuthFacade
          .getAllWritingLessonsProgress(userId: userId);
      lessonsResult.fold(
        (error) => _setError('Failed to load lessons progress: $error'),
        (progressMap) {
          _lessonsProgress.assignAll(progressMap);
          _completedLessons.value =
              progressMap.values.where((p) => p == 100).length;
          _currentLesson.value = _determineCurrentLesson(progressMap);
          _currentLessonProgress.value = progressMap[_currentLesson.value] ?? 0;
        },
      );

      final lettersResult = await _writingAuthFacade
          .getAllWritingLettersProgress(userId: userId);
      lettersResult.fold(
        (error) => _setError('Failed to load letters progress: $error'),
        (progressMap) {
          _lettersProgress.assignAll(progressMap);
          _completedLetters.value =
              progressMap.values.where((p) => p == 100).length;
          _currentLetter.value = _determineCurrentLetter(progressMap);
          _currentLetterProgress.value = progressMap[_currentLetter.value] ?? 0;
        },
      );

      await _updateProgressStats();
    } catch (e) {
      _setError('Unexpected error during _loadAllProgress: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> upsertWritingLessonProgress({
    required int lessonId,
    required int progress,
  }) async {
    final userId = _writingAuthFacade.getCurrentUserId();
    if (userId == null) {
      _setError('User not authenticated');
      return false;
    }

    if (![50, 75, 100].contains(progress)) {
      _setError('Invalid progress value. Must be 50, 75, or 100.');
      return false;
    }

    final accessibleResult = await _writingAuthFacade.isWritingLessonAccessible(
      userId: userId,
      lessonId: lessonId,
    );

    final isAccessible = accessibleResult.fold((error) {
      _setError('Error checking lesson accessibility: $error');
      return false;
    }, (accessible) => accessible);

    if (!isAccessible) {
      _setError(
        'Lesson $lessonId is not accessible. Complete the previous lesson first.',
      );
      return false;
    }

    _setLoading(true);
    _clearError();

    final result = await _writingAuthFacade.upsertWritingLessonProgress(
      userId: userId,
      lessonId: lessonId,
      progress: progress,
    );

    return result.fold(
      (error) {
        _setError('Failed to update lesson progress: $error');
        _setLoading(false);
        return false;
      },
      (_) async {
        _lessonsProgress[lessonId] = progress;
        _completedLessons.value =
            _lessonsProgress.values.where((p) => p == 100).length;
        _currentLesson.value = _determineCurrentLesson(_lessonsProgress);
        _currentLessonProgress.value =
            _lessonsProgress[_currentLesson.value] ?? 0;
        await _updateProgressStats();
        _setLoading(false);
        return true;
      },
    );
  }

  Future<bool> upsertWritingLetterProgress({
    required int lessonId,
    required int progress,
  }) async {
    final userId = _writingAuthFacade.getCurrentUserId();
    if (userId == null) {
      _setError('User not authenticated');
      return false;
    }

    if (![50, 75, 100].contains(progress)) {
      _setError('Invalid progress value. Must be 50, 75, or 100.');
      return false;
    }

    final accessibleResult = await _writingAuthFacade.isWritingLetterAccessible(
      userId: userId,
      lessonId: lessonId,
    );

    final isAccessible = accessibleResult.fold((error) {
      _setError('Error checking letter accessibility: $error');
      return false;
    }, (accessible) => accessible);

    if (!isAccessible) {
      _setError(
        'Letter $lessonId is not accessible. Complete the previous letter first.',
      );
      return false;
    }

    _setLoading(true);
    _clearError();

    final result = await _writingAuthFacade.upsertWritingLetterProgress(
      userId: userId,
      lessonId: lessonId,
      progress: progress,
    );

    return result.fold(
      (error) {
        _setError('Failed to update letter progress: $error');
        _setLoading(false);
        return false;
      },
      (_) async {
        _lettersProgress[lessonId] = progress;
        _completedLetters.value =
            _lettersProgress.values.where((p) => p == 100).length;
        _currentLetter.value = _determineCurrentLetter(_lettersProgress);
        _currentLetterProgress.value =
            _lettersProgress[_currentLetter.value] ?? 0;
        await _updateProgressStats();
        _setLoading(false);
        return true;
      },
    );
  }

  Future<bool> completeLesson(int lessonId) async {
    return await upsertWritingLessonProgress(lessonId: lessonId, progress: 100);
  }

  Future<bool> completeLetterLesson(int lessonId) async {
    return await upsertWritingLetterProgress(lessonId: lessonId, progress: 100);
  }

  Future<bool> markLessonAsOpened(int lessonId) async {
    return await upsertWritingLessonProgress(lessonId: lessonId, progress: 50);
  }

  Future<bool> markLessonAsStarted(int lessonId) async {
    return await upsertWritingLessonProgress(lessonId: lessonId, progress: 75);
  }

  Future<bool> markLetterAsOpened(int lessonId) async {
    return await upsertWritingLetterProgress(lessonId: lessonId, progress: 50);
  }

  Future<bool> markLetterAsStarted(int lessonId) async {
    return await upsertWritingLetterProgress(lessonId: lessonId, progress: 75);
  }

  bool isLessonCompleted(int lessonId) {
    return _lessonsProgress[lessonId] == 100;
  }

  bool isLetterLessonCompleted(int lessonId) {
    return _lettersProgress[lessonId] == 100;
  }

  Future<bool> isWritingLessonAccessible(int lessonId) async {
    final userId = _writingAuthFacade.getCurrentUserId();
    if (userId == null) return false;

    final result = await _writingAuthFacade.isWritingLessonAccessible(
      userId: userId,
      lessonId: lessonId,
    );

    return result.fold((error) {
      debugPrint('Error checking lesson accessibility: $error');
      return false;
    }, (accessible) => accessible);
  }

  Future<bool> isWritingLetterAccessible(int lessonId) async {
    final userId = _writingAuthFacade.getCurrentUserId();
    if (userId == null) return false;

    final result = await _writingAuthFacade.isWritingLetterAccessible(
      userId: userId,
      lessonId: lessonId,
    );

    return result.fold((error) {
      debugPrint('Error checking letter accessibility: $error');
      return false;
    }, (accessible) => accessible);
  }

  Future<int> getLessonProgress(int lessonId) async {
    final userId = _writingAuthFacade.getCurrentUserId();
    if (userId == null) return 0;

    final result = await _writingAuthFacade.getWritingLessonProgress(
      userId: userId,
      lessonId: lessonId,
    );

    return result.fold((error) {
      debugPrint('Error getting lesson progress: $error');
      return 0;
    }, (progress) => progress ?? 0);
  }

  Future<int> getLetterProgress(int lessonId) async {
    final userId = _writingAuthFacade.getCurrentUserId();
    if (userId == null) return 0;

    final result = await _writingAuthFacade.getWritingLetterProgress(
      userId: userId,
      lessonId: lessonId,
    );

    return result.fold((error) {
      debugPrint('Error getting letter progress: $error');
      return 0;
    }, (progress) => progress ?? 0);
  }

  int _determineCurrentLesson(Map<int, int> progressMap) {
    for (int i = 1; i <= totalWritingLessons; i++) {
      if ((progressMap[i] ?? 0) < 100) {
        return i;
      }
    }
    return totalWritingLessons;
  }

  int _determineCurrentLetter(Map<int, int> progressMap) {
    for (int i = 1; i <= totalLetterLessons; i++) {
      if ((progressMap[i] ?? 0) < 100) {
        return i;
      }
    }
    return totalLetterLessons;
  }

  Future<void> _updateProgressStats() async {
    final userId = _writingAuthFacade.getCurrentUserId();
    if (userId == null) {
      _setError('User not authenticated for stats');
      return;
    }

    final statsResult = await _writingAuthFacade.getWritingProgressStats(
      userId: userId,
      totalLessons: totalWritingLessons,
      totalLetters: totalLetterLessons,
    );

    statsResult.fold(
      (error) => _setError('Failed to get progress stats: $error'),
      (stats) {
        _overallProgress.value = stats['overall_completion_percentage'] ?? 0.0;
        _lessonsProgressPercentage.value =
            stats['lessons_completion_percentage'] ?? 0.0;
        _lettersProgressPercentage.value =
            stats['letters_completion_percentage'] ?? 0.0;
      },
    );
  }

  void _clearProgress() {
    _lessonsProgress.clear();
    _lettersProgress.clear();
    _completedLessons.value = 0;
    _currentLesson.value = 1;
    _currentLessonProgress.value = 0;
    _completedLetters.value = 0;
    _currentLetter.value = 1;
    _currentLetterProgress.value = 0;
    _overallProgress.value = 0.0;
    _lessonsProgressPercentage.value = 0.0;
    _lettersProgressPercentage.value = 0.0;
  }

  void _setLoading(bool loading) {
    _isLoading.value = loading;
  }

  void _setError(String error) {
    _hasError.value = true;
    _errorMessage.value = error;
    debugPrint('WritingController Error: $error');
  }

  void _clearError() {
    _hasError.value = false;
    _errorMessage.value = '';
  }

  double get completionPercentage {
    if (totalLessons == 0) return 0.0;
    return ((_completedLessons.value + _completedLetters.value) /
            totalLessons) *
        100;
  }
}
