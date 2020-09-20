import 'equal_to_validator.dart';

/// Checks if provided value is equal to `true`
class IsTrueValidator extends EqualToValidator<bool> {
  const IsTrueValidator({
    String fieldName,
    String message = 'should be equal to true',
  })  : super(
    true,
    fieldName: fieldName,
    message: message,
  );

  const IsTrueValidator.withMessage(String message)
      : super.withMessage(true, message);
}