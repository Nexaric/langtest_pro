import 'dart:convert';

class LessonProgress {
  final int lesson;
  final bool isPassed;
  final bool isLocked;
  final int progress;

  LessonProgress({
    required this.lesson,
    required this.isPassed,
    required this.isLocked,
    required this.progress,
  });

  factory LessonProgress.fromJson(Map<String, dynamic> json) {
    return LessonProgress(
      lesson: json['lesson'],
      isPassed: json['isPassed'],
      isLocked: json['isLocked'],
      progress: json['progress'],
    );
  }

  Map<String, dynamic> toJson() => {
        'lesson': lesson,
        'isPassed': isPassed,
        'isLocked': isLocked,
        'progress': progress,
      };
}

class ProgressModel {
  final String uid;
  final List<LessonProgress> progress;
  final bool? isInitialized;

  ProgressModel({
    required this.uid,
    required this.progress,
     this.isInitialized
  });

  factory ProgressModel.fromJson(Map<String, dynamic> json) {
    return ProgressModel(
      uid: json['uid'],
      progress: (json['progress'] as List<dynamic>)
          .map((item) => LessonProgress.fromJson(jsonDecode(item)))
          .toList(),
          isInitialized: json['isInitialized']
    );
  }

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'progress': progress.map((e) => jsonEncode(e.toJson())).toList(),
        'isInitialized' : isInitialized
      };
}
