import 'package:gojek_courier/src/model/auth_failure_handler.dart';
import 'package:gojek_courier/src/model/connect_retry_time_policy.dart';
import 'package:gojek_courier/src/model/connect_timeout_policy.dart';
import 'package:gojek_courier/src/model/event_handler.dart';
import 'package:gojek_courier/src/model/experiment_config.dart';
import 'package:gojek_courier/src/model/logger.dart';
import 'package:gojek_courier/src/model/mqtt_interceptor.dart';
import 'package:gojek_courier/src/model/subscription_retry_policy.dart';
import 'package:gojek_courier/src/model/work_manager_ping_sender_config.dart';
import 'package:json_annotation/json_annotation.dart';

part 'mqtt_configuration.g.dart';

@JsonSerializable()
class MqttConfiguration{
  final ConnectRetryTimePolicy? connectRetryTimePolicy;
  final ConnectTimeoutPolicy? connectTimeoutPolicy;
  final SubscriptionRetryPolicy? subscriptionRetryPolicy;
  final SubscriptionRetryPolicy? unsubscriptionRetryPolicy;
  final int? wakeLockTimeout;
  final WorkManagerPingSenderConfig? pingSender;
  @JsonKey(ignore: true)
  final AuthFailureHandler? authFailureHandler;
  @JsonKey(ignore: true)
  final ILogger? logger;
  @JsonKey(ignore: true)
  final EventHandler? eventHandler;
  final bool useInterceptor;
  final ExperimentConfig? experimentConfig;

  MqttConfiguration({
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
      this.experimentConfig});

  factory MqttConfiguration.fromJson(Map<String, dynamic> json) => _$MqttConfigurationFromJson(json);

  Map<String, dynamic> toJson() => _$MqttConfigurationToJson(this);
}