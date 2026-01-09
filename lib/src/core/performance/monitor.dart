/// Performance monitoring system
/// 
/// Combines profiler and stats, provides alerts for performance issues.
/// 
/// @license MIT
/// @copyright (c) 2024 DSRT Engine

import 'profiler.dart';
import 'stats.dart';
import '../../utils/logger.dart';

/// Performance threshold configuration
class ExsPerformanceThresholds {
  /// Target FPS
  final double targetFPS;
  
  /// Critical FPS (below this triggers alert)
  final double criticalFPS;
  
  /// Warning FPS (below this triggers warning)
  final double warningFPS;
  
  /// Maximum frame time in milliseconds
  final double maxFrameTime;
  
  /// Maximum draw calls per frame
  final int maxDrawCalls;
  
  /// Maximum triangles per frame
  final int maxTriangles;
  
  /// Constructor with defaults
  const ExsPerformanceThresholds({
    this.targetFPS = 60.0,
    this.criticalFPS = 30.0,
    this.warningFPS = 45.0,
    this.maxFrameTime = 33.0, // ~30 FPS
    this.maxDrawCalls = 1000,
    this.maxTriangles = 1000000,
  });
  
  /// Check if FPS is critical
  bool isCriticalFPS(double fps) => fps < criticalFPS;
  
  /// Check if FPS is warning level
  bool isWarningFPS(double fps) => fps < warningFPS;
  
  /// Check if frame time is too high
  bool isHighFrameTime(double frameTime) => frameTime > maxFrameTime;
  
  /// Check if draw calls are too high
  bool isHighDrawCalls(int drawCalls) => drawCalls > maxDrawCalls;
  
  /// Check if triangle count is too high
  bool isHighTriangles(int triangles) => triangles > maxTriangles;
}

/// Performance issue severity
enum ExsPerformanceIssueSeverity {
  /// Informational message
  info,
  
  /// Performance warning
  warning,
  
  /// Critical performance issue
  critical,
}

/// Performance issue
class ExsPerformanceIssue {
  /// Issue identifier
  final String id;
  
  /// Severity level
  final ExsPerformanceIssueSeverity severity;
  
  /// Description
  final String description;
  
  /// When the issue was detected
  final DateTime detectedAt;
  
  /// Additional data
  final Map<String, dynamic> data;
  
  /// Constructor
  ExsPerformanceIssue({
    required this.id,
    required this.severity,
    required this.description,
    required this.detectedAt,
    this.data = const {},
  });
  
  /// Get issue as string
  @override
  String toString() {
    return '[${severity.name.toUpperCase()}] $description';
  }
}

/// Performance monitor
class ExsPerformanceMonitor {
  /// Profiler instance
  final ExsProfiler profiler;
  
  /// Stats instance
  final ExsStats stats;
  
  /// Logger instance
  final ExsLogger logger;
  
  /// Performance thresholds
  ExsPerformanceThresholds thresholds;
  
  /// Is monitoring enabled
  bool _enabled = false;
  
  /// Detected issues
  final List<ExsPerformanceIssue> _issues = [];
  
  /// Maximum number of issues to keep
  static const int _maxIssues = 100;
  
  /// Last check time
  DateTime? _lastCheckTime;
  
  /// Check interval in seconds
  final double _checkInterval = 1.0;
  
  /// Constructor
  ExsPerformanceMonitor({
    required this.profiler,
    required this.stats,
    ExsPerformanceThresholds? thresholds,
  })  : thresholds = thresholds ?? const ExsPerformanceThresholds(),
        logger = ExsLogger('ExsPerformanceMonitor');
  
  /// Enable monitoring
  void enable() {
    _enabled = true;
    profiler.enable();
    stats.start();
    logger.info('Performance monitoring enabled');
  }
  
  /// Disable monitoring
  void disable() {
    _enabled = false;
    profiler.disable();
    logger.info('Performance monitoring disabled');
  }
  
  /// Check if monitoring is enabled
  bool get isEnabled => _enabled;
  
  /// Update monitoring (call each frame)
  void update() {
    if (!_enabled) return;
    
    stats.updateFrame();
    
    // Check for issues at interval
    final now = DateTime.now();
    if (_lastCheckTime == null ||
        now.difference(_lastCheckTime!).inMilliseconds / 1000.0 >= _checkInterval) {
      _checkForIssues();
      _lastCheckTime = now;
    }
  }
  
