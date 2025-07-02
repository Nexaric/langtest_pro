import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:langtest_pro/model/userData_model.dart';
import 'package:langtest_pro/repo/auth/i_authfacade.dart';
import 'package:langtest_pro/utils/app_exceptions.dart';
import 'package:langtest_pro/utils/utils.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthImpl implements IAuthfacade {
  final supabase = Supabase.instance.client;

  @override
 Future<Either<AppExceptions, User>> loginWithGoogle() async {
  try {
    // Start Google Sign-In via Supabase
    await Supabase.instance.client.auth.signInWithOAuth(
      OAuthProvider.google,
      redirectTo: 'com.example.nexariclangtest://login-callback',
    );

    // Listen for auth state change to get the logged-in user
    final user = await Supabase.instance.client.auth.onAuthStateChange
        .map((event) => Supabase.instance.client.auth.currentUser)
        .firstWhere((user) => user != null, orElse: () => null);

    if (user == null) {
      return left(AppExceptions('User object is null after sign-in'));
    }

    return right(user);
  } on AuthException catch (e) {
    return left(AppExceptions(e.message ??'Authentication error'));
  } catch (e) {
    return left(AppExceptions('Unexpected error: $e'));
  }
}


  @override
  Future<Either<AppExceptions, Unit>> addUserData({
    required User userCred,
    required UserData userModel,
  }) async {
    // final db = FirebaseFirestore.instance;

    final userData = UserData(
      uid: userCred.id,
      phone: userModel.phone,
      firstName: userModel.firstName,
      lastName: userModel.lastName,
      dob: userModel.dob,
      gender: userModel.gender,
      email: userModel.email,
      role: userModel.role,
      isCompleted: userModel.isCompleted,
    );

    try {
      // await db.collection('users').doc(userCred.user!.uid).set(userData);
      await supabase.from('users').upsert(userData);
      Utils.saveString('phone', userData.phone);
      Utils.saveString('email', userData.email);
      return right(unit);
    } catch (e) {
      debugPrint('Firebase error while adding user data: $e');
      return left(ServerException(e.toString()));
    }
  }

  @override
  Future<User?> isLoginned() async {
    final user = supabase.auth.currentUser;
    print("user status $user");
    return user;
  }

  @override
  Future<bool> checkUserDataAdded({required User userCred}) async {
    print("Reached data checking, ${userCred.id}");

    try {
      final response =
          await supabase
              .from('users')
              .select('isCompleted')
              .eq('uid', userCred.id.toString())
              .maybeSingle();

      print("Response: $response");

      if (response == null) {
        print("No user data found");
        return false;
      }

      final isCompleted = response['isCompleted'] as bool?;

      if (isCompleted != null) {
        print("User data found. isCompleted: $isCompleted");
        return isCompleted;
      } else {
        debugPrint("User data not found");
      }
    } catch (e) {
      print("Error in data checking: $e");
    }

    return false;
  }
}
