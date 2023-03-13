import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gojek_courier_example/data/mqtt_module.dart';
import 'package:gojek_courier_example/presentation/screens/demo_screen_tabs/log_tab.dart';

import '../widgets/demo_screen_nav_bar.dart';
import 'demo_screen_tabs/listener_tab.dart';
import 'demo_screen_tabs/subscription_tab.dart';

enum DemoScreenTab { subs, listener, log }

class DemoScreen extends StatefulWidget {
  const DemoScreen({super.key});

  @override
  State<DemoScreen> createState() => _DemoScreenState();
}

class _DemoScreenState extends State<DemoScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabCtl;

  DemoScreenTab _activeTab = DemoScreenTab.subs;

  @override
  void initState() {
    _tabCtl = TabController(length: 3, vsync: this);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      resizeToAvoidBottomInset: false,
      navigationBar: CupertinoNavigationBar(
        middle: const Text('Demo Page'),
        trailing: ValueListenableBuilder<bool>(
            valueListenable: MqttModule.instance.isConnected,
            builder: (_, isConnected, __) {
              return Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isConnected
                      ? CupertinoColors.systemGreen
                      : CupertinoColors.systemRed,
                ),
              );
            }),
      ),
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: DemoScreenNavBar(
                activeTab: _activeTab,
                onTap: (value) {
                  _tabCtl.animateTo(value?.index ?? 0);
                  setState(() {
                    _activeTab = value ?? _activeTab;
                  });
                },
                onValueChanged: (value) {},
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabCtl,
                physics: const NeverScrollableScrollPhysics(),
                children: const [
                  SubscriptionTab(),
                  ListenerTab(),
                  LogTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
