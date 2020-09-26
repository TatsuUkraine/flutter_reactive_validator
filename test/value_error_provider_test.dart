import 'package:flutter_test/flutter_test.dart';
import 'package:stream_validator/value_error_provider.dart';

void main() {
  test('should define if value provided', () {
    final provider = ValueErrorProvider<String>('field', 'value');

    expect(provider.hasValue, true);

    final providerWithoutValue = ValueErrorProvider<String>('field', null);

    expect(providerWithoutValue.hasValue, false);
  });

  test('should compare provider', () {
    final provider1 = ValueErrorProvider<String>('field', 'value');
    final provider2 = ValueErrorProvider<String>('field', 'value');
    final provider3 = ValueErrorProvider<String>('field', 'value2');

    expect(provider1 == provider2, isTrue);
    expect(provider1 == provider3, isFalse);
  });
}
