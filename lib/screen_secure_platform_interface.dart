import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'screen_secure_method_channel.dart';

abstract class ScreenSecurePlatform extends PlatformInterface {
  /// Constructs a ScreenSecurePlatform.
  ScreenSecurePlatform() : super(token: _token);

  static final Object _token = Object();

  static ScreenSecurePlatform _instance = MethodChannelScreenSecure();

  /// The default instance of [ScreenSecurePlatform] to use.
  ///
  /// Defaults to [MethodChannelScreenSecure].
  static ScreenSecurePlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [ScreenSecurePlatform] when
  /// they register themselves.
  static set instance(ScreenSecurePlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
