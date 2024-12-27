/// Model untuk data sensor.
class SensorData {
  /// Jarak yang terdeteksi oleh sensor.
  final double distance;

  /// Status lampu strobe.
  final String strobe;

  /// Tegangan baterai.
  final double batteryVoltage;

  /// Status speaker.
  final String speaker;

  /// Status pompa.
  final String pompa;

  /// Konstruktor utama dengan parameter wajib.
  SensorData({
    required this.distance,
    required this.strobe,
    required this.batteryVoltage,
    required this.speaker,
    required this.pompa,
  });

  /// Factory constructor untuk parsing dari JSON.
  factory SensorData.fromJson(Map<String, dynamic> json) {
    return SensorData(
      distance: (json['distance'] as num?)?.toDouble() ?? 0.0,
      strobe: json['strobe']?.toString() ?? 'OFF',
      batteryVoltage: (json['battery_voltage'] as num?)?.toDouble() ?? 0.0,
      speaker: json['speaker']?.toString() ?? 'OFF',
      pompa: json['pompa']?.toString() ?? 'OFF',
    );
  }

  /// Mengonversi objek SensorData menjadi format JSON.
  Map<String, dynamic> toJson() {
    return {
      'distance': distance,
      'strobe': strobe,
      'battery_voltage': batteryVoltage,
      'speaker': speaker,
      'pompa': pompa,
    };
  }
}
