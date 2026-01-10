// lib/src/core/performance/stats.dart

/// DSRT Engine - Performance Statistics
/// 
/// Provides comprehensive performance statistics collection, analysis,
/// and reporting for monitoring engine performance.
/// 
/// @category Core
/// @subcategory Performance
/// @version 1.0.0
/// @license MIT
/// @copyright DSRT Engine Team

library dsrt_engine.core.performance.stats;

import 'dart:async';
import 'dart:collection';
import 'dart:math' as math;

import '../../utils/logger.dart';
import 'profiler.dart';

/// Statistics category
enum DsrtStatsCategory {
  /// Frame rendering statistics
  frame,
  
  /// Memory usage statistics
  memory,
  
  /// CPU usage statistics
  cpu,
  
  /// GPU usage statistics
  gpu,
  
  /// Network statistics
  network,
  
  /// Asset loading statistics
  assets,
  
  /// Physics statistics
  physics,
  
  /// Audio statistics
  audio,
  
  /// Input statistics
  input,
  
  /// Custom statistics
  custom
}

/// Statistics measurement unit
enum DsrtStatsUnit {
  /// Time in seconds
  seconds,
  
  /// Time in milliseconds
  milliseconds,
  
  /// Count (unitless)
  count,
  
  /// Percentage (0-100)
  percent,
  
  /// Bytes
  bytes,
  
  /// Kilobytes
  kilobytes,
  
  /// Megabytes
  megabytes,
  
  /// Gigabytes
  gigabytes,
  
  /// Frames per second
  fps,
  
  /// Draw calls per frame
  drawCalls,
  
  /// Triangles per frame
  triangles,
  
  /// Vertices per frame
  vertices,
  
  /// Custom unit
  custom
}

/// Statistics data point
class DsrtStatsDataPoint {
  /// Timestamp
  final DateTime timestamp;
  
  /// Value
  final double value;
  
  /// Minimum value in window
  final double min;
  
  /// Maximum value in window
  final double max;
  
  /// Average value in window
  final double average;
  
  /// Creates a statistics data point
  DsrtStatsDataPoint({
    required this.timestamp,
    required this.value,
    required this.min,
    required this.max,
    required this.average,
  });
  
  /// Creates a simple data point
  factory DsrtStatsDataPoint.simple(DateTime timestamp, double value) {
    return DsrtStatsDataPoint(
      timestamp: timestamp,
      value: value,
      min: value,
      max: value,
      average: value,
    );
  }
  
  /// Converts to a map
  Map<String, dynamic> toMap() {
    return {
      'timestamp': timestamp.toIso8601String(),
      'value': value,
      'min': min,
      'max': max,
      'average': average,
    };
  }
}

/// Statistics counter
class DsrtStatsCounter {
  /// Counter name
  final String name;
  
  /// Counter category
  final DsrtStatsCategory category;
  
  /// Counter unit
  final DsrtStatsUnit unit;
  
  /// Custom unit name (if unit is custom)
  final String? customUnit;
  
  /// Counter description
  final String description;
  
  /// Current value
  double _value = 0.0;
  
  /// Total accumulated value
  double _total = 0.0;
  
  /// Minimum value recorded
  double _min = double.infinity;
  
  /// Maximum value recorded
  double _max = double.negativeInfinity;
  
  /// Number of samples
  int _samples = 0;
  
  /// Last update timestamp
  DateTime? _lastUpdate;
  
  /// Creates a statistics counter
  DsrtStatsCounter({
    required this.name,
    required this.category,
    required this.unit,
    this.customUnit,
    this.description = '',
  });
  
  /// Gets the current value
  double get value => _value;
  
  /// Gets the total accumulated value
  double get total => _total;
  
  /// Gets the minimum value
  double get min => _samples > 0 ? _min : 0.0;
  
  /// Gets the maximum value
  double get max => _samples > 0 ? _max : 0.0;
  
  /// Gets the average value
  double get average => _samples > 0 ? _total / _samples : 0.0;
  
  /// Gets the number of samples
  int get samples => _samples;
  
