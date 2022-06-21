import '../../gojek_courier.dart';
import 'courier_exception.dart';
import 'mqtt_connect_option.dart';
import 'package:json_annotation/json_annotation.dart';

part 'mqtt_event.g.dart';

abstract class MqttEvent {
  final ConnectionInfo? connectionInfo;

  MqttEvent({this.connectionInfo});

}

@JsonSerializable()
class MqttConnectAttemptEvent extends MqttEvent {
  final bool isOptimalKeepAlive;
  final ActiveNetInfo activeNetInfo;
  final ServerUri? serverUri;

  MqttConnectAttemptEvent(
      {required this.isOptimalKeepAlive,
      required this.activeNetInfo,
      this.serverUri,
      super.connectionInfo});

  factory MqttConnectAttemptEvent.fromJson(Map<String, dynamic> json) => _$MqttConnectAttemptEventFromJson(json);

  Map<String, dynamic> toJson() => _$MqttConnectAttemptEventToJson(this);
}

@JsonSerializable()
class MqttConnectDiscardedEvent extends MqttEvent {
  final String reason;
  final ActiveNetInfo activeNetworkInfo;

  MqttConnectDiscardedEvent(
      {required this.reason,
      required this.activeNetworkInfo,
      super.connectionInfo});

  factory MqttConnectDiscardedEvent.fromJson(Map<String, dynamic> json) => _$MqttConnectDiscardedEventFromJson(json);

  Map<String, dynamic> toJson() => _$MqttConnectDiscardedEventToJson(this);
}

@JsonSerializable()
class MqttConnectSuccessEvent extends MqttEvent {
  final ActiveNetInfo activeNetInfo;
  final ServerUri? serverUri;
  final int timeTakenMillis;

  MqttConnectSuccessEvent(
      {required this.activeNetInfo,
      required this.serverUri,
      required this.timeTakenMillis,
      super.connectionInfo});

  factory MqttConnectSuccessEvent.fromJson(Map<String, dynamic> json) => _$MqttConnectSuccessEventFromJson(json);

  Map<String, dynamic> toJson() => _$MqttConnectSuccessEventToJson(this);
}

@JsonSerializable()
class MqttConnectFailureEvent extends MqttEvent {
  final CourierException exception;
  final ActiveNetInfo activeNetInfo;
  final ServerUri? serverUri;
  final int timeTakenMillis;

  MqttConnectFailureEvent(
      {required this.exception,
      required this.activeNetInfo,
      this.serverUri,
      required this.timeTakenMillis,
      super.connectionInfo});

  factory MqttConnectFailureEvent.fromJson(Map<String, dynamic> json) => _$MqttConnectFailureEventFromJson(json);

  Map<String, dynamic> toJson() => _$MqttConnectFailureEventToJson(this);
}

@JsonSerializable()
class MqttConnectionLostEvent extends MqttEvent {
  final CourierException exception;
  final ActiveNetInfo activeNetInfo;
  final ServerUri? serverUri;
  final int nextRetryTimeSecs;
  final int sessionTimeMillis;

  MqttConnectionLostEvent(
      {required this.exception,
      required this.activeNetInfo,
      this.serverUri,
      required this.nextRetryTimeSecs,
      required this.sessionTimeMillis,
      super.connectionInfo});

  factory MqttConnectionLostEvent.fromJson(Map<String, dynamic> json) => _$MqttConnectionLostEventFromJson(json);

  Map<String, dynamic> toJson() => _$MqttConnectionLostEventToJson(this);
}

@JsonSerializable()
class SocketConnectAttemptEvent extends MqttEvent {
  final int port;
  final String? host;
  final int timeout;

  SocketConnectAttemptEvent(
      {required this.port,
      this.host,
      required this.timeout,
      super.connectionInfo});

  factory SocketConnectAttemptEvent.fromJson(Map<String, dynamic> json) => _$SocketConnectAttemptEventFromJson(json);

