import 'package:get/get.dart';
import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:langtest_pro/repo/reading/reading_auth_facade.dart';
import 'package:langtest_pro/repo/reading/reading_impl.dart';

class ReadingController extends GetxController {
  late final ReadingAuthFacade _readingAuthFacade;

  // Observable state variables
  final RxBool _isLoading = false.obs;
  final RxBool _hasError = false.obs;
  final RxString _errorMessage = ''.obs;
  final RxBool _isAuthenticated = false.obs;

  // Academic Reading Progress
  final RxMap<int, int> _academicProgress = <int, int>{}.obs;
  final RxInt _completedAcademicLessons = 0.obs;
  final RxInt _currentAcademicLesson = 1.obs;
  final RxInt _currentAcademicLessonProgress = 0.obs;

  // General Training Progress
  final RxMap<int, int> _generalProgress = <int, int>{}.obs;
  final RxInt _completedGeneralLessons = 0.obs;
  final RxInt _currentGeneralLesson = 1.obs;
  final RxInt _currentGeneralLessonProgress = 0.obs;

  // Overall Progress Statistics
  final RxDouble _overallProgress = 0.0.obs;
  final RxDouble _academicProgressPercentage = 0.0.obs;
  final RxDouble _generalProgressPercentage = 0.0.obs;

  // Store lesson scores
  final RxMap<int, String> academicLessonScores = <int, String>{}.obs;
  final RxMap<int, String> generalLessonScores = <int, String>{}.obs;

  // Stream subscription for auth state changes
  StreamSubscription<bool>? _authSubscription;

  // Getters
  bool get isLoading => _isLoading.value;
  bool get hasError => _hasError.value;
  String get errorMessage => _errorMessage.value;
  bool get isAuthenticated => _isAuthenticated.value;
  Map<int, int> get academicProgress => _academicProgress;
  int get completedAcademicLessons => _completedAcademicLessons.value;
  int get currentAcademicLesson => _currentAcademicLesson.value;
  int get currentAcademicLessonProgress => _currentAcademicLessonProgress.value;
  Map<int, int> get generalProgress => _generalProgress;
  int get completedGeneralLessons => _completedGeneralLessons.value;
  int get currentGeneralLesson => _currentGeneralLesson.value;
  int get currentGeneralLessonProgress => _currentGeneralLessonProgress.value;
  double get overallProgress => _overallProgress.value;
  double get academicProgressPercentage => _academicProgressPercentage.value;
  double get generalProgressPercentage => _generalProgressPercentage.value;

  @override
  void onInit() {
    super.onInit();
    _initializeDependencies();
    _setupAuthListener();
    _loadInitialData();
  }

  @override
  void onClose() {
    _authSubscription?.cancel();
    if (_readingAuthFacade is ReadingImpl) {
      (_readingAuthFacade as ReadingImpl).dispose();
    }
    super.onClose();
  }

  void _initializeDependencies() {
    if (!Get.isRegistered<ReadingAuthFacade>()) {
      Get.put<ReadingAuthFacade>(ReadingImpl());
    }
    _readingAuthFacade = Get.find<ReadingAuthFacade>();
  }

  void _setupAuthListener() {
    _authSubscription = _readingAuthFacade.authStateChanges.listen((isAuth) {
      _isAuthenticated.value = isAuth;
      if (isAuth) {
        _loadAllProgress();
      } else {
        _clearProgress();
      }
    });
  }

  Future<void> _loadInitialData() async {
    _isAuthenticated.value = _readingAuthFacade.isUserAuthenticated();
    if (_isAuthenticated.value) {
      await _loadAllProgress();
    }
  }

  void _clearProgress() {
    _academicProgress.clear();
    _generalProgress.clear();
    _completedAcademicLessons.value = 0;
    _completedGeneralLessons.value = 0;
    _currentAcademicLesson.value = 1;
    _currentGeneralLesson.value = 1;
    _currentAcademicLessonProgress.value = 0;
    _currentGeneralLessonProgress.value = 0;
    _overallProgress.value = 0.0;
    _academicProgressPercentage.value = 0.0;
    _generalProgressPercentage.value = 0.0;
    academicLessonScores.clear();
    generalLessonScores.clear();
  }

