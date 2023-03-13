import 'package:json_annotation/json_annotation.dart';

import 'auth_failure_handler.dart';
import 'connect_retry_time_policy.dart';
import 'connect_timeout_policy.dart';
import 'event_handler.dart';
import 'experiment_config.dart';
import 'logger.dart';
import 'subscription_retry_policy.dart';
import 'work_manager_ping_sender_config.dart';

part 'mqtt_configuration.g.dart';

@JsonSerializable()
class MqttConfiguration {
  const MqttConfiguration({
    this.connectRetryTimePolicy,
    this.connectTimeoutPolicy,
    this.subscriptionRetryPolicy,
    this.unsubscriptionRetryPolicy,
    this.wakeLockTimeout,
    this.pingSender,
    this.authFailureHandler,
    this.logger,
    this.eventHandler,
    this.useInterceptor = false,
    this.experimentConfig,
  });

  final ConnectRetryTimePolicy? connectRetryTimePolicy;
  final ConnectTimeoutPolicy? connectTimeoutPolicy;
  final SubscriptionRetryPolicy? subscriptionRetryPolicy;
  final SubscriptionRetryPolicy? unsubscriptionRetryPolicy;
  final int? wakeLockTimeout;
  final WorkManagerPingSenderConfig? pingSender;
  final bool useInterceptor;
  final ExperimentConfig? experimentConfig;

  @JsonKey(includeFromJson: false, includeToJson: false)
  final AuthFailureHandler? authFailureHandler;

  @JsonKey(includeFromJson: false, includeToJson: false)
  final ILogger? logger;

  @JsonKey(includeFromJson: false, includeToJson: false)
  final EventHandler? eventHandler;

  factory MqttConfiguration.fromJson(Map<String, dynamic> json) =>
      _$MqttConfigurationFromJson(json);

  Map<String, dynamic> toJson() => _$MqttConfigurationToJson(this);
}
