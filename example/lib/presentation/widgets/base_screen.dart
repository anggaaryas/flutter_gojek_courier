import 'package:flutter/material.dart';

class BaseScreen extends StatelessWidget {
  const BaseScreen({
    super.key,
    this.body,
    this.footer,
  });

  final Widget? body;
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => Stack(
        children: [
          Positioned(
            top: 0,
            child: SizedBox(
              height: constraints.maxHeight,
              width: constraints.maxWidth,
              child: body,
            ),
          ),
          Positioned(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            child: SizedBox(
              width: constraints.maxWidth,
              child: footer,
            ),
          ),
        ],
      ),
    );
  }
}
