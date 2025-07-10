import 'package:dartz/dartz.dart';
import 'package:langtest_pro/repo/writing/writing_auth_facade.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:async';

class WritingImpl implements WritingAuthFacade {
  final SupabaseClient _supabase = Supabase.instance.client;

  static const String _writingLessonsTable = 'writing_lessons';
  static const String _writingLettersTable = 'writing_letters';

  final StreamController<bool> _authStateController =
      StreamController<bool>.broadcast();

  WritingImpl() {
    _supabase.auth.onAuthStateChange.listen((data) {
      _authStateController.add(data.session != null);
    });
  }

  @override
  String? getCurrentUserId() {
    return _supabase.auth.currentUser?.id;
  }

  @override
  bool isUserAuthenticated() {
    return _supabase.auth.currentUser != null;
  }

  @override
  Stream<bool> get authStateChanges => _authStateController.stream;

  @override
  Future<Either<String, int?>> getWritingLessonProgress({
    required String userId,
    required int lessonId,
  }) async {
    try {
      final response =
          await _supabase
              .from(_writingLessonsTable)
              .select('progress')
              .eq('user_id', userId)
              .eq('lesson_id', lessonId)
              .maybeSingle();

      if (response == null) {
        return const Right(null);
      }

      return Right(response['progress'] as int);
    } on PostgrestException catch (e) {
      return Left('Database error: ${e.message}');
    } catch (e) {
      return Left('Unexpected error: $e');
    }
  }

  @override
  Future<Either<String, int?>> getWritingLetterProgress({
    required String userId,
    required int lessonId,
  }) async {
    try {
      final response =
          await _supabase
              .from(_writingLettersTable)
              .select('progress')
              .eq('user_id', userId)
              .eq('lesson_id', lessonId)
              .maybeSingle();

      if (response == null) {
        return const Right(null);
      }

      return Right(response['progress'] as int);
    } on PostgrestException catch (e) {
      return Left('Database error: ${e.message}');
    } catch (e) {
      return Left('Unexpected error: $e');
    }
  }

  @override
  Future<Either<String, void>> upsertWritingLessonProgress({
    required String userId,
    required int lessonId,
    required int progress,
  }) async {
    try {
      if (![50, 75, 100].contains(progress)) {
        return const Left('Invalid progress value. Must be 50, 75, or 100.');
      }

      await _supabase.from(_writingLessonsTable).upsert({
        'user_id': userId,
        'lesson_id': lessonId,
        'progress': progress,
        'updated_at': DateTime.now().toIso8601String(),
      }, onConflict: 'user_id,lesson_id');

      return const Right(null);
    } on PostgrestException catch (e) {
      return Left('Database error: ${e.message}');
    } catch (e) {
      return Left('Unexpected error: $e');
    }
  }

  @override
  Future<Either<String, void>> upsertWritingLetterProgress({
    required String userId,
    required int lessonId,
    required int progress,
  }) async {
    try {
      if (![50, 75, 100].contains(progress)) {
        return const Left('Invalid progress value. Must be 50, 75, or 100.');
      }

      await _supabase.from(_writingLettersTable).upsert({
        'user_id': userId,
        'lesson_id': lessonId,
        'progress': progress,
        'updated_at': DateTime.now().toIso8601String(),
      }, onConflict: 'user_id,lesson_id');

      return const Right(null);
    } on PostgrestException catch (e) {
      return Left('Database error: ${e.message}');
    } catch (e) {
      return Left('Unexpected error: $e');
    }
  }

  @override
  Future<Either<String, Map<int, int>>> getAllWritingLessonsProgress({
    required String userId,
  }) async {
    try {
      final response = await _supabase
          .from(_writingLessonsTable)
          .select('lesson_id, progress')
          .eq('user_id', userId)
          .order('lesson_id', ascending: true);

      final Map<int, int> progressMap = {};
      for (final row in response) {
        progressMap[row['lesson_id'] as int] = row['progress'] as int;
      }

      return Right(progressMap);
    } on PostgrestException catch (e) {
      return Left('Database error: ${e.message}');
    } catch (e) {
      return Left('Unexpected error: $e');
    }
  }

