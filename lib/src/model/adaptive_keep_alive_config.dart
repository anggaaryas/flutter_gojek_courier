import 'package:gojek_courier/src/model/work_manager_ping_sender_config.dart';

import 'package:json_annotation/json_annotation.dart';

part 'adaptive_keep_alive_config.g.dart';

@JsonSerializable()
class AdaptiveKeepAliveConfig{
  final int lowerBoundMinutes;
  final int upperBoundMinutes;
  final int stepMinutes;
  final int optimalKeepAliveResetLimit;
  final WorkManagerPingSenderConfig pingSender;
  final int activityCheckIntervalSeconds;
  final int inactivityTimeoutSeconds;
  final int policyResetTimeSeconds;
  final int incomingMessagesTTLSecs;
  final int incomingMessagesCleanupIntervalSecs;

  AdaptiveKeepAliveConfig({
      required this.lowerBoundMinutes,
      required this.upperBoundMinutes,
      required this.stepMinutes,
      required this.optimalKeepAliveResetLimit,
      required this.pingSender,
      required this.activityCheckIntervalSeconds,
      required this.inactivityTimeoutSeconds,
      required this.policyResetTimeSeconds,
      required this.incomingMessagesTTLSecs,
      required this.incomingMessagesCleanupIntervalSecs});

  factory AdaptiveKeepAliveConfig.fromJson(Map<String, dynamic> json) => _$AdaptiveKeepAliveConfigFromJson(json);

  Map<String, dynamic> toJson() => _$AdaptiveKeepAliveConfigToJson(this);
}