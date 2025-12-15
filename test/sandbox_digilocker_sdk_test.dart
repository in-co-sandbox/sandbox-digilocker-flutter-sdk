import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sandbox_digilocker_sdk/sandbox_digilocker_sdk.dart';

void main() {
  group('$DigilockerSDK', () {
    late DigilockerSDK digilockerSDK;

    setUp(() {
      digilockerSDK = DigilockerSDK.instance;
    });

    testWidgets('throws exception if open is called without setting API key', (WidgetTester tester) async {
      // Create a minimal widget to obtain a BuildContext
      late BuildContext capturedContext;
      await tester.pumpWidget(
        Builder(
          builder: (context) {
            capturedContext = context;
            return const SizedBox.shrink();
          },
        ),
      );
      expect(() => digilockerSDK.open(context: capturedContext, options: {}), throwsA(isA<Exception>()));
    });
  });
}
