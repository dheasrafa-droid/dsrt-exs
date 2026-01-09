/// DSRT Engine - Validation Utilities
/// Input validation and data verification utilities.
library dsrt_engine.src.core.utils.validators;

import 'dart:math' as math;
import '../constants.dart';
import 'math_utils.dart';

/// Validation utilities for data verification
class Validators {
  /// Check if value is not null
  static bool isNotNull(dynamic value) {
    return value != null;
  }
  
  /// Check if string is not null or empty
  static bool isNotNullOrEmpty(String? value) {
    return value != null && value.isNotEmpty;
  }
  
  /// Check if list is not null or empty
  static bool isNotNullOrEmptyList(List<dynamic>? list) {
    return list != null && list.isNotEmpty;
  }
  
  /// Check if map is not null or empty
  static bool isNotNullOrEmptyMap(Map<dynamic, dynamic>? map) {
    return map != null && map.isNotEmpty;
  }
  
  /// Check if value is within range [min, max] inclusive
  static bool isInRange(num value, num min, num max) {
    return value >= min && value <= max;
  }
  
  /// Check if value is within exclusive range (min, max)
  static bool isInExclusiveRange(num value, num min, num max) {
    return value > min && value < max;
  }
  
  /// Check if value is positive
  static bool isPositive(num value) {
    return value > 0;
  }
  
  /// Check if value is non-negative
  static bool isNonNegative(num value) {
    return value >= 0;
  }
  
  /// Check if value is negative
  static bool isNegative(num value) {
    return value < 0;
  }
  
  /// Check if value is non-positive
  static bool isNonPositive(num value) {
    return value <= 0;
  }
  
  /// Check if value is finite
  static bool isFiniteNumber(num value) {
    return value.isFinite;
  }
  
  /// Check if value is infinite
  static bool isInfiniteNumber(num value) {
    return value.isInfinite;
  }
  
  /// Check if value is NaN
  static bool isNaNNumber(num value) {
    return value.isNaN;
  }
  
  /// Check if value is a valid number (finite and not NaN)
  static bool isValidNumber(num value) {
    return value.isFinite && !value.isNaN;
  }
  
  /// Check if string is a valid email address
  static bool isEmail(String email) {
    const pattern = r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$';
    return RegExp(pattern).hasMatch(email);
  }
  
  /// Check if string is a valid URL
  static bool isUrl(String url) {
    try {
      final uri = Uri.parse(url);
      return uri.isAbsolute;
    } catch (_) {
      return false;
    }
  }
  
  /// Check if string is a valid IP address (IPv4 or IPv6)
  static bool isIpAddress(String ip) {
    // IPv4 pattern
    const ipv4Pattern = r'^((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$';
    if (RegExp(ipv4Pattern).hasMatch(ip)) {
      return true;
    }
    
    // IPv6 pattern (simplified)
    const ipv6Pattern = r'^([0-9a-fA-F]{1,4}:){7}[0-9a-fA-F]{1,4}$';
    return RegExp(ipv6Pattern).hasMatch(ip);
  }
  
  /// Check if string is a valid phone number (simple validation)
  static bool isPhoneNumber(String phone) {
    // Remove common separators
    final cleaned = phone.replaceAll(RegExp(r'[\s\-\(\)\.\+]'), '');
    
    // Check if all remaining characters are digits
    if (!RegExp(r'^\d+$').hasMatch(cleaned)) {
      return false;
    }
    
    // Check length (typical phone numbers are 7-15 digits)
    return cleaned.length >= 7 && cleaned.length <= 15;
  }
  
  /// Check if string contains only alphabetic characters
  static bool isAlphabetic(String text) {
    return RegExp(r'^[a-zA-Z]+$').hasMatch(text);
  }
  
  /// Check if string contains only alphanumeric characters
  static bool isAlphanumeric(String text) {
    return RegExp(r'^[a-zA-Z0-9]+$').hasMatch(text);
  }
  
