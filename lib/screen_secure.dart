import 'dart:async';
import 'package:flutter/services.dart';

/// A Flutter plugin for screen security features
class ScreenSecure {
  static const MethodChannel _channel = MethodChannel('screen_secure');

  /// Initialize screen security with options
  static Future<bool> init({
    bool screenshotBlock = true,
    bool screenRecordBlock = true,
  }) async {
    try {
      final bool result = await _channel.invokeMethod('init', {
        'screenshotBlock': screenshotBlock,
        'screenRecordBlock': screenRecordBlock,
      });
      return result;
    } on PlatformException catch (e) {
      throw ScreenSecureException('Failed to initialize: ${e.message}');
    }
  }

  /// Enable screenshot blocking
  static Future<bool> enableScreenshotBlock() async {
    try {
      return await _channel.invokeMethod('enableScreenshotBlock');
    } on PlatformException catch (e) {
      throw ScreenSecureException('Failed to enable screenshot block: ${e.message}');
    }
  }

  /// Disable screenshot blocking
  static Future<bool> disableScreenshotBlock() async {
    try {
      return await _channel.invokeMethod('disableScreenshotBlock');
    } on PlatformException catch (e) {
      throw ScreenSecureException('Failed to disable screenshot block: ${e.message}');
    }
  }

  /// Enable screen recording detection
  static Future<bool> enableScreenRecordBlock() async {
    try {
      return await _channel.invokeMethod('enableScreenRecordBlock');
    } on PlatformException catch (e) {
      throw ScreenSecureException('Failed to enable screen record block: ${e.message}');
    }
  }

  /// Disable screen recording detection
  static Future<bool> disableScreenRecordBlock() async {
    try {
      return await _channel.invokeMethod('disableScreenRecordBlock');
    } on PlatformException catch (e) {
      throw ScreenSecureException('Failed to disable screen record block: ${e.message}');
    }
  }

  /// Check if screen recording is currently active (iOS only)
  static Future<bool> isScreenRecording() async {
    try {
      return await _channel.invokeMethod('isScreenRecording');
    } on PlatformException catch (e) {
      throw ScreenSecureException('Failed to check screen recording: ${e.message}');
    }
  }

  /// Get current security status
  static Future<Map<String, dynamic>> getSecurityStatus() async {
    try {
      final Map<Object?, Object?> result = await _channel.invokeMethod('getSecurityStatus');
      return Map<String, dynamic>.from(result);
    } on PlatformException catch (e) {
      throw ScreenSecureException('Failed to get security status: ${e.message}');
    }
  }

  /// Set up screen recording detection callback (iOS)
  static void setScreenRecordingCallback(Function(bool isRecording) callback) {
    _channel.setMethodCallHandler((call) async {
      if (call.method == 'onScreenRecordingChanged') {
        final bool isRecording = call.arguments as bool;
        callback(isRecording);
      }
    });
  }
}

/// Custom exception for ScreenSecure operations
class ScreenSecureException implements Exception {
  final String message;
  ScreenSecureException(this.message);

  @override
  String toString() => 'ScreenSecureException: $message';
}