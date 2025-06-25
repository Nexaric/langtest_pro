import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:langtest_pro/repo/listening/listening_auth_facade.dart';
import 'package:langtest_pro/repo/listening/listening_impl.dart';

class ListeningProgressController extends GetxController {
  static const int totalLessons = 50;
  final _completedLessons = 0.obs;
  final _currentLessonProgress = 0.0.obs;
  final _practiceTestCompletion =
      <String, bool>{
        'Part 1': false,
        'Part 2': false,
        'Part 3': false,
        'Part 4': false,
      }.obs;
  final _isLoading = false.obs;
  final _hasError = false.obs;
  final _errorMessage = Rx<String?>(null);
  Box? _progressBox;
  final IListeningFacade _facade = ListeningImpl();
  final String? _userId = Supabase.instance.client.auth.currentUser?.id;

  int get completedLessons => _completedLessons.value;
  double get currentLessonProgress => _currentLessonProgress.value;
  double get lessonProgressPercentage =>
      (_completedLessons / totalLessons) * 100;
  double get progress => _completedLessons / totalLessons;
  bool get isLoading => _isLoading.value;
  bool get hasError => _hasError.value;
  String? get errorMessage => _errorMessage.value;
  Map<String, bool> get practiceTestCompletion =>
      _practiceTestCompletion.value; // Add .value

  bool isPracticeTestComplete(String part) =>
      _practiceTestCompletion[part] ?? false;
  double get overallProgress {
    const double lessonWeight = 0.6;
    const double testWeight = 0.4;
    final double testProgress =
        _practiceTestCompletion.values.where((v) => v).length *
        0.25 *
        testWeight;
    return ((lessonProgressPercentage / 100) * lessonWeight) + testProgress;
  }

  double get testProgressPercentage =>
      _practiceTestCompletion.values.where((v) => v).length * 25.0;

  @override
  void onInit() {
    super.onInit();
    _initialize();
  }

  Future<void> _initialize() async {
    await _initHive();
    if (_userId != null) await _loadProgress();
  }

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

  Future<void> _loadProgress() async {
    if (_isLoading.value || _userId == null) return;

    _isLoading.value = true;
    _hasError.value = false;
    _errorMessage.value = null;
    update();

    try {
      if (_progressBox != null && _progressBox!.isOpen) {
        _completedLessons.value =
            _progressBox!.get('completedLessons', defaultValue: 0) as int;
        _currentLessonProgress.value =
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
      }
      await _facade.loadProgress(uid: _userId!, controller: this);
    } catch (e) {
      _hasError.value = true;
      _errorMessage.value = 'Failed to load progress: $e';
      if (kDebugMode) print('Progress loading error: $e');
    } finally {
      _isLoading.value = false;
      update();
    }
  }

  Future<void> loadProgress() async {
    await _loadProgress();
  }

  Future<void> completeLesson() async {
    if (_completedLessons >= totalLessons || _userId == null) return;

    try {
      _completedLessons.value++;
      _currentLessonProgress.value = 1.0;
      await _saveProgress();
    } catch (e) {
      _hasError.value = true;
      _errorMessage.value = 'Failed to complete lesson: $e';
      if (kDebugMode) print('Lesson completion error: $e');
      update();
    }
  }

  void updateProgress(double progress) {
    if (_completedLessons >= totalLessons || _userId == null) return;

    try {
      _currentLessonProgress.value = progress.clamp(0.0, 1.0);
      _saveProgress();
      update();
    } catch (e) {
      if (kDebugMode) print('Progress update error: $e');
    }
  }

  Future<void> completePracticeTest(String part) async {
    if (_practiceTestCompletion[part] == true ||
        _userId == null ||
        !_practiceTestCompletion.containsKey(part))
      return;

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

  Future<void> _saveProgress() async {
    if (_userId == null) return;

    try {
      if (_progressBox != null && _progressBox!.isOpen) {
        await _progressBox!.put('completedLessons', _completedLessons.value);
        await _progressBox!.put(
          'currentLessonProgress',
          _currentLessonProgress.value,
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
      await _facade.syncProgress(uid: _userId!, controller: this);
    } catch (e) {
      _hasError.value = true;
      _errorMessage.value = 'Failed to save progress: $e';
      if (kDebugMode) print('Progress saving error: $e');
      throw Exception('Failed to save progress: $e');
    }
  }

  Future<void> restoreFromCloud() async {
    if (_userId == null) return;

    _isLoading.value = true;
    _hasError.value = false;
    _errorMessage.value = null;
    update();

    try {
      await _facade.loadProgress(uid: _userId!, controller: this);
      await _saveProgress();
    } catch (e) {
      _hasError.value = true;
      _errorMessage.value = 'Failed to restore from cloud: $e';
      if (kDebugMode) print('Cloud restore error: $e');
    } finally {
      _isLoading.value = false;
      update();
    }
  }

  Future<void> resetProgress() async {
    if (_userId == null) return;

    try {
      _completedLessons.value = 0;
      _currentLessonProgress.value = 0.0;
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
