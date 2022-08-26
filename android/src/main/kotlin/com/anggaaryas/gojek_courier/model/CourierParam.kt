package com.anggaaryas.gojek_courier.model

import android.content.Context
import com.anggaaryas.gojek_courier.DefaultConstants
import com.anggaaryas.gojek_courier.Listener
import com.gojek.chuckmqtt.external.MqttChuckConfig
import com.gojek.chuckmqtt.external.MqttChuckInterceptor
import com.gojek.chuckmqtt.external.Period
import com.gojek.courier.Courier
import com.gojek.courier.streamadapter.rxjava2.RxJava2StreamAdapterFactory
import com.gojek.mqtt.auth.Authenticator
import com.gojek.mqtt.client.MqttClient
import com.gojek.mqtt.client.MqttInterceptor
import com.gojek.mqtt.client.config.ExperimentConfigs
import com.gojek.mqtt.client.config.PersistenceOptions
import com.gojek.mqtt.client.config.v3.MqttV3Configuration
import com.gojek.mqtt.client.factory.MqttClientFactory
import com.gojek.mqtt.model.AdaptiveKeepAliveConfig
import com.gojek.mqtt.model.MqttConnectOptions
import com.gojek.mqtt.policies.connectretrytime.ConnectRetryTimeConfig
import com.gojek.mqtt.policies.connectretrytime.ConnectRetryTimePolicy
import com.gojek.mqtt.policies.connecttimeout.ConnectTimeoutConfig
import com.gojek.mqtt.policies.connecttimeout.ConnectTimeoutPolicy
import com.gojek.mqtt.policies.subscriptionretry.SubscriptionRetryConfig
import com.gojek.mqtt.policies.subscriptionretry.SubscriptionRetryPolicy
import com.gojek.workmanager.pingsender.WorkManagerPingSenderConfig
import com.gojek.workmanager.pingsender.WorkPingSenderFactory


class CourierParam(value : Map<String, Any?>): Param<Courier>(value) {
    var courierConfiguration : CourierConfigurationParam? = null

    init {
        value.getValue("configuration")?.let {
            courierConfiguration = CourierConfigurationParam(it as Map<String, Any?>)
        }
    }

    override fun build(context: Context, logger: Listener): Courier? {
        return courierConfiguration?.build(context, logger)?.let {
            Courier(
                configuration = it
            )
        }
    }

}

class CourierConfigurationParam(value : Map<String, Any?>): Param<Courier.Configuration>(value) {
    var client : MqttClientParam? = null

    init {
        value.getValue("client")?.let {
            client = MqttClientParam(it as Map<String, Any?>)
        }
    }

    override fun build(context: Context, logger: Listener): Courier.Configuration? {
        return client?.build(context, logger)?.let {
            Courier.Configuration(
                client = it,
                streamAdapterFactories = listOf(RxJava2StreamAdapterFactory()),
                logger = logger.getLogger("Courier")
            )
        }
    }
}

class MqttClientParam(value : Map<String, Any?>): Param<MqttClient>(value) {
    var configuration: MqttConfigurationParam? = null

    init {
        value.getValue("configuration")?.let {
            configuration = MqttConfigurationParam(it as Map<String, Any?>)
        }
    }

    override fun build(context: Context, logger: Listener): MqttClient? {
        return configuration?.build(context, logger)
            ?.let { MqttClientFactory.create(context, it) }
    }
}

class MqttConfigurationParam(value: Map<String, Any?>): Param<MqttV3Configuration>(value){
    var connectRetryTimePolicy: ConnectRetryTimePolicyParam? = null
    var connectTimeoutPolicy: ConnectTimeoutPolicyParam? = null
    var subscriptionRetryPolicy: SubscriptionRetryPolicyParam? = null
    var unsubscriptionRetryPolicy: SubscriptionRetryPolicyParam? = null
    var wakeLockTimeout: Int? = null
    var pingSender: WorkManagerPingSenderConfigParam? = null
    var experimentConfig: ExperimentConfigParam? = null
    var useInterceptor: Boolean = false


    init {
        value.getValue("connectRetryTimePolicy")?.let {
            connectRetryTimePolicy = ConnectRetryTimePolicyParam(it as Map<String, Any?>)
        }
        value.getValue("connectTimeoutPolicy")?.let {
            connectTimeoutPolicy = ConnectTimeoutPolicyParam(it as Map<String, Any?>)
        }
        value.getValue("subscriptionRetryPolicy")?.let {
            subscriptionRetryPolicy = SubscriptionRetryPolicyParam(it as Map<String, Any?>)
        }
        value.getValue("unsubscriptionRetryPolicy")?.let {
            unsubscriptionRetryPolicy = SubscriptionRetryPolicyParam(it as Map<String, Any?>)
        }
        value.getValue("wakeLockTimeout")?.let {
            wakeLockTimeout = it as Int
        }
        value.getValue("pingSender")?.let {
            pingSender = WorkManagerPingSenderConfigParam(it as Map<String, Any?>)
        }
        value.getValue("experimentConfig")?.let {
            experimentConfig = ExperimentConfigParam(it as Map<String, Any?>)
        }
        value.getValue("useInterceptor")?.let {
            useInterceptor = it as Boolean
        }
    }

