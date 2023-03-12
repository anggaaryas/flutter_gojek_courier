import 'package:json_annotation/json_annotation.dart';

part 'connection_info.g.dart';

@JsonSerializable()
class ConnectionInfo {
  const ConnectionInfo({
    required this.clientId,
    required this.username,
    required this.keepaliveSeconds,
    required this.connectTimeout,
    required this.host,
    required this.port,
    required this.scheme,
  });

  final String clientId;
  final String username;
  final String scheme;
  final String host;
  final int port;
  final int keepaliveSeconds;
  final int connectTimeout;

  factory ConnectionInfo.fromJson(Map<String, dynamic> json) =>
      _$ConnectionInfoFromJson(json);

  Map<String, dynamic> toJson() => _$ConnectionInfoToJson(this);
}
