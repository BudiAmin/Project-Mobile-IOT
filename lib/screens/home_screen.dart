import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../themes/theme_model.dart';
import 'detail_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isCameraOn = false;
  double _batteryStatus = 75.0;
  String _motorStatus = 'Off';
  double _distance = 10.0;
  double _waterStatus = 50.0;

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
            Wrap(
              spacing: 16.0,
              runSpacing: 16.0,
              children: [
                InfoCard(
                  title: 'Battery',
                  value: '$_batteryStatus%',
                  icon: Icons.battery_full,
                  isDark: themeProvider.isDark,
                ),
                InfoCard(
                  title: 'Motor Status',
                  value: _motorStatus,
                  icon: Icons.motorcycle,
                  isDark: themeProvider.isDark,
                ),
                InfoCard(
                  title: 'Distance',
                  value: '$_distance cm',
                  icon: Icons.square,
                  isDark: themeProvider.isDark,
                ),
                InfoCard(
                  title: 'Water Status',
                  value: '$_waterStatus%',
                  icon: Icons.water,
                  isDark: themeProvider.isDark,
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
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
        width: 160,
        child: Card(
          elevation: 6,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          color: isDark ? Colors.grey.shade800 : Colors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 30, color: Colors.redAccent),
                Divider(
                  color: Colors.grey,
                  thickness: 1,
                  indent: 10,
                  endIndent: 10,
                ),
                SizedBox(height: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black54,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 22,
                    color: Colors.redAccent,
                    fontWeight: FontWeight.w600,
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
