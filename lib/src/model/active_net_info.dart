import 'package:json_annotation/json_annotation.dart';

part 'active_net_info.g.dart';

@JsonSerializable()
class ActiveNetInfo {
  ActiveNetInfo({
    required this.connected,
    required this.validated,
    required this.networkType,
  });

  final bool connected;
  final bool validated;
  final int networkType;

  factory ActiveNetInfo.fromJson(Map<String, dynamic> json) =>
      _$ActiveNetInfoFromJson(json);

  Map<String, dynamic> toJson() => _$ActiveNetInfoToJson(this);
}
