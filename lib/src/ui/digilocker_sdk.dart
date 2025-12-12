part of '../digilocker_sdk.dart';

class _DigilockerSdk extends StatefulWidget {
  final VoidCallback onClose;

  const _DigilockerSdk({required this.onClose});

  @override
  State<_DigilockerSdk> createState() => _DigilockerSdkState();
}

class _DigilockerSdkState extends State<_DigilockerSdk> {
  final settings = InAppWebViewSettings(isInspectable: kDebugMode, javaScriptEnabled: true);

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

  void _triggerEventListener(Map<String, dynamic> event) {
    if (DigilockerSDK.instance.eventListener != null) {
      DigilockerSDK.instance.eventListener!.onEvent(event);
    } else {
      debugPrint('No event listener set.');
    }
  }
}
