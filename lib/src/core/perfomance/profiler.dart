// lib/src/core/performance/profiler.dart

/// DSRT Engine - Performance Profiler
/// 
/// Provides detailed performance profiling and measurement capabilities
/// for identifying bottlenecks and optimizing engine performance.
/// 
/// @category Core
/// @subcategory Performance
/// @version 1.0.0
/// @license MIT
/// @copyright DSRT Engine Team

library dsrt_engine.core.performance.profiler;

import 'dart:async';
import 'dart:collection';
import 'dart:math' as math;

import '../../utils/logger.dart';

/// Profiler measurement type
enum DsrtProfilerMeasurement {
  /// Time measurement (seconds)
  time,
  
  /// Memory measurement (bytes)
  memory,
  
  /// Count measurement (unitless)
  count,
  
  /// Custom measurement
  custom
}

/// Profiler sample containing measurement data
class DsrtProfilerSample {
  /// Sample name/identifier
  final String name;
  
  /// Measurement type
  final DsrtProfilerMeasurement type;
  
  /// Measurement value
  final double value;
  
  /// Timestamp when sample was taken
  final DateTime timestamp;
  
  /// Additional metadata
  final Map<String, dynamic> metadata;
  
  /// Creates a profiler sample
  DsrtProfilerSample({
    required this.name,
    required this.type,
    required this.value,
    DateTime? timestamp,
    this.metadata = const {},
  }) : timestamp = timestamp ?? DateTime.now();
  
  /// Creates a time sample
  factory DsrtProfilerSample.time(String name, double seconds, {
    Map<String, dynamic> metadata = const {},
  }) {
    return DsrtProfilerSample(
      name: name,
      type: DsrtProfilerMeasurement.time,
      value: seconds,
      metadata: metadata,
    );
  }
  
  /// Creates a memory sample
  factory DsrtProfilerSample.memory(String name, int bytes, {
    Map<String, dynamic> metadata = const {},
  }) {
    return DsrtProfilerSample(
      name: name,
      type: DsrtProfilerMeasurement.memory,
      value: bytes.toDouble(),
      metadata: metadata,
    );
  }
  
  /// Creates a count sample
  factory DsrtProfilerSample.count(String name, int count, {
    Map<String, dynamic> metadata = const {},
  }) {
    return DsrtProfilerSample(
      name: name,
      type: DsrtProfilerMeasurement.count,
      value: count.toDouble(),
      metadata: metadata,
    );
  }
  
  /// Converts to a map
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'type': type.name,
      'value': value,
      'timestamp': timestamp.toIso8601String(),
      'metadata': metadata,
    };
  }
}

/// Profiler scope for hierarchical profiling
class DsrtProfilerScope implements DsrtDisposable {
  /// Scope name
  final String name;
  
  /// Parent scope (if any)
  final DsrtProfilerScope? parent;
  
  /// Child scopes
  final Map<String, DsrtProfilerScope> _children;
  
  /// Samples in this scope
  final List<DsrtProfilerSample> _samples;
  
  /// Start time for current measurement
  final Stopwatch _stopwatch;
  
  /// Memory usage at start
  int _startMemory = 0;
  
  /// Whether this scope is currently active
  bool _isActive = false;
  
  /// Creates a profiler scope
  DsrtProfilerScope(this.name, [this.parent])
      : _children = {},
        _samples = [],
        _stopwatch = Stopwatch();
  
  /// Enters this scope for measurement
  void enter() {
    if (_isActive) {
      throw StateError('Scope "$name" is already active');
    }
    
    _isActive = true;
    _stopwatch.reset();
    _stopwatch.start();
    
    // Record initial memory (if available)
    try {
      // This would use platform-specific memory APIs
      // For now, we'll leave it as a placeholder
      _startMemory = 0;
    } catch (_) {
      _startMemory = 0;
    }
  }
  
  /// Exits this scope and records measurement
  DsrtProfilerSample exit() {
    if (!_isActive) {
      throw StateError('Scope "$name" is not active');
    }
    
    _stopwatch.stop();
    _isActive = false;
    
    final elapsedSeconds = _stopwatch.elapsedMicroseconds / 1000000.0;
    
    // Calculate memory delta (if available)
    int memoryDelta = 0;
    if (_startMemory > 0) {
      try {
        // Get current memory and calculate delta
        // final currentMemory = ...;
        // memoryDelta = currentMemory - _startMemory;
      } catch (_) {
        memoryDelta = 0;
      }
    }
    
    final sample = DsrtProfilerSample.time(
      name,
      elapsedSeconds,
      metadata: {
        'memoryDelta': memoryDelta,
        'thread': 'main',
      },
    );
    
    _samples.add(sample);
    return sample;
  }
  
