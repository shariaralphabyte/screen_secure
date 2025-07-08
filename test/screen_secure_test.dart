import 'package:flutter_test/flutter_test.dart';
import 'package:screen_secure/screen_secure.dart';
import 'package:screen_secure/screen_secure_platform_interface.dart';
import 'package:screen_secure/screen_secure_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockScreenSecurePlatform
    with MockPlatformInterfaceMixin
    implements ScreenSecurePlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final ScreenSecurePlatform initialPlatform = ScreenSecurePlatform.instance;

  test('$MethodChannelScreenSecure is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelScreenSecure>());
  });

  test('getPlatformVersion', () async {
    ScreenSecure screenSecurePlugin = ScreenSecure();
    MockScreenSecurePlatform fakePlatform = MockScreenSecurePlatform();
    ScreenSecurePlatform.instance = fakePlatform;

    expect(await screenSecurePlugin.getPlatformVersion(), '42');
  });
}
