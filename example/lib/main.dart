import 'package:flutter/material.dart';
import 'package:gojek_courier_example/simple_chat.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MenuScreen(),
    );
  }
}

class MenuScreen extends StatelessWidget {
  const MenuScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Menu Example"),
        ),
        body: ListView(
          children: [
            menuTile('Chat App', () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const SimpleChatScreen()),
              );
            }),
          ],
        ));
  }

  ListTile menuTile(String name, Function() onTap) {
    return ListTile(
      title: Text(name),
      onTap: onTap,
    );
  }
}
