import 'package:json_annotation/json_annotation.dart';

part 'connect_retry_time_policy.g.dart';

@JsonSerializable()
class ConnectRetryTimePolicy {
  const ConnectRetryTimePolicy({
    this.maxRetryCount,
    this.reconnectTimeFixed,
    this.reconnectTimeRandom,
    this.maxReconnectTime,
  });

  final int? maxRetryCount;
  final int? reconnectTimeFixed;
  final int? reconnectTimeRandom;
  final int? maxReconnectTime;

  factory ConnectRetryTimePolicy.fromJson(Map<String, dynamic> json) =>
      _$ConnectRetryTimePolicyFromJson(json);

  Map<String, dynamic> toJson() => _$ConnectRetryTimePolicyToJson(this);
}
