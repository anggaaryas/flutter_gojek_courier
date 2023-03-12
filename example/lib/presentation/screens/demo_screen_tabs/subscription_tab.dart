import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gojek_courier/gojek_courier.dart';
import 'package:gojek_courier_example/data/mqtt_module.dart';
import 'package:gojek_courier_example/presentation/widgets/base_screen.dart';

import '../../widgets/snackbar.dart';

class SubscriptionTab extends StatefulWidget {
  const SubscriptionTab({super.key});

  @override
  State<SubscriptionTab> createState() => _SubscriptionTabState();
}

class _SubscriptionTabState extends State<SubscriptionTab> {
  final _mqttModule = MqttModule.instance;

  final _topicTextCtl = TextEditingController();
  final _topicFocusNode = FocusNode();

  var _subscriptions = [];

  @override
  void initState() {
    super.initState();

    _subscriptions = _mqttModule.subscribedTopics;

    if (_subscriptions.isEmpty) {
      _topicFocusNode.requestFocus();
    }
  }

  @override
  void dispose() {
    _topicTextCtl.dispose();
    _topicFocusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /* Title */
            const Text(
              'Subscriptions',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 16),

            /* Subscriptions */
            Expanded(
              child: _subscriptions.isEmpty
                  ? const _EmptyTopic()
                  : ListView.builder(
                      itemCount: _subscriptions.length,
                      padding: const EdgeInsets.only(bottom: 60),
                      itemBuilder: (context, index) => _SubsListTile(
                        isFirst: index == 0,
                        isLast: index == _subscriptions.length - 1,
                        title: _subscriptions[index],
                        onUnsub: () => _unsubscribe(_subscriptions[index]),
                      ),
                    ),
            ),
          ],
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
        child: CupertinoTextField(
          controller: _topicTextCtl,
          focusNode: _topicFocusNode,
          placeholder: 'Topic Name',
          suffix: CupertinoButton(
            onPressed: _subscribe,
            child: const Text('Subscribe'),
          ),
        ),
      ),
    );
  }

  void _subscribe() async {
    if (!mounted) return;

    if (_mqttModule.subscribedTopics.contains(_topicTextCtl.text)) {
      InternalSnackbar.showSnackbar(
        context,
        'Topic Already Subscribed',
        'Cannot subscribe to the same topic twice.',
      );
      return;
    }
    
    var isSubscribeSuccess = await _mqttModule.subscribe(
      _topicTextCtl.text,
      QoS.ONE,
    );

    if (isSubscribeSuccess) {
      setState(() {});
    } else {
      // ignore: use_build_context_synchronously
      InternalSnackbar.showSnackbar(
        context,
        'Subscribe Failed',
        'Cannot subscribe to topic. See log for details.',
      );
    }
  }

  void _unsubscribe(String topic) async {
    if (!mounted) return;

    var isUnsubscribeSuccess = await _mqttModule.unsubscribe(topic);

    if (isUnsubscribeSuccess) {
      setState(() {});
    } else {
      // ignore: use_build_context_synchronously
      InternalSnackbar.showSnackbar(
        context,
        'Unsubscribe Failed',
        'Cannot unsubscribe to topic. See log for details.',
      );
    }
  }
}

class _EmptyTopic extends StatelessWidget {
  const _EmptyTopic({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 200,
          decoration: BoxDecoration(
            color: CupertinoColors.darkBackgroundGray,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text(
                'No Topic Subscribed',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              SizedBox(height: 5),
              Text(
                'Add topic in below text field.',
                style: TextStyle(fontSize: 15),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SubsListTile extends StatelessWidget {
  const _SubsListTile({
    Key? key,
    required this.isFirst,
    required this.isLast,
    required this.title,
    required this.onUnsub,
  }) : super(key: key);

  final bool isFirst;
  final bool isLast;
  final String title;
  final VoidCallback onUnsub;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: CupertinoColors.darkBackgroundGray,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(isFirst ? 10 : 0),
          topRight: Radius.circular(isFirst ? 10 : 0),
          bottomLeft: Radius.circular(
            isLast ? 10 : 0,
          ),
          bottomRight: Radius.circular(
            isLast ? 10 : 0,
          ),
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0).copyWith(
              top: isFirst ? 18 : 12,
              bottom: isLast ? 22 : 12,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title),
                GestureDetector(
                  onTap: onUnsub,
                  child: Container(
                    padding: const EdgeInsets.all(3),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: CupertinoColors.destructiveRed,
                    ),
                    child: const Icon(
                      CupertinoIcons.xmark,
                      color: CupertinoColors.white,
                      size: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (!isLast)
            const Divider(
              color: CupertinoColors.inactiveGray,
            )
        ],
      ),
    );
  }
}
