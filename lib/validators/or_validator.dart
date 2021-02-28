import '../contracts/validator.dart';

/// Group validator. Allows to validate value against multiple validators.
///
/// Stop execution as soon as first [Validator] validation succeeded.
///
/// Unlike [AndValidator], this validator will be valid if at least
/// one child validator is valid. If all child validators are
/// invalid - error message from the last validator will be provided
///
/// All [Validator]'s should be designed to validate same value type.
class OrValidator<I> implements Validator<I> {
  final Iterable<Validator<I>> validators;

  const OrValidator(this.validators);

  @override
  String? call(I? value) {
    String? lastError;
    for (Validator<I> validator in validators) {
      final String? error = validator(value);

      if (error == null) {
        return null;
      }

      lastError = error;
    }

    return lastError;
  }
}
