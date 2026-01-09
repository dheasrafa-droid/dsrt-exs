/// DSRT Engine - Debug Utilities
/// Debugging and development utilities.
library dsrt_engine.src.core.utils.debug_utils;

import 'dart:developer' as developer;
import 'dart:math' as math;
import '../../core/constants.dart';
import '../../core/events/event_system.dart';
import '../../core/events/event_types.dart';
import 'logger.dart';

/// Debug utilities for development and troubleshooting
class DebugUtils {
  /// Enable/disable debug mode globally
  static bool debugEnabled = false;
  
  /// Enable/disable verbose logging
  static bool verboseLogging = false;
  
  /// Enable/disable assertion checking
  static bool assertionsEnabled = true;
  
  /// Enable/disable performance warnings
  static bool performanceWarnings = true;
  
  /// Enable/disable memory leak detection
  static bool memoryLeakDetection = false;
  
  /// Debug event system
  static final EventSystem events = EventSystem();
  
  /// Logger instance
  static final Logger logger = Logger('Debug');
  
  /// Assertion with custom message
  static void assertCondition(bool condition, [String message = 'Assertion failed']) {
    if (assertionsEnabled && !condition) {
      final stackTrace = StackTrace.current;
      final error = AssertionError(message);
      
      logger.error('ASSERTION: $message', error, stackTrace);
      
      events.dispatch(ErrorEvent(
        message: 'Assertion failed: $message',
        error: error,
        stackTrace: stackTrace,
        severity: ErrorSeverity.error,
      ));
      
      // Break in debugger if available
      developer.debugger();
      
      throw error;
    }
  }
  
  /// Check for null with debug information
  static T checkNotNull<T>(T? value, [String name = 'value']) {
    if (value == null) {
      final message = '$name must not be null';
      final stackTrace = StackTrace.current;
      final error = ArgumentError.notNull(name);
      
      logger.error('NULL CHECK: $message', error, stackTrace);
      
      events.dispatch(ErrorEvent(
        message: message,
        error: error,
        stackTrace: stackTrace,
        severity: ErrorSeverity.error,
      ));
      
      throw error;
    }
    
    return value;
  }
  
  /// Check bounds with debug information
  static void checkBounds<T extends num>(T value, T min, T max, [String name = 'value']) {
    if (value < min || value > max) {
      final message = '$name ($value) must be between $min and $max';
      final stackTrace = StackTrace.current;
      final error = RangeError.range(value, min, max, name);
      
      logger.error('BOUNDS CHECK: $message', error, stackTrace);
      
      events.dispatch(ErrorEvent(
        message: message,
        error: error,
        stackTrace: stackTrace,
        severity: ErrorSeverity.error,
      ));
      
      throw error;
    }
  }
  
  /// Check index bounds with debug information
  static void checkIndex(int index, int length, [String name = 'index']) {
    if (index < 0 || index >= length) {
      final message = '$name ($index) out of range [0, $length)';
      final stackTrace = StackTrace.current;
      final error = RangeError.range(index, 0, length - 1, name);
      
      logger.error('INDEX CHECK: $message', error, stackTrace);
      
      events.dispatch(ErrorEvent(
        message: message,
        error: error,
        stackTrace: stackTrace,
        severity: ErrorSeverity.error,
      ));
      
      throw error;
    }
  }
  
  /// Log performance warning
  static void performanceWarning(String message, {Map<String, dynamic> data = const {}}) {
    if (performanceWarnings) {
      logger.warning('PERFORMANCE: $message');
      
      events.dispatch(DebugEvent(
        type: DebugEventType.performanceWarning,
        data: {'message': message, ...data},
      ));
    }
  }
  
  /// Log performance critical
  static void performanceCritical(String message, {Map<String, dynamic> data = const {}}) {
    logger.error('PERFORMANCE CRITICAL: $message');
    
    events.dispatch(DebugEvent(
      type: DebugEventType.performanceCritical,
      data: {'message': message, ...data},
    ));
  }
  
