import 'field_validator.dart';

class RegexpValidator extends FieldValidator<String> {
  final RegExp regExp;

  RegexpValidator(this.regExp, {
    String fieldName,
    String errorMessage,
  })  : super(
    fieldName: fieldName,
    errorMessage: errorMessage ?? 'doesn\'t match to ${regExp.pattern}',
  );

  RegexpValidator.withMessage(
    this.regExp,
    String message
  )   : super.withMessage(
    message: message,
  );

  @override
  bool isValid(String value) => regExp.hasMatch(value);
}