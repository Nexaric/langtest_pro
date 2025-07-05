import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:langtest_pro/utils/app_exceptions.dart';

abstract class IReportProblemFacade {
  Future<Either<AppExceptions, Unit>> reportProblem({
    required String title,
    required String description,
    required File image,
  });
}
