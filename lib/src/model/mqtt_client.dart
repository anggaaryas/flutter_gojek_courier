import 'mqtt_configuration.dart';
import 'package:json_annotation/json_annotation.dart';

part 'mqtt_client.g.dart';

@JsonSerializable()
class MqttClient {
  const MqttClient({
    this.configuration,
  });

  final MqttConfiguration? configuration;

  factory MqttClient.fromJson(Map<String, dynamic> json) =>
      _$MqttClientFromJson(json);

  Map<String, dynamic> toJson() => _$MqttClientToJson(this);
}
