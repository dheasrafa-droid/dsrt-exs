/// Logging system for engine diagnostics
/// 
/// Provides leveled logging with category filtering.
/// Works offline, no external dependencies.
/// 
/// @license MIT
/// @copyright (c) 2024 DSRT Engine

import 'dart:developer' as developer;

/// Log levels in increasing order of severity
enum ExsLogLevel {
  /// Verbose debug information
  verbose(0),
  
  /// General debug information
  debug(1),
  
  /// Informational messages
  info(2),
  
  /// Warning messages
  warning(3),
  
  /// Error messages
  error(4),
  
  /// Critical errors
  critical(5);
  
  /// Numeric value for comparison
  final int value;
  
  const ExsLogLevel(this.value);
  
  /// Check if this level includes another level
  bool includes(ExsLogLevel other) => value <= other.value;
  
  /// Get level name
  String get displayName {
    switch (this) {
      case ExsLogLevel.verbose: return 'VERBOSE';
      case ExsLogLevel.debug: return 'DEBUG';
      case ExsLogLevel.info: return 'INFO';
      case ExsLogLevel.warning: return 'WARNING';
      case ExsLogLevel.error: return 'ERROR';
      case ExsLogLevel.critical: return 'CRITICAL';
    }
  }
}

/// Log entry
class ExsLogEntry {
  /// Timestamp
  final DateTime timestamp;
  
  /// Log level
  final ExsLogLevel level;
  
  /// Category/logger name
  final String category;
  
  /// Message
  final String message;
  
  /// Stack trace (optional)
  final StackTrace? stackTrace;
  
  /// Additional data
  final Map<String, dynamic>? data;
  
  /// Constructor
  ExsLogEntry({
    required this.level,
    required this.category,
    required this.message,
    this.stackTrace,
    this.data,
  }) : timestamp = DateTime.now();
  
  /// Format as string
  @override
  String toString() {
    final time = '${timestamp.hour.toString().padLeft(2, '0')}:'
                '${timestamp.minute.toString().padLeft(2, '0')}:'
                '${timestamp.second.toString().padLeft(2, '0')}.'
                '${timestamp.millisecond.toString().padLeft(3, '0')}';
    
    var result = '[${level.displayName}] $time [$category] $message';
    
    if (data != null && data!.isNotEmpty) {
      result += ' ${data.toString()}';
    }
    
    if (stackTrace != null) {
      result += '\n$stackTrace';
    }
    
    return result;
  }
}

/// Log handler interface
abstract class ExsLogHandler {
  /// Handle a log entry
  void handle(ExsLogEntry entry);
}

/// Console log handler (prints to console)
class ExsConsoleLogHandler implements ExsLogHandler {
  /// Minimum level to log
  final ExsLogLevel minLevel;
  
  /// Include stack traces
  final bool includeStackTraces;
  
  /// Constructor
  ExsConsoleLogHandler({
    this.minLevel = ExsLogLevel.info,
    this.includeStackTraces = false,
  });
  
  @override
  void handle(ExsLogEntry entry) {
    if (entry.level.value < minLevel.value) {
      return;
    }
    
    final message = entry.toString();
    
    switch (entry.level) {
      case ExsLogLevel.verbose:
      case ExsLogLevel.debug:
        developer.log(message, name: entry.category, level: 0);
        break;
      case ExsLogLevel.info:
        developer.log(message, name: entry.category, level: 1000);
        break;
      case ExsLogLevel.warning:
        developer.log(message, name: entry.category, level: 2000);
        break;
      case ExsLogLevel.error:
      case ExsLogLevel.critical:
        developer.log(message, name: entry.category, level: 3000);
        break;
    }
    
    // Also print to console for visibility
    print(message);
  }
}

/// Memory log handler (stores logs in memory)
class ExsMemoryLogHandler implements ExsLogHandler {
  /// Maximum number of entries to keep
  final int maxEntries;
  
  /// Log entries
  final List<ExsLogEntry> _entries = [];
  
  /// Constructor
  ExsMemoryLogHandler({this.maxEntries = 1000});
  
  @override
  void handle(ExsLogEntry entry) {
    _entries.add(entry);
    
    // Remove oldest entries if over limit
    if (_entries.length > maxEntries) {
      _entries.removeRange(0, _entries.length - maxEntries);
    }
  }
  
  /// Get all log entries
  List<ExsLogEntry> get entries => List.unmodifiable(_entries);
  
