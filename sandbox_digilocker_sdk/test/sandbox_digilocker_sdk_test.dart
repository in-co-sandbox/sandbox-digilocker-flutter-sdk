import 'package:flutter_test/flutter_test.dart';
import 'package:sandbox_digilocker_sdk/sandbox_digilocker_sdk.dart';

void main() {
  group('$DigilockerSDK', () {
    late DigilockerSDK digilockerSDK;

    setUp(() {
      digilockerSDK = DigilockerSDK.instance;
      digilockerSDK.apiKey = null;
      digilockerSDK.options = {};
    });

    group('#setAPIKey', () {
      test('passes API key correctly', () {
        digilockerSDK.setAPIKey('key_test_1DP5mmOlF5G5aa');

        expect(digilockerSDK.apiKey, equals('key_test_1DP5mmOlF5G5aa'));
      });

      test('throws error if key does not start with "key_"', () {
        expect(
          () => digilockerSDK.setAPIKey('invalid_test_1DP5mmOlF5G5aa'),
          throwsA(isA<Exception>().having((e) => e.toString(), 'message', contains('API key must start with "key_"'))),
        );
      });
    });
  });
}
