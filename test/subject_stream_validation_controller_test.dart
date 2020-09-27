import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:reactive_validator/contracts/stream_error_provider.dart';
import 'package:reactive_validator/contracts/validation_connector.dart';
import 'package:reactive_validator/subject_stream_validation_controller.dart';

class MockedConnector extends Mock implements ValidationConnector<String, String> {}

void main() {
  test('should create empty validation controller', () {
    final controller = SubjectStreamValidationController<String>();

    expect(controller.errors, {});
    expect(controller.isValid, isTrue);

    controller.dispose();
  });

  test('should create seeded validation controller', () {
    final controller = SubjectStreamValidationController<String>.seeded({
      'field': 'value'
    });

    expect(controller.errors, {
      'field': 'value',
    });
    expect(controller.isValid, isFalse);

    controller.dispose();
  });

  test('should return error provider', () {
    final controller = SubjectStreamValidationController<String>.seeded({
      'field': 'value'
    });
    final provider = controller.fieldErrorProvider('field');

    expect(provider, isInstanceOf<StreamErrorProvider<String>>());
    expect(provider.field, 'field');
    expect(provider.value, 'value');
    expect(provider.hasError, isTrue);

    controller.dispose();
  });

  test('should update error map', () {
    final controller = SubjectStreamValidationController<String>(sync: true);

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

  test('should add field error message', () {
    final controller = SubjectStreamValidationController<String>(sync: true);

    controller.addFieldError('field', 'error');
    expect(controller.errors, {
      'field': 'error',
    });
    expect(controller.isValid, isFalse);

    controller.dispose();
  });

  test('should clear field error message', () {
    final controller = SubjectStreamValidationController<String>.seeded({
      'field': 'error',
    }, sync: true);

    expect(controller.errors, {
      'field': 'error',
    });
    expect(controller.isValid, isFalse);

    controller.clearFieldError('field');

    expect(controller.errors, {});
    expect(controller.isValid, isTrue);

    controller.dispose();
  });

  test('should clear all error messages', () {
    final controller = SubjectStreamValidationController<String>.seeded({
      'field1': 'error1',
      'field2': 'error2',
    }, sync: true);

    expect(controller.isValid, isFalse);

    controller.clearErrors();

    expect(controller.errors, {});
    expect(controller.isValid, isTrue);

    controller.dispose();
  });

  test('should remove connector and clear error field', () {
    final controller = SubjectStreamValidationController<String>(sync: true);
    final connector = MockedConnector();

    controller.addConnector(connector);

    when(connector.field).thenReturn('field');

    controller.addFieldError('field', 'error');
    expect(controller.isValid, isFalse);
    controller.removeConnector(connector);

    expect(controller.isValid, isTrue);

    controller.dispose();
  });

  test('should validate across all connectors', () async {
    final controller = SubjectStreamValidationController<String>(sync: true);
    final connector = MockedConnector();

    controller.addConnector(connector);

    when(connector.field).thenReturn('field');
    when(connector.validate()).thenReturn('error');

    expect(controller.isValid, isTrue);

    await controller.validate();

    expect(controller.errors, {
      'field': 'error',
    });
    expect(controller.isValid, isFalse);

    controller.dispose();
  });

  test('should provide streams', () {
    final controller = SubjectStreamValidationController<String>();

    expect(controller.isValidStream, isInstanceOf<Stream<bool>>());
    expect(controller.errorsStream, isInstanceOf<Stream<Map<String, String>>>());
    expect(controller.fieldErrorStream('field'), isInstanceOf<Stream<String>>());

    controller.dispose();
  });

  test('should attach connectors on create', () {
    final connector = MockedConnector();
    final controller = SubjectStreamValidationController<String>(
      connectors: [
        connector,
      ],
    );

    verify(connector.attach(controller)).called(1);
  });

  test('should attach connectors on seeded controller create', () {
    final connector = MockedConnector();
    final controller = SubjectStreamValidationController<String>.seeded(
      {},
      connectors: [
        connector,
      ],
    );

    verify(connector.attach(controller)).called(1);
  });

  test('should attach connectors', () {
    final connector = MockedConnector();
    final controller = SubjectStreamValidationController<String>();

    controller.attachConnectors([connector]);

    verify(connector.attach(controller)).called(1);
  });
}