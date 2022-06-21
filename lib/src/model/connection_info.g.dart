// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'connection_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ConnectionInfo _$ConnectionInfoFromJson(Map<String, dynamic> json) =>
    ConnectionInfo(
      clientId: json['clientId'] as String,
      username: json['username'] as String,
      keepaliveSeconds: json['keepaliveSeconds'] as int,
      connectTimeout: json['connectTimeout'] as int,
      host: json['host'] as String,
      port: json['port'] as int,
      scheme: json['scheme'] as String,
    );

Map<String, dynamic> _$ConnectionInfoToJson(ConnectionInfo instance) =>
    <String, dynamic>{
      'clientId': instance.clientId,
      'username': instance.username,
      'keepaliveSeconds': instance.keepaliveSeconds,
      'connectTimeout': instance.connectTimeout,
      'host': instance.host,
      'port': instance.port,
      'scheme': instance.scheme,
    };
