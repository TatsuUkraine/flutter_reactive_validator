import 'field_validator.dart';

/// Check if field [String] value shorter than some length
class MaxLengthValidator extends FieldValidator<String> {
  MaxLengthValidator(int max, {
    String fieldName,
    String errorMessage,
  })  : super(
    fieldName: fieldName,
    errorMessage: errorMessage ?? 'can contain maximum $max symbols',
    isValid: (value) => value.length <= max,
  );

  MaxLengthValidator.withMessage(
    int max,
    String message
  )   : super.withMessage(
    message: message,
    isValid: (value) => value.length <= max,
  );
}