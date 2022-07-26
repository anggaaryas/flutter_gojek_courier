
import 'package:gojek_courier/gojek_courier.dart';
import 'package:json_annotation/json_annotation.dart';


part 'mqtt_connect_option.g.dart';

@JsonSerializable()
class MqttConnectOption{
  final ServerUri serverUri;
  final KeepAlive keepAlive;
  final String clientId;
  final String username;
  final String password;
  final bool isCleanSession;
  final int readTimeoutSecs;
  final MqttVersion version;
  final Map<String, String> userPropertiesMap;

  MqttConnectOption({
      required this.serverUri,
      required this.keepAlive,
      required this.clientId,
      required this.username,
      required this.password,
      this.version =  MqttVersion.VERSION_3_1_1,
      required this.isCleanSession,
      this.readTimeoutSecs = -1,
      this.userPropertiesMap = const {}});

  factory MqttConnectOption.fromJson(Map<String, dynamic> json) => _$MqttConnectOptionFromJson(json);

  Map<String, dynamic> toJson() => _$MqttConnectOptionToJson(this);
}

enum MqttVersion{
  @JsonValue("MQIsdp")
  VERSION_3_1("MQIsdp", 3),
  @JsonValue("MQTT")
  VERSION_3_1_1("MQTT", 4);


  const MqttVersion(this.protocolName, this.protocolLevel);

  final String protocolName;
  final int protocolLevel;
}

/*
enum MqttVersion(internal val protocolName: String, internal val protocolLevel: Int) {
VERSION_3_1("MQIsdp", 3), VERSION_3_1_1("MQTT", 4)
}
*/
