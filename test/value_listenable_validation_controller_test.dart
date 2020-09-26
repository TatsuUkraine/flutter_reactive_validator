import 'package:flutter_test/flutter_test.dart';
import 'package:reactive_validator/reactive_validator.dart';
import 'package:reactive_validator/value_error_provider.dart';

void main() {
  test('should create empty validation controller', () {
    final controller = ValueListenableValidationController<String>();

    expect(controller.errors, {});
    expect(controller.isValid, isTrue);

    controller.dispose();
  });

  test('should create seeded validation controller', () {
    final controller = ValueListenableValidationController<String>.seeded({
      'field': 'value'
    });
    final provider = controller.fieldErrorProvider('field');

    expect(provider, ValueErrorProvider('field', 'value'));
    expect(controller.errors, {
      'field': 'value',
    });
    expect(controller.isValid, isFalse);

    controller.dispose();
  });

  test('should update error map', () {
    final controller = ValueListenableValidationController<String>();

    expect(controller.errors, {});
    expect(controller.isValid, isTrue);

    controller.addErrors({
      'field': 'value',
    });

    expect(controller.errors, {
      'field': 'value',
    });
    expect(controller.isValid, isFalse);

    controller.dispose();
  });
}