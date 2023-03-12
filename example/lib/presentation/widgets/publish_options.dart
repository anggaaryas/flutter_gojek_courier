import 'package:flutter/cupertino.dart';
import 'package:gojek_courier/gojek_courier.dart';

import 'text_field_suffix.dart';

class PublishOptions extends StatefulWidget {
  const PublishOptions({
    Key? key,
    required this.onRetainChange,
    required this.onQoSChange,
    required this.onTopicChange,
  }) : super(key: key);

  final void Function(bool retain) onRetainChange;
  final void Function(QoS qos) onQoSChange;
  final void Function(String topic) onTopicChange;

  @override
  State<PublishOptions> createState() => _PublishOptionsState();
}

class _PublishOptionsState extends State<PublishOptions> {
  final retainTextCtl = TextEditingController();
  final qosTextCtl = TextEditingController();
  final topicTextCtl = TextEditingController();

  var minimize = false;

  @override
  void initState() {
    super.initState();

    retainTextCtl.text = 'True';
    qosTextCtl.text = 'QoS.ZERO';
    topicTextCtl.addListener(() {
      widget.onTopicChange.call(topicTextCtl.text);
    });
  }

  @override
  void dispose() {
    retainTextCtl.dispose();
    qosTextCtl.dispose();
    topicTextCtl.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).viewInsets.bottom > 200) {
      minimize = true;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: CupertinoColors.darkBackgroundGray,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Publish Options',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => setState(() => minimize = !minimize),
                child: Icon(
                  minimize
                      ? CupertinoIcons.chevron_up
                      : CupertinoIcons.chevron_down,
                ),
              )
            ],
          ),
          const SizedBox(height: 16),
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 250),
            reverseDuration: const Duration(milliseconds: 250),
            firstCurve: Curves.easeOutCirc,
            secondCurve: Curves.easeOut,
            alignment: Alignment.center,
            crossFadeState:
                MediaQuery.of(context).viewInsets.bottom > 100 || minimize
                    ? CrossFadeState.showFirst
                    : CrossFadeState.showSecond,
            firstChild: const SizedBox(width: double.infinity),
            secondChild: Column(
              children: [
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => _showDialog(
                    children: [
                      const Text('True'),
                      const Text('False'),
                    ],
                    onSelectedItemChanged: (index) => setState(() {
                      retainTextCtl.text = index == 0 ? 'True' : 'False';
                      widget.onRetainChange.call(index == 0);
                    }),
                  ),
                  child: CupertinoTextField(
                    controller: retainTextCtl,
                    suffix: const TextFieldSuffix('Retain'),
                    enabled: false,
                  ),
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => _showDialog(
                    children: QoS.values.map((e) => Text(e.name)).toList(),
                    onSelectedItemChanged: (index) => setState(() {
                      var qos = QoS.values[index];
                      qosTextCtl.text = 'QoS.${qos.name}';
                      widget.onQoSChange.call(qos);
                    }),
                  ),
                  child: CupertinoTextField(
                    controller: qosTextCtl,
                    suffix: const TextFieldSuffix('QoS'),
                    enabled: false,
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
          CupertinoTextField(
            controller: topicTextCtl,
            placeholder: 'Topic Name',
            suffix: const TextFieldSuffix('Topic'),
          ),
        ],
      ),
    );
  }

  void _showDialog({
    required List<Widget> children,
    required void Function(int index) onSelectedItemChanged,
  }) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => Container(
        height: 216,
        padding: const EdgeInsets.only(top: 6.0),
        color: CupertinoColors.systemBackground.resolveFrom(context),
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: SafeArea(
          top: false,
          child: CupertinoPicker(
            magnification: 1.1,
            squeeze: 1.1,
            useMagnifier: false,
            itemExtent: 32,
            onSelectedItemChanged: onSelectedItemChanged,
            children: children,
          ),
        ),
      ),
    );
  }
}
