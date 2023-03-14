// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'adaptive_keep_alive_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AdaptiveKeepAliveConfig _$AdaptiveKeepAliveConfigFromJson(
        Map<String, dynamic> json) =>
    AdaptiveKeepAliveConfig(
      lowerBoundMinutes: json['lowerBoundMinutes'] as int,
      upperBoundMinutes: json['upperBoundMinutes'] as int,
      stepMinutes: json['stepMinutes'] as int,
      optimalKeepAliveResetLimit: json['optimalKeepAliveResetLimit'] as int,
      pingSender: WorkManagerPingSenderConfig.fromJson(
          json['pingSender'] as Map<String, dynamic>),
      activityCheckIntervalSeconds: json['activityCheckIntervalSeconds'] as int,
      inactivityTimeoutSeconds: json['inactivityTimeoutSeconds'] as int,
      policyResetTimeSeconds: json['policyResetTimeSeconds'] as int,
      incomingMessagesTTLSecs: json['incomingMessagesTTLSecs'] as int,
      incomingMessagesCleanupIntervalSecs:
          json['incomingMessagesCleanupIntervalSecs'] as int,
    );

Map<String, dynamic> _$AdaptiveKeepAliveConfigToJson(
        AdaptiveKeepAliveConfig instance) =>
    <String, dynamic>{
      'lowerBoundMinutes': instance.lowerBoundMinutes,
      'upperBoundMinutes': instance.upperBoundMinutes,
      'stepMinutes': instance.stepMinutes,
      'optimalKeepAliveResetLimit': instance.optimalKeepAliveResetLimit,
      'activityCheckIntervalSeconds': instance.activityCheckIntervalSeconds,
      'inactivityTimeoutSeconds': instance.inactivityTimeoutSeconds,
      'policyResetTimeSeconds': instance.policyResetTimeSeconds,
      'incomingMessagesTTLSecs': instance.incomingMessagesTTLSecs,
      'incomingMessagesCleanupIntervalSecs':
          instance.incomingMessagesCleanupIntervalSecs,
      'pingSender': instance.pingSender.toJson(),
    };
