// lib/src/core/performance/monitor.dart

/// DSRT Engine - Performance Monitor
/// 
/// Provides real-time performance monitoring, alerting, and automated
/// performance optimization based on runtime metrics.
/// 
/// @category Core
/// @subcategory Performance
/// @version 1.0.0
/// @license MIT
/// @copyright DSRT Engine Team

library dsrt_engine.core.performance.monitor;

import 'dart:async';
import 'dart:collection';
import 'dart:math' as math;

import '../../utils/logger.dart';
import 'profiler.dart';
import 'stats.dart';

/// Monitor alert level
enum DsrtMonitorAlertLevel {
  /// Informational message
  info,
  
  /// Warning - performance degradation detected
  warning,
  
  /// Critical - severe performance issue
  critical,
  
  /// Emergency - engine stability at risk
  emergency
}

/// Monitor alert
class DsrtMonitorAlert {
  /// Alert ID
  final String id;
  
  /// Alert level
  final DsrtMonitorAlertLevel level;
  
  /// Alert message
  final String message;
  
  /// Alert timestamp
  final DateTime timestamp;
  
  /// Associated metric (if any)
  final String? metric;
  
  /// Metric value (if any)
  final double? value;
  
  /// Threshold value (if any)
  final double? threshold;
  
  /// Whether alert is active
  bool isActive;
  
  /// Creates a monitor alert
  DsrtMonitorAlert({
    required this.id,
    required this.level,
    required this.message,
    DateTime? timestamp,
    this.metric,
    this.value,
    this.threshold,
    this.isActive = true,
  }) : timestamp = timestamp ?? DateTime.now();
  
  /// Creates an informational alert
  factory DsrtMonitorAlert.info(String message, {
    String? metric,
    double? value,
    double? threshold,
  }) {
    return DsrtMonitorAlert(
      id: 'info_${DateTime.now().millisecondsSinceEpoch}',
      level: DsrtMonitorAlertLevel.info,
      message: message,
      metric: metric,
      value: value,
      threshold: threshold,
    );
  }
  
  /// Creates a warning alert
  factory DsrtMonitorAlert.warning(String message, {
    String? metric,
    double? value,
    double? threshold,
  }) {
    return DsrtMonitorAlert(
      id: 'warning_${DateTime.now().millisecondsSinceEpoch}',
      level: DsrtMonitorAlertLevel.warning,
      message: message,
      metric: metric,
      value: value,
      threshold: threshold,
    );
  }
  
  /// Creates a critical alert
  factory DsrtMonitorAlert.critical(String message, {
    String? metric,
    double? value,
    double? threshold,
  }) {
    return DsrtMonitorAlert(
      id: 'critical_${DateTime.now().millisecondsSinceEpoch}',
      level: DsrtMonitorAlertLevel.critical,
      message: message,
      metric: metric,
      value: value,
      threshold: threshold,
    );
  }
  
  /// Creates an emergency alert
  factory DsrtMonitorAlert.emergency(String message, {
    String? metric,
    double? value,
    double? threshold,
  }) {
    return DsrtMonitorAlert(
      id: 'emergency_${DateTime.now().millisecondsSinceEpoch}',
      level: DsrtMonitorAlertLevel.emergency,
      message: message,
      metric: metric,
      value: value,
      threshold: threshold,
    );
  }
  
  /// Converts to a map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'level': level.name,
      'message': message,
      'timestamp': timestamp.toIso8601String(),
      'metric': metric,
      'value': value,
      'threshold': threshold,
      'isActive': isActive,
    };
  }
  
  /// Gets a formatted string
  @override
  String toString() {
    final buffer = StringBuffer();
    buffer.write('[$level] $message');
    
    if (metric != null) {
      buffer.write(' (Metric: $metric');
      if (value != null) {
        buffer.write(', Value: $value');
      }
      if (threshold != null) {
        buffer.write(', Threshold: $threshold');
      }
      buffer.write(')');
    }
    
    buffer.write(' at $timestamp');
    return buffer.toString();
  }
}

/// Monitor threshold configuration
class DsrtMonitorThreshold {
  /// Metric name
  final String metric;
  
  /// Warning threshold
  final double warningThreshold;
  
  /// Critical threshold
  final double criticalThreshold;
  
  /// Emergency threshold
  final double emergencyThreshold;
  
