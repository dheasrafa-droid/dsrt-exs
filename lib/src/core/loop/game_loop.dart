/// DSRT Engine - Game Loop System
/// Main game loop implementation for frame-based updates.
library dsrt_engine.src.core.loop.game_loop;

import 'dart:async';
import 'dart:math' as math;
import '../../core/constants.dart';
import '../../utils/logger.dart';
import '../../utils/disposables.dart';
import '../../core/performance/monitor.dart';
import 'clock.dart';

/// Game loop interface
abstract class GameLoop implements Disposable {
  /// Whether the game loop is running
  bool get isRunning;
  
  /// Current frame rate (FPS)
  double get fps;
  
  /// Target frame rate (0 for unlimited)
  double get targetFPS;
  
  /// Delta time for last frame (in seconds)
  double get deltaTime;
  
  /// Fixed time step (for fixed updates)
  double get fixedDeltaTime;
  
  /// Elapsed time since loop started (in seconds)
  double get elapsedTime;
  
  /// Frame count since loop started
  int get frameCount;
  
  /// Start the game loop
  void start();
  
  /// Stop the game loop
  void stop();
  
  /// Pause the game loop
  void pause();
  
  /// Resume the game loop
  void resume();
  
  /// Set the update callback
  void setUpdateCallback(void Function(double) callback);
  
  /// Set the render callback
  void setRenderCallback(void Function(double) callback);
  
  /// Set the fixed update callback
  void setFixedUpdateCallback(void Function(double) callback);
  
  /// Set error handler
  void setErrorHandler(void Function(Object, StackTrace) handler);
}

/// Base game loop implementation
abstract class BaseGameLoop implements GameLoop {
  /// Logger instance
  final Logger logger = Logger('GameLoop');
  
  /// Performance monitor
  final PerformanceMonitor performance;
  
  /// High-resolution clock
  final HighResolutionClock clock;
  
  /// Update callback
  void Function(double deltaTime)? _updateCallback;
  
  /// Render callback
  void Function(double deltaTime)? _renderCallback;
  
  /// Fixed update callback
  void Function(double fixedDeltaTime)? _fixedUpdateCallback;
  
  /// Error handler
  void Function(Object error, StackTrace stackTrace)? _errorHandler;
  
  /// Loop state
  bool _isRunning = false;
  bool _isPaused = false;
  
  /// Timing statistics
  double _fps = 0.0;
  double _deltaTime = 0.0;
  double _fixedDeltaTime = 1.0 / 60.0; // Default 60 FPS
  double _elapsedTime = 0.0;
  int _frameCount = 0;
  
  /// Last frame timestamp
  double _lastFrameTime = 0.0;
  
  /// FPS calculation
  final List<double> _frameTimes = [];
  static const int _fpsSampleCount = 60;
  
  /// Create base game loop
  BaseGameLoop({
    required this.performance,
    required this.clock,
  });
  
  @override
  bool get isRunning => _isRunning;
  
  @override
  bool get isPaused => _isPaused;
  
  @override
  double get fps => _fps;
  
  @override
  double get targetFPS => 1.0 / _fixedDeltaTime;
  
  @override
  double get deltaTime => _deltaTime;
  
  @override
  double get fixedDeltaTime => _fixedDeltaTime;
  
  @override
  double get elapsedTime => _elapsedTime;
  
  @override
  int get frameCount => _frameCount;
  
  @override
  void setUpdateCallback(void Function(double) callback) {
    _updateCallback = callback;
  }
  
  @override
  void setRenderCallback(void Function(double) callback) {
    _renderCallback = callback;
  }
  
  @override
  void setFixedUpdateCallback(void Function(double) callback) {
    _fixedUpdateCallback = callback;
  }
  
  @override
  void setErrorHandler(void Function(Object, StackTrace) handler) {
    _errorHandler = handler;
  }
  
  @override
  void start() {
    if (_isRunning) return;
    
    _isRunning = true;
    _isPaused = false;
    _lastFrameTime = clock.now;
    
    logger.info('Game loop started');
    _onStart();
  }
  
