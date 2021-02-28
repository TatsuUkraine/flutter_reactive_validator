import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rxdart/rxdart.dart';
import 'package:reactive_validator/mapped_stream_error_provider.dart';

import 'mapped_stream_error_provider_test.mocks.dart';

@GenerateMocks([ValueStream])
void main() {
  test('should define if error provided', () {
    final streamWithError = MockValueStream<Map<String, String>>();
    when(streamWithError.valueWrapper).thenReturn(ValueWrapper({
      'field': 'error',
    }));

    final provider =
        MappedStreamErrorProvider<String>('field', streamWithError);

    expect(provider.hasError, isTrue);

    final stream = MockValueStream<Map<String, String>>();
    when(stream.valueWrapper).thenReturn(ValueWrapper({}));

    final providerWithoutValue =
        MappedStreamErrorProvider<String>('field', stream);

    expect(providerWithoutValue.hasError, isFalse);
  });

  test('should compare provider', () {
    final streamWithError = MockValueStream<Map<String, String>>();

    final provider1 =
        MappedStreamErrorProvider<String>('field', streamWithError);
    final provider2 =
        MappedStreamErrorProvider<String>('field', streamWithError);
    final provider3 =
        MappedStreamErrorProvider<String>('field2', streamWithError);

    expect(provider1 == provider2, isTrue);
    expect(provider1 == provider3, isFalse);
  });
}
