import 'package:gojek_courier/src/model/mqtt_configuration.dart';
import 'package:json_annotation/json_annotation.dart';

part 'mqtt_client.g.dart';

@JsonSerializable()
class MqttClient{
  final MqttConfiguration? configuration;

  MqttClient({this.configuration});

  factory MqttClient.fromJson(Map<String, dynamic> json) => _$MqttClientFromJson(json);

  Map<String, dynamic> toJson() => _$MqttClientToJson(this);
}