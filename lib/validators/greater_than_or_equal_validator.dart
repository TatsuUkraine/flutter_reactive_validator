import 'field_validator.dart';

/// Checks if [num] value is greater or equal to provided value
class GreaterThanOrEqualValidator<I extends num> extends FieldValidator<I> {
  GreaterThanOrEqualValidator(I min, {
    String fieldName,
    String errorMessage,
  })  : super(
    fieldName: fieldName,
    errorMessage: errorMessage ?? 'should be greater than $min',
    isValid: (value) => value >= min,
  );

  GreaterThanOrEqualValidator.withMessage(
    I min,
    String message
  )   : super.withMessage(
    message: message,
    isValid: (value) => value >= min,
  );
}