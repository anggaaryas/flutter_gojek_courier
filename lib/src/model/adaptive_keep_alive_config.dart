import 'package:json_annotation/json_annotation.dart';

import 'work_manager_ping_sender_config.dart';

part 'adaptive_keep_alive_config.g.dart';

@JsonSerializable()
class AdaptiveKeepAliveConfig {
  const AdaptiveKeepAliveConfig({
    required this.lowerBoundMinutes,
    required this.upperBoundMinutes,
    required this.stepMinutes,
    required this.optimalKeepAliveResetLimit,
    required this.pingSender,
    required this.activityCheckIntervalSeconds,
    required this.inactivityTimeoutSeconds,
    required this.policyResetTimeSeconds,
    required this.incomingMessagesTTLSecs,
    required this.incomingMessagesCleanupIntervalSecs,
  });

  final int lowerBoundMinutes;
  final int upperBoundMinutes;
  final int stepMinutes;
  final int optimalKeepAliveResetLimit;
  final int activityCheckIntervalSeconds;
  final int inactivityTimeoutSeconds;
  final int policyResetTimeSeconds;
  final int incomingMessagesTTLSecs;
  final int incomingMessagesCleanupIntervalSecs;
  final WorkManagerPingSenderConfig pingSender;

  factory AdaptiveKeepAliveConfig.fromJson(Map<String, dynamic> json) =>
      _$AdaptiveKeepAliveConfigFromJson(json);

  Map<String, dynamic> toJson() => _$AdaptiveKeepAliveConfigToJson(this);
}
