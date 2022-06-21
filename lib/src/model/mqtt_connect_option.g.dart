// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mqtt_connect_option.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MqttConnectOption _$MqttConnectOptionFromJson(Map<String, dynamic> json) =>
    MqttConnectOption(
      serverUris: (json['serverUris'] as List<dynamic>)
          .map((e) => ServerUri.fromJson(e as Map<String, dynamic>))
          .toList(),
      keepAlive: KeepAlive.fromJson(json['keepAlive'] as Map<String, dynamic>),
      clientId: json['clientId'] as String,
      username: json['username'] as String,
      password: json['password'] as String,
      version: $enumDecodeNullable(_$MqttVersionEnumMap, json['version']) ??
          MqttVersion.VERSION_3_1_1,
      isCleanSession: json['isCleanSession'] as bool,
      readTimeoutSecs: json['readTimeoutSecs'] as int? ?? -1,
      userPropertiesMap:
          (json['userPropertiesMap'] as Map<String, dynamic>?)?.map(
                (k, e) => MapEntry(k, e as String),
              ) ??
              const {},
    );

Map<String, dynamic> _$MqttConnectOptionToJson(MqttConnectOption instance) =>
    <String, dynamic>{
      'serverUris': instance.serverUris.map((e) => e.toJson()).toList(),
      'keepAlive': instance.keepAlive.toJson(),
      'clientId': instance.clientId,
      'username': instance.username,
      'password': instance.password,
      'isCleanSession': instance.isCleanSession,
      'readTimeoutSecs': instance.readTimeoutSecs,
      'version': _$MqttVersionEnumMap[instance.version],
      'userPropertiesMap': instance.userPropertiesMap,
    };

const _$MqttVersionEnumMap = {
  MqttVersion.VERSION_3_1: 'MQIsdp',
  MqttVersion.VERSION_3_1_1: 'MQTT',
};
