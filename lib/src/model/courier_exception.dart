import 'package:json_annotation/json_annotation.dart';

part 'courier_exception.g.dart';

@JsonSerializable()
class CourierException{
  final int reasonCode;
  final String? message;

  CourierException(this.reasonCode, this.message);

  factory CourierException.fromJson(Map<String, dynamic> json) => _$CourierExceptionFromJson(json);

  Map<String, dynamic> toJson() => _$CourierExceptionToJson(this);
}