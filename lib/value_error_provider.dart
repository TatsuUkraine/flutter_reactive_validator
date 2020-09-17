import 'package:stream_validator/contracts/error_provider.dart';

class ValueErrorProvider<K> implements ErrorProvider<K> {
  @override
  final K field;

  @override
  final String value;

  const ValueErrorProvider(this.field, this.value);

  @override
  bool get hasValue => value != null;
}