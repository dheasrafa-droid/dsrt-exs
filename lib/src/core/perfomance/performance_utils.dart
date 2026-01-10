// lib/src/core/performance/performance_utils.dart

/// DSRT Engine - Performance Utilities
/// 
/// Provides utility functions and helpers for performance optimization,
/// measurement, and analysis across the engine.
/// 
/// @category Core
/// @subcategory Performance
/// @version 1.0.0
/// @license MIT
/// @copyright DSRT Engine Team

library dsrt_engine.core.performance.performance_utils;

import 'dart:async';
import 'dart:collection';
import 'dart:math' as math;
import 'dart:developer' as developer;

import '../../utils/logger.dart';

/// Performance measurement mode
enum DsrtPerformanceMode {
  /// Maximum performance (lowest latency)
  maximum,
  
  /// Balanced performance and quality
  balanced,
  
  /// Maximum quality (highest fidelity)
  quality,
  
  /// Power saving mode
  powerSaving,
  
  /// Custom performance profile
  custom
}

/// Performance bottleneck type
enum DsrtBottleneckType {
  /// CPU bottleneck
  cpu,
  
  /// GPU bottleneck
  gpu,
  
  /// Memory bottleneck
  memory,
  
  /// Disk I/O bottleneck
  disk,
  
  /// Network bottleneck
  network,
  
  /// Unknown bottleneck
  unknown
}

/// Performance optimization suggestion
class DsrtOptimizationSuggestion {
  /// Suggestion ID
  final String id;
  
  /// Suggestion title
  final String title;
  
  /// Suggestion description
  final String description;
  
  /// Bottleneck type this addresses
  final DsrtBottleneckType bottleneckType;
  
  /// Expected performance improvement (percentage)
  final double expectedImprovement;
  
  /// Implementation difficulty (1-10)
  final int difficulty;
  
  /// Whether this suggestion is enabled
  bool enabled;
  
  /// Creates an optimization suggestion
  DsrtOptimizationSuggestion({
    required this.id,
    required this.title,
    required this.description,
    required this.bottleneckType,
    required this.expectedImprovement,
    required this.difficulty,
    this.enabled = true,
  })  : assert(expectedImprovement >= 0 && expectedImprovement <= 100),
        assert(difficulty >= 1 && difficulty <= 10);
  
  /// Gets a priority score (higher = more important)
  double get priorityScore {
    // Weight expected improvement more heavily than difficulty
    return (expectedImprovement * 0.7) + ((11 - difficulty) * 0.3);
  }
  
  /// Converts to a map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'bottleneckType': bottleneckType.name,
      'expectedImprovement': expectedImprovement,
      'difficulty': difficulty,
      'enabled': enabled,
      'priorityScore': priorityScore,
    };
  }
}

/// Frame time analyzer
class DsrtFrameTimeAnalyzer {
  /// Frame time samples
  final List<double> _samples;
  
  /// Maximum number of samples
  final int _maxSamples;
  
  /// Creates a frame time analyzer
  DsrtFrameTimeAnalyzer({int maxSamples = 300})
      : _samples = [],
        _maxSamples = maxSamples;
  
  /// Adds a frame time sample
  void addSample(double frameTimeSeconds) {
    _samples.add(frameTimeSeconds);
    
    // Trim if needed
    if (_samples.length > _maxSamples) {
      _samples.removeAt(0);
    }
  }
  
  /// Gets the average frame time
  double get averageFrameTime {
    if (_samples.isEmpty) return 0.0;
    return _samples.reduce((a, b) => a + b) / _samples.length;
  }
  
  /// Gets the average FPS
  double get averageFps {
    final avgFrameTime = averageFrameTime;
    return avgFrameTime > 0 ? 1.0 / avgFrameTime : 0.0;
  }
  
  /// Gets the frame time variance
  double get variance {
    if (_samples.isEmpty) return 0.0;
    
    final mean = averageFrameTime;
    double sum = 0.0;
    
    for (final sample in _samples) {
      sum += math.pow(sample - mean, 2);
    }
    
    return sum / _samples.length;
  }
  
  /// Gets the frame time standard deviation
  double get standardDeviation => math.sqrt(variance);
  