  /// Comparison type (greater than or less than)
  final bool greaterIsWorse;
  
  /// Time window for evaluation (seconds)
  final double timeWindow;
  
  /// Minimum samples required
  final int minSamples;
  
  /// Creates a monitor threshold
  DsrtMonitorThreshold({
    required this.metric,
    required this.warningThreshold,
    required this.criticalThreshold,
    required this.emergencyThreshold,
    this.greaterIsWorse = true,
    this.timeWindow = 5.0,
    this.minSamples = 10,
  })  : assert(warningThreshold <= criticalThreshold || !greaterIsWorse,
            'Thresholds must be ordered appropriately'),
        assert(criticalThreshold <= emergencyThreshold || !greaterIsWorse,
            'Thresholds must be ordered appropriately');
  
  /// Evaluates a value against this threshold
  DsrtMonitorAlertLevel? evaluate(double value) {
    if (greaterIsWorse) {
      if (value >= emergencyThreshold) {
        return DsrtMonitorAlertLevel.emergency;
      } else if (value >= criticalThreshold) {
        return DsrtMonitorAlertLevel.critical;
      } else if (value >= warningThreshold) {
        return DsrtMonitorAlertLevel.warning;
      }
    } else {
      if (value <= emergencyThreshold) {
        return DsrtMonitorAlertLevel.emergency;
      } else if (value <= criticalThreshold) {
        return DsrtMonitorAlertLevel.critical;
      } else if (value <= warningThreshold) {
        return DsrtMonitorAlertLevel.warning;
      }
    }
    
    return null;
  }
  
  /// Gets a description of this threshold
  String get description {
    final comparison = greaterIsWorse ? 'above' : 'below';
    return '$metric $comparison $warningThreshold (warning), $criticalThreshold (critical), $emergencyThreshold (emergency)';
  }
  
  /// Converts to a map
  Map<String, dynamic> toMap() {
    return {
      'metric': metric,
      'warningThreshold': warningThreshold,
      'criticalThreshold': criticalThreshold,
      'emergencyThreshold': emergencyThreshold,
      'greaterIsWorse': greaterIsWorse,
      'timeWindow': timeWindow,
      'minSamples': minSamples,
    };
  }
}

/// Monitor metric configuration
class DsrtMonitorMetric {
  /// Metric name
  final String name;
  
  /// Metric description
  final String description;
  
  /// Metric unit
  final DsrtStatsUnit unit;
  
  /// Custom unit name (if unit is custom)
  final String? customUnit;
  
  /// Whether this metric is enabled for monitoring
  final bool enabled;
  
  /// Update interval in seconds
  final double updateInterval;
  
  /// Threshold configuration (if any)
  final DsrtMonitorThreshold? threshold;
  
  /// Creates a monitor metric
  DsrtMonitorMetric({
    required this.name,
    required this.description,
    required this.unit,
    this.customUnit,
    this.enabled = true,
    this.updateInterval = 1.0,
    this.threshold,
  });
  
  /// Converts to a map
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'unit': unit.name,
      'customUnit': customUnit,
      'enabled': enabled,
      'updateInterval': updateInterval,
      'threshold': threshold?.toMap(),
    };
  }
}

/// Monitor action type
enum DsrtMonitorActionType {
  /// Log the alert
  log,
  
  /// Adjust engine settings
  adjustSettings,
  
  /// Reduce rendering quality
  reduceQuality,
  
  /// Enable performance mode
  enablePerformanceMode,
  
  /// Disable non-essential features
  disableFeatures,
  
  /// Restart subsystem
  restartSubsystem,
  
  /// Custom action
  custom
}

/// Monitor action configuration
class DsrtMonitorAction {
  /// Action type
  final DsrtMonitorActionType type;
  
  /// Action name
  final String name;
  
  /// Action description
  final String description;
  
  /// Alert level that triggers this action
  final DsrtMonitorAlertLevel triggerLevel;
  
  /// Action parameters
  final Map<String, dynamic> parameters;
  
  /// Whether this action is enabled
  final bool enabled;
  
  /// Cooldown period in seconds
  final double cooldown;
  
  /// Last execution time
  DateTime? _lastExecution;
  
