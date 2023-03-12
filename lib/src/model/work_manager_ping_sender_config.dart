import 'package:json_annotation/json_annotation.dart';

part 'work_manager_ping_sender_config.g.dart';

@JsonSerializable()
class WorkManagerPingSenderConfig {
  const WorkManagerPingSenderConfig({
    required this.timeoutSeconds,
  });

  final int timeoutSeconds;

  factory WorkManagerPingSenderConfig.fromJson(Map<String, dynamic> json) =>
      _$WorkManagerPingSenderConfigFromJson(json);

  Map<String, dynamic> toJson() => _$WorkManagerPingSenderConfigToJson(this);
}
