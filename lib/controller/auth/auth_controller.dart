import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
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
    auth.loginWithGoogle().then((value) {
      value.fold(
        (f) {
          debugPrint(f.toString());
          Utils.snakBar("Error", f.toString());
          loading.value = false;
        },
        (user) {
          loading.value = false;
          Utils.saveString('userId', user.id);
          Get.offNamed(RoutesName.userDetailsScreen, arguments: user);
        },
      );
    });
  }

  void addUserDataController({
    required User user,
    required UserData userModel,
  }) {
    loading.value = true;
    auth.addUserData(user: user, userModel: userModel).then((value) {
      value.fold(
        (f) {
          debugPrint(f.toString());
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
    debugPrint("In controller");
    loading.value = true;
    final userStatus = await auth.isLoginned();
    if (userStatus != null) {
      final dataStatus = await auth.checkUserDataAdded(user: userStatus);
      debugPrint("Data status: $dataStatus");
      if (dataStatus) {
        loading.value = false;
        Get.offNamed(RoutesName.homeScreen);
      } else {
        loading.value = false;
        Get.offNamed(RoutesName.userDetailsScreen, arguments: userStatus);
      }
    } else {
      loading.value = false;
      Get.offNamed(RoutesName.loginScreen);
    }
  }
}
