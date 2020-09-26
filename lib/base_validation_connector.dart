import 'contracts/validation_connector.dart';
import 'contracts/validation_controller.dart';

abstract class BaseValidationConnector<K,I> implements ValidationConnector<K, I> {
  ValidationController<K> _controller;

  @override
  final K field;

  BaseValidationConnector(this.field);

  ValidationController<K> get controller => _controller;

  @override
  void attach(ValidationController<K> controller) {
    if (_controller != null) {
      throw UnsupportedError('Validator can be attached to only single controller');
    }

    _controller = controller;
    _controller.addConnector(this);
  }

  @override
  void detach() {
    if (_controller == null) {
      throw UnsupportedError('Validator not attached');
    }

    _controller?.removeConnector(this);
    _controller = null;
  }

  @override
  void validateField() {
    if (_controller == null) {
      throw UnsupportedError('Connector should be attached to the controller');
    }

    final String error = validate();
    if (error == null) {
      return _controller.clearFieldError(field);
    }

    _controller.addFieldError(field, error);
  }
}