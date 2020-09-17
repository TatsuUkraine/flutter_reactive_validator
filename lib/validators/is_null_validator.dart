import 'equal_to_validator.dart';

/// Checks if provided value is equal to `null`
class IsNullValidator extends EqualToValidator<Object> {
  const IsNullValidator({
    String fieldName,
    String message,
  })  : super(
    null,
    fieldName: fieldName,
    message: message,
  );

  const IsNullValidator.withMessage(String message)
      : super.withMessage(null, message);
}