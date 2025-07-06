import 'dart:io';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:langtest_pro/repo/report_problem/report_problem_impl.dart';
import 'package:langtest_pro/utils/utils.dart';

class ReportProblemController extends GetxController {
  final reportProblemApi = ReportProblemImpl();
  final RxBool isLoading = false.obs;

  var description = ''.obs;
  var image = Rx<File?>(null);
  var selectedIssue = 'App Crash'.obs;

  final List<String> issues = [
    "App Crash",
    "Login Issues",
    "Payment Problems",
    "Course Access Issues",
    "Audio/Video Errors",
    "Other",
  ];

  final picker = ImagePicker();

  Future<void> pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      image.value = File(pickedFile.path);
    }
  }

  void submitReport() {
    
    if (description.value.trim().isEmpty) {
      Utils.snakBar("Error", "Please describe the issue.");
      return;
    }
    isLoading.value = true;
    reportProblemApi.reportProblem(
      title: selectedIssue.value,
      description: description.value,
      image: image.value,
    ).then((value){
      value.fold((f){
        isLoading.value = false;
        Utils.snakBar("Error", f.toString());
      }, (s){
        isLoading.value = false;
        Utils.snakBar("Success", "Your report has been submitted successfully.");
      });
    });

    
    description.value = '';
    image.value = null;
    selectedIssue.value = 'App Crash';
  }

  void reportProblem({
    required String title,
    required String description,
    required File image,
  }) {
    reportProblemApi.reportProblem(
      title: title,
      description: description,
      image: image,
    );
  }
}
