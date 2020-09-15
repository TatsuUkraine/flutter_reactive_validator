import 'package:flutter/foundation.dart';

import '../contracts/validator.dart';

/// Default implementation of [Validator].
///
/// Can be used to define custom validators
abstract class FieldValidator<I> implements Validator<I> {
  /// Validation error message.
  final String message;

  /// If validation can be invoked on `null` values.
  ///
  /// By default all validators ignoring `null` values during the validation,
  /// except couple of validators
  final bool ignoreNullable;

  /// Defines [fieldName] and [message] that will be used
  /// to generate validation error message if validation fails.
  const FieldValidator({
    String fieldName,
    @required String message,
    this.ignoreNullable = true,
  })  : message = '${fieldName ?? 'Field'} $message';

  /// Defines full validation message if validation fails.
  const FieldValidator.withMessage({
    @required this.message,
    this.ignoreNullable = true,
  })  : assert(message != null);

  @override
  String call(I value) => ignoreNullable && value == null || isValid(value)
      ? null
      : message;

  /// Validation function
  bool isValid(I value);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FieldValidator<I> &&
          runtimeType == other.runtimeType &&
          message == other.message &&
          ignoreNullable == other.ignoreNullable;

  @override
  int get hashCode => message.hashCode ^ ignoreNullable.hashCode;
}