import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:rxdart/rxdart.dart';
import 'package:reactive_validator/mapped_stream_errors_provider.dart';

class MockedStream extends Mock implements ValueStream<Map<String, String>> {}

void main() {
  test('should define if error provided', () {
    final streamWithError = MockedStream();
    when(streamWithError.value).thenReturn({
      'field': 'error',
    });

    final provider = MappedStreamErrorsProvider<String>(
      ['field', 'field2'],
      streamWithError
    );

    expect(provider.hasError, isTrue);

    final stream = MockedStream();
    when(streamWithError.value).thenReturn({});

    final providerWithoutValue =
        MappedStreamErrorsProvider<String>(['field'], stream);

    expect(providerWithoutValue.hasError, isFalse);
  });

  test('should compare provider', () {
    final streamWithError = MockedStream();

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
