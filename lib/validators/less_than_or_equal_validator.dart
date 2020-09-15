import 'field_validator.dart';

/// Check if field value less or equal to provided value
class LessThanOrEqualValidator<I extends num> extends FieldValidator<I> {
  final I max;

  LessThanOrEqualValidator(this.max, {
    String fieldName,
    String errorMessage,
  })  : super(
    fieldName: fieldName,
    message: errorMessage ?? 'should be less than or equal to $max',
  );

  LessThanOrEqualValidator.withMessage(
    this.max,
    String message
  )   : super.withMessage(
    message: message,
  );

  @override
  bool isValid(I value) => value <= max;
}