  Future<void> _loadAllProgress() async {
    final userId = _readingAuthFacade.getCurrentUserId();
    if (userId == null) {
      _setError('User not authenticated');
      return;
    }

    _setLoading(true);
    _clearError();

    try {
      final academicResult = await _readingAuthFacade
          .getAllAcademicReadingProgress(userId: userId);
      academicResult.fold(
        (error) => _setError('Failed to load academic progress: $error'),
        (progress) {
          _academicProgress.assignAll(progress);
          _currentAcademicLessonProgress.value =
              progress[_currentAcademicLesson.value] ?? 0;
        },
      );

      final generalResult = await _readingAuthFacade
          .getAllGeneralTrainingProgress(userId: userId);
      generalResult.fold(
        (error) =>
            _setError('Failed to load general training progress: $error'),
        (progress) {
          _generalProgress.assignAll(progress);
          _currentGeneralLessonProgress.value =
              progress[_currentGeneralLesson.value] ?? 0;
        },
      );

      final statsResult = await _readingAuthFacade.getReadingProgressStats(
        userId: userId,
      );
      statsResult.fold(
        (error) => _setError('Failed to load progress stats: $error'),
        (stats) {
          _overallProgress.value =
              stats['overall_completion_percentage']?.toDouble() ?? 0.0;
          _academicProgressPercentage.value =
              stats['academic_completion_percentage']?.toDouble() ?? 0.0;
          _generalProgressPercentage.value =
              stats['general_completion_percentage']?.toDouble() ?? 0.0;
          _completedAcademicLessons.value =
              stats['completed_academic_lessons'] ?? 0;
          _completedGeneralLessons.value =
              stats['completed_general_lessons'] ?? 0;
        },
      );

      // Update current lessons
      final highestAcademic = await _readingAuthFacade
          .getHighestCompletedAcademicLesson(userId: userId);
      highestAcademic.fold(
        (error) => _setError(
          'Failed to get highest completed academic lesson: $error',
        ),
        (lessonId) => _currentAcademicLesson.value = lessonId + 1,
      );

      final highestGeneral = await _readingAuthFacade
          .getHighestCompletedGeneralTrainingLesson(userId: userId);
      highestGeneral.fold(
        (error) =>
            _setError('Failed to get highest completed general lesson: $error'),
        (lessonId) => _currentGeneralLesson.value = lessonId + 1,
      );
    } catch (e) {
      _setError('Unexpected error loading progress: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> updateAcademicLessonProgress({
    required int lessonId,
    required int progress,
  }) async {
    final userId = _readingAuthFacade.getCurrentUserId();
    if (userId == null) {
      _setError('User not authenticated');
      return false;
    }

    if (![0, 50, 75, 100].contains(progress)) {
      _setError('Invalid progress value. Must be 0, 50, 75, or 100.');
      return false;
    }

    final accessibleResult = await _readingAuthFacade
        .isAcademicReadingLessonAccessible(userId: userId, lessonId: lessonId);

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

    final result = await _readingAuthFacade.upsertAcademicReadingProgress(
      userId: userId,
      lessonId: lessonId,
      progress: progress,
    );

    return result.fold(
      (error) {
        _setError('Failed to update progress: $error');
        return false;
      },
      (_) {
        _academicProgress[lessonId] = progress;
        if (lessonId == _currentAcademicLesson.value) {
          _currentAcademicLessonProgress.value = progress;
        }
        _loadAllProgress();
        return true;
      },
    );
  }

  Future<bool> updateGeneralLessonProgress({
    required int lessonId,
    required int progress,
  }) async {
    final userId = _readingAuthFacade.getCurrentUserId();
    if (userId == null) {
      _setError('User not authenticated');
      return false;
    }

    if (![0, 50, 75, 100].contains(progress)) {
      _setError('Invalid progress value. Must be 0, 50, 75, or 100.');
      return false;
    }

    final accessibleResult = await _readingAuthFacade
        .isGeneralTrainingLessonAccessible(userId: userId, lessonId: lessonId);

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

    final result = await _readingAuthFacade.upsertGeneralTrainingProgress(
      userId: userId,
      lessonId: lessonId,
      progress: progress,
    );

    return result.fold(
      (error) {
        _setError('Failed to update progress: $error');
        return false;
      },
      (_) {
        _generalProgress[lessonId] = progress;
        if (lessonId == _currentGeneralLesson.value) {
          _currentGeneralLessonProgress.value = progress;
        }
        _loadAllProgress();
        return true;
      },
    );
  }

  Future<bool> markAcademicLessonAsOpened(int lessonId) async {
    return await updateAcademicLessonProgress(lessonId: lessonId, progress: 50);
  }

  Future<bool> markAcademicLessonAsStarted(int lessonId) async {
    return await updateAcademicLessonProgress(lessonId: lessonId, progress: 75);
  }

  Future<bool> markAcademicLessonAsCompleted(int lessonId) async {
    return await updateAcademicLessonProgress(
      lessonId: lessonId,
      progress: 100,
    );
  }

  Future<bool> completeAcademicLesson({
    required int lessonId,
    required String score,
  }) async {
    academicLessonScores[lessonId] = score;
    return await markAcademicLessonAsCompleted(lessonId);
  }

  Future<bool> markGeneralLessonAsOpened(int lessonId) async {
    return await updateGeneralLessonProgress(lessonId: lessonId, progress: 50);
  }

  Future<bool> markGeneralLessonAsStarted(int lessonId) async {
    return await updateGeneralLessonProgress(lessonId: lessonId, progress: 75);
  }

  Future<bool> markGeneralLessonAsCompleted(int lessonId) async {
    return await updateGeneralLessonProgress(lessonId: lessonId, progress: 100);
  }

  Future<bool> completeGeneralLesson({
    required int lessonId,
    required String score,
  }) async {
    generalLessonScores[lessonId] = score;
    return await markGeneralLessonAsCompleted(lessonId);
  }

  Future<bool> isAcademicLessonAccessible(int lessonId) async {
    final userId = _readingAuthFacade.getCurrentUserId();
    if (userId == null) return false;

    final result = await _readingAuthFacade.isAcademicReadingLessonAccessible(
      userId: userId,
      lessonId: lessonId,
    );

    return result.fold((error) {
      _setError('Error checking lesson accessibility: $error');
      return false;
    }, (accessible) => accessible);
  }

  Future<bool> isGeneralLessonAccessible(int lessonId) async {
    final userId = _readingAuthFacade.getCurrentUserId();
    if (userId == null) return false;

    final result = await _readingAuthFacade.isGeneralTrainingLessonAccessible(
      userId: userId,
      lessonId: lessonId,
    );

    return result.fold((error) {
      _setError('Error checking lesson accessibility: $error');
      return false;
    }, (accessible) => accessible);
  }

  int getAcademicLessonProgress(int lessonId) {
    return _academicProgress[lessonId] ?? 0;
  }

  int getGeneralLessonProgress(int lessonId) {
    return _generalProgress[lessonId] ?? 0;
  }

  Future<bool> resetAllProgress() async {
    final userId = _readingAuthFacade.getCurrentUserId();
    if (userId == null) {
      _setError('User not authenticated');
      return false;
    }

    _setLoading(true);
    _clearError();

    try {
      final academicResult = await _readingAuthFacade
          .deleteAllAcademicReadingProgress(userId: userId);
      final generalResult = await _readingAuthFacade
          .deleteAllGeneralTrainingProgress(userId: userId);

      bool success = true;
      academicResult.fold((error) {
        _setError('Failed to reset academic progress: $error');
        success = false;
      }, (_) {});
      generalResult.fold((error) {
        _setError('Failed to reset general progress: $error');
        success = false;
      }, (_) {});

      if (success) {
        _clearProgress();
      }
      return success;
    } catch (e) {
      _setError('Failed to reset progress: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> refreshProgress() async {
    await _loadAllProgress();
  }

  void updateProgress(double progress) {
    _overallProgress.value = progress.clamp(0.0, 100.0);
  }

  void _setLoading(bool loading) {
    _isLoading.value = loading;
  }

  void _setError(String error) {
    _hasError.value = true;
    _errorMessage.value = error;
  }

  void _clearError() {
    _hasError.value = false;
    _errorMessage.value = '';
  }
}
