import 'package:json_annotation/json_annotation.dart';

part 'server_uri.g.dart';

@JsonSerializable()
class ServerUri {
  const ServerUri({
    required this.host,
    required this.port,
    this.scheme = "ssl",
  });

  final String host;
  final int port;
  final String scheme;

  @override
  String toString() => "$scheme://$host:$port";

  factory ServerUri.fromJson(Map<String, dynamic> json) =>
      _$ServerUriFromJson(json);

  Map<String, dynamic> toJson() => _$ServerUriToJson(this);
}
