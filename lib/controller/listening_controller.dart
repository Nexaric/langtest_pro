import 'package:get/get.dart';
import 'dart:async';
import 'package:langtest_pro/repo/listening/listening_auth_facade.dart';
import 'package:langtest_pro/repo/listening/listening_impl.dart';

class ListeningController extends GetxController {
  late final ListeningAuthFacade _listeningAuthFacade;

  final RxBool _isLoading = false.obs;
  final RxBool _hasError = false.obs;
  final RxString _errorMessage = ''.obs;
  final RxBool _isAuthenticated = false.obs;

  final RxMap<int, int> _audioLessonsProgress = <int, int>{}.obs;
  final RxInt _completedAudioLessons = 0.obs;
  final RxInt _currentAudioLesson = 1.obs;
  final RxInt _currentAudioLessonProgress = 0.obs;

  final RxMap<int, int> _practiceTestsProgress = <int, int>{}.obs;
  final RxInt _completedPracticeTests = 0.obs;
  final RxInt _currentPracticeTest = 1.obs;
  final RxInt _currentPracticeTestProgress = 0.obs;

  final RxDouble _overallProgress = 0.0.obs;
  final RxDouble _audioLessonsProgressPercentage = 0.0.obs;
  final RxDouble _practiceTestsProgressPercentage = 0.0.obs;

  StreamSubscription<bool>? _authSubscription;

  bool get isLoading => _isLoading.value;
  bool get hasError => _hasError.value;
  String get errorMessage => _errorMessage.value;
  bool get isAuthenticated => _isAuthenticated.value;

  Map<int, int> get audioLessonsProgress => _audioLessonsProgress;
  int get completedAudioLessons => _completedAudioLessons.value;
  int get currentAudioLesson => _currentAudioLesson.value;
  int get currentAudioLessonProgress => _currentAudioLessonProgress.value;

  Map<int, int> get practiceTestsProgress => _practiceTestsProgress;
  int get completedPracticeTests => _completedPracticeTests.value;
  int get currentPracticeTest => _currentPracticeTest.value;
  int get currentPracticeTestProgress => _currentPracticeTestProgress.value;

  double get overallProgress => _overallProgress.value;
  double get audioLessonsProgressPercentage =>
      _audioLessonsProgressPercentage.value;
  double get practiceTestsProgressPercentage =>
      _practiceTestsProgressPercentage.value;

