import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rxdart/rxdart.dart';
import 'package:reactive_validator/mapped_stream_errors_provider.dart';

import 'mapped_stream_errors_provider_test.mocks.dart';

@GenerateMocks([ValueStream])
void main() {
  test('should define if error provided', () {
    final streamWithError = MockValueStream<Map<String, String>>();
    when(streamWithError.valueOrNull).thenReturn({
      'field': 'error',
    });

    final provider = MappedStreamErrorsProvider<String>(
      ['field', 'field2'],
      streamWithError
    );

    expect(provider.hasError, isTrue);

    final stream = MockValueStream<Map<String, String>>();
    when(stream.valueOrNull).thenReturn({});

    final providerWithoutValue =
        MappedStreamErrorsProvider<String>(['field'], stream);

    expect(providerWithoutValue.hasError, isFalse);
  });

  test('should compare provider', () {
    final streamWithError = MockValueStream<Map<String, String>>();

    final provider1 =
        MappedStreamErrorsProvider<String>(['field'], streamWithError);
    final provider2 =
        MappedStreamErrorsProvider<String>(['field'], streamWithError);
    final provider3 =
        MappedStreamErrorsProvider<String>(['field2'], streamWithError);

    expect(provider1 == provider2, isTrue);
    expect(provider1 == provider3, isFalse);
  });
}
