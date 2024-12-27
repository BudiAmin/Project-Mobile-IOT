import 'package:flutter/material.dart';
import 'package:aplikasi_iot/services/api_service.dart';
import 'package:syncfusion_flutter_charts/charts.dart'; // Import Syncfusion Charts
import 'package:aplikasi_iot/models/sensor_model.dart'; // Import SensorData model

class HistoryScreen extends StatefulWidget {
  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  late Future<List<SensorData>> _sensorDataList; // Menyimpan data sensor
  bool _showGraph = false; // Menentukan apakah grafik ditampilkan atau tidak

  @override
  void initState() {
    super.initState();
    _sensorDataList = ApiService.getSensorData(); // Mengambil data sensor dari API
  }

  // Fungsi untuk menggambar grafik dengan Syncfusion
  SfCartesianChart _buildChart(List<SensorData> data) {
    List<ChartData> chartData = List<ChartData>.generate(
      data.length,
      (index) => ChartData(
        x: index.toDouble(),
        y: data[index].distance,
      ),
    );

    return SfCartesianChart(
      title: ChartTitle(text: 'Sensor Data History'),
      primaryXAxis: NumericAxis(title: AxisTitle(text: 'Index')),
      primaryYAxis: NumericAxis(title: AxisTitle(text: 'Value')),
      series: <ChartSeries<ChartData, double>>[
        LineSeries<ChartData, double>(
          dataSource: chartData,
          xValueMapper: (ChartData data, _) => data.x,
          yValueMapper: (ChartData data, _) => data.y,
          name: ' Distance',
          markerSettings: MarkerSettings(isVisible: true),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sensor History'),
        centerTitle: true,
        backgroundColor: Colors.redAccent,
        actions: [
          IconButton(
            icon: Icon(Icons.graphic_eq),
            onPressed: () {
              setState(() {
                _showGraph = !_showGraph; // Toggle grafik
              });
            },
          ),
        ],
      ),
      body: FutureBuilder<List<SensorData>>(
        future: _sensorDataList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No data available.'));
          } else {
            List<SensorData> sensorDataList = snapshot.data!;

            // Jika _showGraph true, tampilkan grafik
            if (_showGraph) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: _buildChart(sensorDataList), // Menampilkan grafik
              );
            }

            // Jika grafik tidak ditampilkan, tampilkan data history
            return GridView.builder(
              padding: EdgeInsets.all(16.0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // 2 kolom dalam grid
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 16.0,
              ),
              itemCount: sensorDataList.length, // Menampilkan data berdasarkan jumlah data
              itemBuilder: (context, index) {
                var sensorData = sensorDataList[index]; // Ambil data sensor

                return Card(
                  elevation: 6,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      children: [
                        Icon(Icons.history, size: 40, color: Colors.redAccent),
                        SizedBox(height: 10),
                        Text(
                          ': ${sensorData.distance} cm',
                          style: TextStyle(fontSize: 14),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Battery: ${sensorData.batteryVoltage} V',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Strobe: ${sensorData.strobe}',
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}

// Model untuk data grafik
class ChartData {
  final double x;
  final double y;

  ChartData({required this.x, required this.y});
}
