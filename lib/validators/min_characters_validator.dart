import 'field_validator.dart';

/// Check if field [String] value longer than some length
class MinCharactersValidator extends FieldValidator<String> {
  final int min;

  const MinCharactersValidator(
    this.min, {
    String? fieldName,
    String? errorMessage,
  }) : super(
          fieldName: fieldName,
          message: errorMessage ?? 'should contain minimum $min characters',
        );

  const MinCharactersValidator.withMessage(this.min, String message)
      : super.withMessage(
          message: message,
        );

  @override
  bool isValid(String? value) => value!.length >= min;
}
