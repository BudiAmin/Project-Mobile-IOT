import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'themes/theme_model.dart';
import 'themes/app_theme.dart'; // Tambahkan untuk import tema yang telah Anda buat
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/home_screen.dart'; // Import HomeScreen

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThemeModel(), // Inisialisasi ThemeModel
      child: Consumer<ThemeModel>(
        builder: (context, themeModel, child) {
          return MaterialApp(
            title: 'Aplikasi IoT',
            theme: AppTheme.light, // Tema terang
            darkTheme: AppTheme.dark, // Tema gelap
            themeMode: themeModel.isDark
                ? ThemeMode.dark
                : ThemeMode.light, // Menggunakan tema sesuai pilihan
            home: LoginScreen(), // Mulai dari halaman Login
            routes: {
              '/login_screen': (context) => LoginScreen(),
              '/register_screen': (context) => RegisterScreen(),
              '/home_screen': (context) => HomeScreen(), // Rute ke HomeScreen
            },
          );
        },
      ),
    );
  }
}
