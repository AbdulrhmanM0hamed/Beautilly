import 'package:flutter/material.dart';
import '../services/service_locator.dart';
import '../services/cache/cache_service.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;
  
  ThemeProvider() {
    _loadTheme();
  }

  ThemeMode get themeMode => _themeMode;

  Future<void> _loadTheme() async {
    final isDark = await sl<CacheService>().getDarkMode();
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  Future<void> setTheme(ThemeMode mode) async {
    _themeMode = mode;
    await sl<CacheService>().setDarkMode(mode == ThemeMode.dark);
    notifyListeners();
  }
} 