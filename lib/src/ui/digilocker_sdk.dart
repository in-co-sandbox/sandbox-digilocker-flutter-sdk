part of '../digilocker_sdk.dart';

class _DigilockerSdk extends StatefulWidget {
  final VoidCallback onClose;

  const _DigilockerSdk({required this.onClose});

  @override
  State<_DigilockerSdk> createState() => _DigilockerSdkState();
}

class _DigilockerSdkState extends State<_DigilockerSdk> {
  final settings = InAppWebViewSettings(isInspectable: kDebugMode, javaScriptEnabled: true);

  bool _showNavbar = false;
  final Uri _sdkUri = Uri.parse(DigilockerSDK.redirectUrl);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            if (_showNavbar)
              DigilockerNavbar(
                title: 'Verification',
                onClose: _handleNavBarClose,
                themeOptions: DigilockerSDK.instance._options,
              ),
            Expanded(
              child: InAppWebView(
                initialSettings: settings,
                onLoadStart: (controller, url) {
                  controller.addJavaScriptHandler(
                    handlerName: 'DigilockerSDK_onMessage',
                    callback: (args) {
                      return _handleEvent(
                        jsonDecode(args.first),
                        controller,
                      );
                    },
                  );
                },
                onPageCommitVisible: (controller, url) async {
                  final uri = url;
                  if (uri != null && uri.host != _sdkUri.host) {
                    setState(() {
                      _showNavbar = true;
                    });
                  }
                  if (uri != null && uri.host == _sdkUri.host) {
                    setState(() {
                      _showNavbar = false;
                    });
                  }
                },
                initialUrlRequest: URLRequest(
                  url: WebUri(DigilockerSDK.redirectUrl),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleEvent(
    Map<String, dynamic> event,
    InAppWebViewController controller,
  ) {
    try {
      final eventType = event['type'] as String?;

      if (eventType == Events.initialized.value) {
        final options = DigilockerSDK.instance._options;
        options['api_key'] = DigilockerSDK.instance._apiKey;

        final readyEvent = _prepareEvent(Events.ready.value, options);

        controller.evaluateJavascript(
          source: '''
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

  void _handleNavBarClose() {
    final event = _prepareEvent(Events.closed.value, {});
    _triggerEventListener(event);
    widget.onClose();
  }

  Map<String, dynamic> _prepareEvent(
    String type,
    Map<String, dynamic> data,
  ) {
    return {
      'specversion': '1.0',
      'type': type,
      'source': 'flutter-app',
      'time': DateTime.now().toIso8601String(),
      'datacontenttype': 'application/json',
      'data': data,
    };
  }

  void _triggerEventListener(Map<String, dynamic> event) {
    DigilockerSDK.instance._eventListener?.onEvent(event);
  }
}
