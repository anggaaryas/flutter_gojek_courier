import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gojek_courier/gojek_courier.dart';
import 'package:gojek_courier/gojek_courier.dart' as courier;

class SimpleChatScreen extends StatefulWidget {
  const SimpleChatScreen({Key? key}) : super(key: key);

  @override
  State<SimpleChatScreen> createState() => _SimpleChatScreenState();
}

class _SimpleChatScreenState extends State<SimpleChatScreen> {
  final gojekCourierPlugin = GojekCourier();
  List<String> logText = [];
  List<String> chatList = [];
  String topic  = "";
  String username = "";
  TextEditingController message = TextEditingController();
  bool isConnect = false;
  bool isTopicSubscribed = false;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {

    gojekCourierPlugin.receiveDataStream.listen((event) {
      var decode = jsonDecode(event)["data"];
      chatList.add("${decode["from"]}   :   ${decode['msg']}");
      setState((){});
    });

    await initCourier();

  }

  Future<void> connect(String username) async {
    await gojekCourierPlugin.connect(option: MqttConnectOption(
      isCleanSession: true,
      clientId: username,
      keepAlive: courier.KeepAlive(
          timeSeconds: 60
      ),

      password: "",
      serverUri: ServerUri(host: "broker.mqttdashboard.com", port: 1883,scheme: "tcp"),
      username: username,
    ));
  }

  Future<void> subscribeTopic(String topic) async {
    await gojekCourierPlugin.subscribe("chat/testroom/$topic");
  }

  Future<void> send(String topic, String msg) async {
    message.clear();
    await gojekCourierPlugin.send("chat/testroom/$topic", jsonEncode({
      "from" : username,
      "msg" : msg,
    }).toString());
  }

  Future<void> initCourier() async {
    await gojekCourierPlugin.initialise(
        courier: Courier(
            configuration: CourierConfiguration(
                logger: courier.Logger(
                    onDebug: (String tag, String msg, [String tr = ""]){
                      logText.add("[DEBUG]   --$tag   $msg");
                      setState((){});
                    },
                    onError: (String tag, String msg, [String tr = ""]){
                      logText.add("[ERROR]   --$tag   $msg");
                      setState((){});
                    },
                    onInfo: (String tag, String msg, [String tr = ""]){
                      logText.add("[INFO]   --$tag   $msg");
                      setState((){});
                    },
                    onVerbose: (String tag, String msg, [String tr = ""]){
                      logText.add("[VERBOSE]   --$tag   $msg");
                      setState((){});
                    },
                    onWarning: (String tag, {String msg = "", String tr = ""}){
                      logText.add("[WARNING]   --$tag   $msg");
                      setState((){});
                    }
                ),
                client: MqttClient(
                    configuration: MqttConfiguration(
                        logger: courier.Logger(
                            onDebug: (String tag, String msg, [String tr = ""]){
                              logText.add("[DEBUG]   --$tag   $msg");
                              setState((){});
                            },
                            onError: (String tag, String msg, [String tr = ""]){
                              logText.add("[ERROR]   --$tag   $msg");
                              setState((){});
                            },
                            onInfo: (String tag, String msg, [String tr = ""]){
                              logText.add("[INFO]   --$tag   $msg");
                              setState((){});
                            },
                            onVerbose: (String tag, String msg, [String tr = ""]){
                              logText.add("[VERBOSE]   --$tag   $msg");
                              setState((){});
                            },
                            onWarning: (String tag, {String msg = "", String tr = ""}){
                              logText.add("[WARNING]   --$tag   $msg");
                              setState((){});
                            }
                        ),
                      eventHandler: EventHandler(
                        onEvent: (event){
                          if(event is MqttConnectSuccessEvent){
                            setState((){
                              isConnect = true;
                            });
                          } else if(event is MqttSubscribeSuccessEvent){
                            setState(() {
                              isTopicSubscribed = true;
                            });
                          } else if(event is MqttDisconnectCompleteEvent){
                            setState(() {
                              isConnect = false;
                              isTopicSubscribed = false;
                            });
                          }
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(event.toString())));
                        }
                      ),
                      authFailureHandler: AuthFailureHandler(
                        handleAuthFailure: (){
                          setState((){
                            isConnect = false;
                          });
                        }
                      )
                    )))));

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            isConnect && !isTopicSubscribed? Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                onChanged: (value){
                  setState((){
                    topic = value;
                  });
                },
                decoration: const InputDecoration(
                    hintText: "topic"
                ),
              ),
            ): Container(),
            isConnect? Container(): Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                onChanged: (value){
                  setState((){
                    username = value;
                  });
                },
                decoration: const InputDecoration(
                    hintText: "username"
                ),
              ),
            ),
            isTopicSubscribed && isConnect? Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: message,
                decoration: const InputDecoration(
                    hintText: "message"
                ),
              ),
            ) : Container(),
            SizedBox(
              height: 32,
              child: ListView(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal ,
                children: [
                  isConnect? Container() : ElevatedButton(onPressed: () async {
                    if(username.isNotEmpty){
                      connect(username);
                    }
                  }, child: const Text("Connect")),
                  isConnect && !isTopicSubscribed? ElevatedButton(onPressed: (){
                    if(topic.isNotEmpty){
                      subscribeTopic(topic);
                    }
                  }, child: const Text("Subscribe")) : Container(),
                  isConnect? ElevatedButton(onPressed: (){
                    gojekCourierPlugin.disconnect();
                    setState((){
                      isConnect = false;
                    });
                  }, child: const Text("Disconnect")) : Container(),
                  isTopicSubscribed? ElevatedButton(onPressed: (){
                    send(topic, message.text);
                  }, child: const Text("Send")) : Container(),
                ],
              ),
            ),
            const Padding(padding: EdgeInsets.all(8),
              child: Text("Chat:", style: TextStyle(
                  fontSize: 16
              ),),),
            Expanded(child: ListView.builder(
              itemCount: chatList.length,
              itemBuilder: (ctx, index){
                return Text(chatList.reversed.toList()[index]);
              },
            )),
            const Padding(padding: EdgeInsets.all(8),
              child: Text("LOG:", style: TextStyle(
                  fontSize: 16
              ),),),
            Expanded(child: ListView.separated(
              itemCount: logText.length,
              itemBuilder: (ctx, index){
                return Text(logText.reversed.toList()[index]);
              },
              separatorBuilder: (ctx, index){
                return const Padding(padding: EdgeInsets.all(8));
              },
            )),
          ],
        )
    );
  }
}