# Screen Secure 🔐

[![pub package](https://img.shields.io/pub/v/screen_secure.svg)](https://pub.dev/packages/screen_secure)
[![GitHub](https://img.shields.io/github/license/shariaralphabyte/screen_secure)](https://github.com/shariaralphabyte/screen_secure/blob/main/LICENSE)
[![Platform](https://img.shields.io/badge/platform-Android%20%7C%20iOS-blue.svg)](https://pub.dev/packages/screen_secure)
[![Build Status](https://github.com/shariaralphabyte/screen_secure/workflows/CI/badge.svg)](https://github.com/shariaralphabyte/screen_secure/actions)

A powerful Flutter plugin for comprehensive screen security features including screenshot and screen recording protection across Android and iOS platforms.

## ✨ Features

🔐 **Cross-platform screen security**
- **Android**: Uses `FLAG_SECURE` to block screenshots and screen recordings
- **iOS**: Detects screen recording and overlays a secure warning screen

⚡ **Simple Integration**
- One-line initialization with customizable options
- Dynamic enable/disable functionality at runtime
- Real-time screen recording detection callbacks

🎯 **Professional Grade**
- Comprehensive error handling with custom exceptions
- Platform-specific optimizations
- Extensive documentation and examples

## 📱 Platform Support

| Platform | Screenshot Block | Screen Record Block | Real-time Detection | Min Version |
|----------|------------------|---------------------|---------------------|-------------|
| Android  | ✅               | ✅                   | ❌                   | API 16+     |
| iOS      | ✅               | ✅                   | ✅                   | iOS 11.0+   |

## 🚀 Quick Start

### Installation

Add this to your `pubspec.yaml`:

```yaml
dependencies:
  screen_secure: ^1.0.1
```

Run:
```bash
flutter pub get
```

### Basic Usage

```dart
import 'package:screen_secure/screen_secure.dart';

// Initialize with both features enabled
await ScreenSecure.init(
  screenshotBlock: true,
  screenRecordBlock: true,
);
```

That's it! Your app is now protected from screenshots and screen recordings.

## 📋 Usage Examples

### Complete Implementation

```dart
import 'package:flutter/material.dart';
import 'package:screen_secure/screen_secure.dart';

class MySecureApp extends StatefulWidget {
  @override
  _MySecureAppState createState() => _MySecureAppState();
}

class _MySecureAppState extends State<MySecureApp> {
  bool _isRecording = false;
  Map<String, dynamic> _securityStatus = {};

  @override
  void initState() {
    super.initState();
    _initializeScreenSecure();
    _setupScreenRecordingCallback();
  }

  Future<void> _initializeScreenSecure() async {
    try {
      // Initialize with custom settings
      await ScreenSecure.init(
        screenshotBlock: true,
        screenRecordBlock: true,
      );
      
      // Get current status
      final status = await ScreenSecure.getSecurityStatus();
      setState(() {
        _securityStatus = status;
      });
      
      print('Screen security initialized successfully');
    } on ScreenSecureException catch (e) {
      print('Failed to initialize screen security: ${e.message}');
    }
  }

  void _setupScreenRecordingCallback() {
    // Set up callback for real-time screen recording detection (iOS)
    ScreenSecure.setScreenRecordingCallback((isRecording) {
      setState(() {
        _isRecording = isRecording;
      });
      
      if (isRecording) {
        // Handle screen recording started
        _showRecordingAlert();
      } else {
        // Handle screen recording stopped
        print('Screen recording stopped');
      }
    });
  }

  void _showRecordingAlert() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.warning, color: Colors.red),
            SizedBox(width: 8),
            Text('Security Alert'),
          ],
        ),
        content: Text(
          'Screen recording has been detected. For security reasons, '
          'sensitive content may be hidden.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Secure App'),
        backgroundColor: _isRecording ? Colors.red : Colors.blue,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Security Status Card
            Card(
              elevation: 4,
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Security Status',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 12),
                    _buildStatusRow(
                      'Screenshot Protection',
                      _securityStatus['screenshotBlocked'] ?? false,
                    ),
                    _buildStatusRow(
                      'Screen Record Protection',
                      _securityStatus['screenRecordBlocked'] ?? false,
                    ),
                    _buildStatusRow(
                      'Currently Recording',
                      _isRecording,
                      isWarning: _isRecording,
                    ),
                  ],
                ),
              ),
            ),
            
            SizedBox(height: 24),
            
            // Control Buttons
            Text(
              'Security Controls',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            
            ElevatedButton.icon(
              onPressed: _toggleScreenshotProtection,
              icon: Icon(Icons.screenshot_monitor),
              label: Text('Toggle Screenshot Protection'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 12),
              ),
            ),
            
            SizedBox(height: 8),
            
            ElevatedButton.icon(
              onPressed: _toggleScreenRecordProtection,
              icon: Icon(Icons.videocam_off),
              label: Text('Toggle Screen Record Protection'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 12),
              ),
            ),
            
            SizedBox(height: 8),
            
            OutlinedButton.icon(
              onPressed: _checkSecurityStatus,
              icon: Icon(Icons.refresh),
              label: Text('Refresh Status'),
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 12),
              ),
            ),
            
            SizedBox(height: 24),
            
            // Sensitive Content Area
            Card(
              color: _isRecording ? Colors.red.shade50 : Colors.green.shade50,
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Icon(
                      _isRecording ? Icons.visibility_off : Icons.lock,
                      size: 48,
                      color: _isRecording ? Colors.red : Colors.green,
                    ),
                    SizedBox(height: 8),
                    Text(
                      _isRecording 
                        ? 'Sensitive content hidden due to screen recording'
                        : 'Sensitive content visible - Screen is secure',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: _isRecording ? Colors.red : Colors.green,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusRow(String label, bool isEnabled, {bool isWarning = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Row(
            children: [
              Icon(
                isEnabled ? Icons.check_circle : Icons.cancel,
                color: isWarning 
                  ? Colors.orange 
                  : (isEnabled ? Colors.green : Colors.grey),
                size: 20,
              ),
              SizedBox(width: 4),
              Text(
                isEnabled ? 'Active' : 'Inactive',
                style: TextStyle(
                  color: isWarning 
                    ? Colors.orange 
                    : (isEnabled ? Colors.green : Colors.grey),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _toggleScreenshotProtection() async {
    try {
      final isEnabled = _securityStatus['screenshotBlocked'] ?? false;
      
      if (isEnabled) {
        await ScreenSecure.disableScreenshotBlock();
      } else {
        await ScreenSecure.enableScreenshotBlock();
      }
      
      _checkSecurityStatus();
    } on ScreenSecureException catch (e) {
      _showErrorSnackBar('Failed to toggle screenshot protection: ${e.message}');
    }
  }

  Future<void> _toggleScreenRecordProtection() async {
    try {
      final isEnabled = _securityStatus['screenRecordBlocked'] ?? false;
      
      if (isEnabled) {
        await ScreenSecure.disableScreenRecordBlock();
      } else {
        await ScreenSecure.enableScreenRecordBlock();
      }
      
      _checkSecurityStatus();
    } on ScreenSecureException catch (e) {
      _showErrorSnackBar('Failed to toggle screen record protection: ${e.message}');
    }
  }

  Future<void> _checkSecurityStatus() async {
    try {
      final status = await ScreenSecure.getSecurityStatus();
      setState(() {
        _securityStatus = status;
      });
    } on ScreenSecureException catch (e) {
      _showErrorSnackBar('Failed to get security status: ${e.message}');
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }
}
```

### Simple Usage Examples

#### Basic initialization:
```dart
// Enable both features
await ScreenSecure.init();

// Enable only screenshot protection
await ScreenSecure.init(
  screenshotBlock: true,
  screenRecordBlock: false,
);
```

#### Individual control:
```dart
// Enable screenshot protection
await ScreenSecure.enableScreenshotBlock();

// Disable screenshot protection
await ScreenSecure.disableScreenshotBlock();

// Enable screen recording protection
await ScreenSecure.enableScreenRecordBlock();

// Disable screen recording protection
await ScreenSecure.disableScreenRecordBlock();
```

#### Status monitoring:
```dart
// Get current security status
final status = await ScreenSecure.getSecurityStatus();
print('Screenshot blocked: ${status['screenshotBlocked']}');
print('Screen record blocked: ${status['screenRecordBlocked']}');
print('Platform: ${status['platform']}');

// Check if currently recording (iOS only)
final isRecording = await ScreenSecure.isScreenRecording();
print('Currently recording: $isRecording');
```

#### Real-time callbacks:
```dart
// Set up screen recording detection callback
ScreenSecure.setScreenRecordingCallback((isRecording) {
  if (isRecording) {
    print('Screen recording started!');
    // Hide sensitive content
    // Show warning to user
  } else {
    print('Screen recording stopped!');
    // Show sensitive content again
  }
});
```

## 📖 API Reference

### Core Methods

#### `init()`
Initialize screen security with options.

```dart
static Future<bool> init({
  bool screenshotBlock = true,
  bool screenRecordBlock = true,
}) async
```

**Parameters:**
- `screenshotBlock`: Enable screenshot protection (default: true)
- `screenRecordBlock`: Enable screen recording protection (default: true)

**Returns:** `Future<bool>` - Success status

**Throws:** `ScreenSecureException` on failure

---

#### `enableScreenshotBlock()`
Enable screenshot protection.

```dart
static Future<bool> enableScreenshotBlock() async
```

**Returns:** `Future<bool>` - Success status

**Throws:** `ScreenSecureException` on failure

---

#### `disableScreenshotBlock()`
Disable screenshot protection.

```dart
static Future<bool> disableScreenshotBlock() async
```

**Returns:** `Future<bool>` - Success status

**Throws:** `ScreenSecureException` on failure

---

#### `enableScreenRecordBlock()`
Enable screen recording protection.

```dart
static Future<bool> enableScreenRecordBlock() async
```

**Returns:** `Future<bool>` - Success status

**Throws:** `ScreenSecureException` on failure

---

#### `disableScreenRecordBlock()`
Disable screen recording protection.

```dart
static Future<bool> disableScreenRecordBlock() async
```

**Returns:** `Future<bool>` - Success status

**Throws:** `ScreenSecureException` on failure

---

#### `isScreenRecording()`
Check if screen recording is currently active (iOS only).

```dart
static Future<bool> isScreenRecording() async
```

**Returns:** `Future<bool>` - Recording status

**Throws:** `ScreenSecureException` on failure

**Note:** Always returns `false` on Android

---

#### `getSecurityStatus()`
Get current security status.

```dart
static Future<Map<String, dynamic>> getSecurityStatus() async
```

**Returns:** `Future<Map<String, dynamic>>` with keys:
- `screenshotBlocked`: Boolean indicating screenshot protection status
- `screenRecordBlocked`: Boolean indicating screen recording protection status
- `platform`: String indicating platform ("android" or "ios")
- `isCurrentlyRecording`: Boolean indicating current recording status (iOS only)

**Throws:** `ScreenSecureException` on failure

---

#### `setScreenRecordingCallback()`
Set up callback for real-time screen recording detection.

```dart
static void setScreenRecordingCallback(Function(bool isRecording) callback)
```

**Parameters:**
- `callback`: Function called when screen recording status changes

**Note:** Only functional on iOS

### Exception Handling

The plugin provides custom exception handling through `ScreenSecureException`:

```dart
try {
  await ScreenSecure.init();
} on ScreenSecureException catch (e) {
  print('Screen security error: ${e.message}');
} catch (e) {
  print('Unexpected error: $e');
}
```

## 🔧 Platform-Specific Implementation

### Android Implementation

The Android implementation uses `WindowManager.LayoutParams.FLAG_SECURE` to prevent:
- Screenshots via system screenshot function
- Screen recordings via system screen recording
- Screenshots via accessibility services
- Content visibility in recent apps overview

```kotlin
// Enable protection
activity?.window?.setFlags(
    WindowManager.LayoutParams.FLAG_SECURE,
    WindowManager.LayoutParams.FLAG_SECURE
)

// Disable protection
activity?.window?.clearFlags(WindowManager.LayoutParams.FLAG_SECURE)
```

**Limitations:**
- No real-time detection of recording attempts
- Protection applies to entire activity window

### iOS Implementation

The iOS implementation provides:
- Screen recording detection via `UIScreen.capturedDidChangeNotification`
- Secure view overlay during recording
- Real-time callback notifications

```swift
// Enable screen recording detection
NotificationCenter.default.addObserver(
    self,
    selector: #selector(screenCaptureChanged),
    name: UIScreen.capturedDidChangeNotification,
    object: nil
)

// Check recording status
let isRecording = UIScreen.main.isCaptured
```

**Features:**
- Real-time screen recording detection
- Customizable warning overlays
- Callback-based notifications

## 🎯 Best Practices

### 1. Initialize Early
```dart
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: ScreenSecure.init(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return MaterialApp(/* your app */);
        }
        return CircularProgressIndicator();
      },
    );
  }
}
```

### 2. Handle Errors Gracefully
```dart
Future<void> initSecurityWithFallback() async {
  try {
    await ScreenSecure.init();
  } on ScreenSecureException catch (e) {
    // Log error but continue app execution
    print('Screen security not available: ${e.message}');
    // Optionally show user notification
  }
}
```

### 3. Responsive UI Based on Recording Status
```dart
Widget buildSensitiveContent() {
  return StreamBuilder<bool>(
    stream: _recordingStatusStream,
    builder: (context, snapshot) {
      final isRecording = snapshot.data ?? false;
      
      if (isRecording) {
        return _buildSecureOverlay();
      }
      
      return _buildSensitiveContent();
    },
  );
}
```

### 4. Conditional Feature Enabling
```dart
Future<void> setupPlatformSpecificSecurity() async {
  final status = await ScreenSecure.getSecurityStatus();
  final platform = status['platform'];
  
  if (platform == 'ios') {
    // Enable iOS-specific features
    ScreenSecure.setScreenRecordingCallback(_handleRecording);
  } else if (platform == 'android') {
    // Enable Android-specific features
    await ScreenSecure.enableScreenshotBlock();
  }
}
```

## 📋 Permissions

No additional permissions are required for this plugin. It uses only system-level APIs available to all apps.

## 🚀 Performance Considerations

- **Minimal overhead**: The plugin uses native platform APIs with negligible performance impact
- **Memory efficient**: No continuous monitoring or polling
- **Battery friendly**: Event-driven callbacks only when needed

## 🔍 Testing

### Unit Testing
```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:screen_secure/screen_secure.dart';

void main() {
  group('ScreenSecure Tests', () {
    test('init returns true on successful initialization', () async {
      final result = await ScreenSecure.init();
      expect(result, isTrue);
    });
    
    test('getSecurityStatus returns valid status', () async {
      final status = await ScreenSecure.getSecurityStatus();
      expect(status, isA<Map<String, dynamic>>());
      expect(status.containsKey('platform'), isTrue);
    });
  });
}
```

### Integration Testing
```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:screen_secure_example/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  
  group('Screen Security Integration Tests', () {
    testWidgets('App initializes with security enabled', (tester) async {
      app.main();
      await tester.pumpAndSettle();
      
      // Verify security status indicators
      expect(find.text('Screenshot Protection'), findsOneWidget);
      expect(find.text('Active'), findsWidgets);
    });
  });
}
```

## 🤝 Contributing

We welcome contributions! Please see our [Contributing Guide](CONTRIBUTING.md) for details.

### Development Setup

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Make your changes
4. Add tests for your changes
5. Ensure all tests pass (`flutter test`)
6. Commit your changes (`git commit -m 'Add amazing feature'`)
7. Push to the branch (`git push origin feature/amazing-feature`)
8. Open a Pull Request

### Code Style

- Follow [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style)
- Use meaningful variable and function names
- Add documentation for all public APIs
- Include examples in documentation

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 📞 Support


- **Examples**: [Example App](https://github.com/shariaralphabyte/screen_secure/tree/main/example)

## 🌟 Acknowledgments

- Flutter team for the excellent plugin architecture
- Android and iOS teams for providing robust security APIs
- Open source community for inspiration and feedback

## 📈 Changelog

See [CHANGELOG.md](CHANGELOG.md) for a detailed history of changes.

---

**Made with ❤️ by [Sharia Hossain](https://github.com/shariaralphabyte)**

*If you find this plugin helpful, please consider giving it a ⭐ on GitHub!*
