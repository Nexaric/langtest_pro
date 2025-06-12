abstract class IPushFacade {

Future<void> requestPermissionForFcm({required String userId});

void foregroundNotificationChannel();

}