import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:langtest_pro/controller/listening/listening_controller.dart';
import 'package:langtest_pro/repo/listening/listening_auth_facade.dart';
import 'package:logger/logger.dart'; // Add this

class ListeningImpl implements IListeningFacade {
  final SupabaseClient _supabase = Supabase.instance.client;
  final logger = Logger(); // Add this

  @override
  Future<void> syncProgress({
    required String uid,
    required ListeningProgressController controller,
  }) async {
    try {
      await _supabase.from('listening_progress').upsert({
        'uid': uid,
        'completed_lessons': controller._completedLessons.value,
        'current_lesson_progress': controller._currentLessonProgress.value,
        'practice_tests': controller._practiceTestCompletion.value,
        'last_updated': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      logger.e(
        'Error syncing listening progress: $e',
      ); // Replace print with logger
    }
  }

  @override
  Future<void> loadProgress({
    required String uid,
    required ListeningProgressController controller,
  }) async {
    try {
      final response =
          await _supabase
              .from('listening_progress')
              .select()
              .eq('uid', uid)
              .maybeSingle();
      if (response != null) {
        controller._completedLessons.value = response['completed_lessons'] ?? 0;
        controller._currentLessonProgress.value =
            (response['current_lesson_progress'] as num?)?.toDouble() ?? 0.0;
        controller._practiceTestCompletion.value = Map<String, bool>.from(
          response['practice_tests'] ?? {},
        );
      }
    } catch (e) {
      logger.e(
        'Error loading listening progress: $e',
      ); // Replace print with logger
    }
  }
}