  /// Gets the frame time jitter (relative standard deviation)
  double get jitter {
    final mean = averageFrameTime;
    return mean > 0 ? standardDeviation / mean : 0.0;
  }
  
  /// Gets the minimum frame time
  double get minFrameTime {
    if (_samples.isEmpty) return 0.0;
    return _samples.reduce(math.min);
  }
  
  /// Gets the maximum frame time
  double get maxFrameTime {
    if (_samples.isEmpty) return 0.0;
    return _samples.reduce(math.max);
  }
  
  /// Gets the 95th percentile frame time
  double get percentile95 {
    if (_samples.isEmpty) return 0.0;
    
    final sorted = List<double>.from(_samples)..sort();
    final index = (sorted.length * 0.95).floor();
    return sorted[index];
  }
  
  /// Gets the frame time consistency score (0-100)
  double get consistencyScore {
    if (_samples.length < 2) return 100.0;
    
    final jitterValue = jitter;
    if (jitterValue == 0.0) return 100.0;
    
    // Convert jitter to consistency score
    // Lower jitter = higher consistency
    final consistency = math.max(0.0, 100.0 - (jitterValue * 1000.0));
    return consistency.clamp(0.0, 100.0);
  }
  
  /// Analyzes frame times and returns insights
  Map<String, dynamic> analyze() {
    return {
      'sampleCount': _samples.length,
      'averageFrameTime': averageFrameTime,
      'averageFps': averageFps,
      'minFrameTime': minFrameTime,
      'maxFrameTime': maxFrameTime,
      'percentile95': percentile95,
      'variance': variance,
      'standardDeviation': standardDeviation,
      'jitter': jitter,
      'consistencyScore': consistencyScore,
      'isStable': consistencyScore >= 90.0,
      'recommendation': _getRecommendation(),
    };
  }
  
  /// Gets performance recommendation
  String _getRecommendation() {
    if (_samples.isEmpty) return 'Insufficient data';
    
    final avgFps = averageFps;
    final consistency = consistencyScore;
    
    if (avgFps < 30.0) {
      return 'Critical: Average FPS below 30. Consider reducing graphics settings.';
    } else if (avgFps < 60.0) {
      return 'Warning: Average FPS below 60. Some optimization may be needed.';
    } else if (consistency < 80.0) {
      return 'Warning: Frame time consistency is low. Look for intermittent bottlenecks.';
    } else {
      return 'Good: Performance is stable and within acceptable range.';
    }
  }
  
  /// Clears all samples
  void clear() {
    _samples.clear();
  }
}

/// Memory usage analyzer
class DsrtMemoryAnalyzer {
  /// Memory samples (bytes)
  final List<int> _samples;
  
  /// Sample timestamps
  final List<DateTime> _timestamps;
  
  /// Maximum number of samples
  final int _maxSamples;
  
  /// Creates a memory analyzer
  DsrtMemoryAnalyzer({int maxSamples = 600})
      : _samples = [],
        _timestamps = [],
        _maxSamples = maxSamples;
  
  /// Adds a memory sample
  void addSample(int memoryBytes, [DateTime? timestamp]) {
    _samples.add(memoryBytes);
    _timestamps.add(timestamp ?? DateTime.now());
    
    // Trim if needed
    if (_samples.length > _maxSamples) {
      _samples.removeAt(0);
      _timestamps.removeAt(0);
    }
  }
  
  /// Gets the current memory usage
  int get currentMemory {
    return _samples.isNotEmpty ? _samples.last : 0;
  }
  
  /// Gets the peak memory usage
  int get peakMemory {
    if (_samples.isEmpty) return 0;
    return _samples.reduce(math.max);
  }
  
  /// Gets the average memory usage
  double get averageMemory {
    if (_samples.isEmpty) return 0.0;
    return _samples.reduce((a, b) => a + b) / _samples.length;
  }
  
  /// Gets the memory trend (bytes per second)
  double get memoryTrend {
    if (_samples.length < 2) return 0.0;
    
    final firstSample = _samples.first;
    final lastSample = _samples.last;
    final firstTime = _timestamps.first;
    final lastTime = _timestamps.last;
    
    final timeDiff = lastTime.difference(firstTime).inSeconds;
    if (timeDiff == 0) return 0.0;
    
    return (lastSample - firstSample) / timeDiff;
  }
  
