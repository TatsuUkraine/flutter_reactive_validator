import 'package:flutter/foundation.dart';

import 'field_validator.dart';

/// Validates if [String] is not empty
class NotEmptyStringValidator extends FieldValidator<String> {

  const NotEmptyStringValidator({
    String fieldName,
    String message,
  })  : super(
    fieldName: fieldName,
    message: message ?? 'can\'t be empty',
  );

  const NotEmptyStringValidator.withMessage(String message)
      : super.withMessage(message: message);

  @override
  bool isValid(String value) => value.isNotEmpty;
}