  /// Gets the last update timestamp
  DateTime? get lastUpdate => _lastUpdate;
  
  /// Sets the current value
  void setValue(double newValue) {
    _value = newValue;
    _total += newValue;
    _min = math.min(_min, newValue);
    _max = math.max(_max, newValue);
    _samples++;
    _lastUpdate = DateTime.now();
  }
  
  /// Increments the counter by a value
  void increment([double amount = 1.0]) {
    setValue(_value + amount);
  }
  
  /// Decrements the counter by a value
  void decrement([double amount = 1.0]) {
    setValue(_value - amount);
  }
  
  /// Resets the counter
  void reset() {
    _value = 0.0;
    _total = 0.0;
    _min = double.infinity;
    _max = double.negativeInfinity;
    _samples = 0;
    _lastUpdate = null;
  }
  
  /// Gets a formatted value string
  String get formattedValue {
    switch (unit) {
      case DsrtStatsUnit.seconds:
        return '${_value.toStringAsFixed(3)}s';
      case DsrtStatsUnit.milliseconds:
        return '${(_value * 1000).toStringAsFixed(2)}ms';
      case DsrtStatsUnit.percent:
        return '${_value.toStringAsFixed(1)}%';
      case DsrtStatsUnit.bytes:
        return _formatBytes(_value);
      case DsrtStatsUnit.kilobytes:
        return '${(_value / 1024).toStringAsFixed(2)}KB';
      case DsrtStatsUnit.megabytes:
        return '${(_value / (1024 * 1024)).toStringAsFixed(2)}MB';
      case DsrtStatsUnit.gigabytes:
        return '${(_value / (1024 * 1024 * 1024)).toStringAsFixed(2)}GB';
      case DsrtStatsUnit.fps:
        return '${_value.toStringAsFixed(1)} FPS';
      case DsrtStatsUnit.drawCalls:
        return '${_value.toInt()} draw calls';
      case DsrtStatsUnit.triangles:
        return _formatLargeNumber(_value.toInt());
      case DsrtStatsUnit.vertices:
        return _formatLargeNumber(_value.toInt());
      case DsrtStatsUnit.count:
        return _formatLargeNumber(_value.toInt());
      case DsrtStatsUnit.custom:
        return '${_value.toStringAsFixed(2)} ${customUnit ?? "units"}';
    }
  }
  
  /// Gets statistics as a map
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'category': category.name,
      'unit': unit.name,
      'customUnit': customUnit,
      'description': description,
      'value': _value,
      'total': _total,
      'min': min,
      'max': max,
      'average': average,
      'samples': _samples,
      'lastUpdate': _lastUpdate?.toIso8601String(),
      'formattedValue': formattedValue,
    };
  }
  
  /// Formats bytes with appropriate unit
  static String _formatBytes(double bytes) {
    const units = ['B', 'KB', 'MB', 'GB', 'TB'];
    var unitIndex = 0;
    var value = bytes;
    
    while (value >= 1024 && unitIndex < units.length - 1) {
      value /= 1024;
      unitIndex++;
    }
    
    return '${value.toStringAsFixed(2)} ${units[unitIndex]}';
  }
  
  /// Formats large numbers with commas
  static String _formatLargeNumber(int number) {
    final String str = number.toString();
    final buffer = StringBuffer();
    var count = 0;
    
    for (var i = str.length - 1; i >= 0; i--) {
      buffer.write(str[i]);
      count++;
      if (count == 3 && i > 0) {
        buffer.write(',');
        count = 0;
      }
    }
    
    return buffer.toString().split('').reversed.join();
  }
}

/// Statistics time series
class DsrtStatsTimeSeries {
  /// Series name
  final String name;
  
  /// Series category
  final DsrtStatsCategory category;
  
  /// Series unit
  final DsrtStatsUnit unit;
  
  /// Maximum data points to keep
  final int maxPoints;
  
  /// Data points
  final List<DsrtStatsDataPoint> _points;
  
  /// Window size for moving average
  final int _windowSize;
  
  /// Creates a statistics time series
  DsrtStatsTimeSeries({
    required this.name,
    required this.category,
    required this.unit,
    this.maxPoints = 1000,
    int windowSize = 10,
  })  : _points = [],
        _windowSize = math.max(1, windowSize);
  