  /// Detects memory leaks
  bool detectLeak({double thresholdPerMinute = 1024 * 1024}) {
    // Convert threshold to bytes per second
    final thresholdPerSecond = thresholdPerMinute / 60.0;
    
    if (_samples.length < 10) return false;
    
    // Use linear regression to detect trend
    double sumX = 0.0;
    double sumY = 0.0;
    double sumXY = 0.0;
    double sumX2 = 0.0;
    
    for (var i = 0; i < _samples.length; i++) {
      final x = i.toDouble();
      final y = _samples[i].toDouble();
      sumX += x;
      sumY += y;
      sumXY += x * y;
      sumX2 += x * x;
    }
    
    final n = _samples.length.toDouble();
    final slope = (n * sumXY - sumX * sumY) / (n * sumX2 - sumX * sumX);
    
    // Convert slope to bytes per second (assuming regular sampling)
    final sampleInterval = _calculateAverageSampleInterval();
    final bytesPerSecond = sampleInterval > 0 ? slope / sampleInterval : 0.0;
    
    return bytesPerSecond > thresholdPerSecond;
  }
  
  /// Calculates average sample interval in seconds
  double _calculateAverageSampleInterval() {
    if (_timestamps.length < 2) return 1.0;
    
    var totalDiff = 0;
    for (var i = 1; i < _timestamps.length; i++) {
      totalDiff += _timestamps[i].difference(_timestamps[i - 1]).inSeconds;
    }
    
    return totalDiff / (_timestamps.length - 1);
  }
  
  /// Analyzes memory usage and returns insights
  Map<String, dynamic> analyze() {
    final trend = memoryTrend;
    final leakDetected = detectLeak();
    
    return {
      'sampleCount': _samples.length,
      'currentMemory': currentMemory,
      'peakMemory': peakMemory,
      'averageMemory': averageMemory,
      'memoryTrend': trend,
      'memoryTrendMBps': trend / (1024 * 1024),
      'leakDetected': leakDetected,
      'recommendation': _getRecommendation(),
    };
  }
  
  /// Gets memory recommendation
  String _getRecommendation() {
    final currentMB = currentMemory / (1024 * 1024);
    final trendMBps = memoryTrend / (1024 * 1024);
    final leakDetected = detectLeak();
    
    if (leakDetected) {
      return 'Critical: Memory leak detected. Application memory is growing at ${trendMBps.toStringAsFixed(2)} MB/s.';
    } else if (currentMB > 1000) {
      return 'Warning: Memory usage is high (${currentMB.toStringAsFixed(2)} MB). Consider optimizing asset loading.';
    } else if (trendMBps > 0.1) {
      return 'Warning: Memory is slowly increasing. Monitor for potential leaks.';
    } else {
      return 'Good: Memory usage is stable and within acceptable range.';
    }
  }
  
  /// Clears all samples
  void clear() {
    _samples.clear();
    _timestamps.clear();
  }
}

/// Performance optimization manager
class DsrtPerformanceOptimizer {
  /// Performance mode
  DsrtPerformanceMode _mode = DsrtPerformanceMode.balanced;
  
  /// Optimization suggestions
  final Map<String, DsrtOptimizationSuggestion> _suggestions;
  
  /// Applied optimizations
  final Set<String> _appliedOptimizations;
  
  /// Logger
  final DsrtLogger _logger;
  
  /// Creates a performance optimizer
  DsrtPerformanceOptimizer({DsrtLogger? logger})
      : _suggestions = {},
        _appliedOptimizations = {},
        _logger = logger ?? DsrtLogger() {
    _initializeDefaultSuggestions();
  }
  
  /// Gets the current performance mode
  DsrtPerformanceMode get mode => _mode;
  
  /// Sets the performance mode
  void setMode(DsrtPerformanceMode newMode) {
    if (_mode == newMode) return;
    
    _mode = newMode;
    _applyModeOptimizations();
    _logger.info('Performance mode changed to: ${newMode.name}');
  }
  
