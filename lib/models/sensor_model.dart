/// Model untuk data sensor.
class SensorData {
  /// Jarak yang terdeteksi oleh sensor.
  final double distance;

  /// Status lampu strobo.
  final String strobo;

  /// Tegangan baterai.
  final int batre;

  /// Status speaker.
  final String speaker;

  /// Status pompa.
  final String pompa;

  /// Status fire.
  final String fire;

  /// Konstruktor utama dengan parameter wajib.
  SensorData({
    required this.distance,
    required this.strobo,
    required this.batre,
    required this.speaker,
    required this.pompa,
    required this.fire,
  });

  /// Factory constructor untuk parsing dari JSON.
  factory SensorData.fromJson(Map<String, dynamic> json) {
    return SensorData(
      distance: (json['distance'] as num?)?.toDouble() ?? 0.0,
      strobo: json['strobo']?.toString() ?? 'OFF',
      batre: (json['batre'] as num?)?.toInt() ?? 0,
      speaker: json['speaker']?.toString() ?? 'OFF',
      pompa: json['pompa']?.toString() ?? 'OFF',
      fire: json['fire']?.toString() ?? 'UNKNOWN',
    );
  }

  /// Mengonversi objek SensorData menjadi format JSON.
  Map<String, dynamic> toJson() {
    return {
      'distance': distance,
      'strobo': strobo,
      'batre': batre,
      'speaker': speaker,
      'pompa': pompa,
      'fire': fire,
    };
  }
}
