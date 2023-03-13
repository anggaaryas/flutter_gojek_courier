import 'package:flutter/cupertino.dart';
import 'package:gojek_courier_example/presentation/screens/config_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const CupertinoApp(
      theme: CupertinoThemeData(brightness: Brightness.dark),
      home: ConfigScreen(),
    );
  }
}
