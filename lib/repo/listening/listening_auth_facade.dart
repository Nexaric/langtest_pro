import 'package:langtest_pro/controller/listening/listening_controller.dart';

abstract class IListeningFacade {
  Future<void> syncProgress({
    required String uid,
    required ListeningProgressController controller,
  });
  Future<void> loadProgress({
    required String uid,
    required ListeningProgressController controller,
  });
}
