import 'field_validator.dart';

/// Defines if field value not equal to provided value.
class NotEqualToValidator<I> extends FieldValidator<I> {

  NotEqualToValidator(I equalTo, {
    String fieldName,
    String errorMessage,
  })  : super(
    fieldName: fieldName,
    errorMessage: errorMessage ?? 'shouldn\'t be equal to $equalTo',
    isValid: (value) => value == equalTo,
    ignoreNullable: false,
  );


  NotEqualToValidator.withMessage(
    I equalTo,
    String message
  )   : super.withMessage(
    message: message,
    isValid: (value) => value == equalTo,
    ignoreNullable: false,
  );
}