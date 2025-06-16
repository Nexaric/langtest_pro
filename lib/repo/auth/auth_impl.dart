import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:langtest_pro/model/userData_model.dart';
import 'package:langtest_pro/repo/auth/i_authfacade.dart';
import 'package:langtest_pro/utils/app_exceptions.dart';

class AuthImpl implements IAuthfacade {
  @override
  Future<Either<AppExceptions, UserCredential>> loginWithGoogle() async {
    try {
      final googleSignIn = GoogleSignIn();
      final googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        return left(AppExceptions('Sign-in cancelled by user'));
      }

      final googleAuth = await googleUser.authentication;

      print("this is google auth $googleAuth");

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      print("this is credentials $credential");

      final userCredential = await FirebaseAuth.instance.signInWithCredential(
        credential,
      );

      print("this is user cred $userCredential");

      if (userCredential.user != null) {
        final status = await checkUserDataAdded(user: userCredential.user!);
        if (status == false) {
          await addUserData(
            user: userCredential.user!,
            userModel: UserData(
              firstName: '',
              lastName: '',
              dob: '',
              gender: '',
              email: '',
              role: '',
              isCompleted: false,
            ),
          ); // await to ensure it's completed
        }

        return right(userCredential);
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
    } on FirebaseAuthException catch (e) {
      return (left(AppExceptions.fromFirebaseError(e)));
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
    final db = FirebaseFirestore.instance;

    final userData = {
      "first_name": userModel.firstName,
      "last_name": userModel.lastName,
      "dob": userModel.dob,
      "gender": userModel.gender,
      "email": user.email,
      "role": "student",
      "isCompleted": userModel.isCompleted,
    };

    try {
      await db.collection('users').doc(user.uid).set(userData);
      return right(unit);
    } on FirebaseException catch (e) {
      debugPrint('Firebase error while adding user data: ${e.message}');
      return left(ServerException(e.message ?? 'Firestore error'));
    } catch (e) {
      debugPrint('Unexpected error while adding user data: $e');
      return left(AppExceptions('Unexpected error: $e'));
    }
  }

  @override
  Future<User?> isLoginned() async {
    final user = await FirebaseAuth.instance.authStateChanges().first;
    print("user status $user");
    return user;
  }

  @override
  Future<bool> checkUserDataAdded({required User user}) async {
    print("reached data checkking");
    try {
      final documentSnapshot =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .get();

      if (documentSnapshot.exists) {
        print("snapshot exists");
        final data = documentSnapshot.get('isCompleted');
        return data;
      }
      
    } catch (e) {
      print("in data checking $e");
      
    }

    return false;
  }
}
