import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:permission_handler/permission_handler.dart'; // Import Permission Handler
import '../themes/theme_model.dart';
import '../services/mqtt_service.dart';
import '../models/sensor_model.dart'; // Import model SensorData
import 'detail_screen.dart'; // Import DetailScreen

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isCameraOn = false;
  RTCVideoRenderer _cameraRenderer = RTCVideoRenderer();
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

    // Inisialisasi kamera renderer
    _cameraRenderer.initialize();

    // Inisialisasi MQTT Service
    mqttService = MqttService(
      onDataReceived: (SensorData sensorData) {
        setState(() {
          _sensorData = sensorData;
        });
      },
    );

    // Menghubungkan ke broker MQTT
    mqttService.connect();

    // Meminta izin kamera
    _requestCameraPermission();
  }

  @override
  void dispose() {
    // Membersihkan resource
    _cameraRenderer.dispose();
    mqttService.disconnect();
    super.dispose();
  }

  Future<void> _requestCameraPermission() async {
    // Memeriksa izin kamera
    PermissionStatus cameraStatus = await Permission.camera.status;

    if (!cameraStatus.isGranted) {
      // Jika izin belum diberikan, minta izin
      PermissionStatus status = await Permission.camera.request();
      if (!status.isGranted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Camera permission is required!')),
        );
      }
    }
  }

  void _toggleCamera() async {
    if (_isCameraOn) {
      setState(() {
        _isCameraOn = false;
      });
      _cameraRenderer.srcObject = null;
    } else {
      await _selectCamera();
    }
  }

  Future<void> _selectCamera() async {
    final devices = await navigator.mediaDevices.enumerateDevices();
    final videoDevices =
        devices.where((device) => device.kind == 'videoinput').toList();

    if (videoDevices.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No cameras detected!')),
      );
      return;
    }

    String? selectedDeviceId;

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Pilih Kamera'),
          content: StatefulBuilder(
            builder: (context, setState) {
              return DropdownButton<String>(
                isExpanded: true,
                value: selectedDeviceId,
                hint: Text('Pilih kamera...'),
                items: videoDevices.map((device) {
                  return DropdownMenuItem<String>(
                    value: device.deviceId,
                    child: Text(device.label.isNotEmpty
                        ? device.label
                        : 'Camera ${videoDevices.indexOf(device) + 1}'),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedDeviceId = value;
                  });
                },
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(selectedDeviceId);
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );

    if (selectedDeviceId != null) {
      await _initializeCamera(selectedDeviceId!);
      setState(() {
        _isCameraOn = true;
      });
    }
  }

  Future<void> _initializeCamera(String deviceId) async {
    final constraints = {
      'audio': false,
      'video': {
        'deviceId': deviceId,
      },
    };

    final stream = await navigator.mediaDevices.getUserMedia(constraints);
    _cameraRenderer.srcObject = stream;
  }

  Widget _buildCameraWidget() {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.redAccent),
        borderRadius: BorderRadius.circular(15),
      ),
      child: RTCVideoView(
        _cameraRenderer,
        mirror: true,
      ),
    );
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
            // Kotak kamera yang tetap pada tempatnya
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
                child: _isCameraOn
                    ? _buildCameraWidget()
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.camera_alt,
                            size: 50,
                            color: Colors.redAccent,
                          ),
                          SizedBox(width: 10),
                          Text(
                            '[Camera OFF]',
                            style: TextStyle(
                              fontSize: 22,
                              color: themeProvider.isDark
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
            SizedBox(height: 16),
            // Grid di bawah kamera, tidak menutupi kamera
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
        showModalBottomSheet(
          context: context,
          isScrollControlled: true, // Untuk memungkinkan tinggi yang fleksibel
          backgroundColor: Colors.transparent,
          builder: (context) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.6, // 60% layar
              decoration: BoxDecoration(
                color: isDark ? Colors.grey[900] : Colors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
              ),
              child: DetailScreen(
                title: title,
                value: value,
                icon: icon,
              ),
            );
          },
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
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.redAccent,
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
