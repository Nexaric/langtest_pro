import 'package:dartz/dartz.dart';
import 'package:langtest_pro/model/progress_model.dart';
import 'package:langtest_pro/utils/app_exceptions.dart';

abstract class ListeningFacade {
  Future<Either<AppExceptions, Unit>> initializeProgress({
    required ProgressModel progressModel,
  });

  Future<Either<AppExceptions, ProgressModel>> getProgress({
    required String uid,
  });

  Future<Either<AppExceptions, bool>> checkifInitialized({
    required ProgressModel progressModel,
  });

  Future<Either<AppExceptions, Unit>> updateLessonProgress({
    required LessonProgress lessonProgress,
  });

 

}