  Map<String, dynamic> toJson() => _$SocketConnectAttemptEventToJson(this);
}

@JsonSerializable()
class SocketConnectSuccessEvent extends MqttEvent {
  final int port;
  final String? host;
  final int timeout;
  final int timeTakenMillis;

  SocketConnectSuccessEvent(
      {required this.port,
      this.host,
      required this.timeout,
      required this.timeTakenMillis,
      super.connectionInfo});

  factory SocketConnectSuccessEvent.fromJson(Map<String, dynamic> json) => _$SocketConnectSuccessEventFromJson(json);

  Map<String, dynamic> toJson() => _$SocketConnectSuccessEventToJson(this);
}

@JsonSerializable()
class SocketConnectFailureEvent extends MqttEvent {
  final int port;
  final String? host;
  final int timeout;
  final int timeTakenMillis;
  final CourierException exception;

  SocketConnectFailureEvent(
      {required this.port,
      this.host,
      required this.timeout,
      required this.timeTakenMillis,
      required this.exception,
      super.connectionInfo});

  factory SocketConnectFailureEvent.fromJson(Map<String, dynamic> json) => _$SocketConnectFailureEventFromJson(json);

  Map<String, dynamic> toJson() => _$SocketConnectFailureEventToJson(this);
}

@JsonSerializable()
class SSLSocketAttemptEvent extends MqttEvent {
  final int port;
  final String? host;
  final int timeout;

  SSLSocketAttemptEvent(
      {required this.port,
      this.host,
      required this.timeout,
      super.connectionInfo});

  factory SSLSocketAttemptEvent.fromJson(Map<String, dynamic> json) => _$SSLSocketAttemptEventFromJson(json);

  Map<String, dynamic> toJson() => _$SSLSocketAttemptEventToJson(this);
}

@JsonSerializable()
class SSLSocketSuccessEvent extends MqttEvent {
  final int port;
  final String? host;
  final int timeout;
  final int timeTakenMillis;

  SSLSocketSuccessEvent(
      {required this.port,
      this.host,
      required this.timeout,
      required this.timeTakenMillis,
      super.connectionInfo});

  factory SSLSocketSuccessEvent.fromJson(Map<String, dynamic> json) => _$SSLSocketSuccessEventFromJson(json);

  Map<String, dynamic> toJson() => _$SSLSocketSuccessEventToJson(this);
}

@JsonSerializable()
class SSLSocketFailureEvent extends MqttEvent {
  final int port;
  final String? host;
  final int timeout;
  final CourierException exception;
  final int timeTakenMillis;

  SSLSocketFailureEvent(
      {required this.port,
      this.host,
      required this.timeout,
      required this.exception,
      required this.timeTakenMillis,
      super.connectionInfo});

  factory SSLSocketFailureEvent.fromJson(Map<String, dynamic> json) => _$SSLSocketFailureEventFromJson(json);

  Map<String, dynamic> toJson() => _$SSLSocketFailureEventToJson(this);
}

@JsonSerializable()
class SSLHandshakeSuccessEvent extends MqttEvent {
  final int port;
  final String? host;
  final int timeout;
  final int timeTakenMillis;

  SSLHandshakeSuccessEvent(
      {required this.port,
      this.host,
      required this.timeout,
      required this.timeTakenMillis,
      super.connectionInfo});

  factory SSLHandshakeSuccessEvent.fromJson(Map<String, dynamic> json) => _$SSLHandshakeSuccessEventFromJson(json);

  Map<String, dynamic> toJson() => _$SSLHandshakeSuccessEventToJson(this);
}

@JsonSerializable()
class ConnectPacketSendEvent extends MqttEvent {
  ConnectPacketSendEvent({required super.connectionInfo});

  factory ConnectPacketSendEvent.fromJson(Map<String, dynamic> json) => _$ConnectPacketSendEventFromJson(json);

  Map<String, dynamic> toJson() => _$ConnectPacketSendEventToJson(this);
}

