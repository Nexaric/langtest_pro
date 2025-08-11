import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:langtest_pro/model/progress_model.dart';
import 'package:langtest_pro/repo/reading/reading_facade.dart';
import 'package:langtest_pro/utils/app_exceptions.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:dartz/dartz.dart';

class ReadingImpl implements ReadingFacade {
  final supabase = Supabase.instance.client;
  final table = 'reading_progress';

  @override
  Future<Either<AppExceptions, ProgressModel>> getProgress({
    required String uid,
  }) async {
    try {
      final response =
          await supabase.from(table).select().eq('uid', uid).single();
      final progressModel = ProgressModel.fromJson(response);
      return Right(progressModel);
    } on SocketException {
      return Left(InternetException());
    } catch (e) {
      return Left(AppExceptions('Some Unknown Error Occured'));
    }
  }

  @override
  Future<Either<AppExceptions, Unit>> initializeProgress({
    required ProgressModel progressModel,
  }) async {
    try {
      await supabase.from(table).upsert(progressModel.toJson());
      await updateLessonProgress(
        lessonProgress: LessonProgress(
          lesson: 1,
          isPassed: false,
          isLocked: false,
          progress: 0,
        ),
      );
      return const Right(unit);
    } on SocketException catch (e) {
      return Left(InternetException("Network Error"));
    } catch (e) {
      return Left(AppExceptions('Failed to save progress: $e'));
    }
  }

  @override
  Future<Either<AppExceptions, bool>> checkifInitialized({
    required ProgressModel progressModel,
  }) async {
    debugPrint(progressModel.uid);
    try {
      final data = await supabase
          .from(table)
          .select()
          .eq('uid', progressModel.uid);
      if (data.isEmpty) {
        return right(false);
      } else {
        return right(true);
      }
    } on SocketException {
      return left(InternetException());
    } catch (e) {
      return left(AppExceptions("Some Unknown Error Occured"));
    }
  }

  @override
  Future<Either<AppExceptions, Unit>> updateLessonProgress({
    required LessonProgress lessonProgress,
  }) async {
  // debugPrint("hlleo reacherd");
    try {
      final userId = supabase.auth.currentUser?.id;
      if (userId == null) {
        print("yes user null");
        return Left(AppExceptions("User not authenticated."));
      }

      // Step 1: Fetch existing row
      final response =
          await supabase
              .from(table)
              .select('progress')
              .eq('uid', userId)
              .single();

      final progressList = (response['progress'] as List).cast<String>();

      // Step 2: Find and decode existing lesson
      int targetIndex = progressList.indexWhere((jsonStr) {
        final decoded = jsonDecode(jsonStr);
        return decoded['lesson'] == lessonProgress.lesson;
      });

      if (targetIndex == -1) {
        return Left(AppExceptions("Lesson not found."));
      }

      final existingJson = jsonDecode(progressList[targetIndex]);
      final mergedJson = {
        ...existingJson,
        ...lessonProgress.toJson(), // new values override old
      };

      final mergedTextJson = jsonEncode(mergedJson);

      // Step 3: Prepare parameters
      final params = {
        'user_uid_to_update': userId,
        'lesson_id_to_update': lessonProgress.lesson,
        'new_lesson_data_text': mergedTextJson,
      };

      // Step 4: Call Supabase function
      await supabase.rpc('update_reading_lesson_progress', params: params);
      return const Right(unit);
    } on PostgrestException catch (e) {
      debugPrint(e.toString());
      return Left(AppExceptions(e.message));
    } catch (e) {
      debugPrint("⚠️ Unexpected error: $e");
      return Left(AppExceptions("An unexpected error occurred: $e"));
    }
  }
}
