import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import '../services/api_service.dart';
import '../themes/theme_model.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  bool _isValidEmail(String email) {
    final RegExp regex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    return regex.hasMatch(email);
  }

  void _login() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      Fluttertoast.showToast(msg: "Email and Password cannot be empty");
      return;
    }

    if (!_isValidEmail(email)) {
      Fluttertoast.showToast(msg: "Invalid email format");
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      bool success = await ApiService.login(email, password);

      if (success) {
        Fluttertoast.showToast(msg: "Login successful");
        Navigator.pushReplacementNamed(context, '/home_screen');
      } else {
        Fluttertoast.showToast(msg: "Invalid email or password");
      }
    } catch (error) {
      Fluttertoast.showToast(msg: error.toString());
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final themeProvider = Provider.of<ThemeModel>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "Login",
          style: TextStyle(
            color: themeProvider.isDark ? Colors.white : Colors.grey.shade900,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              themeProvider.isDark ? Icons.wb_sunny : Icons.nightlight_round,
              color: themeProvider.isDark ? Colors.white : Colors.grey.shade900,
            ),
            onPressed: () {
              themeProvider.isDark = !themeProvider.isDark;
            },
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            width: size.width * 0.8,
            padding: EdgeInsets.symmetric(vertical: size.height * 0.05),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Selamat Datang!",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontSize: size.width * 0.08,
                        fontWeight: FontWeight.bold,
                        color:
                            themeProvider.isDark ? Colors.white : Colors.black,
                      ),
                ),
                SizedBox(height: 5),
                Text(
                  "Di Fire Fighter App",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontSize: size.width * 0.05,
                        color:
                            themeProvider.isDark ? Colors.white : Colors.black,
                      ),
                ),
                SizedBox(height: 10),
                Icon(
                  Icons.fire_truck,
                  size: size.width * 0.2,
                  color: themeProvider.isDark ? Colors.white : Colors.black,
                ),
                SizedBox(height: 30),
                Container(
                  decoration: BoxDecoration(
                    color: themeProvider.isDark
                        ? Colors.grey.shade800
                        : Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                      border: InputBorder.none,
                      hintText: "Email",
                      hintStyle: TextStyle(
                        color: themeProvider.isDark
                            ? Colors.white54
                            : Colors.black54,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    color: themeProvider.isDark
                        ? Colors.grey.shade800
                        : Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                      border: InputBorder.none,
                      hintText: "Password",
                      hintStyle: TextStyle(
                        color: themeProvider.isDark
                            ? Colors.white54
                            : Colors.black54,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 30),
                MaterialButton(
                  onPressed: _isLoading ? null : _login,
                  elevation: 0,
                  padding: EdgeInsets.all(18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  color: Colors.blue,
                  child: Center(
                    child: _isLoading
                        ? CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : Text(
                            "Login",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
                SizedBox(height: 30),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/register_screen');
                  },
                  child: Text(
                    "Belum punya akun? Daftar disini",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: themeProvider.isDark
                              ? Colors.white
                              : Colors.black,
                        ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
