import 'field_validator.dart';

/// Check if field [String] value longer than some length
class MinLengthValidator extends FieldValidator<String> {
  final int min;

  MinLengthValidator(this.min, {
    String fieldName,
    String errorMessage,
  })  : super(
    fieldName: fieldName,
    message: errorMessage ?? 'should contain minimum $min characters',
  );

  MinLengthValidator.withMessage(
    this.min,
    String message
  )   : super.withMessage(
    message: message,
  );

  @override
  bool isValid(String value) => value.length >= min;
}