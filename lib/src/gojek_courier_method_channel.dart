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

  Map<String, Courier> courierList = {};


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
  Future<void> connect({required MqttConnectOption option, required String id}) async {
    await methodChannel.invokeMethod<String>('connect', {
      'id': id,
      'payload': option.toJson()
    });
  }

  @override
  Future<void> initialise({required Courier courier, required String id}) async {
    if (!courierList.containsKey(id)) {
      courierList.addAll({
        id: courier
      });

      if(Platform.isIOS){
        courierList[id]?.configuration.logger?.i("Library", "Logger is not supported in Ios");
        if(courier.configuration.client.configuration?.useInterceptor ?? false){
          courierList[id]?.configuration.logger?.i("Library", "interceptor is not supported in Ios");
        }
      }

      await methodChannel.invokeMethod<String>('initialise', {
        'id': id,
        'payload': courier.toJson()
      });
    } else {
      throw ('courier already init...!');
    }
  }

  void streamAuthFail() {
    _authFailStreamSubscription = authFailStream.listen((event) {
      // _courier?.configuration.client.configuration?.authFailureHandler
      //     ?.handleAuthFailure
      //     ?.call();
    });
  }

  void streamLogger() {

    _loggerStreamSubscription = loggerStream.listen((event) {
      var decode = jsonDecode(event);
      var type = decode["type"];
      var topic = decode["topic"];
      var msg = decode["data"];

      if (type == "debug") {
        courierList.forEach((key, value) {
          value.configuration.logger?.d(topic, msg);
        });
      } else if (type == "info") {
        courierList.forEach((key, value) {
          value.configuration.logger?.i(topic, msg);
        });
      } else if (type == "warning") {
        courierList.forEach((key, value) {
          value.configuration.logger?.w(topic, msg: msg);
        });
      } else if (type == "error") {
        courierList.forEach((key, value) {
          value.configuration.logger?.e(topic, msg);
        });
      } else if (type == "verbose") {
        courierList.forEach((key, value) {
          value.configuration.logger?.v(topic, msg);
        });
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
            courierList.forEach((key, value){value.configuration.client.configuration?.eventHandler?.onEvent
                ?.call(MqttConnectAttemptEvent.fromJson(data));});
          }
          break;
        case "MqttConnectDiscardedEvent":
          {
            courierList.forEach((key, value){value.configuration.client.configuration?.eventHandler?.onEvent
                ?.call(MqttConnectDiscardedEvent.fromJson(data));});

          }
          break;
        case "MqttConnectSuccessEvent":
          {
            courierList.forEach((key, value){value.configuration.client.configuration?.eventHandler?.onEvent
                ?.call(MqttConnectSuccessEvent.fromJson(data));});
          }
          break;
        case "MqttConnectFailureEvent":
          {
            courierList.forEach((key, value){value.configuration.client.configuration?.eventHandler?.onEvent
                ?.call(MqttConnectFailureEvent.fromJson(data));});
          }
          break;
        case "MqttConnectionLostEvent":
          {
            courierList.forEach((key, value){value.configuration.client.configuration?.eventHandler?.onEvent
                ?.call(MqttConnectionLostEvent.fromJson(data));});
          }
          break;
        case "SocketConnectAttemptEvent":
          {
            courierList.forEach((key, value){value.configuration.client.configuration?.eventHandler?.onEvent
                ?.call(SocketConnectAttemptEvent.fromJson(data));});

          }
          break;
        case "SocketConnectSuccessEvent":
          {
            courierList.forEach((key, value){value.configuration.client.configuration?.eventHandler?.onEvent
                ?.call(SocketConnectSuccessEvent.fromJson(data));});
          }
          break;
        case "SocketConnectFailureEvent":
          {
            courierList.forEach((key, value){value.configuration.client.configuration?.eventHandler?.onEvent
                ?.call(SocketConnectFailureEvent.fromJson(data));});
          }
          break;
        case "SSLSocketAttemptEvent":
          {
            courierList.forEach((key, value){value.configuration.client.configuration?.eventHandler?.onEvent
                ?.call(SSLSocketAttemptEvent.fromJson(data));});
          }
          break;
        case "SSLSocketSuccessEvent":
          {
            courierList.forEach((key, value){value.configuration.client.configuration?.eventHandler?.onEvent
                ?.call(SSLSocketSuccessEvent.fromJson(data));});
          }
          break;
        case "SSLSocketFailureEvent":
          {
            courierList.forEach((key, value){value.configuration.client.configuration?.eventHandler?.onEvent
                ?.call(SSLSocketFailureEvent.fromJson(data));});
          }
          break;
        case "SSLHandshakeSuccessEvent":
          {
            courierList.forEach((key, value){value.configuration.client.configuration?.eventHandler?.onEvent
                ?.call(SSLHandshakeSuccessEvent.fromJson(data));});
          }
          break;
        case "ConnectPacketSendEvent":
          {
            courierList.forEach((key, value){value.configuration.client.configuration?.eventHandler?.onEvent
                ?.call(ConnectPacketSendEvent.fromJson(data));});
          }
          break;
        case "MqttSubscribeAttemptEvent":
          {
            courierList.forEach((key, value){value.configuration.client.configuration?.eventHandler?.onEvent
                ?.call(MqttSubscribeAttemptEvent.fromJson(data));});
          }
          break;
        case "MqttSubscribeSuccessEvent":
          {
            courierList.forEach((key, value){value.configuration.client.configuration?.eventHandler?.onEvent
                ?.call(MqttSubscribeSuccessEvent.fromJson(data));});
          }
          break;
        case "MqttSubscribeFailureEvent":
          {
            courierList.forEach((key, value){value.configuration.client.configuration?.eventHandler?.onEvent
                ?.call(MqttSubscribeFailureEvent.fromJson(data));});
          }
          break;
        case "MqttUnsubscribeAttemptEvent":
          {
            courierList.forEach((key, value){value.configuration.client.configuration?.eventHandler?.onEvent
                ?.call(MqttUnsubscribeAttemptEvent.fromJson(data));});
          }
          break;
        case "MqttUnsubscribeSuccessEvent":
          {
            courierList.forEach((key, value){value.configuration.client.configuration?.eventHandler?.onEvent
                ?.call(MqttUnsubscribeSuccessEvent.fromJson(data));});
          }
          break;
        case "MqttUnsubscribeFailureEvent":
          {
            courierList.forEach((key, value){value.configuration.client.configuration?.eventHandler?.onEvent
                ?.call(MqttUnsubscribeFailureEvent.fromJson(data));});
          }
          break;
        case "MqttMessageReceiveEvent":
          {
            courierList.forEach((key, value){value.configuration.client.configuration?.eventHandler?.onEvent
                ?.call(MqttMessageReceiveEvent.fromJson(data));});
          }
          break;
        case "MqttMessageReceiveErrorEvent":
          {
            courierList.forEach((key, value){value.configuration.client.configuration?.eventHandler?.onEvent
                ?.call(MqttMessageReceiveErrorEvent.fromJson(data));});
          }
          break;
        case "MqttMessageSendEvent":
          {
            courierList.forEach((key, value){value.configuration.client.configuration?.eventHandler?.onEvent
                ?.call(MqttMessageSendEvent.fromJson(data));});
          }
          break;
        case "MqttMessageSendSuccessEvent":
          {
            courierList.forEach((key, value){value.configuration.client.configuration?.eventHandler?.onEvent
                ?.call(MqttMessageSendSuccessEvent.fromJson(data));});
          }
          break;
        case "MqttMessageSendFailureEvent":
          {
            courierList.forEach((key, value){value.configuration.client.configuration?.eventHandler?.onEvent
                ?.call(MqttMessageSendFailureEvent.fromJson(data));});
          }
          break;
        case "MqttPingInitiatedEvent":
          {
            courierList.forEach((key, value){value.configuration.client.configuration?.eventHandler?.onEvent
                ?.call(MqttPingInitiatedEvent.fromJson(data));});
          }
          break;
        case "MqttPingScheduledEvent":
          {
            courierList.forEach((key, value){value.configuration.client.configuration?.eventHandler?.onEvent
                ?.call(MqttPingScheduledEvent.fromJson(data));});
          }
          break;
        case "MqttPingCancelledEvent":
          {
            courierList.forEach((key, value){value.configuration.client.configuration?.eventHandler?.onEvent
                ?.call(MqttPingCancelledEvent.fromJson(data));});
          }
          break;
        case "MqttPingSuccessEvent":
          {
            courierList.forEach((key, value){value.configuration.client.configuration?.eventHandler?.onEvent
                ?.call(MqttPingSuccessEvent.fromJson(data));});
          }
          break;
        case "MqttPingFailureEvent":
          {
            courierList.forEach((key, value){value.configuration.client.configuration?.eventHandler?.onEvent
                ?.call(MqttPingFailureEvent.fromJson(data));});
          }
          break;
        case "MqttPingExceptionEvent":
          {
            courierList.forEach((key, value){value.configuration.client.configuration?.eventHandler?.onEvent
                ?.call(MqttPingExceptionEvent.fromJson(data));});
          }
          break;
        case "BackgroundAlarmPingLimitReached":
          {
            courierList.forEach((key, value){value.configuration.client.configuration?.eventHandler?.onEvent
                ?.call(BackgroundAlarmPingLimitReached.fromJson(data));});
          }
          break;
        case "OptimalKeepAliveFoundEvent":
          {
            courierList.forEach((key, value){value.configuration.client.configuration?.eventHandler?.onEvent
                ?.call(OptimalKeepAliveFoundEvent.fromJson(data));});
          }
          break;
        case "MqttReconnectEvent":
          {
            courierList.forEach((key, value){value.configuration.client.configuration?.eventHandler?.onEvent
                ?.call(MqttReconnectEvent.fromJson(data));});
          }
          break;
        case "MqttDisconnectEvent":
          {
            courierList.forEach((key, value){value.configuration.client.configuration?.eventHandler?.onEvent
                ?.call(MqttDisconnectEvent.fromJson(data));});
          }
          break;
        case "MqttDisconnectStartEvent":
          {
            courierList.forEach((key, value){value.configuration.client.configuration?.eventHandler?.onEvent
                ?.call(MqttDisconnectStartEvent.fromJson(data));});
          }
          break;
        case "MqttDisconnectCompleteEvent":
          {
            courierList.forEach((key, value){value.configuration.client.configuration?.eventHandler?.onEvent
                ?.call(MqttDisconnectCompleteEvent.fromJson(data));});
          }
          break;
        case "OfflineMessageDiscardedEvent":
          {
            courierList.forEach((key, value){value.configuration.client.configuration?.eventHandler?.onEvent
                ?.call(OfflineMessageDiscardedEvent.fromJson(data));});
          }
          break;
        case "InboundInactivityEvent":
          {
            courierList.forEach((key, value){value.configuration.client.configuration?.eventHandler?.onEvent
                ?.call(InboundInactivityEvent.fromJson(data));});
          }
          break;
        case "HandlerThreadNotAliveEvent":
          {
            courierList.forEach((key, value){value.configuration.client.configuration?.eventHandler?.onEvent
                ?.call(HandlerThreadNotAliveEvent.fromJson(data));});
          }
          break;
        case "AuthenticatorAttemptEvent":
          {
            courierList.forEach((key, value){value.configuration.client.configuration?.eventHandler?.onEvent
                ?.call(AuthenticatorAttemptEvent.fromJson(data));});
          }
          break;
        case "AuthenticatorSuccessEvent":
          {
            courierList.forEach((key, value){value.configuration.client.configuration?.eventHandler?.onEvent
                ?.call(AuthenticatorSuccessEvent.fromJson(data));});
          }
          break;
        case "AuthenticatorErrorEvent":
          {
            courierList.forEach((key, value){value.configuration.client.configuration?.eventHandler?.onEvent
                ?.call(AuthenticatorErrorEvent.fromJson(data));});
          }
          break;

        case "CourierDisconnect":
          {
            courierList.forEach((key, value){value.configuration.client.configuration?.eventHandler?.onEvent
                ?.call(CourierDisconnectEvent.fromJson(data));});
          }
          break;
        case "ConnectionAvailable":
          {
            courierList.forEach((key, value){value.configuration.client.configuration?.eventHandler?.onEvent
                ?.call(ConnectionAvailableEvent());});
          }
          break;
        case "ConnectionUnavailable":
          {
            courierList.forEach((key, value) {value.configuration.client.configuration?.eventHandler?.onEvent
                ?.call(ConnectionUnavailableEvent());});
          }
          break;
      }
    });
  }

  @override
  Future<void> subscribe(String id, String topic, [QoS qoS = QoS.ZERO]) async {
    await methodChannel.invokeMethod<String>(
        'subscribe', {'id': id, 'topic': topic, 'qos': '${qoSEnumMap[qoS]}'});
  }

  @override
  Future<void> unsubscribe(String id, String topic) async {
    await methodChannel.invokeMethod<String>('unsubscribe', {'id': id, 'topic': topic});
  }

  @override
  Future<void> disconnect(String id) async {
    await methodChannel.invokeMethod<String>('disconnect', {'id': id});
  }

  @override
  Future<void> send(String id, String topic, String msg,
      [QoS qoS = QoS.ZERO]) async {
    await methodChannel.invokeMethod<String>(
        'send', {'id': id, 'topic': topic, 'msg': msg, 'qos': '${qoSEnumMap[qoS]}'});
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
  Future<void> sendUint8List(String id, String topic, Uint8List msg, [QoS qoS = QoS.ZERO]) async {
    await methodChannel.invokeMethod<String>(
        'sendByte', {'id' : id, 'topic': topic, 'msg': msg, 'qos': '${qoSEnumMap[qoS]}'});
  }
}
