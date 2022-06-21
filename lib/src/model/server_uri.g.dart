// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'server_uri.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ServerUri _$ServerUriFromJson(Map<String, dynamic> json) => ServerUri(
      host: json['host'] as String,
      port: json['port'] as int,
      scheme: json['scheme'] as String? ?? "ssl",
    );

Map<String, dynamic> _$ServerUriToJson(ServerUri instance) => <String, dynamic>{
      'host': instance.host,
      'port': instance.port,
      'scheme': instance.scheme,
    };
