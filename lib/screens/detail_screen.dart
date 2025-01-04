import 'package:flutter/material.dart';
import 'package:aplikasi_iot/models/sensor_model.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:aplikasi_iot/services/mqtt_service.dart';

class DetailScreen extends StatefulWidget {
  final String title;
  final IconData icon;
  final String value;

  // Konstruktor
  DetailScreen({
    required this.title,
    required this.icon,
    required this.value,
  });

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late List<_ChartData> chartData;
  int time = 0;
  late MqttService mqttService;

  @override
  void initState() {
    super.initState();

    // Inisialisasi data grafik
    chartData = [for (int i = 0; i < 10; i++) _ChartData(i, 0.0)];

    // Inisialisasi MQTT
    mqttService = MqttService(onDataReceived: _onDataReceived);
    mqttService.connect();
  }

  @override
  void dispose() {
    mqttService.disconnect();
    super.dispose();
  }

  void _onDataReceived(SensorData sensorData) {
    double sensorValue = _getSensorValue(sensorData);

    if (mounted) {
      setState(() {
        time++;
        chartData.add(_ChartData(time, sensorValue));

        // Hapus data lama agar grafik tetap ringkas
        if (chartData.length > 100) {
          chartData.removeAt(0);
        }
      });
    }
  }

  double _getSensorValue(SensorData sensor) {
    switch (widget.title) {
      case 'Ultrasonic Distance':
        return sensor.distance;
      case 'Pompa Status':
        return (sensor.pompa == 'on') ? 1.0 : 0.0;
      case 'Strobe Status':
        return (sensor.strobo == 'on') ? 1.0 : 0.0;
      case 'Battery Voltage':
        return sensor.batre.toDouble();
      case 'Speaker Status':
        return (sensor.speaker == 'on') ? 1.0 : 0.0;
      case 'API Status':
        return (sensor.fire == 'on') ? 1.0 : 0.0;
      default:
        return 0.0;
    }
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

class _ChartData {
  _ChartData(this.x, this.y);
  final int x;
  final double y;
}
