import 'field_validator.dart';

/// Checks if value is equal to provided value
class EqualToValidator<I> extends FieldValidator<I> {
  EqualToValidator(I equalTo, {
    String fieldName,
    String errorMessage,
  })  : super(
    fieldName: fieldName,
    errorMessage: errorMessage ?? 'should be equal to $equalTo',
    isValid: (value) => value == equalTo,
    ignoreNullable: false,
  );

  EqualToValidator.withMessage(
    I equalTo,
    String message
  )   : super.withMessage(
    message: message,
    isValid: (value) => value == equalTo,
    ignoreNullable: false,
  );
}