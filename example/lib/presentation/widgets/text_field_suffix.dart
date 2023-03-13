import 'package:flutter/cupertino.dart';

class TextFieldSuffix extends StatelessWidget {
  const TextFieldSuffix(
    this.title, {
    Key? key,
  }) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      '$title  ',
      style: const TextStyle(color: CupertinoColors.systemGrey),
    );
  }
}