  /// Log memory usage
  static void logMemoryUsage([String context = '']) {
    if (memoryLeakDetection) {
      // This would use platform-specific memory APIs
      // For web: performance.memory
      // For native: ProcessInfo
      
      final message = 'Memory usage${context.isNotEmpty ? ' ($context)' : ''}';
      logger.info(message);
      
      if (verboseLogging) {
        developer.log(message, name: 'Memory');
      }
    }
  }
  
  /// Measure execution time
  static T measureTime<T>(String operation, T Function() callback, {bool logResult = true}) {
    final stopwatch = Stopwatch()..start();
    final result = callback();
    stopwatch.stop();
    
    final elapsed = stopwatch.elapsedMicroseconds / 1000.0;
    
    if (logResult) {
      logger.debug('$operation took ${elapsed.toStringAsFixed(2)}ms');
    }
    
    if (performanceWarnings && elapsed > 16.67) { // More than 60 FPS frame time
      performanceWarning('$operation took ${elapsed.toStringAsFixed(2)}ms');
    }
    
    return result;
  }
  
  /// Async measure execution time
  static Future<T> measureTimeAsync<T>(String operation, Future<T> Function() callback, {bool logResult = true}) async {
    final stopwatch = Stopwatch()..start();
    final result = await callback();
    stopwatch.stop();
    
    final elapsed = stopwatch.elapsedMicroseconds / 1000.0;
    
    if (logResult) {
      logger.debug('$operation took ${elapsed.toStringAsFixed(2)}ms');
    }
    
    if (performanceWarnings && elapsed > 16.67) {
      performanceWarning('$operation took ${elapsed.toStringAsFixed(2)}ms');
    }
    
    return result;
  }
  
  /// Count function calls for profiling
  static Map<String, int> _callCounts = {};
  
  /// Count function call
  static void countCall(String functionName) {
    if (!debugEnabled) return;
    
    _callCounts[functionName] = (_callCounts[functionName] ?? 0) + 1;
  }
  
  /// Get call counts
  static Map<String, int> getCallCounts() {
    return Map.from(_callCounts);
  }
  
  /// Reset call counts
  static void resetCallCounts() {
    _callCounts.clear();
  }
  
  /// Print call counts
  static void printCallCounts() {
    if (_callCounts.isEmpty) {
      logger.info('No call counts recorded');
      return;
    }
    
    logger.info('=== Function Call Counts ===');
    final sorted = _callCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    
    for (final entry in sorted) {
      logger.info('${entry.key}: ${entry.value} calls');
    }
    logger.info('===========================');
  }
  
  /// Debug breakpoint
  static void breakpoint([String message = '']) {
    if (!debugEnabled) return;
    
    logger.info('BREAKPOINT${message.isNotEmpty ? ': $message' : ''}');
    developer.debugger();
    
    events.dispatch(DebugEvent(
      type: DebugEventType.breakpointHit,
      data: {'message': message},
    ));
  }
  
  /// Conditional breakpoint
  static void breakIf(bool condition, [String message = '']) {
    if (condition) {
      breakpoint(message);
    }
  }
  
  /// Log variable state
  static void logVariable(String name, dynamic value) {
    if (!debugEnabled) return;
    
    final stringValue = value?.toString() ?? 'null';
    logger.debug('$name = $stringValue (${value?.runtimeType})');
    
    events.dispatch(DebugEvent(
      type: DebugEventType.variableChanged,
      data: {'name': name, 'value': stringValue, 'type': value?.runtimeType.toString()},
    ));
  }
  
  /// Log object properties
  static void logObject(String name, dynamic object, {List<String>? properties}) {
    if (!debugEnabled) return;
    
    logger.debug('=== $name ===');
    
    if (object == null) {
      logger.debug('null');
      return;
    }
    
    try {
      if (properties != null) {
        for (final prop in properties) {
          final value = _getProperty(object, prop);
          logger.debug('$prop: $value');
        }
      } else {
        // Try to get all properties
        logger.debug(object.toString());
      }
    } catch (e) {
      logger.debug('Error inspecting object: $e');
    }
    
    logger.debug('================');
  }
  
