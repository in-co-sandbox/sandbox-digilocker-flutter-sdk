part of '../digilocker_sdk.dart';

/// Internal widget that displays the Digilocker SDK web view and handles communication.
///
/// This widget is not intended to be used directly. It is shown as a modal page
/// when the SDK is opened via [DigilockerSDK.open].
class _DigilockerSdk extends StatefulWidget {
  /// Callback invoked when the Digilocker flow is closed.
  final VoidCallback onClose;

  /// Creates a [_DigilockerSdk] widget.
  const _DigilockerSdk({required this.onClose});

  @override
  State<_DigilockerSdk> createState() => _DigilockerSdkState();
}

/// State for the [_DigilockerSdk] widget.
class _DigilockerSdkState extends State<_DigilockerSdk> {
  /// WebView settings for the Digilocker SDK web view.
  final settings = InAppWebViewSettings(isInspectable: kDebugMode, javaScriptEnabled: true);

  /// Builds the Digilocker SDK web view UI.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: InAppWebView(
          initialSettings: settings,
          onLoadStart: (controller, url) {
            controller.addJavaScriptHandler(
              handlerName: 'DigilockerSDK_onMessage',
              callback: (args) {
                return _handleEvent(jsonDecode(args.first), controller);
              },
            );
          },
          initialUrlRequest: URLRequest(url: WebUri(DigilockerSDK.redirectUrl)),
        ),
      ),
    );
  }

  /// Handles events received from the web view via JavaScript channel.
  ///
  /// [event] is the event data from the web view.
  /// [controller] is the web view controller for executing JavaScript.
  void _handleEvent(Map<String, dynamic> event, InAppWebViewController controller) {
    try {
      final eventType = event['type'] as String?;
      if (eventType == Events.initialized.value) {
        final options = DigilockerSDK.instance.options;
        options['api_key'] = DigilockerSDK.instance.apiKey;
        final readyEvent = _prepareEvent(Events.ready.value, options);
        controller.evaluateJavascript(
          source:
              '''
            window.postMessage(${jsonEncode(readyEvent)}, '*');
          ''',
        );
      }

      if (eventType == Events.closed.value || eventType == Events.completed.value) {
        widget.onClose();
      }

      _triggerEventListener(event);
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  /// Prepares an event object to send to the web view.
  ///
  /// [type] is the event type string.
  /// [data] is the event payload.
  /// Returns a map representing the event.
  Map<String, dynamic> _prepareEvent(String type, Map<String, dynamic> data) {
    final event = {
      'specversion': '1.0',
      'type': type,
      'source': 'flutter-app',
      'time': DateTime.now().toIso8601String(),
      'datacontenttype': 'application/json',
      'data': data,
    };
    return event;
  }

  /// Triggers the registered [EventListener] with the given [event].
  ///
  /// If no event listener is set, logs a debug message.
  void _triggerEventListener(Map<String, dynamic> event) {
    if (DigilockerSDK.instance._eventListener != null) {
      DigilockerSDK.instance._eventListener!.onEvent(event);
    } else {
      debugPrint('No event listener set.');
    }
  }
}
