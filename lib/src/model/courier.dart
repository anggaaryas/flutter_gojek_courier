import 'package:gojek_courier/src/model/courier_configuration.dart';
import 'package:json_annotation/json_annotation.dart';

part 'courier.g.dart';

@JsonSerializable()
class Courier{
  final CourierConfiguration configuration;

  Courier({required this.configuration});

  factory Courier.fromJson(Map<String, dynamic> json) => _$CourierFromJson(json);

  Map<String, dynamic> toJson() => _$CourierToJson(this);
}