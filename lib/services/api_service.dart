import 'dart:convert';
import 'package:http/http.dart' as http;
// import 'package:aplikasi_iot/models/battery_model.dart';
import 'package:aplikasi_iot/models/sensor_model.dart'; // Import model untuk data sensor

class ApiService {
  static const String baseUrl =
      "https://dd59-2001-448a-3021-6e94-440-359d-2c6d-3f06.ngrok-free.app"; // Sesuaikan dengan URL backend Anda

  // Login API
  static Future<bool> login(String username, String password) async {
    final url = Uri.parse("$baseUrl/login");
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"username": username, "password": password}),
      );

      if (response.statusCode == 200) {
        return true; // Login berhasil
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error["error"] ?? "Login failed");
      }
    } catch (e) {
      throw Exception("Error during login: $e");
    }
  }

  // Register API
  static Future<bool> register(String username, String password) async {
    final url = Uri.parse("$baseUrl/register");
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"username": username, "password": password}),
      );

      if (response.statusCode == 201) {
        return true; // Registrasi berhasil
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error["error"] ?? "Registration failed");
      }
    } catch (e) {
      throw Exception("Error during registration: $e");
    }
  }

  // Mengirim data sensor
  static Future<bool> postSensorData(Map<String, dynamic> sensorData) async {
    final url = Uri.parse("$baseUrl/sensor_data");
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(sensorData),
      );

      if (response.statusCode == 201) {
        return true; // Data sensor berhasil dikirim
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error["error"] ?? "Failed to send sensor data");
      }
    } catch (e) {
      throw Exception("Error during sending sensor data: $e");
    }
  }

  // Mengambil data sensor (GET)
  static Future<List<SensorData>> getSensorData() async {
    final url = Uri.parse("$baseUrl/sensor_data");
    try {
      final response = await http.get(
        url,
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // Mengonversi data JSON menjadi List<SensorData>
        List<SensorData> sensorDataList = (data['sensor_data'] as List)
            .map((sensor) => SensorData.fromJson(sensor))
            .toList();
        return sensorDataList;
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error["error"] ?? "Failed to fetch sensor data");
      }
    } catch (e) {
      throw Exception("Error fetching sensor data: $e");
    }
  }
}
