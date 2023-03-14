import 'mqtt_event.dart';

class EventHandler {
  const EventHandler({this.onEvent});

  final Function(MqttEvent)? onEvent;
}
