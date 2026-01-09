/// DSRT Engine - Fixed Time Step Loop
/// Fixed time step implementation for deterministic updates.
library dsrt_engine.src.core.loop.fixed_step;

import 'dart:async';
import 'dart:math' as math;
import '../constants.dart';
import '../../utils/logger.dart';
import '../../utils/disposables.dart';
import '../../core/performance/monitor.dart';
import 'clock.dart';
import 'game_loop.dart';

/// Fixed time step loop with interpolation
class FixedStepLoopDetailed extends BaseGameLoop {
  /// Fixed update accumulator
  double _accumulator = 0.0;
  
  /// Interpolation factor (0.0 to 1.0)
  double _alpha = 0.0;
  
  /// Maximum allowed accumulator (prevents spiral of death)
  final double _maxAccumulator;
  
  /// Maximum updates per frame
  final int _maxUpdatesPerFrame;
  
  /// Fixed update timer
  Timer? _fixedTimer;
  
  /// Frame timer
  Timer? _frameTimer;
  
  /// Update statistics
  int _fixedUpdateCount = 0;
  int _variableUpdateCount = 0;
  int _renderCount = 0;
  
  /// Last fixed update time
  double _lastFixedUpdateTime = 0.0;
  
  /// Interpolation data
  final Map<String, InterpolationData> _interpolationData = {};
  
  /// Create fixed step loop
  FixedStepLoopDetailed({
    required PerformanceMonitor performance,
    required HighResolutionClock clock,
    required void Function(double) updateCallback,
    required void Function(double) fixedUpdateCallback,
    void Function(double)? renderCallback,
    void Function(Object, StackTrace)? errorHandler,
    double targetFPS = 60.0,
    int maxUpdatesPerFrame = 5,
    bool useTimer = true,
  }) : 
    _maxAccumulator = maxUpdatesPerFrame * (1.0 / targetFPS),
    _maxUpdatesPerFrame = maxUpdatesPerFrame,
    super(performance: performance, clock: clock) {
    
    setUpdateCallback(updateCallback);
    setFixedUpdateCallback(fixedUpdateCallback);
    if (renderCallback != null) setRenderCallback(renderCallback);
    if (errorHandler != null) setErrorHandler(errorHandler);
    setFixedTimeStep(1.0 / targetFPS);
    
    logger.debug('Fixed step loop created: ${(1.0 / fixedDeltaTime).toStringAsFixed(1)} FPS');
  }
  
  @override
  void _executeLoop(double deltaTime) {
    // Add to accumulator
    _accumulator += deltaTime;
    
    // Cap accumulator to prevent spiral of death
    if (_accumulator > _maxAccumulator) {
      _accumulator = _maxAccumulator;
      if (_accumulator > fixedDeltaTime * 2) {
        logger.warning('Frame rate critically low, accumulator: ${_accumulator.toStringAsFixed(4)}s');
      }
    }
    
    // Perform fixed updates
    int updatesThisFrame = 0;
    while (_accumulator >= fixedDeltaTime) {
      _executeFixedUpdate();
      _accumulator -= fixedDeltaTime;
      updatesThisFrame++;
      
      if (updatesThisFrame >= _maxUpdatesPerFrame) {
        logger.warning('Max updates per frame reached: $_maxUpdatesPerFrame');
        _accumulator = 0.0;
        break;
      }
    }
    
    // Calculate interpolation factor
    _alpha = _accumulator / fixedDeltaTime;
    
    // Execute variable update with interpolation
    if (_updateCallback != null) {
      _executeVariableUpdate(deltaTime);
    }
    
    // Execute render with interpolation
    if (_renderCallback != null) {
      _executeRender(deltaTime);
    }
    
    // Update statistics
    _fixedUpdateCount += updatesThisFrame;
    _variableUpdateCount++;
    _renderCount++;
  }
  
  /// Execute fixed update
  void _executeFixedUpdate() {
    final startTime = clock.now;
    
    try {
      // Update interpolation data before fixed update
      _captureInterpolationData();
      
      // Execute fixed update
      if (_fixedUpdateCallback != null) {
        _fixedUpdateCallback!(fixedDeltaTime);
      }
      
      // Update last fixed update time
      _lastFixedUpdateTime = clock.now;
      
    } catch (error, stackTrace) {
      _handleError(error, stackTrace);
    }
    
    final updateTime = (clock.now - startTime) * 1000.0; // Convert to ms
    
    // Warn if fixed update takes too long
    if (updateTime > fixedDeltaTime * 1000) {
      logger.warning('Fixed update took ${updateTime.toStringAsFixed(2)}ms '
                    '(> ${(fixedDeltaTime * 1000).toStringAsFixed(2)}ms)');
    }
  }
  
