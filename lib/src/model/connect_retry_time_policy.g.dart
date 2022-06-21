// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'connect_retry_time_policy.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ConnectRetryTimePolicy _$ConnectRetryTimePolicyFromJson(
        Map<String, dynamic> json) =>
    ConnectRetryTimePolicy(
      maxRetryCount: json['maxRetryCount'] as int?,
      reconnectTimeFixed: json['reconnectTimeFixed'] as int?,
      reconnectTimeRandom: json['reconnectTimeRandom'] as int?,
      maxReconnectTime: json['maxReconnectTime'] as int?,
    );

Map<String, dynamic> _$ConnectRetryTimePolicyToJson(
        ConnectRetryTimePolicy instance) =>
    <String, dynamic>{
      'maxRetryCount': instance.maxRetryCount,
      'reconnectTimeFixed': instance.reconnectTimeFixed,
      'reconnectTimeRandom': instance.reconnectTimeRandom,
      'maxReconnectTime': instance.maxReconnectTime,
    };
