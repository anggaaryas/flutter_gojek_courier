import 'package:json_annotation/json_annotation.dart';

part 'courier_exception.g.dart';

@JsonSerializable()
class CourierException {
  const CourierException(
    this.reasonCode,
    this.message,
  );

  final int reasonCode;
  final String? message;

  factory CourierException.fromJson(Map<String, dynamic> json) =>
      _$CourierExceptionFromJson(json);

  Map<String, dynamic> toJson() => _$CourierExceptionToJson(this);
}
