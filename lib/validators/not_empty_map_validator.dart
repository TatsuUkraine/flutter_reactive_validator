import 'field_validator.dart';

/// Validates if [Map] is not empty
class NotEmptyMapValidator<K,V> extends FieldValidator<Map<K,V>> {

  const NotEmptyMapValidator({
    String fieldName,
    String message,
  })  : super(
    fieldName: fieldName,
    message: message ?? 'can\'t be empty',
  );

  const NotEmptyMapValidator.withMessage(String message)
      : super.withMessage(message: message);

  @override
  bool isValid(Map<K,V> value) => value.isNotEmpty;
}