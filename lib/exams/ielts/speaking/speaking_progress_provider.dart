import 'package:flutter/material.dart';

class SpeakingProgressProvider extends ChangeNotifier {
  static const int totalLessons = 50;
  int _completedLessons = 0;

  int get completedLessons => _completedLessons;
  double get progress =>
      totalLessons > 0 ? _completedLessons / totalLessons : 0;

  void completeLesson() {
    if (_completedLessons < totalLessons) {
      _completedLessons++;
      notifyListeners();
    }
  }

  void resetProgress() {
    _completedLessons = 0;
    notifyListeners();
  }

  // Optional: Track speaking scores if needed
  double _averageScore = 0.0;
  int _totalAssessments = 0;

  double get averageScore => _averageScore;
  int get totalAssessments => _totalAssessments;

  void addAssessment(double score) {
    _totalAssessments++;
    _averageScore =
        ((_averageScore * (_totalAssessments - 1)) + score) / _totalAssessments;
    notifyListeners();
  }

  // Optional: Save and load progress methods
  Future<void> saveProgress() async {
    // Implement using shared_preferences or other storage
  }

  Future<void> loadProgress() async {
    // Implement loading from storage
  }
}
