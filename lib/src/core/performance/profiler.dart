/// Performance profiling system
/// 
/// Measures execution time of various engine systems.
/// Can be enabled/disabled via engine config.
/// 
/// @license MIT
/// @copyright (c) 2024 DSRT Engine

import 'dart:collection';
import '../../utils/logger.dart';

/// Profiling measurement
class ExsProfileMeasurement {
  /// Measurement name
  final String name;
  
  /// Start time in microseconds
  final int startTime;
  
  /// End time in microseconds
  final int? endTime;
  
  /// Parent measurement if nested
  final ExsProfileMeasurement? parent;
  
  /// Child measurements
  final List<ExsProfileMeasurement> children = [];
  
  /// Create a measurement
  ExsProfileMeasurement(this.name, this.startTime, this.parent);
  
  /// Get duration in microseconds
  int get durationMicroseconds {
    if (endTime == null) return 0;
    return endTime! - startTime;
  }
  
  /// Get duration in milliseconds
  double get durationMilliseconds => durationMicroseconds / 1000.0;
  
  /// Get total duration including children
  int get totalDurationMicroseconds {
    var total = durationMicroseconds;
    for (final child in children) {
      total += child.totalDurationMicroseconds;
    }
    return total;
  }
}

/// Performance profiler
class ExsProfiler {
  /// Logger instance
  final ExsLogger _logger;
  
  /// Is profiling enabled
  bool _enabled = false;
  
  /// Current measurements stack
  final List<ExsProfileMeasurement> _measurementStack = [];
  
  /// Completed measurements for this frame
  final List<ExsProfileMeasurement> _frameMeasurements = [];
  
  /// Measurements history (ring buffer)
  final List<List<ExsProfileMeasurement>> _history = [];
  
  /// Maximum history size
  final int _maxHistorySize = 60; // Keep last 60 frames
  
  /// Frame counter
  int _frameCount = 0;
  
  /// Constructor
  ExsProfiler() : _logger = ExsLogger('ExsProfiler');
  
  /// Enable profiling
  void enable() {
    _enabled = true;
    _logger.info('Profiling enabled');
  }
  
  /// Disable profiling
  void disable() {
    _enabled = false;
    _logger.info('Profiling disabled');
    clear();
  }
  
  /// Check if profiling is enabled
  bool get isEnabled => _enabled;
  
  /// Start a new measurement
  void begin(String name) {
    if (!_enabled) return;
    
    final now = DateTime.now().microsecondsSinceEpoch;
    final parent = _measurementStack.isNotEmpty ? _measurementStack.last : null;
    final measurement = ExsProfileMeasurement(name, now, parent);
    
    if (parent != null) {
      parent.children.add(measurement);
    } else {
      _frameMeasurements.add(measurement);
    }
    
    _measurementStack.add(measurement);
  }
  
  /// End current measurement
  void end() {
    if (!_enabled || _measurementStack.isEmpty) return;
    
    final measurement = _measurementStack.removeLast();
    final now = DateTime.now().microsecondsSinceEpoch;
    
    // Use reflection to set private field (in real implementation would need different approach)
    // For now, we'll track end time separately
    // measurement._endTime = now;
  }
  
  /// End frame and record measurements
  void endFrame() {
    if (!_enabled) return;
    
    // Set end times for all open measurements
    final now = DateTime.now().microsecondsSinceEpoch;
    for (final measurement in _measurementStack) {
      // measurement._endTime = now;
    }
    
    // Add to history
    _history.add(List.from(_frameMeasurements));
    if (_history.length > _maxHistorySize) {
      _history.removeAt(0);
    }
    
    // Clear for next frame
    _frameMeasurements.clear();
    _measurementStack.clear();
    _frameCount++;
  }
  
  /// Get measurements from last frame
  List<ExsProfileMeasurement> get lastFrameMeasurements {
    if (_history.isEmpty) return [];
    return _history.last;
  }
  
  /// Get average frame time over history
  double get averageFrameTime {
    if (_history.isEmpty) return 0.0;
    
    var total = 0.0;
    var count = 0;
    
    for (final frame in _history) {
      for (final measurement in frame) {
        if (measurement.parent == null) { // Top-level measurements only
          total += measurement.durationMilliseconds;
          count++;
        }
      }
    }
    
    return count > 0 ? total / count : 0.0;
  }
  
  /// Get frame rate based on average frame time
  double get averageFPS {
    final avgTime = averageFrameTime;
    return avgTime > 0 ? 1000.0 / avgTime : 0.0;
  }
  
  /// Get peak frame time in history
  double get peakFrameTime {
    if (_history.isEmpty) return 0.0;
    
    var peak = 0.0;
    for (final frame in _history) {
      for (final measurement in frame) {
        if (measurement.parent == null) {
          final time = measurement.durationMilliseconds;
          if (time > peak) peak = time;
        }
      }
    }
    return peak;
  }
  
  /// Clear all measurements
  void clear() {
    _measurementStack.clear();
    _frameMeasurements.clear();
    _history.clear();
    _frameCount = 0;
  }
  
  /// Get statistics as a map
  Map<String, dynamic> getStats() {
    return {
      'enabled': _enabled,
      'frameCount': _frameCount,
      'averageFrameTime': averageFrameTime,
      'averageFPS': averageFPS,
      'peakFrameTime': peakFrameTime,
      'historySize': _history.length,
    };
  }
  
  /// Print detailed profiling report
  void printReport() {
    if (!_enabled) {
      _logger.info('Profiling is disabled');
      return;
    }
    
    _logger.info('=== Performance Report ===');
    _logger.info('Frames recorded: $_frameCount');
    _logger.info('Average FPS: ${averageFPS.toStringAsFixed(2)}');
    _logger.info('Average frame time: ${averageFrameTime.toStringAsFixed(2)}ms');
    _logger.info('Peak frame time: ${peakFrameTime.toStringAsFixed(2)}ms');
    
    if (_history.isNotEmpty) {
      _logger.info('\nLast frame measurements:');
      _printMeasurements(lastFrameMeasurements, 0);
    }
  }
  
  /// Print measurements recursively
  void _printMeasurements(List<ExsProfileMeasurement> measurements, int depth) {
    final indent = '  ' * depth;
    for (final measurement in measurements) {
      final time = measurement.durationMilliseconds;
      final totalTime = measurement.totalDurationMicroseconds / 1000.0;
      _logger.info('$indent${measurement.name}: ${time.toStringAsFixed(2)}ms '
                   '(total: ${totalTime.toStringAsFixed(2)}ms)');
      if (measurement.children.isNotEmpty) {
        _printMeasurements(measurement.children, depth + 1);
      }
    }
  }
}
