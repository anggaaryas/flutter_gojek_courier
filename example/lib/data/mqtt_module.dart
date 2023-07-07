import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter/material.dart' as material;
import 'package:gojek_courier/gojek_courier.dart';
import 'package:gojek_courier_example/data/mqtt_message.dart';

class MqttModule {
  MqttModule._();
  static final MqttModule _i = MqttModule._();
  static MqttModule get instance => _i;

  static final GojekCourier _courier = GojekCourier();

  final List<String> subscribedTopics = [];
  final material.ValueNotifier<bool> isConnected =
      material.ValueNotifier<bool>(false);

  bool _firstTryConnect = false;

  StreamController<MqttEvent> mqttEventLog = StreamController.broadcast();
  Stream<dynamic> get receiveDataStream => _courier.receiveDataStream.map(
        (event) => MqttMessage.fromJson(jsonDecode(event)),
      );

  final ILogger _logger = Logger(
    onDebug: (String tag, String msg, [String tr = '']) {
      print('[DEBUG]   --$tag   $msg');
    },
    onError: (String tag, String msg, [String tr = '']) {
      print('[ERROR]   --$tag   $msg');
    },
    onInfo: (String tag, String msg, [String tr = '']) {
      print('[INFO]   --$tag   $msg');
    },
    onVerbose: (String tag, String msg, [String tr = '']) {
      print('[VERBOSE]   --$tag   $msg');
    },
    onWarning: (String tag, {String msg = '', String tr = ''}) {
      print('[WARNING]   --$tag   $msg');
    },
  );

  Future<void> initialize() async {
    await _courier.initialise(
      courier: Courier(
        configuration: CourierConfiguration(
          logger: _logger,
          client: MqttClient(
            configuration: MqttConfiguration(
                useInterceptor: true,
                experimentConfig: const ExperimentConfig(
                  isPersistentSubscriptionStoreEnabled: false,
                ),
                // logger: _logger,
                eventHandler: EventHandler(
                  onEvent: (event) {
                    mqttEventLog.sink.add(event);
                    print('[EVENT]   $event   ${event.toJson()}');

                    switch (event.runtimeType) {
                      case MqttConnectSuccessEvent:
                        isConnected.value = true;
                        break;
                      case MqttDisconnectCompleteEvent:
                        isConnected.value = false;
                        break;
                      case MqttConnectionLostEvent:
                        print("conn lost");
                        isConnected.value = false;
                        break;
                      default:
                        break;
                    }
                  },
                )),
          ),
        ),
      ),
    );
  }

  Future<bool> connect({
    required bool cleanSession,
    required String clientId,
    required String host,
    required String scheme,
    required int port,
    required int pingInterval,
    required String username,
    required String password,
  }) async {
    try {
      await _courier.connect(
        option: MqttConnectOption(
          isCleanSession: cleanSession,
          clientId: clientId,
          keepAlive: KeepAlive(timeSeconds: pingInterval),
          serverUri: ServerUri(
            host: host,
            port: port,
            scheme: "tcp",
          ),
          username: username,
          password: password,
        ),
      );
      isConnected.value = true;
      _firstTryConnect = true;
      return true;
    } catch (e) {
      log('Error connect mqtt $e');
      return false;
    }
  }

  Future<bool> disconnect() async {
    if(_firstTryConnect){
      try {
        var completer = Completer<bool>();
        var t = mqttEventLog.stream.listen((event) {
          if(event is MqttDisconnectCompleteEvent || event is MqttConnectionLostEvent){
            completer.complete(true);
          }
        });
        _courier.disconnect();
        await completer.future;
        t.cancel();
        return true;
      } catch (e) {
        log('Error disconnect mqtt $e');
        return false;
      }
    }

    return true;
  }

  Future<bool> subscribe(String topic, QoS qos) async {
    if (!subscribedTopics.contains(topic)) {
      try {
        await _courier.subscribe(topic, qos);
        subscribedTopics.add(topic);
        return true;
      } catch (e) {
        log('Error publish string $e');
        return false;
      }
    }
    return true;
  }

  Future<bool> subscribeAll(List<String> topics, QoS qos) async {
    var temp = <String>[];
    for(var topic in topics){
      if (!subscribedTopics.contains(topic)) {
        temp.add(topic);
      }
    }
    try {
      for(var topic in temp){
        _courier.subscribe(topic, qos);
      }

      var completer = Completer<bool>();
      var listener = mqttEventLog.stream.listen((event){
        if(event is MqttUnsubscribeSuccessEvent && event.topics?.length == temp.length){
          var i = 0;
          for(var t in event.topics!){
            if(temp.contains(t)) i++;
          }
          if(i == temp.length) {
            completer.complete(true);
            temp.forEach((element) {subscribedTopics.add(element);});
          }
        }
      });
      await completer.future;
      await listener.cancel();


      return true;
    } catch (e) {
      log('Error publish string $e');
      return false;
    }
    return true;
  }

  Future<bool> unsubscribe(String topic) async {
    if (subscribedTopics.contains(topic)) {
      try {
        await _courier.unsubscribe(topic);
        var completer = Completer<bool>();

        var listener = mqttEventLog.stream.listen((event){
          if(event is MqttUnsubscribeSuccessEvent){
            completer.complete(true);
          }
        });
        await completer.future;
        await listener.cancel();
        subscribedTopics.remove(topic);
        return true;
      } catch (e) {
        log('Error publish string $e');
        return false;
      }
    }
    return true;
  }

  Future<bool> publishString({
    required String topic,
    required String message,
    required QoS qos,
  }) async {
    try {
      await _courier.send(topic, message, qos);
      return true;
    } catch (e) {
      log('Error publish string $e');
      return false;
    }
  }

  Future<bool> publishByte({
    required String topic,
    required Uint8List message,
    required QoS qos,
  }) async {
    try {
      await _courier.sendUint8List(topic, message, qos);
      return true;
    } catch (e) {
      log('Error publish string $e');
      return false;
    }
  }

  Future<void> dispose() async {
    _courier.disconnect();
    // mqttEventLog.close();

    return;
  }
}
