import 'field_validator.dart';

/// Validates if value is before defined [DateTime]
class BeforeDateTimeValidator extends FieldValidator<DateTime> {
  final DateTime dateTime;
  final String Function(DateTime) formatter;

  BeforeDateTimeValidator(
    this.dateTime, {
    String fieldName,
    String errorMessage,
    this.formatter,
  }) : super(
          fieldName: fieldName,
          message: errorMessage ??
              'should be before ${formatter?.call(dateTime) ?? dateTime}',
        );

  const BeforeDateTimeValidator.withMessage(
    this.dateTime,
    String message,
  )   : formatter = null,
        super.withMessage(message: message);

  @override
  bool isValid(DateTime value) => value.isBefore(dateTime);
}
