// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'keep_alive.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

KeepAlive _$KeepAliveFromJson(Map<String, dynamic> json) => KeepAlive(
      timeSeconds: json['timeSeconds'] as int,
      isOptimal: json['isOptimal'] as bool? ?? false,
    );

Map<String, dynamic> _$KeepAliveToJson(KeepAlive instance) => <String, dynamic>{
      'timeSeconds': instance.timeSeconds,
      'isOptimal': instance.isOptimal,
    };
