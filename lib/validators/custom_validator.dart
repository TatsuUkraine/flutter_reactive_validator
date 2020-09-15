import 'package:flutter/foundation.dart';

import '../contracts/validator.dart';

typedef bool _Validator<I>(I value);
typedef String _MessageBuilder<I>(I value);

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
    @required String errorMessage,
    @required _Validator<I> isValid,
    bool ignoreNullable = true,
  }): this.withMessage(
    isValid: isValid,
    ignoreNullable: ignoreNullable,
    message: (_) => '${fieldName ?? 'Field'} $errorMessage',
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