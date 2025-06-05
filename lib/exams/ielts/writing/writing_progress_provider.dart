import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WritingProgressProvider with ChangeNotifier {
  // Total number of lessons (40 Writing Task 2 + 14 Formal Letters)
  static const int totalLessons = 54;
  static const int totalWritingLessons = 40;
  static const int totalLetterLessons = 14;

  // Track completed Writing Task 2 lessons
  int _completedLessons = 0;
  final Set<int> _completedLessonIds = {};

  // Track completed Formal Letter lessons
  int _completedLetterLessons = 0;
  final Set<int> _completedLetterIds = {};

  // SharedPreferences for persistence
  SharedPreferences? _prefs;

  WritingProgressProvider() {
    _loadProgress();
  }

  // Getters
  int get completedLessons => _completedLessons;
  Set<int> get completedLessonIds => _completedLessonIds;
  int get completedLetterLessons => _completedLetterLessons;
  Set<int> get completedLetterIds => _completedLetterIds;

  double get progress =>
      (_completedLessons + _completedLetterLessons) / totalLessons;

  int get completionPercentage => ((progress) * 100).round();

  // Load progress from SharedPreferences
  Future<void> _loadProgress() async {
    try {
      _prefs = await SharedPreferences.getInstance();
      _completedLessons = _prefs?.getInt('completedLessons') ?? 0;
      _completedLetterLessons = _prefs?.getInt('completedLetterLessons') ?? 0;

      final lessonIds = _prefs?.getStringList('completedLessonIds') ?? [];
      _completedLessonIds.addAll(lessonIds.map(int.parse));

      final letterIds = _prefs?.getStringList('completedLetterIds') ?? [];
      _completedLetterIds.addAll(letterIds.map(int.parse));

      notifyListeners();
    } catch (e) {
      debugPrint('Error loading progress: $e');
    }
  }

  // Save progress to SharedPreferences
  Future<void> _saveProgress() async {
    try {
      await _prefs?.setInt('completedLessons', _completedLessons);
      await _prefs?.setInt('completedLetterLessons', _completedLetterLessons);
      await _prefs?.setStringList(
        'completedLessonIds',
        _completedLessonIds.map((id) => id.toString()).toList(),
      );
      await _prefs?.setStringList(
        'completedLetterIds',
        _completedLetterIds.map((id) => id.toString()).toList(),
      );
    } catch (e) {
      debugPrint('Error saving progress: $e');
    }
  }

  // Complete a Writing Task 2 lesson
  void completeLesson(int lessonNumber) {
    if (lessonNumber < 1 || lessonNumber > totalWritingLessons) {
      debugPrint('Invalid lesson number: $lessonNumber');
      return;
    }
    if (_completedLessonIds.add(lessonNumber)) {
      _completedLessons = _completedLessonIds.length;
      _saveProgress();
      notifyListeners();
    }
  }

  // Complete a Formal Letter lesson
  void completeLetterLesson(int letterId) {
    if (letterId < 1 || letterId > totalLetterLessons) {
      debugPrint('Invalid letter ID: $letterId');
      return;
    }
    if (_completedLetterIds.add(letterId)) {
      _completedLetterLessons = _completedLetterIds.length;
      _saveProgress();
      notifyListeners();
    }
  }

  // Check if a Writing Task 2 lesson is completed
  bool isLessonCompleted(int lessonNumber) {
    return _completedLessonIds.contains(lessonNumber);
  }

  // Check if a Formal Letter lesson is completed
  bool isLetterLessonCompleted(int letterId) {
    return _completedLetterIds.contains(letterId);
  }

  // Reset all progress (optional, for debugging or user reset)
  Future<void> resetProgress() async {
    _completedLessons = 0;
    _completedLessonIds.clear();
    _completedLetterLessons = 0;
    _completedLetterIds.clear();
    await _saveProgress();
    notifyListeners();
  }
}