  /// Execute variable update with interpolation
  void _executeVariableUpdate(double deltaTime) {
    try {
      // Apply interpolation to data
      _applyInterpolation(_alpha);
      
      // Execute variable update
      _updateCallback!(deltaTime);
    } catch (error, stackTrace) {
      _handleError(error, stackTrace);
    }
  }
  
  /// Execute render with interpolation
  void _executeRender(double deltaTime) {
    try {
      // Render with current interpolation
      _renderCallback!(deltaTime);
    } catch (error, stackTrace) {
      _handleError(error, stackTrace);
    }
  }
  
  @override
  void _onStart() {
    _resetState();
    
    // Start fixed update timer
    _fixedTimer = Timer.periodic(
      Duration(milliseconds: (fixedDeltaTime * 1000).round()),
      (_) => _fixedUpdate(),
    );
    
    // Start main loop
    _startFrameLoop();
    
    logger.info('Fixed step loop started');
  }
  
  @override
  void _onStop() {
    _fixedTimer?.cancel();
    _fixedTimer = null;
    
    _frameTimer?.cancel();
    _frameTimer = null;
    
    logger.info('Fixed step loop stopped');
  }
  
  @override
  void _onPause() {
    _fixedTimer?.cancel();
    _fixedTimer = null;
    
    _frameTimer?.cancel();
    _frameTimer = null;
    
    logger.info('Fixed step loop paused');
  }
  
  @override
  void _onResume() {
    _fixedTimer = Timer.periodic(
      Duration(milliseconds: (fixedDeltaTime * 1000).round()),
      (_) => _fixedUpdate(),
    );
    
    _startFrameLoop();
    
    logger.info('Fixed step loop resumed');
  }
  
  @override
  void dispose() {
    _fixedTimer?.cancel();
    _frameTimer?.cancel();
    _interpolationData.clear();
    super.dispose();
  }
  
  /// Reset loop state
  void _resetState() {
    _accumulator = 0.0;
    _alpha = 0.0;
    _lastFixedUpdateTime = clock.now;
    _fixedUpdateCount = 0;
    _variableUpdateCount = 0;
    _renderCount = 0;
    _interpolationData.clear();
  }
  
  /// Start frame loop
  void _startFrameLoop() {
    _frameTimer = Timer.periodic(
      Duration(milliseconds: 1), // Run as fast as possible
      (_) {
        if (isRunning && !isPaused) {
          final currentTime = clock.now;
          _loop(currentTime);
        }
      },
    );
  }
  
  /// Fixed update tick (for timer-based updates)
  void _fixedUpdate() {
    if (!isRunning || isPaused) return;
    
    // This is called by the timer, but we handle fixed updates in the main loop
    // This method is kept for compatibility
  }
  
  /// Get current interpolation factor
  double get interpolationFactor => _alpha;
  
  /// Get accumulator value
  double get accumulator => _accumulator;
  
  /// Get fixed update count
  int get fixedUpdateCount => _fixedUpdateCount;
  
  /// Get variable update count
  int get variableUpdateCount => _variableUpdateCount;
  
  /// Get render count
  int get renderCount => _renderCount;
  
  /// Get loop statistics
  FixedStepStats get stats {
    return FixedStepStats(
      fps: fps,
      fixedFPS: 1.0 / fixedDeltaTime,
      deltaTime: deltaTime,
      fixedDeltaTime: fixedDeltaTime,
      accumulator: _accumulator,
      interpolationFactor: _alpha,
      fixedUpdateCount: _fixedUpdateCount,
      variableUpdateCount: _variableUpdateCount,
      renderCount: _renderCount,
      updatesPerFrame: _fixedUpdateCount / math.max(1, _renderCount),
    );
  }
  
  // Interpolation system
  
  /// Register interpolation data
  void registerInterpolationData(String id, InterpolationData data) {
    _interpolationData[id] = data;
  }
  
  /// Unregister interpolation data
  void unregisterInterpolationData(String id) {
    _interpolationData.remove(id);
  }
  
  /// Capture interpolation data before fixed update
  void _captureInterpolationData() {
    for (final data in _interpolationData.values) {
      data.capture();
    }
  }
  
  /// Apply interpolation to data
  void _applyInterpolation(double alpha) {
    for (final data in _interpolationData.values) {
      data.interpolate(alpha);
    }
  }
}

