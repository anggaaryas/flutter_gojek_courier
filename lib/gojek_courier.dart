
export 'package:gojek_courier/src/model/courier.dart';
export 'package:gojek_courier/src/model/active_net_info.dart';
export 'package:gojek_courier/src/model/adaptive_keep_alive_config.dart';
export 'package:gojek_courier/src/model/auth_failure_handler.dart';
export 'package:gojek_courier/src/model/connect_retry_time_policy.dart';
export 'package:gojek_courier/src/model/connect_timeout_policy.dart';
export 'package:gojek_courier/src/model/connection_info.dart';
export 'package:gojek_courier/src/model/courier_configuration.dart';
export 'package:gojek_courier/src/model/event_handler.dart';
export 'package:gojek_courier/src/model/experiment_config.dart';
export 'package:gojek_courier/src/model/logger.dart';
export 'package:gojek_courier/src/model/mqtt_client.dart';
export 'package:gojek_courier/src/model/mqtt_configuration.dart';
export 'package:gojek_courier/src/model/mqtt_event.dart';
export 'package:gojek_courier/src/model/mqtt_interceptor.dart';
export 'package:gojek_courier/src/model/server_uri.dart';
export 'package:gojek_courier/src/model/work_manager_ping_sender_config.dart';
export 'package:gojek_courier/src/model/mqtt_connect_option.dart';
export 'package:gojek_courier/src/model/keep_alive.dart';


import 'dart:async';
import 'dart:typed_data';

import 'gojek_courier.dart';
import 'src/gojek_courier_platform_interface.dart';

class GojekCourier implements GojekCourierBehaviour{

  Future<String?> getPlatformVersion() {
    return GojekCourierPlatform.instance.getPlatformVersion();
  }

  @override
  Future<void> connect({required MqttConnectOption option}) {
    return GojekCourierPlatform.instance.connect(option: option);
  }

  @override
  Future<void> initialise({required Courier courier}) {
    return GojekCourierPlatform.instance.initialise(courier: courier);
  }

  @override
  Stream get receiveDataStream => GojekCourierPlatform.instance.receiveDataStream;

  @override
  Future<void> subscribe(String topic, [QoS qoS =  QoS.ZERO]) {
    return GojekCourierPlatform.instance.subscribe(topic, qoS);
  }

  @override
  Future<void> unsubscribe(String topic) {
    return GojekCourierPlatform.instance.unsubscribe(topic);
  }

  @override
  Future<void> disconnect() {
    return GojekCourierPlatform.instance.disconnect();
  }

  @override
  Future<void> send(String topic, String msg, [QoS qoS =  QoS.ZERO]) {
    return GojekCourierPlatform.instance.send(topic, msg, qoS);
  }

  @override
  Future<void> sendUint8List(String topic, Uint8List msg, [QoS qoS = QoS.ZERO]) {
    return GojekCourierPlatform.instance.sendUint8List(topic, msg, qoS);
  }
}

// Logger, ios unavailable
// authfail, ios unavailable
// some event is different between android and ios