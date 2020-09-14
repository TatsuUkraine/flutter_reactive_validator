import '../contracts/validator.dart';

/// Group validator. Allows to validate value against multiple validators.
///
/// Stop execution as soon as first [Validator] validation fails.
///
/// All [Validator]'s should be designed to validate same value type.
class GroupValidator<I> implements Validator<I> {
  final List<Validator<I>> validators;

  GroupValidator(this.validators)
      : assert(validators != null && validators.isNotEmpty);

  @override
  String call(I value) {
    for (Validator<I> validator in validators) {
      final String error = validator(value);

      if (error != null) {
        return error;
      }
    }

    return null;
  }

}