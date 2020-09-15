import 'package:flutter/foundation.dart';

import '../contracts/validator.dart';

typedef bool _Validator<I>(I value);
typedef String _MessageBuilder<I>(I value);

/// Custom validator. Allows to define validation with
/// [CustomValidator.isValid] callback.
///
/// Can be defined or with field name and error message within default constructor
/// or with [CustomValidator.message] callback to generate error message during the
/// validation
class CustomValidator<I> implements Validator<I> {

  /// Validation message callback
  final _MessageBuilder<I> message;

  /// Validation method
  final _Validator<I> isValid;

  /// If validation can be invoked on `null` values.
  ///
  /// By default all validators ignoring `null` values during the validation,
  /// except couple of validators
  final bool ignoreNullable;

  CustomValidator({
    String fieldName,
    @required _MessageBuilder<I> message,
    @required _Validator<I> isValid,
    bool ignoreNullable = true,
  }): this.withMessage(
    isValid: isValid,
    ignoreNullable: ignoreNullable,
    message: (value) => '${fieldName ?? 'Field'} ${message(value)}',
  );

  CustomValidator.withMessage({
    @required this.message,
    @required this.isValid,
    this.ignoreNullable = true,
  });

  @override
  String call(I value) => ignoreNullable && value == null || isValid(value)
      ? null
      : message(value);
}