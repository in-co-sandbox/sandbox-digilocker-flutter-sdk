# Sandbox Digilocker Flutter SDK

A Flutter SDK that provides an embedded Digilocker integration in your app. This SDK allows you to integrate Sandbox's Digilocker SDK seamlessly into your Flutter applications.

## Features

- **Embedded Digilocker Solution**: Integrate Digilocker directly into your app
- **Event Handling**: Listen to SDK events for real-time updates
- **Customizable Theme**: Support for light/dark themes with custom color schemes
- **API Key Authentication**: Secure authentication using API keys

## Installation

Add the Sandbox Digilocker SDK to your `pubspec.yaml`:

```yaml
dependencies:
  sandbox_digilocker_sdk: ^1.0.0-alpha
```

## Usage

1. **Import the SDK**:
```dart
import 'package:sandbox_digilocker_sdk/sandbox_digilocker_sdk.dart';
```

2. **Set your API Key**:
```dart
DigilockerSDK.instance.setAPIKey('key_your_api_key_here');
```

3. **Open the SDK**:
```dart
await DigilockerSDK.instance.open(
  context: context,
  options: {
        "session_id": "a7fac865-61a9-4589-b80c....",
        "brand": {
            "name": "MoneyApp",
            "logo_url": "https://example.com/your_logo"
        },
        "theme": {
            "mode": "light",
            "seed": "#3D6838"
        }
    },
);
```

## Example

```dart
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
                        'name': "Quicko",
                        'logo_url': "https://cdn.your_logo.svg/",
                      },
                      'theme': {'mode': 'light', 'seed': '#2962FF'},
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

```

## API Reference

### DigilockerSDK

The main SDK class that provides a singleton instance for managing interactions.

#### Methods

##### `setAPIKey(String apiKey)`
Sets the API key required to authenticate requests.

**Parameters:**
- `apiKey` (String): The API key string starting with "key_"

**Throws:** Exception if the API key does not start with "key_"

##### `open({required BuildContext context, required Map<String, dynamic> options})`
Opens the SDK UI to perform various operations based on provided options.

**Parameters:**
- `context` (BuildContext): The BuildContext from which the SDK is accessed
- `options` (Map<String, dynamic>): A map containing various options such as intent

**Throws:** Exception if API key or required options are not set

##### `setEventListener(EventListener eventListener)`
Registers an event listener to receive SDK events.

**Parameters:**
- `eventListener` (EventListener): The event listener to register

### EventListener

Interface for receiving SDK events.

#### Methods

##### `onEvent(Map<String, dynamic> event)`
Called when an SDK event occurs.

**Parameters:**
- `event` (Map<String, dynamic>): The event data

## Configuration Options

The SDK accepts various configuration options when opening:

#### `session_id` (string, required)
Unique session ID generated when the **Create Session API** is called.  
Example: `a7fac865-61a9-4589-b80c....`

---

#### `brand` (object, required)
Configuration for branding displayed in the DigiLocker interface.

**Child attributes:**

- **`name`** (string, required)  
  Display name of your business or app shown during the DigiLocker flow.

- **`logo_url`** (string, required)  
  Publicly accessible HTTPS URL of your logo displayed within the SDK.

---

#### `theme` (object, required)
Appearance configuration for the SDK.

**Child attributes:**

- **`mode`** (string, required)  
  Sets the overall appearance of the SDK. Accepts `"light"` or `"dark"`.

- **`seed`** (string, required)  
  Primary brand color used in the SDK interface. Accepts a hex code.

## Requirements

- Flutter SDK: ^3.8.1
- Flutter: >=1.17.0

## Getting Help

For more information about Sandbox API's services, visit:
- **Homepage**: https://sandbox.co.in
- **Demo**: https://demo.sandbox.co.in/kyc/digilocker
- **Documentation**: https://developer.sandbox.co.in

## License

This project is licensed under the terms specified in the LICENSE file.

## Changelog

See [CHANGELOG.md](CHANGELOG.md) for a list of changes and version history.