  /// Adds a data point
  void addPoint(double value, [DateTime? timestamp]) {
    final pointTimestamp = timestamp ?? DateTime.now();
    
    // Calculate moving statistics
    final windowStart = math.max(0, _points.length - _windowSize);
    final windowPoints = _points.sublist(windowStart);
    
    double windowMin = value;
    double windowMax = value;
    double windowSum = value;
    
    for (final point in windowPoints) {
      windowMin = math.min(windowMin, point.value);
      windowMax = math.max(windowMax, point.value);
      windowSum += point.value;
    }
    
    final windowAverage = windowSum / (windowPoints.length + 1);
    
    final point = DsrtStatsDataPoint(
      timestamp: pointTimestamp,
      value: value,
      min: windowMin,
      max: windowMax,
      average: windowAverage,
    );
    
    _points.add(point);
    
    // Trim if needed
    if (_points.length > maxPoints) {
      _points.removeAt(0);
    }
  }
  
  /// Gets all data points
  List<DsrtStatsDataPoint> get points => List.unmodifiable(_points);
  
  /// Gets the latest data point
  DsrtStatsDataPoint? get latestPoint => _points.isNotEmpty ? _points.last : null;
  
  /// Gets the latest value
  double get latestValue => latestPoint?.value ?? 0.0;
  
  /// Gets the minimum value in the series
  double get minValue {
    if (_points.isEmpty) return 0.0;
    return _points.map((p) => p.value).reduce(math.min);
  }
  
  /// Gets the maximum value in the series
  double get maxValue {
    if (_points.isEmpty) return 0.0;
    return _points.map((p) => p.value).reduce(math.max);
  }
  
  /// Gets the average value in the series
  double get averageValue {
    if (_points.isEmpty) return 0.0;
    return _points.map((p) => p.value).reduce((a, b) => a + b) / _points.length;
  }
  
  /// Clears all data points
  void clear() {
    _points.clear();
  }
  
  /// Gets statistics for a time range
  Map<String, dynamic> getStatsForRange(DateTime start, DateTime end) {
    final rangePoints = _points.where((p) => 
      p.timestamp.isAfter(start) && p.timestamp.isBefore(end)
    ).toList();
    
    if (rangePoints.isEmpty) {
      return {
        'count': 0,
        'min': 0.0,
        'max': 0.0,
        'average': 0.0,
      };
    }
    
    final values = rangePoints.map((p) => p.value).toList();
    final min = values.reduce(math.min);
    final max = values.reduce(math.max);
    final average = values.reduce((a, b) => a + b) / values.length;
    
    return {
      'count': rangePoints.length,
      'min': min,
      'max': max,
      'average': average,
    };
  }
  
  /// Converts to a map
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'category': category.name,
      'unit': unit.name,
      'pointCount': _points.length,
      'latestValue': latestValue,
      'minValue': minValue,
      'maxValue': maxValue,
      'averageValue': averageValue,
      'points': _points.map((p) => p.toMap()).toList(),
    };
  }
}

/// Statistics collector
class DsrtStatsCollector implements DsrtDisposable {
  /// Statistics counters
  final Map<String, DsrtStatsCounter> _counters;
  
  /// Statistics time series
  final Map<String, DsrtStatsTimeSeries> _timeSeries;
  
  /// Statistics logger
  final DsrtLogger _logger;
  
  /// Whether statistics collection is enabled
  bool _enabled = true;
  
  /// Auto-save interval in seconds
  final int _autoSaveInterval;
  
  /// Auto-save timer
  Timer? _autoSaveTimer;
  
  /// Statistics save callback
  Future<void> Function(Map<String, dynamic> stats)? _saveCallback;
  
  /// Creates a statistics collector
  DsrtStatsCollector({
    DsrtLogger? logger,
    int autoSaveInterval = 60,
    Future<void> Function(Map<String, dynamic> stats)? saveCallback,
  })  : _counters = {},
        _timeSeries = {},
        _logger = logger ?? DsrtLogger(),
        _autoSaveInterval = autoSaveInterval,
        _saveCallback = saveCallback {
    _initializeDefaultCounters();
    _startAutoSaveTimer();
  }
  
