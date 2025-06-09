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

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await FirebaseAuth.instance.signInWithCredential(
        credential,
      );

      if (userCredential.user != null) {
        await addUserData(
          user: userCredential,
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
        return right(userCredential);
      } else {
        return left(ServerException('User object is null'));
      }
    } on PlatformException catch (e) {
      if (e.code == 'network_error' || e.message?.contains('7') == true) {
      debugPrint('Network error: Please check your internet connection.');
      return left(AppExceptions("Please check your internet connection.","Network Error"));
    } else{
      return left(AppExceptions(e.message ?? 'Platform error during sign-in'));
    }
    } on FirebaseAuthException catch (e) {
      return(left(AppExceptions.fromFirebaseError(e)));
    } catch (e) {
      debugPrint('Unknown error during Google Sign-In: $e');
      return left(AppExceptions('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<AppExceptions, Unit>> addUserData({
    required UserCredential user,
    required UserData userModel,
  }) async {
    final db = FirebaseFirestore.instance;

    final userData = {
      "first_name": userModel.firstName,
      "last_name": userModel.lastName,
      "dob": userModel.dob,
      "gender": userModel.gender,
      "email": user.user!.email,
      "role": "student",
      "isCompleted": userModel.isCompleted,
    };

    try {
      await db.collection('users').doc(user.user!.uid).set(userData);
      return right(unit);
    } on FirebaseException catch (e) {
      debugPrint('Firebase error while adding user data: ${e.message}');
      return left(ServerException(e.message ?? 'Firestore error'));
    } catch (e) {
      debugPrint('Unexpected error while adding user data: $e');
      return left(AppExceptions('Unexpected error: $e'));
    }
  }
}
