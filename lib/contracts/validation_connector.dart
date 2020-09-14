import 'validation_controller.dart';

abstract class ValidationConnector<K,I> {
  /// Field key for error message
  K get field;

  /// Attach connector to the validation controller
  void attach(ValidationController<K> controller);

  /// Detach connector from the validation controller
  void detach();

  /// Validate current field value
  String validate();
}