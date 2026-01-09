/// DSRT Engine - Performance Profiler
/// Performance profiling and measurement tools.
library dsrt_engine.src.core.performance.profiler;

import 'dart:collection';
import 'dart:math' as math;
import '../../utils/logger.dart';

/// Performance profiler for measuring execution times
class Profiler {
  /// Profiler singleton instance
  static final Profiler _instance = Profiler._internal();
  
  /// Get profiler instance
  factory Profiler() => _instance;
  
  /// Internal constructor
  Profiler._internal();
  
  /// Logger instance
  final Logger _logger = Logger('Profiler');
  
  /// Enabled state
  bool _enabled = false;
  
  /// Active measurements
  final Map<String, _Measurement> _activeMeasurements = {};
  
  /// Measurement history
  final List<_MeasurementResult> _history = [];
  
  /// Statistics for named operations
  final Map<String, _OperationStats> _operationStats = {};
  
  /// Maximum history size
  int maxHistorySize = 1000;
  
  /// Enable profiling
  void enable() {
    if (_enabled) return;
    _enabled = true;
    _logger.info('Profiler enabled');
  }
  
  /// Disable profiling
  void disable() {
    if (!_enabled) return;
    _enabled = false;
    _logger.info('Profiler disabled');
  }
  
  /// Check if profiling is enabled
  bool get isEnabled => _enabled;
  
  /// Start a measurement
  void begin(String name) {
    if (!_enabled) return;
    
    if (_activeMeasurements.containsKey(name)) {
      _logger.warning('Measurement "$name" already active');
      return;
    }
    
    final measurement = _Measurement(name, DateTime.now());
    _activeMeasurements[name] = measurement;
  }
  
  /// End a measurement
  double end(String name) {
    if (!_enabled) return 0.0;
    
    final measurement = _activeMeasurements.remove(name);
    if (measurement == null) {
      _logger.warning('Measurement "$name" not found');
      return 0.0;
    }
    
    final endTime = DateTime.now();
    final duration = endTime.difference(measurement.startTime).inMicroseconds / 1000.0;
    
    _recordMeasurement(measurement.name, duration);
    
    return duration;
  }
  
  /// Measure execution time of a function
  T measure<T>(String name, T Function() function) {
    if (!_enabled) return function();
    
    begin(name);
    try {
      return function();
    } finally {
      end(name);
    }
  }
  
  /// Get statistics for an operation
  OperationStats getStats(String operationName) {
    final stats = _operationStats[operationName];
    if (stats == null) {
      return OperationStats(
        operationName: operationName,
        callCount: 0,
        totalTime: 0.0,
        averageTime: 0.0,
        minTime: 0.0,
        maxTime: 0.0,
        lastTime: 0.0,
      );
    }
    
    return OperationStats(
      operationName: operationName,
      callCount: stats.callCount,
      totalTime: stats.totalTime,
      averageTime: stats.averageTime,
      minTime: stats.minTime,
      maxTime: stats.maxTime,
      lastTime: stats.lastTime,
    );
  }
  
  /// Get all operation statistics
  Map<String, OperationStats> getAllStats() {
    final stats = <String, OperationStats>{};
    _operationStats.forEach((name, stat) {
      stats[name] = OperationStats(
        operationName: name,
        callCount: stat.callCount,
        totalTime: stat.totalTime,
        averageTime: stat.averageTime,
        minTime: stat.minTime,
        maxTime: stat.maxTime,
        lastTime: stat.lastTime,
      );
    });
    return stats;
  }
  
  /// Clear all measurements and statistics
  void clear() {
    _activeMeasurements.clear();
    _history.clear();
    _operationStats.clear();
    _logger.debug('Profiler cleared');
  }
  
  /// Get recent measurements
  List<MeasurementResult> getRecentMeasurements({int limit = 100}) {
    final start = math.max(0, _history.length - limit);
    final end = _history.length;
    
    return _history.sublist(start, end).map((result) {
      return MeasurementResult(
        name: result.name,
        duration: result.duration,
        timestamp: result.timestamp,
      );
    }).toList();
  }
  
