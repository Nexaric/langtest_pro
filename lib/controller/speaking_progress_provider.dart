import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SpeakingProgressController extends GetxController {
  static const int totalLessons = 50;

  final _completedLessons = 0.obs;
  final _averageScore = 0.0.obs;
  final _totalAssessments = 0.obs;
  final _isLoading = false.obs;
  final _errorMessage = Rx<String?>('');

  int get completedLessons => _completedLessons.value;
  double get progress =>
      totalLessons > 0 ? _completedLessons.value / totalLessons : 0;
  double get averageScore => _averageScore.value;
  int get totalAssessments => _totalAssessments.value;
  bool get isLoading => _isLoading.value;
  String? get errorMessage => _errorMessage.value;
  bool get hasError =>
      _errorMessage.value != null && _errorMessage.value!.isNotEmpty;

  @override
  void onInit() {
    super.onInit();
    _loadProgress();
  }

  Future<void> _loadProgress() async {
    _isLoading.value = true;
    try {
      final prefs = await SharedPreferences.getInstance();
      _completedLessons.value = prefs.getInt('completedSpeakingLessons') ?? 0;
      _averageScore.value = prefs.getDouble('averageSpeakingScore') ?? 0.0;
      _totalAssessments.value = prefs.getInt('totalSpeakingAssessments') ?? 0;
      _isLoading.value = false;
      _errorMessage.value = '';
    } catch (e) {
      _isLoading.value = false;
      _errorMessage.value = 'Failed to load speaking progress: $e';
    }
  }

  Future<void> completeLesson() async {
    if (_completedLessons.value < totalLessons) {
      _completedLessons.value++;
      await _saveProgress();
    }
  }

  Future<void> addAssessment(double score) async {
    _totalAssessments.value++;
    _averageScore.value =
        ((_averageScore.value * (_totalAssessments.value - 1)) + score) /
        _totalAssessments.value;
    await _saveProgress();
  }

  Future<void> resetProgress() async {
    _completedLessons.value = 0;
    _averageScore.value = 0.0;
    _totalAssessments.value = 0;
    _errorMessage.value = '';
    await _saveProgress();
  }

  Future<void> _saveProgress() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('completedSpeakingLessons', _completedLessons.value);
      await prefs.setDouble('averageSpeakingScore', _averageScore.value);
      await prefs.setInt('totalSpeakingAssessments', _totalAssessments.value);
      _errorMessage.value = '';
    } catch (e) {
      _errorMessage.value = 'Failed to save speaking progress: $e';
    }
  }
}