  /// Get property value using reflection (limited)
  static dynamic _getProperty(dynamic object, String property) {
    try {
      if (object is Map) {
        return object[property];
      }
      
      // Use noSuchMethod trick for getting private properties
      return _getPropertyViaNoSuchMethod(object, property);
    } catch (e) {
      return '<unable to access>';
    }
  }
  
  /// Try to get property via noSuchMethod
  static dynamic _getPropertyViaNoSuchMethod(dynamic object, String property) {
    try {
      // This is a simplified approach
      // In real implementation, you might use dart:mirrors or code generation
      return object[property];
    } catch (e) {
      return '<unable to access>';
    }
  }
  
  /// Trace function calls
  static void trace([String message = '']) {
    if (!debugEnabled) return;
    
    final stackTrace = StackTrace.current;
    final lines = stackTrace.toString().split('\n');
    
    logger.debug('TRACE${message.isNotEmpty ? ': $message' : ''}');
    
    // Print first few stack frames
    final maxFrames = math.min(5, lines.length);
    for (int i = 1; i < maxFrames; i++) { // Skip first line (this function)
      logger.debug('  ${lines[i].trim()}');
    }
    
    events.dispatch(DebugEvent(
      type: DebugEventType.stackTraceCaptured,
      data: {'message': message, 'stackTrace': stackTrace.toString()},
    ));
  }
  
  /// Validate state with custom validator
  static void validateState(bool isValid, String context, [Map<String, dynamic> data = const {}]) {
    if (!isValid) {
      final message = 'State validation failed: $context';
      final stackTrace = StackTrace.current;
      
      logger.error('STATE VALIDATION: $message', null, stackTrace);
      
      events.dispatch(ErrorEvent(
        message: message,
        error: StateError(message),
        stackTrace: stackTrace,
        severity: ErrorSeverity.error,
        data: data,
      ));
    }
  }
  
  /// Check for NaN or infinite values
  static void checkNumber(double value, String name) {
    if (value.isNaN) {
      final error = ArgumentError('$name is NaN');
      logger.error('NAN CHECK: $name is NaN', error);
      throw error;
    }
    
    if (value.isInfinite) {
      final error = ArgumentError('$name is infinite');
      logger.error('INFINITE CHECK: $name is infinite', error);
      throw error;
    }
  }
  
  /// Check list/collection invariants
  static void checkCollection<T>(List<T> collection, String name) {
    if (collection.length != collection.toSet().length) {
      logger.warning('Collection $name contains duplicate elements');
    }
  }
  
  /// Enable all debug features
  static void enableAll() {
    debugEnabled = true;
    verboseLogging = true;
    assertionsEnabled = true;
    performanceWarnings = true;
    memoryLeakDetection = true;
    
    logger.info('All debug features enabled');
  }
  
  /// Disable all debug features
  static void disableAll() {
    debugEnabled = false;
    verboseLogging = false;
    assertionsEnabled = false;
    performanceWarnings = false;
    memoryLeakDetection = false;
    
    logger.info('All debug features disabled');
  }
  
  /// Dump debug information to console
  static void dumpInfo() {
    logger.info('=== Debug Information ===');
    logger.info('Debug enabled: $debugEnabled');
    logger.info('Verbose logging: $verboseLogging');
    logger.info('Assertions enabled: $assertionsEnabled');
    logger.info('Performance warnings: $performanceWarnings');
    logger.info('Memory leak detection: $memoryLeakDetection');
    logger.info('Call counts: ${_callCounts.length} functions tracked');
    logger.info('========================');
  }
  
  /// Create debug overlay data
  static Map<String, dynamic> createDebugOverlay() {
    return {
      'debugEnabled': debugEnabled,
      'verboseLogging': verboseLogging,
      'assertionsEnabled': assertionsEnabled,
      'performanceWarnings': performanceWarnings,
      'memoryLeakDetection': memoryLeakDetection,
      'callCounts': _callCounts.length,
      'timestamp': DateTime.now().toIso8601String(),
    };
  }
}

/// Debug scope for tracking resource usage
class DebugScope with Disposable {
  final String name;
  final DateTime startTime = DateTime.now();
  final Stopwatch stopwatch = Stopwatch();
  final Map<String, dynamic> metadata = {};
  
