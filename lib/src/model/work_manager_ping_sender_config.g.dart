// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'work_manager_ping_sender_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WorkManagerPingSenderConfig _$WorkManagerPingSenderConfigFromJson(
        Map<String, dynamic> json) =>
    WorkManagerPingSenderConfig(
      timeoutSeconds: json['timeoutSeconds'] as int,
    );

Map<String, dynamic> _$WorkManagerPingSenderConfigToJson(
        WorkManagerPingSenderConfig instance) =>
    <String, dynamic>{
      'timeoutSeconds': instance.timeoutSeconds,
    };
