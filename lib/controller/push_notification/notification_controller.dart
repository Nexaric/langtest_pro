import 'package:get/get.dart';
import 'package:langtest_pro/repo/push_notification/i_push_facade.dart';
import 'package:langtest_pro/repo/push_notification/push_impl.dart';

class NotificationController extends GetxController {
  IPushFacade pushFacade = PushImpl();

  void requestPermissionForFcm({required String userId}) {
    print("in push controller");
    pushFacade.requestPermissionForFcm(userId: userId);
  }

  void foregroundNotificationChannel() {
    pushFacade.foregroundNotificationChannel();
  }
}
