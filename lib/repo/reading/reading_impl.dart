import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:langtest_pro/repo/reading/reading_auth_facade.dart';
import 'dart:async';

class ReadingImpl implements ReadingAuthFacade {
  final SupabaseClient _supabase = Supabase.instance.client;

  static const String _academicReadingTable = 'academic_reading';
  static const String _generalTrainingTable = 'general_training';

  final StreamController<bool> _authStateController =
      StreamController<bool>.broadcast();

  ReadingImpl() {
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
  Future<Either<String, int?>> getAcademicReadingProgress({
    required String userId,
    required int lessonId,
  }) async {
    try {
      final response =
          await _supabase
              .from(_academicReadingTable)
              .select('progress')
              .eq('user_id', userId)
              .eq('lesson_id', lessonId)
              .maybeSingle();

      return Right(response?['progress'] as int? ?? 0);
    } on PostgrestException catch (e) {
      return Left('Database error: ${e.message}');
    } catch (e) {
      return Left('Unexpected error: $e');
    }
  }

  @override
  Future<Either<String, int?>> getGeneralTrainingProgress({
    required String userId,
    required int lessonId,
  }) async {
    try {
      final response =
          await _supabase
              .from(_generalTrainingTable)
              .select('progress')
              .eq('user_id', userId)
              .eq('lesson_id', lessonId)
              .maybeSingle();

      return Right(response?['progress'] as int? ?? 0);
    } on PostgrestException catch (e) {
      return Left('Database error: ${e.message}');
    } catch (e) {
      return Left('Unexpected error: $e');
    }
  }

  @override
  Future<Either<String, void>> upsertAcademicReadingProgress({
    required String userId,
    required int lessonId,
    required int progress,
  }) async {
    try {
      if (![0, 50, 75, 100].contains(progress)) {
        return const Left('Invalid progress value. Must be 0, 50, 75, or 100.');
      }

      await _supabase.from(_academicReadingTable).upsert({
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
  Future<Either<String, void>> upsertGeneralTrainingProgress({
    required String userId,
    required int lessonId,
    required int progress,
  }) async {
    try {
      if (![0, 50, 75, 100].contains(progress)) {
        return const Left('Invalid progress value. Must be 0, 50, 75, or 100.');
      }

      await _supabase.from(_generalTrainingTable).upsert({
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
  Future<Either<String, Map<int, int>>> getAllAcademicReadingProgress({
    required String userId,
  }) async {
    try {
      final response = await _supabase
          .from(_academicReadingTable)
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
  Future<Either<String, Map<int, int>>> getAllGeneralTrainingProgress({
    required String userId,
  }) async {
    try {
      final response = await _supabase
          .from(_generalTrainingTable)
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
  Future<Either<String, void>> deleteAcademicReadingProgress({
    required String userId,
    required int lessonId,
  }) async {
    try {
      await _supabase
          .from(_academicReadingTable)
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
  Future<Either<String, void>> deleteGeneralTrainingProgress({
    required String userId,
    required int lessonId,
  }) async {
    try {
      await _supabase
          .from(_generalTrainingTable)
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
  Future<Either<String, void>> deleteAllAcademicReadingProgress({
    required String userId,
  }) async {
    try {
      await _supabase
          .from(_academicReadingTable)
          .delete()
          .eq('user_id', userId);

      return const Right(null);
    } on PostgrestException catch (e) {
      return Left('Database error: ${e.message}');
    } catch (e) {
      return Left('Unexpected error: $e');
    }
  }

  @override
  Future<Either<String, void>> deleteAllGeneralTrainingProgress({
    required String userId,
  }) async {
    try {
      await _supabase
          .from(_generalTrainingTable)
          .delete()
          .eq('user_id', userId);

      return const Right(null);
    } on PostgrestException catch (e) {
      return Left('Database error: ${e.message}');
    } catch (e) {
      return Left('Unexpected error: $e');
    }
  }

  @override
  Future<Either<String, int>> getHighestCompletedAcademicLesson({
    required String userId,
  }) async {
    try {
      final response = await _supabase
          .from(_academicReadingTable)
          .select('lesson_id')
          .eq('user_id', userId)
          .eq('progress', 100)
          .order('lesson_id', ascending: false)
          .limit(1);

      return Right(response.isEmpty ? 0 : response.first['lesson_id'] as int);
    } on PostgrestException catch (e) {
      return Left('Database error: ${e.message}');
    } catch (e) {
      return Left('Unexpected error: $e');
    }
  }

  @override
  Future<Either<String, int>> getHighestCompletedGeneralTrainingLesson({
    required String userId,
  }) async {
    try {
      final response = await _supabase
          .from(_generalTrainingTable)
          .select('lesson_id')
          .eq('user_id', userId)
          .eq('progress', 100)
          .order('lesson_id', ascending: false)
          .limit(1);

      return Right(response.isEmpty ? 0 : response.first['lesson_id'] as int);
    } on PostgrestException catch (e) {
      return Left('Database error: ${e.message}');
    } catch (e) {
      return Left('Unexpected error: $e');
    }
  }

  @override
  Future<Either<String, bool>> isAcademicReadingLessonAccessible({
    required String userId,
    required int lessonId,
  }) async {
    try {
      if (lessonId == 1) {
        return const Right(true);
      }

      final previousLessonResult = await getAcademicReadingProgress(
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
  Future<Either<String, bool>> isGeneralTrainingLessonAccessible({
    required String userId,
    required int lessonId,
  }) async {
    try {
      if (lessonId == 1) {
        return const Right(true);
      }

      final previousLessonResult = await getGeneralTrainingProgress(
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
  Future<Either<String, Map<String, dynamic>>> getReadingProgressStats({
    required String userId,
  }) async {
    try {
      final academicResult = await getAllAcademicReadingProgress(
        userId: userId,
      );
      final generalResult = await getAllGeneralTrainingProgress(userId: userId);

      return academicResult.fold(
        (error) => Left(error),
        (academicProgress) => generalResult.fold((error) => Left(error), (
          generalProgress,
        ) {
          const int totalAcademicLessons = 40;
          const int totalGeneralLessons = 14;
          const int totalLessons = totalAcademicLessons + totalGeneralLessons;

          final int completedAcademicLessons =
              academicProgress.values
                  .where((progress) => progress == 100)
                  .length;
          final int completedGeneralLessons =
              generalProgress.values
                  .where((progress) => progress == 100)
                  .length;
          final int totalCompletedLessons =
              completedAcademicLessons + completedGeneralLessons;

          final int inProgressAcademicLessons =
              academicProgress.values
                  .where((progress) => progress > 0 && progress < 100)
                  .length;
          final int inProgressGeneralLessons =
              generalProgress.values
                  .where((progress) => progress > 0 && progress < 100)
                  .length;
          final int totalInProgressLessons =
              inProgressAcademicLessons + inProgressGeneralLessons;

          final double overallCompletionPercentage =
              totalLessons > 0
                  ? (totalCompletedLessons / totalLessons) * 100
                  : 0.0;
          final double academicCompletionPercentage =
              totalAcademicLessons > 0
                  ? (completedAcademicLessons / totalAcademicLessons) * 100
                  : 0.0;
          final double generalCompletionPercentage =
              totalGeneralLessons > 0
                  ? (completedGeneralLessons / totalGeneralLessons) * 100
                  : 0.0;

          return Right({
            'overall_completion_percentage': overallCompletionPercentage,
            'academic_completion_percentage': academicCompletionPercentage,
            'general_completion_percentage': generalCompletionPercentage,
            'total_completed_lessons': totalCompletedLessons,
            'total_in_progress_lessons': totalInProgressLessons,
            'completed_academic_lessons': completedAcademicLessons,
            'completed_general_lessons': completedGeneralLessons,
            'in_progress_academic_lessons': inProgressAcademicLessons,
            'in_progress_general_lessons': inProgressGeneralLessons,
            'total_lessons': totalLessons,
            'total_academic_lessons': totalAcademicLessons,
            'total_general_lessons': totalGeneralLessons,
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
