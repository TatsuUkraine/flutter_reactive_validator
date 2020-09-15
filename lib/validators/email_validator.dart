import 'field_validator.dart';
import 'package:email_validator/email_validator.dart' as v;

/// Validator for email value. Backed with `email_validator` package to provide
/// proper validation.
class EmailValidator extends FieldValidator<String> {
  final bool allowTopLevelDomains;
  final bool allowInternational;

  EmailValidator({
    String fieldName,
    String errorMessage,
    this.allowTopLevelDomains = false,
    this.allowInternational = true,
  })  : super(
    fieldName: fieldName,
    message: errorMessage ?? 'value should be a valid email',
  );

  EmailValidator.withMessage(String message, {
    this.allowTopLevelDomains = false,
    this.allowInternational = true,
  })  : super.withMessage(
    message: message,
  );

  @override
  bool isValid(value) => v.EmailValidator.validate(
    value,
    allowTopLevelDomains,
    allowInternational
  );
}