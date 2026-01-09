/// DSRT Engine - Performance Statistics
/// Performance statistics collection and analysis.
library dsrt_engine.src.core.performance.stats;

import 'dart:collection';
import 'dart:math' as math;
import '../../utils/logger.dart';

/// Performance statistics collector
class PerformanceStats {
  /// Frame statistics
  final FrameStats frameStats;
  
  /// Memory statistics
  final MemoryStats memoryStats;
  
  /// Render statistics
  final RenderStats renderStats;
  
  /// Physics statistics
  final PhysicsStats physicsStats;
  
  /// Audio statistics
  final AudioStats audioStats;
  
  /// Create performance stats
  PerformanceStats()
      : frameStats = FrameStats(),
        memoryStats = MemoryStats(),
        renderStats = RenderStats(),
        physicsStats = PhysicsStats(),
        audioStats = AudioStats();
  
  /// Reset all statistics
  void reset() {
    frameStats.reset();
    memoryStats.reset();
    renderStats.reset();
    physicsStats.reset();
    audioStats.reset();
  }
  
  /// Update all statistics
  void update() {
    frameStats.update();
    memoryStats.update();
  }
  
  /// Get summary as string
  String getSummary() {
    return '''
Performance Summary:
  FPS: ${frameStats.fps.toStringAsFixed(1)} (min: ${frameStats.minFps.toStringAsFixed(1)}, max: ${frameStats.maxFps.toStringAsFixed(1)})
  Frame Time: ${frameStats.frameTime.toStringAsFixed(2)}ms
  Memory: ${(memoryStats.usedMemory / 1024 / 1024).toStringAsFixed(2)}MB / ${(memoryStats.totalMemory / 1024 / 1024).toStringAsFixed(2)}MB
  Draw Calls: ${renderStats.drawCalls}
  Triangles: ${renderStats.triangles}
  Vertices: ${renderStats.vertices}
''';
  }
  
  /// Convert to map for serialization
  Map<String, dynamic> toMap() {
    return {
      'frame': frameStats.toMap(),
      'memory': memoryStats.toMap(),
      'render': renderStats.toMap(),
      'physics': physicsStats.toMap(),
      'audio': audioStats.toMap(),
    };
  }
}

/// Frame statistics
class FrameStats {
  /// Current FPS
  double fps = 0.0;
  
  /// Average FPS
  double averageFps = 0.0;
  
  /// Minimum FPS
  double minFps = double.infinity;
  
  /// Maximum FPS
  double maxFps = 0.0;
  
  /// Current frame time (ms)
  double frameTime = 0.0;
  
  /// Average frame time (ms)
  double averageFrameTime = 0.0;
  
  /// Frame count
  int frameCount = 0;
  
  /// Last frame timestamp
  double lastFrameTime = 0.0;
  
  /// FPS history
  final List<double> _fpsHistory = [];
  
  /// Frame time history
  final List<double> _frameTimeHistory = [];
  
  /// Maximum history size
  static const int maxHistorySize = 300; // 5 seconds at 60 FPS
  
  /// Update frame statistics
  void update() {
    final now = DateTime.now().millisecondsSinceEpoch / 1000.0;
    
    if (lastFrameTime > 0) {
      final delta = now - lastFrameTime;
      
      // Calculate FPS
      if (delta > 0) {
        fps = 1.0 / delta;
        frameTime = delta * 1000.0;
        
        // Update min/max FPS
        minFps = math.min(minFps, fps);
        maxFps = math.max(maxFps, fps);
        
        // Add to history
        _fpsHistory.add(fps);
        _frameTimeHistory.add(frameTime);
        
        // Trim history
        if (_fpsHistory.length > maxHistorySize) {
          _fpsHistory.removeAt(0);
          _frameTimeHistory.removeAt(0);
        }
        
        // Calculate averages
        averageFps = _calculateAverage(_fpsHistory);
        averageFrameTime = _calculateAverage(_frameTimeHistory);
      }
    }
    
    lastFrameTime = now;
    frameCount++;
  }
  
  /// Reset statistics
  void reset() {
    fps = 0.0;
    averageFps = 0.0;
    minFps = double.infinity;
    maxFps = 0.0;
    frameTime = 0.0;
    averageFrameTime = 0.0;
    frameCount = 0;
    lastFrameTime = 0.0;
    _fpsHistory.clear();
    _frameTimeHistory.clear();
  }
  
  /// Get FPS history
  List<double> getFpsHistory() => List.from(_fpsHistory);
  
  /// Get frame time history
  List<double> getFrameTimeHistory() => List.from(_frameTimeHistory);
  
  /// Calculate average of list
  double _calculateAverage(List<double> values) {
    if (values.isEmpty) return 0.0;
    
    double sum = 0.0;
    for (final value in values) {
      sum += value;
    }
    return sum / values.length;
  }
  
  /// Convert to map
  Map<String, dynamic> toMap() {
    return {
      'fps': fps,
      'averageFps': averageFps,
      'minFps': minFps.isFinite ? minFps : 0.0,
      'maxFps': maxFps,
      'frameTime': frameTime,
      'averageFrameTime': averageFrameTime,
      'frameCount': frameCount,
    };
  }
}

/// Memory statistics
class MemoryStats {
  /// Used memory in bytes
  int usedMemory = 0;
  
  /// Total memory in bytes
  int totalMemory = 0;
  