  // Updated getter for progress to return a double between 0.0 and 1.0
  double getProgress(String lessonId) {
    final id = int.tryParse(lessonId) ?? 0;
    return (_audioLessonsProgress[id] ?? 0) / 100.0;
  }

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
    if (_listeningAuthFacade is ListeningImpl) {
      (_listeningAuthFacade as ListeningImpl).dispose();
    }
    super.onClose();
  }

  void _initializeDependencies() {
    _listeningAuthFacade = Get.put<ListeningAuthFacade>(
      ListeningImpl() as ListeningAuthFacade,
    );
  }

  void _setupAuthListener() {
    _authSubscription = _listeningAuthFacade.authStateChanges.listen((isAuth) {
      _isAuthenticated.value = isAuth;
      if (isAuth) {
        _loadAllProgress();
      } else {
        _clearProgress();
      }
    });
  }

  Future<void> _loadInitialData() async {
    _isAuthenticated.value = _listeningAuthFacade.isUserAuthenticated();
    if (_isAuthenticated.value) {
      await _loadAllProgress();
    }
  }

  void _clearProgress() {
    _audioLessonsProgress.clear();
    _practiceTestsProgress.clear();
    _completedAudioLessons.value = 0;
    _completedPracticeTests.value = 0;
    _currentAudioLesson.value = 1;
    _currentPracticeTest.value = 1;
    _currentAudioLessonProgress.value = 0;
    _currentPracticeTestProgress.value = 0;
    _overallProgress.value = 0.0;
    _audioLessonsProgressPercentage.value = 0.0;
    _practiceTestsProgressPercentage.value = 0.0;
  }

  Future<void> _loadAllProgress() async {
    final userId = _listeningAuthFacade.getCurrentUserId();
    if (userId == null) {
      _setError('User not authenticated');
      return;
    }

    _setLoading(true);
    _clearError();

    try {
      final audioLessonsResult = await _listeningAuthFacade
          .getAllListeningAudioLessonsProgress(userId: userId);
      audioLessonsResult.fold(
        (error) => _setError('Failed to load audio lessons progress: $error'),
        (progress) => _audioLessonsProgress.assignAll(progress),
      );

      final practiceTestsResult = await _listeningAuthFacade
          .getAllListeningPracticeTestsProgress(userId: userId);
      practiceTestsResult.fold(
        (error) => _setError('Failed to load practice tests progress: $error'),
        (progress) => _practiceTestsProgress.assignAll(progress),
      );

      _calculateProgressStatistics();
    } catch (e) {
      _setError('Unexpected error loading progress: $e');
    } finally {
      _setLoading(false);
    }
  }

  void _calculateProgressStatistics() {
    final completedAudio =
        _audioLessonsProgress.values.where((p) => p == 100).length;
    _completedAudioLessons.value = completedAudio;
    _audioLessonsProgressPercentage.value = (completedAudio / 50) * 100;

    int currentAudio = 1;
    int currentAudioProgress = 0;
    for (int i = 1; i <= 50; i++) {
      final progress = _audioLessonsProgress[i] ?? 0;
      if (progress == 100) {
        currentAudio = i + 1;
        currentAudioProgress = 0;
      } else if (progress > 0) {
        currentAudio = i;
        currentAudioProgress = progress;
        break;
      } else {
        break;
      }
    }
    _currentAudioLesson.value = currentAudio.clamp(1, 50);
    _currentAudioLessonProgress.value = currentAudioProgress;

    final completedTests =
        _practiceTestsProgress.values.where((p) => p == 100).length;
    _completedPracticeTests.value = completedTests;
    _practiceTestsProgressPercentage.value = (completedTests / 4) * 100;

    int currentTest = 1;
    int currentTestProgress = 0;
    for (int i = 1; i <= 4; i++) {
      final progress = _practiceTestsProgress[i] ?? 0;
      if (progress == 100) {
        currentTest = i + 1;
        currentTestProgress = 0;
      } else if (progress > 0) {
        currentTest = i;
        currentTestProgress = progress;
        break;
      } else {
        break;
      }
    }
    _currentPracticeTest.value = currentTest.clamp(1, 4);
    _currentPracticeTestProgress.value = currentTestProgress;

    final totalCompleted = completedAudio + completedTests;
    _overallProgress.value = (totalCompleted / 54) * 100;
  }

  // Updated progress update method
  Future<bool> updateLessonProgress(
    String lessonId,
    String progressState,
  ) async {
    final id = int.tryParse(lessonId) ?? 0;
    final userId = _listeningAuthFacade.getCurrentUserId();
    if (userId == null) {
      _setError('User not authenticated');
      return false;
    }

    int progress;
    switch (progressState) {
      case 'audio_opened':
        progress = 50;
        break;
      case 'audio_started':
        progress = 75;
        break;
      case 'lesson_completed':
        progress = 100;
        break;
      default:
        _setError('Invalid progress state: $progressState');
        return false;
    }

    final accessibleResult = await _listeningAuthFacade
        .isListeningAudioLessonAccessible(userId: userId, lessonId: id);

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

    final result = await _listeningAuthFacade
        .upsertListeningAudioLessonProgress(
          userId: userId,
          lessonId: id,
          progress: progress,
        );

    return result.fold(
      (error) {
        _setError('Failed to update progress: $error');
        return false;
      },
      (_) {
        _audioLessonsProgress[id] = progress;
        _calculateProgressStatistics();
        return true;
      },
    );
  }

  Future<bool> updateAudioLessonProgress({
    required int lessonId,
    required int progress,
  }) async {
    final userId = _listeningAuthFacade.getCurrentUserId();
    if (userId == null) {
      _setError('User not authenticated');
      return false;
    }

    if (![50, 75, 100].contains(progress)) {
      _setError('Invalid progress value. Must be 50, 75, or 100.');
      return false;
    }

    final accessibleResult = await _listeningAuthFacade
        .isListeningAudioLessonAccessible(userId: userId, lessonId: lessonId);

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

    final result = await _listeningAuthFacade
        .upsertListeningAudioLessonProgress(
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
        _audioLessonsProgress[lessonId] = progress;
        _calculateProgressStatistics();
        return true;
      },
    );
  }

  Future<bool> updatePracticeTestProgress({
    required int lessonId,
    required int progress,
  }) async {
    final userId = _listeningAuthFacade.getCurrentUserId();
    if (userId == null) {
      _setError('User not authenticated');
      return false;
    }

    if (![50, 75, 100].contains(progress)) {
      _setError('Invalid progress value. Must be 50, 75, or 100.');
      return false;
    }

    final accessibleResult = await _listeningAuthFacade
        .isListeningPracticeTestAccessible(userId: userId, lessonId: lessonId);

    final isAccessible = accessibleResult.fold((error) {
      _setError('Error checking test accessibility: $error');
      return false;
    }, (accessible) => accessible);

    if (!isAccessible) {
      _setError(
        'Test $lessonId is not accessible. Complete the previous test first.',
      );
      return false;
    }

    final result = await _listeningAuthFacade
        .upsertListeningPracticeTestProgress(
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
        _practiceTestsProgress[lessonId] = progress;
        _calculateProgressStatistics();
        return true;
      },
    );
  }

  Future<bool> markAudioLessonAsOpened(int lessonId) async {
    return await updateAudioLessonProgress(lessonId: lessonId, progress: 50);
  }

  Future<bool> markAudioLessonAsStarted(int lessonId) async {
    return await updateAudioLessonProgress(lessonId: lessonId, progress: 75);
  }

  Future<bool> markAudioLessonAsCompleted(int lessonId) async {
    return await updateAudioLessonProgress(lessonId: lessonId, progress: 100);
  }

  Future<bool> markPracticeTestAsOpened(int lessonId) async {
    return await updatePracticeTestProgress(lessonId: lessonId, progress: 50);
  }

  Future<bool> markPracticeTestAsStarted(int lessonId) async {
    return await updatePracticeTestProgress(lessonId: lessonId, progress: 75);
  }

  Future<bool> markPracticeTestAsCompleted(int lessonId) async {
    return await updatePracticeTestProgress(lessonId: lessonId, progress: 100);
  }

  Future<bool> isAudioLessonAccessible(int lessonId) async {
    final userId = _listeningAuthFacade.getCurrentUserId();
    if (userId == null) return false;

    final result = await _listeningAuthFacade.isListeningAudioLessonAccessible(
      userId: userId,
      lessonId: lessonId,
    );

    return result.fold((error) => false, (accessible) => accessible);
  }

  Future<bool> isPracticeTestAccessible(int lessonId) async {
    final userId = _listeningAuthFacade.getCurrentUserId();
    if (userId == null) return false;

    final result = await _listeningAuthFacade.isListeningPracticeTestAccessible(
      userId: userId,
      lessonId: lessonId,
    );

    return result.fold((error) => false, (accessible) => accessible);
  }

  int getAudioLessonProgress(int lessonId) {
    return _audioLessonsProgress[lessonId] ?? 0;
  }

  int getPracticeTestProgress(int lessonId) {
    return _practiceTestsProgress[lessonId] ?? 0;
  }

  Future<void> refreshProgress() async {
    await _loadAllProgress();
  }

  Future<bool> resetAllProgress() async {
    final userId = _listeningAuthFacade.getCurrentUserId();
    if (userId == null) {
      _setError('User not authenticated');
      return false;
    }

    _setLoading(true);
    _clearError();

    try {
      for (final lessonId in _audioLessonsProgress.keys) {
        await _listeningAuthFacade.deleteListeningAudioLessonProgress(
          userId: userId,
          lessonId: lessonId,
        );
      }

      for (final lessonId in _practiceTestsProgress.keys) {
        await _listeningAuthFacade.deleteListeningPracticeTestProgress(
          userId: userId,
          lessonId: lessonId,
        );
      }

      _clearProgress();
      return true;
    } catch (e) {
      _setError('Failed to reset progress: $e');
      return false;
    } finally {
      _setLoading(false);
    }
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
