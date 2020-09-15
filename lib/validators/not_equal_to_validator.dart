import 'field_validator.dart';

/// Defines if field value not equal to provided value.
class NotEqualToValidator<I> extends FieldValidator<I> {
  final I equalTo;

  NotEqualToValidator(this.equalTo, {
    String fieldName,
    String message,
  })  : super(
    fieldName: fieldName,
    message: message ?? 'shouldn\'t be equal to $equalTo',
    ignoreNullable: false,
  );


  NotEqualToValidator.withMessage(
    this.equalTo,
    String message
  )   : super.withMessage(
    message: message,
    ignoreNullable: false,
  );

  @override
  bool isValid(I value) => value == equalTo;
}