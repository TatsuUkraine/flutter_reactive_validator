import '../contracts/validator.dart';

/// Group validator. Allows to validate value against multiple validators.
///
/// Stop execution as soon as first [Validator] validation fails.
///
/// All [Validator]'s should be designed to validate same value type.
///
/// Unlike [OrValidator] this validator will be valid only
/// if ALL child validators are valid
class AndValidator<I> implements Validator<I> {
  final Iterable<Validator<I>> validators;

  const AndValidator(this.validators);

  @override
  String? call(I? value) {
    for (Validator<I> validator in validators) {
      final String? error = validator(value);

      if (error != null) {
        return error;
      }
    }

    return null;
  }
}
