// lib/repo/listening/listening_impl.dart

import 'package:flutter/foundation.dart';
import 'package:langtest_pro/repo/listening/listening_auth_facade.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ListeningImpl implements ListeningAuthFacade {
  final SupabaseClient _supabase;

  ListeningImpl(this._supabase);

  @override
  Future<void> updateProgress(String userId, List<String> progress) async {
    final stopwatch = Stopwatch()..start();
    try {
      await _supabase.from('listning').upsert({
        'user_id': userId,
        'progress': progress,
      }, onConflict: 'user_id');
      debugPrint(
        'Supabase updateProgress took: ${stopwatch.elapsedMilliseconds}ms',
      );
    } on PostgrestException catch (e) {
      debugPrint('Supabase update error: ${e.code} - ${e.message}');
      throw Exception('Failed to update progress: ${e.message}');
    } catch (e) {
      debugPrint('Unexpected update error: $e');
      throw Exception('Failed to update progress: $e');
    } finally {
      stopwatch.stop();
    }
  }

  @override
  Future<List<String>> fetchProgress(String userId) async {
    final stopwatch = Stopwatch()..start();
    try {
      final response =
          await _supabase
              .from('listning')
              .select('progress')
              .eq('user_id', userId)
              .maybeSingle();

      debugPrint(
        'Supabase fetchProgress took: ${stopwatch.elapsedMilliseconds}ms',
      );
      if (response == null) {
        return [];
      }

      return List<String>.from(response['progress'] ?? []);
    } on PostgrestException catch (e) {
      debugPrint('Supabase fetch error: ${e.code} - ${e.message}');
      throw Exception('Failed to fetch progress: ${e.message}');
    } catch (e) {
      debugPrint('Unexpected fetch error: $e');
      throw Exception('Failed to fetch progress: $e');
    } finally {
      stopwatch.stop();
    }
  }

  @override
  Future<void> resetProgress(String userId) async {
    final stopwatch = Stopwatch()..start();
    try {
      await _supabase.from('listning').upsert({
        'user_id': userId,
        'progress': [],
      }, onConflict: 'user_id');
      debugPrint(
        'Supabase resetProgress took: ${stopwatch.elapsedMilliseconds}ms',
      );
    } on PostgrestException catch (e) {
      debugPrint('Supabase reset error: ${e.code} - ${e.message}');
      throw Exception('Failed to reset progress: ${e.message}');
    } catch (e) {
      debugPrint('Unexpected reset error: $e');
      throw Exception('Failed to reset progress: $e');
    } finally {
      stopwatch.stop();
    }
  }
}
