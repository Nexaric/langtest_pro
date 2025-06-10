import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:langtest_pro/model/userData_model.dart';
import 'package:langtest_pro/repo/auth/auth_impl.dart';
import 'package:langtest_pro/repo/auth/i_authfacade.dart';
import 'package:langtest_pro/res/routes/routes_name.dart';
import 'package:langtest_pro/utils/utils.dart';

class AuthController extends GetxController {
  IAuthfacade auth = AuthImpl();
  
  RxBool loading = false.obs;

  void signInwithGoogle() {
    loading.value = true;
    auth.loginWithGoogle().then((value){
      value.fold((f){
         debugPrint(value.toString());
        Utils.snakBar("Error",f.toString());
        loading.value = false;
      }, (s){
        loading.value = false;
        Get.offNamed(RoutesName.userDetailsScreen,
        arguments: s
        );
      });
    });
  }

  void addUserDataController({required UserCredential user, required UserData userModel}){
    loading.value = true;
    auth.addUserData(user: user, userModel: userModel).then((value){
      value.fold((f){
        debugPrint(value.toString());
        Utils.snakBar("Error", f.toString());
        loading.value = false;
      }, (s){
        loading.value = false;
        Get.offNamed(RoutesName.homeScreen);
      });
    });
  }
}
//i made login page
//i made forget screen