  /// Adds an optimization suggestion
  void addSuggestion(DsrtOptimizationSuggestion suggestion) {
    _suggestions[suggestion.id] = suggestion;
  }
  
  /// Removes an optimization suggestion
  void removeSuggestion(String id) {
    _suggestions.remove(id);
  }
  
  /// Gets all suggestions
  List<DsrtOptimizationSuggestion> get suggestions => _suggestions.values.toList();
  
  /// Gets suggestions for a specific bottleneck
  List<DsrtOptimizationSuggestion> getSuggestionsForBottleneck(DsrtBottleneckType bottleneckType) {
    return _suggestions.values
        .where((s) => s.bottleneckType == bottleneckType && s.enabled)
        .toList();
  }
  
  /// Gets prioritized suggestions
  List<DsrtOptimizationSuggestion> getPrioritizedSuggestions([int limit = 10]) {
    return _suggestions.values
        .where((s) => s.enabled)
        .toList()
      ..sort((a, b) => b.priorityScore.compareTo(a.priorityScore))
      ..take(limit);
  }
  
  /// Applies an optimization
  void applyOptimization(String suggestionId) {
    final suggestion = _suggestions[suggestionId];
    if (suggestion == null || !suggestion.enabled) {
      throw ArgumentError('Suggestion $suggestionId not found or disabled');
    }
    
    if (_appliedOptimizations.contains(suggestionId)) {
      _logger.warning('Optimization $suggestionId is already applied');
      return;
    }
    
    // Apply the optimization (implementation depends on specific optimization)
    _applySpecificOptimization(suggestion);
    
    _appliedOptimizations.add(suggestionId);
    _logger.info('Applied optimization: ${suggestion.title}');
  }
  
  /// Reverts an optimization
  void revertOptimization(String suggestionId) {
    if (!_appliedOptimizations.contains(suggestionId)) {
      throw ArgumentError('Optimization $suggestionId is not applied');
    }
    
    // Revert the optimization
    _revertSpecificOptimization(suggestionId);
    
    _appliedOptimizations.remove(suggestionId);
    _logger.info('Reverted optimization: $suggestionId');
  }
  
  /// Analyzes performance data and suggests optimizations
  List<DsrtOptimizationSuggestion> analyzeAndSuggest({
    required DsrtFrameTimeAnalyzer frameAnalyzer,
    required DsrtMemoryAnalyzer memoryAnalyzer,
    int maxSuggestions = 5,
  }) {
    final suggestions = <DsrtOptimizationSuggestion>[];
    final frameAnalysis = frameAnalyzer.analyze();
    final memoryAnalysis = memoryAnalyzer.analyze();
    
    // Analyze frame time issues
    final avgFps = frameAnalysis['averageFps'] as double;
    final consistency = frameAnalysis['consistencyScore'] as double;
    
    if (avgFps < 30.0) {
      suggestions.addAll(getSuggestionsForBottleneck(DsrtBottleneckType.gpu));
      suggestions.addAll(getSuggestionsForBottleneck(DsrtBottleneckType.cpu));
    } else if (avgFps < 60.0) {
      suggestions.addAll(getSuggestionsForBottleneck(DsrtBottleneckType.gpu));
    }
    
    if (consistency < 80.0) {
      suggestions.addAll(getSuggestionsForBottleneck(DsrtBottleneckType.cpu));
    }
    
    // Analyze memory issues
    final memoryTrend = memoryAnalysis['memoryTrendMBps'] as double;
    final leakDetected = memoryAnalysis['leakDetected'] as bool;
    
    if (leakDetected || memoryTrend > 0.5) {
      suggestions.addAll(getSuggestionsForBottleneck(DsrtBottleneckType.memory));
    }
    
    // Remove duplicates and sort by priority
    final uniqueSuggestions = <String, DsrtOptimizationSuggestion>{};
    for (final suggestion in suggestions) {
      if (!_appliedOptimizations.contains(suggestion.id)) {
        uniqueSuggestions[suggestion.id] = suggestion;
      }
    }
    
    return uniqueSuggestions.values
        .toList()
      ..sort((a, b) => b.priorityScore.compareTo(a.priorityScore))
      ..take(maxSuggestions);
  }
  