  /// Check for performance issues
  void _checkForIssues() {
    final currentFPS = stats.fps;
    final currentFrameTime = stats.frameTime;
    final currentDrawCalls = stats.drawCalls;
    final currentTriangles = stats.triangles;
    
    // Check FPS
    if (thresholds.isCriticalFPS(currentFPS)) {
      _addIssue(
        id: 'low_fps_critical',
        severity: ExsPerformanceIssueSeverity.critical,
        description: 'FPS critically low: ${currentFPS.toStringAsFixed(1)}',
        data: {
          'fps': currentFPS,
          'threshold': thresholds.criticalFPS,
        },
      );
    } else if (thresholds.isWarningFPS(currentFPS)) {
      _addIssue(
        id: 'low_fps_warning',
        severity: ExsPerformanceIssueSeverity.warning,
        description: 'FPS below warning threshold: ${currentFPS.toStringAsFixed(1)}',
        data: {
          'fps': currentFPS,
          'threshold': thresholds.warningFPS,
        },
      );
    }
    
    // Check frame time
    if (thresholds.isHighFrameTime(currentFrameTime)) {
      _addIssue(
        id: 'high_frame_time',
        severity: ExsPerformanceIssueSeverity.warning,
        description: 'Frame time high: ${currentFrameTime.toStringAsFixed(1)}ms',
        data: {
          'frameTime': currentFrameTime,
          'threshold': thresholds.maxFrameTime,
        },
      );
    }
    
    // Check draw calls
    if (thresholds.isHighDrawCalls(currentDrawCalls)) {
      _addIssue(
        id: 'high_draw_calls',
        severity: ExsPerformanceIssueSeverity.warning,
        description: 'High draw calls: $currentDrawCalls',
        data: {
          'drawCalls': currentDrawCalls,
          'threshold': thresholds.maxDrawCalls,
        },
      );
    }
    
    // Check triangle count
    if (thresholds.isHighTriangles(currentTriangles)) {
      _addIssue(
        id: 'high_triangle_count',
        severity: ExsPerformanceIssueSeverity.warning,
        description: 'High triangle count: $currentTriangles',
        data: {
          'triangles': currentTriangles,
          'threshold': thresholds.maxTriangles,
        },
      );
    }
  }
  
  /// Add a performance issue
  void _addIssue({
    required String id,
    required ExsPerformanceIssueSeverity severity,
    required String description,
    Map<String, dynamic> data = const {},
  }) {
    final issue = ExsPerformanceIssue(
      id: id,
      severity: severity,
      description: description,
      detectedAt: DateTime.now(),
      data: data,
    );
    
    _issues.add(issue);
    
    // Keep only recent issues
    if (_issues.length > _maxIssues) {
      _issues.removeAt(0);
    }
    
    // Log based on severity
    switch (severity) {
      case ExsPerformanceIssueSeverity.critical:
        logger.error('Performance issue: $description');
        break;
      case ExsPerformanceIssueSeverity.warning:
        logger.warning('Performance issue: $description');
        break;
      case ExsPerformanceIssueSeverity.info:
        logger.info('Performance issue: $description');
        break;
    }
  }
  
  /// Get all detected issues
  List<ExsPerformanceIssue> get issues => List.unmodifiable(_issues);
  
  /// Get issues by severity
  List<ExsPerformanceIssue> getIssuesBySeverity(ExsPerformanceIssueSeverity severity) {
    return _issues.where((issue) => issue.severity == severity).toList();
  }
  
  /// Clear all issues
  void clearIssues() {
    _issues.clear();
  }
  
  /// Get performance summary
  Map<String, dynamic> getSummary() {
    return {
      'enabled': _enabled,
      'fps': stats.fps,
      'frameTime': stats.frameTime,
      'minFrameTime': stats.minFrameTime,
      'maxFrameTime': stats.maxFrameTime,
      'drawCalls': stats.drawCalls,
      'triangles': stats.triangles,
      'issues': {
        'total': _issues.length,
        'critical': getIssuesBySeverity(ExsPerformanceIssueSeverity.critical).length,
        'warning': getIssuesBySeverity(ExsPerformanceIssueSeverity.warning).length,
        'info': getIssuesBySeverity(ExsPerformanceIssueSeverity.info).length,
      },
      'thresholds': {
        'targetFPS': thresholds.targetFPS,
        'criticalFPS': thresholds.criticalFPS,
        'warningFPS': thresholds.warningFPS,
        'maxFrameTime': thresholds.maxFrameTime,
        'maxDrawCalls': thresholds.maxDrawCalls,
        'maxTriangles': thresholds.maxTriangles,
      },
    };
  }
  
  /// Print performance report
  void printReport() {
    logger.info('=== Performance Monitor Report ===');
    
    final summary = getSummary();
    for (final entry in summary.entries) {
      if (entry.value is Map) {
        logger.info('${entry.key}:');
        final subMap = entry.value as Map;
        for (final subEntry in subMap.entries) {
          logger.info('  ${subEntry.key}: ${subEntry.value}');
        }
      } else {
        logger.info('${entry.key}: ${entry.value}');
      }
    }
    
    if (_issues.isNotEmpty) {
      logger.info('\nRecent issues:');
      final recentIssues = _issues.length > 5 
          ? _issues.sublist(_issues.length - 5)
          : _issues;
      for (final issue in recentIssues.reversed) {
        logger.info('  ${issue.detectedAt} - $issue');
      }
    }
  }
}
