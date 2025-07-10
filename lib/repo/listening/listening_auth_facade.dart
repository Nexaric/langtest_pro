// lib/domain/listening/listening_auth_facade.dart

import 'package:dartz/dartz.dart';

/// Abstract interface for listening progress authentication and data operations
/// This follows Clean Architecture principles by defining the contract
/// that the data layer must implement
abstract class ListeningAuthFacade {
  /// Get progress for a specific lesson in listening audio lessons
  /// Returns null if no progress exists, or the progress value (50, 75, 100)
  Future<Either<String, int?>> getListeningAudioLessonProgress({
    required String userId,
    required int lessonId,
  });

  /// Get progress for a specific lesson in listening practice tests
  /// Returns null if no progress exists, or the progress value (50, 75, 100)
  Future<Either<String, int?>> getListeningPracticeTestProgress({
    required String userId,
    required int lessonId,
  });

  /// Insert or update progress for listening audio lesson
  /// Progress values: 50 (opened), 75 (started), 100 (completed)
  Future<Either<String, void>> upsertListeningAudioLessonProgress({
    required String userId,
    required int lessonId,
    required int progress,
  });

  /// Insert or update progress for listening practice test
  /// Progress values: 50 (opened), 75 (started), 100 (completed)
  Future<Either<String, void>> upsertListeningPracticeTestProgress({
    required String userId,
    required int lessonId,
    required int progress,
  });

  /// Get all listening audio lessons progress for a user
  /// Returns a map where key is lesson_id and value is progress
  Future<Either<String, Map<int, int>>> getAllListeningAudioLessonsProgress({
    required String userId,
  });

  /// Get all listening practice tests progress for a user
  /// Returns a map where key is lesson_id and value is progress
  Future<Either<String, Map<int, int>>> getAllListeningPracticeTestsProgress({
    required String userId,
  });

  /// Get the current authenticated user ID
  /// Returns null if no user is authenticated
  String? getCurrentUserId();

  /// Check if a user is currently authenticated
  bool isUserAuthenticated();

  /// Get user authentication state stream
  Stream<bool> get authStateChanges;

  /// Delete progress for a specific listening audio lesson
  Future<Either<String, void>> deleteListeningAudioLessonProgress({
    required String userId,
    required int lessonId,
  });

  /// Delete progress for a specific listening practice test
  Future<Either<String, void>> deleteListeningPracticeTestProgress({
    required String userId,
    required int lessonId,
  });

  /// Batch update multiple listening audio lessons progress entries
  Future<Either<String, void>> batchUpdateListeningAudioLessonsProgress({
    required String userId,
    required Map<int, int> progressMap,
  });

  /// Batch update multiple listening practice tests progress entries
  Future<Either<String, void>> batchUpdateListeningPracticeTestsProgress({
    required String userId,
    required Map<int, int> progressMap,
  });

  /// Get the highest completed lesson number for listening audio lessons
  /// Returns 0 if no lessons are completed
  Future<Either<String, int>> getHighestCompletedListeningAudioLesson({
    required String userId,
  });

  /// Get the highest completed lesson number for listening practice tests
  /// Returns 0 if no lessons are completed
  Future<Either<String, int>> getHighestCompletedListeningPracticeTest({
    required String userId,
  });

  /// Check if a specific listening audio lesson is accessible
  /// A lesson is accessible if the previous lesson is completed (100%) or it's lesson 1
  Future<Either<String, bool>> isListeningAudioLessonAccessible({
    required String userId,
    required int lessonId,
  });

  /// Check if a specific listening practice test is accessible
  /// A test is accessible if the previous test is completed (100%) or it's test 1
  Future<Either<String, bool>> isListeningPracticeTestAccessible({
    required String userId,
    required int lessonId,
  });

  /// Get overall listening progress statistics
  /// Returns a map with completion percentages and other stats
  Future<Either<String, Map<String, dynamic>>> getListeningProgressStats({
    required String userId,
  });
}

