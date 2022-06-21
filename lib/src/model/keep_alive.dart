import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'keep_alive.g.dart';

@JsonSerializable()
class KeepAlive{
  final int timeSeconds;

  @protected
  final bool isOptimal;

  KeepAlive({required this.timeSeconds, this.isOptimal = false});

  factory KeepAlive.fromJson(Map<String, dynamic> json) => _$KeepAliveFromJson(json);

  Map<String, dynamic> toJson() => _$KeepAliveToJson(this);
}