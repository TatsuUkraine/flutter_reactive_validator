import 'not_equal_to_validator.dart';

/// Checks if provided value not equal to `null`
class NotNullValidator extends NotEqualToValidator<Object> {
  const NotNullValidator({
    String fieldName,
    String message = 'can\'t be null',
  })  : super(
    null,
    fieldName: fieldName,
    message: message,
  );

  const NotNullValidator.withMessage(String message)
      : super.withMessage(null, message);
}