import 'field_validator.dart';

/// Validates if value is after defined [DateTime]
class AfterDateTimeValidator extends FieldValidator<DateTime> {
  final DateTime dateTime;
  final String Function(DateTime) formatter;

  AfterDateTimeValidator(this.dateTime, {
    String fieldName,
    String errorMessage,
    this.formatter,
  }): super(
    fieldName: fieldName,
    message: errorMessage ?? 'should be after ${formatter?.call(dateTime) ?? dateTime}',
  );

  const AfterDateTimeValidator.withMessage(
    this.dateTime,
    String message
  ) : formatter = null,
      super.withMessage(message: message);

  @override
  bool isValid(DateTime value) => value.isAfter(dateTime);

}