  /// Enables statistics collection
  void enable() {
    if (_enabled) return;
    _enabled = true;
    _logger.debug('Statistics collection enabled');
  }
  
  /// Disables statistics collection
  void disable() {
    if (!_enabled) return;
    _enabled = false;
    _logger.debug('Statistics collection disabled');
  }
  
  /// Checks if statistics collection is enabled
  bool get isEnabled => _enabled;
  
  /// Creates or gets a counter
  DsrtStatsCounter counter({
    required String name,
    required DsrtStatsCategory category,
    required DsrtStatsUnit unit,
    String? customUnit,
    String description = '',
  }) {
    if (!_counters.containsKey(name)) {
      _counters[name] = DsrtStatsCounter(
        name: name,
        category: category,
        unit: unit,
        customUnit: customUnit,
        description: description,
      );
    }
    return _counters[name]!;
  }
  
  /// Creates or gets a time series
  DsrtStatsTimeSeries timeSeries({
    required String name,
    required DsrtStatsCategory category,
    required DsrtStatsUnit unit,
    int maxPoints = 1000,
    int windowSize = 10,
  }) {
    if (!_timeSeries.containsKey(name)) {
      _timeSeries[name] = DsrtStatsTimeSeries(
        name: name,
        category: category,
        unit: unit,
        maxPoints: maxPoints,
        windowSize: windowSize,
      );
    }
    return _timeSeries[name]!;
  }
  
  /// Records a value to a counter
  void recordCounter(String name, double value) {
    if (!_enabled) return;
    
    final counter = _counters[name];
    if (counter != null) {
      counter.setValue(value);
    }
  }
  
  /// Records a value to a time series
  void recordTimeSeries(String name, double value, [DateTime? timestamp]) {
    if (!_enabled) return;
    
    final series = _timeSeries[name];
    if (series != null) {
      series.addPoint(value, timestamp);
    }
  }
  
  /// Increments a counter
  void incrementCounter(String name, [double amount = 1.0]) {
    if (!_enabled) return;
    
    final counter = _counters[name];
    if (counter != null) {
      counter.increment(amount);
    }
  }
  
  /// Decrements a counter
  void decrementCounter(String name, [double amount = 1.0]) {
    if (!_enabled) return;
    
    final counter = _counters[name];
    if (counter != null) {
      counter.decrement(amount);
    }
  }
  
  /// Gets a counter by name
  DsrtStatsCounter? getCounter(String name) {
    return _counters[name];
  }
  
  /// Gets a time series by name
  DsrtStatsTimeSeries? getTimeSeries(String name) {
    return _timeSeries[name];
  }
  
  /// Gets all counters
  List<DsrtStatsCounter> get counters => _counters.values.toList();
  
  /// Gets all time series
  List<DsrtStatsTimeSeries> get timeSeriesList => _timeSeries.values.toList();
  
  /// Gets counters by category
  List<DsrtStatsCounter> getCountersByCategory(DsrtStatsCategory category) {
    return _counters.values.where((c) => c.category == category).toList();
  }
  
  /// Gets time series by category
  List<DsrtStatsTimeSeries> getTimeSeriesByCategory(DsrtStatsCategory category) {
    return _timeSeries.values.where((s) => s.category == category).toList();
  }
  
  /// Resets all counters
  void resetCounters() {
    for (final counter in _counters.values) {
      counter.reset();
    }
  }
  
  /// Clears all time series
  void clearTimeSeries() {
    for (final series in _timeSeries.values) {
      series.clear();
    }
  }
  
  /// Resets all statistics
  void reset() {
    resetCounters();
    clearTimeSeries();
    _logger.debug('Statistics reset');
  }
  
