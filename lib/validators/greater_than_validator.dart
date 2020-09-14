import 'field_validator.dart';

/// Checks if [num] value is greater than provided value
class GreaterThanValidator<I extends num> extends FieldValidator<I> {
  GreaterThanValidator(I min, {
    String fieldName,
    String errorMessage,
  })  : super(
    fieldName: fieldName,
    errorMessage: errorMessage ?? 'should be greater than $min',
    isValid: (value) => value > min,
  );

  GreaterThanValidator.withMessage(
    I min,
    String message
  )   : super.withMessage(
    message: message,
    isValid: (value) => value > min,
  );
}