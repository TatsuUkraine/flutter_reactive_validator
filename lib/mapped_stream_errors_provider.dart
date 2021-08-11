import 'package:rxdart/rxdart.dart';

import 'contracts/stream_errors_provider.dart';
import 'utils.dart';

class MappedStreamErrorsProvider<K> implements StreamErrorsProvider<K> {
  @override
  final Iterable<K> fields;

  /// [Stream] with errors
  final ValueStream<Map<K, String>> _valueStream;

  const MappedStreamErrorsProvider(this.fields, this._valueStream);

  @override
  Iterable<String> get value => _transform(_valueStream.valueOrNull);

  @override
  bool get hasError => value.isNotEmpty;

  @override
  Stream<Iterable<String>> get stream => _valueStream.map(_transform);

  /// Transformer to find error among error [Map]
  Iterable<String> _transform(Map<K, String>? errors) =>
      filterErrors(fields, errors ?? const {});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MappedStreamErrorsProvider<K> &&
          runtimeType == other.runtimeType &&
          fieldsComparator.equals(fields, other.fields) &&
          _valueStream == other._valueStream;

  @override
  int get hashCode => fieldsComparator.hash(fields) ^ _valueStream.hashCode;
}
