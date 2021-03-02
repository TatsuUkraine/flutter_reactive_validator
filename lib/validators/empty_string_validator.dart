import 'field_validator.dart';

/// Validates if [String] is empty
class EmptyStringValidator extends FieldValidator<String> {
  const EmptyStringValidator({String? fieldName, String? message})
      : super(
          fieldName: fieldName,
          message: message ?? 'should be empty',
        );

  const EmptyStringValidator.withMessage(String message)
      : super.withMessage(message: message);

  @override
  bool isValid(String? value) => value?.isEmpty ?? true;
}