  @override
  void stop() {
    if (!_isRunning) return;
    
    _isRunning = false;
    _isPaused = false;
    
    logger.info('Game loop stopped');
    _onStop();
  }
  
  @override
  void pause() {
    if (!_isRunning || _isPaused) return;
    
    _isPaused = true;
    logger.info('Game loop paused');
    _onPause();
  }
  
  @override
  void resume() {
    if (!_isRunning || !_isPaused) return;
    
    _isPaused = false;
    _lastFrameTime = clock.now;
    
    logger.info('Game loop resumed');
    _onResume();
  }
  
  @override
  void dispose() {
    stop();
    logger.debug('Game loop disposed');
  }
  
  /// Set fixed time step
  void setFixedTimeStep(double fixedDeltaTime) {
    if (fixedDeltaTime <= 0) {
      throw ArgumentError('Fixed delta time must be positive');
    }
    _fixedDeltaTime = fixedDeltaTime;
  }
  
  /// Set target FPS
  void setTargetFPS(double targetFPS) {
    if (targetFPS <= 0) {
      throw ArgumentError('Target FPS must be positive');
    }
    _fixedDeltaTime = 1.0 / targetFPS;
  }
  
  /// Main loop iteration
  void _loop(double currentTime) {
    if (!_isRunning || _isPaused) return;
    
    try {
      performance.beginFrame();
      
      // Calculate delta time
      _deltaTime = currentTime - _lastFrameTime;
      _lastFrameTime = currentTime;
      
      // Clamp delta time to prevent spiral of death
      _deltaTime = math.min(_deltaTime, DSRTConstants.maxDeltaTime);
      
      // Update elapsed time
      _elapsedTime += _deltaTime;
      
      // Update frame count
      _frameCount++;
      
      // Calculate FPS
      _updateFPS(_deltaTime);
      
      // Execute loop logic
      _executeLoop(_deltaTime);
      
      performance.endFrame();
    } catch (error, stackTrace) {
      _handleError(error, stackTrace);
    }
  }
  
  /// Update FPS calculation
  void _updateFPS(double deltaTime) {
    _frameTimes.add(deltaTime);
    if (_frameTimes.length > _fpsSampleCount) {
      _frameTimes.removeAt(0);
    }
    
    if (_frameTimes.isNotEmpty) {
      final averageDelta = _frameTimes.reduce((a, b) => a + b) / _frameTimes.length;
      _fps = averageDelta > 0 ? 1.0 / averageDelta : 0.0;
    }
  }
  
  /// Execute loop logic (to be implemented by subclasses)
  void _executeLoop(double deltaTime);
  
  /// Handle loop error
  void _handleError(Object error, StackTrace stackTrace) {
    logger.error('Game loop error: $error', stackTrace);
    
    if (_errorHandler != null) {
      _errorHandler!(error, stackTrace);
    }
  }
  
  /// Called when loop starts
  void _onStart();
  
  /// Called when loop stops
  void _onStop();
  
  /// Called when loop pauses
  void _onPause();
  
  /// Called when loop resumes
  void _onResume();
}

/// Variable time step game loop
/// Updates as fast as possible, using actual delta time
class VariableStepLoop extends BaseGameLoop {
  /// Animation frame ID (for web)
  int? _animationFrameId;
  
  /// Request animation frame function (platform-specific)
  final Future<void> Function(void Function(double)) _requestAnimationFrame;
  
  /// Cancel animation frame function (platform-specific)
  final void Function(int) _cancelAnimationFrame;
  
