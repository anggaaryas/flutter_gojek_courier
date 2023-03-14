import 'courier_configuration.dart';
import 'package:json_annotation/json_annotation.dart';

part 'courier.g.dart';

@JsonSerializable()
class Courier {
  const Courier({
    required this.configuration,
  });

  final CourierConfiguration configuration;

  factory Courier.fromJson(Map<String, dynamic> json) =>
      _$CourierFromJson(json);

  Map<String, dynamic> toJson() => _$CourierToJson(this);
}
