import 'package:flutter/material.dart';

class BaseScreen extends StatelessWidget {
  const BaseScreen({
    super.key,
    this.body = const SizedBox(),
    this.footer = const SizedBox(),
  });

  final Widget body;
  final Widget footer;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => Column(
        children: [
          Expanded(child: body),
          SizedBox(
              width: constraints.maxWidth,
              child: footer,
            ),
        ],
      ),
    );
  }
}
