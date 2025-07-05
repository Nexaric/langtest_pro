import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:langtest_pro/model/payments_model.dart';
import 'package:langtest_pro/repo/payments/payments_impl.dart';
import 'package:langtest_pro/res/routes/routes_name.dart';

class PaymentController extends GetxController {
  PaymentsImpl payment = PaymentsImpl();
  RxBool isLoading = false.obs;

  void makePayment({
    required PaymentModel model,
    required String period,
  }) async {
    isLoading.value = true;
    await payment.makePayment(data: model, period: period).then(((value) {
      value.fold((f) {
        debugPrint("Payment Failed");
        isLoading.value = false;
      }, (s) {
        isLoading.value = false;
        debugPrint("Payment Success");
        Get.offNamed(RoutesName.paymentSuccessfulScreen);

      });
    }));
  }
}
