import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:dartz/dartz.dart';
import 'package:langtest_pro/model/userData_model.dart';
import 'package:langtest_pro/repo/profile/profile_impl.dart';
import 'package:langtest_pro/res/routes/routes_name.dart';
import 'package:langtest_pro/utils/utils.dart';

class ProfileController extends GetxController {
  final ProfileImpl _profileImpl = ProfileImpl();

  var userData = Rxn<UserData>();
  var isLoading = false.obs;
  var error = ''.obs;

  Future<void> getProfile() async {
    isLoading.value = true;

    await _profileImpl.getProfile().then((value) {
      value.fold(
        (f) {
          isLoading.value = false;
          Utils.snakBar("Error", f.toString());
        },
        (s) {
          isLoading.value = false;
          userData.value = s;
        },
      );
    });
  }

  Future<void> updateProfile({required UserData userDataModel}) async {
    isLoading.value = true;
    await _profileImpl.updateProfile(userData: userDataModel).then((value) {
      value.fold(
        (f) {
          isLoading.value = false;
          Utils.snakBar("Error", f.toString());
        },
        (s) {
          isLoading.value = false;
          Get.offNamed(RoutesName.homeScreen);
          debugPrint("success");
          Utils.snakBar("Success", "Profile Updated");
        },
      );
    });
  }
}
