// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscription_retry_policy.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SubscriptionRetryPolicy _$SubscriptionRetryPolicyFromJson(
        Map<String, dynamic> json) =>
    SubscriptionRetryPolicy(
      maxRetryCount: json['maxRetryCount'] as int?,
    );

Map<String, dynamic> _$SubscriptionRetryPolicyToJson(
        SubscriptionRetryPolicy instance) =>
    <String, dynamic>{
      'maxRetryCount': instance.maxRetryCount,
    };
