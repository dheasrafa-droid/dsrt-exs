/// Performance statistics collection
/// 
/// Tracks various engine metrics like frame rate, memory usage,
/// draw calls, triangle counts, etc.
/// 
/// @license MIT
/// @copyright (c) 2024 DSRT Engine

import 'dart:collection';

/// Performance statistics class
class ExsStats {
  /// Frame counter
  int frames = 0;
  
  /// Time when stats started
  DateTime? _startTime;
  
  /// Last frame time
  DateTime? _lastFrameTime;
  
  /// Frame times history (ring buffer)
  final Queue<double> _frameTimes = Queue<double>();
  
  /// Maximum frame time history size
  static const int _maxFrameTimeHistory = 60;
  
  /// Draw calls per frame
  int drawCalls = 0;
  
  /// Triangles rendered per frame
  int triangles = 0;
  
  /// Lines rendered per frame
  int lines = 0;
  
  /// Points rendered per frame
  int points = 0;
  
  /// Textures loaded
  int textures = 0;
  
  /// Geometries loaded
  int geometries = 0;
  
  /// Materials loaded
  int materials = 0;
  
  /// Shaders compiled
  int shaders = 0;
  
  /// Maximum draw calls in a single frame
  int maxDrawCalls = 0;
  
  /// Maximum triangles in a single frame
  int maxTriangles = 0;
  
  /// Start tracking statistics
  void start() {
    _startTime = DateTime.now();
    _lastFrameTime = DateTime.now();
    frames = 0;
    resetFrameCounters();
  }
  
  /// Update frame statistics
  void updateFrame() {
    final now = DateTime.now();
    
    // Calculate frame time
    if (_lastFrameTime != null) {
      final frameTime = now.difference(_lastFrameTime!).inMilliseconds.toDouble();
      _frameTimes.addLast(frameTime);
      
      // Maintain history size
      if (_frameTimes.length > _maxFrameTimeHistory) {
        _frameTimes.removeFirst();
      }
    }
    
    _lastFrameTime = now;
    frames++;
    
    // Track maximums
    if (drawCalls > maxDrawCalls) maxDrawCalls = drawCalls;
    if (triangles > maxTriangles) maxTriangles = triangles;
  }
  
  /// Reset per-frame counters
  void resetFrameCounters() {
    drawCalls = 0;
    triangles = 0;
    lines = 0;
    points = 0;
  }
  
  /// Get current frames per second
  double get fps {
    if (_frameTimes.isEmpty) return 0.0;
    
    // Average of last 10 frames
    final recentFrames = _frameTimes.length > 10 
        ? _frameTimes.toList().sublist(_frameTimes.length - 10)
        : _frameTimes.toList();
    
    var totalTime = 0.0;
    for (final time in recentFrames) {
      totalTime += time;
    }
    
    final avgTime = totalTime / recentFrames.length;
    return avgTime > 0 ? 1000.0 / avgTime : 0.0;
  }
  
  /// Get average frame time (ms)
  double get frameTime {
    if (_frameTimes.isEmpty) return 0.0;
    
    var total = 0.0;
    for (final time in _frameTimes) {
      total += time;
    }
    
    return total / _frameTimes.length;
  }
  
  /// Get minimum frame time in history (ms)
  double get minFrameTime {
    if (_frameTimes.isEmpty) return 0.0;
    
    var min = double.infinity;
    for (final time in _frameTimes) {
      if (time < min) min = time;
    }
    
    return min.isFinite ? min : 0.0;
  }
  
  /// Get maximum frame time in history (ms)
  double get maxFrameTime {
    if (_frameTimes.isEmpty) return 0.0;
    
    var max = 0.0;
    for (final time in _frameTimes) {
      if (time > max) max = time;
    }
    
    return max;
  }
  
  /// Get uptime in seconds
  double get uptime {
    if (_startTime == null) return 0.0;
    return DateTime.now().difference(_startTime!).inMilliseconds / 1000.0;
  }
  
  /// Get memory usage (placeholder - would need platform-specific implementation)
  int get memoryUsage {
    // This is a placeholder. In a real implementation, this would use
    // platform-specific APIs to get actual memory usage.
    return 0;
  }
  
  /// Get statistics as a map
  Map<String, dynamic> toMap() {
    return {
      'frames': frames,
      'fps': fps,
      'frameTime': frameTime,
      'minFrameTime': minFrameTime,
      'maxFrameTime': maxFrameTime,
      'drawCalls': drawCalls,
      'maxDrawCalls': maxDrawCalls,
      'triangles': triangles,
      'maxTriangles': maxTriangles,
      'lines': lines,
      'points': points,
      'textures': textures,
      'geometries': geometries,
      'materials': materials,
      'shaders': shaders,
      'uptime': uptime,
      'memoryUsage': memoryUsage,
    };
  }
  
  /// Get statistics summary as string
  String get summary {
    return 'FPS: ${fps.toStringAsFixed(1)}, '
           'Frame: ${frameTime.toStringAsFixed(1)}ms, '
           'Draws: $drawCalls, '
           'Tris: $triangles, '
           'Uptime: ${uptime.toStringAsFixed(1)}s';
  }
  
  /// Reset all statistics
  void reset() {
    _startTime = null;
    _lastFrameTime = null;
    _frameTimes.clear();
    frames = 0;
    drawCalls = 0;
    triangles = 0;
    lines = 0;
    points = 0;
    maxDrawCalls = 0;
    maxTriangles = 0;
    textures = 0;
    geometries = 0;
    materials = 0;
    shaders = 0;
  }
}
