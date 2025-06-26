import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WritingProgressController extends GetxController {
  // Total number of lessons (40 Writing Task 2 + 14 Formal Letters)
  static const int totalLessons = 54;
  static const int totalWritingLessons = 40;
  static const int totalLetterLessons = 14;

  // Track completed Writing Task 2 lessons
  final _completedLessons = 0.obs;
  final _completedLessonIds = <int>{}.obs;

  // Track completed Formal Letter lessons
  final _completedLetterLessons = 0.obs;
  final _completedLetterIds = <int>{}.obs;

  // SharedPreferences for persistence
  SharedPreferences? _prefs;

  WritingProgressController() {
    _loadProgress();
  }

  // Getters
  int get completedLessons => _completedLessons.value;
  Set<int> get completedLessonIds => _completedLessonIds.toSet();
  int get completedLetterLessons => _completedLetterLessons.value;
  Set<int> get completedLetterIds => _completedLetterIds.toSet();

  double get progress =>
      (_completedLessons.value + _completedLetterLessons.value) / totalLessons;

  int get completionPercentage => (progress * 100).round();

  // Load progress from SharedPreferences
  Future<void> _loadProgress() async {
    try {
      _prefs = await SharedPreferences.getInstance();
      _completedLessons.value = _prefs?.getInt('completedLessons') ?? 0;
      _completedLetterLessons.value =
          _prefs?.getInt('completedLetterLessons') ?? 0;

      final lessonIds = _prefs?.getStringList('completedLessonIds') ?? [];
      _completedLessonIds.addAll(lessonIds.map(int.parse));

      final letterIds = _prefs?.getStringList('completedLetterIds') ?? [];
      _completedLetterIds.addAll(letterIds.map(int.parse));

      update();
    } catch (e) {
      print('Error loading progress: $e');
    }
  }

  // Save progress to SharedPreferences
  Future<void> _saveProgress() async {
    try {
      await _prefs?.setInt('completedLessons', _completedLessons.value);
      await _prefs?.setInt(
        'completedLetterLessons',
        _completedLetterLessons.value,
      );
      await _prefs?.setStringList(
        'completedLessonIds',
        _completedLessonIds.map((id) => id.toString()).toList(),
      );
      await _prefs?.setStringList(
        'completedLetterIds',
        _completedLetterIds.map((id) => id.toString()).toList(),
      );
    } catch (e) {
      print('Error saving progress: $e');
    }
  }

  // Complete a Writing Task 2 lesson
  void completeLesson(int lessonNumber) {
    if (lessonNumber < 1 || lessonNumber > totalWritingLessons) {
      print('Invalid lesson number: $lessonNumber');
      return;
    }
    if (_completedLessonIds.add(lessonNumber)) {
      _completedLessons.value = _completedLessonIds.length;
      _saveProgress();
      update();
    }
  }

  // Complete a Formal Letter lesson
  void completeLetterLesson(int letterId) {
    if (letterId < 1 || letterId > totalLetterLessons) {
      print('Invalid letter ID: $letterId');
      return;
    }
    if (_completedLetterIds.add(letterId)) {
      _completedLetterLessons.value = _completedLetterIds.length;
      _saveProgress();
      update();
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

  // Reset all progress
  Future<void> resetProgress() async {
    _completedLessons.value = 0;
    _completedLessonIds.clear();
    _completedLetterLessons.value = 0;
    _completedLetterIds.clear();
    await _saveProgress();
    update();
  }
}