  /// Gets optimization status
  Map<String, dynamic> get status {
    return {
      'mode': _mode.name,
      'totalSuggestions': _suggestions.length,
      'enabledSuggestions': _suggestions.values.where((s) => s.enabled).length,
      'appliedOptimizations': _appliedOptimizations.length,
      'appliedOptimizationIds': _appliedOptimizations.toList(),
    };
  }
  
  /// Initializes default suggestions
  void _initializeDefaultSuggestions() {
    // GPU optimizations
    addSuggestion(DsrtOptimizationSuggestion(
      id: 'reduce_shadow_quality',
      title: 'Reduce Shadow Quality',
      description: 'Lower shadow map resolution and filtering quality',
      bottleneckType: DsrtBottleneckType.gpu,
      expectedImprovement: 15.0,
      difficulty: 2,
    ));
    
    addSuggestion(DsrtOptimizationSuggestion(
      id: 'disable_ssao',
      title: 'Disable SSAO',
      description: 'Disable screen-space ambient occlusion',
      bottleneckType: DsrtBottleneckType.gpu,
      expectedImprovement: 10.0,
      difficulty: 1,
    ));
    
    addSuggestion(DsrtOptimizationSuggestion(
      id: 'reduce_texture_quality',
      title: 'Reduce Texture Quality',
      description: 'Use lower resolution textures',
      bottleneckType: DsrtBottleneckType.gpu,
      expectedImprovement: 20.0,
      difficulty: 3,
    ));
    
    // CPU optimizations
    addSuggestion(DsrtOptimizationSuggestion(
      id: 'reduce_physics_accuracy',
      title: 'Reduce Physics Accuracy',
      description: 'Lower physics simulation accuracy and frequency',
      bottleneckType: DsrtBottleneckType.cpu,
      expectedImprovement: 25.0,
      difficulty: 4,
    ));
    
    addSuggestion(DsrtOptimizationSuggestion(
      id: 'optimize_ai_updates',
      title: 'Optimize AI Updates',
      description: 'Reduce AI update frequency and complexity',
      bottleneckType: DsrtBottleneckType.cpu,
      expectedImprovement: 15.0,
      difficulty: 5,
    ));
    
    // Memory optimizations
    addSuggestion(DsrtOptimizationSuggestion(
      id: 'enable_asset_streaming',
      title: 'Enable Asset Streaming',
      description: 'Stream assets on demand instead of loading everything at once',
      bottleneckType: DsrtBottleneckType.memory,
      expectedImprovement: 40.0,
      difficulty: 7,
    ));
    
    addSuggestion(DsrtOptimizationSuggestion(
      id: 'reduce_cache_size',
      title: 'Reduce Cache Size',
      description: 'Reduce the size of various internal caches',
      bottleneckType: DsrtBottleneckType.memory,
      expectedImprovement: 20.0,
      difficulty: 3,
    ));
  }
  
  /// Applies mode-specific optimizations
  void _applyModeOptimizations() {
    // Clear previously applied mode-based optimizations
    final modeOptimizations = _appliedOptimizations.where((id) => id.startsWith('mode_')).toList();
    for (final id in modeOptimizations) {
      revertOptimization(id);
    }
    
    // Apply new mode optimizations
    switch (_mode) {
      case DsrtPerformanceMode.maximum:
        _applyOptimization('reduce_shadow_quality');
        _applyOptimization('disable_ssao');
        _applyOptimization('reduce_physics_accuracy');
        break;
      
      case DsrtPerformanceMode.balanced:
        // Balanced mode uses default settings
        break;
      
      case DsrtPerformanceMode.quality:
        // Quality mode might disable some optimizations
        break;
      
      case DsrtPerformanceMode.powerSaving:
        _applyOptimization('reduce_shadow_quality');
        _applyOptimization('disable_ssao');
        _applyOptimization('reduce_texture_quality');
        _applyOptimization('reduce_physics_accuracy');
        _applyOptimization('optimize_ai_updates');
        break;
      
      case DsrtPerformanceMode.custom:
        // Custom mode doesn't apply automatic optimizations
        break;
    }
  }
  
