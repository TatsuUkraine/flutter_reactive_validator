import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:rxdart/rxdart.dart';
import 'package:reactive_validator/mapped_stream_error_provider.dart';

class MockedStream extends Mock implements ValueStream<Map<String, String>> {}

void main() {
  test('should define if error provided', () {
    final streamWithError = MockedStream();
    when(streamWithError.value).thenReturn({
      'field': 'error',
    });

    final provider = MappedStreamErrorProvider<String>('field', streamWithError);

    expect(provider.hasError, true);

    final stream = MockedStream();
    when(streamWithError.value).thenReturn({});

    final providerWithoutValue = MappedStreamErrorProvider<String>('field', stream);

    expect(providerWithoutValue.hasError, false);
  });

  test('should compare provider', () {
    final streamWithError = MockedStream();

    final provider1 = MappedStreamErrorProvider<String>('field', streamWithError);
    final provider2 = MappedStreamErrorProvider<String>('field', streamWithError);
    final provider3 = MappedStreamErrorProvider<String>('field2', streamWithError);

    expect(provider1 == provider2, isTrue);
    expect(provider1 == provider3, isFalse);
  });
}