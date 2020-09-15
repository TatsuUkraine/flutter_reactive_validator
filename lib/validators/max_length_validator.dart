import 'field_validator.dart';

/// Check if field [String] value shorter than some length
class MaxLengthValidator extends FieldValidator<String> {
  final int max;

  const MaxLengthValidator(this.max, {
    String fieldName,
    String errorMessage,
  })  : super(
    fieldName: fieldName,
    message: errorMessage ?? 'should contain maximum $max characters',
  );

  const MaxLengthValidator.withMessage(
    this.max,
    String message
  )   : super.withMessage(
    message: message,
  );

  @override
  bool isValid(String value) => value.length <= max;
}