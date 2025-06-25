import 'package:langtest_pro/controller/writing/writing_controller.dart';

abstract class IWritingFacade {
  Future<void> syncProgress({
    required String uid,
    required WritingProgressController controller,
  });
  Future<void> loadProgress({
    required String uid,
    required WritingProgressController controller,
  });
}
