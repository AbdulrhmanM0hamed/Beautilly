abstract class CacheService {
  Future<void> saveToken(String token);
  Future<void> saveUser(Map<String, dynamic> user);
  Future<String?> getToken();
  Future<Map<String, dynamic>?> getUser();
  Future<String?> getSessionCookie();
  Future<void> saveSessionCookie(String cookie);
  Future<void> clearCache();
} 