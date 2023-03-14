import 'adaptive_keep_alive_config.dart';
import 'package:json_annotation/json_annotation.dart';

part 'experiment_config.g.dart';

@JsonSerializable()
class ExperimentConfig {
  const ExperimentConfig({
    required this.isPersistentSubscriptionStoreEnabled,
    required this.adaptiveKeepAliveConfig,
  });

  final bool isPersistentSubscriptionStoreEnabled;
  final AdaptiveKeepAliveConfig adaptiveKeepAliveConfig;

  factory ExperimentConfig.fromJson(Map<String, dynamic> json) =>
      _$ExperimentConfigFromJson(json);

  Map<String, dynamic> toJson() => _$ExperimentConfigToJson(this);
}