  /// Check if string contains only digits
  static bool isDigits(String text) {
    return RegExp(r'^[0-9]+$').hasMatch(text);
  }
  
  /// Check if string is a valid hexadecimal color code
  static bool isHexColor(String color) {
    final pattern = RegExp(r'^#?([0-9a-fA-F]{3}|[0-9a-fA-F]{6}|[0-9a-fA-F]{8})$');
    return pattern.hasMatch(color);
  }
  
  /// Check if string is a valid date in ISO 8601 format
  static bool isIsoDate(String date) {
    try {
      DateTime.parse(date);
      return true;
    } catch (_) {
      return false;
    }
  }
  
  /// Check if string is a valid JSON
  static bool isJson(String text) {
    try {
      // Try to parse as JSON
      // This is a simplified check - actual JSON parsing would be done elsewhere
      final trimmed = text.trim();
      return (trimmed.startsWith('{') && trimmed.endsWith('}')) ||
             (trimmed.startsWith('[') && trimmed.endsWith(']'));
    } catch (_) {
      return false;
    }
  }
  
  /// Check if value matches pattern
  static bool matchesPattern(String value, String pattern) {
    return RegExp(pattern).hasMatch(value);
  }
  
  /// Check if value has minimum length
  static bool hasMinLength(String value, int minLength) {
    return value.length >= minLength;
  }
  
  /// Check if value has maximum length
  static bool hasMaxLength(String value, int maxLength) {
    return value.length <= maxLength;
  }
  
  /// Check if value has exact length
  static bool hasExactLength(String value, int length) {
    return value.length == length;
  }
  
  /// Check if value contains substring
  static bool containsSubstring(String value, String substring) {
    return value.contains(substring);
  }
  
  /// Check if value starts with prefix
  static bool startsWith(String value, String prefix) {
    return value.startsWith(prefix);
  }
  
  /// Check if value ends with suffix
  static bool endsWith(String value, String suffix) {
    return value.endsWith(suffix);
  }
  
  /// Check if two values are equal (with optional epsilon for numbers)
  static bool equals(dynamic a, dynamic b, {double epsilon = DSRTConstants.epsilon}) {
    if (a is num && b is num) {
      return MathUtils.approximately(a.toDouble(), b.toDouble(), epsilon);
    }
    return a == b;
  }
  
  /// Check if two lists are equal
  static bool listEquals(List<dynamic>? a, List<dynamic>? b) {
    if (a == null || b == null) return a == b;
    if (a.length != b.length) return false;
    
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    
    return true;
  }
  
  /// Check if two maps are equal
  static bool mapEquals(Map<dynamic, dynamic>? a, Map<dynamic, dynamic>? b) {
    if (a == null || b == null) return a == b;
    if (a.length != b.length) return false;
    
    for (final key in a.keys) {
      if (!b.containsKey(key) || a[key] != b[key]) {
        return false;
      }
    }
    
    return true;
  }
  
  /// Check if value is one of allowed values
  static bool isOneOf(dynamic value, List<dynamic> allowedValues) {
    return allowedValues.contains(value);
  }
  
  /// Check if value is not one of disallowed values
  static bool isNotOneOf(dynamic value, List<dynamic> disallowedValues) {
    return !disallowedValues.contains(value);
  }
  
  /// Check if value is between two other values (inclusive)
  static bool isBetween(dynamic value, dynamic min, dynamic max) {
    if (value is Comparable) {
      return value.compareTo(min) >= 0 && value.compareTo(max) <= 0;
    }
    return false;
  }
  
  /// Check if value is greater than other
  static bool isGreaterThan(dynamic value, dynamic other) {
    if (value is Comparable) {
      return value.compareTo(other) > 0;
    }
    return false;
  }
  
  /// Check if value is greater than or equal to other
  static bool isGreaterThanOrEqual(dynamic value, dynamic other) {
    if (value is Comparable) {
      return value.compareTo(other) >= 0;
    }
    return false;
  }
  
