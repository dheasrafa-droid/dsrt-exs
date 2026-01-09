/// DSRT Engine - High Resolution Clock
/// High precision timing utilities for game loops.
library dsrt_engine.src.core.loop.clock;

import 'dart:async';
import 'dart:math' as math;

/// High resolution clock for precise timing
abstract class HighResolutionClock {
  /// Get current time in seconds with high precision
  double get now;
  
  /// Initialize the clock
  Future<void> initialize();
  
  /// Dispose clock resources
  void dispose();
}

/// System clock implementation using DateTime
class SystemClock implements HighResolutionClock {
  /// Start time reference
  double _startTime = 0.0;
  
  /// Performance reference (for browsers)
  double? _performanceReference;
  
  /// Check if performance API is available
  bool get _hasPerformance => _isWeb() && _checkPerformanceAPI();
  
  @override
  double get now {
    if (_hasPerformance && _performanceReference != null) {
      // Use performance.now() for web
      return _getPerformanceTime() - _performanceReference!;
    } else {
      // Use DateTime for native
      return (DateTime.now().microsecondsSinceEpoch - _startTime) / 1000000.0;
    }
  }
  
  @override
  Future<void> initialize() async {
    if (_hasPerformance) {
      _performanceReference = _getPerformanceTime();
      _startTime = 0.0;
    } else {
      _startTime = DateTime.now().microsecondsSinceEpoch.toDouble();
    }
  }
  
  @override
  void dispose() {
    // Nothing to dispose
  }
  
  /// Get performance time in seconds
  double _getPerformanceTime() {
    // This would use dart:js interop in real implementation
    // For now, return DateTime-based time
    return DateTime.now().microsecondsSinceEpoch / 1000000.0;
  }
  
  /// Check if running on web
  static bool _isWeb() {
    return identical(0, 0.0);
  }
  
  /// Check if performance API is available
  static bool _checkPerformanceAPI() {
    // Simplified check
    return _isWeb();
  }
}

/// Manual clock for testing and simulation
class ManualClock implements HighResolutionClock {
  double _currentTime = 0.0;
  double _timeScale = 1.0;
  bool _isPaused = false;
  
  @override
  double get now => _currentTime;
  
  /// Get time scale
  double get timeScale => _timeScale;
  
  /// Set time scale (1.0 = normal, 2.0 = double speed, 0.5 = half speed)
  set timeScale(double scale) {
    _timeScale = math.max(0.0, scale);
  }
  
  /// Check if clock is paused
  bool get isPaused => _isPaused;
  
  @override
  Future<void> initialize() async {
    _currentTime = 0.0;
    _timeScale = 1.0;
    _isPaused = false;
  }
  
  @override
  void dispose() {
    // Nothing to dispose
  }
  
  /// Advance time by delta seconds
  void advance(double deltaSeconds) {
    if (!_isPaused) {
      _currentTime += deltaSeconds * _timeScale;
    }
  }
  
  /// Pause the clock
  void pause() {
    _isPaused = true;
  }
  
  /// Resume the clock
  void resume() {
    _isPaused = false;
  }
  
  /// Reset the clock to zero
  void reset() {
    _currentTime = 0.0;
  }
  
  /// Set current time
  void setTime(double seconds) {
    _currentTime = seconds;
  }
}

/// Scaled clock for time manipulation
class ScaledClock implements HighResolutionClock {
  final HighResolutionClock _sourceClock;
  double _timeScale = 1.0;
  double _offset = 0.0;
  double? _pauseTime;
  
  /// Create scaled clock with source clock
  ScaledClock(this._sourceClock);
  
  @override
  double get now {
    final sourceTime = _sourceClock.now;
    
    if (_pauseTime != null) {
      return _pauseTime!;
    }
    
    return (sourceTime * _timeScale) + _offset;
  }
  
  /// Get time scale
  double get timeScale => _timeScale;
  
  /// Set time scale
  set timeScale(double scale) {
    if (_pauseTime != null) {
      // Adjust pause time when changing scale while paused
      final current = now;
      _timeScale = scale;
      _pauseTime = current;
    } else {
      // Update offset to maintain continuity
      final currentSourceTime = _sourceClock.now;
      final currentScaledTime = now;
      _timeScale = scale;
      _offset = currentScaledTime - (currentSourceTime * _timeScale);
    }
  }
  
