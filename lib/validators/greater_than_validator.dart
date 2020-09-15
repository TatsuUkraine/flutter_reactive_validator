import 'field_validator.dart';

/// Checks if [num] value is greater than provided value
class GreaterThanValidator<I extends num> extends FieldValidator<I> {
  final I min;

  GreaterThanValidator(this.min, {
    String fieldName,
    String errorMessage,
  })  : super(
    fieldName: fieldName,
    message: errorMessage ?? 'should be greater than $min',
  );

  GreaterThanValidator.withMessage(
    this.min,
    String message
  )   : super.withMessage(
    message: message,
  );

  @override
  bool isValid(I value) => value > min;
}