  /// Check if value is less than other
  static bool isLessThan(dynamic value, dynamic other) {
    if (value is Comparable) {
      return value.compareTo(other) < 0;
    }
    return false;
  }
  
  /// Check if value is less than or equal to other
  static bool isLessThanOrEqual(dynamic value, dynamic other) {
    if (value is Comparable) {
      return value.compareTo(other) <= 0;
    }
    return false;
  }
  
  /// Check if value satisfies all validators
  static bool all(dynamic value, List<bool Function(dynamic)> validators) {
    for (final validator in validators) {
      if (!validator(value)) return false;
    }
    return true;
  }
  
  /// Check if value satisfies any validator
  static bool any(dynamic value, List<bool Function(dynamic)> validators) {
    for (final validator in validators) {
      if (validator(value)) return true;
    }
    return false;
  }
  
  /// Check if value satisfies none of the validators
  static bool none(dynamic value, List<bool Function(dynamic)> validators) {
    return !any(value, validators);
  }
  
  /// Validate with custom error message
  static ValidationResult validate(
    dynamic value,
    bool Function(dynamic) validator,
    String errorMessage,
  ) {
    if (validator(value)) {
      return ValidationResult.valid(value: value);
    } else {
      return ValidationResult.invalid(value: value, error: errorMessage);
    }
  }
  
  /// Validate with multiple validators
  static ValidationResult validateAll(
    dynamic value,
    List<ValidationRule> rules,
  ) {
    for (final rule in rules) {
      if (!rule.validator(value)) {
        return ValidationResult.invalid(value: value, error: rule.errorMessage);
      }
    }
    return ValidationResult.valid(value: value);
  }
  
  /// Validate collection elements
  static ValidationResult validateCollection(
    List<dynamic> collection,
    bool Function(dynamic) validator,
    String errorMessage,
  ) {
    for (int i = 0; i < collection.length; i++) {
      if (!validator(collection[i])) {
        return ValidationResult.invalid(
          value: collection,
          error: '$errorMessage at index $i',
        );
      }
    }
    return ValidationResult.valid(value: collection);
  }
  
  /// Validate map entries
  static ValidationResult validateMap(
    Map<dynamic, dynamic> map,
    bool Function(dynamic, dynamic) validator,
    String errorMessage,
  ) {
    for (final entry in map.entries) {
      if (!validator(entry.key, entry.value)) {
        return ValidationResult.invalid(
          value: map,
          error: '$errorMessage for key "${entry.key}"',
        );
      }
    }
    return ValidationResult.valid(value: map);
  }
  
  /// Sanitize string (remove invalid characters)
  static String sanitizeString(
    String input, {
    String allowedChars = r'a-zA-Z0-9\s\-_\.',
    String replacement = '',
  }) {
    final pattern = RegExp('[^$allowedChars]');
    return input.replaceAll(pattern, replacement);
  }
  
  /// Normalize string (trim, lowercase, etc.)
  static String normalizeString(
    String input, {
    bool trim = true,
    bool lowerCase = false,
    bool upperCase = false,
    bool collapseWhitespace = true,
  }) {
    var result = input;
    
    if (trim) result = result.trim();
    if (collapseWhitespace) {
      result = result.replaceAll(RegExp(r'\s+'), ' ');
    }
    if (lowerCase) result = result.toLowerCase();
    if (upperCase) result = result.toUpperCase();
    
    return result;
  }
  
  /// Ensure value is within bounds
  static num clampValue(num value, num min, num max) {
    return math.max(min, math.min(max, value));
  }
  
  /// Ensure value is positive (or zero)
  static num ensurePositive(num value, {bool allowZero = true}) {
    if (allowZero && value < 0) return 0;
    if (!allowZero && value <= 0) return 1;
    return value;
  }
  