enum QoS {
  @JsonValue(0)
  ZERO(0),
  @JsonValue(1)
  ONE(1),
  @JsonValue(2)
  TWO(2);

  const QoS(this.value);

  final int value;
}

@JsonSerializable()
class MqttSubscribeAttemptEvent extends MqttEvent {
  final Map<String, QoS> topics;

  MqttSubscribeAttemptEvent({required this.topics, super.connectionInfo});

  factory MqttSubscribeAttemptEvent.fromJson(Map<String, dynamic> json) => _$MqttSubscribeAttemptEventFromJson(json);

  Map<String, dynamic> toJson() => _$MqttSubscribeAttemptEventToJson(this);
}

@JsonSerializable()
class MqttSubscribeSuccessEvent extends MqttEvent {
  final Map<String, QoS> topics;
  final int timeTakenMillis;

  MqttSubscribeSuccessEvent(
      {required this.topics,
      required this.timeTakenMillis,
      super.connectionInfo});

  factory MqttSubscribeSuccessEvent.fromJson(Map<String, dynamic> json) => _$MqttSubscribeSuccessEventFromJson(json);

  Map<String, dynamic> toJson() => _$MqttSubscribeSuccessEventToJson(this);
}

@JsonSerializable()
class MqttSubscribeFailureEvent extends MqttEvent {
  final Map<String, QoS> topics;
  final CourierException exception;
  final int timeTakenMillis;

  MqttSubscribeFailureEvent(
      {required this.topics,
      required this.exception,
      required this.timeTakenMillis,
      super.connectionInfo});

  factory MqttSubscribeFailureEvent.fromJson(Map<String, dynamic> json) => _$MqttSubscribeFailureEventFromJson(json);

  Map<String, dynamic> toJson() => _$MqttSubscribeFailureEventToJson(this);
}

@JsonSerializable()
class MqttUnsubscribeAttemptEvent extends MqttEvent {
  final List<String> topics;

  MqttUnsubscribeAttemptEvent({required this.topics, super.connectionInfo});

  factory MqttUnsubscribeAttemptEvent.fromJson(Map<String, dynamic> json) => _$MqttUnsubscribeAttemptEventFromJson(json);

  Map<String, dynamic> toJson() => _$MqttUnsubscribeAttemptEventToJson(this);
}

@JsonSerializable()
class MqttUnsubscribeSuccessEvent extends MqttEvent {
  final List<String> topics;
  final int timeTakenMillis;

  MqttUnsubscribeSuccessEvent(
      {required this.topics,
      required this.timeTakenMillis,
      super.connectionInfo});

  factory MqttUnsubscribeSuccessEvent.fromJson(Map<String, dynamic> json) => _$MqttUnsubscribeSuccessEventFromJson(json);

  Map<String, dynamic> toJson() => _$MqttUnsubscribeSuccessEventToJson(this);
}

@JsonSerializable()
class MqttUnsubscribeFailureEvent extends MqttEvent {
  final List<String> topics;
  final CourierException exception;
  final int timeTakenMillis;

  MqttUnsubscribeFailureEvent(
      {required this.topics,
      required this.exception,
      required this.timeTakenMillis,
      super.connectionInfo});

  factory MqttUnsubscribeFailureEvent.fromJson(Map<String, dynamic> json) => _$MqttUnsubscribeFailureEventFromJson(json);

  Map<String, dynamic> toJson() => _$MqttUnsubscribeFailureEventToJson(this);
}

@JsonSerializable()
class MqttMessageReceiveEvent extends MqttEvent {
  final String topic;
  final int sizeBytes;

  MqttMessageReceiveEvent(
      {required this.topic, required this.sizeBytes, super.connectionInfo});

  factory MqttMessageReceiveEvent.fromJson(Map<String, dynamic> json) => _$MqttMessageReceiveEventFromJson(json);

  Map<String, dynamic> toJson() => _$MqttMessageReceiveEventToJson(this);
}

