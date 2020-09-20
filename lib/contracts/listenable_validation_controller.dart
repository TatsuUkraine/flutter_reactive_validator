import 'package:flutter/foundation.dart';

import 'validation_controller.dart';

abstract class ListenableValidationController<K> extends ValidationController<K> {

  /// [ValueListenable] with all validation error messages.
  ValueListenable<Map<K, String>> get errorsNotifier;
}