import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import '../themes/theme_model.dart';
import '../services/mqtt_service.dart';
import '../models/sensor_model.dart';
import 'detail_screen.dart';
import 'history_screen.dart';
import 'team_screen.dart';
import '../services/api_service.dart';
import '../models/fire_model.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  SensorData _sensorData = SensorData(
    distance: 0.0,
    strobo: 'Off',
    batre: 0,
    speaker: 'Off',
    pompa: 'Off',
    fire: "Unknown",
  );

  late MqttService mqttService;
  int _selectedIndex = 0;
  late PageController _pageController;

  String _fireImageUrl = ''; // URL gambar kebakaran
  List<FireImage> _fireImages = [];
  bool _isImageSelected = false; // Flag apakah gambar telah dipilih

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
    _loadFireImages(); // Ambil gambar kebakaran dari API

    _pageController = PageController(initialPage: _selectedIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    mqttService.disconnect(); // Disconnect MQTT service properly
    super.dispose();
  }

  Future<void> _loadFireImages() async {
    try {
      List<FireImage> fireImages = await ApiService.getFireImages();
      if (mounted) {
        setState(() {
          _fireImages = fireImages;
        });
      }
    } catch (e) {
      print("Error loading fire images: $e");
    }
  }

  Widget _buildCameraWidget() {
    return GestureDetector(
      onTap: _showImageSelectionDialog,
      child: Container(
        height: 250, // Tinggi gambar
        width: double.infinity, // Lebar penuh layar
        decoration: BoxDecoration(
          color: Colors.white, // Latar belakang container
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.redAccent, // Warna pada keempat sisi
              blurRadius: 6.0, // Efek blur pada warna
              spreadRadius: 2.0, // Lebar warna di sekitar container
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15), // Untuk menjaga sudut gambar
          child: Stack(
            children: [
              // Jika gambar telah dipilih, tampilkan gambar
              _isImageSelected && _fireImageUrl.isNotEmpty
                  ? Image.network(
                      _fireImageUrl,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    )
                  // Jika belum dipilih, tampilkan placeholder
                  : Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.image, size: 60, color: Colors.redAccent),
                          SizedBox(height: 10),
                          Text(
                            'Tap to Select Image',
                            style: TextStyle(
                                fontSize: 22, color: Colors.redAccent),
                          ),
                        ],
                      ),
                    ),
              // Tombol close untuk menghapus gambar
              if (_isImageSelected && _fireImageUrl.isNotEmpty)
                Positioned(
                  top: 10,
                  right: 10,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _fireImageUrl = ''; // Hapus URL gambar
                        _isImageSelected = false; // Reset flag gambar
                      });
                    },
                    child: CircleAvatar(
                      radius: 15,
                      backgroundColor: Colors.redAccent,
                      child: Icon(
                        Icons.close,
                        size: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _showImageSelectionDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.5,
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Select Fire Image',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.redAccent,
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: _fireImages.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: Image.network(
                        _fireImages[index].fireImageUrl,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                      title: Text(
                        'Image ${index + 1}',
                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodyLarge?.color,
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          _fireImageUrl = _fireImages[index].fireImageUrl;
                          _isImageSelected =
                              true; // Tandai bahwa gambar telah dipilih
                        });
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
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
                _buildCameraWidget(),
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
                      value: _sensorData.strobo,
                      icon: Icons.lightbulb_outline,
                      isDark: themeProvider.isDark,
                    ),
                    InfoCard(
                      title: 'Battery Voltage',
                      value: '${_sensorData.batre} V',
                      icon: Icons.battery_charging_full,
                      isDark: themeProvider.isDark,
                    ),
                    InfoCard(
                      title: 'Speaker Status',
                      value: _sensorData.speaker,
                      icon: Icons.speaker,
                      isDark: themeProvider.isDark,
                    ),
                    InfoCard(
                      title: 'Fire Status',
                      value: _sensorData.fire,
                      icon: Icons.warning,
                      isDark: themeProvider.isDark,
                    ),
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
          HistoryScreen(),
          TeamScreen(),
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
