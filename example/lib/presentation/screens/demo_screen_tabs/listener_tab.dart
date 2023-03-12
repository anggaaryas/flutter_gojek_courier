import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gojek_courier/gojek_courier.dart';
import 'package:gojek_courier_example/data/mqtt_module.dart';
import 'package:gojek_courier_example/presentation/widgets/base_screen.dart';
import 'package:gojek_courier_example/presentation/widgets/publish_options.dart';
import 'package:gojek_courier_example/presentation/widgets/snackbar.dart';

import '../../../data/mqtt_message.dart';
import '../../widgets/message_bubble.dart';

enum MessageType { publish, subscribe }

class _Message {
  _Message({
    required this.type,
    required this.message,
  });

  final MessageType type;
  final MqttMessage message;
}

class ListenerTab extends StatefulWidget {
  const ListenerTab({super.key});

  @override
  State<ListenerTab> createState() => _ListenerTabState();
}

class _ListenerTabState extends State<ListenerTab>
    with AutomaticKeepAliveClientMixin {
  final _mqttModule = MqttModule.instance;
  late final StreamSubscription _mqttListener;

  final ScrollController _scrollCtl = ScrollController();

  final _messageTextCtl = TextEditingController();
  var messages = <_Message>[];

  QoS _publishQoS = QoS.ZERO;
  String _topic = '';
  bool retain = true;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _listenMqtt();
  }

  @override
  void dispose() {
    _messageTextCtl.dispose();
    _mqttListener.cancel();
    _scrollCtl.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BaseScreen(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: ListView.builder(
          controller: _scrollCtl,
          padding: const EdgeInsets.only(bottom: 300),
          itemCount: messages.length,
          itemBuilder: (context, index) => MessageBubble(
            qos: QoS.ONE,
            type: messages[index].type,
            topic: messages[index].message.topic,
            message: messages[index].message.data.toString(),
          ),
        ),
      ),
      footer: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.transparent,
              CupertinoColors.black,
            ],
          ),
        ),
        child: Column(
          children: [
            /* Publish Options */
            PublishOptions(
              onRetainChange: (val) => setState(() => retain = val),
              onQoSChange: (val) => setState(() => _publishQoS = val),
              onTopicChange: (val) => setState(() => _topic = val),
            ),
            const SizedBox(height: 20),

            /* Message TextField */
            CupertinoTextField(
              controller: _messageTextCtl,
              placeholder: 'Message',
              suffix: CupertinoButton(
                onPressed: _publishMessage,
                child: const Text('Publish'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _listenMqtt() {
    _mqttListener = _mqttModule.receiveDataStream.listen((event) {
      setState(() {
        messages.add(_Message(type: MessageType.subscribe, message: event));
        _scrollCtl.animateTo(
          _scrollCtl.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutCirc,
        );
      });
    });
  }

  void _publishMessage() async {
    if (_topic.trim().isEmpty) {
      InternalSnackbar.showSnackbar(
        context,
        'Topic is empty',
        'Please input the topic first',
      );

      return;
    }
    var isPublishSuccess = await _mqttModule.publishString(
      topic: _topic,
      message: _messageTextCtl.text,
      qos: _publishQoS,
    );

    if (isPublishSuccess) {
      setState(() {
        messages.add(
          _Message(
            type: MessageType.publish,
            message: MqttMessage(topic: _topic, data: _messageTextCtl.text),
          ),
        );
      });
    } else {
      // ignore: use_build_context_synchronously
      InternalSnackbar.showSnackbar(
        context,
        'Publish Failed',
        'Cannot publish message. See log for details.',
      );
    }
  }
}