  /// Check if clock is paused
  bool get isPaused => _pauseTime != null;
  
  @override
  Future<void> initialize() async {
    await _sourceClock.initialize();
    _timeScale = 1.0;
    _offset = 0.0;
    _pauseTime = null;
  }
  
  @override
  void dispose() {
    _sourceClock.dispose();
  }
  
  /// Pause the clock
  void pause() {
    if (_pauseTime == null) {
      _pauseTime = now;
    }
  }
  
  /// Resume the clock
  void resume() {
    if (_pauseTime != null) {
      // Adjust offset to account for paused time
      final pausedDuration = _sourceClock.now * _timeScale - _pauseTime!;
      _offset -= pausedDuration;
      _pauseTime = null;
    }
  }
  
  /// Reset the clock to source time
  void reset() {
    _timeScale = 1.0;
    _offset = 0.0;
    _pauseTime = null;
  }
  
  /// Set time scale instantly (without continuity)
  void setTimeScale(double scale) {
    _timeScale = math.max(0.0, scale);
    if (_pauseTime != null) {
      _pauseTime = now;
    }
  }
  
  /// Get unscaled time from source clock
  double get unscaledTime => _sourceClock.now;
  
  /// Get elapsed time since clock started
  double get elapsedTime => now;
}

/// Stopwatch with high precision
class HighResolutionStopwatch {
  final HighResolutionClock _clock;
  double _startTime = 0.0;
  double _elapsed = 0.0;
  bool _isRunning = false;
  
  /// Create stopwatch with clock
  HighResolutionStopwatch(HighResolutionClock clock) : _clock = clock;
  
  /// Get elapsed time in seconds
  double get elapsed {
    if (_isRunning) {
      return _elapsed + (_clock.now - _startTime);
    } else {
      return _elapsed;
    }
  }
  
  /// Check if stopwatch is running
  bool get isRunning => _isRunning;
  
  /// Start the stopwatch
  void start() {
    if (!_isRunning) {
      _startTime = _clock.now;
      _isRunning = true;
    }
  }
  
  /// Stop the stopwatch
  void stop() {
    if (_isRunning) {
      _elapsed += _clock.now - _startTime;
      _isRunning = false;
    }
  }
  
  /// Reset the stopwatch
  void reset() {
    _elapsed = 0.0;
    _isRunning = false;
  }
  
  /// Restart the stopwatch
  void restart() {
    reset();
    start();
  }
  
  /// Split time (get elapsed without stopping)
  double split() {
    return elapsed;
  }
  
  /// Lap time (get elapsed and restart)
  double lap() {
    final lapTime = elapsed;
    restart();
    return lapTime;
  }
  
  /// Convert to string with formatted time
  @override
  String toString() {
    final seconds = elapsed;
    
    if (seconds < 1.0) {
      return '${(seconds * 1000).toStringAsFixed(1)}ms';
    } else if (seconds < 60.0) {
      return '${seconds.toStringAsFixed(2)}s';
    } else {
      final minutes = seconds / 60.0;
      return '${minutes.toStringAsFixed(1)}m';
    }
  }
}

/// Timer with high precision
class HighResolutionTimer {
  final HighResolutionClock _clock;
  final double _duration;
  double _startTime = 0.0;
  bool _isRunning = false;
  bool _isCompleted = false;
  
  /// Completion callback
  void Function()? onComplete;
  
  /// Create timer with duration in seconds
  HighResolutionTimer(this._clock, this._duration);
  
  /// Get remaining time in seconds
  double get remaining {
    if (!_isRunning || _isCompleted) {
      return 0.0;
    }
    
    final elapsed = _clock.now - _startTime;
    final remaining = _duration - elapsed;
    
    return math.max(0.0, remaining);
  }
  
  /// Get elapsed time in seconds
  double get elapsed {
    if (!_isRunning) {
      return 0.0;
    }
    
    return _clock.now - _startTime;
  }
  