  /// Gets comprehensive statistics
  Map<String, dynamic> get stats {
    final countersMap = <String, dynamic>{};
    for (final counter in _counters.values) {
      countersMap[counter.name] = counter.toMap();
    }
    
    final timeSeriesMap = <String, dynamic>{};
    for (final series in _timeSeries.values) {
      timeSeriesMap[series.name] = series.toMap();
    }
    
    return {
      'enabled': _enabled,
      'timestamp': DateTime.now().toIso8601String(),
      'counters': countersMap,
      'timeSeries': timeSeriesMap,
      'summary': _getSummary(),
    };
  }
  
  /// Gets a formatted statistics report
  String get report {
    final buffer = StringBuffer();
    buffer.writeln('=== DSRT Engine Statistics Report ===');
    buffer.writeln('Generated: ${DateTime.now()}');
    buffer.writeln('Status: ${_enabled ? "Enabled" : "Disabled"}');
    buffer.writeln();
    
    // Frame statistics
    final frameCounters = getCountersByCategory(DsrtStatsCategory.frame);
    if (frameCounters.isNotEmpty) {
      buffer.writeln('Frame Statistics:');
      for (final counter in frameCounters) {
        buffer.writeln('  ${counter.name}: ${counter.formattedValue}');
      }
      buffer.writeln();
    }
    
    // Memory statistics
    final memoryCounters = getCountersByCategory(DsrtStatsCategory.memory);
    if (memoryCounters.isNotEmpty) {
      buffer.writeln('Memory Statistics:');
      for (final counter in memoryCounters) {
        buffer.writeln('  ${counter.name}: ${counter.formattedValue}');
      }
      buffer.writeln();
    }
    
    // Performance statistics
    buffer.writeln('Performance Summary:');
    final summary = _getSummary();
    for (final entry in summary.entries) {
      buffer.writeln('  ${entry.key}: ${entry.value}');
    }
    
    return buffer.toString();
  }
  
  /// Sets the save callback
  void setSaveCallback(Future<void> Function(Map<String, dynamic> stats)> callback) {
    _saveCallback = callback;
  }
  
  /// Saves statistics
  Future<void> save() async {
    if (_saveCallback != null) {
      try {
        await _saveCallback!(stats);
        _logger.debug('Statistics saved');
      } catch (error, stackTrace) {
        _logger.error('Failed to save statistics: $error', stackTrace);
      }
    }
  }
  
  /// Initializes default counters
  void _initializeDefaultCounters() {
    // Frame statistics
    counter(
      name: 'fps',
      category: DsrtStatsCategory.frame,
      unit: DsrtStatsUnit.fps,
      description: 'Frames per second',
    );
    
    counter(
      name: 'frameTime',
      category: DsrtStatsCategory.frame,
      unit: DsrtStatsUnit.milliseconds,
      description: 'Frame time in milliseconds',
    );
    
    counter(
      name: 'frameCount',
      category: DsrtStatsCategory.frame,
      unit: DsrtStatsUnit.count,
      description: 'Total frames rendered',
    );
    
    // Memory statistics
    counter(
      name: 'memoryUsed',
      category: DsrtStatsCategory.memory,
      unit: DsrtStatsUnit.megabytes,
      description: 'Memory used by application',
    );
    
    counter(
      name: 'memoryPeak',
      category: DsrtStatsCategory.memory,
      unit: DsrtStatsUnit.megabytes,
      description: 'Peak memory usage',
    );
    
    counter(
      name: 'gpuMemory',
      category: DsrtStatsCategory.memory,
      unit: DsrtStatsUnit.megabytes,
      description: 'GPU memory usage',
    );
    
    // Rendering statistics
    counter(
      name: 'drawCalls',
      category: DsrtStatsCategory.frame,
      unit: DsrtStatsUnit.drawCalls,
      description: 'Draw calls per frame',
    );
    
    counter(
      name: 'triangles',
      category: DsrtStatsCategory.frame,
      unit: DsrtStatsUnit.triangles,
      description: 'Triangles rendered per frame',
    );
    
    counter(
      name: 'vertices',
      category: DsrtStatsCategory.frame,
      unit: DsrtStatsUnit.vertices,
      description: 'Vertices processed per frame',
    );
    
    // Initialize time series
    timeSeries(
      name: 'fpsHistory',
      category: DsrtStatsCategory.frame,
      unit: DsrtStatsUnit.fps,
      maxPoints: 300, // 5 seconds at 60 FPS
    );
    
    timeSeries(
      name: 'frameTimeHistory',
      category: DsrtStatsCategory.frame,
      unit: DsrtStatsUnit.milliseconds,
      maxPoints: 300,
    );
    
    timeSeries(
      name: 'memoryHistory',
      category: DsrtStatsCategory.memory,
      unit: DsrtStatsUnit.megabytes,
      maxPoints: 600, // 10 minutes at 1 sample per second
    );
  }
  
