import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:langtest_pro/model/userData_model.dart';
import 'package:langtest_pro/utils/app_exceptions.dart';

abstract class IAuthfacade {

  Future<Either<AppExceptions, UserCredential>> loginWithGoogle();

  Future<Either<AppExceptions, Unit>> addUserData({
    required User user,
    required UserData userModel,
  });

  Future<User?> isLoginned();

  Future<bool> checkUserDataAdded({required User user});
}