  /// Create variable step loop
  VariableStepLoop({
    required PerformanceMonitor performance,
    required HighResolutionClock clock,
    required void Function(double) updateCallback,
    void Function(double)? renderCallback,
    void Function(double)? fixedUpdateCallback,
    void Function(Object, StackTrace)? errorHandler,
    double targetFPS = 0, // 0 means unlimited
  }) : 
    _requestAnimationFrame = _getRequestAnimationFrame(),
    _cancelAnimationFrame = _getCancelAnimationFrame(),
    super(performance: performance, clock: clock) {
    
    setUpdateCallback(updateCallback);
    if (renderCallback != null) setRenderCallback(renderCallback);
    if (fixedUpdateCallback != null) setFixedUpdateCallback(fixedUpdateCallback);
    if (errorHandler != null) setErrorHandler(errorHandler);
    if (targetFPS > 0) setTargetFPS(targetFPS);
  }
  
  @override
  void _executeLoop(double deltaTime) {
    // Variable update
    if (_updateCallback != null) {
      _updateCallback!(deltaTime);
    }
    
    // Fixed update (if requested)
    if (_fixedUpdateCallback != null) {
      _fixedUpdateCallback!(fixedDeltaTime);
    }
    
    // Render
    if (_renderCallback != null) {
      _renderCallback!(deltaTime);
    }
    
    // Schedule next frame
    _scheduleNextFrame();
  }
  
  @override
  void _onStart() {
    _scheduleNextFrame();
  }
  
  @override
  void _onStop() {
    if (_animationFrameId != null) {
      _cancelAnimationFrame(_animationFrameId!);
      _animationFrameId = null;
    }
  }
  
  @override
  void _onPause() {
    if (_animationFrameId != null) {
      _cancelAnimationFrame(_animationFrameId!);
      _animationFrameId = null;
    }
  }
  
  @override
  void _onResume() {
    _scheduleNextFrame();
  }
  
  /// Schedule next animation frame
  void _scheduleNextFrame() {
    if (!isRunning || isPaused) return;
    
    _requestAnimationFrame((timestamp) {
      if (isRunning && !isPaused) {
        _loop(timestamp / 1000.0); // Convert ms to seconds
      }
    }).then((id) {
      _animationFrameId = id;
    });
  }
  
  /// Get platform-specific requestAnimationFrame
  static Future<void> Function(void Function(double)) _getRequestAnimationFrame() {
    // This is a simplified version
    // In real implementation, this would handle both web and native
    return (callback) async {
      // Web implementation
      if (_isWeb()) {
        // Use browser's requestAnimationFrame
        // In real code, this would use dart:js interop
        Future.delayed(Duration(milliseconds: 16), () => callback(performance.now()));
        return 0;
      } else {
        // Native implementation
        final completer = Completer<void>();
        Timer(const Duration(milliseconds: 16), () {
          callback(DateTime.now().millisecondsSinceEpoch / 1000.0);
          completer.complete();
        });
        return completer.future.then((_) => 0);
      }
    };
  }
  
  /// Get platform-specific cancelAnimationFrame
  static void Function(int) _getCancelAnimationFrame() {
    return (id) {
      // Implementation depends on platform
    };
  }
  
  /// Check if running on web
  static bool _isWeb() {
    return identical(0, 0.0); // Simple check for web platform
  }
}

/// Fixed time step game loop
/// Updates at fixed intervals, independent of frame rate
class FixedStepLoop extends BaseGameLoop {
  /// Accumulated time since last update
  double _accumulator = 0.0;
  
  /// Maximum updates per frame (to prevent spiral of death)
  final int maxUpdatesPerFrame;
  
  /// Timer for fixed updates
  Timer? _fixedTimer;
  
  /// Target update interval in milliseconds
  int get _updateInterval => (fixedDeltaTime * 1000).round();
  
  /// Create fixed step loop
  FixedStepLoop({
    required PerformanceMonitor performance,
    required HighResolutionClock clock,
    required void Function(double) updateCallback,
    void Function(double)? renderCallback,
    required void Function(double) fixedUpdateCallback,
    void Function(Object, StackTrace)? errorHandler,
    double targetFPS = 60.0,
    this.maxUpdatesPerFrame = 5,
  }) : super(performance: performance, clock: clock) {
    
    setUpdateCallback(updateCallback);
    if (renderCallback != null) setRenderCallback(renderCallback);
    setFixedUpdateCallback(fixedUpdateCallback);
    if (errorHandler != null) setErrorHandler(errorHandler);
    setTargetFPS(targetFPS);
  }
  
