import 'field_validator.dart';

/// Validates if [Iterable] is not empty
class NotEmptyIterableValidator<I> extends FieldValidator<Iterable<I>> {

  const NotEmptyIterableValidator({
    String fieldName,
    String message
  })  : super(
    fieldName: fieldName,
    message: message ?? 'can\'t be empty',
  );

  const NotEmptyIterableValidator.withMessage(String message)
      : super.withMessage(message: message);

  @override
  bool isValid(Iterable<I> value) => value.isNotEmpty;
}