  @override
  Future<Either<String, Map<int, int>>> getAllWritingLettersProgress({
    required String userId,
  }) async {
    try {
      final response = await _supabase
          .from(_writingLettersTable)
          .select('lesson_id, progress')
          .eq('user_id', userId)
          .order('lesson_id', ascending: true);

      final Map<int, int> progressMap = {};
      for (final row in response) {
        progressMap[row['lesson_id'] as int] = row['progress'] as int;
      }

      return Right(progressMap);
    } on PostgrestException catch (e) {
      return Left('Database error: ${e.message}');
    } catch (e) {
      return Left('Unexpected error: $e');
    }
  }

  @override
  Future<Either<String, void>> deleteWritingLessonProgress({
    required String userId,
    required int lessonId,
  }) async {
    try {
      await _supabase
          .from(_writingLessonsTable)
          .delete()
          .eq('user_id', userId)
          .eq('lesson_id', lessonId);

      return const Right(null);
    } on PostgrestException catch (e) {
      return Left('Database error: ${e.message}');
    } catch (e) {
      return Left('Unexpected error: $e');
    }
  }

  @override
  Future<Either<String, void>> deleteWritingLetterProgress({
    required String userId,
    required int lessonId,
  }) async {
    try {
      await _supabase
          .from(_writingLettersTable)
          .delete()
          .eq('user_id', userId)
          .eq('lesson_id', lessonId);

      return const Right(null);
    } on PostgrestException catch (e) {
      return Left('Database error: ${e.message}');
    } catch (e) {
      return Left('Unexpected error: $e');
    }
  }

  @override
  Future<Either<String, void>> batchUpdateWritingLessonsProgress({
    required String userId,
    required Map<int, int> progressMap,
  }) async {
    try {
      final List<Map<String, dynamic>> upsertData = [];

      for (final entry in progressMap.entries) {
        if (![50, 75, 100].contains(entry.value)) {
          return Left(
            'Invalid progress value for lesson ${entry.key}. Must be 50, 75, or 100.',
          );
        }

        upsertData.add({
          'user_id': userId,
          'lesson_id': entry.key,
          'progress': entry.value,
          'updated_at': DateTime.now().toIso8601String(),
        });
      }

      await _supabase
          .from(_writingLessonsTable)
          .upsert(upsertData, onConflict: 'user_id,lesson_id');

      return const Right(null);
    } on PostgrestException catch (e) {
      return Left('Database error: ${e.message}');
    } catch (e) {
      return Left('Unexpected error: $e');
    }
  }

  @override
  Future<Either<String, void>> batchUpdateWritingLettersProgress({
    required String userId,
    required Map<int, int> progressMap,
  }) async {
    try {
      final List<Map<String, dynamic>> upsertData = [];

      for (final entry in progressMap.entries) {
        if (![50, 75, 100].contains(entry.value)) {
          return Left(
            'Invalid progress value for letter ${entry.key}. Must be 50, 75, or 100.',
          );
        }

        upsertData.add({
          'user_id': userId,
          'lesson_id': entry.key,
          'progress': entry.value,
          'updated_at': DateTime.now().toIso8601String(),
        });
      }

      await _supabase
          .from(_writingLettersTable)
          .upsert(upsertData, onConflict: 'user_id,lesson_id');

      return const Right(null);
    } on PostgrestException catch (e) {
      return Left('Database error: ${e.message}');
    } catch (e) {
      return Left('Unexpected error: $e');
    }
  }

  @override
  Future<Either<String, int>> getHighestCompletedWritingLesson({
    required String userId,
  }) async {
    try {
      final response = await _supabase
          .from(_writingLessonsTable)
          .select('lesson_id')
          .eq('user_id', userId)
          .eq('progress', 100)
          .order('lesson_id', ascending: false)
          .limit(1);

      if (response.isEmpty) {
        return const Right(0);
      }

      return Right(response.first['lesson_id'] as int);
    } on PostgrestException catch (e) {
      return Left('Database error: ${e.message}');
    } catch (e) {
      return Left('Unexpected error: $e');
    }
  }

