// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'courier_configuration.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CourierConfiguration _$CourierConfigurationFromJson(
        Map<String, dynamic> json) =>
    CourierConfiguration(
      client: MqttClient.fromJson(json['client'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CourierConfigurationToJson(
        CourierConfiguration instance) =>
    <String, dynamic>{
      'client': instance.client.toJson(),
    };
