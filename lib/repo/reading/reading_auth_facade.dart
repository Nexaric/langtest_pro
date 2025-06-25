import 'package:langtest_pro/controller/reading/reading_controller.dart';

abstract class IReadingFacade {
  Future<void> syncProgress({
    required String uid,
    required ReadingProgressController controller,
  });
  Future<void> loadProgress({
    required String uid,
    required ReadingProgressController controller,
  });
}
