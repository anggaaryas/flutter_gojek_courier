import 'package:gojek_courier/src/model/logger.dart';
import 'package:gojek_courier/src/model/mqtt_client.dart';
import 'package:json_annotation/json_annotation.dart';

part 'courier_configuration.g.dart';

@JsonSerializable()
class CourierConfiguration {
  const CourierConfiguration({
    required this.client,
    this.logger,
  });

  final MqttClient client;

  @JsonKey(includeFromJson: false, includeToJson: false)
  final ILogger? logger;

  factory CourierConfiguration.fromJson(Map<String, dynamic> json) =>
      _$CourierConfigurationFromJson(json);

  Map<String, dynamic> toJson() => _$CourierConfigurationToJson(this);
}
