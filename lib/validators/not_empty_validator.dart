import '../contracts/validator.dart';
import 'custom_validator.dart';

/// Checks value on `isNotEmpty`
class NotEmptyValidator {
  static String _defaultErrorMessage = 'can\'t be empty';

  /// Checks if string is not empty
  static Validator<String> string({
    String fieldName,
    String message,
  }) => CustomValidator<String>(
    fieldName: fieldName,
    message: (_) => message ?? _defaultErrorMessage,
    isValid: (value) => value.isNotEmpty,
  );

  /// Checks if string is not empty. Defines full error message
  static Validator<String> stringWithMessage(String message) =>
      CustomValidator<String>.withMessage(
        message: (_) => message,
        isValid: (value) => value.isNotEmpty,
      );

  /// Checks if [Iterable] is not empty
  static Validator<Iterable<I>> iterable<I>({
    String fieldName,
    String message,
  }) => CustomValidator<Iterable<I>>(
    fieldName: fieldName,
    message: (_) => message ?? _defaultErrorMessage,
    isValid: (value) => value.isNotEmpty,
  );

  /// Checks if [Iterable] is not empty. Defines full error message
  static Validator<Iterable<I>> iterableWithMessage<I>(String message) =>
      CustomValidator<Iterable<I>>.withMessage(
        message: (_) => message,
        isValid: (value) => value.isNotEmpty,
      );

  /// Checks if [Map] is not empty
  static Validator<Map<K,V>> map<K,V>({
    String fieldName,
    String message,
  }) => CustomValidator<Map<K,V>>(
    fieldName: fieldName,
    message: (_) => message ?? _defaultErrorMessage,
    isValid: (value) => value.isNotEmpty,
  );

  /// Checks if [Iterable] is not empty. Defines full error message
  static Validator<Map<K,V>> mapWithMessage<K,V>(String message) =>
      CustomValidator<Map<K,V>>.withMessage(
        message: (_) => message,
        isValid: (value) => value.isNotEmpty,
      );
}