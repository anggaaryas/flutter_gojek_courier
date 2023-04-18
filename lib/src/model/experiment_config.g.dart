// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'experiment_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExperimentConfig _$ExperimentConfigFromJson(Map<String, dynamic> json) =>
    ExperimentConfig(
      isPersistentSubscriptionStoreEnabled:
          json['isPersistentSubscriptionStoreEnabled'] as bool,
      adaptiveKeepAliveConfig: AdaptiveKeepAliveConfig.fromJson(
          json['adaptiveKeepAliveConfig'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ExperimentConfigToJson(ExperimentConfig instance) =>
    <String, dynamic>{
      'isPersistentSubscriptionStoreEnabled':
          instance.isPersistentSubscriptionStoreEnabled,
      'adaptiveKeepAliveConfig': instance.adaptiveKeepAliveConfig?.toJson(),
    };
