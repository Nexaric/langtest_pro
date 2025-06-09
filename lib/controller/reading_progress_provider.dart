import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReadingProgressProvider with ChangeNotifier {
  static const int totalAcademicLessons = 40;
  static const int totalGeneralLessons = 14;
  static const int totalLessons = totalAcademicLessons + totalGeneralLessons;

  int _completedAcademicLessons = 0;
  int _completedGeneralLessons = 0;
  double _currentLessonProgress = 0.0;
  final Map<int, String> _academicLessonScores = {};
  final Map<int, String> _generalLessonScores = {};
  bool _isLoading = false;
  String? _errorMessage;

  int get completedAcademicLessons => _completedAcademicLessons;
  int get completedGeneralLessons => _completedGeneralLessons;
  double get currentLessonProgress => _currentLessonProgress;
  double get progress =>
      (_completedAcademicLessons + _completedGeneralLessons) / totalLessons;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasError => _errorMessage != null;
  Map<int, String> get academicLessonScores =>
      Map.unmodifiable(_academicLessonScores);
  Map<int, String> get generalLessonScores =>
      Map.unmodifiable(_generalLessonScores);

  ReadingProgressProvider() {
    _loadProgress();
  }

  Future<void> _loadProgress() async {
    _isLoading = true;
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      _completedAcademicLessons = prefs.getInt('completedAcademicLessons') ?? 0;
      _completedGeneralLessons = prefs.getInt('completedGeneralLessons') ?? 0;
      _currentLessonProgress = prefs.getDouble('currentLessonProgress') ?? 0.0;
      final academicScores = prefs.getStringList('academicLessonScores') ?? [];
      final generalScores = prefs.getStringList('generalLessonScores') ?? [];
      for (var entry in academicScores) {
        final parts = entry.split(':');
        if (parts.length == 2) {
          _academicLessonScores[int.parse(parts[0])] = parts[1];
        }
      }
      for (var entry in generalScores) {
        final parts = entry.split(':');
        if (parts.length == 2) {
          _generalLessonScores[int.parse(parts[0])] = parts[1];
        }
      }
      _isLoading = false;
      _errorMessage = null;
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Failed to load progress: $e';
    }
    notifyListeners();
  }

  Future<void> restoreFromCloud() async {
    _isLoading = true;
    notifyListeners();
    try {
      await Future.delayed(const Duration(seconds: 1));
      _isLoading = false;
      _errorMessage = null;
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Failed to sync progress: $e';
    }
    notifyListeners();
  }

  Future<void> completeAcademicLesson({
    required int lessonId,
    required String score,
  }) async {
    if (lessonId == _completedAcademicLessons + 1) {
      _completedAcademicLessons++;
      _currentLessonProgress = 0.0;
      _academicLessonScores[lessonId] = score;
    } else if (lessonId <= _completedAcademicLessons) {
      _academicLessonScores[lessonId] = score;
    }
    await _saveProgress();
    notifyListeners();
  }

  Future<void> completeGeneralLesson({
    required int lessonId,
    required String score,
  }) async {
    if (lessonId == _completedGeneralLessons + 1) {
      _completedGeneralLessons++;
      _generalLessonScores[lessonId] = score;
    } else if (lessonId <= _completedGeneralLessons) {
      _generalLessonScores[lessonId] = score;
    }
    await _saveProgress();
    notifyListeners();
  }

  bool isAcademicLessonAccessible(int lessonId) {
    return lessonId <= _completedAcademicLessons + 1;
  }

  bool isGeneralLessonAccessible(int lessonId) {
    return lessonId <= _completedGeneralLessons + 1;
  }

  void updateProgress(double progress) {
    _currentLessonProgress = progress.clamp(0.0, 1.0);
    _saveProgress();
    notifyListeners();
  }

  Future<void> _saveProgress() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('completedAcademicLessons', _completedAcademicLessons);
      await prefs.setInt('completedGeneralLessons', _completedGeneralLessons);
      await prefs.setDouble('currentLessonProgress', _currentLessonProgress);
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
    } catch (e) {
      _errorMessage = 'Failed to save progress: $e';
    }
  }

  void resetProgress() {
    _completedAcademicLessons = 0;
    _completedGeneralLessons = 0;
    _currentLessonProgress = 0.0;
    _academicLessonScores.clear();
    _generalLessonScores.clear();
    _errorMessage = null;
    _saveProgress();
    notifyListeners();
  }
}
