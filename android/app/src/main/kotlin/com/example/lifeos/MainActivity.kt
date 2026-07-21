package com.example.lifeos

import android.app.NotificationManager
import android.content.Context
import android.content.Intent
import android.provider.Settings
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

/**
 * Thin platform channel for Do Not Disturb control during an active Focus
 * session — Android exposes DND toggling only through
 * NotificationManager.setInterruptionFilter, which requires the user to
 * have granted Notification Policy Access (a settings-screen grant, not a
 * runtime permission dialog). There is no legitimate third-party API for
 * the separate Digital Wellbeing "Focus Mode" — this channel intentionally
 * only ever touches DND, never claims to control that.
 */
class MainActivity : FlutterActivity() {
    private val channelName = "com.lifeos/dnd"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        val notificationManager =
            getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channelName).setMethodCallHandler { call, result ->
            when (call.method) {
                "isPolicyAccessGranted" -> {
                    result.success(notificationManager.isNotificationPolicyAccessGranted)
                }
                "openPolicyAccessSettings" -> {
                    startActivity(
                        Intent(Settings.ACTION_NOTIFICATION_POLICY_ACCESS_SETTINGS)
                            .addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                    )
                    result.success(null)
                }
                "getInterruptionFilter" -> {
                    result.success(notificationManager.currentInterruptionFilter)
                }
                "setInterruptionFilter" -> {
                    if (!notificationManager.isNotificationPolicyAccessGranted) {
                        result.error("POLICY_ACCESS_DENIED", "Notification policy access not granted", null)
                        return@setMethodCallHandler
                    }
                    val filter = call.argument<Int>("filter")
                    if (filter == null) {
                        result.error("INVALID_ARGUMENT", "filter is required", null)
                        return@setMethodCallHandler
                    }
                    notificationManager.setInterruptionFilter(filter)
                    result.success(null)
                }
                else -> result.notImplemented()
            }
        }
    }
}