    override fun build(context: Context, logger: Listener): MqttV3Configuration {
        return MqttV3Configuration(
            logger = logger.getLogger("Courier"),
            eventHandler = logger.eventHandler,
            authFailureHandler = logger.authFailureHandler, // redundant di on event?
            connectTimeoutPolicy = connectTimeoutPolicy?.build(context, logger) ?: ConnectTimeoutPolicy(ConnectTimeoutConfig()),
            authenticator = object : Authenticator {
                override fun authenticate(
                    connectOptions: MqttConnectOptions,
                    forceRefresh: Boolean
                ): MqttConnectOptions {
                    return connectOptions
                }
            },
            mqttInterceptorList = if (useInterceptor) listOf(
                MqttChuckInterceptor(
                    context,
                    MqttChuckConfig(retentionPeriod = Period.ONE_HOUR)
                )
            ) else emptyList(),
            persistenceOptions = PersistenceOptions.PahoPersistenceOptions(100, false),
            experimentConfigs = experimentConfig?.build(context, logger) ?: ExperimentConfigs(),
            unsubscriptionRetryPolicy = unsubscriptionRetryPolicy?.build(context, logger) ?: SubscriptionRetryPolicy(SubscriptionRetryConfig()),
            wakeLockTimeout = wakeLockTimeout ?: DefaultConstants.DEFAULT_WAKELOCK_TIMEOUT,
            socketFactory = null,
            pingSender = WorkPingSenderFactory.createMqttPingSender(
                context,
                pingSender?.build(context, logger) ?: WorkManagerPingSenderConfig(
                    timeoutSeconds = DefaultConstants.DEFAULT_PING_TIMEOUT_SECS
                )
            ),
            subscriptionRetryPolicy = subscriptionRetryPolicy?.build(context, logger) ?: SubscriptionRetryPolicy(SubscriptionRetryConfig()),
            connectRetryTimePolicy = connectRetryTimePolicy?.build(context, logger) ?: ConnectRetryTimePolicy(ConnectRetryTimeConfig()),
        )
    }
}

class ExperimentConfigParam(value: Map<String, Any?>): Param<ExperimentConfigs>(value)  {
    var isPersistentSubscriptionStoreEnabled: Boolean? = null
    var adaptiveKeepAliveConfig: AdaptiveKeepAliveConfigParam? = null

    init {
        value.getValue("isPersistentSubscriptionStoreEnabled")?.let {
            isPersistentSubscriptionStoreEnabled = it as Boolean
        }
        value.getValue("adaptiveKeepAliveConfig")?.let {
            adaptiveKeepAliveConfig = AdaptiveKeepAliveConfigParam(it as Map<String, Any?>)
        }
    }

    override fun build(context: Context, logger: Listener): ExperimentConfigs? {
        return ExperimentConfigs(
            isPersistentSubscriptionStoreEnabled = isPersistentSubscriptionStoreEnabled ?: true
        )
    }
}

class AdaptiveKeepAliveConfigParam(value: Map<String, Any?>): Param<AdaptiveKeepAliveConfig>(value)  {
    var lowerBoundMinutes: Int? = null
    var upperBoundMinutes: Int? = null
    var stepMinutes: Int? = null
    var optimalKeepAliveResetLimit : Int? = null
    var pingSender: WorkManagerPingSenderConfigParam? = null
    var activityCheckIntervalSeconds : Int? = null
    var inactivityTimeoutSeconds : Int? = null
    var policyResetTimeSeconds : Int? = null
    var incomingMessagesTTLSecs : Int? = null
    var incomingMessagesCleanupIntervalSecs : Int? = null

    init {
        value.getValue("lowerBoundMinutes")?.let {
            lowerBoundMinutes = it as Int
        }
        value.getValue("upperBoundMinutes")?.let {
            upperBoundMinutes = it as Int
        }
        value.getValue("stepMinutes")?.let {
            stepMinutes = it as Int
        }
        value.getValue("optimalKeepAliveResetLimit")?.let {
            optimalKeepAliveResetLimit = it as Int
        }
        value.getValue("activityCheckIntervalSeconds")?.let {
            activityCheckIntervalSeconds = it as Int
        }
        value.getValue("inactivityTimeoutSeconds")?.let {
            inactivityTimeoutSeconds = it as Int
        }
        value.getValue("policyResetTimeSeconds")?.let {
            policyResetTimeSeconds = it as Int
        }
        value.getValue("incomingMessagesTTLSecs")?.let {
            incomingMessagesTTLSecs = it as Int
        }
        value.getValue("incomingMessagesCleanupIntervalSecs")?.let {
            incomingMessagesCleanupIntervalSecs = it as Int
        }
        value.getValue("pingSender")?.let {
            pingSender = WorkManagerPingSenderConfigParam(it as Map<String, Any?>)
        }
    }

