import 'dart:typed_data';

import 'package:gojek_courier/src/model/courier.dart';
import 'package:gojek_courier/src/model/mqtt_connect_option.dart';
import 'package:gojek_courier/src/model/mqtt_event.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'gojek_courier_method_channel.dart';

abstract class GojekCourierPlatform extends PlatformInterface implements GojekCourierBehaviour {
  /// Constructs a GojekCourierPlatform.
  GojekCourierPlatform() : super(token: _token);

  static final Object _token = Object();

  static GojekCourierPlatform _instance = MethodChannelGojekCourier();

  /// The default instance of [GojekCourierPlatform] to use.
  ///
  /// Defaults to [MethodChannelGojekCourier].
  static GojekCourierPlatform get instance => _instance;
  
  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [GojekCourierPlatform] when
  /// they register themselves.
  static set instance(GojekCourierPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }


}

abstract class GojekCourierBehaviour{
  Future<String?> getPlatformVersion();
  Stream get receiveDataStream;

  Future<void> initialise({required Courier courier});
  Future<void> connect({required MqttConnectOption option});
  Future<void> subscribe(String topic, [QoS qoS =  QoS.ZERO]);
  Future<void> unsubscribe(String topic);
  Future<void> disconnect();
  Future<void> send(String topic, String msg, [QoS qoS =  QoS.ZERO]);
  Future<void> sendUint8List(String topic, Uint8List msg, [QoS qoS =  QoS.ZERO]);

}