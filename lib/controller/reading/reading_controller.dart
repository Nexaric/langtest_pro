import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:langtest_pro/core/widgets/loading_dialog_box.dart';
import 'package:langtest_pro/model/progress_model.dart';
import 'package:langtest_pro/repo/reading/reading_impl.dart';
import 'package:langtest_pro/res/routes/routes_name.dart';
import 'package:langtest_pro/utils/utils.dart';

class ReadingController extends GetxController{
  ReadingImpl progressRepo = ReadingImpl();

  RxBool isLoading = false.obs;

  // Use List<Map<String, dynamic>> instead of List<String> to avoid decoding
  var progressList = <Map<String, dynamic>>[].obs;

  void initializeProgress({
    required ProgressModel progressModel,
    required BuildContext context,
  }) async {
    LoadingDialog.show(context);
    await progressRepo.checkifInitialized(progressModel: progressModel).then((
      value,
    ) {
      value.fold(
        (f) {
          LoadingDialog.hide(context);
          isLoading.value = false;
          Utils.snakBar("Error", f.toString());
        },
        (s) async {
          if (s == false) {
            LoadingDialog.hide(context);
            await progressRepo
                .initializeProgress(progressModel: progressModel)
                .then((value) {
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

  void getProgress({required BuildContext ctx, bool? flag}) async {
    debugPrint("🔄 Entered getProgress");

    isLoading.value = true;
    progressList.clear(); // cleaner than assign([])

    LoadingDialog.show(ctx);

    final uid = await Utils.getString("userId");

    if (uid != null) {
      final result = await progressRepo.getProgress(uid: uid);
      result.fold(
        (failure) {
          LoadingDialog.hide(ctx);
          isLoading.value = false;
          Utils.snakBar("Error", failure.toString());
        },
        (success) {
          LoadingDialog.hide(ctx);
          isLoading.value = false;

          final List<dynamic> rawData = success.toJson()['progress'];

          try {
            final parsedData =
                rawData
                    .map<Map<String, dynamic>>((e) => jsonDecode(e))
                    .toList();

            progressList.assignAll(parsedData); // ✅ triggers UI update

            debugPrint("✅ Progress List: ${progressList.toJson()}");
            debugPrint(
              "🧩 isLocked of 0: ${progressList.isNotEmpty ? progressList[0]['isLocked'] : 'Empty list'}",
            );
           
            Get.offNamed(RoutesName.audioLessonsScreen);
          } catch (e) {
            debugPrint("❌ Error decoding progress: $e");
            Utils.snakBar("Error", "Failed to parse progress data.");
          }
        },
      );
    } else {
      isLoading.value = false;
      LoadingDialog.hide(ctx);
      Utils.snakBar("Error", "User ID not found.");
    }
  }

  void updateProgress({
    required LessonProgress lessonProgress,
    required BuildContext ctx,
    required VoidCallback onSuccessNavigate,
  }) {
    if (lessonProgress.lesson == 1) {
      LoadingDialog.show(ctx);
      progressRepo.updateLessonProgress(
        lessonProgress: LessonProgress(
          lesson: lessonProgress.lesson,
          isPassed: true,
          isLocked: false,
          progress: 100,
        ),
      );
      progressRepo.updateLessonProgress(
        lessonProgress: LessonProgress(
          lesson: lessonProgress.lesson + 1,
          isLocked: false,
        ),
      );
      LoadingDialog.hide(ctx);
      return;
    }
    LoadingDialog.show(ctx);
    debugPrint("Reached Update Progress");
    progressRepo.updateLessonProgress(lessonProgress: lessonProgress).then((
      value,
    ) {
      value.fold(
        (f) {
          LoadingDialog.hide(ctx);
          print(f.toString());
          Utils.snakBar("Error", f.toString());
        },
        (s) {
          LoadingDialog.hide(ctx);
          onSuccessNavigate();
          debugPrint("success on update");
        },
      );
    });
  }
}