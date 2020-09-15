import 'equal_to_validator.dart';

/// Checks if provided value is equal to `null`
class NullValidator extends EqualToValidator<Object> {
  NullValidator({
    String fieldName,
    String message,
  })  : super(
    null,
    fieldName: fieldName,
    message: message,
  );

  NullValidator.withMessage(String message)
      : super.withMessage(null, message);
}