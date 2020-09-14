import 'field_validator.dart';

/// Check if field [String] value shorter than some length
class MaxLengthValidator extends FieldValidator<String> {
  MaxLengthValidator(int max, {
    String fieldName,
    String errorMessage,
  })  : super(
    fieldName: fieldName,
    errorMessage: errorMessage ?? 'length should be less than $max',
    isValid: (value) => value.length < max,
  );

  MaxLengthValidator.withMessage(
    int max,
    String message
  )   : super.withMessage(
    message: message,
    isValid: (value) => value.length < max,
  );
}