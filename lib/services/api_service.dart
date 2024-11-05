import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:aplikasi_iot/models/battery_model.dart';

class ApiService {
  // Ganti localhost dengan 10.0.2.2 agar emulator Android bisa terhubung ke server di komputer lokal
  static const String apiUrl = 'http://10.0.2.2:3001/api';

  // Method untuk login
  static Future<bool> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$apiUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('Login successful: ${data['message']}');
        return true;
      } else {
        print('Login failed: ${response.body}');
        throw Exception('Login failed: ${response.body}');
      }
    } catch (e) {
      print('Error during login: $e');
      throw Exception('Error during login');
    }
  }

  // Method untuk registrasi
  static Future<bool> register(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$apiUrl/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        print('Registration failed: ${response.body}');
        throw Exception('Registration failed: ${response.body}');
      }
    } catch (e) {
      print('Error during registration: $e');
      throw Exception('Error during registration');
    }
  }

  // Method untuk mendapatkan status baterai
  static Future<BatteryStatus> getBatteryStatus() async {
    try {
      final response = await http.get(Uri.parse('$apiUrl/battery'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return BatteryStatus.fromJson(data);
      } else {
        print('Failed to fetch battery status: ${response.body}');
        throw Exception('Failed to fetch battery status');
      }
    } catch (e) {
      print('Error during fetching battery status: $e');
      throw Exception('Error during fetching battery status');
    }
  }

  // Tambahkan method lain jika diperlukan
}