  /// Applies a specific optimization
  void _applySpecificOptimization(DsrtOptimizationSuggestion suggestion) {
    // In a real implementation, this would apply the actual optimization
    // For now, we just log it
    _logger.debug('Applying optimization: ${suggestion.title}');
    
    // Example: Apply optimization based on suggestion ID
    switch (suggestion.id) {
      case 'reduce_shadow_quality':
        // Implementation would adjust shadow settings
        break;
      case 'disable_ssao':
        // Implementation would disable SSAO
        break;
      // ... other optimizations
    }
  }
  
  /// Reverts a specific optimization
  void _revertSpecificOptimization(String suggestionId) {
    // In a real implementation, this would revert the actual optimization
    _logger.debug('Reverting optimization: $suggestionId');
    
    // Example: Revert optimization based on suggestion ID
    switch (suggestionId) {
      case 'reduce_shadow_quality':
        // Implementation would restore shadow settings
        break;
      case 'disable_ssao':
        // Implementation would enable SSAO
        break;
      // ... other optimizations
    }
  }
}

/// Performance utility functions
class DsrtPerformanceUtils {
  /// Measures execution time of a function
  static double measureExecutionTime(void Function() function) {
    final stopwatch = Stopwatch()..start();
    function();
    stopwatch.stop();
    return stopwatch.elapsedMicroseconds / 1000000.0;
  }
  
  /// Measures execution time of an async function
  static Future<double> measureAsyncExecutionTime(Future Function() function) async {
    final stopwatch = Stopwatch()..start();
    await function();
    stopwatch.stop();
    return stopwatch.elapsedMicroseconds / 1000000.0;
  }
  
  /// Benchmarks a function multiple times
  static List<double> benchmark(
    void Function() function, {
    int iterations = 100,
    int warmup = 10,
  }) {
    final results = <double>[];
    
    // Warmup
    for (var i = 0; i < warmup; i++) {
      function();
    }
    
    // Benchmark
    for (var i = 0; i < iterations; i++) {
      final stopwatch = Stopwatch()..start();
      function();
      stopwatch.stop();
      results.add(stopwatch.elapsedMicroseconds / 1000000.0);
    }
    
    return results;
  }
  
  /// Calculates statistics from benchmark results
  static Map<String, double> calculateBenchmarkStats(List<double> results) {
    if (results.isEmpty) {
      return {
        'count': 0.0,
        'min': 0.0,
        'max': 0.0,
        'mean': 0.0,
        'median': 0.0,
        'stddev': 0.0,
        'p95': 0.0,
        'p99': 0.0,
      };
    }
    
    final sorted = List<double>.from(results)..sort();
    final count = results.length.toDouble();
    final min = sorted.first;
    final max = sorted.last;
    
    // Mean
    final mean = results.reduce((a, b) => a + b) / count;
    
    // Median
    final median = count % 2 == 0
        ? (sorted[(count ~/ 2) - 1] + sorted[count ~/ 2]) / 2
        : sorted[count ~/ 2];
    
    // Standard deviation
    double sumSquaredDiff = 0.0;
    for (final value in results) {
      sumSquaredDiff += math.pow(value - mean, 2);
    }
    final stddev = math.sqrt(sumSquaredDiff / count);
    
    // Percentiles
    final p95 = sorted[(count * 0.95).floor()];
    final p99 = sorted[(count * 0.99).floor()];
    
    return {
      'count': count,
      'min': min,
      'max': max,
      'mean': mean,
      'median': median,
      'stddev': stddev,
      'p95': p95,
      'p99': p99,
    };
  }
  
  /// Estimates frame time budget
  static double estimateFrameTimeBudget(double targetFps) {
    return 1.0 / targetFps;
  }
  
  /// Calculates performance score (0-100)
  static double calculatePerformanceScore({
    required double currentFps,
    required double targetFps,
    required double frameTimeConsistency,
  }) {
    // FPS component (0-50 points)
    final fpsRatio = math.min(currentFps / targetFps, 1.0);
    final fpsScore = fpsRatio * 50.0;
    
    // Consistency component (0-50 points)
    final consistencyScore = (frameTimeConsistency / 100.0) * 50.0;
    
    return (fpsScore + consistencyScore).clamp(0.0, 100.0);
  }
  
