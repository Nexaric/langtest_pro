import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:langtest_pro/core/widgets/loading_dialog_box.dart';
import 'package:langtest_pro/model/progress_model.dart';
import 'package:langtest_pro/repo/listening/listening_impl.dart';
import 'package:langtest_pro/res/routes/routes_name.dart';
import 'package:langtest_pro/utils/utils.dart';

class ListeningController extends GetxController {
  ListeningImpl progressRepo = ListeningImpl();

  RxBool isLoading = false.obs;

  // Use List<Map<String, dynamic>> instead of List<String> to avoid decoding
  Rx<List<Map<String, dynamic>>> progressList = Rx<List<Map<String, dynamic>>>([]);

  void initializeProgress({
    required ProgressModel progressModel,
    required BuildContext context,
  }) async {
    LoadingDialog.show(context);
    await progressRepo.checkifInitialized(progressModel: progressModel).then((value) {
      value.fold(
        (f) {
          LoadingDialog.hide(context);
          isLoading.value = false;
          Utils.snakBar("Error", f.toString());
        },
        (s) async {
          if (s == false) {
            LoadingDialog.hide(context);
            await progressRepo.initializeProgress(progressModel: progressModel).then((value) {
              value.fold(
                (f) {
                  LoadingDialog.hide(context);
                  isLoading.value = false;
                  Utils.snakBar("Error", f.toString());
                },
                (s) async {
                  LoadingDialog.hide(context);
                  debugPrint("success 1");
                  getProgress(ctx: context);
                },
              );
            });
          } else {
            LoadingDialog.hide(context);
            debugPrint("else 1");
            getProgress(ctx: context);
          }
        },
      );
    });
  }

  void getProgress({required BuildContext ctx}) async {
  debugPrint("i got into get progress class");
  isLoading.value = true;
  progressList.value = [];
  LoadingDialog.show(ctx);

  final uid = await Utils.getString("userId");
  if (uid != null) {
    await progressRepo.getProgress(uid: uid).then((value) {
      value.fold(
        (f) {
          LoadingDialog.hide(ctx);
          isLoading.value = false;
          Utils.snakBar("Error", f.toString());
        },
        (s) {
          LoadingDialog.hide(ctx);
          isLoading.value = false;

          final List<dynamic> data = s.toJson()['progress'];

          // Convert List<String> to List<Map<String, dynamic>>
          progressList.value =
              data.map<Map<String, dynamic>>((e) => jsonDecode(e)).toList();

          debugPrint(progressList.value[0].toString());
          debugPrint("isLocked value: ${progressList.value[0]['isLocked']}");
          Get.toNamed(RoutesName.audioLessonsScreen);
        },
      );
    });
  }
}

}
