import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:langtest_pro/controller/writing/writing_controller.dart';
import 'package:langtest_pro/repo/writing/writing_auth_facade.dart';

class WritingImpl implements IWritingFacade {
  final SupabaseClient _supabase = Supabase.instance.client;

  @override
  Future<void> syncProgress({
    required String uid,
    required WritingProgressController controller,
  }) async {
    try {
      await _supabase.from('writing_progress').upsert({
        'uid': uid,
        'completed_lessons': controller._completedLessons.value, // Add .value
        'completed_letter_lessons':
            controller._completedLetterLessons.value, // Add .value
        'last_updated': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      // Avoid print, use logger instead
      // print('Error syncing writing progress: $e');
    }
  }

  @override
  Future<void> loadProgress({
    required String uid,
    required WritingProgressController controller,
  }) async {
    try {
      final response =
          await _supabase
              .from('writing_progress')
              .select()
              .eq('uid', uid)
              .maybeSingle();
      if (response != null) {
        controller._completedLessons.value =
            response['completed_lessons'] ?? 0; // Add .value
        controller._completedLetterLessons.value =
            response['completed_letter_lessons'] ?? 0; // Add .value
      }
    } catch (e) {
      // Avoid print, use logger instead
      // print('Error loading writing progress: $e');
    }
  }
}