  /// Creates a monitor action
  DsrtMonitorAction({
    required this.type,
    required this.name,
    required this.description,
    required this.triggerLevel,
    this.parameters = const {},
    this.enabled = true,
    this.cooldown = 30.0,
  });
  
  /// Checks if this action can be executed
  bool canExecute() {
    if (!enabled) return false;
    
    if (_lastExecution != null && cooldown > 0) {
      final secondsSinceLast = DateTime.now().difference(_lastExecution!).inSeconds;
      return secondsSinceLast >= cooldown;
    }
    
    return true;
  }
  
  /// Marks this action as executed
  void markExecuted() {
    _lastExecution = DateTime.now();
  }
  
  /// Gets the time until next execution
  Duration? get timeUntilNextExecution {
    if (_lastExecution == null || cooldown <= 0) return null;
    
    final nextExecution = _lastExecution!.add(Duration(seconds: cooldown.round()));
    return nextExecution.difference(DateTime.now());
  }
  
  /// Converts to a map
  Map<String, dynamic> toMap() {
    return {
      'type': type.name,
      'name': name,
      'description': description,
      'triggerLevel': triggerLevel.name,
      'parameters': parameters,
      'enabled': enabled,
      'cooldown': cooldown,
      'lastExecution': _lastExecution?.toIso8601String(),
      'canExecute': canExecute(),
    };
  }
}

/// Performance monitor
class DsrtPerformanceMonitor implements DsrtDisposable {
  /// Statistics collector
  final DsrtStatsCollector _statsCollector;
  
  /// Profiler
  final DsrtProfiler _profiler;
  
  /// Logger
  final DsrtLogger _logger;
  
  /// Monitor metrics
  final Map<String, DsrtMonitorMetric> _metrics;
  
  /// Monitor actions
  final Map<String, DsrtMonitorAction> _actions;
  
  /// Active alerts
  final Map<String, DsrtMonitorAlert> _activeAlerts;
  
  /// Alert history
  final List<DsrtMonitorAlert> _alertHistory;
  
  /// Maximum alert history size
  final int _maxAlertHistory;
  
  /// Metric values history
  final Map<String, List<double>> _metricHistory;
  
  /// Maximum metric history size
  final int _maxMetricHistory;
  
  /// Whether monitoring is enabled
  bool _enabled = true;
  
  /// Whether monitoring is paused
  bool _paused = false;
  
  /// Update timer
  Timer? _updateTimer;
  
  /// Update interval in seconds
  final double _updateInterval;
  
  /// Alert callbacks
  final List<void Function(DsrtMonitorAlert)> _alertCallbacks;
  
  /// Action callbacks
  final Map<DsrtMonitorActionType, Future<void> Function(DsrtMonitorAction, DsrtMonitorAlert)> _actionCallbacks;
  
  /// Creates a performance monitor
  DsrtPerformanceMonitor({
    required DsrtStatsCollector statsCollector,
    required DsrtProfiler profiler,
    DsrtLogger? logger,
    int maxAlertHistory = 1000,
    int maxMetricHistory = 1000,
    double updateInterval = 1.0,
  })  : _statsCollector = statsCollector,
        _profiler = profiler,
        _logger = logger ?? DsrtLogger(),
        _metrics = {},
        _actions = {},
        _activeAlerts = {},
        _alertHistory = [],
        _maxAlertHistory = maxAlertHistory,
        _metricHistory = {},
        _maxMetricHistory = maxMetricHistory,
        _updateInterval = updateInterval,
        _alertCallbacks = [],
        _actionCallbacks = {} {
    _initializeDefaultMetrics();
    _initializeDefaultActions();
    _startUpdateTimer();
  }
  
  /// Enables monitoring
  void enable() {
    if (_enabled) return;
    _enabled = true;
    _startUpdateTimer();
    _logger.info('Performance monitoring enabled');
  }
  
  /// Disables monitoring
  void disable() {
    if (!_enabled) return;
    _enabled = false;
    _stopUpdateTimer();
    _logger.info('Performance monitoring disabled');
  }
  
  /// Pauses monitoring
  void pause() {
    if (!_enabled || _paused) return;
    _paused = true;
    _logger.debug('Performance monitoring paused');
  }
  
  /// Resumes monitoring
  void resume() {
    if (!_enabled || !_paused) return;
    _paused = false;
    _logger.debug('Performance monitoring resumed');
  }
  