@JsonSerializable()
class MqttMessageReceiveErrorEvent extends MqttEvent {
  final String topic;
  final int sizeBytes;
  final CourierException exception;

  MqttMessageReceiveErrorEvent(
      {required this.topic,
      required this.sizeBytes,
      required this.exception,
      super.connectionInfo});

  factory MqttMessageReceiveErrorEvent.fromJson(Map<String, dynamic> json) => _$MqttMessageReceiveErrorEventFromJson(json);

  Map<String, dynamic> toJson() => _$MqttMessageReceiveErrorEventToJson(this);
}

@JsonSerializable()
class MqttMessageSendEvent extends MqttEvent {
  final String topic;
  final int qos;
  final int sizeBytes;

  MqttMessageSendEvent(
      {required this.topic,
      required this.qos,
      required this.sizeBytes,
      super.connectionInfo});

  factory MqttMessageSendEvent.fromJson(Map<String, dynamic> json) => _$MqttMessageSendEventFromJson(json);

  Map<String, dynamic> toJson() => _$MqttMessageSendEventToJson(this);
}

@JsonSerializable()
class MqttMessageSendSuccessEvent extends MqttEvent {
  final String topic;
  final int qos;
  final int sizeBytes;

  MqttMessageSendSuccessEvent(
      {required this.topic,
      required this.qos,
      required this.sizeBytes,
      super.connectionInfo});

  factory MqttMessageSendSuccessEvent.fromJson(Map<String, dynamic> json) => _$MqttMessageSendSuccessEventFromJson(json);

  Map<String, dynamic> toJson() => _$MqttMessageSendSuccessEventToJson(this);
}

@JsonSerializable()
class MqttMessageSendFailureEvent extends MqttEvent {
  final String topic;
  final int qos;
  final int sizeBytes;
  final CourierException exception;

  MqttMessageSendFailureEvent(
      {required this.topic,
      required this.qos,
      required this.sizeBytes,
      required this.exception,
      super.connectionInfo});

  factory MqttMessageSendFailureEvent.fromJson(Map<String, dynamic> json) => _$MqttMessageSendFailureEventFromJson(json);

  Map<String, dynamic> toJson() => _$MqttMessageSendFailureEventToJson(this);
}

@JsonSerializable()
class MqttPingInitiatedEvent extends MqttEvent {
  final String serverUri;
  final int keepAliveSecs;
  final bool isAdaptive;

  MqttPingInitiatedEvent(
      {required this.serverUri,
      required this.keepAliveSecs,
      required this.isAdaptive,
      super.connectionInfo});

  factory MqttPingInitiatedEvent.fromJson(Map<String, dynamic> json) => _$MqttPingInitiatedEventFromJson(json);

  Map<String, dynamic> toJson() => _$MqttPingInitiatedEventToJson(this);
}

@JsonSerializable()
class MqttPingScheduledEvent extends MqttEvent {
  final int nextPingTimeSecs;
  final int keepAliveSecs;
  final bool isAdaptive;

  MqttPingScheduledEvent(
      {required this.nextPingTimeSecs,
      required this.keepAliveSecs,
      required this.isAdaptive,
      super.connectionInfo});

  factory MqttPingScheduledEvent.fromJson(Map<String, dynamic> json) => _$MqttPingScheduledEventFromJson(json);

  Map<String, dynamic> toJson() => _$MqttPingScheduledEventToJson(this);
}

@JsonSerializable()
class MqttPingCancelledEvent extends MqttEvent {
  final String serverUri;
  final int keepAliveSecs;
  final bool isAdaptive;

  MqttPingCancelledEvent(
      {required this.serverUri,
      required this.keepAliveSecs,
      required this.isAdaptive,
      super.connectionInfo});

  factory MqttPingCancelledEvent.fromJson(Map<String, dynamic> json) => _$MqttPingCancelledEventFromJson(json);

  Map<String, dynamic> toJson() => _$MqttPingCancelledEventToJson(this);
}

