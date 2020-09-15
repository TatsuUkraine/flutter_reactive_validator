import 'field_validator.dart';

/// Validate if [DateTime] is before validated value
class BeforeDateTimeValidator extends FieldValidator<DateTime> {
  final DateTime dateTime;
  final String Function(DateTime) formatter;

  BeforeDateTimeValidator(this.dateTime, {
    String fieldName,
    String errorMessage,
    this.formatter,
  }): super(
    fieldName: fieldName,
    errorMessage: errorMessage ?? 'should be before ${formatter?.call(dateTime) ?? dateTime}',
  );

  BeforeDateTimeValidator.withMessage(
    this.dateTime,
    String message,
  ) : formatter = null,
      super.withMessage(message: message);

  @override
  bool isValid(DateTime value) => dateTime.isBefore(value);

}