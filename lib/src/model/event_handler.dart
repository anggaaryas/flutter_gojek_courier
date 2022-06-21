import 'package:gojek_courier/src/model/mqtt_event.dart';

class EventHandler{
  Function(MqttEvent)? onEvent;

  EventHandler({this.onEvent});
}