  /// Checks if monitoring is enabled
  bool get isEnabled => _enabled;
  
  /// Checks if monitoring is paused
  bool get isPaused => _paused;
  
  /// Registers a metric for monitoring
  void registerMetric(DsrtMonitorMetric metric) {
    _metrics[metric.name] = metric;
    _metricHistory[metric.name] = [];
    _logger.debug('Metric registered: ${metric.name}');
  }
  
  /// Unregisters a metric
  void unregisterMetric(String metricName) {
    _metrics.remove(metricName);
    _metricHistory.remove(metricName);
    _logger.debug('Metric unregistered: $metricName');
  }
  
  /// Registers an action
  void registerAction(DsrtMonitorAction action) {
    _actions[action.name] = action;
    _logger.debug('Action registered: ${action.name}');
  }
  
  /// Unregisters an action
  void unregisterAction(String actionName) {
    _actions.remove(actionName);
    _logger.debug('Action unregistered: $actionName');
  }
  
  /// Registers an alert callback
  void registerAlertCallback(void Function(DsrtMonitorAlert) callback) {
    _alertCallbacks.add(callback);
  }
  
  /// Unregisters an alert callback
  void unregisterAlertCallback(void Function(DsrtMonitorAlert) callback) {
    _alertCallbacks.remove(callback);
  }
  
  /// Registers an action callback
  void registerActionCallback(
    DsrtMonitorActionType type,
    Future<void> Function(DsrtMonitorAction, DsrtMonitorAlert) callback,
  ) {
    _actionCallbacks[type] = callback;
  }
  
  /// Unregisters an action callback
  void unregisterActionCallback(DsrtMonitorActionType type) {
    _actionCallbacks.remove(type);
  }
  
  /// Gets all registered metrics
  List<DsrtMonitorMetric> get metrics => _metrics.values.toList();
  
  /// Gets all registered actions
  List<DsrtMonitorAction> get actions => _actions.values.toList();
  
  /// Gets active alerts
  List<DsrtMonitorAlert> get activeAlerts => _activeAlerts.values.toList();
  
  /// Gets alert history
  List<DsrtMonitorAlert> get alertHistory => List.unmodifiable(_alertHistory);
  
  /// Gets metric history
  Map<String, List<double>> get metricHistory => Map.unmodifiable(_metricHistory);
  
  /// Gets a metric by name
  DsrtMonitorMetric? getMetric(String name) {
    return _metrics[name];
  }
  
  /// Gets an action by name
  DsrtMonitorAction? getAction(String name) {
    return _actions[name];
  }
  
  /// Triggers an alert
  void triggerAlert(DsrtMonitorAlert alert) {
    if (!_enabled || _paused) return;
    
    // Add to active alerts
    _activeAlerts[alert.id] = alert;
    
    // Add to history
    _alertHistory.add(alert);
    
    // Trim history if needed
    if (_alertHistory.length > _maxAlertHistory) {
      _alertHistory.removeAt(0);
    }
    
    // Execute alert callbacks
    for (final callback in _alertCallbacks) {
      try {
        callback(alert);
      } catch (error, stackTrace) {
        _logger.error('Error in alert callback: $error', stackTrace);
      }
    }
    
    // Execute actions for this alert level
    _executeActionsForAlert(alert);
    
    _logger.log(_getLogLevelForAlert(alert.level), 'Performance alert: ${alert.message}');
  }
  
  /// Clears an alert
  void clearAlert(String alertId) {
    final alert = _activeAlerts[alertId];
    if (alert != null) {
      alert.isActive = false;
      _activeAlerts.remove(alertId);
      _logger.debug('Alert cleared: $alertId');
    }
  }
  
  /// Clears all alerts
  void clearAllAlerts() {
    for (final alert in _activeAlerts.values) {
      alert.isActive = false;
    }
    _activeAlerts.clear();
    _logger.debug('All alerts cleared');
  }
  
  /// Updates monitor metrics
  void updateMetrics() {
    if (!_enabled || _paused) return;
    
    for (final metric in _metrics.values) {
      if (!metric.enabled) continue;
      
      final value = _getMetricValue(metric.name);
      if (value != null) {
        _recordMetricValue(metric.name, value);
        _evaluateMetricThreshold(metric, value);
      }
    }
  }
  
