class MqttMessage {
  MqttMessage({
    required this.topic,
    required this.data,
  });

  final String topic;
  final dynamic data;

  factory MqttMessage.fromJson(Map<String, dynamic> json) => MqttMessage(
        topic: json['topic'],
        data: String.fromCharCodes(List<int>.from(json['data'])),
      );
}
