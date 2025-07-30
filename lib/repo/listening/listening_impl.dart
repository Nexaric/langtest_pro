import 'dart:io';

import 'package:langtest_pro/model/progress_model.dart';
import 'package:langtest_pro/repo/listening/listening_facade.dart';
import 'package:langtest_pro/utils/app_exceptions.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:dartz/dartz.dart';

class ListeningImpl implements ListeningFacade {
  final supabase = Supabase.instance.client;
  final table = 'listening_progress';

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
}
