import 'package:flutter/foundation.dart';

import '../contracts/validator.dart';

/// Default implementation of [Validator].
///
/// Can be used to define custom validators
class FieldValidator<I> implements Validator<I> {
  /// Field name.
  ///
  /// Default to `Field`
  final String fieldName;

  /// Validation message for provided [fieldName]
  final String errorMessage;

  /// Full validation message.
  ///
  /// If provided, [fieldName] and [errorMessage] will be ignored
  final String message;
  
  /// Validation function
  final bool Function(I value) isValid;

  /// If validation can be invoked on `null` values.
  ///
  /// By default all validators ignoring `null` values during the validation,
  /// except couple of validators
  final bool ignoreNullable;

  /// Defines [fieldName] and [errorMessage] that will be used
  /// to generate validation error message if validation fails
  FieldValidator({
    this.fieldName,
    @required this.errorMessage,
    @required this.isValid,
    this.ignoreNullable = true,
  })  : message = null;

  /// Defines validation message if validation fails
  FieldValidator.withMessage({
    @required this.isValid,
    @required this.message,
    this.ignoreNullable = true,
  })  : assert(message != null),
        errorMessage = null,
        fieldName = null;
  
  String get _fieldName => fieldName ?? 'Field';

  @override
  String call(I value) => ignoreNullable && value == null || isValid(value)
      ? null
      : message ?? '$_fieldName $errorMessage';
}