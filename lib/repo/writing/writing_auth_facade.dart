// lib/domain/writing/writing_auth_facade.dart

import 'package:dartz/dartz.dart';

/// Abstract interface for writing progress authentication and data operations
/// This follows Clean Architecture principles by defining the contract
/// that the data layer must implement
abstract class WritingAuthFacade {
  /// Get progress for a specific lesson in writing lessons
  /// Returns null if no progress exists, or the progress value (50, 75, 100)
  Future<Either<String, int?>> getWritingLessonProgress({
    required String userId,
    required int lessonId,
  });

  /// Get progress for a specific lesson in writing letters
  /// Returns null if no progress exists, or the progress value (50, 75, 100)
  Future<Either<String, int?>> getWritingLetterProgress({
    required String userId,
    required int lessonId,
  });

  /// Insert or update progress for writing lesson
  /// Progress values: 50 (opened), 75 (started), 100 (completed)
  Future<Either<String, void>> upsertWritingLessonProgress({
    required String userId,
    required int lessonId,
    required int progress,
  });

  /// Insert or update progress for writing letter
  /// Progress values: 50 (opened), 75 (started), 100 (completed)
  Future<Either<String, void>> upsertWritingLetterProgress({
    required String userId,
    required int lessonId,
    required int progress,
  });

  /// Get all writing lessons progress for a user
  /// Returns a map where key is lesson_id and value is progress
  Future<Either<String, Map<int, int>>> getAllWritingLessonsProgress({
    required String userId,
  });

  /// Get all writing letters progress for a user
  /// Returns a map where key is lesson_id and value is progress
  Future<Either<String, Map<int, int>>> getAllWritingLettersProgress({
    required String userId,
  });

  /// Delete progress for a specific writing lesson
  Future<Either<String, void>> deleteWritingLessonProgress({
    required String userId,
    required int lessonId,
  });

  /// Delete progress for a specific writing letter
  Future<Either<String, void>> deleteWritingLetterProgress({
    required String userId,
    required int lessonId,
  });

  /// Batch update multiple writing lessons progress entries
  Future<Either<String, void>> batchUpdateWritingLessonsProgress({
    required String userId,
    required Map<int, int> progressMap,
  });

  /// Batch update multiple writing letters progress entries
  Future<Either<String, void>> batchUpdateWritingLettersProgress({
    required String userId,
    required Map<int, int> progressMap,
  });

  /// Get the highest completed lesson number for writing lessons
  /// Returns 0 if no lessons are completed
  Future<Either<String, int>> getHighestCompletedWritingLesson({
    required String userId,
  });

  /// Get the highest completed lesson number for writing letters
  /// Returns 0 if no lessons are completed
  Future<Either<String, int>> getHighestCompletedWritingLetter({
    required String userId,
  });

  /// Check if a specific writing lesson is accessible
  /// A lesson is accessible if the previous lesson is completed (100%) or it's lesson 1
  Future<Either<String, bool>> isWritingLessonAccessible({
    required String userId,
    required int lessonId,
  });

  /// Check if a specific writing letter is accessible
  /// A letter is accessible if the previous letter is completed (100%) or it's letter 1
  Future<Either<String, bool>> isWritingLetterAccessible({
    required String userId,
    required int lessonId,
  });

  /// Get overall writing progress statistics
  /// Returns a map with completion percentages and other stats
  Future<Either<String, Map<String, dynamic>>> getWritingProgressStats({
    required String userId,
    required int totalLessons,
    required int totalLetters,
  });

  // Auth related methods
  String? getCurrentUserId();
  bool isUserAuthenticated();
  Stream<bool> get authStateChanges;
}
