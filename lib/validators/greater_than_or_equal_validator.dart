import 'field_validator.dart';

/// Checks if [num] value is greater or equal to provided value
class GreaterThanOrEqualValidator<I extends num> extends FieldValidator<I> {
  final I min;

  GreaterThanOrEqualValidator(this.min, {
    String fieldName,
    String errorMessage,
  })  : super(
    fieldName: fieldName,
    errorMessage: errorMessage ?? 'should be greater than or equal to $min',
  );

  GreaterThanOrEqualValidator.withMessage(
    this.min,
    String message
  )   : super.withMessage(
    message: message,
  );

  @override
  bool isValid(I value) => value >= min;
}