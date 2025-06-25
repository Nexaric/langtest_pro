import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:langtest_pro/repo/reading/reading_auth_facade.dart';
import 'package:langtest_pro/repo/reading/reading_impl.dart';

class ReadingProgressController extends GetxController {
  static const int totalAcademicLessons = 40;
  static const int totalGeneralLessons = 14;
  static const int totalLessons = totalAcademicLessons + totalGeneralLessons;

  final _completedAcademicLessons = 0.obs;
  final _completedGeneralLessons = 0.obs;
  final _currentLessonProgress = 0.0.obs;
  final _academicLessonScores = <int, String>{}.obs;
  final _generalLessonScores = <int, String>{}.obs;
  final _isLoading = false.obs;
  final _errorMessage = Rx<String?>(null);

  final IReadingFacade _facade = ReadingImpl();
  final String? _userId = Supabase.instance.client.auth.currentUser?.id;

  int get completedAcademicLessons => _completedAcademicLessons.value;
  int get completedGeneralLessons => _completedGeneralLessons.value;
  double get currentLessonProgress => _currentLessonProgress.value;
  double get progress =>
      (_completedAcademicLessons.value + _completedGeneralLessons.value) /
      totalLessons;
  bool get isLoading => _isLoading.value;
  String? get errorMessage => _errorMessage.value;
  bool get hasError => _errorMessage.value != null;
  Map<int, String> get academicLessonScores =>
      Map.unmodifiable(_academicLessonScores);
  Map<int, String> get generalLessonScores =>
      Map.unmodifiable(_generalLessonScores);

  @override
  void onInit() {
    super.onInit();
    if (_userId != null) _loadProgress();
  }

  Future<void> _loadProgress() async {
    _isLoading.value = true;
    try {
      final prefs = await SharedPreferences.getInstance();
      _completedAcademicLessons.value =
          prefs.getInt('completedAcademicLessons') ?? 0;
      _completedGeneralLessons.value =
          prefs.getInt('completedGeneralLessons') ?? 0;
      _currentLessonProgress.value =
          prefs.getDouble('currentLessonProgress') ?? 0.0;

      final academicScores = prefs.getStringList('academicLessonScores') ?? [];
      _academicLessonScores.clear();
      for (var entry in academicScores) {
        final parts = entry.split(':');
        if (parts.length == 2) {
          try {
            final lessonId = int.parse(parts[0]);
            _academicLessonScores[lessonId] = parts[1];
          } catch (e) {
            print('Error parsing academic score entry "$entry": $e');
            continue;
          }
        }
      }

      final generalScores = prefs.getStringList('generalLessonScores') ?? [];
      _generalLessonScores.clear();
      for (var entry in generalScores) {
        final parts = entry.split(':');
        if (parts.length == 2) {
          try {
            final lessonId = int.parse(parts[0]);
            _generalLessonScores[lessonId] = parts[1];
          } catch (e) {
            print('Error parsing general score entry "$entry": $e');
            continue;
          }
        }
      }

      if (_userId != null)
        await _facade.loadProgress(uid: _userId!, controller: this);
    } catch (e) {
      _isLoading.value = false;
      _errorMessage.value = 'Failed to load progress: $e';
      print('Load progress error: $e');
    } finally {
      _isLoading.value = false;
      update();
    }
  }

  // Add public loadProgress method
  Future<void> loadProgress() async {
    await _loadProgress();
  }

  Future<void> restoreFromCloud() async {
    if (_userId == null) return;

    _isLoading.value = true;
    try {
      await _facade.loadProgress(uid: _userId!, controller: this);
      await _saveProgress();
      Get.snackbar('Success', 'Progress restored from cloud');
    } catch (e) {
      _isLoading.value = false;
      _errorMessage.value = 'Failed to sync progress: $e';
      print('Cloud sync error: $e');
      Get.snackbar('Error', 'Failed to sync progress: $e');
    } finally {
      _isLoading.value = false;
      update();
    }
  }

  Future<void> completeAcademicLesson({
    required int lessonId,
    required String score,
  }) async {
    if (_userId == null) return;
    if (lessonId < 1 || lessonId > totalAcademicLessons) {
      _errorMessage.value = 'Invalid academic lesson ID: $lessonId';
      return;
    }
    if (lessonId == _completedAcademicLessons.value + 1) {
      _completedAcademicLessons.value++;
      _currentLessonProgress.value = 0.0;
      _academicLessonScores[lessonId] = score;
    } else if (lessonId <= _completedAcademicLessons.value) {
      _academicLessonScores[lessonId] = score;
    }
    await _saveProgress();
  }

  Future<void> completeGeneralLesson({
    required int lessonId,
    required String score,
  }) async {
    if (_userId == null) return;
    if (lessonId < 1 || lessonId > totalGeneralLessons) {
      _errorMessage.value = 'Invalid general lesson ID: $lessonId';
      return;
    }
    if (lessonId == _completedGeneralLessons.value + 1) {
      _completedGeneralLessons.value++;
      _generalLessonScores[lessonId] = score;
    } else if (lessonId <= _completedGeneralLessons.value) {
      _generalLessonScores[lessonId] = score;
    }
    await _saveProgress();
  }

  bool isAcademicLessonAccessible(int lessonId) {
    return lessonId >= 1 && lessonId <= _completedAcademicLessons.value + 1;
  }

  bool isGeneralLessonAccessible(int lessonId) {
    return lessonId >= 1 && lessonId <= _completedGeneralLessons.value + 1;
  }

  void updateProgress(double progress) {
    if (_userId == null) return;
    _currentLessonProgress.value = progress.clamp(0.0, 1.0);
    _saveProgress();
  }

  Future<void> _saveProgress() async {
    if (_userId == null) return;

    _isLoading.value = true;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(
        'completedAcademicLessons',
        _completedAcademicLessons.value,
      );
      await prefs.setInt(
        'completedGeneralLessons',
        _completedGeneralLessons.value,
      );
      await prefs.setDouble(
        'currentLessonProgress',
        _currentLessonProgress.value,
      );
      final academicScores =
          _academicLessonScores.entries
              .map((e) => '${e.key}:${e.value}')
              .toList();
      final generalScores =
          _generalLessonScores.entries
              .map((e) => '${e.key}:${e.value}')
              .toList();
      await prefs.setStringList('academicLessonScores', academicScores);
      await prefs.setStringList('generalLessonScores', generalScores);

      await _facade.syncProgress(uid: _userId!, controller: this);
    } catch (e) {
      _isLoading.value = false;
      _errorMessage.value = 'Failed to save progress: $e';
      print('Save progress error: $e');
    } finally {
      _isLoading.value = false;
      update();
    }
  }

  Future<void> resetProgress() async {
    if (_userId == null) return;

    _completedAcademicLessons.value = 0;
    _completedGeneralLessons.value = 0;
    _currentLessonProgress.value = 0.0;
    _academicLessonScores.clear();
    _generalLessonScores.clear();
    _errorMessage.value = null;
    await _saveProgress();
  }
}
