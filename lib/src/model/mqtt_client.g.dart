// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mqtt_client.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MqttClient _$MqttClientFromJson(Map<String, dynamic> json) => MqttClient(
      configuration: json['configuration'] == null
          ? null
          : MqttConfiguration.fromJson(
              json['configuration'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$MqttClientToJson(MqttClient instance) =>
    <String, dynamic>{
      'configuration': instance.configuration?.toJson(),
    };