  /// Gets performance summary
  Map<String, String> _getSummary() {
    final fpsCounter = getCounter('fps');
    final frameTimeCounter = getCounter('frameTime');
    final memoryCounter = getCounter('memoryUsed');
    final drawCallsCounter = getCounter('drawCalls');
    
    return {
      'FPS': fpsCounter?.formattedValue ?? 'N/A',
      'Frame Time': frameTimeCounter?.formattedValue ?? 'N/A',
      'Memory': memoryCounter?.formattedValue ?? 'N/A',
      'Draw Calls': drawCallsCounter?.formattedValue ?? 'N/A',
      'Total Frames': getCounter('frameCount')?.formattedValue ?? 'N/A',
    };
  }
  
  /// Starts the auto-save timer
  void _startAutoSaveTimer() {
    if (_autoSaveInterval <= 0) return;
    
    _autoSaveTimer = Timer.periodic(
      Duration(seconds: _autoSaveInterval),
      (_) async {
        if (_enabled && _saveCallback != null) {
          await save();
        }
      },
    );
  }
  
  /// Stops the auto-save timer
  void _stopAutoSaveTimer() {
    _autoSaveTimer?.cancel();
    _autoSaveTimer = null;
  }
  
  @override
  Future<void> dispose() async {
    _stopAutoSaveTimer();
    
    // Save final statistics
    if (_enabled && _saveCallback != null) {
      await save();
    }
    
    _logger.debug('Statistics collector disposed');
  }
}

/// Statistics manager for engine-wide statistics
class DsrtStatsManager implements DsrtDisposable {
  /// Main statistics collector
  final DsrtStatsCollector _collector;
  
  /// Profiler reference
  final DsrtProfiler? _profiler;
  
  /// Update interval in seconds
  final double _updateInterval;
  
  /// Last update time
  double _lastUpdateTime = 0.0;
  
  /// Frame time accumulator
  final List<double> _frameTimeSamples;
  
  /// Maximum frame time samples
  final int _maxFrameTimeSamples;
  
  /// Creates a statistics manager
  DsrtStatsManager({
    DsrtProfiler? profiler,
    double updateInterval = 1.0,
    int maxFrameTimeSamples = 60,
    DsrtLogger? logger,
  })  : _collector = DsrtStatsCollector(logger: logger),
        _profiler = profiler,
        _updateInterval = math.max(0.1, updateInterval),
        _frameTimeSamples = [],
        _maxFrameTimeSamples = math.max(1, maxFrameTimeSamples);
  
  /// Updates statistics
  void update(double deltaTime) {
    _lastUpdateTime += deltaTime;
    
    if (_lastUpdateTime >= _updateInterval) {
      _updateStatistics();
      _lastUpdateTime = 0.0;
    }
    
    // Accumulate frame time for FPS calculation
    _frameTimeSamples.add(deltaTime);
    if (_frameTimeSamples.length > _maxFrameTimeSamples) {
      _frameTimeSamples.removeAt(0);
    }
  }
  
  /// Gets the statistics collector
  DsrtStatsCollector get collector => _collector;
  
  /// Gets the profiler
  DsrtProfiler? get profiler => _profiler;
  
