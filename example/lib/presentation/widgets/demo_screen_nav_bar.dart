import 'package:flutter/cupertino.dart';

import '../screens/demo_screen.dart';

class DemoScreenNavBar extends StatelessWidget {
  const DemoScreenNavBar({
    Key? key,
    required this.activeTab,
    required this.onValueChanged,
    required this.onTap,
  }) : super(key: key);

  final DemoScreenTab activeTab;
  final Function(DemoScreenTab? tab) onValueChanged;
  final Function(DemoScreenTab? tab) onTap;

  @override
  Widget build(BuildContext context) {
    return CupertinoSlidingSegmentedControl<DemoScreenTab>(
      thumbColor: CupertinoColors.systemBlue,
      groupValue: activeTab,
      onValueChanged: onValueChanged,
      children: {
        for (var tab in DemoScreenTab.values)
          tab: _NavBarItem(
            tab: tab,
            onTap: () => onTap.call(tab),
          )
      },
    );
  }
}

class _NavBarItem extends StatelessWidget {
  const _NavBarItem({
    Key? key,
    required this.tab,
    required this.onTap,
  }) : super(key: key);

  final DemoScreenTab tab;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (event) => onTap.call(),
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Text(
          _buildTitle(tab.name),
          style: const TextStyle(color: CupertinoColors.white),
        ),
      ),
    );
  }

  String _buildTitle(String name) =>
      "${name[0].toUpperCase()}${name.substring(1).toLowerCase()}";
}
