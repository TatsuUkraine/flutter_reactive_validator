import 'package:flutter_test/flutter_test.dart';
import 'package:reactive_validator/value_errors_provider.dart';

void main() {
  test('should define if error provided', () {
    final provider = ValueErrorsProvider<String>(['field'], ['value']);

    expect(provider.hasError, isTrue);

    final providerWithoutValue = ValueErrorsProvider<String>(['field'], []);

    expect(providerWithoutValue.hasError, isFalse);
  });

  test('should compare provider', () {
    final provider1 = ValueErrorsProvider<String>(['field'], ['value']);
    final provider2 = ValueErrorsProvider<String>(['field'], ['value']);
    final provider3 = ValueErrorsProvider<String>(['field'], ['value2']);

    expect(provider1 == provider2, isTrue);
    expect(provider1 == provider3, isFalse);
  });
}