  /// Gets performance statistics
  Map<String, dynamic> get stats {
    final metricsStats = <String, dynamic>{};
    for (final metric in _metrics.values) {
      final history = _metricHistory[metric.name];
      metricsStats[metric.name] = {
        'enabled': metric.enabled,
        'currentValue': history?.isNotEmpty == true ? history!.last : null,
        'historySize': history?.length ?? 0,
        'threshold': metric.threshold?.toMap(),
      };
    }
    
    return {
      'enabled': _enabled,
      'paused': _paused,
      'metricsCount': _metrics.length,
      'actionsCount': _actions.length,
      'activeAlertsCount': _activeAlerts.length,
      'alertHistoryCount': _alertHistory.length,
      'metrics': metricsStats,
      'activeAlerts': _activeAlerts.values.map((a) => a.toMap()).toList(),
    };
  }
  
  /// Gets a formatted report
  String get report {
    final buffer = StringBuffer();
    buffer.writeln('=== DSRT Performance Monitor Report ===');
    buffer.writeln('Status: ${_enabled ? (_paused ? "Paused" : "Enabled") : "Disabled"}');
    buffer.writeln('Timestamp: ${DateTime.now()}');
    buffer.writeln();
    
    // Active alerts
    if (_activeAlerts.isNotEmpty) {
      buffer.writeln('Active Alerts (${_activeAlerts.length}):');
      for (final alert in _activeAlerts.values) {
        buffer.writeln('  ${alert.toString()}');
      }
      buffer.writeln();
    }
    
    // Metric status
    buffer.writeln('Monitored Metrics (${_metrics.length}):');
    for (final metric in _metrics.values) {
      final history = _metricHistory[metric.name];
      final currentValue = history?.isNotEmpty == true ? history!.last : null;
      
      buffer.write('  ${metric.name}: ');
      if (currentValue != null) {
        buffer.write('$currentValue');
        if (metric.threshold != null) {
          final level = metric.threshold!.evaluate(currentValue);
          if (level != null) {
            buffer.write(' [$level]');
          }
        }
      } else {
        buffer.write('No data');
      }
      buffer.writeln();
    }
    
    return buffer.toString();
  }
  
  /// Initializes default metrics
  void _initializeDefaultMetrics() {
    // Frame rate metrics
    registerMetric(DsrtMonitorMetric(
      name: 'fps',
      description: 'Frames per second',
      unit: DsrtStatsUnit.fps,
      threshold: DsrtMonitorThreshold(
        metric: 'fps',
        warningThreshold: 30.0,
        criticalThreshold: 20.0,
        emergencyThreshold: 10.0,
        greaterIsWorse: false, // Lower FPS is worse
        timeWindow: 3.0,
        minSamples: 5,
      ),
    ));
    
    // Frame time metrics
    registerMetric(DsrtMonitorMetric(
      name: 'frameTime',
      description: 'Frame time in milliseconds',
      unit: DsrtStatsUnit.milliseconds,
      threshold: DsrtMonitorThreshold(
        metric: 'frameTime',
        warningThreshold: 33.33, // 30 FPS
        criticalThreshold: 50.0, // 20 FPS
        emergencyThreshold: 100.0, // 10 FPS
        greaterIsWorse: true, // Higher frame time is worse
        timeWindow: 3.0,
        minSamples: 5,
      ),
    ));
    
    // Memory metrics
    registerMetric(DsrtMonitorMetric(
      name: 'memoryUsage',
      description: 'Memory usage in megabytes',
      unit: DsrtStatsUnit.megabytes,
      threshold: DsrtMonitorThreshold(
        metric: 'memoryUsage',
        warningThreshold: 500.0,
        criticalThreshold: 800.0,
        emergencyThreshold: 1000.0,
        greaterIsWorse: true,
        timeWindow: 10.0,
        minSamples: 5,
      ),
    ));
    
    // CPU metrics (estimated)
    registerMetric(DsrtMonitorMetric(
      name: 'cpuUsage',
      description: 'CPU usage percentage',
      unit: DsrtStatsUnit.percent,
      threshold: DsrtMonitorThreshold(
        metric: 'cpuUsage',
        warningThreshold: 80.0,
        criticalThreshold: 90.0,
        emergencyThreshold: 95.0,
        greaterIsWorse: true,
        timeWindow: 5.0,
        minSamples: 5,
      ),
    ));
  }
  
