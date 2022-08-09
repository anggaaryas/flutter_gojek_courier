import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ConfigurationSection extends StatelessWidget {
  const ConfigurationSection(
      {Key? key,
        required this.ipAddressController,
        required this.portController,
        required this.pingInterval,
        required this.clientIdController,
        required this.usernameController,
        required this.passwordController,
        required this.isCleanSession,
        this.onConnect,
        this.onRandomClientId,
        this.onDefaultConnection,
        this.onCleanSession})
      : super(key: key);

  final TextEditingController ipAddressController;
  final TextEditingController portController;
  final TextEditingController pingInterval;
  final TextEditingController clientIdController;
  final TextEditingController usernameController;
  final TextEditingController passwordController;
  final bool isCleanSession;
  final VoidCallback? onConnect;
  final VoidCallback? onRandomClientId;
  final VoidCallback? onDefaultConnection;
  final void Function(bool)? onCleanSession;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 30,
            ),
            const Text("Connection"),
            const SizedBox(
              height: 10,
            ),
            CupertinoTextField(
              controller: ipAddressController,
              textDirection: TextDirection.ltr,
              textAlign: TextAlign.end,
              prefix: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Text("IP Address: "),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            CupertinoTextField(
              controller: portController,
              keyboardType: TextInputType.number,
              textDirection: TextDirection.ltr,
              textAlign: TextAlign.end,
              prefix: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Text("Port: "),
              ),
            ),
            TextButton(
                onPressed: onDefaultConnection,
                child: const Text("Use HiveMQ Public Address & Port")),
            const SizedBox(
              height: 20,
            ),
            const Text("ClientID"),
            const SizedBox(
              height: 10,
            ),
            CupertinoTextField(
              controller: clientIdController,
              prefix: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Text("ClientID: "),
              ),
            ),
            TextButton(
                child: const Text("Use Random from Username"),
                onPressed: onRandomClientId),
            const SizedBox(
              height: 20,
            ),
            const Text("Crendentials"),
            const SizedBox(
              height: 10,
            ),
            CupertinoTextField(
              controller: usernameController,
              textDirection: TextDirection.ltr,
              textAlign: TextAlign.end,
              placeholder: "Username",
              prefix: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Text("*Username: "),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            CupertinoTextField(
              controller: passwordController,
              textDirection: TextDirection.ltr,
              textAlign: TextAlign.end,
              placeholder: "Password (Optional)",
              prefix: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Text("Password: "),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            const Text("Configuration"),
            const SizedBox(
              height: 10,
            ),
            CupertinoTextField(
              controller: pingInterval,
              keyboardType: TextInputType.number,
              textDirection: TextDirection.ltr,
              textAlign: TextAlign.end,
              prefix: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Text("Ping Interval: "),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Clean Session"),
                CupertinoSwitch(
                    value: isCleanSession, onChanged: onCleanSession),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            CupertinoButton.filled(
                onPressed: onConnect, child: const Text("Connect")),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
