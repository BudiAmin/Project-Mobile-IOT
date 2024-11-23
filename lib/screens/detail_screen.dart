import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class DetailScreen extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  DetailScreen({
    required this.title,
    required this.value,
    required this.icon,
  });

  // Data contoh untuk grafik
  final List<_ChartData> chartData = [
    _ChartData(1, 20),
    _ChartData(2, 35),
    _ChartData(3, 28),
    _ChartData(4, 45),
    _ChartData(5, 40),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 50, color: Colors.redAccent),
              SizedBox(width: 10),
              Text(
                value,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(height: 16),
          Text(
            'Grafik Status',
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
                primaryXAxis: CategoryAxis(),
                title: ChartTitle(text: 'Data Status'),
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
    );
  }
}

// Model data untuk grafik
class _ChartData {
  _ChartData(this.x, this.y);
  final int x;
  final double y;
}
