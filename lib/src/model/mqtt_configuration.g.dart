// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mqtt_configuration.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MqttConfiguration _$MqttConfigurationFromJson(Map<String, dynamic> json) =>
    MqttConfiguration(
      connectRetryTimePolicy: json['connectRetryTimePolicy'] == null
          ? null
          : ConnectRetryTimePolicy.fromJson(
              json['connectRetryTimePolicy'] as Map<String, dynamic>),
      connectTimeoutPolicy: json['connectTimeoutPolicy'] == null
          ? null
          : ConnectTimeoutPolicy.fromJson(
              json['connectTimeoutPolicy'] as Map<String, dynamic>),
      subscriptionRetryPolicy: json['subscriptionRetryPolicy'] == null
          ? null
          : SubscriptionRetryPolicy.fromJson(
              json['subscriptionRetryPolicy'] as Map<String, dynamic>),
      unsubscriptionRetryPolicy: json['unsubscriptionRetryPolicy'] == null
          ? null
          : SubscriptionRetryPolicy.fromJson(
              json['unsubscriptionRetryPolicy'] as Map<String, dynamic>),
      wakeLockTimeout: json['wakeLockTimeout'] as int?,
      pingSender: json['pingSender'] == null
          ? null
          : WorkManagerPingSenderConfig.fromJson(
              json['pingSender'] as Map<String, dynamic>),
      useInterceptor: json['useInterceptor'] as bool? ?? false,
      experimentConfig: json['experimentConfig'] == null
          ? null
          : ExperimentConfig.fromJson(
              json['experimentConfig'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$MqttConfigurationToJson(MqttConfiguration instance) =>
    <String, dynamic>{
      'connectRetryTimePolicy': instance.connectRetryTimePolicy?.toJson(),
      'connectTimeoutPolicy': instance.connectTimeoutPolicy?.toJson(),
      'subscriptionRetryPolicy': instance.subscriptionRetryPolicy?.toJson(),
      'unsubscriptionRetryPolicy': instance.unsubscriptionRetryPolicy?.toJson(),
      'wakeLockTimeout': instance.wakeLockTimeout,
      'pingSender': instance.pingSender?.toJson(),
      'useInterceptor': instance.useInterceptor,
      'experimentConfig': instance.experimentConfig?.toJson(),
    };