  /// Get progress (0.0 to 1.0)
  double get progress {
    if (!_isRunning || _duration == 0.0) {
      return _isCompleted ? 1.0 : 0.0;
    }
    
    final elapsed = _clock.now - _startTime;
    final progress = elapsed / _duration;
    
    return math.min(1.0, math.max(0.0, progress));
  }
  
  /// Check if timer is running
  bool get isRunning => _isRunning;
  
  /// Check if timer is completed
  bool get isCompleted => _isCompleted;
  
  /// Start the timer
  void start() {
    _startTime = _clock.now;
    _isRunning = true;
    _isCompleted = false;
  }
  
  /// Stop the timer
  void stop() {
    _isRunning = false;
  }
  
  /// Reset the timer
  void reset() {
    _isRunning = false;
    _isCompleted = false;
  }
  
  /// Restart the timer
  void restart() {
    reset();
    start();
  }
  
  /// Update the timer (should be called each frame)
  void update() {
    if (!_isRunning || _isCompleted) {
      return;
    }
    
    if (progress >= 1.0) {
      _isCompleted = true;
      _isRunning = false;
      
      if (onComplete != null) {
        onComplete!();
      }
    }
  }
  
  /// Check if timer has expired
  bool get hasExpired => progress >= 1.0;
}

/// Time utility functions
class TimeUtils {
  /// Format seconds to human-readable string
  static String formatSeconds(double seconds, {bool showMilliseconds = false}) {
    if (seconds < 1.0 && showMilliseconds) {
      return '${(seconds * 1000).toStringAsFixed(0)}ms';
    } else if (seconds < 60.0) {
      return '${seconds.toStringAsFixed(showMilliseconds ? 2 : 0)}s';
    } else if (seconds < 3600.0) {
      final minutes = seconds / 60.0;
      final remainingSeconds = seconds % 60.0;
      return '${minutes.floor()}m ${remainingSeconds.toStringAsFixed(0)}s';
    } else {
      final hours = seconds / 3600.0;
      final remainingMinutes = (seconds % 3600.0) / 60.0;
      return '${hours.floor()}h ${remainingMinutes.floor()}m';
    }
  }
  
  /// Format timecode (HH:MM:SS.mmm)
  static String formatTimecode(double seconds) {
    final hours = (seconds / 3600).floor();
    final minutes = ((seconds % 3600) / 60).floor();
    final secs = (seconds % 60).floor();
    final milliseconds = ((seconds % 1) * 1000).floor();
    
    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:'
             '${minutes.toString().padLeft(2, '0')}:'
             '${secs.toString().padLeft(2, '0')}.'
             '${milliseconds.toString().padLeft(3, '0')}';
    } else {
      return '${minutes.toString().padLeft(2, '0')}:'
             '${secs.toString().padLeft(2, '0')}.'
             '${milliseconds.toString().padLeft(3, '0')}';
    }
  }
  
  /// Calculate frame time from FPS
  static double fpsToFrameTime(double fps) {
    if (fps <= 0) return 0.0;
    return 1.0 / fps;
  }
  
  /// Calculate FPS from frame time
  static double frameTimeToFPS(double frameTime) {
    if (frameTime <= 0) return 0.0;
    return 1.0 / frameTime;
  }
  
  /// Interpolate between timestamps
  static double interpolate(double previousTime, double currentTime, double targetTime, double alpha) {
    if (alpha <= 0.0) return previousTime;
    if (alpha >= 1.0) return currentTime;
    
    // Simple linear interpolation
    return previousTime + (currentTime - previousTime) * alpha;
  }
  
  /// Calculate smooth delta time (exponential moving average)
  static double smoothDeltaTime(List<double> frameTimes, double smoothingFactor) {
    if (frameTimes.isEmpty) return 0.0;
    
    double smoothed = frameTimes.first;
    for (int i = 1; i < frameTimes.length; i++) {
      smoothed = smoothingFactor * frameTimes[i] + (1 - smoothingFactor) * smoothed;
    }
    
    return smoothed;
  }
  
  /// Calculate average frame time
  static double averageFrameTime(List<double> frameTimes) {
    if (frameTimes.isEmpty) return 0.0;
    
    double sum = 0.0;
    for (final time in frameTimes) {
      sum += time;
    }
    
    return sum / frameTimes.length;
  }
  
  /// Calculate frame time variance
  static double frameTimeVariance(List<double> frameTimes) {
    if (frameTimes.length < 2) return 0.0;
    
    final average = averageFrameTime(frameTimes);
    double sum = 0.0;
    
    for (final time in frameTimes) {
      final diff = time - average;
      sum += diff * diff;
    }
    
    return sum / (frameTimes.length - 1);
  }
  
  /// Calculate frame time standard deviation
  static double frameTimeStandardDeviation(List<double> frameTimes) {
    return math.sqrt(frameTimeVariance(frameTimes));
  }
  
  /// Calculate frame time jitter (maximum deviation)
  static double frameTimeJitter(List<double> frameTimes) {
    if (frameTimes.isEmpty) return 0.0;
    
    final average = averageFrameTime(frameTimes);
    double maxDeviation = 0.0;
    
    for (final time in frameTimes) {
      final deviation = (time - average).abs();
      if (deviation > maxDeviation) {
        maxDeviation = deviation;
      }
    }
    
    return maxDeviation;
  }
  
  /// Check if frame rate is stable
  static bool isFrameRateStable(List<double> frameTimes, double threshold) {
    if (frameTimes.length < 2) return true;
    
    final jitter = frameTimeJitter(frameTimes);
    final average = averageFrameTime(frameTimes);
    
    return jitter / average < threshold;
  }
}

