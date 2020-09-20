import 'package:flutter/foundation.dart';

import 'field_validator.dart';

/// Validates if [Iterable] is empty
class EmptyIterableValidator<I> extends FieldValidator<Iterable<I>> {

  const EmptyIterableValidator({
    String fieldName,
    @required String message
  })  : super(
    fieldName: fieldName,
    message: message ?? 'should be empty',
  );

  const EmptyIterableValidator.withMessage(String message)
      : super.withMessage(message: message);

  @override
  bool isValid(Iterable<I> value) => value.isEmpty;
}