import 'field_validator.dart';

/// Check if field value less than a provided value
class LessThanValidator<I extends num> extends FieldValidator<I> {
  LessThanValidator(I max, {
    String fieldName,
    String errorMessage,
  })  : super(
    fieldName: fieldName,
    errorMessage: errorMessage ?? 'should be less than $max',
    isValid: (value) => value < max,
  );

  LessThanValidator.withMessage(
    I max,
    String message
  )   : super.withMessage(
    message: message,
    isValid: (value) => value < max,
  );
}