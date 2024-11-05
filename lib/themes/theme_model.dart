import 'package:flutter/material.dart';
import 'package:aplikasi_iot/themes/theme_preference.dart';

class ThemeModel extends ChangeNotifier {
  bool _isDark = false;
  late ThemePreferences _preferences;

  bool get isDark => _isDark;

  ThemeModel() {
    _preferences = ThemePreferences();
    getPreferences();
  }

  // Set dark mode or light mode and notify listeners
  set isDark(bool value) {
    _isDark = value;
    _preferences.setTheme(value);
    notifyListeners();
  }

  // Retrieve saved theme preferences from local storage
  void getPreferences() async {
    _isDark = await _preferences.getTheme();
    notifyListeners();
  }
}
