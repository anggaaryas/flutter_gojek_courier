import 'package:json_annotation/json_annotation.dart';

part 'connect_timeout_policy.g.dart';

@JsonSerializable()
class ConnectTimeoutPolicy{
  final int? sslHandshakeTimeOut;
  final int? sslUpperBoundConnTimeOut;
  final int? upperBoundConnTimeOut;

  ConnectTimeoutPolicy({this.sslHandshakeTimeOut, this.sslUpperBoundConnTimeOut,
      this.upperBoundConnTimeOut});

  factory ConnectTimeoutPolicy.fromJson(Map<String, dynamic> json) => _$ConnectTimeoutPolicyFromJson(json);

  Map<String, dynamic> toJson() => _$ConnectTimeoutPolicyToJson(this);
}