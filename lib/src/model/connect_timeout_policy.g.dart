// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'connect_timeout_policy.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ConnectTimeoutPolicy _$ConnectTimeoutPolicyFromJson(
        Map<String, dynamic> json) =>
    ConnectTimeoutPolicy(
      sslHandshakeTimeOut: json['sslHandshakeTimeOut'] as int?,
      sslUpperBoundConnTimeOut: json['sslUpperBoundConnTimeOut'] as int?,
      upperBoundConnTimeOut: json['upperBoundConnTimeOut'] as int?,
    );

Map<String, dynamic> _$ConnectTimeoutPolicyToJson(
        ConnectTimeoutPolicy instance) =>
    <String, dynamic>{
      'sslHandshakeTimeOut': instance.sslHandshakeTimeOut,
      'sslUpperBoundConnTimeOut': instance.sslUpperBoundConnTimeOut,
      'upperBoundConnTimeOut': instance.upperBoundConnTimeOut,
    };
