import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Camera and Sensor Data',
      home: CameraAndSensorScreen(),
    );
  }
}

class CameraAndSensorScreen extends StatefulWidget {
  @override
  _CameraAndSensorScreenState createState() => _CameraAndSensorScreenState();
}

class _CameraAndSensorScreenState extends State<CameraAndSensorScreen> {
  CameraController? _cameraController;
  List<CameraDescription> _cameras = [];
  final _channel = WebSocketChannel.connect(
    Uri.parse('ws://192.168.0.70:3001'), // Ganti dengan IP komputer Anda
  );

  // Sensor data state
  String ultrasonicDistance = "-";
  String relayStatus = "-";
  String strobeStatus = "-";
  String rotatorStatus = "-";
  String batteryVoltage = "-";
  String speakerStatus = "-";

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _listenToWebSocket();
  }

  Future<void> _initializeCamera() async {
    try {
      _cameras = await availableCameras();
      if (_cameras.isNotEmpty) {
        _cameraController = CameraController(
          _cameras.first,
          ResolutionPreset.medium,
        );

        await _cameraController!.initialize();
        setState(() {});
      }
    } catch (e) {
      print('Error initializing camera: $e');
    }
  }

  void _listenToWebSocket() {
    _channel.stream.listen((message) {
      try {
        final sensorData = Map<String, dynamic>.from(message);
        setState(() {
          ultrasonicDistance = sensorData['ultrasonic_distance'] ?? "-";
          relayStatus = sensorData['relay_status'] ?? "-";
          strobeStatus = sensorData['strobe_status'] ?? "-";
          rotatorStatus = sensorData['rotator_status'] ?? "-";
          batteryVoltage = sensorData['battery_voltage'] ?? "-";
          speakerStatus = sensorData['speaker_status'] ?? "-";
        });
      } catch (e) {
        print('Error parsing WebSocket message: $e');
      }
    });
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    _channel.sink.close(status.goingAway);
    super.dispose();
  }

  Widget buildCameraView() {
    if (_cameraController != null && _cameraController!.value.isInitialized) {
      return Expanded(
        child: CameraPreview(_cameraController!),
      );
    } else {
      return Container(
        height: 300,
        color: Colors.grey[300],
        child: Center(
          child: Icon(Icons.camera_alt, size: 50, color: Colors.grey),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Camera and Sensor Data'),
      ),
      body: Column(
        children: [
          buildCameraView(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  if (_cameraController != null &&
                      _cameraController!.value.isInitialized) {
                    _cameraController!.startVideoRecording();
                  }
                },
                child: Text("Start Camera"),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  if (_cameraController != null) {
                    _cameraController!.dispose();
                    setState(() {});
                  }
                },
                child: Text("Stop Camera"),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildSensorData(),
        ],
      ),
    );
  }

  Widget _buildSensorData() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Ultrasonic Distance: $ultrasonicDistance"),
        Text("Relay Status: $relayStatus"),
        Text("Strobe Status: $strobeStatus"),
        Text("Rotator Status: $rotatorStatus"),
        Text("Battery Voltage: $batteryVoltage"),
        Text("Speaker Status: $speakerStatus"),
      ],
    );
  }
}
