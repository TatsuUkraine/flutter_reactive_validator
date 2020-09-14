import 'not_equal_to_validator.dart';

/// Checks if provided value not equal to `null`
class NotNullValidator extends NotEqualToValidator<Object> {
  NotNullValidator({
    String fieldName,
    String errorMessage,
  })  : super(
    null,
    fieldName: fieldName,
    errorMessage: errorMessage,
  );

  NotNullValidator.withMessage(String message)
      : super.withMessage(null, message);
}