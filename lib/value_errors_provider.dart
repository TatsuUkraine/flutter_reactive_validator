import 'contracts/errors_provider.dart';
import 'utils.dart';

/// Provides info about field validation
class ValueErrorsProvider<K> implements ErrorsProvider<K> {
  @override
  final Iterable<K> fields;

  @override
  final Iterable<String> value;

  const ValueErrorsProvider(this.fields, this.value);

  @override
  bool get hasError => value != null;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ValueErrorsProvider<K> &&
          runtimeType == other.runtimeType &&
          fieldsComparator.equals(fields, other.fields) &&
          value == other.value;

  @override
  int get hashCode => fieldsComparator.hash(fields) ^ value.hashCode;
}