  /// Generate a performance report
  PerformanceReport generateReport() {
    final report = PerformanceReport(
      generatedAt: DateTime.now(),
      enabled: _enabled,
      totalMeasurements: _history.length,
      activeMeasurements: _activeMeasurements.length,
    );
    
    // Add operation statistics
    _operationStats.forEach((name, stats) {
      report.operationStats[name] = OperationStats(
        operationName: name,
        callCount: stats.callCount,
        totalTime: stats.totalTime,
        averageTime: stats.averageTime,
        minTime: stats.minTime,
        maxTime: stats.maxTime,
        lastTime: stats.lastTime,
      );
    });
    
    // Add recent measurements
    report.recentMeasurements = getRecentMeasurements(limit: 50);
    
    return report;
  }
  
  /// Print performance summary to console
  void printSummary() {
    if (!_enabled) {
      _logger.info('Profiler is disabled');
      return;
    }
    
    final report = generateReport();
    
    _logger.info('=== Performance Report ===');
    _logger.info('Generated: ${report.generatedAt}');
    _logger.info('Total measurements: ${report.totalMeasurements}');
    _logger.info('Active measurements: ${report.activeMeasurements}');
    
    if (report.operationStats.isNotEmpty) {
      _logger.info('\nOperation Statistics:');
      report.operationStats.values.forEach((stats) {
        if (stats.callCount > 0) {
          _logger.info(
            '  ${stats.operationName}: '
            'calls=${stats.callCount}, '
            'avg=${stats.averageTime.toStringAsFixed(2)}ms, '
            'min=${stats.minTime.toStringAsFixed(2)}ms, '
            'max=${stats.maxTime.toStringAsFixed(2)}ms'
          );
        }
      });
    }
    
    if (report.recentMeasurements.isNotEmpty) {
      _logger.info('\nRecent Measurements (last ${report.recentMeasurements.length}):');
      for (final measurement in report.recentMeasurements.take(5)) {
        _logger.info(
          '  ${measurement.name}: '
          '${measurement.duration.toStringAsFixed(2)}ms '
          'at ${measurement.timestamp}'
        );
      }
      if (report.recentMeasurements.length > 5) {
        _logger.info('  ... and ${report.recentMeasurements.length - 5} more');
      }
    }
    
    _logger.info('==========================');
  }
  
  // Private methods
  
  /// Record a measurement
  void _recordMeasurement(String name, double duration) {
    final result = _MeasurementResult(name, duration, DateTime.now());
    _history.add(result);
    
    // Trim history if needed
    if (_history.length > maxHistorySize) {
      _history.removeRange(0, _history.length - maxHistorySize);
    }
    
    // Update operation statistics
    var stats = _operationStats[name];
    if (stats == null) {
      stats = _OperationStats();
      _operationStats[name] = stats;
    }
    
    stats.record(duration);
  }
}

/// Measurement data
class _Measurement {
  final String name;
  final DateTime startTime;
  
  _Measurement(this.name, this.startTime);
}

/// Measurement result
class _MeasurementResult {
  final String name;
  final double duration;
  final DateTime timestamp;
  
  _MeasurementResult(this.name, this.duration, this.timestamp);
}

/// Operation statistics
class _OperationStats {
  int callCount = 0;
  double totalTime = 0.0;
  double minTime = double.maxFinite;
  double maxTime = 0.0;
  double lastTime = 0.0;
  
  double get averageTime => callCount > 0 ? totalTime / callCount : 0.0;
  
  void record(double duration) {
    callCount++;
    totalTime += duration;
    minTime = math.min(minTime, duration);
    maxTime = math.max(maxTime, duration);
    lastTime = duration;
  }
}

/// Public measurement result
class MeasurementResult {
  final String name;
  final double duration; // in milliseconds
  final DateTime timestamp;
  
  MeasurementResult({
    required this.name,
    required this.duration,
    required this.timestamp,
  });
}

/// Operation statistics (public)
class OperationStats {
  final String operationName;
  final int callCount;
  final double totalTime;
  final double averageTime;
  final double minTime;
  final double maxTime;
  final double lastTime;
  
  OperationStats({
    required this.operationName,
    required this.callCount,
    required this.totalTime,
    required this.averageTime,
    required this.minTime,
    required this.maxTime,
    required this.lastTime,
  });
}

/// Performance report
class PerformanceReport {
  final DateTime generatedAt;
  final bool enabled;
  final int totalMeasurements;
  final int activeMeasurements;
  
  final Map<String, OperationStats> operationStats = {};
  List<MeasurementResult> recentMeasurements = [];
  
  PerformanceReport({
    required this.generatedAt,
    required this.enabled,
    required this.totalMeasurements,
    required this.activeMeasurements,
  });
}
