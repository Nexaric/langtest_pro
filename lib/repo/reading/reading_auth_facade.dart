import 'package:dartz/dartz.dart';
import 'dart:async';

abstract class ReadingAuthFacade {
  String? getCurrentUserId();
  bool isUserAuthenticated();
  Stream<bool> get authStateChanges;

  Future<Either<String, int?>> getAcademicReadingProgress({
    required String userId,
    required int lessonId,
  });

  Future<Either<String, int?>> getGeneralTrainingProgress({
    required String userId,
    required int lessonId,
  });

  Future<Either<String, void>> upsertAcademicReadingProgress({
    required String userId,
    required int lessonId,
    required int progress,
  });

  Future<Either<String, void>> upsertGeneralTrainingProgress({
    required String userId,
    required int lessonId,
    required int progress,
  });

  Future<Either<String, Map<int, int>>> getAllAcademicReadingProgress({
    required String userId,
  });

  Future<Either<String, Map<int, int>>> getAllGeneralTrainingProgress({
    required String userId,
  });

  Future<Either<String, void>> deleteAcademicReadingProgress({
    required String userId,
    required int lessonId,
  });

  Future<Either<String, void>> deleteGeneralTrainingProgress({
    required String userId,
    required int lessonId,
  });

  Future<Either<String, void>> deleteAllAcademicReadingProgress({
    required String userId,
  });

  Future<Either<String, void>> deleteAllGeneralTrainingProgress({
    required String userId,
  });

  Future<Either<String, int>> getHighestCompletedAcademicLesson({
    required String userId,
  });

  Future<Either<String, int>> getHighestCompletedGeneralTrainingLesson({
    required String userId,
  });

  Future<Either<String, bool>> isAcademicReadingLessonAccessible({
    required String userId,
    required int lessonId,
  });

  Future<Either<String, bool>> isGeneralTrainingLessonAccessible({
    required String userId,
    required int lessonId,
  });

  Future<Either<String, Map<String, dynamic>>> getReadingProgressStats({
    required String userId,
  });
}
