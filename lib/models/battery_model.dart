class BatteryStatus {
  final double battery;
  final String motorStatus;

  BatteryStatus({required this.battery, required this.motorStatus});

  factory BatteryStatus.fromJson(Map<String, dynamic> json) {
    return BatteryStatus(
      battery: json['battery'].toDouble(),
      motorStatus: json['motorStatus'],
    );
  }
}