  /// Creates or gets a child scope
  DsrtProfilerScope child(String childName) {
    if (!_children.containsKey(childName)) {
      _children[childName] = DsrtProfilerScope(childName, this);
    }
    return _children[childName]!;
  }
  
  /// Records a custom sample
  void recordSample(DsrtProfilerSample sample) {
    _samples.add(sample);
  }
  
  /// Gets all samples in this scope
  List<DsrtProfilerSample> get samples => List.unmodifiable(_samples);
  
  /// Gets child scopes
  List<DsrtProfilerScope> get children => _children.values.toList();
  
  /// Gets the total time recorded in this scope
  double get totalTime {
    return _samples
        .where((s) => s.type == DsrtProfilerMeasurement.time)
        .fold(0.0, (sum, sample) => sum + sample.value);
  }
  
  /// Gets the average time per sample
  double get averageTime {
    final timeSamples = _samples
        .where((s) => s.type == DsrtProfilerMeasurement.time)
        .toList();
    return timeSamples.isEmpty ? 0.0 : totalTime / timeSamples.length;
  }
  
  /// Gets the minimum time sample
  double get minTime {
    final timeSamples = _samples
        .where((s) => s.type == DsrtProfilerMeasurement.time)
        .map((s) => s.value);
    return timeSamples.isEmpty ? 0.0 : timeSamples.reduce(math.min);
  }
  
  /// Gets the maximum time sample
  double get maxTime {
    final timeSamples = _samples
        .where((s) => s.type == DsrtProfilerMeasurement.time)
        .map((s) => s.value);
    return timeSamples.isEmpty ? 0.0 : timeSamples.reduce(math.max);
  }
  
  /// Gets the sample count
  int get sampleCount => _samples.length;
  
  /// Clears all samples and children
  void clear() {
    _samples.clear();
    _children.clear();
  }
  
  /// Converts to a hierarchical map
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'totalTime': totalTime,
      'averageTime': averageTime,
      'minTime': minTime,
      'maxTime': maxTime,
      'sampleCount': sampleCount,
      'samples': _samples.map((s) => s.toMap()).toList(),
      'children': _children.values.map((c) => c.toMap()).toList(),
    };
  }
  
  /// Gets a formatted string representation
  String format({int indent = 0}) {
    final buffer = StringBuffer();
    final indentStr = '  ' * indent;
    
    buffer.write('$indentStr$name: ');
    buffer.write('${(totalTime * 1000).toStringAsFixed(2)}ms ');
    buffer.write('(avg: ${(averageTime * 1000).toStringAsFixed(2)}ms, ');
    buffer.write('min: ${(minTime * 1000).toStringAsFixed(2)}ms, ');
    buffer.write('max: ${(maxTime * 1000).toStringAsFixed(2)}ms)');
    buffer.write(' [${sampleCount}x]');
    buffer.writeln();
    
    for (final child in children) {
      buffer.write(child.format(indent: indent + 1));
    }
    
    return buffer.toString();
  }
  
  @override
  Future<void> dispose() async {
    clear();
  }
}

/// Profiler frame data
class DsrtProfilerFrame {
  /// Frame number
  final int frameNumber;
  
  /// Frame start time
  final DateTime startTime;
  
  /// Frame duration in seconds
  final double duration;
  
  /// Frame samples
  final List<DsrtProfilerSample> samples;
  
  /// Creates profiler frame data
  DsrtProfilerFrame({
    required this.frameNumber,
    required this.startTime,
    required this.duration,
    required this.samples,
  });
  
  /// Gets frame samples by type
  List<DsrtProfilerSample> getSamplesByType(DsrtProfilerMeasurement type) {
    return samples.where((s) => s.type == type).toList();
  }
  
  /// Gets frame time samples
  List<DsrtProfilerSample> get timeSamples => getSamplesByType(DsrtProfilerMeasurement.time);
  
  /// Gets frame memory samples
  List<DsrtProfilerSample> get memorySamples => getSamplesByType(DsrtProfilerMeasurement.memory);
  
  /// Gets frame count samples
  List<DsrtProfilerSample> get countSamples => getSamplesByType(DsrtProfilerMeasurement.count);
  
  /// Converts to a map
  Map<String, dynamic> toMap() {
    return {
      'frameNumber': frameNumber,
      'startTime': startTime.toIso8601String(),
      'duration': duration,
      'sampleCount': samples.length,
      'samples': samples.map((s) => s.toMap()).toList(),
    };
  }
}

/// Main performance profiler
class DsrtProfiler implements DsrtDisposable {
  /// Root profiler scope
  final DsrtProfilerScope _rootScope;
  
  /// Current active scope stack
  final List<DsrtProfilerScope> _scopeStack;
  
  /// Recorded frames
  final List<DsrtProfilerFrame> _frames;
  
  /// Maximum number of frames to keep in history
  final int _maxHistoryFrames;
  
  /// Whether profiling is enabled
  bool _enabled = false;
  
