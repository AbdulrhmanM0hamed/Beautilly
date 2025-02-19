import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'cache_service.dart';

class CacheServiceImpl implements CacheService {
  
  final SharedPreferences _prefs;
  static const String _tokenKey = 'token';
  static const String _userKey = 'user';
  static const String _sessionCookieKey = 'session_cookie';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _rememberMeKey = 'remember_me';
  static const String _emailKey = 'saved_email';
  static const String _passwordKey = 'saved_password';

  CacheServiceImpl(this._prefs);

  @override
  Future<void> saveToken(String token) async {
    await _prefs.setString(_tokenKey, token);
  }

  @override
  Future<void> saveUser(Map<String, dynamic> user) async {
    await _prefs.setString(_userKey, jsonEncode(user));
  }

  @override
  Future<String?> getToken() async {
    final token = _prefs.getString(_tokenKey);
    return token;
  }

  @override
  Future<Map<String, dynamic>?> getUser() async {
    final userStr = _prefs.getString(_userKey);
    if (userStr == null) return null;
    return jsonDecode(userStr) as Map<String, dynamic>;
  }

  @override
  Future<void> clearCache() async {
    await _prefs.remove(_tokenKey);
    await _prefs.remove(_refreshTokenKey);
    await _prefs.remove(_sessionCookieKey);
    await _prefs.remove(_userKey);  // إضافة مسح بيانات المستخدم
    
    if (!(await getRememberMe())) {
      await clearLoginCredentials();
    }
  }

  @override
  Future<String?> getSessionCookie() async {
    return _prefs.getString(_sessionCookieKey);
  }

  @override
  Future<void> saveSessionCookie(String cookie) async {
    await _prefs.setString(_sessionCookieKey, cookie);
  }

  @override
  int? getUserId() {
    final userStr = _prefs.getString(_userKey);
    if (userStr == null) return null;
    final user = jsonDecode(userStr) as Map<String, dynamic>;
    return user['id'] as int?;
  }
  
  @override
  Future<String?> getRefreshToken() async {
    return _prefs.getString(_refreshTokenKey);
  }
  
  @override
  Future<void> saveRefreshToken(String token) async {
    await _prefs.setString(_refreshTokenKey, token);
  }

  @override
  Future<bool> getRememberMe() async {
    return _prefs.getBool(_rememberMeKey) ?? false;
  }

  @override
  Future<void> setRememberMe(bool value) async {
    await _prefs.setBool(_rememberMeKey, value);
  }

  @override
  Future<Map<String, String>?> getLoginCredentials() async {
    final email = _prefs.getString(_emailKey);
    final password = _prefs.getString(_passwordKey);
    
    if (email != null && password != null) {
      return {
        'email': email,
        'password': password,
      };
    }
    return null;
  }

  @override
  Future<void> saveLoginCredentials(String email, String password) async {
    await _prefs.setString(_emailKey, email);
    await _prefs.setString(_passwordKey, password);
  }

  @override
  Future<void> clearLoginCredentials() async {
    await _prefs.remove(_emailKey);
    await _prefs.remove(_passwordKey);
    await _prefs.remove(_rememberMeKey);
  }
}