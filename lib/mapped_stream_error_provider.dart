import 'package:rxdart/rxdart.dart';

import 'contracts/stream_error_provider.dart';

class MappedStreamErrorProvider<K> implements StreamErrorProvider<K> {
  @override
  final K field;

  /// [Stream] with errors
  final ValueStream<Map<K, String>> _valueStream;

  const MappedStreamErrorProvider(this.field, this._valueStream);

  @override
  String? get value => _transform(_valueStream.valueOrNull);

  @override
  bool get hasError => value != null;

  @override
  Stream<String?> get stream => _valueStream.map(_transform);

  /// Transformer to find error among error [Map]
  String? _transform(Map<K, String?>? errors) => (errors ?? {})[field];

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MappedStreamErrorProvider<K> &&
          runtimeType == other.runtimeType &&
          field == other.field &&
          _valueStream == other._valueStream;

  @override
  int get hashCode => field.hashCode ^ _valueStream.hashCode;
}