/// Fixed step loop statistics
class FixedStepStats {
  final double fps;
  final double fixedFPS;
  final double deltaTime;
  final double fixedDeltaTime;
  final double accumulator;
  final double interpolationFactor;
  final int fixedUpdateCount;
  final int variableUpdateCount;
  final int renderCount;
  final double updatesPerFrame;
  
  FixedStepStats({
    required this.fps,
    required this.fixedFPS,
    required this.deltaTime,
    required this.fixedDeltaTime,
    required this.accumulator,
    required this.interpolationFactor,
    required this.fixedUpdateCount,
    required this.variableUpdateCount,
    required this.renderCount,
    required this.updatesPerFrame,
  });
  
  /// Convert to map
  Map<String, dynamic> toMap() {
    return {
      'fps': fps,
      'fixedFPS': fixedFPS,
      'deltaTime': deltaTime,
      'fixedDeltaTime': fixedDeltaTime,
      'accumulator': accumulator,
      'interpolationFactor': interpolationFactor,
      'fixedUpdateCount': fixedUpdateCount,
      'variableUpdateCount': variableUpdateCount,
      'renderCount': renderCount,
      'updatesPerFrame': updatesPerFrame,
    };
  }
  
  @override
  String toString() {
    return 'FPS: ${fps.toStringAsFixed(1)} (Fixed: ${fixedFPS.toStringAsFixed(1)}) | '
           'Updates/Frame: ${updatesPerFrame.toStringAsFixed(2)} | '
           'Interpolation: ${(interpolationFactor * 100).toStringAsFixed(1)}%';
  }
}

/// Interpolation data interface
abstract class InterpolationData {
  /// Capture current state
  void capture();
  
  /// Interpolate to target state
  void interpolate(double alpha);
  
  /// Apply interpolated state
  void apply();
}

/// Vector interpolation data
class VectorInterpolationData implements InterpolationData {
  final List<double> _previous = [];
  final List<double> _current = [];
  final List<double> _interpolated = [];
  
  /// Get interpolated vector
  List<double> get interpolated => _interpolated;
  
  @override
  void capture() {
    // Store current as previous
    _previous.clear();
    _previous.addAll(_current);
  }
  
  /// Set current vector
  void setCurrent(List<double> vector) {
    _current.clear();
    _current.addAll(vector);
    
    // Initialize interpolated vector
    if (_interpolated.isEmpty) {
      _interpolated.addAll(vector);
    }
  }
  
  @override
  void interpolate(double alpha) {
    if (_previous.isEmpty || _current.isEmpty) return;
    
    // Linear interpolation
    for (int i = 0; i < _current.length; i++) {
      final prev = i < _previous.length ? _previous[i] : _current[i];
      final curr = _current[i];
      _interpolated[i] = prev + (curr - prev) * alpha;
    }
  }
  
  @override
  void apply() {
    // Implementation depends on usage
  }
}

/// Transform interpolation data
class TransformInterpolationData implements InterpolationData {
  final VectorInterpolationData _position;
  final VectorInterpolationData _rotation;
  final VectorInterpolationData _scale;
  
  TransformInterpolationData()
      : _position = VectorInterpolationData(),
        _rotation = VectorInterpolationData(),
        _scale = VectorInterpolationData();
  
  /// Set current transform
  void setCurrent({
    required List<double> position,
    required List<double> rotation,
    required List<double> scale,
  }) {
    _position.setCurrent(position);
    _rotation.setCurrent(rotation);
    _scale.setCurrent(scale);
  }
  
  @override
  void capture() {
    _position.capture();
    _rotation.capture();
    _scale.capture();
  }
  
  @override
  void interpolate(double alpha) {
    _position.interpolate(alpha);
    _rotation.interpolate(alpha);
    _scale.interpolate(alpha);
  }
  
  @override
  void apply() {
    // Implementation depends on usage
  }
  
  /// Get interpolated position
  List<double> get interpolatedPosition => _position.interpolated;
  
  /// Get interpolated rotation
  List<double> get interpolatedRotation => _rotation.interpolated;
  
  /// Get interpolated scale
  List<double> get interpolatedScale => _scale.interpolated;
}

/// Fixed step loop with adaptive time step
class AdaptiveFixedStepLoop extends FixedStepLoopDetailed {
  /// Target update duration (for adaptation)
  final double _targetUpdateDuration;
  
  /// Adaptation sensitivity
  final double _adaptationSensitivity;
  
  /// Minimum time step
  final double _minTimeStep;
  
  /// Maximum time step
  final double _maxTimeStep;
  
  /// Update duration history
  final List<double> _updateDurations = [];
  static const int _durationHistorySize = 60;
  
