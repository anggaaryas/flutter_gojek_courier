import 'dart:typed_data';

class MqttInterceptor {
  const MqttInterceptor({
    this.onMqttWireMessageSent,
    this.onMqttWireMessageReceived,
  });

  final Function(Uint8List mqttWireMessageBytes)? onMqttWireMessageSent;
  final Function(Uint8List mqttWireMessageBytes)? onMqttWireMessageReceived;
}