  @override
  void _executeLoop(double deltaTime) {
    // Add to accumulator
    _accumulator += deltaTime;
    
    // Cap accumulator to prevent spiral of death
    final maxAccumulator = maxUpdatesPerFrame * fixedDeltaTime;
    if (_accumulator > maxAccumulator) {
      _accumulator = maxAccumulator;
      logger.warning('Frame rate too low, skipping updates');
    }
    
    // Perform fixed updates
    int updateCount = 0;
    while (_accumulator >= fixedDeltaTime) {
      // Fixed update
      if (_fixedUpdateCallback != null) {
        _fixedUpdateCallback!(fixedDeltaTime);
      }
      
      _accumulator -= fixedDeltaTime;
      updateCount++;
      
      // Safety check
      if (updateCount >= maxUpdatesPerFrame * 2) {
        logger.error('Infinite loop detected in fixed updates');
        break;
      }
    }
    
    // Variable update (interpolation)
    if (_updateCallback != null) {
      final alpha = _accumulator / fixedDeltaTime;
      _updateCallback!(deltaTime);
    }
    
    // Render
    if (_renderCallback != null) {
      _renderCallback!(deltaTime);
    }
  }
  
  @override
  void _onStart() {
    // Start fixed update timer
    _fixedTimer = Timer.periodic(
      Duration(milliseconds: _updateInterval),
      (_) => _fixedUpdate(),
    );
    
    // Start main loop
    _scheduleNextFrame();
  }
  
  @override
  void _onStop() {
    _fixedTimer?.cancel();
    _fixedTimer = null;
  }
  
  @override
  void _onPause() {
    _fixedTimer?.cancel();
    _fixedTimer = null;
  }
  
  @override
  void _onResume() {
    _fixedTimer = Timer.periodic(
      Duration(milliseconds: _updateInterval),
      (_) => _fixedUpdate(),
    );
    _scheduleNextFrame();
  }
  
  @override
  void dispose() {
    _fixedTimer?.cancel();
    super.dispose();
  }
  
  /// Fixed update tick
  void _fixedUpdate() {
    if (!isRunning || isPaused) return;
    
    try {
      if (_fixedUpdateCallback != null) {
        _fixedUpdateCallback!(fixedDeltaTime);
      }
    } catch (error, stackTrace) {
      _handleError(error, stackTrace);
    }
  }
  
  /// Schedule next frame
  void _scheduleNextFrame() {
    if (!isRunning || isPaused) return;
    
    Future.delayed(Duration.zero, () {
      if (isRunning && !isPaused) {
        _loop(clock.now);
        _scheduleNextFrame();
      }
    });
  }
}

/// Adaptive game loop
/// Switches between fixed and variable steps based on performance
class AdaptiveGameLoop extends BaseGameLoop {
  /// Current loop mode
  LoopMode _mode = LoopMode.variable;
  
  /// Performance thresholds
  final double lowFpsThreshold = 30.0;
  final double highFpsThreshold = 55.0;
  
  /// Mode change cooldown
  double _modeChangeCooldown = 0.0;
  static const double _modeChangeDelay = 1.0; // seconds
  
  /// Fixed step loop (for when FPS is low)
  final FixedStepLoop _fixedLoop;
  
  /// Variable step loop (for when FPS is high)
  final VariableStepLoop _variableLoop;
  
  /// Current active loop
  GameLoop get _activeLoop => _mode == LoopMode.fixed ? _fixedLoop : _variableLoop;
  