  /// Updates all statistics
  void _updateStatistics() {
    // Calculate FPS from frame time samples
    if (_frameTimeSamples.isNotEmpty) {
      final totalTime = _frameTimeSamples.reduce((a, b) => a + b);
      final averageFrameTime = totalTime / _frameTimeSamples.length;
      final fps = averageFrameTime > 0 ? 1.0 / averageFrameTime : 0.0;
      
      _collector.recordCounter('fps', fps);
      _collector.recordCounter('frameTime', averageFrameTime * 1000);
      _collector.incrementCounter('frameCount', _frameTimeSamples.length.toDouble());
      
      // Record to time series
      _collector.recordTimeSeries('fpsHistory', fps);
      _collector.recordTimeSeries('frameTimeHistory', averageFrameTime * 1000);
    }
    
    // Update profiler statistics if available
    if (_profiler != null) {
      final avgFps = _profiler!.getAverageFps();
      final avgFrameTime = _profiler!.getAverageFrameTime();
      
      _collector.recordCounter('profilerFps', avgFps);
      _collector.recordCounter('profilerFrameTime', avgFrameTime * 1000);
    }
    
    // Update memory statistics (platform dependent)
    _updateMemoryStatistics();
  }
  
  /// Updates memory statistics
  void _updateMemoryStatistics() {
    try {
      // Platform-specific memory tracking
      // This is a simplified implementation
      final process = Process.runSync('ps', ['-o', 'rss=', '-p', '${pid}']);
      if (process.exitCode == 0) {
        final output = process.stdout.toString().trim();
        final memoryKb = int.tryParse(output) ?? 0;
        final memoryMb = memoryKb / 1024.0;
        
        _collector.recordCounter('memoryUsed', memoryMb);
        _collector.recordTimeSeries('memoryHistory', memoryMb);
        
        // Update peak memory
        final peakCounter = _collector.getCounter('memoryPeak');
        if (peakCounter != null && memoryMb > peakCounter.value) {
          _collector.recordCounter('memoryPeak', memoryMb);
        }
      }
    } catch (_) {
      // Memory tracking not available on this platform
    }
  }
  
  /// Gets process ID
  static int get pid => Process.current.pid;
  
  /// Gets a formatted report
  String get report => _collector.report;
  
  /// Gets comprehensive statistics
  Map<String, dynamic> get stats => _collector.stats;
  
  @override
  Future<void> dispose() async {
    await _collector.dispose();
  }
}

/// Global statistics instance
class DsrtGlobalStats {
  static DsrtStatsManager? _instance;
  
  static DsrtStatsManager get instance {
    if (_instance == null) {
      throw StateError('Statistics manager not initialized');
    }
    return _instance!;
  }
  
  static void initialize({DsrtProfiler? profiler}) {
    _instance = DsrtStatsManager(profiler: profiler);
  }
  
  static void dispose() {
    _instance?.dispose();
    _instance = null;
  }
  
  static bool get isInitialized => _instance != null;
}

/// Statistics utilities
class DsrtStatsUtils {
  /// Formats a duration for display
  static String formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);
    final milliseconds = duration.inMilliseconds.remainder(1000);
    
    if (hours > 0) {
      return '${hours}h ${minutes}m ${seconds}s';
    } else if (minutes > 0) {
      return '${minutes}m ${seconds}s';
    } else if (seconds > 0) {
      return '${seconds}.${milliseconds.toString().padLeft(3, '0')}s';
    } else {
      return '${milliseconds}ms';
    }
  }
  
  /// Formats a file size for display
  static String formatFileSize(int bytes) {
    const units = ['B', 'KB', 'MB', 'GB', 'TB'];
    var unitIndex = 0;
    var size = bytes.toDouble();
    
    while (size >= 1024 && unitIndex < units.length - 1) {
      size /= 1024;
      unitIndex++;
    }
    
    return '${size.toStringAsFixed(2)} ${units[unitIndex]}';
  }
  
  /// Calculates percentage
  static double calculatePercentage(double value, double total) {
    return total > 0 ? (value / total) * 100.0 : 0.0;
  }
  
  /// Calculates moving average
  static double calculateMovingAverage(List<double> values, int windowSize) {
    if (values.isEmpty) return 0.0;
    
    final window = math.min(windowSize, values.length);
    final windowValues = values.sublist(values.length - window);
    final sum = windowValues.reduce((a, b) => a + b);
    
    return sum / window;
  }
}
