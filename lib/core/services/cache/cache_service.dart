abstract class CacheService {
  Future<void> saveToken(String token);
  Future<void> saveUser(Map<String, dynamic> user);
  Future<String?> getToken();
  Future<Map<String, dynamic>?> getUser();
  Future<String?> getSessionCookie();
  Future<void> saveSessionCookie(String cookie);
  Future<void> clearCache();
  int? getUserId();
  Future<String?> getRefreshToken();
  Future<void> saveRefreshToken(String token);
  Future<bool> getRememberMe();
  Future<void> setRememberMe(bool value);
  Future<Map<String, String>?> getLoginCredentials();
  Future<void> saveLoginCredentials(String email, String password);
  Future<void> clearLoginCredentials();
  Future<String?> getFCMToken();
  Future<void> saveFCMToken(String token);
} 