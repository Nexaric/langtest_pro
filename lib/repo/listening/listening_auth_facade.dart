// lib/repo/listening/listening_auth_facade.dart

abstract class ListeningAuthFacade {
  Future<void> updateProgress(String userId, List<String> progress);
  Future<List<String>> fetchProgress(String userId);
  Future<void> resetProgress(String userId);
}
