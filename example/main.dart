import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sandbox_digilocker_sdk/sandbox_digilocker_sdk.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Digilocker SDK Example')),
        body: Center(
          child: Builder(
            builder: (BuildContext context) {
              return ElevatedButton(
                onPressed: () {
                  DigilockerSDK.instance.setAPIKey('key_live_350507e24fd.....');
                  DigilockerSDK.instance.setEventListener(SDKEventListener());
                  DigilockerSDK.instance.open(
                    context: context,
                    options: {
                      'session_id': '6b0c94d2-7c87-4d21-....',
                      'brand': {
                        'name': 'MoneyApp',
                        'logo_url': 'https://i.imgur.com/vMd9Wcu.png',
                      },
                      'theme': {'mode': 'light', 'seed': '#3D6838'},
                    },
                  );
                },
                child: const Text('Open Digilocker'),
              );
            },
          ),
        ),
      ),
    );
  }
}

class SDKEventListener implements EventListener {
  @override
  void onEvent(Map<String, dynamic> event) {
    if (kDebugMode) {
      print('Received event: $event');
    }
  }
}
