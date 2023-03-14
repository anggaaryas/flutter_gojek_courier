import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'keep_alive.g.dart';

@JsonSerializable()
class KeepAlive {
  const KeepAlive({
    required this.timeSeconds,
    this.isOptimal = false,
  });

  final int timeSeconds;

  @protected
  final bool isOptimal;

  factory KeepAlive.fromJson(Map<String, dynamic> json) =>
      _$KeepAliveFromJson(json);

  Map<String, dynamic> toJson() => _$KeepAliveToJson(this);
}
