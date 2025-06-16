

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:langtest_pro/model/userData_model.dart';
import 'package:langtest_pro/repo/auth/i_authfacade.dart';
import 'package:langtest_pro/utils/app_exceptions.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthImpl implements IAuthfacade {
  final supabase = Supabase.instance.client;

  @override
  Future<Either<AppExceptions, User>> loginWithGoogle() async {
    try {
      // Trigger Google Sign-In via Supabase
      final response = await Supabase.instance.client.auth.signInWithOAuth(
          OAuthProvider.google,
          redirectTo: 'com.example.nexariclangtest://login-callback'
      );

      // Supabase handles the redirect in web, and on mobile via deep linking.
      // The session is saved automatically.

      // You can get the current user like this:
      final user = Supabase.instance.client.auth.currentUser;

      if (user == null) {
        return left(AppExceptions('User object is null after sign-in'));
      }

      // Check if user data is already added to the Supabase DB
      final status = await checkUserDataAdded(userCred: user);
      if (!status) {
        await addUserData(
          userCred: user,
          userModel: UserData(
            firstName: '',
            lastName: '',
            dob: '',
            gender: '',
            email: user.email ?? '',
            role: '',
            isCompleted: false,
          ),
        );
      }

      return right(user);
    } on AuthException catch (e) {
      print("Exception one ${e.toString()}");
      return left(AppExceptions(e.message ?? 'Authentication error'));
    } catch (e) {
       
      debugPrint('Unexpected error during Supabase Google Sign-In: $e');
      return left(AppExceptions('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<AppExceptions, Unit>> addUserData({
    required User userCred,
    required UserData userModel,
  }) async {
    // final db = FirebaseFirestore.instance;

    final userData = {
      "uid": userCred.id,
      "first_name": userModel.firstName,
      "last_name": userModel.lastName,
      "dob": userModel.dob,
      "gender": userModel.gender,
      "email": userCred.email,
      "role": "student",
      "isCompleted": userModel.isCompleted,
    };

    try {
      // await db.collection('users').doc(userCred.user!.uid).set(userData);
      await supabase.from('users').insert(userData);
      return right(unit);
    }  catch (e) {
      debugPrint('Firebase error while adding user data: $e');
      return left(ServerException(e.toString() ));
    } 
  }

  @override
  Future<User?> isLoginned() async {
    final user =  supabase.auth.currentUser;
    print("user status $user");
    return user;
  }

  @override
  Future<bool> checkUserDataAdded({required User userCred}) async {
    print("Reached data checking");

    try {
      final response =
          await supabase
              .from('users')
              .select('isCompleted')
              .eq(
                'uid',
                userCred.id,
              ) // Ensure 'uid' is your Supabase column for user ID
              .maybeSingle();

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
//client id : 882549364582-r1cins0s0f9drfk2v0bk5qhc08c9891m.apps.googleusercontent.com
//secret_id : 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