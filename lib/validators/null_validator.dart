import 'equal_to_validator.dart';

/// Checks if provided value is equal to `null`
class NullValidator extends EqualToValidator<Object> {
  const NullValidator({
    String fieldName,
    String message,
  })  : super(
    null,
    fieldName: fieldName,
    message: message,
  );

  const NullValidator.withMessage(String message)
      : super.withMessage(null, message);
}