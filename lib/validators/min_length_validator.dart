import 'field_validator.dart';

/// Check if field [String] value longer than some length
class MinLengthValidator extends FieldValidator<String> {
  MinLengthValidator(int min, {
    String fieldName,
    String errorMessage,
  })  : super(
    fieldName: fieldName,
    errorMessage: errorMessage ?? 'length should be greater than $min',
    isValid: (value) => value.length > min,
  );

  MinLengthValidator.withMessage(
    int min,
    String message
  )   : super.withMessage(
    message: message,
    isValid: (value) => value.length > min,
  );
}