  /// Create adaptive fixed step loop
  AdaptiveFixedStepLoop({
    required PerformanceMonitor performance,
    required HighResolutionClock clock,
    required void Function(double) updateCallback,
    required void Function(double) fixedUpdateCallback,
    void Function(double)? renderCallback,
    void Function(Object, StackTrace)? errorHandler,
    double targetFPS = 60.0,
    int maxUpdatesPerFrame = 5,
    double adaptationSensitivity = 0.1,
    double minFPS = 30.0,
    double maxFPS = 120.0,
  }) : 
    _targetUpdateDuration = 1.0 / targetFPS,
    _adaptationSensitivity = adaptationSensitivity,
    _minTimeStep = 1.0 / maxFPS,
    _maxTimeStep = 1.0 / minFPS,
    super(
      performance: performance,
      clock: clock,
      updateCallback: updateCallback,
      fixedUpdateCallback: fixedUpdateCallback,
      renderCallback: renderCallback,
      errorHandler: errorHandler,
      targetFPS: targetFPS,
      maxUpdatesPerFrame: maxUpdatesPerFrame,
    ) {
    
    logger.debug('Adaptive fixed step loop created');
  }
  
  @override
  void _executeFixedUpdate() {
    final startTime = clock.now;
    
    try {
      // Capture interpolation data
      _captureInterpolationData();
      
      // Execute fixed update
      if (_fixedUpdateCallback != null) {
        _fixedUpdateCallback!(fixedDeltaTime);
      }
      
      // Update last fixed update time
      _lastFixedUpdateTime = clock.now;
      
    } catch (error, stackTrace) {
      _handleError(error, stackTrace);
    }
    
    // Measure update duration
    final updateDuration = (clock.now - startTime);
    _updateDurations.add(updateDuration);
    
    // Trim history
    if (_updateDurations.length > _durationHistorySize) {
      _updateDurations.removeAt(0);
    }
    
    // Adapt time step if needed
    _adaptTimeStep();
  }
  
  /// Adapt time step based on performance
  void _adaptTimeStep() {
    if (_updateDurations.length < _durationHistorySize ~/ 2) {
      return; // Not enough data
    }
    
    // Calculate average update duration
    double averageDuration = 0.0;
    for (final duration in _updateDurations) {
      averageDuration += duration;
    }
    averageDuration /= _updateDurations.length;
    
    // Calculate adaptation factor
    final ratio = averageDuration / _targetUpdateDuration;
    final adaptation = 1.0 + (ratio - 1.0) * _adaptationSensitivity;
    
    // Calculate new time step
    double newTimeStep = fixedDeltaTime / adaptation;
    
    // Clamp to valid range
    newTimeStep = newTimeStep.clamp(_minTimeStep, _maxTimeStep);
    
    // Apply adaptation
    if ((newTimeStep - fixedDeltaTime).abs() > 0.0001) {
      final oldFPS = 1.0 / fixedDeltaTime;
      final newFPS = 1.0 / newTimeStep;
      
      setFixedTimeStep(newTimeStep);
      
      logger.debug('Adapted time step: ${oldFPS.toStringAsFixed(1)} FPS -> '
                  '${newFPS.toStringAsFixed(1)} FPS '
                  '(load: ${(averageDuration / fixedDeltaTime * 100).toStringAsFixed(1)}%)');
    }
  }
  
  /// Get adaptation statistics
  AdaptationStats get adaptationStats {
    double averageDuration = 0.0;
    if (_updateDurations.isNotEmpty) {
      for (final duration in _updateDurations) {
        averageDuration += duration;
      }
      averageDuration /= _updateDurations.length;
    }
    
    final load = averageDuration / fixedDeltaTime;
    
    return AdaptationStats(
      currentFPS: 1.0 / fixedDeltaTime,
      targetFPS: 1.0 / _targetUpdateDuration,
      minFPS: 1.0 / _maxTimeStep,
      maxFPS: 1.0 / _minTimeStep,
      updateLoad: load,
      adaptationSensitivity: _adaptationSensitivity,
    );
  }
}

/// Adaptation statistics
class AdaptationStats {
  final double currentFPS;
  final double targetFPS;
  final double minFPS;
  final double maxFPS;
  final double updateLoad;
  final double adaptationSensitivity;
  
  AdaptationStats({
    required this.currentFPS,
    required this.targetFPS,
    required this.minFPS,
    required this.maxFPS,
    required this.updateLoad,
    required this.adaptationSensitivity,
  });
  
  /// Check if adaptation is needed
  bool get needsAdaptation {
    return updateLoad > 1.1 || updateLoad < 0.9;
  }
  
