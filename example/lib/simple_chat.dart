import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:gojek_courier/gojek_courier.dart';
import 'package:gojek_courier/gojek_courier.dart' as courier;
import 'package:gojek_courier_example/configuration_section.dart';

class SimpleChatScreen extends StatefulWidget {
  const SimpleChatScreen({Key? key}) : super(key: key);

  @override
  State<SimpleChatScreen> createState() => _SimpleChatScreenState();
}

class _SimpleChatScreenState extends State<SimpleChatScreen> {
  final gojekCourierPlugin = GojekCourier();
  List<String> logText = [];
  List<String> chatList = [];
  String topic = "";
  TextEditingController message = TextEditingController();
  bool isConnect = false;
  bool isTopicSubscribed = false;
  bool isCleanSession = true;

  final TextEditingController _ipAddressController =
  TextEditingController(text: "broker.mqttdashboard.com");
  final TextEditingController _portController =
  TextEditingController(text: "1883");
  final TextEditingController _clientIdController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _pingInterval = TextEditingController(text: "60");

  @override
  void initState() {
    super.initState();
    initPlatformState();
    _usernameController.text = "user";
    _clientIdController.text =
    "${_usernameController.text}-${Random().nextInt(10000)}";
  }

  Future<void> initPlatformState() async {


    await initCourier();


  }

  Future<void> connect(String username) async {
    await gojekCourierPlugin.connect(
        option: MqttConnectOption(
          isCleanSession: isCleanSession,
          clientId: _clientIdController.text,
          keepAlive: courier.KeepAlive(timeSeconds: int.parse(_pingInterval.text)),
          password: _passwordController.text,
          serverUri: ServerUri(
              host: _ipAddressController.text,
              port: int.parse(_portController.text),
              scheme: "tcp"),
          username: username,

        ));
  }

  Future<void> subscribeTopic(String topic) async {
    await gojekCourierPlugin.subscribe("chat/testroom/$topic", QoS.TWO);

    listen();
  }

  void listen() {
    gojekCourierPlugin.receiveDataStream.listen((event) {
      var decode = (jsonDecode(event)["data"] as List<dynamic>).map((e) {
        return e as int;
      }).toList();
      var msgString =  Utf8Decoder().convert(decode);
      var msg = jsonDecode(msgString);
      chatList.add("${msg["from"]}   :   ${msg['msg']}");
      setState(() {});
      print('=-=-=-=-=');
    });
  }

  Future<void> send(String topic, String msg) async {
    message.clear();
    await gojekCourierPlugin.send(
        "chat/testroom/$topic",
        jsonEncode({
          "from": _clientIdController.text,
          "msg": msg,
        }).toString());
  }

  Future<void> sendByte(String topic, String msg) async {
    message.clear();
    await gojekCourierPlugin.sendUint8List(
        "chat/testroom/$topic",
        Uint8List.fromList(utf8.encode(jsonEncode({
          "from": _clientIdController.text,
          "msg": msg,
        }).toString())));
  }

