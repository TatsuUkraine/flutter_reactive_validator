import 'package:flutter_test/flutter_test.dart';
import 'package:stream_validator/value_error_provider.dart';

void main() {
  test('should define if value provided', () {
    final provider = ValueErrorProvider<String>('field', 'value');

    expect(provider.hasValue, true);

    final providerWithoutValue = ValueErrorProvider<String>('field', null);

    expect(providerWithoutValue.hasValue, false);
  });
}
