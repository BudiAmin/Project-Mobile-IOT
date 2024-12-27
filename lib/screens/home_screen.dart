import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:camera/camera.dart';
import 'package:video_player/video_player.dart';
import '../themes/theme_model.dart';
import '../services/mqtt_service.dart';
import '../models/sensor_model.dart';
import 'detail_screen.dart';
import 'history_screen.dart';
import 'team_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isCameraOn = false;
  late CameraController _cameraController;
  late List<CameraDescription> _cameras;
  late CameraDescription _selectedCamera;
  late VideoPlayerController _ipCameraController;
  bool _isIpCameraOn = false;

  SensorData _sensorData = SensorData(
    distance: 0.0,
    strobe: 'Off',
    batteryVoltage: 0.0,
    speaker: 'Off',
    pompa: 'Off',
  );

  late MqttService mqttService;

  int _selectedIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    mqttService = MqttService(
      onDataReceived: (SensorData sensorData) {
        if (mounted) {
          setState(() {
            _sensorData = sensorData;
          });
        }
      },
    );

    mqttService.connect();
    _requestCameraPermission();
    _initializeCameras();

    _pageController = PageController(initialPage: _selectedIndex);
  }

  @override
  void dispose() {
    if (_isCameraOn) _cameraController.dispose();
    if (_isIpCameraOn) _ipCameraController.dispose();
    _pageController.dispose();
    mqttService.disconnect(); // Disconnect MQTT service properly
    super.dispose();
  }

  Future<void> _requestCameraPermission() async {
    PermissionStatus cameraStatus = await Permission.camera.status;

    if (!cameraStatus.isGranted) {
      PermissionStatus status = await Permission.camera.request();
      if (!status.isGranted && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Camera permission is required!',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  Future<void> _initializeCameras() async {
    try {
      _cameras = await availableCameras();
      if (_cameras.isNotEmpty) {
        _selectedCamera = _cameras.first;
      }
    } catch (e) {
      if (mounted) {
        print('Failed to get available cameras: $e');
      }
    }
  }

  Future<void> _startCamera(CameraDescription cameraDescription) async {
    _cameraController = CameraController(
      cameraDescription,
      ResolutionPreset.medium,
    );

    try {
      await _cameraController.initialize();
      if (mounted) {
        setState(() {
          _isCameraOn = true;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Failed to initialize camera: $e',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  Future<void> _startIpCamera(String url) async {
    _ipCameraController = VideoPlayerController.network(url)
      ..initialize().then((_) {
        if (mounted) {
          setState(() {
            _isIpCameraOn = true;
            _ipCameraController.play();
          });
        }
      }).catchError((e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Failed to load IP Camera: $e',
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.redAccent,
            ),
          );
        }
      });
  }

  Future<void> _startUsbCamera() async {
    // Add your USB camera initialization code here
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'USB Camera feature is not implemented yet.',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  void _toggleCamera() async {
    if (_isCameraOn) {
      setState(() {
        _isCameraOn = false;
      });
      await _cameraController.dispose();
    } else {
      await _startCamera(_selectedCamera);
    }
  }

  Widget _buildCameraWidget() {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.redAccent, width: 2),
        borderRadius: BorderRadius.circular(15),
      ),
      child: _isCameraOn
          ? CameraPreview(_cameraController)
          : _isIpCameraOn
              ? VideoPlayer(_ipCameraController)
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.camera_alt, size: 50, color: Colors.redAccent),
                    SizedBox(width: 10),
                    Text(
                      '[Camera OFF]',
                      style: TextStyle(fontSize: 22, color: Colors.redAccent),
                    ),
                  ],
                ),
    );
  }

  void _onItemTapped(int index) {
    if (mounted) {
      setState(() {
        _selectedIndex = index;
      });
      _pageController.animateToPage(
        index,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeModel>(context);

    return Scaffold(
      appBar: _selectedIndex == 0
          ? AppBar(
              title: Text(
                'Dashboard FIREFIGHTER',
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
              actions: [
                PopupMenuButton<String>(
                  onSelected: (String choice) async {
                    if (choice == 'Front Camera') {
                      final frontCamera = _cameras.firstWhere(
                        (camera) =>
                            camera.lensDirection == CameraLensDirection.front,
                        orElse: () => _cameras.first,
                      );
                      await _startCamera(frontCamera);
                    } else if (choice == 'Rear Camera') {
                      final rearCamera = _cameras.firstWhere(
                        (camera) =>
                            camera.lensDirection == CameraLensDirection.back,
                        orElse: () => _cameras.first,
                      );
                      await _startCamera(rearCamera);
                    } else if (choice == 'IP Camera') {
                      await _startIpCamera('http://192.168.1.100:8080/video');
                    } else if (choice == 'USB Camera') {
                      await _startUsbCamera();
                    }
                  },
                  itemBuilder: (context) {
                    return [
                      PopupMenuItem(
                        value: 'Front Camera',
                        child: Text('Front Camera'),
                      ),
                      PopupMenuItem(
                        value: 'Rear Camera',
                        child: Text('Back Camera'),
                      ),
                      PopupMenuItem(
                        value: 'IP Camera',
                        child: Text('IP Camera'),
                      ),
                      PopupMenuItem(
                        value: 'USB Camera',
                        child: Text('USB Camera'),
                      ),
                    ];
                  },
                  icon: Icon(Icons.switch_camera, color: Colors.white),
                ),
              ],
            )
          : null,
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        children: [
          SingleChildScrollView(
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
                    child: _buildCameraWidget(),
                  ),
                ),
                SizedBox(height: 16),
                Wrap(
                  spacing: 16.0,
                  runSpacing: 16.0,
                  children: [
                    InfoCard(
                      title: 'Ultrasonic Distance',
                      value: '${_sensorData.distance} cm',
                      icon: Icons.radar,
                      isDark: themeProvider.isDark,
                    ),
                    InfoCard(
                      title: 'Strobe Status',
                      value: _sensorData.strobe,
                      icon: Icons.lightbulb_outline,
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
                      value: _sensorData.speaker,
                      icon: Icons.speaker,
                      isDark: themeProvider.isDark,
                    ),
                    // InfoCard(
                    //   title: 'Fire Status',
                    //   value: _sensorData.fireStatus,
                    //   icon: Icons.warning,
                    //   isDark: themeProvider.isDark,
                    // ),
                    InfoCard(
                      title: 'Pompa Status',
                      value: _sensorData.pompa,
                      icon: Icons.water,
                      isDark: themeProvider.isDark,
                    ),
                  ],
                ),
              ],
            ),
          ),
          HistoryScreen(), // Assuming this is a static screen
          TeamScreen(), // Assuming this is a static screen
        ],
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
      bottomNavigationBar: CurvedNavigationBar(
        index: _selectedIndex,
        height: 60.0,
        color: Colors.redAccent,
        backgroundColor: Colors.white,
        buttonBackgroundColor: Colors.redAccent,
        animationDuration: Duration(milliseconds: 300),
        animationCurve: Curves.easeInOut,
        items: <Widget>[
          Icon(Icons.home, size: 30, color: Colors.white),
          Icon(Icons.graphic_eq, size: 30, color: Colors.white),
          Icon(Icons.group, size: 30, color: Colors.white),
        ],
        onTap: _onItemTapped,
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
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (context) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.6,
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