  /// Ensure value is negative (or zero)
  static num ensureNegative(num value, {bool allowZero = true}) {
    if (allowZero && value > 0) return 0;
    if (!allowZero && value >= 0) return -1;
    return value;
  }
  
  /// Ensure value is finite
  static num ensureFinite(num value, num fallback) {
    return value.isFinite ? value : fallback;
  }
  
  /// Ensure value is not NaN
  static num ensureNotNaN(num value, num fallback) {
    return !value.isNaN ? value : fallback;
  }
  
  /// Ensure list is not null
  static List<T> ensureNotNullList<T>(List<T>? list) {
    return list ?? <T>[];
  }
  
  /// Ensure map is not null
  static Map<K, V> ensureNotNullMap<K, V>(Map<K, V>? map) {
    return map ?? <K, V>{};
  }
  
  /// Ensure string is not null or empty
  static String ensureNotNullOrEmpty(String? value, String fallback) {
    return value != null && value.isNotEmpty ? value : fallback;
  }
}

/// Validation rule with error message
class ValidationRule {
  final bool Function(dynamic) validator;
  final String errorMessage;
  
  ValidationRule(this.validator, this.errorMessage);
}

/// Validation result
class ValidationResult {
  final bool isValid;
  final dynamic value;
  final String? error;
  final List<ValidationError>? errors;
  
  ValidationResult._({
    required this.isValid,
    required this.value,
    this.error,
    this.errors,
  });
  
  factory ValidationResult.valid({required dynamic value}) {
    return ValidationResult._(isValid: true, value: value);
  }
  
  factory ValidationResult.invalid({
    required dynamic value,
    String? error,
    List<ValidationError>? errors,
  }) {
    return ValidationResult._(
      isValid: false,
      value: value,
      error: error,
      errors: errors,
    );
  }
  
  /// Throw exception if invalid
  void throwIfInvalid() {
    if (!isValid) {
      throw ValidationException(
        error ?? 'Validation failed',
        errors ?? [],
      );
    }
  }
  
  /// Get error message (first error)
  String get errorMessage {
    if (isValid) return '';
    if (error != null) return error!;
    if (errors != null && errors!.isNotEmpty) {
      return errors!.first.message;
    }
    return 'Validation failed';
  }
  
  /// Get all error messages
  List<String> get errorMessages {
    final messages = <String>[];
    if (error != null) messages.add(error!);
    if (errors != null) {
      messages.addAll(errors!.map((e) => e.message));
    }
    return messages;
  }
}

/// Validation error details
class ValidationError {
  final String field;
  final String message;
  final dynamic value;
  final String? code;
  
  ValidationError({
    required this.field,
    required this.message,
    required this.value,
    this.code,
  });
  
  @override
  String toString() {
    return '$field: $message (value: $value)';
  }
}

/// Validation exception
class ValidationException implements Exception {
  final String message;
  final List<ValidationError> errors;
  
  ValidationException(this.message, this.errors);
  
  @override
  String toString() {
    final buffer = StringBuffer('ValidationException: $message\n');
    for (final error in errors) {
      buffer.write('  ${error.toString()}\n');
    }
    return buffer.toString();
  }
}

/// Field validator builder
class FieldValidator<T> {
  final String fieldName;
  final List<ValidationRule> _rules = [];
  
  FieldValidator(this.fieldName);
  
  /// Add required rule
  FieldValidator<T> required({String? message}) {
    _rules.add(ValidationRule(
      (value) => value != null,
      message ?? '$fieldName is required',
    ));
    return this;
  }
  
  /// Add not empty rule (for strings, lists, maps)
  FieldValidator<T> notEmpty({String? message}) {
    _rules.add(ValidationRule(
      (value) {
        if (value == null) return false;
        if (value is String) return value.isNotEmpty;
        if (value is List) return value.isNotEmpty;
        if (value is Map) return value.isNotEmpty;
        return true; // Non-collection types are considered not empty
      },
      message ?? '$fieldName must not be empty',
    ));
    return this;
  }
  
