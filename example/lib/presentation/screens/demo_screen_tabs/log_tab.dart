import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gojek_courier/gojek_courier.dart';

import '../../../data/mqtt_module.dart';

class _Log {
  final MqttEvent event;
  final DateTime timestamp;

  _Log({
    required this.event,
    required this.timestamp,
  });

  String get time => '${timestamp.hour.toString().padLeft(2, '0')}:'
      '${timestamp.minute.toString().padLeft(2, '0')}:'
      '${timestamp.second.toString().padLeft(2, '0')}.'
      '${timestamp.millisecond.toString().padLeft(3, '0')}';
}

class LogTab extends StatefulWidget {
  const LogTab({super.key});

  @override
  State<LogTab> createState() => _LogTabState();
}

class _LogTabState extends State<LogTab> with AutomaticKeepAliveClientMixin {
  final _mqttModule = MqttModule.instance;

  late final StreamSubscription _eventSubs;
  final List<_Log> _logs = [];

  final ScrollController _scrollCtl = ScrollController();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();

    _eventSubs = _mqttModule.mqttEventLog.stream.listen(_eventListener);
  }

  @override
  void dispose() {
    _eventSubs.cancel();
    _scrollCtl.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ListView.builder(
      controller: _scrollCtl,
      padding: const EdgeInsets.all(16).copyWith(bottom: 32),
      itemCount: _logs.length,
      itemBuilder: (context, index) => Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${_logs[index].time}  ',
                style: const TextStyle(
                  color: CupertinoColors.systemGrey,
                ),
              ),
              Expanded(
                child: Text(
                  '${_logs[index].event}',
                  style: const TextStyle(),
                ),
              ),
            ],
          ),
          if (index != _logs.length - 1)
            const Divider(
              thickness: 1,
              color: CupertinoColors.secondaryLabel,
            ),
        ],
      ),
    );
  }

  void _eventListener(event) {
    setState(() {
      _logs.add(
        _Log(event: event, timestamp: DateTime.now()),
      );
      var offset = _scrollCtl.position.maxScrollExtent;
      if (_scrollCtl.position.maxScrollExtent >
          MediaQuery.of(context).size.height - 100) {
        offset += 30;
      }
      _scrollCtl.animateTo(
        offset,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCirc,
      );
    });
  }
}
