/// DSRT Engine - Performance Monitor
/// Performance monitoring system with real-time analysis.
library dsrt_engine.src.core.performance.monitor;

import 'dart:async';
import 'dart:math' as math;
import 'profiler.dart';
import 'stats.dart';
import '../../utils/logger.dart';
import '../../utils/disposables.dart';

/// Performance monitoring system
class PerformanceMonitor with Disposable {
  /// Profiler instance
  final Profiler profiler;
  
  /// Performance statistics
  final PerformanceStats stats;
  
  /// Logger instance
  final Logger logger;
  
  /// Enabled state
  bool _enabled = false;
  
  /// Update timer
  Timer? _updateTimer;
  
  /// Update interval in seconds
  double updateInterval = 1.0;
  
  /// Frame duration buffer
  final List<double> _frameDurations = [];
  
  /// Maximum frame duration buffer size
  static const int maxFrameDurationBuffer = 60;
  
  /// Frame duration threshold for warnings (ms)
  double frameDurationWarningThreshold = 16.67; // ~60 FPS
  
  /// Frame duration threshold for critical warnings (ms)
  double frameDurationCriticalThreshold = 33.33; // ~30 FPS
  
  /// Memory usage warning threshold (percentage)
  double memoryWarningThreshold = 80.0;
  
  /// Memory usage critical threshold (percentage)
  double memoryCriticalThreshold = 90.0;
  
  /// Warning callback
  void Function(PerformanceWarning)? onWarning;
  
  /// Critical callback
  void Function(PerformanceCritical)? onCritical;
  
  /// Create performance monitor
  PerformanceMonitor()
      : profiler = Profiler(),
        stats = PerformanceStats(),
        logger = Logger('PerformanceMonitor');
  
  /// Enable performance monitoring
  void enable(bool enableProfiling) {
    if (_enabled) return;
    
    _enabled = true;
    
    if (enableProfiling) {
      profiler.enable();
    }
    
    // Start update timer
    _startUpdateTimer();
    
    logger.info('Performance monitoring enabled');
  }
  
  /// Disable performance monitoring
  void disable() {
    if (!_enabled) return;
    
    _enabled = false;
    profiler.disable();
    _stopUpdateTimer();
    
    logger.info('Performance monitoring disabled');
  }
  
  /// Check if monitoring is enabled
  bool get isEnabled => _enabled;
  
  /// Begin a frame
  void beginFrame() {
    if (!_enabled) return;
    profiler.begin('frame');
  }
  
  /// End a frame
  void endFrame() {
    if (!_enabled) return;
    
    final frameDuration = profiler.end('frame');
    _recordFrameDuration(frameDuration);
    _checkPerformance(frameDuration);
  }
  
  /// Begin a named operation
  void beginOperation(String name) {
    if (!_enabled) return;
    profiler.begin(name);
  }
  
  /// End a named operation
  void endOperation(String name) {
    if (!_enabled) return;
    profiler.end(name);
  }
  
  /// Get current frame duration
  double get frameDuration {
    if (_frameDurations.isEmpty) return 0.0;
    return _frameDurations.last;
  }
  
  /// Get average frame duration
  double get averageFrameDuration {
    if (_frameDurations.isEmpty) return 0.0;
    
    double sum = 0.0;
    for (final duration in _frameDurations) {
      sum += duration;
    }
    return sum / _frameDurations.length;
  }
  
  /// Get frame duration jitter
  double get frameJitter {
    if (_frameDurations.length < 2) return 0.0;
    
    double sum = 0.0;
    final average = averageFrameDuration;
    
    for (final duration in _frameDurations) {
      final diff = duration - average;
      sum += diff * diff;
    }
    
    return math.sqrt(sum / _frameDurations.length);
  }
  
  /// Generate performance report
  PerformanceReport generateReport() {
    return profiler.generateReport();
  }
  
  /// Print performance summary
  void printSummary() {
    if (!_enabled) {
      logger.info('Performance monitoring is disabled');
      return;
    }
    
    profiler.printSummary();
    
    logger.info('=== Performance Stats ===');
    logger.info(stats.getSummary());
    logger.info('=========================');
  }
  
  /// Reset all performance data
  void reset() {
    profiler.clear();
    stats.reset();
    _frameDurations.clear();
    logger.debug('Performance data reset');
  }
  