  /// Get load percentage
  double get loadPercentage => updateLoad * 100;
  
  @override
  String toString() {
    return 'FPS: ${currentFPS.toStringAsFixed(1)}/${targetFPS.toStringAsFixed(1)} | '
           'Load: ${loadPercentage.toStringAsFixed(1)}% | '
           'Range: ${minFPS.toStringAsFixed(0)}-${maxFPS.toStringAsFixed(0)} FPS';
  }
}

/// Fixed step loop with priority updates
class PriorityFixedStepLoop extends FixedStepLoopDetailed {
  /// Update priorities
  final Map<String, PriorityUpdate> _priorityUpdates = {};
  
  /// Normal updates
  final List<void Function(double)> _normalUpdates = [];
  
  /// Create priority fixed step loop
  PriorityFixedStepLoop({
    required PerformanceMonitor performance,
    required HighResolutionClock clock,
    required void Function(double) updateCallback,
    required void Function(double) fixedUpdateCallback,
    void Function(double)? renderCallback,
    void Function(Object, StackTrace)? errorHandler,
    double targetFPS = 60.0,
    int maxUpdatesPerFrame = 5,
  }) : super(
      performance: performance,
      clock: clock,
      updateCallback: updateCallback,
      fixedUpdateCallback: fixedUpdateCallback,
      renderCallback: renderCallback,
      errorHandler: errorHandler,
      targetFPS: targetFPS,
      maxUpdatesPerFrame: maxUpdatesPerFrame,
    );
  
  /// Add priority update
  void addPriorityUpdate(
    String id,
    void Function(double) callback, {
    int priority = 0,
    double maxUpdateTime = 0.0, // 0 = unlimited
  }) {
    _priorityUpdates[id] = PriorityUpdate(
      id: id,
      callback: callback,
      priority: priority,
      maxUpdateTime: maxUpdateTime,
    );
  }
  
  /// Remove priority update
  void removePriorityUpdate(String id) {
    _priorityUpdates.remove(id);
  }
  
  /// Add normal update
  void addNormalUpdate(void Function(double) callback) {
    _normalUpdates.add(callback);
  }
  
  /// Remove normal update
  bool removeNormalUpdate(void Function(double) callback) {
    return _normalUpdates.remove(callback);
  }
  
  @override
  void _executeFixedUpdate() {
    final startTime = clock.now;
    
    try {
      // Capture interpolation data
      _captureInterpolationData();
      
      // Execute priority updates (sorted by priority)
      final sortedUpdates = _priorityUpdates.values.toList()
        ..sort((a, b) => b.priority.compareTo(a.priority));
      
      for (final update in sortedUpdates) {
        final updateStart = clock.now;
        
        try {
          update.callback(fixedDeltaTime);
        } catch (error, stackTrace) {
          logger.error('Error in priority update "${update.id}": $error', stackTrace);
        }
        
        // Check if update took too long
        final updateTime = (clock.now - updateStart) * 1000.0;
        if (update.maxUpdateTime > 0 && updateTime > update.maxUpdateTime) {
          logger.warning('Priority update "${update.id}" took '
                        '${updateTime.toStringAsFixed(2)}ms '
                        '(> ${update.maxUpdateTime.toStringAsFixed(2)}ms)');
        }
        
        // Check overall time budget
        if ((clock.now - startTime) > fixedDeltaTime) {
          logger.warning('Fixed update time budget exceeded, '
                        'skipping remaining updates');
          break;
        }
      }
      
      // Execute normal updates
      for (final callback in _normalUpdates) {
        try {
          callback(fixedDeltaTime);
        } catch (error, stackTrace) {
          logger.error('Error in normal update: $error', stackTrace);
        }
        
        // Check overall time budget
        if ((clock.now - startTime) > fixedDeltaTime) {
          logger.warning('Fixed update time budget exceeded, '
                        'skipping remaining updates');
          break;
        }
      }
      
      // Execute main fixed update callback
      if (_fixedUpdateCallback != null) {
        _fixedUpdateCallback!(fixedDeltaTime);
      }
      
      // Update last fixed update time
      _lastFixedUpdateTime = clock.now;
      
    } catch (error, stackTrace) {
      _handleError(error, stackTrace);
    }
  }
}

/// Priority update definition
class PriorityUpdate {
  final String id;
  final void Function(double) callback;
  final int priority; // Higher number = higher priority
  final double maxUpdateTime; // Maximum allowed update time in milliseconds
  
  PriorityUpdate({
    required this.id,
    required this.callback,
    required this.priority,
    required this.maxUpdateTime,
  });
}
