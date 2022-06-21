// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'courier_exception.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CourierException _$CourierExceptionFromJson(Map<String, dynamic> json) =>
    CourierException(
      json['reasonCode'] as int,
      json['message'] as String?,
    );

Map<String, dynamic> _$CourierExceptionToJson(CourierException instance) =>
    <String, dynamic>{
      'reasonCode': instance.reasonCode,
      'message': instance.message,
    };
