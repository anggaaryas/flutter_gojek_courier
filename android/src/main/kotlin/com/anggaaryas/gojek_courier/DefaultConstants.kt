package com.anggaaryas.gojek_courier

class DefaultConstants {


    companion object{
        const val MQTT_WAIT_BEFORE_RECONNECT_TIME_MS = 10L

        const val MAX_INFLIGHT_MESSAGES_ALLOWED = 100

        const val MSG_APP_PUBLISH = 4
        const val MESSAGE = "msg"

        const val SERVER_UNAVAILABLE_MAX_CONNECT_TIME = 9 /* 9 minutes */

        const val UNRESOLVED_EXCEPTION = "unresolved"

        /*
             * When disconnecting (forcibly) it might happen that some messages
             * are waiting for acks or delivery. So before disconnecting,
             * wait for this time to let mqtt finish the work and
             * then disconnect w/o letting more msgs to come in.
             */
        const val QUIESCE_TIME_MILLIS = 500 // 500 milliseconds

        const val DISCONNECT_TIMEOUT_MILLIS = 1000 // 1 seconds (2 * QUIESCE_TIME_MILLS)

        const val DEFAULT_WAKELOCK_TIMEOUT = 0

        const val DEFAULT_ACTIVITY_CHECK_INTERVAL_SECS = 62

        const val DEFAULT_INACTIVITY_TIMEOUT_SECS = 60

        const val DEFAULT_POLICY_RESET_TIME_SECS = 300

        const val DEFAULT_PING_TIMEOUT_SECS = 30L
    }

}