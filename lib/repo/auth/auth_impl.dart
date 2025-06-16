import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:langtest_pro/model/userData_model.dart';
import 'package:langtest_pro/repo/auth/i_authfacade.dart';
import 'package:langtest_pro/utils/app_exceptions.dart';

class AuthImpl implements IAuthfacade {
  final supabase = Supabase.instance.client;

  @override
  Future<Either<AppExceptions, User>> loginWithGoogle() async {
    try {
      final googleSignIn = GoogleSignIn();
      final googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        return left(AppExceptions('Sign-in cancelled by user'));
      }

      final googleAuth = await googleUser.authentication;
      final accessToken = googleAuth.accessToken;
      final idToken = googleAuth.idToken;

      if (accessToken == null || idToken == null) {
        return left(AppExceptions('Google Sign-In failed: No tokens received'));
      }

      final response = await supabase.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: accessToken,
      );

      final user = response.user;
      if (user != null) {
        final status = await checkUserDataAdded(user: user);
        if (!status) {
          await addUserData(
            user: user,
            userModel: UserData(
              firstName: '',
              lastName: '',
              dob: '',
              gender: '',
              email: user.email ?? '',
              role: 'student',
              isCompleted: false,
            ),
          );
        }
        return right(user);
      } else {
        return left(ServerException('User object is null'));
      }
    } on PlatformException catch (e) {
      if (e.code == 'network_error' || e.message?.contains('7') == true) {
        debugPrint('Network error: Please check your internet connection.');
        return left(
          AppExceptions(
            "Please check your internet connection.",
            "Network Error",
          ),
        );
      } else {
        return left(
          AppExceptions(e.message ?? 'Platform error during sign-in'),
        );
      }
    } on AuthException catch (e) {
      debugPrint("hello print error ${e.message.toString()}");
      return left(AppExceptions(e.message));
    } catch (e) {
      debugPrint('Unknown error during Google Sign-In: $e');
      return left(AppExceptions('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<AppExceptions, Unit>> addUserData({
    required User user,
    required UserData userModel,
  }) async {
    try {
      final userData = {
        'id': user.id,
        'first_name': userModel.firstName,
        'last_name': userModel.lastName,
        'dob': userModel.dob,
        'gender': userModel.gender,
        'email': user.email,
        'role': userModel.role,
        'is_completed': userModel.isCompleted,
      };

      await supabase.from('users').insert(userData);
      return right(unit);
    } catch (e) {
      debugPrint('Error while adding user data: $e');
      return left(AppExceptions('Unexpected error: $e'));
    }
  }

  @override
  Future<User?> isLoginned() async {
    return supabase.auth.currentUser;
  }

  @override
  Future<bool> checkUserDataAdded({required User user}) async {
    try {
      final response =
          await supabase
              .from('users')
              .select('is_completed')
              .eq('id', user.id)
              .maybeSingle();

      if (response != null) {
        return response['is_completed'] ?? false;
      }
      return false;
    } catch (e) {
      debugPrint('Error checking user data: $e');
      return false;
    }
  }
}
