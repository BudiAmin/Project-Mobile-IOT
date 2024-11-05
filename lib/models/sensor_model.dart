class SensorData {
  final double distance;
  final String direction;
  final DateTime timestamp;

  SensorData({required this.distance, required this.direction, required this.timestamp});

  // Factory method untuk konversi dari JSON ke objek SensorData
  factory SensorData.fromJson(Map<String, dynamic> json) {
    return SensorData(
      distance: json['distance'],
      direction: json['direction'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }

  // Metode untuk konversi objek SensorData ke JSON
  Map<String, dynamic> toJson() {
    return {
      'distance': distance,
      'direction': direction,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}
