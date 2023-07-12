import 'dart:math';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gojek_courier_example/network/mqtt_module.dart';
import 'package:gojek_courier_example/presentation/screens/demo_screen.dart';
import 'package:gojek_courier_example/presentation/widgets/base_screen.dart';
import 'package:gojek_courier_example/presentation/widgets/snackbar.dart';

import '../widgets/text_field_suffix.dart';

class ConfigScreen extends StatefulWidget {
  const ConfigScreen({super.key});

  @override
  State<ConfigScreen> createState() => _ConfigScreenState();
}

class _ConfigScreenState extends State<ConfigScreen>
    with WidgetsBindingObserver {
  final _mqttModule = MqttModule.instance;

  static const String _defaultHost = 'broker.mqttdashboard.com';
  static const String _defaultPort = '1883';
  static const String _defaultScheme = 'tcp';
  static const String _defaultPing = '30';

  final TextEditingController _hostTextCtl = TextEditingController();
  final TextEditingController _portTextCtl = TextEditingController();
  final TextEditingController _schemeTextCtl = TextEditingController();
  final TextEditingController _pingTextCtl = TextEditingController();
  final TextEditingController _clientIdTextCtl = TextEditingController();
  final TextEditingController _usernameTextCtl = TextEditingController();
  final TextEditingController _passwordTextCtl = TextEditingController();

  final ScrollController _scrollController = ScrollController();

  bool _isCleanSession = true;
  double _bottomInset = 0;
  final _footerHeight = 180;


  @override
  void initState() {
    super.initState();

    _mqttModule.initialize();

    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _scrollController.addListener(() {
        print(_scrollController.offset);
      });
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);

    _hostTextCtl.dispose();
    _portTextCtl.dispose();
    _pingTextCtl.dispose();
    _clientIdTextCtl.dispose();
    _usernameTextCtl.dispose();
    _passwordTextCtl.dispose();

    _mqttModule.disconnect();
    _mqttModule.dispose();

    _scrollController.dispose();

    super.dispose();
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    setState(() {
      _bottomInset = WidgetsBinding.instance.window.viewInsets.bottom;
    });

    // Future.delayed(Duration.zero, () {
    //   if (_bottomInset != 0) {
    //     _scrollController.animateTo(_scrollController.offset + _footerHeight, duration: const Duration(milliseconds: 250), curve: Curves.easeOut);
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      resizeToAvoidBottomInset: true,
      child: BaseScreen(
        body: CustomScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          controller: _scrollController,
          slivers: <Widget>[
            const CupertinoSliverNavigationBar(
              largeTitle: Text(
                'GojekCourier',
                style: TextStyle(letterSpacing: -0.6),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /* Connection */
                    const Text('Connection'),
                    const SizedBox(height: 10),
                    CupertinoTextField(
                      controller: _hostTextCtl,
                      keyboardType: TextInputType.url,
                      suffix: const TextFieldSuffix('Host'),
                      placeholder: _defaultHost,
                    ),
                    const SizedBox(height: 10),
                    CupertinoTextField(
                      controller: _portTextCtl,
                      keyboardType: TextInputType.number,
                      suffix: const TextFieldSuffix('Port'),
                      placeholder: _defaultPort,
                    ),
                    const SizedBox(height: 10),
                    CupertinoTextField(
                      controller: _schemeTextCtl,
                      keyboardType: TextInputType.number,
                      suffix: const TextFieldSuffix('Scheme'),
                      placeholder: _defaultScheme,
                    ),
                    TextButton(
                      child: const Text('Use HiveMQ Public Address & Port'),
                      onPressed: () {
                        setState(() {
                          _hostTextCtl.text = _defaultHost;
                          _portTextCtl.text = _defaultPort;
                          _schemeTextCtl.text = _defaultScheme;
                        });
                      },
                    ),
                    const SizedBox(height: 20),

                    /* Client ID */
                    const Text('ClientID'),
                    const SizedBox(height: 10),
                    CupertinoTextField(
                      controller: _clientIdTextCtl,
                      suffix: const TextFieldSuffix('ClientID'),
                      placeholder: 'User-1234',
                    ),
                    TextButton(
                      child: const Text('Generate random ClientID'),
                      onPressed: () {
                        setState(() {
                          _clientIdTextCtl.text =
                          '${Random.secure().nextInt(100000)}';
                        });
                      },
                    ),
                    const SizedBox(height: 20),

                    /* Credentials */
                    const Text('Crendentials'),
                    const SizedBox(height: 10),
                    CupertinoTextField(
                      controller: _usernameTextCtl,
                      suffix: const TextFieldSuffix('Username'),
                      placeholder: 'Username',
                    ),
                    const SizedBox(height: 10),
                    CupertinoTextField(
                      controller: _passwordTextCtl,
                      suffix: const TextFieldSuffix('Password'),
                      placeholder: 'Password (Optional)',
                    ),
                    const SizedBox(height: 30),

                    /* Mqtt Config */
                    const Text('MQTT Configuration'),
                    const SizedBox(height: 10),
                    CupertinoTextField(
                      controller: _pingTextCtl,
                      keyboardType: TextInputType.number,
                      suffix: const TextFieldSuffix('Ping Interval'),
                      placeholder: _defaultPing,
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Clean Session'),
                        CupertinoSwitch(
                          value: _isCleanSession,
                          onChanged: (value) => setState(() {
                            _isCleanSession = value;
                          }),
                        ),
                      ],
                    ),
                    const SizedBox(height: 120),
                  ],
                ),
              ),
            ),
          ],
        ),
        footer: Container(
          padding: const EdgeInsets.all(16),
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                CupertinoColors.black,
              ],
            ),
          ),
          child: ValueListenableBuilder<bool>(
            valueListenable: _mqttModule.isConnected,
            builder: (_, isConnected, __) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: AnimatedCrossFade(
                  duration: const Duration(milliseconds: 200),
                  crossFadeState: isConnected
                      ? CrossFadeState.showSecond
                      : CrossFadeState.showFirst,
                  firstChild: SizedBox(
                    width: double.infinity,
                    child: CupertinoButton.filled(
                      onPressed: _connect,
                      child: Text(
                        isConnected ? 'Open Demo Screen' : 'Connect',
                        style: const TextStyle(
                          color: CupertinoColors.white,
                        ),
                      ),
                    ),
                  ),
                  secondChild: SizedBox(
                    width: double.infinity,
                    child: CupertinoButton(
                      onPressed: _disconnect,
                      color: CupertinoColors.systemRed,
                      child: const Text(
                        'Disconnect',
                        style: TextStyle(
                          color: CupertinoColors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _connect() async {
    if (!mounted) return;

    if (_mqttModule.isConnected.value) {
      Navigator.of(context).push(CupertinoPageRoute(
        builder: (_) => const DemoScreen(),
      ));
      return;
    }

    setState(() {
      if (_hostTextCtl.text.isEmpty) {
        _hostTextCtl.text = _defaultHost;
      }
      if (_portTextCtl.text.isEmpty) {
        _portTextCtl.text = _defaultPort;
      }
      if (_schemeTextCtl.text.isEmpty) {
        _schemeTextCtl.text = _defaultScheme;
      }
      if (_clientIdTextCtl.text.isEmpty) {
        _clientIdTextCtl.text = '${Random.secure().nextInt(100000)}';
      }
      if (_usernameTextCtl.text.isEmpty) {
        _usernameTextCtl.text = 'User-${Random.secure().nextInt(100000)}';
      }
      if (_pingTextCtl.text.isEmpty) {
        _pingTextCtl.text = _defaultPing;
      }

      FocusScope.of(context).unfocus();
    });

    showCupertinoDialog(
      context: context,
      builder: (_) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: const Center(
          child: CupertinoActivityIndicator(),
        ),
      ),
    );

    var isConnectSuccess = await _mqttModule.connect(
      cleanSession: _isCleanSession,
      clientId: _clientIdTextCtl.text,
      host: _hostTextCtl.text,
      scheme: _schemeTextCtl.text,
      port: int.parse(_portTextCtl.text),
      pingInterval: int.parse(_pingTextCtl.text),
      username: _usernameTextCtl.text,
      password: _passwordTextCtl.text,
    );

    // ignore: use_build_context_synchronously
    Navigator.of(context).pop();

    if (isConnectSuccess) {
      // ignore: use_build_context_synchronously
      Navigator.of(context).push(CupertinoPageRoute(
        builder: (_) => const DemoScreen(),
      ));
    }
  }

  void _disconnect() async {
    if (!mounted) return;

    showCupertinoDialog(
      context: context,
      builder: (_) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: const Center(
          child: CupertinoActivityIndicator(),
        ),
      ),
    );

    var isDisconnectSuccess = await _mqttModule.disconnect();

    // ignore: use_build_context_synchronously
    Navigator.of(context).pop();

    if (isDisconnectSuccess) {
      // ignore: use_build_context_synchronously
      InternalSnackbar.showSnackbar(
        context,
        'Mqtt Disconnected',
        'Connection sucessfully disconnected',
      );
    }
  }
}