    override fun build(context: Context, logger: Listener): AdaptiveKeepAliveConfig {
        return AdaptiveKeepAliveConfig(
            lowerBoundMinutes = lowerBoundMinutes ?: 0,
            upperBoundMinutes = upperBoundMinutes ?: 0,
            stepMinutes = stepMinutes ?: 2,
            optimalKeepAliveResetLimit = optimalKeepAliveResetLimit ?: 10,
            pingSender = WorkPingSenderFactory.createAdaptiveMqttPingSender(
                context,
                WorkManagerPingSenderConfig(
                    timeoutSeconds = pingSender?.timeoutSeconds ?: DefaultConstants.DEFAULT_PING_TIMEOUT_SECS
                )
            )
        )
    }
}

class WorkManagerPingSenderConfigParam(value: Map<String, Any?>): Param<WorkManagerPingSenderConfig>(value)  {
    var timeoutSeconds: Long? = null

    init {
        value.getValue("timeoutSeconds")?.let {
            timeoutSeconds = it as Long
        }
    }

    override fun build(context: Context, logger: Listener): WorkManagerPingSenderConfig {
        return WorkManagerPingSenderConfig(
            timeoutSeconds = timeoutSeconds ?: DefaultConstants.DEFAULT_PING_TIMEOUT_SECS
        )
    }
}

class SubscriptionRetryPolicyParam(value: Map<String, Any?>): Param<SubscriptionRetryPolicy>(value) {
    var maxRetryCount: Int? = null

    init {
        value.getValue("maxRetryCount")?.let {
            maxRetryCount = it as Int
        }
    }

    override fun build(context: Context, logger: Listener): SubscriptionRetryPolicy {
        return SubscriptionRetryPolicy(
            SubscriptionRetryConfig(
            maxRetryCount ?: SubscriptionRetryConfig.DEFAULT_MAX_RETRY_COUNT
        )
        )
    }
}

class ConnectTimeoutPolicyParam(value: Map<String, Any?>): Param<ConnectTimeoutPolicy>(value) {
    var sslHandshakeTimeOut: Int? = null
    var sslUpperBoundConnTimeOut: Int? = null
    var upperBoundConnTimeOut: Int? = null

    init {
        value.getValue("sslHandshakeTimeOut")?.let {
            sslHandshakeTimeOut = it as Int
        }
        value.getValue("sslUpperBoundConnTimeOut")?.let {
            sslUpperBoundConnTimeOut = it as Int
        }
        value.getValue("upperBoundConnTimeOut")?.let {
            upperBoundConnTimeOut = it as Int
        }
    }

    override fun build(context: Context, logger: Listener): ConnectTimeoutPolicy {
        return ConnectTimeoutPolicy(
            ConnectTimeoutConfig(
                sslHandshakeTimeOut ?: ConnectTimeoutConfig.SSL_HANDSHAKE_TIMEOUT,
                sslUpperBoundConnTimeOut ?: ConnectTimeoutConfig.UPPER_BOUND_CONN_TIMEOUT_SSL,
                upperBoundConnTimeOut ?: ConnectTimeoutConfig.UPPER_BOUND_CONN_TIMEOUT
            )
        )
    }
}

class ConnectRetryTimePolicyParam(value: Map<String, Any?>): Param<ConnectRetryTimePolicy>(value) {
    var maxRetryCount: Int? = null
    var reconnectTimeFixed: Int? = null
    var reconnectTimeRandom: Int? = null
    var maxReconnectTime: Int? = null

    init {
        value.getValue("maxRetryCount")?.let {
            maxRetryCount = it as Int
        }
        value.getValue("reconnectTimeFixed")?.let {
            reconnectTimeFixed = it as Int
        }
        value.getValue("reconnectTimeRandom")?.let {
            reconnectTimeRandom = it as Int
        }
        value.getValue("maxReconnectTime")?.let {
            maxReconnectTime = it as Int
        }
    }

    override fun build(context: Context, listener: Listener): ConnectRetryTimePolicy {
        return ConnectRetryTimePolicy(
            ConnectRetryTimeConfig(
                maxRetryCount ?: ConnectRetryTimeConfig.MAX_RETRY_COUNT_DEFAULT,
                reconnectTimeFixed ?: ConnectRetryTimeConfig.RECONNECT_TIME_FIXED_DEFAULT,
                reconnectTimeRandom ?: ConnectRetryTimeConfig.RECONNECT_TIME_RANDOM_DEFAULT,
                maxReconnectTime ?: ConnectRetryTimeConfig.MAX_RECONNECT_TIME_DEFAULT
            )
        )
    }
}