  /// Create adaptive game loop
  AdaptiveGameLoop({
    required PerformanceMonitor performance,
    required HighResolutionClock clock,
    required void Function(double) updateCallback,
    void Function(double)? renderCallback,
    void Function(double)? fixedUpdateCallback,
    void Function(Object, StackTrace)? errorHandler,
    double targetFPS = 60.0,
    int maxUpdatesPerFrame = 5,
  }) : 
    _fixedLoop = FixedStepLoop(
      performance: performance,
      clock: clock,
      updateCallback: updateCallback,
      renderCallback: renderCallback,
      fixedUpdateCallback: fixedUpdateCallback ?? updateCallback,
      errorHandler: errorHandler,
      targetFPS: targetFPS,
      maxUpdatesPerFrame: maxUpdatesPerFrame,
    ),
    _variableLoop = VariableStepLoop(
      performance: performance,
      clock: clock,
      updateCallback: updateCallback,
      renderCallback: renderCallback,
      fixedUpdateCallback: fixedUpdateCallback,
      errorHandler: errorHandler,
      targetFPS: targetFPS,
    ),
    super(performance: performance, clock: clock) {
    
    setUpdateCallback(updateCallback);
    if (renderCallback != null) setRenderCallback(renderCallback);
    if (fixedUpdateCallback != null) setFixedUpdateCallback(fixedUpdateCallback);
    if (errorHandler != null) setErrorHandler(errorHandler);
  }
  
  @override
  bool get isRunning => _activeLoop.isRunning;
  
  @override
  double get fps => _activeLoop.fps;
  
  @override
  double get deltaTime => _activeLoop.deltaTime;
  
  @override
  double get fixedDeltaTime => _fixedLoop.fixedDeltaTime;
  
  @override
  double get elapsedTime => _activeLoop.elapsedTime;
  
  @override
  int get frameCount => _activeLoop.frameCount;
  
  @override
  void start() {
    // Start with variable step
    _mode = LoopMode.variable;
    _variableLoop.start();
    
    logger.info('Adaptive game loop started (mode: ${_mode.name})');
  }
  
  @override
  void stop() {
    _fixedLoop.stop();
    _variableLoop.stop();
    
    logger.info('Adaptive game loop stopped');
  }
  
  @override
  void pause() {
    _activeLoop.pause();
    logger.info('Adaptive game loop paused');
  }
  
  @override
  void resume() {
    _activeLoop.resume();
    logger.info('Adaptive game loop resumed');
  }
  
  @override
  void setUpdateCallback(void Function(double) callback) {
    super.setUpdateCallback(callback);
    _fixedLoop.setUpdateCallback(callback);
    _variableLoop.setUpdateCallback(callback);
  }
  
  @override
  void setRenderCallback(void Function(double) callback) {
    super.setRenderCallback(callback);
    _fixedLoop.setRenderCallback(callback);
    _variableLoop.setRenderCallback(callback);
  }
  
  @override
  void setFixedUpdateCallback(void Function(double) callback) {
    super.setFixedUpdateCallback(callback);
    _fixedLoop.setFixedUpdateCallback(callback);
    _variableLoop.setFixedUpdateCallback(callback);
  }
  
  @override
  void setErrorHandler(void Function(Object, StackTrace) handler) {
    super.setErrorHandler(handler);
    _fixedLoop.setErrorHandler(handler);
    _variableLoop.setErrorHandler(handler);
  }
  
  @override
  void _executeLoop(double deltaTime) {
    // Update mode based on performance
    _updateMode(deltaTime);
    
    // Delegate to active loop
    // Note: The actual loop execution is handled by the sub-loops
  }
  
  @override
  void _onStart() {
    // Handled by start()
  }
  
  @override
  void _onStop() {
    // Handled by stop()
  }
  
  @override
  void _onPause() {
    // Handled by pause()
  }
  
  @override
  void _onResume() {
    // Handled by resume()
  }
  
  @override
  void dispose() {
    _fixedLoop.dispose();
    _variableLoop.dispose();
    super.dispose();
  }
  
