import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'screen_secure_platform_interface.dart';

/// An implementation of [ScreenSecurePlatform] that uses method channels.
class MethodChannelScreenSecure extends ScreenSecurePlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('screen_secure');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
