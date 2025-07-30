import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:langtest_pro/model/userData_model.dart';
import 'package:langtest_pro/repo/auth/auth_impl.dart';
import 'package:langtest_pro/repo/auth/i_authfacade.dart';
import 'package:langtest_pro/res/routes/routes_name.dart';
import 'package:langtest_pro/utils/utils.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthController extends GetxController {
  IAuthfacade auth = AuthImpl();

  RxBool loading = false.obs;

  void signInwithGoogle() {
    loading.value = true;
    auth.loginWithGoogle().then((value) {
      value.fold(
        (f) {
          debugPrint(value.toString());
          Utils.snakBar("Error", f.toString());
          loading.value = false;
        },
        (s) async {
          loading.value = false;
          Utils.saveString('userId', s.id);
          final status = await auth.checkUserDataAdded(userCred: s);
          status.fold(
            (f) {
              Utils.snakBar("Error", f.toString());
            },
            (success) async {
              if (!success) {
                Get.offNamed(RoutesName.userDetailsScreen, arguments: s);
                await auth.addUserData(
                  userCred: s,
                  userModel: UserData(
                    phone: '',
                    uid: s.id,
                    firstName: '',
                    lastName: '',
                    dob: '',
                    gender: '',
                    email: s.email ?? '',
                    role: '',
                    isCompleted: false,
                  ),
                );
              } else {
                Get.offNamed(RoutesName.homeScreen);
              }
            },
          );
        },
      );
    });
  }

  void addUserDataController({
    required User userCred,
    required UserData userModel,
  }) {
    loading.value = true;
    auth.addUserData(userCred: userCred, userModel: userModel).then((value) {
      value.fold(
        (f) {
          debugPrint(value.toString());
          Utils.snakBar("Error", f.toString());
          loading.value = false;
        },
        (s) {
          loading.value = false;
          Get.offNamed(RoutesName.homeScreen);
        },
      );
    });
  }

  void checkLogin() async {
    print("in contorller");
    loading.value = true;
    final userStatus = await auth.isLoginned();
    if (userStatus != null) {
      final dataStatus = await auth.checkUserDataAdded(userCred: userStatus);
      print("data status $dataStatus");

      dataStatus.fold(
        (f) {
          loading.value = false;
          Get.offNamed(RoutesName.loginScreen);
          Utils.snakBar("Error", f.toString());
        },
        (s) {
          if (s == true) {
            loading.value = false;
            Get.offNamed(RoutesName.homeScreen);
          } else {
            loading.value = false;
            Get.offNamed(RoutesName.userDetailsScreen, arguments: userStatus);
          }
        },
      );
    } else {
      loading.value = false;
      Get.offNamed(RoutesName.loginScreen);
    }
  }
}
