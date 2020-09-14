import '../contracts/validator.dart';
import 'field_validator.dart';

/// Checks value on `isNotEmpty`
class NotEmptyValidator {
  static String _defaultErrorMessage = 'can\'t be empty';

  /// Checks if string is not empty
  static Validator<String> string({
    String fieldName,
    String errorMessage,
  }) => FieldValidator<String>(
    fieldName: fieldName,
    errorMessage: errorMessage ?? _defaultErrorMessage,
    isValid: (value) => value.isNotEmpty,
  );

  /// Checks if string is not empty. Defines full error message
  static Validator<String> stringWithMessage(String message) =>
      FieldValidator<String>.withMessage(
        message: message,
        isValid: (value) => value.isNotEmpty,
      );

  /// Checks if [Iterable] is not empty
  static Validator<Iterable<I>> iterable<I>({
    String fieldName,
    String errorMessage,
  }) => FieldValidator<Iterable<I>>(
    fieldName: fieldName,
    errorMessage: errorMessage ?? _defaultErrorMessage,
    isValid: (value) => value.isNotEmpty,
  );

  /// Checks if [Iterable] is not empty. Defines full error message
  static Validator<Iterable<I>> iterableWithMessage<I>(String message) =>
      FieldValidator<Iterable<I>>.withMessage(
        message: message,
        isValid: (value) => value.isNotEmpty,
      );

  /// Checks if [Map] is not empty
  static Validator<Map<K,V>> map<K,V>({
    String fieldName,
    String errorMessage,
  }) => FieldValidator<Map<K,V>>(
    fieldName: fieldName,
    errorMessage: errorMessage ?? _defaultErrorMessage,
    isValid: (value) => value.isNotEmpty,
  );

  /// Checks if [Iterable] is not empty. Defines full error message
  static Validator<Map<K,V>> mapWithMessage<K,V>(String message) =>
      FieldValidator<Map<K,V>>.withMessage(
        message: message,
        isValid: (value) => value.isNotEmpty,
      );
}