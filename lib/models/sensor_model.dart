class SensorData {
  final double ultrasonicDistance;
  final String relayStatus;
  final String strobeStatus;
  final String rotatorStatus;
  final double batteryVoltage;
  final String speakerStatus;

  SensorData({
    required this.ultrasonicDistance,
    required this.relayStatus,
    required this.strobeStatus,
    required this.rotatorStatus,
    required this.batteryVoltage,
    required this.speakerStatus,
  });

  // Fungsi untuk membuat objek SensorData dari JSON
  factory SensorData.fromJson(Map<String, dynamic> json) {
    return SensorData(
      ultrasonicDistance: json['ultrasonic_distance'].toDouble(),
      relayStatus: json['relay_status'],
      strobeStatus: json['strobe_status'],
      rotatorStatus: json['rotator_status'],
      batteryVoltage: json['battery_voltage'].toDouble(),
      speakerStatus: json['speaker_status'],
    );
  }

  // Fungsi untuk mengubah objek SensorData menjadi JSON
  Map<String, dynamic> toJson() {
    return {
      'ultrasonic_distance': ultrasonicDistance,
      'relay_status': relayStatus,
      'strobe_status': strobeStatus,
      'rotator_status': rotatorStatus,
      'battery_voltage': batteryVoltage,
      'speaker_status': speakerStatus,
    };
  }
}
