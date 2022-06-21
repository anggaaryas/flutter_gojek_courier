import 'package:gojek_courier/src/model/logger.dart';
import 'package:gojek_courier/src/model/mqtt_client.dart';
import 'package:json_annotation/json_annotation.dart';

part 'courier_configuration.g.dart';

@JsonSerializable()
class CourierConfiguration{
  final MqttClient client;
  @JsonKey(ignore: true)
  final ILogger? logger;

  CourierConfiguration({required this.client, this.logger});

  factory CourierConfiguration.fromJson(Map<String, dynamic> json) => _$CourierConfigurationFromJson(json);

  Map<String, dynamic> toJson() => _$CourierConfigurationToJson(this);
}