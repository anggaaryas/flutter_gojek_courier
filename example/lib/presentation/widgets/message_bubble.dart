
import 'package:flutter/cupertino.dart';
import 'package:gojek_courier/gojek_courier.dart';

import '../screens/demo_screen_tabs/listener_tab.dart';

class MessageBubble extends StatelessWidget {
  const MessageBubble({
    Key? key,
    required this.type,
    required this.message,
    required this.topic,
    required this.qos,
  }) : super(key: key);

  final MessageType type;
  final String message;
  final String topic;
  final QoS qos;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: type == MessageType.subscribe
            ? CrossAxisAlignment.start
            : CrossAxisAlignment.end,
        children: [
          /* Main Message */
          Container(
            padding: const EdgeInsets.all(12),
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.7,
            ),
            decoration: BoxDecoration(
              color: type == MessageType.subscribe
                  ? CupertinoColors.darkBackgroundGray
                  : CupertinoColors.systemBlue,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(message),
          ),
          const SizedBox(height: 4),

          /* Details */
          Text(
            ' QoS.${qos.name} | $topic',
            style: const TextStyle(
              color: CupertinoColors.systemGrey,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
