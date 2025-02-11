import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'cache_service.dart';

class CacheServiceImpl implements CacheService {
  
  final SharedPreferences _prefs;
  static const String _tokenKey = 'token';
  static const String _userKey = 'user';
  static const String _sessionCookieKey = 'session_cookie';

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
    await _prefs.remove(_userKey);
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
} 