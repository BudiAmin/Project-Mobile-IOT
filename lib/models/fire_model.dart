class FireImage {
  final String timestamp;
  final String fireImageUrl;

  FireImage({
    required this.timestamp,
    required this.fireImageUrl,
  });

  // Factory untuk membuat instance dari JSON
  factory FireImage.fromJson(Map<String, dynamic> json) {
    return FireImage(
      timestamp: json['timestamp'] as String,
      fireImageUrl: json['fire_image_url'] as String,
    );
  }

  // Konversi instance menjadi JSON (opsional)
  Map<String, dynamic> toJson() {
    return {
      'timestamp': timestamp,
      'fire_image_url': fireImageUrl,
    };
  }

  // Parsing daftar FireImage dari JSON array
  static List<FireImage> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => FireImage.fromJson(json)).toList();
  }
}
