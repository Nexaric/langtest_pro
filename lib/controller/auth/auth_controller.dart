import 'package:get/get.dart';
import 'package:langtest_pro/model/userData_model.dart';
import 'package:langtest_pro/repo/auth/auth_impl.dart';
import 'package:langtest_pro/repo/auth/i_authfacade.dart';
import 'package:langtest_pro/res/routes/routes_name.dart';
import 'package:langtest_pro/utils/utils.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:logger/logger.dart'; // Add this

class AuthController extends GetxController {
  IAuthfacade auth = AuthImpl();
  final logger = Logger(); // Add logger instance

  RxBool loading = false.obs;

  void signInwithGoogle() {
    loading.value = true;
    auth.loginWithGoogle().then((value) {
      value.fold(
        (f) {
          logger.e(
            'Google Sign-In Error: $f',
          ); // Replace debugPrint with logger
          Utils.snakBar("Error", f.toString());
          loading.value = false;
        },
        (s) {
          loading.value = false;
          Utils.saveString('userId', s.id);
          Get.offNamed(RoutesName.userDetailsScreen, arguments: s);
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
          logger.e('Add User Data Error: $f'); // Replace debugPrint with logger
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
    logger.i('Checking login status'); // Replace print with logger
    loading.value = true;
    final userStatus = await auth.isLoginned();
    if (userStatus != null) {
      final dataStatus = await auth.checkUserDataAdded(userCred: userStatus);
      logger.d('User data status: $dataStatus'); // Replace print with logger
      if (dataStatus == true) {
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
