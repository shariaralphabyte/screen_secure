# Changelog
## 1.0.3

### Added
- Initial release of screen_secure plugin
- Screenshot blocking for Android using FLAG_SECURE
- Screen recording detection and blocking for iOS
- Cross-platform initialization with customizable options
- Dynamic enable/disable functionality for both features
- Real-time screen recording detection callbacks (iOS)
- Comprehensive error handling with custom exceptions
- Complete example app demonstrating all features
- Extensive documentation and API reference

### Features
- ✅ Android screenshot and screen recording protection
- ✅ iOS screen recording detection with overlay warnings
- ✅ One-line initialization: `ScreenSecure.init()`
- ✅ Runtime control of security features
- ✅ Professional error handling
- ✅ Platform-specific optimizations
## 1.0.0

### Added
- Initial release of screen_secure plugin
- Screenshot blocking for Android using FLAG_SECURE
- Screen recording detection and blocking for iOS
- Cross-platform initialization with customizable options
- Dynamic enable/disable functionality for both features
- Real-time screen recording detection callbacks (iOS)
- Comprehensive error handling with custom exceptions
- Complete example app demonstrating all features
- Extensive documentation and API reference

### Features
- ✅ Android screenshot and screen recording protection
- ✅ iOS screen recording detection with overlay warnings
- ✅ One-line initialization: `ScreenSecure.init()`
- ✅ Runtime control of security features
- ✅ Professional error handling
- ✅ Platform-specific optimizations

### Platform Support
- Android API 16+
- iOS 11.0+

### API Reference
- `init()` - Initialize with custom options
- `enableScreenshotBlock()` - Enable screenshot protection
- `disableScreenshotBlock()` - Disable screenshot protection
- `enableScreenRecordBlock()` - Enable screen recording protection
- `disableScreenRecordBlock()` - Disable screen recording protection
- `isScreenRecording()` - Check current recording status (iOS)
- `getSecurityStatus()` - Get comprehensive security status
- `setScreenRecordingCallback()` - Set up real-time callbacks