  /// Detects performance bottleneck
  static DsrtBottleneckType detectBottleneck({
    required double cpuTime,
    required double gpuTime,
    required double frameTime,
    double threshold = 0.7,
  }) {
    final cpuRatio = cpuTime / frameTime;
    final gpuRatio = gpuTime / frameTime;
    
    if (cpuRatio > threshold && gpuRatio > threshold) {
      return DsrtBottleneckType.unknown; // Both are bottlenecks
    } else if (cpuRatio > threshold) {
      return DsrtBottleneckType.cpu;
    } else if (gpuRatio > threshold) {
      return DsrtBottleneckType.gpu;
    } else {
      return DsrtBottleneckType.unknown; // No clear bottleneck
    }
  }
  
  /// Formats performance data for display
  static String formatPerformanceData({
    required double fps,
    required double frameTime,
    required double memoryMB,
    String? additionalInfo,
  }) {
    final buffer = StringBuffer();
    buffer.write('FPS: ${fps.toStringAsFixed(1)}');
    buffer.write(' | Frame: ${(frameTime * 1000).toStringAsFixed(2)}ms');
    buffer.write(' | Memory: ${memoryMB.toStringAsFixed(1)}MB');
    
    if (additionalInfo != null) {
      buffer.write(' | $additionalInfo');
    }
    
    return buffer.toString();
  }
  
  /// Checks if performance meets target requirements
  static Map<String, dynamic> checkPerformanceRequirements({
    required double currentFps,
    required double minRequiredFps,
    required double currentMemoryMB,
    required double maxAllowedMemoryMB,
    required double frameTimeConsistency,
    required double minConsistency,
  }) {
    final meetsFps = currentFps >= minRequiredFps;
    final meetsMemory = currentMemoryMB <= maxAllowedMemoryMB;
    final meetsConsistency = frameTimeConsistency >= minConsistency;
    final allRequirementsMet = meetsFps && meetsMemory && meetsConsistency;
    
    final issues = <String>[];
    if (!meetsFps) {
      issues.add('FPS below requirement ($currentFps < $minRequiredFps)');
    }
    if (!meetsMemory) {
      issues.add('Memory above limit (${currentMemoryMB}MB > ${maxAllowedMemoryMB}MB)');
    }
    if (!meetsConsistency) {
      issues.add('Frame time consistency below minimum ($frameTimeConsistency < $minConsistency)');
    }
    
    return {
      'meetsRequirements': allRequirementsMet,
      'meetsFps': meetsFps,
      'meetsMemory': meetsMemory,
      'meetsConsistency': meetsConsistency,
      'issues': issues,
      'score': calculatePerformanceScore(
        currentFps: currentFps,
        targetFps: minRequiredFps,
        frameTimeConsistency: frameTimeConsistency,
      ),
    };
  }
  
  /// Creates a performance profile for different modes
  static Map<DsrtPerformanceMode, Map<String, dynamic>> createPerformanceProfiles() {
    return {
      DsrtPerformanceMode.maximum: {
        'description': 'Maximum performance, lowest quality',
        'targetFps': 120.0,
        'shadowQuality': 'low',
        'textureQuality': 'low',
        'antialiasing': false,
        'postProcessing': false,
        'physicsQuality': 'low',
      },
      DsrtPerformanceMode.balanced: {
        'description': 'Balanced performance and quality',
        'targetFps': 60.0,
        'shadowQuality': 'medium',
        'textureQuality': 'medium',
        'antialiasing': true,
        'postProcessing': true,
        'physicsQuality': 'medium',
      },
      DsrtPerformanceMode.quality: {
        'description': 'Maximum quality, lower performance',
        'targetFps': 30.0,
        'shadowQuality': 'high',
        'textureQuality': 'high',
        'antialiasing': true,
        'postProcessing': true,
        'physicsQuality': 'high',
      },
      DsrtPerformanceMode.powerSaving: {
        'description': 'Power saving mode',
        'targetFps': 30.0,
        'shadowQuality': 'low',
        'textureQuality': 'low',
        'antialiasing': false,
        'postProcessing': false,
        'physicsQuality': 'low',
        'powerLimit': 0.7,
      },
    };
  }
}