  Future<void> initCourier() async {
    await gojekCourierPlugin.initialise(
        courier: Courier(
            configuration: CourierConfiguration(
                logger: courier.Logger(
                    onDebug: (String tag, String msg, [String tr = ""]) {
                      logText.add("[DEBUG]   --$tag   $msg");
                      setState(() {});
                    }, onError: (String tag, String msg, [String tr = ""]) {
                  logText.add("[ERROR]   --$tag   $msg");
                  setState(() {});
                }, onInfo: (String tag, String msg, [String tr = ""]) {
                  logText.add("[INFO]   --$tag   $msg");
                  setState(() {});
                }, onVerbose: (String tag, String msg, [String tr = ""]) {
                  logText.add("[VERBOSE]   --$tag   $msg");
                  setState(() {});
                }, onWarning: (String tag, {String msg = "", String tr = ""}) {
                  logText.add("[WARNING]   --$tag   $msg");
                  setState(() {});
                }),
                client: MqttClient(
                    configuration: MqttConfiguration(
                        logger: courier.Logger(onDebug: (String tag, String msg,
                            [String tr = ""]) {
                          logText.add("[DEBUG]   --$tag   $msg");
                          setState(() {});
                        }, onError: (String tag, String msg, [String tr = ""]) {
                          logText.add("[ERROR]   --$tag   $msg");
                          setState(() {});
                        }, onInfo: (String tag, String msg, [String tr = ""]) {
                          logText.add("[INFO]   --$tag   $msg");
                          setState(() {});
                        }, onVerbose: (String tag, String msg,
                            [String tr = ""]) {
                          logText.add("[VERBOSE]   --$tag   $msg");
                          setState(() {});
                        }, onWarning: (String tag,
                            {String msg = "", String tr = ""}) {
                          logText.add("[WARNING]   --$tag   $msg");
                          setState(() {});
                        }),
                        eventHandler: EventHandler(onEvent: (event) {
                          if (event is MqttConnectSuccessEvent) {
                            print(isConnect);
                            print('===');
                            setState(() {
                              isConnect = true;
                            });
                          } else if (event is MqttSubscribeSuccessEvent) {
                            print(event.topics);
                            print('===');
                            setState(() {
                              isTopicSubscribed = true;
                            });
                          } else if (event is MqttDisconnectCompleteEvent) {
                            setState(() {
                              isConnect = false;
                              isTopicSubscribed = false;
                            });
                          }
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(event.toString())));
                        }),
                        authFailureHandler:
                        AuthFailureHandler(handleAuthFailure: () {
                          setState(() {
                            isConnect = false;
                          });
                        }))))));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: isConnect
            ? Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            isConnect && !isTopicSubscribed
                ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    topic = value;
                  });
                },
                decoration:
                const InputDecoration(hintText: "topic"),
              ),
            )
                : Container(),
            isTopicSubscribed && isConnect
                ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: message,
                decoration:
                const InputDecoration(hintText: "message"),
              ),
            )
                : Container(),
            SizedBox(
              height: 32,
              child: ListView(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                children: [
                  isConnect && !isTopicSubscribed
                      ? ElevatedButton(
                      onPressed: () {
                        if (topic.isNotEmpty) {
                          subscribeTopic(topic);
                        }
                      },
                      child: const Text("Subscribe"))
                      : Container(),
                  isConnect
                      ? ElevatedButton(
                      onPressed: () {
                        gojekCourierPlugin.disconnect();
                        setState(() {
                          isConnect = false;
                          isTopicSubscribed = false;
                        });
                      },
                      child: const Text("Disconnect"))
                      : Container(),
                  isTopicSubscribed
                      ? ElevatedButton(
                      onPressed: () {
                        sendByte(topic, message.text);
                      },
                      child: const Text("Send"))
                      : Container(),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(8),
              child: Text(
                "Chat:",
                style: TextStyle(fontSize: 16),
              ),
            ),
            Expanded(
                child: ListView.builder(
                  itemCount: chatList.length,
                  itemBuilder: (ctx, index) {
                    return Text(chatList.reversed.toList()[index]);
                  },
                )),
            const Padding(
              padding: EdgeInsets.all(8),
              child: Text(
                "LOG:",
                style: TextStyle(fontSize: 16),
              ),
            ),
            Expanded(
                child: ListView.separated(
                  itemCount: logText.length,
                  itemBuilder: (ctx, index) {
                    return Text(logText.reversed.toList()[index]);
                  },
                  separatorBuilder: (ctx, index) {
                    return const Padding(padding: EdgeInsets.all(8));
                  },
                )),
          ],
        )
            : ConfigurationSection(
          ipAddressController: _ipAddressController,
          portController: _portController,
          pingInterval: _pingInterval,
          clientIdController: _clientIdController,
          usernameController: _usernameController,
          passwordController: _passwordController,
          isCleanSession: isCleanSession,
          onConnect: () async {
            if (_usernameController.text.isNotEmpty) {
              await connect(_usernameController.text);
            }
          },
          onRandomClientId: () {
            setState(() {
              _clientIdController.text =
              "${_usernameController.text}-${Random().nextInt(10000)}";
            });
          },
          onDefaultConnection: () {
            _ipAddressController.text = "broker.mqttdashboard.com";
            _portController.text = "1883";
          },
          onCleanSession: (value) {
            setState(() {
              isCleanSession = value;
            });
          },
        ));
  }
}
