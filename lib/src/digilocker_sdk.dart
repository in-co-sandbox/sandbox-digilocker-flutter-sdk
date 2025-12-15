import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:sandbox_digilocker_sdk/sandbox_digilocker_sdk.dart';
import 'package:sandbox_digilocker_sdk/src/events/events.dart';

part 'ui/digilocker_sdk.dart';

/// Provides a singleton instance for managing Digilocker SDK interactions.
///
/// Use [DigilockerSDK.instance] to access the singleton. This class handles
/// authentication, event listening, and opening the Digilocker UI flow.
///
/// Example usage:
/// ```
/// DigilockerSDK.instance.setAPIKey('key_xxx');
/// DigilockerSDK.instance.setEventListener(myListener);
/// await DigilockerSDK.instance.open(context: context, options: {...});
/// ```
class DigilockerSDK {
  static final DigilockerSDK _instance = DigilockerSDK._internal();

  static DigilockerSDK get instance => _instance;

  DigilockerSDK._internal();

  static const String redirectUrl = 'https://sdk.sandbox.co.in/kyc/digilocker';
  String? apiKey;
  EventListener? _eventListener;
  Map<String, dynamic> options = {};

  /// Sets the API key for authenticating requests to the Digilocker SDK.
  ///
  /// The [apiKey] must start with 'key_'.
  /// Throws an [Exception] if the key is invalid.
  void setAPIKey(String apiKey) {
    if (!apiKey.startsWith('key_')) {
      throw Exception('API key must start with "key_".');
    }
    this.apiKey = apiKey;
  }

  /// Registers an [EventListener] to receive Digilocker SDK events.
  ///
  /// The [listener] will be notified of events during the SDK flow.
  void setEventListener(EventListener listener) {
    _eventListener = listener;
  }

  /// Opens the Digilocker SDK UI as a modal page.
  ///
  /// Requires a [context] for navigation and a map of [options] for configuration.
  /// Throws an [Exception] if the API key is not set or required options are missing.
  Future<void> open({required BuildContext context, required Map<String, dynamic> options}) async {
    if (apiKey == null) {
      throw Exception('API key not set. Call setAPIKey() before opening.');
    }

    this.options = Map.from(options);

    _validateOptions(this.options);

    await Navigator.of(context).push(
      CupertinoPageRoute(
        builder: (context) {
          return _DigilockerSdk(
            onClose: () {
              Navigator.of(context).pop();
            },
          );
        },
        fullscreenDialog: true,
        title: 'Digilocker | Sandbox',
      ),
    );
  }

  /// Validates the required options for the Digilocker SDK.
  ///
  /// Throws an [Exception] if any required option is missing.
  void _validateOptions(Map<String, dynamic> options) {
    if (!options.containsKey('brand')) {
      throw Exception('Option "brand" is required.');
    }
    if (!options.containsKey('session_id')) {
      throw Exception('Option "session_id" is required.');
    }
    if (!options.containsKey('theme')) {
      throw Exception('Option "theme" is required.');
    }
  }
}
