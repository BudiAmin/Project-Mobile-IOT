import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:aplikasi_iot/models/fire_model.dart';
import 'package:aplikasi_iot/models/sensor_model.dart';

class ApiService {
  static const String baseUrl =
      "https://93e6-103-104-130-40.ngrok-free.app/"; // URL backend

  // Variabel untuk menyimpan token
  static String? _token;

  // Login API
  static Future<bool> login(String username, String password) async {
    final url = Uri.parse("$baseUrl/api/login/");
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"username": username, "password": password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _token = data['token'];
        return true;
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
    final url = Uri.parse("$baseUrl/api/register/");
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"username": username, "password": password}),
      );

      if (response.statusCode == 201) {
        return true;
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error["error"] ?? "Registration failed");
      }
    } catch (e) {
      throw Exception("Error during registration: $e");
    }
  }

  // Mengambil data sensor (GET)
  static Future<List<SensorData>> getSensorData() async {
    final url = Uri.parse("$baseUrl/api/sensor-data/");
    try {
      final response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          if (_token != null) "Authorization": "Token $_token",
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
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

  // Mengirim data sensor (POST)
  static Future<bool> postSensorData(Map<String, dynamic> sensorData) async {
    final url = Uri.parse("$baseUrl/api/sensor-data/");
    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          if (_token != null) "Authorization": "Token $_token",
        },
        body: jsonEncode(sensorData),
      );

      if (response.statusCode == 201) {
        return true;
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error["error"] ?? "Failed to send sensor data");
      }
    } catch (e) {
      throw Exception("Error during sending sensor data: $e");
    }
  }

  // Mengambil daftar gambar kebakaran (GET)
  static Future<List<FireImage>> getFireImages() async {
    final url = Uri.parse("$baseUrl/api/fire-images/");
    try {
      final response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          if (_token != null) "Authorization": "Token $_token",
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        List<FireImage> fireImages = (data['fire_images'] as List)
            .map((image) => FireImage.fromJson(image))
            .toList();
        return fireImages;
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error["error"] ?? "Failed to fetch fire images");
      }
    } catch (e) {
      throw Exception("Error fetching fire images: $e");
    }
  }

  // Logout API
  static Future<void> logout() async {
    _token = null;
  }
}