  /// Update loop mode based on performance
  void _updateMode(double deltaTime) {
    if (_modeChangeCooldown > 0) {
      _modeChangeCooldown -= deltaTime;
      return;
    }
    
    final currentFps = _activeLoop.fps;
    
    if (_mode == LoopMode.variable && currentFps < lowFpsThreshold) {
      // Switch to fixed step mode
      _switchToFixedMode();
    } else if (_mode == LoopMode.fixed && currentFps > highFpsThreshold) {
      // Switch to variable step mode
      _switchToVariableMode();
    }
  }
  
  /// Switch to fixed step mode
  void _switchToFixedMode() {
    if (_mode == LoopMode.fixed) return;
    
    logger.info('Switching to fixed step mode (FPS: ${_variableLoop.fps.toStringAsFixed(1)})');
    
    // Capture current state
    final wasRunning = _variableLoop.isRunning;
    final wasPaused = !_variableLoop.isRunning || _variableLoop is BaseGameLoop && (_variableLoop as BaseGameLoop).isPaused;
    
    // Stop variable loop
    _variableLoop.stop();
    
    // Start fixed loop with same state
    if (wasRunning && !wasPaused) {
      _fixedLoop.start();
    } else if (wasRunning && wasPaused) {
      _fixedLoop.start();
      _fixedLoop.pause();
    }
    
    _mode = LoopMode.fixed;
    _modeChangeCooldown = _modeChangeDelay;
  }
  
  /// Switch to variable step mode
  void _switchToVariableMode() {
    if (_mode == LoopMode.variable) return;
    
    logger.info('Switching to variable step mode (FPS: ${_fixedLoop.fps.toStringAsFixed(1)})');
    
    // Capture current state
    final wasRunning = _fixedLoop.isRunning;
    final wasPaused = !_fixedLoop.isRunning || _fixedLoop is BaseGameLoop && (_fixedLoop as BaseGameLoop).isPaused;
    
    // Stop fixed loop
    _fixedLoop.stop();
    
    // Start variable loop with same state
    if (wasRunning && !wasPaused) {
      _variableLoop.start();
    } else if (wasRunning && wasPaused) {
      _variableLoop.start();
      _variableLoop.pause();
    }
    
    _mode = LoopMode.variable;
    _modeChangeCooldown = _modeChangeDelay;
  }
  
  /// Get current loop mode
  LoopMode get mode => _mode;
  
  /// Set loop mode manually
  void setMode(LoopMode mode) {
    if (_mode == mode) return;
    
    if (mode == LoopMode.fixed) {
      _switchToFixedMode();
    } else {
      _switchToVariableMode();
    }
  }
}

/// Loop modes
enum LoopMode {
  fixed,
  variable,
  
  String get name {
    switch (this) {
      case LoopMode.fixed:
        return 'Fixed';
      case LoopMode.variable:
        return 'Variable';
    }
  }
}

/// Loop statistics
class LoopStats {
  final double fps;
  final double deltaTime;
  final double fixedDeltaTime;
  final double elapsedTime;
  final int frameCount;
  final LoopMode mode;
  final double frameTime; // in milliseconds
  final double updateTime; // in milliseconds
  final double renderTime; // in milliseconds
  
  LoopStats({
    required this.fps,
    required this.deltaTime,
    required this.fixedDeltaTime,
    required this.elapsedTime,
    required this.frameCount,
    required this.mode,
    required this.frameTime,
    required this.updateTime,
    required this.renderTime,
  });
  
  /// Convert to map
  Map<String, dynamic> toMap() {
    return {
      'fps': fps,
      'deltaTime': deltaTime,
      'fixedDeltaTime': fixedDeltaTime,
      'elapsedTime': elapsedTime,
      'frameCount': frameCount,
      'mode': mode.name,
      'frameTime': frameTime,
      'updateTime': updateTime,
      'renderTime': renderTime,
    };
  }
  
  @override
  String toString() {
    return 'FPS: ${fps.toStringAsFixed(1)}, '
           'Frame: ${frameTime.toStringAsFixed(2)}ms, '
           'Update: ${updateTime.toStringAsFixed(2)}ms, '
           'Render: ${renderTime.toStringAsFixed(2)}ms';
  }
}