/// Time scaling manager
class TimeScaleManager {
  final HighResolutionClock _clock;
  double _baseTimeScale = 1.0;
  double _currentTimeScale = 1.0;
  final Map<String, double> _modifiers = {};
  
  /// Create time scale manager
  TimeScaleManager(this._clock);
  
  /// Get current time scale
  double get timeScale => _currentTimeScale;
  
  /// Set base time scale
  set baseTimeScale(double scale) {
    _baseTimeScale = math.max(0.0, scale);
    _updateCurrentTimeScale();
  }
  
  /// Add time scale modifier
  void addModifier(String id, double multiplier) {
    _modifiers[id] = multiplier;
    _updateCurrentTimeScale();
  }
  
  /// Remove time scale modifier
  void removeModifier(String id) {
    _modifiers.remove(id);
    _updateCurrentTimeScale();
  }
  
  /// Check if modifier exists
  bool hasModifier(String id) {
    return _modifiers.containsKey(id);
  }
  
  /// Get modifier value
  double? getModifier(String id) {
    return _modifiers[id];
  }
  
  /// Clear all modifiers
  void clearModifiers() {
    _modifiers.clear();
    _updateCurrentTimeScale();
  }
  
  /// Apply slow motion effect
  void slowMotion(double intensity, [Duration duration = Duration.zero]) {
    addModifier('slow_motion', intensity);
    
    if (duration > Duration.zero) {
      Future.delayed(duration, () {
        removeModifier('slow_motion');
      });
    }
  }
  
  /// Apply bullet time effect (extreme slow motion)
  void bulletTime([Duration duration = const Duration(seconds: 3)]) {
    slowMotion(0.1, duration);
  }
  
  /// Apply time stop effect
  void timeStop([Duration duration = const Duration(seconds: 2)]) {
    slowMotion(0.0, duration);
  }
  
  /// Apply fast forward effect
  void fastForward(double speed, [Duration duration = Duration.zero]) {
    addModifier('fast_forward', speed);
    
    if (duration > Duration.zero) {
      Future.delayed(duration, () {
        removeModifier('fast_forward');
      });
    }
  }
  
  /// Update current time scale from modifiers
  void _updateCurrentTimeScale() {
    double scale = _baseTimeScale;
    
    for (final multiplier in _modifiers.values) {
      scale *= multiplier;
    }
    
    _currentTimeScale = math.max(0.0, scale);
  }
  
  /// Get scaled delta time
  double getScaledDeltaTime(double rawDeltaTime) {
    return rawDeltaTime * _currentTimeScale;
  }
  
  /// Reset to normal time
  void reset() {
    _baseTimeScale = 1.0;
    clearModifiers();
  }
}
