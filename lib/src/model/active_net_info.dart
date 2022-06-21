import 'package:json_annotation/json_annotation.dart';

part 'active_net_info.g.dart';

@JsonSerializable()
class ActiveNetInfo {
  final bool connected;
  final bool validated;
  final int networkType;

  ActiveNetInfo(
      {required this.connected,
      required this.validated,
      required this.networkType});

  factory ActiveNetInfo.fromJson(Map<String, dynamic> json) => _$ActiveNetInfoFromJson(json);

  Map<String, dynamic> toJson() => _$ActiveNetInfoToJson(this);
}
