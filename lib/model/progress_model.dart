import 'dart:convert';

class LessonProgress {
  final int lesson;
  final bool? isPassed;
  final bool? isLocked;
  final int? progress;

  LessonProgress({
    required this.lesson,
    this.isPassed,
    this.isLocked,
    this.progress,
  });

  factory LessonProgress.fromJson(Map<String, dynamic> json) {
    return LessonProgress(
      lesson: json['lesson'],
      isPassed: json['isPassed'],
      isLocked: json['isLocked'],
      progress: json['progress'],
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{'lesson': lesson};
    if (isPassed != null) data['isPassed'] = isPassed;
    if (isLocked != null) data['isLocked'] = isLocked;
    if (progress != null) data['progress'] = progress;
    return data;
  }
}

class ProgressModel {
  final String uid;
  final List<LessonProgress> progress;
  final bool? isInitialized;

  ProgressModel({
    required this.uid,
    required this.progress,
    this.isInitialized,
  });

  factory ProgressModel.fromJson(Map<String, dynamic> json) {
    return ProgressModel(
      uid: json['uid'],
      progress:
          (json['progress'] as List<dynamic>)
              .map((item) => LessonProgress.fromJson(jsonDecode(item)))
              .toList(),
      isInitialized: json['isInitialized'],
    );
  }

  Map<String, dynamic> toJson() => {
    'uid': uid,
    'progress': progress.map((e) => jsonEncode(e.toJson())).toList(),
    'isInitialized': isInitialized,
  };
}