  /// Whether profiling is paused
  bool _paused = false;
  
  /// Current frame number
  int _currentFrame = 0;
  
  /// Frame start time
  DateTime? _frameStartTime;
  
  /// Frame samples for current frame
  final List<DsrtProfilerSample> _currentFrameSamples;
  
  /// Profiler logger
  final DsrtLogger _logger;
  
  /// Creates a performance profiler
  DsrtProfiler({
    String rootScopeName = 'root',
    int maxHistoryFrames = 300, // 5 seconds at 60 FPS
    DsrtLogger? logger,
  })  : _rootScope = DsrtProfilerScope(rootScopeName),
        _scopeStack = [],
        _frames = [],
        _maxHistoryFrames = math.max(1, maxHistoryFrames),
        _currentFrameSamples = [],
        _logger = logger ?? DsrtLogger();
  
  /// Enables profiling
  void enable() {
    if (_enabled) return;
    _enabled = true;
    _logger.info('Performance profiler enabled');
  }
  
  /// Disables profiling
  void disable() {
    if (!_enabled) return;
    _enabled = false;
    _logger.info('Performance profiler disabled');
  }
  
  /// Pauses profiling
  void pause() {
    if (!_enabled || _paused) return;
    _paused = true;
    _logger.debug('Performance profiler paused');
  }
  
  /// Resumes profiling
  void resume() {
    if (!_enabled || !_paused) return;
    _paused = true;
    _logger.debug('Performance profiler resumed');
  }
  
  /// Checks if profiling is enabled
  bool get isEnabled => _enabled;
  
  /// Checks if profiling is paused
  bool get isPaused => _paused;
  
  /// Begins a new frame
  void beginFrame() {
    if (!_enabled || _paused) return;
    
    _currentFrame++;
    _frameStartTime = DateTime.now();
    _currentFrameSamples.clear();
    
    // Automatically enter root scope
    _rootScope.enter();
    _scopeStack.add(_rootScope);
  }
  
  /// Ends the current frame
  void endFrame() {
    if (!_enabled || _paused || _frameStartTime == null) return;
    
    // Exit all remaining scopes
    while (_scopeStack.isNotEmpty) {
      endScope();
    }
    
    final frameDuration = DateTime.now().difference(_frameStartTime!).inMicroseconds / 1000000.0;
    
    // Create frame record
    final frame = DsrtProfilerFrame(
      frameNumber: _currentFrame,
      startTime: _frameStartTime!,
      duration: frameDuration,
      samples: List.from(_currentFrameSamples),
    );
    
    _frames.add(frame);
    
    // Trim history if needed
    if (_frames.length > _maxHistoryFrames) {
      _frames.removeAt(0);
    }
    
    _frameStartTime = null;
  }
  
  /// Begins a profiling scope
  DsrtProfilerScope beginScope(String scopeName) {
    if (!_enabled || _paused) {
      return DsrtProfilerScope(scopeName);
    }
    
    final currentScope = _scopeStack.isNotEmpty ? _scopeStack.last : _rootScope;
    final scope = currentScope.child(scopeName);
    
    scope.enter();
    _scopeStack.add(scope);
    
    return scope;
  }
  
  /// Ends the current profiling scope
  DsrtProfilerSample? endScope() {
    if (!_enabled || _paused || _scopeStack.isEmpty) {
      return null;
    }
    
    final scope = _scopeStack.removeLast();
    final sample = scope.exit();
    
    _currentFrameSamples.add(sample);
    return sample;
  }
  
  /// Measures execution of a function
  T measure<T>(String scopeName, T Function() function) {
    final scope = beginScope(scopeName);
    try {
      return function();
    } finally {
      endScope();
    }
  }
  
  /// Measures asynchronous execution of a function
  Future<T> measureAsync<T>(String scopeName, Future<T> Function() function) async {
    final scope = beginScope(scopeName);
    try {
      return await function();
    } finally {
      endScope();
    }
  }
  
  /// Records a custom sample
  void recordSample(DsrtProfilerSample sample) {
    if (!_enabled || _paused) return;
    _currentFrameSamples.add(sample);
  }
  
  /// Records a time sample
  void recordTime(String name, double seconds, {Map<String, dynamic> metadata = const {}}) {
    recordSample(DsrtProfilerSample.time(name, seconds, metadata: metadata));
  }
  
  /// Records a memory sample
  void recordMemory(String name, int bytes, {Map<String, dynamic> metadata = const {}}) {
    recordSample(DsrtProfilerSample.memory(name, bytes, metadata: metadata));
  }
  
  /// Records a count sample
  void recordCount(String name, int count, {Map<String, dynamic> metadata = const {}}) {
    recordSample(DsrtProfilerSample.count(name, count, metadata: metadata));
  }
  
  /// Gets the current frame number
  int get currentFrame => _currentFrame;
  