  @override
  Future<Either<String, int>> getHighestCompletedWritingLetter({
    required String userId,
  }) async {
    try {
      final response = await _supabase
          .from(_writingLettersTable)
          .select('lesson_id')
          .eq('user_id', userId)
          .eq('progress', 100)
          .order('lesson_id', ascending: false)
          .limit(1);

      if (response.isEmpty) {
        return const Right(0);
      }

      return Right(response.first['lesson_id'] as int);
    } on PostgrestException catch (e) {
      return Left('Database error: ${e.message}');
    } catch (e) {
      return Left('Unexpected error: $e');
    }
  }

  @override
  Future<Either<String, bool>> isWritingLessonAccessible({
    required String userId,
    required int lessonId,
  }) async {
    try {
      if (lessonId == 1) {
        return const Right(true);
      }

      final previousLessonResult = await getWritingLessonProgress(
        userId: userId,
        lessonId: lessonId - 1,
      );

      return previousLessonResult.fold(
        (error) => Left(error),
        (progress) => Right(progress == 100),
      );
    } catch (e) {
      return Left('Unexpected error: $e');
    }
  }

  @override
  Future<Either<String, bool>> isWritingLetterAccessible({
    required String userId,
    required int lessonId,
  }) async {
    try {
      if (lessonId == 1) {
        return const Right(true);
      }

      final previousLetterResult = await getWritingLetterProgress(
        userId: userId,
        lessonId: lessonId - 1,
      );

      return previousLetterResult.fold(
        (error) => Left(error),
        (progress) => Right(progress == 100),
      );
    } catch (e) {
      return Left('Unexpected error: $e');
    }
  }

  @override
  Future<Either<String, Map<String, dynamic>>> getWritingProgressStats({
    required String userId,
    required int totalLessons,
    required int totalLetters,
  }) async {
    try {
      final lessonsResult = await getAllWritingLessonsProgress(userId: userId);
      final lettersResult = await getAllWritingLettersProgress(userId: userId);

      return lessonsResult.fold(
        (error) => Left(error),
        (lessonsProgress) => lettersResult.fold((error) => Left(error), (
          lettersProgress,
        ) {
          final int completedLessons =
              lessonsProgress.values
                  .where((progress) => progress == 100)
                  .length;
          final int completedLetters =
              lettersProgress.values
                  .where((progress) => progress == 100)
                  .length;
          final int totalWritingTasks = totalLessons + totalLetters;
          final int totalCompletedTasks = completedLessons + completedLetters;

          final int inProgressLessons =
              lessonsProgress.values
                  .where((progress) => progress > 0 && progress < 100)
                  .length;
          final int inProgressLetters =
              lettersProgress.values
                  .where((progress) => progress > 0 && progress < 100)
                  .length;
          final int totalInProgressTasks =
              inProgressLessons + inProgressLetters;

          final double overallCompletionPercentage =
              totalWritingTasks > 0
                  ? (totalCompletedTasks / totalWritingTasks) * 100
                  : 0.0;
          final double lessonsCompletionPercentage =
              totalLessons > 0 ? (completedLessons / totalLessons) * 100 : 0.0;
          final double lettersCompletionPercentage =
              totalLetters > 0 ? (completedLetters / totalLetters) * 100 : 0.0;

          return Right({
            'overall_completion_percentage': overallCompletionPercentage,
            'lessons_completion_percentage': lessonsCompletionPercentage,
            'letters_completion_percentage': lettersCompletionPercentage,
            'total_completed_tasks': totalCompletedTasks,
            'total_in_progress_tasks': totalInProgressTasks,
            'completed_lessons': completedLessons,
            'completed_letters': completedLetters,
            'in_progress_lessons': inProgressLessons,
            'in_progress_letters': inProgressLetters,
            'total_writing_tasks': totalWritingTasks,
            'total_lessons': totalLessons,
            'total_letters': totalLetters,
          });
        }),
      );
    } catch (e) {
      return Left('Unexpected error: $e');
    }
  }

  void dispose() {
    _authStateController.close();
  }
}