@JsonSerializable()
class MqttPingSuccessEvent extends MqttEvent {
  final String serverUri;
  final int timeTakenMillis;
  final int keepAliveSecs;
  final bool isAdaptive;

  MqttPingSuccessEvent(
      {required this.serverUri,
      required this.timeTakenMillis,
      required this.keepAliveSecs,
      required this.isAdaptive,
      super.connectionInfo});

  factory MqttPingSuccessEvent.fromJson(Map<String, dynamic> json) => _$MqttPingSuccessEventFromJson(json);

  Map<String, dynamic> toJson() => _$MqttPingSuccessEventToJson(this);
}

@JsonSerializable()
class MqttPingFailureEvent extends MqttEvent {
  final String serverUri;
  final int timeTakenMillis;
  final int keepAliveSecs;
  final CourierException exception;
  final bool isAdaptive;

  MqttPingFailureEvent(
      {required this.serverUri,
      required this.timeTakenMillis,
      required this.keepAliveSecs,
      required this.exception,
      required this.isAdaptive,
      super.connectionInfo});

  factory MqttPingFailureEvent.fromJson(Map<String, dynamic> json) => _$MqttPingFailureEventFromJson(json);

  Map<String, dynamic> toJson() => _$MqttPingFailureEventToJson(this);
}

@JsonSerializable()
class MqttPingExceptionEvent extends MqttEvent {
  final CourierException exception;
  final bool isAdaptive;

  MqttPingExceptionEvent(
      {required this.exception,
      required this.isAdaptive,
      super.connectionInfo});

  factory MqttPingExceptionEvent.fromJson(Map<String, dynamic> json) => _$MqttPingExceptionEventFromJson(json);

  Map<String, dynamic> toJson() => _$MqttPingExceptionEventToJson(this);
}

@JsonSerializable()
class BackgroundAlarmPingLimitReached extends MqttEvent {
  final bool isAdaptive;

  BackgroundAlarmPingLimitReached(
      {required this.isAdaptive, super.connectionInfo});

  factory BackgroundAlarmPingLimitReached.fromJson(Map<String, dynamic> json) => _$BackgroundAlarmPingLimitReachedFromJson(json);

  Map<String, dynamic> toJson() => _$BackgroundAlarmPingLimitReachedToJson(this);
}

@JsonSerializable()
class OptimalKeepAliveFoundEvent extends MqttEvent {
  final int timeMinutes;
  final int probeCount;
  final int convergenceTime;

  OptimalKeepAliveFoundEvent(
      {required this.timeMinutes,
      required this.probeCount,
      required this.convergenceTime,
      super.connectionInfo});

  factory OptimalKeepAliveFoundEvent.fromJson(Map<String, dynamic> json) => _$OptimalKeepAliveFoundEventFromJson(json);

  Map<String, dynamic> toJson() => _$OptimalKeepAliveFoundEventToJson(this);
}

@JsonSerializable()
class MqttReconnectEvent extends MqttEvent {
  MqttReconnectEvent({required super.connectionInfo});

  factory MqttReconnectEvent.fromJson(Map<String, dynamic> json) => _$MqttReconnectEventFromJson(json);

  Map<String, dynamic> toJson() => _$MqttReconnectEventToJson(this);
}

@JsonSerializable()
class MqttDisconnectEvent extends MqttEvent {
  MqttDisconnectEvent({required super.connectionInfo});

  factory MqttDisconnectEvent.fromJson(Map<String, dynamic> json) => _$MqttDisconnectEventFromJson(json);

  Map<String, dynamic> toJson() => _$MqttDisconnectEventToJson(this);
}

@JsonSerializable()
class MqttDisconnectStartEvent extends MqttEvent {
  MqttDisconnectStartEvent({required super.connectionInfo});

  factory MqttDisconnectStartEvent.fromJson(Map<String, dynamic> json) => _$MqttDisconnectStartEventFromJson(json);

  Map<String, dynamic> toJson() => _$MqttDisconnectStartEventToJson(this);
}

