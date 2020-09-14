import 'equal_to_validator.dart';

/// Checks if provided value is equal to `null`
class NullValidator extends EqualToValidator<Object> {
  NullValidator({
    String fieldName,
    String errorMessage,
  })  : super(
    null,
    fieldName: fieldName,
    errorMessage: errorMessage,
  );

  NullValidator.withMessage(String message)
      : super.withMessage(null, message);
}