  /// Add minimum length rule
  FieldValidator<T> minLength(int min, {String? message}) {
    _rules.add(ValidationRule(
      (value) => value is String && value.length >= min,
      message ?? '$fieldName must be at least $min characters',
    ));
    return this;
  }
  
  /// Add maximum length rule
  FieldValidator<T> maxLength(int max, {String? message}) {
    _rules.add(ValidationRule(
      (value) => value is String && value.length <= max,
      message ?? '$fieldName must be at most $max characters',
    ));
    return this;
  }
  
  /// Add exact length rule
  FieldValidator<T> exactLength(int length, {String? message}) {
    _rules.add(ValidationRule(
      (value) => value is String && value.length == length,
      message ?? '$fieldName must be exactly $length characters',
    ));
    return this;
  }
  
  /// Add email validation rule
  FieldValidator<T> email({String? message}) {
    _rules.add(ValidationRule(
      (value) => value is String && Validators.isEmail(value),
      message ?? '$fieldName must be a valid email address',
    ));
    return this;
  }
  
  /// Add URL validation rule
  FieldValidator<T> url({String? message}) {
    _rules.add(ValidationRule(
      (value) => value is String && Validators.isUrl(value),
      message ?? '$fieldName must be a valid URL',
    ));
    return this;
  }
  
  /// Add pattern matching rule
  FieldValidator<T> matches(String pattern, {String? message}) {
    final regex = RegExp(pattern);
    _rules.add(ValidationRule(
      (value) => value is String && regex.hasMatch(value),
      message ?? '$fieldName must match pattern',
    ));
    return this;
  }
  
  /// Add numeric range rule
  FieldValidator<T> range(num min, num max, {String? message}) {
    _rules.add(ValidationRule(
      (value) => value is num && value >= min && value <= max,
      message ?? '$fieldName must be between $min and $max',
    ));
    return this;
  }
  
  /// Add minimum value rule
  FieldValidator<T> min(num min, {String? message}) {
    _rules.add(ValidationRule(
      (value) => value is num && value >= min,
      message ?? '$fieldName must be at least $min',
    ));
    return this;
  }
  
  /// Add maximum value rule
  FieldValidator<T> max(num max, {String? message}) {
    _rules.add(ValidationRule(
      (value) => value is num && value <= max,
      message ?? '$fieldName must be at most $max',
    ));
    return this;
  }
  
  /// Add positive number rule
  FieldValidator<T> positive({String? message}) {
    _rules.add(ValidationRule(
      (value) => value is num && value > 0,
      message ?? '$fieldName must be positive',
    ));
    return this;
  }
  
  /// Add negative number rule
  FieldValidator<T> negative({String? message}) {
    _rules.add(ValidationRule(
      (value) => value is num && value < 0,
      message ?? '$fieldName must be negative',
    ));
    return this;
  }
  
  /// Add integer rule
  FieldValidator<T> integer({String? message}) {
    _rules.add(ValidationRule(
      (value) => value is num && value % 1 == 0,
      message ?? '$fieldName must be an integer',
    ));
    return this;
  }
  
  /// Add custom validation rule
  FieldValidator<T> custom(
    bool Function(T?) validator,
    String message,
  ) {
    _rules.add(ValidationRule(
      (value) => validator(value as T?),
      message,
    ));
    return this;
  }
  
  /// Validate value
  ValidationResult validate(T? value) {
    for (final rule in _rules) {
      if (!rule.validator(value)) {
        return ValidationResult.invalid(
          value: value,
          error: rule.errorMessage,
          errors: [
            ValidationError(
              field: fieldName,
              message: rule.errorMessage,
              value: value,
            ),
          ],
        );
      }
    }
    return ValidationResult.valid(value: value);
  }
  
  /// Get rules count
  int get ruleCount => _rules.length;
}

