// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'active_net_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ActiveNetInfo _$ActiveNetInfoFromJson(Map<String, dynamic> json) =>
    ActiveNetInfo(
      connected: json['connected'] as bool,
      validated: json['validated'] as bool,
      networkType: json['networkType'] as int,
    );

Map<String, dynamic> _$ActiveNetInfoToJson(ActiveNetInfo instance) =>
    <String, dynamic>{
      'connected': instance.connected,
      'validated': instance.validated,
      'networkType': instance.networkType,
    };
