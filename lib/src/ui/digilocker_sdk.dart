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

  late final String _homeHost = Uri.parse(DigilockerSDK.redirectUrl).host;

  bool _isHome(Uri? url) => url?.host == _homeHost;

  void _setNavbar(bool visible) {
    if (!mounted) return;
    if (_showNavbar != visible) {
      setState(() => _showNavbar = visible);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildAnimatedNavbar(),
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
                onLoadStop: (controller, url) {
                  if (url == null) return;

                  if (_isHome(url)) {
                    _setNavbar(false);
                  } else {
                    Future.microtask(() {
                      _setNavbar(true);
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

  Widget _buildAnimatedNavbar() {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 250),
      switchInCurve: Curves.easeOut,
      switchOutCurve: Curves.easeIn,
      transitionBuilder: (child, animation) {
        final slide = Tween<Offset>(
          begin: const Offset(0, -1),
          end: Offset.zero,
        ).animate(animation);

        return SlideTransition(
          position: slide,
          child: child,
        );
      },
      child: _showNavbar
          ? DigilockerNavbar(
              key: const ValueKey('digilocker-navbar'),
              onClose: widget.onClose,
            )
          : const SizedBox(
              key: ValueKey('digilocker-navbar-empty'),
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
