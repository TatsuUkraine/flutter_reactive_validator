import 'contracts/error_provider.dart';

/// Provides info about field validation
class ValueErrorProvider<K> implements ErrorProvider<K> {
  @override
  final K field;

  @override
  final String value;

  const ValueErrorProvider(this.field, this.value);

  @override
  bool get hasError => value != null;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ValueErrorProvider<K> &&
          runtimeType == other.runtimeType &&
          field == other.field &&
          value == other.value;

  @override
  int get hashCode => field.hashCode ^ value.hashCode;
}