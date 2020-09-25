import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:stream_validator/contracts/validation_connector.dart';
import 'package:stream_validator/contracts/validation_controller.dart';
import 'package:stream_validator/contracts/validator.dart';
import 'package:stream_validator/stream_validation_connector.dart';

class MockedValidator extends Mock implements Validator<String> {}
class MockedController extends Mock implements ValidationController<String> {}
class MockedStream extends Mock implements Stream<String> {}
class MockedSubscription extends Mock implements StreamSubscription<String> {}

void main() {
  test('should throw error on attach', () {
    final controller = MockedController();

    final connector = StreamValidationConnector(
      field: 'field',
      validator: MockedValidator(),
      stream: MockedStream(),
    );

    connector.attach(controller);

    expect(() => connector.attach(controller), throwsUnsupportedError);
  });

  test('should attach controller', () {
    final controller = MockedController();
    final validator = MockedValidator();
    final stream = MockedStream();

    final connector = StreamValidationConnector(
      field: 'field',
      validator: validator,
      stream: stream,
    );

    connector.attach(controller);

    verify(controller.addConnector(connector)).called(1);
    verify(stream.listen(argThat(anything))).called(1);
    verifyNever(validator.call(argThat(anything)));
  });

  test('should attach controller and validate', () {
    final controller = MockedController();
    final stream = MockedStream();
    final validator = MockedValidator();

    final connector = StreamValidationConnector.seeded(
      field: 'field',
      validator: validator,
      stream: stream,
      validateOnAttach: true,
      initialValue: 'value',
    );

    connector.attach(controller);

    verify(controller.addConnector(connector)).called(1);
    verify(stream.listen(argThat(anything))).called(1);
    verify(validator.call('value')).called(1);
    verify(controller.clearFieldError('field')).called(1);
  });

  test('should throw error on detach', () {
    final connector = StreamValidationConnector(
      field: 'field',
      validator: MockedValidator(),
      stream: MockedStream(),
    );

    expect(() => connector.detach(), throwsUnsupportedError);
  });

  test('should detach', () {
    final controller = MockedController();
    final stream = MockedStream();
    final subscription = MockedSubscription();

    final connector = StreamValidationConnector(
      field: 'field',
      validator: MockedValidator(),
      stream: stream,
    );


    when(stream.listen(argThat(anything))).thenReturn(subscription);

    connector.attach(controller);
    connector.detach();

    verify(subscription.cancel()).called(1);
    verify(controller.removeConnector(connector)).called(1);
  });

  test('should clear on change', () {
    final controller = MockedController();
    final stream = StreamController(sync: true);
    final validator = MockedValidator();

    final connector = StreamValidationConnector(
      field: 'field',
      validator: validator,
      stream: stream.stream,
      clearOnChange: true,
      validateOnChange: false,
    );

    connector.attach(controller);

    stream.sink.add('falue');

    verify(controller.clearFieldError('field')).called(1);

    stream.close();
  });

  test('should validate on change', () {
    final controller = MockedController();
    final stream = StreamController(sync: true);
    final validator = MockedValidator();

    final connector = StreamValidationConnector(
      field: 'field',
      validator: validator,
      stream: stream.stream,
      clearOnChange: false,
      validateOnChange: true,
    );

    connector.attach(controller);

    when(validator.call('value')).thenReturn(null);
    when(validator.call('value2')).thenReturn('Error validation');

    stream.sink.add('value');
    stream.sink.add('value2');

    verify(controller.clearFieldError('field')).called(1);
    verify(controller.addFieldError('field', 'Error validation')).called(1);

    stream.close();
  });

  test('should connect validator to the notifier', () {
    final controller = StreamController();
    final connector = controller.stream.connectValidator(field: 'field', validator: MockedValidator());

    expect(connector, isInstanceOf<ValidationConnector>());
    expect(connector.field, 'field');

    controller.close();
  });
}