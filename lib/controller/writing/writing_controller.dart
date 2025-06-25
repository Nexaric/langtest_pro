import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:langtest_pro/repo/writing/writing_auth_facade.dart';
import 'package:langtest_pro/repo/writing/writing_impl.dart';

class WritingProgressController extends GetxController {
  static const int totalLessons = 54;
  static const int totalWritingLessons = 40;
  static const int totalLetterLessons = 14;

  final _completedLessons = 0.obs;
  final _completedLessonIds = <int>{}.obs;
  final _completedLetterLessons = 0.obs;
  final _completedLetterIds = <int>{}.obs;

  SharedPreferences? _prefs;
  final IWritingFacade _facade = WritingImpl();
  final String? _userId = Supabase.instance.client.auth.currentUser?.id;

  int get completedLessons => _completedLessons.value;
  Set<int> get completedLessonIds => _completedLessonIds.toSet();
  int get completedLetterLessons => _completedLetterLessons.value;
  Set<int> get completedLetterIds => _completedLetterIds.toSet();

  double get progress =>
      (_completedLessons.value + _completedLetterLessons.value) / totalLessons;
  int get completionPercentage => (progress * 100).round();

  @override
  void onInit() {
    super.onInit();
    if (_userId != null) _loadProgress();
  }

  Future<void> _loadProgress() async {
    try {
      _prefs = await SharedPreferences.getInstance();
      _completedLessons.value = _prefs?.getInt('completedLessons') ?? 0;
      _completedLetterLessons.value =
          _prefs?.getInt('completedLetterLessons') ?? 0;

      final lessonIds = _prefs?.getStringList('completedLessonIds') ?? [];
      _completedLessonIds.value = lessonIds.map(int.parse).toSet();

      final letterIds = _prefs?.getStringList('completedLetterIds') ?? [];
      _completedLetterIds.value = letterIds.map(int.parse).toSet();

      if (_userId != null)
        await _facade.loadProgress(uid: _userId!, controller: this);
      update();
    } catch (e) {
      print('Error loading progress: $e');
    }
  }

  // Add public loadProgress method
  Future<void> loadProgress() async {
    await _loadProgress();
  }

  Future<void> _saveProgress() async {
    if (_userId == null) return;

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

      await _facade.syncProgress(uid: _userId!, controller: this);
    } catch (e) {
      print('Error saving progress: $e');
    }
  }

  void completeLesson(int lessonNumber) {
    if (_userId == null) return;
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

  void completeLetterLesson(int letterId) {
    if (_userId == null) return;
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

  bool isLessonCompleted(int lessonNumber) {
    return _completedLessonIds.contains(lessonNumber);
  }

  bool isLetterLessonCompleted(int letterId) {
    return _completedLetterIds.contains(letterId);
  }

  Future<void> resetProgress() async {
    if (_userId == null) return;

    _completedLessons.value = 0;
    _completedLessonIds.clear();
    _completedLetterLessons.value = 0;
    _completedLetterIds.clear();
    await _saveProgress();
    update();
  }
}
