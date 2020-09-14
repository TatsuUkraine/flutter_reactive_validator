import 'field_validator.dart';

/// Check if field value less or equal to provided value
class LessThanOrEqualValidator<I extends num> extends FieldValidator<I> {
  LessThanOrEqualValidator(I max, {
    String fieldName,
    String errorMessage,
  })  : super(
    fieldName: fieldName,
    errorMessage: errorMessage ?? 'should be less than or equal to $max',
    isValid: (value) => value <= max,
  );

  LessThanOrEqualValidator.withMessage(
    I max,
    String message
  )   : super.withMessage(
    message: message,
    isValid: (value) => value <= max,
  );
}