  /// Get entries by level
  List<ExsLogEntry> getEntriesByLevel(ExsLogLevel level) {
    return _entries.where((entry) => entry.level == level).toList();
  }
  
  /// Get entries by category
  List<ExsLogEntry> getEntriesByCategory(String category) {
    return _entries.where((entry) => entry.category == category).toList();
  }
  
  /// Clear all entries
  void clear() {
    _entries.clear();
  }
  
  /// Get entry count
  int get count => _entries.length;
}

/// File log handler (writes to file - placeholder for file system support)
class ExsFileLogHandler implements ExsLogHandler {
  final String _filePath;
  final ExsLogLevel _minLevel;
  
  ExsFileLogHandler(String filePath, {ExsLogLevel minLevel = ExsLogLevel.info})
    : _filePath = filePath,
      _minLevel = minLevel;
  
  @override
  void handle(ExsLogEntry entry) {
    if (entry.level.value < _minLevel.value) {
      return;
    }
    
    // File system operations would go here
    // For now, this is a placeholder
    // In a real implementation, would write to file
  }
}

/// Logger class
class ExsLogger {
  /// Category/name of this logger
  final String category;
  
  /// Minimum log level
  ExsLogLevel minLevel;
  
  /// Log handlers
  static final List<ExsLogHandler> _handlers = [
    ExsConsoleLogHandler(),
    ExsMemoryLogHandler(),
  ];
  
  /// Constructor
  ExsLogger(this.category, {this.minLevel = ExsLogLevel.info});
  
  /// Add a log handler globally
  static void addHandler(ExsLogHandler handler) {
    _handlers.add(handler);
  }
  
  /// Remove a log handler
  static void removeHandler(ExsLogHandler handler) {
    _handlers.remove(handler);
  }
  
  /// Clear all handlers
  static void clearHandlers() {
    _handlers.clear();
  }
  
  /// Get memory log handler if available
  static ExsMemoryLogHandler? getMemoryHandler() {
    for (final handler in _handlers) {
      if (handler is ExsMemoryLogHandler) {
        return handler;
      }
    }
    return null;
  }
  
  /// Log verbose message
  void verbose(String message, {StackTrace? stackTrace, Map<String, dynamic>? data}) {
    _log(ExsLogLevel.verbose, message, stackTrace, data);
  }
  
  /// Log debug message
  void debug(String message, {StackTrace? stackTrace, Map<String, dynamic>? data}) {
    _log(ExsLogLevel.debug, message, stackTrace, data);
  }
  
  /// Log info message
  void info(String message, {StackTrace? stackTrace, Map<String, dynamic>? data}) {
    _log(ExsLogLevel.info, message, stackTrace, data);
  }
  
  /// Log warning message
  void warning(String message, {StackTrace? stackTrace, Map<String, dynamic>? data}) {
    _log(ExsLogLevel.warning, message, stackTrace, data);
  }
  
  /// Log error message
  void error(String message, {StackTrace? stackTrace, Map<String, dynamic>? data}) {
    _log(ExsLogLevel.error, message, stackTrace, data);
  }
  
  /// Log critical message
  void critical(String message, {StackTrace? stackTrace, Map<String, dynamic>? data}) {
    _log(ExsLogLevel.critical, message, stackTrace, data);
  }
  
  /// Internal log method
  void _log(ExsLogLevel level, String message, StackTrace? stackTrace, Map<String, dynamic>? data) {
    if (level.value < minLevel.value) {
      return;
    }
    
    final entry = ExsLogEntry(
      level: level,
      category: category,
      message: message,
      stackTrace: stackTrace,
      data: data,
    );
    
    for (final handler in _handlers) {
      try {
        handler.handle(entry);
      } catch (e) {
        // Don't let handler errors crash the engine
        print('Error in log handler: $e');
      }
    }
  }
  
  /// Check if verbose logging is enabled
  bool get isVerboseEnabled => minLevel.includes(ExsLogLevel.verbose);
  
  /// Check if debug logging is enabled
  bool get isDebugEnabled => minLevel.includes(ExsLogLevel.debug);
  
  /// Check if info logging is enabled
  bool get isInfoEnabled => minLevel.includes(ExsLogLevel.info);
  
  /// Check if warning logging is enabled
  bool get isWarningEnabled => minLevel.includes(ExsLogLevel.warning);
  
  /// Check if error logging is enabled
  bool get isErrorEnabled => minLevel.includes(ExsLogLevel.error);
}
