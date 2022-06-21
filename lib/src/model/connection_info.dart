import 'package:json_annotation/json_annotation.dart';

part 'connection_info.g.dart';

@JsonSerializable()
class ConnectionInfo {
  final String clientId;
  final String username;
  final int keepaliveSeconds;
  final int connectTimeout;
  final String host;
  final int port;
  final String scheme;

  ConnectionInfo(
      {required this.clientId,
      required this.username,
      required this.keepaliveSeconds,
      required this.connectTimeout,
      required this.host,
      required this.port,
      required this.scheme});

  factory ConnectionInfo.fromJson(Map<String, dynamic> json) => _$ConnectionInfoFromJson(json);

  Map<String, dynamic> toJson() => _$ConnectionInfoToJson(this);
}