  /// Initializes default actions
  void _initializeDefaultActions() {
    // Log action for all alerts
    registerAction(DsrtMonitorAction(
      type: DsrtMonitorActionType.log,
      name: 'log_all_alerts',
      description: 'Log all performance alerts',
      triggerLevel: DsrtMonitorAlertLevel.info,
    ));
    
    // Reduce quality on warning
    registerAction(DsrtMonitorAction(
      type: DsrtMonitorActionType.reduceQuality,
      name: 'reduce_quality_on_warning',
      description: 'Reduce rendering quality on warning alerts',
      triggerLevel: DsrtMonitorAlertLevel.warning,
      parameters: {
        'qualityLevel': 'medium',
        'disableShadows': true,
        'reduceTextureQuality': true,
      },
      cooldown: 60.0,
    ));
    
    // Enable performance mode on critical
    registerAction(DsrtMonitorAction(
      type: DsrtMonitorActionType.enablePerformanceMode,
      name: 'enable_performance_mode_on_critical',
      description: 'Enable performance mode on critical alerts',
      triggerLevel: DsrtMonitorAlertLevel.critical,
      parameters: {
        'performanceMode': true,
        'disablePostProcessing': true,
        'reduceDrawDistance': true,
      },
      cooldown: 30.0,
    ));
    
    // Emergency actions
    registerAction(DsrtMonitorAction(
      type: DsrtMonitorActionType.disableFeatures,
      name: 'disable_non_essential_features_on_emergency',
      description: 'Disable non-essential features on emergency alerts',
      triggerLevel: DsrtMonitorAlertLevel.emergency,
      parameters: {
        'disablePhysics': false,
        'disableAudio': true,
        'disableParticles': true,
        'disableShadows': true,
        'disableReflections': true,
      },
      cooldown: 10.0,
    ));
  }
  
  /// Starts the update timer
  void _startUpdateTimer() {
    if (_updateTimer != null && _updateTimer!.isActive) {
      return;
    }
    
    final interval = Duration(milliseconds: (_updateInterval * 1000).round());
    _updateTimer = Timer.periodic(interval, (_) {
      if (_enabled && !_paused) {
        updateMetrics();
      }
    });
  }
  
  /// Stops the update timer
  void _stopUpdateTimer() {
    _updateTimer?.cancel();
    _updateTimer = null;
  }
  
  /// Gets the value of a metric
  double? _getMetricValue(String metricName) {
    switch (metricName) {
      case 'fps':
        final counter = _statsCollector.getCounter('fps');
        return counter?.value;
      
      case 'frameTime':
        final counter = _statsCollector.getCounter('frameTime');
        return counter?.value;
      
      case 'memoryUsage':
        final counter = _statsCollector.getCounter('memoryUsed');
        return counter?.value;
      
      case 'cpuUsage':
        // Estimate CPU usage based on frame time
        final frameTimeCounter = _statsCollector.getCounter('frameTime');
        if (frameTimeCounter?.value != null) {
          // Assume 16.67ms (60 FPS) is 0% CPU and 33.33ms (30 FPS) is 100% CPU
          const targetFrameTime = 16.67;
          final frameTime = frameTimeCounter!.value;
          return math.min(100.0, (frameTime / targetFrameTime) * 100.0);
        }
        return null;
      
      default:
        // Check if it's a custom counter
        final counter = _statsCollector.getCounter(metricName);
        return counter?.value;
    }
  }
  
  /// Records a metric value
  void _recordMetricValue(String metricName, double value) {
    if (!_metricHistory.containsKey(metricName)) {
      _metricHistory[metricName] = [];
    }
    
    final history = _metricHistory[metricName]!;
    history.add(value);
    
    // Trim history if needed
    if (history.length > _maxMetricHistory) {
      history.removeAt(0);
    }
  }
  
