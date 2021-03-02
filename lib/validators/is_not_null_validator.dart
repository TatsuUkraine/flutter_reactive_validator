import 'not_equal_to_validator.dart';

/// Checks if provided value not equal to `null`
class IsNotNullValidator<I> extends NotEqualToValidator<I> {
  const IsNotNullValidator({
    String? fieldName,
    String message = 'can\'t be null',
  }) : super(
          null,
          fieldName: fieldName,
          message: message,
        );

  const IsNotNullValidator.withMessage(String message)
      : super.withMessage(null, message);
}
