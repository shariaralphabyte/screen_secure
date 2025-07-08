import 'package:flutter/material.dart';
import 'package:screen_secure/screen_secure.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Screen Secure Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Screen Secure Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Map<String, dynamic> _securityStatus = {};
  bool _isRecording = false;

  @override
  void initState() {
    super.initState();
    _initializeScreenSecure();
    _setupScreenRecordingCallback();
  }

  Future<void> _initializeScreenSecure() async {
    try {
      await ScreenSecure.init(
        screenshotBlock: true,
        screenRecordBlock: true,
      );
      _updateSecurityStatus();
    } catch (e) {
      _showError('Failed to initialize: $e');
    }
  }

  void _setupScreenRecordingCallback() {
    ScreenSecure.setScreenRecordingCallback((isRecording) {
      setState(() {
        _isRecording = isRecording;
      });
    });
  }

  Future<void> _updateSecurityStatus() async {
    try {
      final status = await ScreenSecure.getSecurityStatus();
      setState(() {
        _securityStatus = status;
      });
    } catch (e) {
      _showError('Failed to get status: $e');
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Security Status',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    Text('Screenshot Blocked: ${_securityStatus['screenshotBlocked'] ?? 'Unknown'}'),
                    Text('Screen Record Blocked: ${_securityStatus['screenRecordBlocked'] ?? 'Unknown'}'),
                    Text('Platform: ${_securityStatus['platform'] ?? 'Unknown'}'),
                    if (_securityStatus['isCurrentlyRecording'] != null)
                      Text('Currently Recording: ${_securityStatus['isCurrentlyRecording']}'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            if (_isRecording)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.warning, color: Colors.red),
                    SizedBox(width: 8),
                    Text('Screen recording detected!'),
                  ],
                ),
              ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                await ScreenSecure.enableScreenshotBlock();
                _updateSecurityStatus();
              },
              child: const Text('Enable Screenshot Block'),
            ),
            ElevatedButton(
              onPressed: () async {
                await ScreenSecure.disableScreenshotBlock();
                _updateSecurityStatus();
              },
              child: const Text('Disable Screenshot Block'),
            ),
            ElevatedButton(
              onPressed: () async {
                await ScreenSecure.enableScreenRecordBlock();
                _updateSecurityStatus();
              },
              child: const Text('Enable Screen Record Block'),
            ),
            ElevatedButton(
              onPressed: () async {
                await ScreenSecure.disableScreenRecordBlock();
                _updateSecurityStatus();
              },
              child: const Text('Disable Screen Record Block'),
            ),
            ElevatedButton(
              onPressed: _updateSecurityStatus,
              child: const Text('Refresh Status'),
            ),
          ],
        ),
      ),
    );
  }
}