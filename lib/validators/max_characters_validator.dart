import 'field_validator.dart';

/// Check if field [String] value shorter than some length
class MaxCharactersValidator extends FieldValidator<String> {
  final int max;

  const MaxCharactersValidator(this.max, {
    String fieldName,
    String errorMessage,
  })  : super(
    fieldName: fieldName,
    message: errorMessage ?? 'should contain maximum $max characters',
  );

  const MaxCharactersValidator.withMessage(
    this.max,
    String message
  )   : super.withMessage(
    message: message,
  );

  @override
  bool isValid(String value) => value.length <= max;
}