  /// Gets the root scope
  DsrtProfilerScope get rootScope => _rootScope;
  
  /// Gets all recorded frames
  List<DsrtProfilerFrame> get frames => List.unmodifiable(_frames);
  
  /// Gets the most recent frame
  DsrtProfilerFrame? get lastFrame => _frames.isNotEmpty ? _frames.last : null;
  
  /// Gets frames from the last N seconds
  List<DsrtProfilerFrame> getFramesFromLastSeconds(double seconds) {
    final cutoff = DateTime.now().subtract(Duration(microseconds: (seconds * 1000000).round()));
    return _frames.where((frame) => frame.startTime.isAfter(cutoff)).toList();
  }
  
  /// Gets the average frame time over the last N frames
  double getAverageFrameTime([int frameCount = 60]) {
    final recentFrames = _frames.sublist(math.max(0, _frames.length - frameCount));
    if (recentFrames.isEmpty) return 0.0;
    
    final totalTime = recentFrames.fold(0.0, (sum, frame) => sum + frame.duration);
    return totalTime / recentFrames.length;
  }
  
  /// Gets the average FPS over the last N frames
  double getAverageFps([int frameCount = 60]) {
    final avgFrameTime = getAverageFrameTime(frameCount);
    return avgFrameTime > 0 ? 1.0 / avgFrameTime : 0.0;
  }
  
  /// Gets performance statistics
  Map<String, dynamic> get stats {
    final recentFrames = getFramesFromLastSeconds(1.0);
    final avgFrameTime = getAverageFrameTime();
    final avgFps = getAverageFps();
    
    return {
      'enabled': _enabled,
      'paused': _paused,
      'currentFrame': _currentFrame,
      'totalFrames': _frames.length,
      'recentFrames': recentFrames.length,
      'averageFrameTime': avgFrameTime,
      'averageFps': avgFps,
      'rootScope': _rootScope.toMap(),
    };
  }
  
  /// Gets a formatted report
  String get report {
    final buffer = StringBuffer();
    buffer.writeln('=== DSRT Performance Profiler Report ===');
    buffer.writeln('Status: ${_enabled ? (_paused ? 'Paused' : 'Enabled') : 'Disabled'}');
    buffer.writeln('Frame: $_currentFrame (Total: ${_frames.length})');
    buffer.writeln('Average FPS: ${getAverageFps().toStringAsFixed(1)}');
    buffer.writeln('Average Frame Time: ${(getAverageFrameTime() * 1000).toStringAsFixed(2)}ms');
    buffer.writeln();
    buffer.writeln('Performance Hierarchy:');
    buffer.write(_rootScope.format());
    
    if (_frames.isNotEmpty) {
      buffer.writeln();
      buffer.writeln('Recent Frame Times:');
      final recentFrames = _frames.sublist(math.max(0, _frames.length - 10));
      for (final frame in recentFrames) {
        buffer.writeln('  Frame ${frame.frameNumber}: ${(frame.duration * 1000).toStringAsFixed(2)}ms');
      }
    }
    
    return buffer.toString();
  }
  
  /// Clears all profiling data
  void clear() {
    _rootScope.clear();
    _frames.clear();
    _currentFrameSamples.clear();
    _scopeStack.clear();
    _currentFrame = 0;
    _frameStartTime = null;
  }
  
  /// Exports profiling data
  Map<String, dynamic> export() {
    return {
      'metadata': {
        'exportTime': DateTime.now().toIso8601String(),
        'engine': 'DSRT Engine',
        'version': '1.0.0',
      },
      'stats': stats,
      'frames': _frames.map((f) => f.toMap()).toList(),
      'rootScope': _rootScope.toMap(),
    };
  }
  
  @override
  Future<void> dispose() async {
    clear();
    await _rootScope.dispose();
  }
}

/// Profiler scope helper for using with `using` pattern
class DsrtProfilerScopeHelper {
  final DsrtProfiler _profiler;
  final String _scopeName;
  
  DsrtProfilerScopeHelper(this._profiler, this._scopeName);
  
  void enter() => _profiler.beginScope(_scopeName);
  void exit() => _profiler.endScope();
}

/// Extension for easier profiling
extension DsrtProfilerExtensions on DsrtProfiler {
  /// Creates a scope helper for the given scope name
  DsrtProfilerScopeHelper scope(String scopeName) {
    return DsrtProfilerScopeHelper(this, scopeName);
  }
}

/// Global profiler instance
class DsrtGlobalProfiler {
  static DsrtProfiler? _instance;
  
  static DsrtProfiler get instance {
    return _instance ??= DsrtProfiler();
  }
  
  static void setInstance(DsrtProfiler profiler) {
    _instance = profiler;
  }
  
  static void dispose() {
    _instance?.dispose();
    _instance = null;
  }
}q
