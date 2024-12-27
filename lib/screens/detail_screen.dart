import 'dart:async';
import 'package:flutter/material.dart';
import 'package:aplikasi_iot/models/sensor_model.dart'; // Model SensorData
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:aplikasi_iot/services/api_service.dart'; // API Service

class DetailScreen extends StatefulWidget {
  final String title;
  final IconData icon;

  DetailScreen({
    required this.title,
    required this.icon, required String value,
  });

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late List<_ChartData> chartData;
  late Timer timer;
  int time = 0;

  @override
  void initState() {
    super.initState();
    // Inisialisasi data grafik
    chartData = [for (int i = 0; i < 10; i++) _ChartData(i, 0.0)];

    // Timer untuk memperbarui data setiap 1 detik
    timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
      setState(() {
        time++;
        _updateChartData();
      });
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  // Fungsi untuk memperbarui data grafik dengan data sensor terbaru
  void _updateChartData() async {
    try {
      // Mengambil data sensor dari API
      List<SensorData> sensorDataList =
          (await ApiService.getSensorData()).cast<SensorData>();

      // Debugging log
      print('Sensor Data: $sensorDataList');

      // Mendapatkan nilai yang sesuai berdasarkan judul layar
      double sensorValue = _getSensorValue(sensorDataList);

      // Menambahkan data ke grafik
      setState(() {
        chartData.add(_ChartData(time, sensorValue));
        if (chartData.length > 100) {
          chartData.removeAt(0);
        }
      });
    } catch (e) {
      print('Error fetching sensor data: $e');
    }
  }

  // Fungsi untuk mengambil nilai sensor yang sesuai dengan title
  double _getSensorValue(List<SensorData> sensorDataList) {
    if (sensorDataList.isNotEmpty) {
      SensorData sensor = sensorDataList[0];

      switch (widget.title) {
        case 'Ultrasonic Distance':
          return sensor.distance;
        case 'Pompa Status':
          return (sensor.pompa == 'on') ? 1.0 : 0.0;
        case 'Strobe Status':
          return (sensor.strobe == 'on') ? 1.0 : 0.0;
        case 'Battery Voltage':
          return sensor.batteryVoltage;
        case 'Speaker Status':
          return (sensor.speaker == 'on') ? 1.0 : 0.0;
        default:
          return 0.0;
      }
    }
    return 0.0; // Jika data kosong atau null
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.redAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Header Icon dan Judul
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(widget.icon, size: 50, color: Colors.redAccent),
                SizedBox(width: 10),
                Text(
                  widget.title,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 16),

            // Grafik
            Text(
              'Live Chart ${widget.title}',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black26),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: SfCartesianChart(
                  primaryXAxis:
                      NumericAxis(title: AxisTitle(text: 'Waktu (detik)')),
                  primaryYAxis: NumericAxis(
                      title: AxisTitle(
                          text: widget.title == 'Battery Voltage'
                              ? 'Kapasitas Baterai (%)'
                              : 'Nilai')),
                  title: ChartTitle(text: 'Grafik ${widget.title}'),
                  legend: Legend(isVisible: false),
                  tooltipBehavior: TooltipBehavior(enable: true),
                  series: <LineSeries<_ChartData, int>>[
                    LineSeries<_ChartData, int>(
                      dataSource: chartData,
                      xValueMapper: (_ChartData data, _) => data.x,
                      yValueMapper: (_ChartData data, _) => data.y,
                      color: Colors.redAccent,
                      markerSettings: MarkerSettings(isVisible: true),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Model data untuk grafik
class _ChartData {
  _ChartData(this.x, this.y);
  final int x;
  final double y;
}