  /// Evaluates a metric against its threshold
  void _evaluateMetricThreshold(DsrtMonitorMetric metric, double value) {
    final threshold = metric.threshold;
    if (threshold == null) return;
    
    // Check if we have enough samples
    final history = _metricHistory[metric.name];
    if (history == null || history.length < threshold.minSamples) {
      return;
    }
    
    // Get samples from the time window
    final windowSamples = _getSamplesInTimeWindow(metric.name, threshold.timeWindow);
    if (windowSamples.length < threshold.minSamples) {
      return;
    }
    
    // Calculate average value in window
    final windowAverage = windowSamples.reduce((a, b) => a + b) / windowSamples.length;
    
    // Evaluate against threshold
    final alertLevel = threshold.evaluate(windowAverage);
    if (alertLevel != null) {
      // Check if we already have an active alert for this metric
      final existingAlert = _findActiveAlertForMetric(metric.name, alertLevel);
      if (existingAlert == null) {
        // Create new alert
        final alert = DsrtMonitorAlert(
          id: '${metric.name}_${alertLevel.name}_${DateTime.now().millisecondsSinceEpoch}',
          level: alertLevel,
          message: '${metric.description} ${threshold.greaterIsWorse ? "above" : "below"} threshold',
          metric: metric.name,
          value: windowAverage,
          threshold: threshold.greaterIsWorse
              ? _getThresholdForLevel(threshold, alertLevel)
              : _getThresholdForLevel(threshold, alertLevel),
        );
        
        triggerAlert(alert);
      }
    } else {
      // Clear any active alerts for this metric if value is now normal
      _clearAlertsForMetricIfNormal(metric.name, windowAverage, threshold);
    }
  }
  
  /// Gets samples within a time window
  List<double> _getSamplesInTimeWindow(String metricName, double timeWindow) {
    final history = _metricHistory[metricName];
    if (history == null || history.isEmpty) {
      return [];
    }
    
    // For simplicity, we assume samples are taken at regular intervals
    // In a real implementation, we would track timestamps for each sample
    final expectedSamples = (timeWindow / _updateInterval).ceil();
    return history.sublist(math.max(0, history.length - expectedSamples));
  }
  
  /// Finds an active alert for a metric
  DsrtMonitorAlert? _findActiveAlertForMetric(String metricName, DsrtMonitorAlertLevel level) {
    for (final alert in _activeAlerts.values) {
      if (alert.metric == metricName && 
          alert.level == level && 
          alert.isActive) {
        return alert;
      }
    }
    return null;
  }
  
  /// Clears alerts for a metric if value is normal
  void _clearAlertsForMetricIfNormal(
    String metricName,
    double value,
    DsrtMonitorThreshold threshold,
  ) {
    final alertsToClear = <String>[];
    
    for (final alert in _activeAlerts.values) {
      if (alert.metric == metricName && alert.isActive) {
        final alertLevel = threshold.evaluate(value);
        if (alertLevel == null || alertLevel.index < alert.level.index) {
          alertsToClear.add(alert.id);
        }
      }
    }
    
    for (final alertId in alertsToClear) {
      clearAlert(alertId);
    }
  }
  
  /// Gets threshold value for a specific level
  double _getThresholdForLevel(DsrtMonitorThreshold threshold, DsrtMonitorAlertLevel level) {
    switch (level) {
      case DsrtMonitorAlertLevel.warning:
        return threshold.warningThreshold;
      case DsrtMonitorAlertLevel.critical:
        return threshold.criticalThreshold;
      case DsrtMonitorAlertLevel.emergency:
        return threshold.emergencyThreshold;
      default:
        return 0.0;
    }
  }
  
  /// Executes actions for an alert
  Future<void> _executeActionsForAlert(DsrtMonitorAlert alert) async {
    for (final action in _actions.values) {
      if (!action.enabled || action.triggerLevel.index > alert.level.index) {
        continue;
      }
      
      if (action.canExecute()) {
        final callback = _actionCallbacks[action.type];
        if (callback != null) {
          try {
            await callback(action, alert);
            action.markExecuted();
            _logger.debug('Action executed: ${action.name} for alert: ${alert.id}');
          } catch (error, stackTrace) {
            _logger.error('Error executing action ${action.name}: $error', stackTrace);
          }
        }
      }
    }
  }
  
  /// Gets log level for alert level
  DsrtLogLevel _getLogLevelForAlert(DsrtMonitorAlertLevel alertLevel) {
    switch (alertLevel) {
      case DsrtMonitorAlertLevel.info:
        return DsrtLogLevel.info;
      case DsrtMonitorAlertLevel.warning:
        return DsrtLogLevel.warning;
      case DsrtMonitorAlertLevel.critical:
        return DsrtLogLevel.error;
      case DsrtMonitorAlertLevel.emergency:
        return DsrtLogLevel.error;
    }
  }
  
