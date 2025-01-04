import 'package:aplikasi_iot/models/sensor_model.dart'; // Pastikan model ini ada dan benar
import 'package:mqtt_client/mqtt_client.dart' as mqtt;
import 'package:mqtt_client/mqtt_server_client.dart' as mqtt;
import 'dart:convert';

class MqttService {
  late mqtt.MqttServerClient client;
  final String broker = 'broker.hivemq.com'; // Broker MQTT
  final int port = 1883; // Port koneksi MQTT tanpa TLS
  final String topic = 'mobil/ff'; // Topik MQTT
  final String clientId = 'Mobil_${DateTime.now().millisecondsSinceEpoch}';
  final Function(SensorData) onDataReceived;

  MqttService({required this.onDataReceived});

  /// Fungsi untuk menghubungkan ke broker MQTT
  Future<void> connect() async {
    client = mqtt.MqttServerClient(broker, clientId)
      ..port = port
      ..keepAlivePeriod = 90 // Keep-alive interval
      ..autoReconnect = true // Aktifkan auto reconnect
      ..resubscribeOnAutoReconnect = true // Resubscribe setelah reconnect
      ..logging(on: false); // Nonaktifkan logging (aktifkan saat debugging)

    // Pesan koneksi MQTT
    final mqtt.MqttConnectMessage connMess = mqtt.MqttConnectMessage()
        .withClientIdentifier(clientId)
        .startClean() // Membersihkan sesi sebelumnya
        .withWillTopic('$topic/disconnect') // Pesan jika koneksi mati
        .withWillMessage('Client disconnected')
        .withWillQos(mqtt.MqttQos.atLeastOnce);

    client.connectionMessage = connMess;

    try {
      print('Mencoba menghubungkan ke broker MQTT...');
      await client.connect();

      // Periksa status koneksi
      if (client.connectionStatus?.state ==
          mqtt.MqttConnectionState.connected) {
        print('Berhasil terhubung ke broker MQTT');
        subscribeToTopic(); // Subscribe setelah koneksi berhasil
      } else {
        print(
            'Gagal terhubung ke broker, status: ${client.connectionStatus?.state}');
        client.disconnect();
      }
    } catch (e) {
      print('Kesalahan saat menghubungkan ke broker MQTT: $e');
      client.disconnect();
    }
  }

  /// Fungsi untuk subscribe ke topik MQTT
  void subscribeToTopic() {
    try {
      client.subscribe(topic, mqtt.MqttQos.atLeastOnce);
      print('Berhasil subscribe ke topik: $topic');
      listenToMessages();
    } catch (e) {
      print('Gagal subscribe ke topik: $e');
    }
  }

  /// Fungsi untuk mendengarkan pesan MQTT
  void listenToMessages() {
    client.updates
        ?.listen((List<mqtt.MqttReceivedMessage<mqtt.MqttMessage>> event) {
      try {
        final mqtt.MqttPublishMessage message =
            event[0].payload as mqtt.MqttPublishMessage;
        final String payload = mqtt.MqttPublishPayload.bytesToStringAsString(
            message.payload.message);
        print('Pesan diterima: $payload');

        // Konversi JSON menjadi objek SensorData
        final sensorData = SensorData.fromJson(jsonDecode(payload));
        onDataReceived(sensorData); // Kirim data ke UI atau handler lain
      } catch (e) {
        print('Kesalahan saat memproses pesan: $e');
      }
    });
  }

  /// Fungsi untuk mengirim pesan ke broker MQTT
  void publishMessage(Map<String, dynamic> message) {
    final String payload = jsonEncode(message);
    final mqtt.MqttClientPayloadBuilder builder =
        mqtt.MqttClientPayloadBuilder();
    builder.addString(payload);

    try {
      client.publishMessage(topic, mqtt.MqttQos.atLeastOnce, builder.payload!);
      print('Pesan berhasil dikirim: $payload');
    } catch (e) {
      print('Gagal mengirim pesan: $e');
    }
  }

  /// Fungsi untuk menutup koneksi MQTT
  void disconnect() {
    try {
      client.disconnect();
      print('Koneksi ke broker MQTT telah ditutup.');
    } catch (e) {
      print('Kesalahan saat menutup koneksi: $e');
    }
  }
}