/// Schema validator for complex data structures
class SchemaValidator {
  final Map<String, FieldValidator<dynamic>> _fields = {};
  
  /// Add field validator
  void addField(String fieldName, FieldValidator<dynamic> validator) {
    _fields[fieldName] = validator;
  }
  
  /// Validate data against schema
  ValidationResult validate(Map<String, dynamic> data) {
    final errors = <ValidationError>[];
    
    for (final entry in _fields.entries) {
      final fieldName = entry.key;
      final validator = entry.value;
      final value = data[fieldName];
      
      final result = validator.validate(value);
      if (!result.isValid) {
        if (result.errors != null) {
          errors.addAll(result.errors!);
        } else {
          errors.add(ValidationError(
            field: fieldName,
            message: result.errorMessage,
            value: value,
          ));
        }
      }
    }
    
    // Check for extra fields
    for (final fieldName in data.keys) {
      if (!_fields.containsKey(fieldName)) {
        errors.add(ValidationError(
          field: fieldName,
          message: 'Unexpected field',
          value: data[fieldName],
          code: 'UNEXPECTED_FIELD',
        ));
      }
    }
    
    if (errors.isEmpty) {
      return ValidationResult.valid(value: data);
    } else {
      return ValidationResult.invalid(
        value: data,
        errors: errors,
      );
    }
  }
  
  /// Validate partial data (allow missing fields)
  ValidationResult validatePartial(Map<String, dynamic> data) {
    final errors = <ValidationError>[];
    
    for (final entry in data.entries) {
      final fieldName = entry.key;
      final value = entry.value;
      
      final validator = _fields[fieldName];
      if (validator != null) {
        final result = validator.validate(value);
        if (!result.isValid) {
          if (result.errors != null) {
            errors.addAll(result.errors!);
          } else {
            errors.add(ValidationError(
              field: fieldName,
              message: result.errorMessage,
              value: value,
            ));
          }
        }
      }
    }
    
    if (errors.isEmpty) {
      return ValidationResult.valid(value: data);
    } else {
      return ValidationResult.invalid(
        value: data,
        errors: errors,
      );
    }
  }
  
  /// Get field validator
  FieldValidator<dynamic>? getFieldValidator(String fieldName) {
    return _fields[fieldName];
  }
  
  /// Get all field names
  Set<String> get fieldNames => _fields.keys.toSet();
  
  /// Clear all field validators
  void clear() {
    _fields.clear();
  }
}

/// Runtime type checker
class TypeChecker {
  /// Check if value is of specified type
  static bool isType<T>(dynamic value) {
    return value is T;
  }
  
  /// Check if value is numeric
  static bool isNumeric(dynamic value) {
    return value is num;
  }
  
  /// Check if value is string
  static bool isString(dynamic value) {
    return value is String;
  }
  
  /// Check if value is boolean
  static bool isBoolean(dynamic value) {
    return value is bool;
  }
  
  /// Check if value is list
  static bool isList(dynamic value) {
    return value is List;
  }
  
  /// Check if value is map
  static bool isMap(dynamic value) {
    return value is Map;
  }
  
  /// Check if value is date
  static bool isDateTime(dynamic value) {
    return value is DateTime;
  }
  
  /// Check if value is enum
  static bool isEnum(dynamic value) {
    return value is Enum;
  }
  
  /// Cast value to type with validation
  static T? cast<T>(dynamic value, {T? defaultValue}) {
    if (value is T) {
      return value;
    }
    return defaultValue;
  }
  
  /// Cast value to type or throw
  static T castOrThrow<T>(dynamic value, [String? errorMessage]) {
    if (value is T) {
      return value;
    }
    throw ValidationException(
      errorMessage ?? 'Expected type ${T.toString()} but got ${value.runtimeType}',
      [],
    );
  }
  
  /// Ensure value is of type
  static T ensureType<T>(dynamic value, T defaultValue) {
    if (value is T) {
      return value;
    }
    return defaultValue;
  }
  
