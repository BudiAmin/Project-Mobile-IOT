import 'package:aplikasi_iot/models/sensor_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../themes/theme_model.dart';
import 'detail_screen.dart';
import '../services/mqtt_service.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isCameraOn = false;
  SensorData _sensorData = SensorData(
    ultrasonicDistance: 0.0,
    relayStatus: 'Off',
    strobeStatus: 'Off',
    rotatorStatus: 'Off',
    batteryVoltage: 0.0,
    speakerStatus: 'Off',
  );

  late MqttService mqttService;

  @override
  void initState() {
    super.initState();

    // Inisialisasi mqttService dengan callback onDataReceived
    mqttService = MqttService(
      onDataReceived: (SensorData sensorData) {
        setState(() {
          _sensorData = sensorData;
        });
      },
    );

    // Menghubungkan ke broker MQTT
    mqttService.connect();
  }

  @override
  void dispose() {
    mqttService.disconnect();
    super.dispose();
  }

  void _toggleCamera() {
    setState(() {
      _isCameraOn = !_isCameraOn;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Dashboard Pemadam Kebakaran',
          style: TextStyle(
            color: themeProvider.isDark ? Colors.white : Colors.black,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.redAccent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pushReplacementNamed('/login_screen');
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: _toggleCamera,
              child: Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      _isCameraOn ? Icons.camera : Icons.camera_alt,
                      size: 50,
                      color: Colors.redAccent,
                    ),
                    SizedBox(width: 10),
                    Text(
                      _isCameraOn ? '[Camera ON]' : '[Camera OFF]',
                      style: TextStyle(
                        fontSize: 22,
                        color:
                            themeProvider.isDark ? Colors.white : Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            // Sensor Grid
            Wrap(
              spacing: 16.0,
              runSpacing: 16.0,
              children: [
                InfoCard(
                  title: 'Ultrasonic Distance',
                  value: '${_sensorData.ultrasonicDistance} cm',
                  icon: Icons.radar,
                  isDark: themeProvider.isDark,
                ),
                InfoCard(
                  title: 'Relay Status',
                  value: _sensorData.relayStatus,
                  icon: Icons.switch_right,
                  isDark: themeProvider.isDark,
                ),
                InfoCard(
                  title: 'Strobe Status',
                  value: _sensorData.strobeStatus,
                  icon: Icons.lightbulb_outline,
                  isDark: themeProvider.isDark,
                ),
                InfoCard(
                  title: 'Rotator Status',
                  value: _sensorData.rotatorStatus,
                  icon: Icons.rotate_right,
                  isDark: themeProvider.isDark,
                ),
                InfoCard(
                  title: 'Battery Voltage',
                  value: '${_sensorData.batteryVoltage} V',
                  icon: Icons.battery_charging_full,
                  isDark: themeProvider.isDark,
                ),
                InfoCard(
                  title: 'Speaker Status',
                  value: _sensorData.speakerStatus,
                  icon: Icons.speaker,
                  isDark: themeProvider.isDark,
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Mengirim data yang sesuai dengan format Map<String, dynamic>
          mqttService.publishMessage({
            'message': 'Sensor Data Updated',
            'timestamp': DateTime.now().toString(),
          });
        },
        backgroundColor: Colors.redAccent,
        child: Icon(Icons.add),
      ),
    );
  }
}

class InfoCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final bool isDark;

  InfoCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailScreen(
              title: title,
              value: value,
              icon: icon,
            ),
          ),
        );
      },
      child: Container(
        width: 140,
        child: Card(
          elevation: 6,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          color: isDark ? Colors.grey.shade800 : Colors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 40, color: Colors.redAccent),
                SizedBox(height: 10),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black,
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