  @override
  Future<void> dispose() async {
    _stopUpdateTimer();
    clearAllAlerts();
    _alertCallbacks.clear();
    _actionCallbacks.clear();
    _logger.debug('Performance monitor disposed');
  }
}

/// Global performance monitor instance
class DsrtGlobalMonitor {
  static DsrtPerformanceMonitor? _instance;
  
  static DsrtPerformanceMonitor get instance {
    if (_instance == null) {
      throw StateError('Performance monitor not initialized');
    }
    return _instance!;
  }
  
  static void initialize({
    required DsrtStatsCollector statsCollector,
    required DsrtProfiler profiler,
    DsrtLogger? logger,
  }) {
    _instance = DsrtPerformanceMonitor(
      statsCollector: statsCollector,
      profiler: profiler,
      logger: logger,
    );
  }
  
  static void dispose() {
    _instance?.dispose();
    _instance = null;
  }
  
  static bool get isInitialized => _instance != null;
}

/// Performance monitoring utilities
class DsrtMonitorUtils {
  /// Creates default threshold for FPS
  static DsrtMonitorThreshold createFpsThreshold({
    double warning = 30.0,
    double critical = 20.0,
    double emergency = 10.0,
  }) {
    return DsrtMonitorThreshold(
      metric: 'fps',
      warningThreshold: warning,
      criticalThreshold: critical,
      emergencyThreshold: emergency,
      greaterIsWorse: false,
      timeWindow: 3.0,
      minSamples: 5,
    );
  }
  
  /// Creates default threshold for frame time
  static DsrtMonitorThreshold createFrameTimeThreshold({
    double warning = 33.33, // 30 FPS
    double critical = 50.0, // 20 FPS
    double emergency = 100.0, // 10 FPS
  }) {
    return DsrtMonitorThreshold(
      metric: 'frameTime',
      warningThreshold: warning,
      criticalThreshold: critical,
      emergencyThreshold: emergency,
      greaterIsWorse: true,
      timeWindow: 3.0,
      minSamples: 5,
    );
  }
  
  /// Creates default threshold for memory usage
  static DsrtMonitorThreshold createMemoryThreshold({
    double warning = 500.0, // MB
    double critical = 800.0, // MB
    double emergency = 1000.0, // MB
  }) {
    return DsrtMonitorThreshold(
      metric: 'memoryUsage',
      warningThreshold: warning,
      criticalThreshold: critical,
      emergencyThreshold: emergency,
      greaterIsWorse: true,
      timeWindow: 10.0,
      minSamples: 5,
    );
  }
  
  /// Analyzes performance trends
  static Map<String, dynamic> analyzeTrends(List<double> values, int windowSize) {
    if (values.isEmpty) {
      return {
        'trend': 'stable',
        'slope': 0.0,
        'volatility': 0.0,
      };
    }
    
    final window = math.min(windowSize, values.length);
    final windowValues = values.sublist(values.length - window);
    
    // Calculate linear regression
    double sumX = 0.0;
    double sumY = 0.0;
    double sumXY = 0.0;
    double sumX2 = 0.0;
    
    for (var i = 0; i < windowValues.length; i++) {
      final x = i.toDouble();
      final y = windowValues[i];
      sumX += x;
      sumY += y;
      sumXY += x * y;
      sumX2 += x * x;
    }
    
    final n = windowValues.length.toDouble();
    final slope = (n * sumXY - sumX * sumY) / (n * sumX2 - sumX * sumX);
    
    // Calculate volatility (standard deviation)
    final mean = sumY / n;
    double sumSquaredDiff = 0.0;
    for (final value in windowValues) {
      sumSquaredDiff += math.pow(value - mean, 2);
    }
    final volatility = math.sqrt(sumSquaredDiff / n);
    
    // Determine trend
    String trend;
    if (slope > 0.1) {
      trend = 'increasing';
    } else if (slope < -0.1) {
      trend = 'decreasing';
    } else {
      trend = 'stable';
    }
    
    return {
      'trend': trend,
      'slope': slope,
      'volatility': volatility,
      'mean': mean,
      'min': windowValues.reduce(math.min),
      'max': windowValues.reduce(math.max),
    };
  }
}
