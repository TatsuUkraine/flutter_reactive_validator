import 'field_validator.dart';
import 'package:email_validator/email_validator.dart' as v;

/// Validator for email value. Backed with `email_validator` package to provide
/// proper validation.
class EmailValidator extends FieldValidator<String> {
  EmailValidator({
    String fieldName,
    String errorMessage,
    bool allowTopLevelDomains = false,
    bool allowInternational = true,
  })  : super(
    fieldName: fieldName,
    errorMessage: errorMessage ?? 'value should be a valid email',
    isValid: (value) => v.EmailValidator.validate(
      value,
      allowTopLevelDomains,
      allowInternational
    ),
  );

  EmailValidator.withMessage(String message, {
    bool allowTopLevelDomains = false,
    bool allowInternational = true,
  })  : super.withMessage(
    message: message,
    isValid: (value) => v.EmailValidator.validate(
      value,
      allowTopLevelDomains,
      allowInternational
    ),
  );
}