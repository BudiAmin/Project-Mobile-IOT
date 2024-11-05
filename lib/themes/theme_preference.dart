import 'package:shared_preferences/shared_preferences.dart';

class ThemePreferences {
  static const String prefKey = "theme_mode";

  // Save theme mode (true for dark mode, false for light mode)
  Future<void> setTheme(bool value) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setBool(prefKey, value);
  }

  // Retrieve saved theme mode (default is light mode)
  Future<bool> getTheme() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getBool(prefKey) ?? false;
  }
}
