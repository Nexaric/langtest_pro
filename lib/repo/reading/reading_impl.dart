import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:langtest_pro/controller/reading/reading_controller.dart';
import 'package:langtest_pro/repo/reading/reading_auth_facade.dart';

class ReadingImpl implements IReadingFacade {
  final SupabaseClient _supabase = Supabase.instance.client;

  @override
  Future<void> syncProgress({
    required String uid,
    required ReadingProgressController controller,
  }) async {
    try {
      await _supabase.from('reading_progress').upsert({
        'uid': uid,
        'completed_academic_lessons':
            controller._completedAcademicLessons.value, // Add .value
        'completed_general_lessons':
            controller._completedGeneralLessons.value, // Add .value
        'current_lesson_progress':
            controller._currentLessonProgress.value, // Add .value
        'last_updated': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      // Avoid print, use logger instead
      // print('Error syncing reading progress: $e');
    }
  }

  @override
  Future<void> loadProgress({
    required String uid,
    required ReadingProgressController controller,
  }) async {
    try {
      final response =
          await _supabase
              .from('reading_progress')
              .select()
              .eq('uid', uid)
              .maybeSingle();
      if (response != null) {
        controller._completedAcademicLessons.value =
            response['completed_academic_lessons'] ?? 0; // Add .value
        controller._completedGeneralLessons.value =
            response['completed_general_lessons'] ?? 0; // Add .value
        controller._currentLessonProgress.value =
            (response['current_lesson_progress'] as num?)?.toDouble() ??
            0.0; // Add .value
      }
    } catch (e) {
      // Avoid print, use logger instead
      // print('Error loading reading progress: $e');
    }
  }
}
