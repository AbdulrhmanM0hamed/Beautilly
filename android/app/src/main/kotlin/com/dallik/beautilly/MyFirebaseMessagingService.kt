package com.dallik.beautilly.services

import com.google.firebase.messaging.FirebaseMessagingService
import com.google.firebase.messaging.RemoteMessage

class MyFirebaseMessagingService : FirebaseMessagingService() {
    override fun onMessageReceived(remoteMessage: RemoteMessage) {
        super.onMessageReceived(remoteMessage)
        // معالجة الإشعارات
    }

    override fun onNewToken(token: String) {
        super.onNewToken(token)
        // معالجة التوكن الجديد
    }
} 