@JsonSerializable()
class MqttDisconnectCompleteEvent extends MqttEvent {
  MqttDisconnectCompleteEvent({required super.connectionInfo});

  factory MqttDisconnectCompleteEvent.fromJson(Map<String, dynamic> json) => _$MqttDisconnectCompleteEventFromJson(json);

  Map<String, dynamic> toJson() => _$MqttDisconnectCompleteEventToJson(this);
}

@JsonSerializable()
class OfflineMessageDiscardedEvent extends MqttEvent {
  final int messageId;

  OfflineMessageDiscardedEvent({required this.messageId, super.connectionInfo});

  factory OfflineMessageDiscardedEvent.fromJson(Map<String, dynamic> json) => _$OfflineMessageDiscardedEventFromJson(json);

  Map<String, dynamic> toJson() => _$OfflineMessageDiscardedEventToJson(this);
}

@JsonSerializable()
class InboundInactivityEvent extends MqttEvent {
  InboundInactivityEvent({required super.connectionInfo});

  factory InboundInactivityEvent.fromJson(Map<String, dynamic> json) => _$InboundInactivityEventFromJson(json);

  Map<String, dynamic> toJson() => _$InboundInactivityEventToJson(this);
}

enum ThreadState {
  @JsonValue("NEW")
  NEW,
  @JsonValue("RUNNABLE")
  RUNNABLE,
  @JsonValue("BLOCKED")
  BLOCKED,
  @JsonValue("WAITING")
  WAITING,
  @JsonValue("TIMED_WAITING")
  TIMED_WAITING,
  @JsonValue("TERMINATED")
  TERMINATED;
}

@JsonSerializable()
class HandlerThreadNotAliveEvent extends MqttEvent {
  final bool isInterrupted;
  final ThreadState state;

  HandlerThreadNotAliveEvent(
      {required this.isInterrupted, required this.state, super.connectionInfo});

  factory HandlerThreadNotAliveEvent.fromJson(Map<String, dynamic> json) => _$HandlerThreadNotAliveEventFromJson(json);

  Map<String, dynamic> toJson() => _$HandlerThreadNotAliveEventToJson(this);
}

@JsonSerializable()
class AuthenticatorAttemptEvent extends MqttEvent {
  final bool forceRefresh;
  final MqttConnectOption connectOptions;

  AuthenticatorAttemptEvent(
      {required this.forceRefresh,
      required this.connectOptions,
      super.connectionInfo});

  factory AuthenticatorAttemptEvent.fromJson(Map<String, dynamic> json) => _$AuthenticatorAttemptEventFromJson(json);

  Map<String, dynamic> toJson() => _$AuthenticatorAttemptEventToJson(this);
}

@JsonSerializable()
class AuthenticatorSuccessEvent extends MqttEvent {
  final bool forceRefresh;
  final MqttConnectOption connectOptions;
  final int timeTakenMillis;

  AuthenticatorSuccessEvent(
      {required this.forceRefresh,
      required this.connectOptions,
      required this.timeTakenMillis,
      super.connectionInfo});

  factory AuthenticatorSuccessEvent.fromJson(Map<String, dynamic> json) => _$AuthenticatorSuccessEventFromJson(json);

  Map<String, dynamic> toJson() => _$AuthenticatorSuccessEventToJson(this);
}

@JsonSerializable()
class AuthenticatorErrorEvent extends MqttEvent {
  final CourierException exception;
  final int nextRetryTimeSecs;
  final ActiveNetInfo activeNetworkInfo;
  final int timeTakenMillis;

  AuthenticatorErrorEvent(
      {required this.exception,
      required this.nextRetryTimeSecs,
      required this.activeNetworkInfo,
      required this.timeTakenMillis,
      super.connectionInfo});

  factory AuthenticatorErrorEvent.fromJson(Map<String, dynamic> json) => _$AuthenticatorErrorEventFromJson(json);

  Map<String, dynamic> toJson() => _$AuthenticatorErrorEventToJson(this);
}
