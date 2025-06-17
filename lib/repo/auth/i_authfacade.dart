import 'package:dartz/dartz.dart';
import 'package:langtest_pro/model/userData_model.dart';
import 'package:langtest_pro/utils/app_exceptions.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class IAuthfacade {

  Future<Either<AppExceptions, User>> loginWithGoogle();

  Future<Either<AppExceptions, Unit>> addUserData({
    required User userCred,
    required UserData userModel,
  });

  Future<User?> isLoginned();

  Future<bool> checkUserDataAdded({required User userCred});
}
