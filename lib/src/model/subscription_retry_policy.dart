import 'package:json_annotation/json_annotation.dart';

part 'subscription_retry_policy.g.dart';

@JsonSerializable()
class SubscriptionRetryPolicy{
  int? maxRetryCount;

  SubscriptionRetryPolicy({this.maxRetryCount});

  factory SubscriptionRetryPolicy.fromJson(Map<String, dynamic> json) => _$SubscriptionRetryPolicyFromJson(json);

  Map<String, dynamic> toJson() => _$SubscriptionRetryPolicyToJson(this);
}