  /// Memory usage percentage
  double get memoryUsagePercent => totalMemory > 0 ? (usedMemory / totalMemory * 100) : 0.0;
  
  /// Memory usage history
  final List<int> _memoryHistory = [];
  
  /// Update memory statistics
  void update() {
    // This is a platform-specific implementation
    // For web, we can use performance.memory if available
    // For native, we need platform-specific code
    
    try {
      // Web implementation
      if (_isWeb()) {
        // Try to get memory info from browser
        _updateWebMemory();
      } else {
        // Native implementation would go here
        _updateNativeMemory();
      }
    } catch (e) {
      // Memory info not available
      usedMemory = 0;
      totalMemory = 0;
    }
    
    // Add to history
    _memoryHistory.add(usedMemory);
    if (_memoryHistory.length > PerformanceStats.maxHistorySize) {
      _memoryHistory.removeAt(0);
    }
  }
  
  /// Reset statistics
  void reset() {
    usedMemory = 0;
    totalMemory = 0;
    _memoryHistory.clear();
  }
  
  /// Get memory history
  List<int> getMemoryHistory() => List.from(_memoryHistory);
  
  /// Check if running on web
  bool _isWeb() {
    return identical(0, 0.0); // Simple check for web platform
  }
  
  /// Update web memory stats
  void _updateWebMemory() {
    // This would use dart:js or js interop in real implementation
    // For now, return placeholder values
    usedMemory = 100 * 1024 * 1024; // 100MB
    totalMemory = 4000 * 1024 * 1024; // 4GB
  }
  
  /// Update native memory stats
  void _updateNativeMemory() {
    // Placeholder for native implementation
    usedMemory = 200 * 1024 * 1024; // 200MB
    totalMemory = 8000 * 1024 * 1024; // 8GB
  }
  
  /// Convert to map
  Map<String, dynamic> toMap() {
    return {
      'usedMemory': usedMemory,
      'totalMemory': totalMemory,
      'memoryUsagePercent': memoryUsagePercent,
    };
  }
}

/// Render statistics
class RenderStats {
  /// Number of draw calls
  int drawCalls = 0;
  
  /// Number of triangles rendered
  int triangles = 0;
  
  /// Number of vertices processed
  int vertices = 0;
  
  /// Number of shader program switches
  int programSwitches = 0;
  
  /// Number of texture binds
  int textureBinds = 0;
  
  /// Number of buffer binds
  int bufferBinds = 0;
  
  /// Number of framebuffer switches
  int framebufferSwitches = 0;
  
  /// Reset statistics
  void reset() {
    drawCalls = 0;
    triangles = 0;
    vertices = 0;
    programSwitches = 0;
    textureBinds = 0;
    bufferBinds = 0;
    framebufferSwitches = 0;
  }
  
  /// Increment draw calls
  void incrementDrawCalls(int count) {
    drawCalls += count;
  }
  
  /// Add triangle count
  void addTriangles(int count) {
    triangles += count;
  }
  
  /// Add vertex count
  void addVertices(int count) {
    vertices += count;
  }
  
  /// Increment program switches
  void incrementProgramSwitches() {
    programSwitches++;
  }
  
  /// Increment texture binds
  void incrementTextureBinds() {
    textureBinds++;
  }
  
  /// Increment buffer binds
  void incrementBufferBinds() {
    bufferBinds++;
  }
  
  /// Increment framebuffer switches
  void incrementFramebufferSwitches() {
    framebufferSwitches++;
  }
  
  /// Convert to map
  Map<String, dynamic> toMap() {
    return {
      'drawCalls': drawCalls,
      'triangles': triangles,
      'vertices': vertices,
      'programSwitches': programSwitches,
      'textureBinds': textureBinds,
      'bufferBinds': bufferBinds,
      'framebufferSwitches': framebufferSwitches,
    };
  }
}

/// Physics statistics
class PhysicsStats {
  /// Number of rigid bodies
  int rigidBodies = 0;
  
  /// Number of collision checks
  int collisionChecks = 0;
  
  /// Number of collisions detected
  int collisionsDetected = 0;
  
  /// Physics update time (ms)
  double updateTime = 0.0;
  
  /// Collision detection time (ms)
  double collisionTime = 0.0;
  
  /// Reset statistics
  void reset() {
    rigidBodies = 0;
    collisionChecks = 0;
    collisionsDetected = 0;
    updateTime = 0.0;
    collisionTime = 0.0;
  }
  
  /// Convert to map
  Map<String, dynamic> toMap() {
    return {
      'rigidBodies': rigidBodies,
      'collisionChecks': collisionChecks,
      'collisionsDetected': collisionsDetected,
      'updateTime': updateTime,
      'collisionTime': collisionTime,
    };
  }
}

/// Audio statistics
class AudioStats {
  /// Number of active audio sources
  int activeSources = 0;
  
  /// Number of audio buffers loaded
  int buffersLoaded = 0;
  
  /// Audio processing time (ms)
  double processingTime = 0.0;
  
  /// Reset statistics
  void reset() {
    activeSources = 0;
    buffersLoaded = 0;
    processingTime = 0.0;
  }
  
  /// Convert to map
  Map<String, dynamic> toMap() {
    return {
      'activeSources': activeSources,
      'buffersLoaded': buffersLoaded,
      'processingTime': processingTime,
    };
  }
}