  /// Initialize performance monitoring
  void initialize() {
    logger.debug('Performance monitor initialized');
  }
  
  /// Dispose resources
  @override
  void dispose() {
    disable();
    super.dispose();
  }
  
  // Private methods
  
  /// Start update timer
  void _startUpdateTimer() {
    _updateTimer = Timer.periodic(
      Duration(milliseconds: (updateInterval * 1000).round()),
      (_) => _onUpdate(),
    );
  }
  
  /// Stop update timer
  void _stopUpdateTimer() {
    _updateTimer?.cancel();
    _updateTimer = null;
  }
  
  /// Update handler
  void _onUpdate() {
    stats.update();
    _checkMemoryUsage();
  }
  
  /// Record frame duration
  void _recordFrameDuration(double duration) {
    _frameDurations.add(duration);
    
    // Trim buffer
    if (_frameDurations.length > maxFrameDurationBuffer) {
      _frameDurations.removeAt(0);
    }
  }
  
  /// Check performance metrics
  void _checkPerformance(double frameDuration) {
    // Check frame duration
    if (frameDuration > frameDurationCriticalThreshold) {
      _handleCritical(
        PerformanceCritical(
          type: CriticalType.frameTime,
          message: 'Frame time critical: ${frameDuration.toStringAsFixed(2)}ms',
          data: {'frameDuration': frameDuration},
        ),
      );
    } else if (frameDuration > frameDurationWarningThreshold) {
      _handleWarning(
        PerformanceWarning(
          type: WarningType.frameTime,
          message: 'Frame time warning: ${frameDuration.toStringAsFixed(2)}ms',
          data: {'frameDuration': frameDuration},
        ),
      );
    }
    
    // Check frame jitter
    final jitter = frameJitter;
    if (jitter > frameDurationWarningThreshold * 0.5) {
      _handleWarning(
        PerformanceWarning(
          type: WarningType.frameJitter,
          message: 'High frame jitter: ${jitter.toStringAsFixed(2)}ms',
          data: {'jitter': jitter},
        ),
      );
    }
  }
  
  /// Check memory usage
  void _checkMemoryUsage() {
    final usagePercent = stats.memoryStats.memoryUsagePercent;
    
    if (usagePercent > memoryCriticalThreshold) {
      _handleCritical(
        PerformanceCritical(
          type: CriticalType.memory,
          message: 'Memory usage critical: ${usagePercent.toStringAsFixed(1)}%',
          data: {
            'usagePercent': usagePercent,
            'usedMemory': stats.memoryStats.usedMemory,
            'totalMemory': stats.memoryStats.totalMemory,
          },
        ),
      );
    } else if (usagePercent > memoryWarningThreshold) {
      _handleWarning(
        PerformanceWarning(
          type: WarningType.memory,
          message: 'High memory usage: ${usagePercent.toStringAsFixed(1)}%',
          data: {
            'usagePercent': usagePercent,
            'usedMemory': stats.memoryStats.usedMemory,
            'totalMemory': stats.memoryStats.totalMemory,
          },
        ),
      );
    }
  }
  
  /// Handle performance warning
  void _handleWarning(PerformanceWarning warning) {
    logger.warning('Performance warning: ${warning.message}');
    
    if (onWarning != null) {
      onWarning!(warning);
    }
  }
  
  /// Handle performance critical
  void _handleCritical(PerformanceCritical critical) {
    logger.error('Performance critical: ${critical.message}');
    
    if (onCritical != null) {
      onCritical!(critical);
    }
  }
}

/// Performance warning types
enum WarningType {
  frameTime,
  frameJitter,
  memory,
  render,
  physics,
  audio,
}

/// Performance critical types
enum CriticalType {
  frameTime,
  memory,
  render,
  physics,
  audio,
}

/// Performance warning
class PerformanceWarning {
  final WarningType type;
  final String message;
  final Map<String, dynamic> data;
  final DateTime timestamp;
  
  PerformanceWarning({
    required this.type,
    required this.message,
    this.data = const {},
  }) : timestamp = DateTime.now();
}

/// Performance critical
class PerformanceCritical {
  final CriticalType type;
  final String message;
  final Map<String, dynamic> data;
  final DateTime timestamp;
  
  PerformanceCritical({
    required this.type,
    required this.message,
    this.data = const {},
  }) : timestamp = DateTime.now();
}