  int? _memoryStart;
  int? _memoryEnd;
  
  DebugScope(this.name) {
    stopwatch.start();
    DebugUtils.logger.debug('[$name] Scope started');
    
    if (DebugUtils.memoryLeakDetection) {
      // Record initial memory usage
      _memoryStart = _getMemoryUsage();
    }
  }
  
  /// Add metadata to scope
  void addMetadata(String key, dynamic value) {
    metadata[key] = value;
  }
  
  /// End scope and log results
  @override
  void dispose() {
    stopwatch.stop();
    final elapsed = stopwatch.elapsedMicroseconds / 1000.0;
    
    if (DebugUtils.memoryLeakDetection) {
      _memoryEnd = _getMemoryUsage();
    }
    
    final memoryInfo = _memoryStart != null && _memoryEnd != null
        ? 'Memory: ${_memoryEnd! - _memoryStart!} bytes'
        : '';
    
    DebugUtils.logger.debug('[$name] Scope ended - Time: ${elapsed.toStringAsFixed(2)}ms $memoryInfo');
    
    if (DebugUtils.performanceWarnings && elapsed > 16.67) {
      DebugUtils.performanceWarning('Scope "$name" took ${elapsed.toStringAsFixed(2)}ms');
    }
    
    super.dispose();
  }
  
  /// Get memory usage (platform-specific)
  int _getMemoryUsage() {
    // Placeholder - actual implementation would be platform-specific
    return 0;
  }
}

/// Debug resource tracker
class DebugResourceTracker {
  static final Map<String, int> _resourceCounts = {};
  static final Map<String, List<String>> _resourceOwners = {};
  
  /// Track resource creation
  static void trackResource(String type, String id, [String owner = '']) {
    if (!DebugUtils.debugEnabled) return;
    
    _resourceCounts[type] = (_resourceCounts[type] ?? 0) + 1;
    
    if (owner.isNotEmpty) {
      _resourceOwners.putIfAbsent(type, () => []).add('$id ($owner)');
    }
    
    DebugUtils.logger.debug('Resource created: $type#$id ${owner.isNotEmpty ? 'by $owner' : ''}');
  }
  
  /// Track resource disposal
  static void untrackResource(String type, String id) {
    if (!DebugUtils.debugEnabled) return;
    
    final count = _resourceCounts[type] ?? 0;
    if (count > 0) {
      _resourceCounts[type] = count - 1;
    }
    
    DebugUtils.logger.debug('Resource disposed: $type#$id');
  }
  
  /// Get resource counts
  static Map<String, int> getResourceCounts() {
    return Map.from(_resourceCounts);
  }
  
  /// Check for resource leaks
  static void checkForLeaks() {
    if (!DebugUtils.debugEnabled || !DebugUtils.memoryLeakDetection) return;
    
    final leaks = <String, int>{};
    
    for (final entry in _resourceCounts.entries) {
      if (entry.value > 0) {
        leaks[entry.key] = entry.value;
      }
    }
    
    if (leaks.isNotEmpty) {
      DebugUtils.logger.error('=== RESOURCE LEAKS DETECTED ===');
      for (final entry in leaks.entries) {
        DebugUtils.logger.error('${entry.key}: ${entry.value} potential leaks');
        
        final owners = _resourceOwners[entry.key];
        if (owners != null && owners.isNotEmpty) {
          DebugUtils.logger.error('  Owners: ${owners.take(5).join(', ')}${owners.length > 5 ? '...' : ''}');
        }
      }
      DebugUtils.logger.error('===============================');
    }
  }
  
  /// Reset resource tracking
  static void reset() {
    _resourceCounts.clear();
    _resourceOwners.clear();
  }
}

/// Disposable mixin for resource management
mixin Disposable {
  bool _disposed = false;
  
  bool get isDisposed => _disposed;
  
  @mustCallSuper
  void dispose() {
    _disposed = true;
  }
  
  /// Assert that object is not disposed
  void assertNotDisposed() {
    if (_disposed) {
      throw StateError('Object has been disposed');
    }
  }
}