  /// Convert value to type if possible
  static T? convert<T>(dynamic value, T? Function(dynamic) converter) {
    return converter(value);
  }
}

/// Validation utilities for engine-specific types
class EngineValidators {
  /// Check if value is valid color (integer or hex string)
  static bool isValidColor(dynamic value) {
    if (value is int) {
      return value >= 0 && value <= 0xFFFFFFFF;
    }
    if (value is String) {
      return Validators.isHexColor(value);
    }
    return false;
  }
  
  /// Check if value is valid vector (list of 2, 3, or 4 numbers)
  static bool isValidVector(dynamic value) {
    if (value is! List) return false;
    if (value.length < 2 || value.length > 4) return false;
    
    for (final element in value) {
      if (element is! num) return false;
    }
    
    return true;
  }
  
  /// Check if value is valid matrix (list of lists)
  static bool isValidMatrix(dynamic value) {
    if (value is! List) return false;
    if (value.isEmpty) return false;
    
    final rowCount = value.length;
    int? colCount;
    
    for (final row in value) {
      if (row is! List) return false;
      if (colCount == null) {
        colCount = row.length;
      } else if (row.length != colCount) {
        return false;
      }
      
      for (final element in row) {
        if (element is! num) return false;
      }
    }
    
    return true;
  }
  
  /// Check if value is valid vertex data
  static bool isValidVertexData(dynamic value) {
    if (value is! List) return false;
    
    for (final vertex in value) {
      if (!isValidVector(vertex)) return false;
    }
    
    return true;
  }
  
  /// Check if value is valid UV coordinates (list of 2 numbers)
  static bool isValidUV(dynamic value) {
    if (value is! List || value.length != 2) return false;
    return value[0] is num && value[1] is num;
  }
  
  /// Check if value is valid normal vector (list of 3 numbers, normalized)
  static bool isValidNormal(dynamic value) {
    if (!isValidVector(value) || (value as List).length != 3) return false;
    
    final x = value[0] as num;
    final y = value[1] as num;
    final z = value[2] as num;
    
    final length = math.sqrt(x * x + y * y + z * z);
    return MathUtils.approximately(length, 1.0);
  }
  
  /// Check if value is valid transformation matrix (4x4)
  static bool isValidTransformMatrix(dynamic value) {
    if (!isValidMatrix(value)) return false;
    
    final matrix = value as List<List<num>>;
    if (matrix.length != 4) return false;
    
    for (final row in matrix) {
      if (row.length != 4) return false;
    }
    
    return true;
  }
  
  /// Check if value is valid quaternion (list of 4 numbers, normalized)
  static bool isValidQuaternion(dynamic value) {
    if (value is! List || value.length != 4) return false;
    
    for (final element in value) {
      if (element is! num) return false;
    }
    
    final x = value[0] as num;
    final y = value[1] as num;
    final z = value[2] as num;
    final w = value[3] as num;
    
    final length = math.sqrt(x * x + y * y + z * z + w * w);
    return MathUtils.approximately(length, 1.0);
  }
  
  /// Check if value is valid Euler angles (list of 3 numbers)
  static bool isValidEulerAngles(dynamic value) {
    if (value is! List || value.length != 3) return false;
    
    for (final element in value) {
      if (element is! num) return false;
    }
    
    return true;
  }
  
  /// Check if value is valid bounding box (min and max vectors)
  static bool isValidBoundingBox(dynamic value) {
    if (value is! List || value.length != 2) return false;
    
    if (!isValidVector(value[0]) || !isValidVector(value[1])) {
      return false;
    }
    
    // Check that min <= max for each component
    final min = value[0] as List<num>;
    final max = value[1] as List<num>;
    
    if (min.length != max.length) return false;
    
    for (int i = 0; i < min.length; i++) {
      if (min[i] > max[i]) return false;
    }
    
    return true;
  }
}
