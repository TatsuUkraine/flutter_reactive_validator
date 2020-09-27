import 'package:flutter_test/flutter_test.dart';
import 'package:reactive_validator/validators/before_date_time_validator.dart';

void main() {
  test('validation should fail', () {
    final validator = BeforeDateTimeValidator(DateTime.now());

    final isValid = validator.isValid(DateTime.now().add(Duration(minutes: 1)));

    expect(isValid, isFalse);
  });

  test('validation should succeeded', () {
    final validator = BeforeDateTimeValidator(DateTime.now());

    final isValid = validator.isValid(DateTime.now().subtract(Duration(minutes: 1)));

    expect(isValid, isTrue);
  });
}