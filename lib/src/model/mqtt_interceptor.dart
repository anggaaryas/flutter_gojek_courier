import 'dart:typed_data';

class MqttInterceptor{
  Function(Uint8List mqttWireMessageBytes)? onMqttWireMessageSent;
  Function(Uint8List mqttWireMessageBytes)? onMqttWireMessageReceived;

  MqttInterceptor({this.onMqttWireMessageSent, this.onMqttWireMessageReceived});
}