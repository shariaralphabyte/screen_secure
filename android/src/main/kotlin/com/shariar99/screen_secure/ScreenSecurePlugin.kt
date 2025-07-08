package com.shariar99.screen_secure

import android.app.Activity
import android.view.WindowManager
import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

class ScreenSecurePlugin: FlutterPlugin, MethodCallHandler, ActivityAware {
  private lateinit var channel: MethodChannel
  private var activity: Activity? = null
  private var isScreenshotBlocked = false
  private var isScreenRecordBlocked = false

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "screen_secure")
    channel.setMethodCallHandler(this)
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    when (call.method) {
      "init" -> {
        val screenshotBlock = call.argument<Boolean>("screenshotBlock") ?: true
        val screenRecordBlock = call.argument<Boolean>("screenRecordBlock") ?: true
        initScreenSecure(screenshotBlock, screenRecordBlock, result)
      }
      "enableScreenshotBlock" -> enableScreenshotBlock(result)
      "disableScreenshotBlock" -> disableScreenshotBlock(result)
      "enableScreenRecordBlock" -> enableScreenRecordBlock(result)
      "disableScreenRecordBlock" -> disableScreenRecordBlock(result)
      "isScreenRecording" -> result.success(false) // Android doesn't have native detection
      "getSecurityStatus" -> getSecurityStatus(result)
      else -> result.notImplemented()
    }
  }

  private fun initScreenSecure(screenshotBlock: Boolean, screenRecordBlock: Boolean, result: Result) {
    try {
      if (screenshotBlock) {
        enableScreenshotProtection()
      }
      if (screenRecordBlock) {
        enableScreenRecordProtection()
      }
      result.success(true)
    } catch (e: Exception) {
      result.error("INIT_ERROR", "Failed to initialize screen security", e.message)
    }
  }

  private fun enableScreenshotBlock(result: Result) {
    try {
      enableScreenshotProtection()
      result.success(true)
    } catch (e: Exception) {
      result.error("ENABLE_ERROR", "Failed to enable screenshot block", e.message)
    }
  }

  private fun disableScreenshotBlock(result: Result) {
    try {
      disableScreenshotProtection()
      result.success(true)
    } catch (e: Exception) {
      result.error("DISABLE_ERROR", "Failed to disable screenshot block", e.message)
    }
  }

  private fun enableScreenRecordBlock(result: Result) {
    try {
      enableScreenRecordProtection()
      result.success(true)
    } catch (e: Exception) {
      result.error("ENABLE_ERROR", "Failed to enable screen record block", e.message)
    }
  }

  private fun disableScreenRecordBlock(result: Result) {
    try {
      disableScreenRecordProtection()
      result.success(true)
    } catch (e: Exception) {
      result.error("DISABLE_ERROR", "Failed to disable screen record block", e.message)
    }
  }

  private fun getSecurityStatus(result: Result) {
    val status = mapOf(
      "screenshotBlocked" to isScreenshotBlocked,
      "screenRecordBlocked" to isScreenRecordBlocked,
      "platform" to "android"
    )
    result.success(status)
  }

  private fun enableScreenshotProtection() {
    activity?.window?.setFlags(
      WindowManager.LayoutParams.FLAG_SECURE,
      WindowManager.LayoutParams.FLAG_SECURE
    )
    isScreenshotBlocked = true
  }

  private fun disableScreenshotProtection() {
    activity?.window?.clearFlags(WindowManager.LayoutParams.FLAG_SECURE)
    isScreenshotBlocked = false
  }

  private fun enableScreenRecordProtection() {
    // On Android, FLAG_SECURE also prevents screen recording
    enableScreenshotProtection()
    isScreenRecordBlocked = true
  }

  private fun disableScreenRecordProtection() {
    // On Android, screen recording protection is tied to screenshot protection
    if (!isScreenshotBlocked) {
      disableScreenshotProtection()
    }
    isScreenRecordBlocked = false
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    activity = binding.activity
  }

  override fun onDetachedFromActivityForConfigChanges() {
    activity = null
  }

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    activity = binding.activity
  }

  override fun onDetachedFromActivity() {
    activity = null
  }
}