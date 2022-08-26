import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../gojek_courier.dart';
import 'gojek_courier_platform_interface.dart';
import 'model/courier.dart';
import 'model/mqtt_connect_option.dart';

class MethodChannelGojekCourier extends GojekCourierPlatform {
  StreamSubscription? _loggerStreamSubscription;
  StreamSubscription? _eventStreamSubscription;
  StreamSubscription? _authFailStreamSubscription;
  StreamSubscription? _dataSubscription;

  late Stream dataStream;

  Courier? _courier;
  MqttConnectOption? _mqttConnectOption;

  @visibleForTesting
  final methodChannel = const MethodChannel('gojek_courier');

  final receiveDataChannel = const EventChannel('receive_data_channel');

  final loggerChannel = const EventChannel('logger_channel');

  final eventChannel = const EventChannel('event_channel');

  final authFailChannel = const EventChannel('auth_fail_channel');

  MethodChannelGojekCourier(){
    streamLogger();

    streamEvent();

    streamAuthFail();

    streamData();
  }

  @override
  Future<String?> getPlatformVersion() async {
    final version =
    await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  void streamData(){
    dataStream = receiveDataChannel.receiveBroadcastStream();
    _dataSubscription = dataStream.listen((event) { });
  }

  @override
  Stream get receiveDataStream {
    return dataStream;
  }

  @override
  Future<void> connect({required MqttConnectOption option}) async {
    await methodChannel.invokeMethod<String>('connect', option.toJson());
  }

  @override
  Future<void> initialise({required Courier courier}) async {
    if (_courier == null) {
      _courier = courier;

      if(Platform.isIOS){
        _courier?.configuration.logger?.i("Library", "Logger is not supported in Ios");
        if(courier.configuration.client.configuration?.useInterceptor ?? false){
          _courier?.configuration.logger?.i("Library", "interceptor is not supported in Ios");
        }
      }

      await methodChannel.invokeMethod<String>('initialise', courier.toJson());
    } else {
      throw ('courier already init...!');
    }
  }

  void streamAuthFail() {
    _authFailStreamSubscription = authFailStream.listen((event) {
      print(event);
      _courier?.configuration.client.configuration?.authFailureHandler
          ?.handleAuthFailure
          ?.call();
    });
  }

  void streamLogger() {

    _loggerStreamSubscription = loggerStream.listen((event) {
      var decode = jsonDecode(event);
      var type = decode["type"];
      var topic = decode["topic"];
      var msg = decode["data"];

      if (type == "debug") {
        _courier?.configuration.logger?.d(topic, msg);
      } else if (type == "info") {
        _courier?.configuration.logger?.i(topic, msg);
      } else if (type == "warning") {
        _courier?.configuration.logger?.w(topic, msg: msg);
      } else if (type == "error") {
        _courier?.configuration.logger?.e(topic, msg);
      } else if (type == "verbose") {
        _courier?.configuration.logger?.v(topic, msg);
      }
    });
  }

  void streamEvent() {
    _eventStreamSubscription = eventStream.listen((event) {
      // print("event...");
      // print(event);
      if(Platform.isIOS){
        event = (event as String).replaceAll('\\', '\\\\');
      }
      var json = jsonDecode(event);
      final topic = (json["topic"] as String).split("\$")[1];
      final data = json["data"];

      if(data["connectionInfo"] is String){
        data["connectionInfo"] = null;
      }

      print("=== $topic  ===");

      switch (topic) {
        case "MqttConnectAttemptEvent":
          {
            _courier
                ?.configuration.client.configuration?.eventHandler?.onEvent
                ?.call(MqttConnectAttemptEvent.fromJson(data));
          }
          break;
        case "MqttConnectDiscardedEvent":
          {
            _courier
                ?.configuration.client.configuration?.eventHandler?.onEvent
                ?.call(MqttConnectDiscardedEvent.fromJson(data));
          }
          break;
        case "MqttConnectSuccessEvent":
          {
            _courier
                ?.configuration.client.configuration?.eventHandler?.onEvent
                ?.call(MqttConnectSuccessEvent.fromJson(data));
          }
          break;
        case "MqttConnectFailureEvent":
          {
            _courier
                ?.configuration.client.configuration?.eventHandler?.onEvent
                ?.call(MqttConnectFailureEvent.fromJson(data));
          }
          break;
        case "MqttConnectionLostEvent":
          {
            _courier
                ?.configuration.client.configuration?.eventHandler?.onEvent
                ?.call(MqttConnectionLostEvent.fromJson(data));
          }
          break;
        case "SocketConnectAttemptEvent":
          {
            _courier
                ?.configuration.client.configuration?.eventHandler?.onEvent
                ?.call(SocketConnectAttemptEvent.fromJson(data));
          }
          break;
        case "SocketConnectSuccessEvent":
          {
            _courier
                ?.configuration.client.configuration?.eventHandler?.onEvent
                ?.call(SocketConnectSuccessEvent.fromJson(data));
          }
          break;
        case "SocketConnectFailureEvent":
          {
            _courier
                ?.configuration.client.configuration?.eventHandler?.onEvent
                ?.call(SocketConnectFailureEvent.fromJson(data));
          }
          break;
        case "SSLSocketAttemptEvent":
          {
            _courier
                ?.configuration.client.configuration?.eventHandler?.onEvent
                ?.call(SSLSocketAttemptEvent.fromJson(data));
          }
          break;
        case "SSLSocketSuccessEvent":
          {
            _courier
                ?.configuration.client.configuration?.eventHandler?.onEvent
                ?.call(SSLSocketSuccessEvent.fromJson(data));
          }
          break;
        case "SSLSocketFailureEvent":
          {
            _courier
                ?.configuration.client.configuration?.eventHandler?.onEvent
                ?.call(SSLSocketFailureEvent.fromJson(data));
          }
          break;
        case "SSLHandshakeSuccessEvent":
          {
            _courier
                ?.configuration.client.configuration?.eventHandler?.onEvent
                ?.call(SSLHandshakeSuccessEvent.fromJson(data));
          }
          break;
        case "ConnectPacketSendEvent":
          {
            _courier
                ?.configuration.client.configuration?.eventHandler?.onEvent
                ?.call(ConnectPacketSendEvent.fromJson(data));
          }
          break;
        case "MqttSubscribeAttemptEvent":
          {
            _courier
                ?.configuration.client.configuration?.eventHandler?.onEvent
                ?.call(MqttSubscribeAttemptEvent.fromJson(data));
          }
          break;
        case "MqttSubscribeSuccessEvent":
          {
            _courier
                ?.configuration.client.configuration?.eventHandler?.onEvent
                ?.call(MqttSubscribeSuccessEvent.fromJson(data));
          }
          break;
        case "MqttSubscribeFailureEvent":
          {
            _courier
                ?.configuration.client.configuration?.eventHandler?.onEvent
                ?.call(MqttSubscribeFailureEvent.fromJson(data));
          }
          break;
        case "MqttUnsubscribeAttemptEvent":
          {
            _courier
                ?.configuration.client.configuration?.eventHandler?.onEvent
                ?.call(MqttUnsubscribeAttemptEvent.fromJson(data));
          }
          break;
        case "MqttUnsubscribeSuccessEvent":
          {
            _courier
                ?.configuration.client.configuration?.eventHandler?.onEvent
                ?.call(MqttUnsubscribeSuccessEvent.fromJson(data));
          }
          break;
        case "MqttUnsubscribeFailureEvent":
          {
            _courier
                ?.configuration.client.configuration?.eventHandler?.onEvent
                ?.call(MqttUnsubscribeFailureEvent.fromJson(data));
          }
          break;
        case "MqttMessageReceiveEvent":
          {
            _courier
                ?.configuration.client.configuration?.eventHandler?.onEvent
                ?.call(MqttMessageReceiveEvent.fromJson(data));
          }
          break;
        case "MqttMessageReceiveErrorEvent":
          {
            _courier
                ?.configuration.client.configuration?.eventHandler?.onEvent
                ?.call(MqttMessageReceiveErrorEvent.fromJson(data));
          }
          break;
        case "MqttMessageSendEvent":
          {
            _courier
                ?.configuration.client.configuration?.eventHandler?.onEvent
                ?.call(MqttMessageSendEvent.fromJson(data));
          }
          break;
        case "MqttMessageSendSuccessEvent":
          {
            _courier
                ?.configuration.client.configuration?.eventHandler?.onEvent
                ?.call(MqttMessageSendSuccessEvent.fromJson(data));
          }
          break;
        case "MqttMessageSendFailureEvent":
          {
            _courier
                ?.configuration.client.configuration?.eventHandler?.onEvent
                ?.call(MqttMessageSendFailureEvent.fromJson(data));
          }
          break;
        case "MqttPingInitiatedEvent":
          {
            _courier
                ?.configuration.client.configuration?.eventHandler?.onEvent
                ?.call(MqttPingInitiatedEvent.fromJson(data));
          }
          break;
        case "MqttPingScheduledEvent":
          {
            _courier
                ?.configuration.client.configuration?.eventHandler?.onEvent
                ?.call(MqttPingScheduledEvent.fromJson(data));
          }
          break;
        case "MqttPingCancelledEvent":
          {
            _courier
                ?.configuration.client.configuration?.eventHandler?.onEvent
                ?.call(MqttPingCancelledEvent.fromJson(data));
          }
          break;
        case "MqttPingSuccessEvent":
          {
            _courier
                ?.configuration.client.configuration?.eventHandler?.onEvent
                ?.call(MqttPingSuccessEvent.fromJson(data));
          }
          break;
        case "MqttPingFailureEvent":
          {
            _courier
                ?.configuration.client.configuration?.eventHandler?.onEvent
                ?.call(MqttPingFailureEvent.fromJson(data));
          }
          break;
        case "MqttPingExceptionEvent":
          {
            _courier
                ?.configuration.client.configuration?.eventHandler?.onEvent
                ?.call(MqttPingExceptionEvent.fromJson(data));
          }
          break;
        case "BackgroundAlarmPingLimitReached":
          {
            _courier
                ?.configuration.client.configuration?.eventHandler?.onEvent
                ?.call(BackgroundAlarmPingLimitReached.fromJson(data));
          }
          break;
        case "OptimalKeepAliveFoundEvent":
          {
            _courier
                ?.configuration.client.configuration?.eventHandler?.onEvent
                ?.call(OptimalKeepAliveFoundEvent.fromJson(data));
          }
          break;
        case "MqttReconnectEvent":
          {
            _courier
                ?.configuration.client.configuration?.eventHandler?.onEvent
                ?.call(MqttReconnectEvent.fromJson(data));
          }
          break;
        case "MqttDisconnectEvent":
          {
            _courier
                ?.configuration.client.configuration?.eventHandler?.onEvent
                ?.call(MqttDisconnectEvent.fromJson(data));
          }
          break;
        case "MqttDisconnectStartEvent":
          {
            _courier
                ?.configuration.client.configuration?.eventHandler?.onEvent
                ?.call(MqttDisconnectStartEvent.fromJson(data));
          }
          break;
        case "MqttDisconnectCompleteEvent":
          {
            _courier
                ?.configuration.client.configuration?.eventHandler?.onEvent
                ?.call(MqttDisconnectCompleteEvent.fromJson(data));
          }
          break;
        case "OfflineMessageDiscardedEvent":
          {
            _courier
                ?.configuration.client.configuration?.eventHandler?.onEvent
                ?.call(OfflineMessageDiscardedEvent.fromJson(data));
          }
          break;
        case "InboundInactivityEvent":
          {
            _courier
                ?.configuration.client.configuration?.eventHandler?.onEvent
                ?.call(InboundInactivityEvent.fromJson(data));
          }
          break;
        case "HandlerThreadNotAliveEvent":
          {
            _courier
                ?.configuration.client.configuration?.eventHandler?.onEvent
                ?.call(HandlerThreadNotAliveEvent.fromJson(data));
          }
          break;
        case "AuthenticatorAttemptEvent":
          {
            _courier
                ?.configuration.client.configuration?.eventHandler?.onEvent
                ?.call(AuthenticatorAttemptEvent.fromJson(data));
          }
          break;
        case "AuthenticatorSuccessEvent":
          {
            _courier
                ?.configuration.client.configuration?.eventHandler?.onEvent
                ?.call(AuthenticatorSuccessEvent.fromJson(data));
          }
          break;
        case "AuthenticatorErrorEvent":
          {
            _courier
                ?.configuration.client.configuration?.eventHandler?.onEvent
                ?.call(AuthenticatorErrorEvent.fromJson(data));
          }
          break;

        case "CourierDisconnect":
          {
            _courier
                ?.configuration.client.configuration?.eventHandler?.onEvent
                ?.call(CourierDisconnectEvent.fromJson(data));
          }
          break;
        case "ConnectionAvailable":
          {
            _courier
                ?.configuration.client.configuration?.eventHandler?.onEvent
                ?.call(ConnectionAvailableEvent());
          }
          break;
        case "ConnectionUnavailable":
          {
            _courier
                ?.configuration.client.configuration?.eventHandler?.onEvent
                ?.call(ConnectionUnavailableEvent());
          }
          break;
      }
    });
  }

  @override
  Future<void> subscribe(String topic, [QoS qoS = QoS.ZERO]) async {
    await methodChannel.invokeMethod<String>(
        'subscribe', {'topic': topic, 'qos': '${qoSEnumMap[qoS]}'});
  }

  @override
  Future<void> unsubscribe(String topic) async {
    await methodChannel.invokeMethod<String>('unsubscribe', {'topic': topic});
  }

  @override
  Future<void> disconnect() async {
    await methodChannel.invokeMethod<String>('disconnect');
  }

  @override
  Future<void> send(String topic, String msg,
      [QoS qoS = QoS.ZERO]) async {
    await methodChannel.invokeMethod<String>(
        'send', {'topic': topic, 'msg': msg, 'qos': '${qoSEnumMap[qoS]}'});
  }

  Stream get loggerStream {
    return loggerChannel.receiveBroadcastStream();
  }

  Stream get eventStream {
    return eventChannel.receiveBroadcastStream();
  }

  Stream get authFailStream {
    return authFailChannel.receiveBroadcastStream();
  }

  @override
  Future<void> sendUint8List(String topic, Uint8List msg, [QoS qoS = QoS.ZERO]) async {
    await methodChannel.invokeMethod<String>(
        'sendByte', {'topic': topic, 'msg': msg, 'qos': '${qoSEnumMap[qoS]}'});
  }
}
