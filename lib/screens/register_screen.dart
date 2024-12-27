import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import '../services/api_service.dart';
import '../themes/theme_model.dart';

const kDarkBlueColor = Color(0xFF053149);

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  void _register() async {
    String username = _usernameController.text.trim();
    String password = _passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      Fluttertoast.showToast(msg: "Username and Password cannot be empty");
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      bool success = await ApiService.register(username, password);

      if (success) {
        Fluttertoast.showToast(msg: "Registration successful");
        Navigator.pushReplacementNamed(context, '/login_screen');
      } else {
        Fluttertoast.showToast(msg: "Registration failed");
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
          "Register",
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
                  "Buat Akun Baru!",
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
                  "Daftar untuk memulai",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontSize: size.width * 0.05,
                        color:
                            themeProvider.isDark ? Colors.white : Colors.black,
                      ),
                ),
                SizedBox(height: 10),
                Icon(
                  const IconData(0xe289, fontFamily: 'MaterialIcons'),
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
                    controller: _usernameController,
                    decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                      border: InputBorder.none,
                      hintText: "Username",
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
                  onPressed: _isLoading ? null : _register,
                  elevation: 0,
                  padding: EdgeInsets.all(18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  color: kDarkBlueColor,
                  child: Center(
                    child: _isLoading
                        ? CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : Text(
                            "Daftar",
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
                    Navigator.pushNamed(context, '/login_screen');
                  },
                  child: Text(
                    "Sudah punya akun? Login disini",
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
