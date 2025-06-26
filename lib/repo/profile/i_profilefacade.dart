import 'package:dartz/dartz.dart';
import 'package:langtest_pro/model/userData_model.dart';
import 'package:langtest_pro/utils/app_exceptions.dart';

abstract class IProfilefacade {
  Future<Either<AppExceptions,UserData>> getProfile();
  Future<Either<AppExceptions,Unit>> updateProfile({required UserData userData}); 
}