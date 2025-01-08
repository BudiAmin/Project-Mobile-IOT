import 'package:flutter/material.dart';
import 'package:aplikasi_iot/models/sensor_model.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:aplikasi_iot/services/mqtt_service.dart';

class DetailScreen extends StatefulWidget {
  final String title;
  final IconData icon;
  final String value;

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

    // Initialize chart data
    chartData = [for (int i = 0; i < 10; i++) _ChartData(i, 0.0)];

    // Initialize MQTT service
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

        // Remove old data to keep chart concise
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
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Icon(widget.icon, size: 60, color: Colors.redAccent),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.title,
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Current Value: ${widget.value}',
                            style:
                                TextStyle(fontSize: 16, color: Colors.black54),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        'Live Chart ${widget.title}',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 16),
                      Expanded(
                        child: SfCartesianChart(
                          primaryXAxis: NumericAxis(
                              title: AxisTitle(text: 'Time (seconds)')),
                          primaryYAxis: NumericAxis(
                              title: AxisTitle(
                                  text: widget.title == 'Battery Voltage'
                                      ? 'Battery Capacity (%)'
                                      : 'Value')),
                          title: ChartTitle(text: 'Graph of ${widget.title}'),
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
                    ],
                  ),
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
