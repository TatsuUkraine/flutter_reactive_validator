import 'package:rxdart/rxdart.dart';

import 'contracts/error_provider.dart';

class MappedValueErrorProvider<K> implements ErrorProvider<K> {
  @override
  final K field;

  final ValueStream<Map<K, String>> _valueStream;

  MappedValueErrorProvider(this.field, this._valueStream);

  @override
  String get value => _transform(_valueStream.value);

  @override
  bool get hasValue => _valueStream.value != null;

  @override
  Stream<String> get stream {
    if (_valueStream.hasValue) {
      return _valueStream.skip(1).map(_transform);
    }

    return _valueStream.map(_transform);
  }

  String _transform(Map<K, String> errors) => (errors ?? {})[field];
}