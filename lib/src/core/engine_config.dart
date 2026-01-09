/// Engine configuration class
/// 
/// Contains all configurable parameters for the engine.
/// This is a pure data class with no dependencies.
/// 
/// @license MIT
/// @copyright (c) 2024 DSRT Engine

/// Configuration for the DSRT Engine
class ExsEngineConfig {
  /// Engine name/identifier
  final String name;
  
  /// Target frames per second (0 for uncapped)
  final int targetFPS;
  
  /// Enable performance profiling
  final bool enableProfiling;
  
  /// Enable debug mode
  final bool debugMode;
  
  /// Enable physics simulation
  final bool enablePhysics;
  
  /// Enable audio system
  final bool enableAudio;
  
  /// Enable UI system
  final bool enableUI;
  
  /// Default constructor with sensible defaults
  const ExsEngineConfig({
    this.name = 'DSRT Engine',
    this.targetFPS = 60,
    this.enableProfiling = false,
    this.debugMode = false,
    this.enablePhysics = true,
    this.enableAudio = true,
    this.enableUI = true,
  });
  
  /// Create a minimal config for lightweight applications
  const ExsEngineConfig.minimal()
    : name = 'DSRT Minimal',
      targetFPS = 60,
      enableProfiling = false,
      debugMode = false,
      enablePhysics = false,
      enableAudio = false,
      enableUI = false;
  
  /// Create a development config with all debug features
  const ExsEngineConfig.development()
    : name = 'DSRT Development',
      targetFPS = 60,
      enableProfiling = true,
      debugMode = true,
      enablePhysics = true,
      enableAudio = true,
      enableUI = true;
  
  /// Create a production config optimized for performance
  const ExsEngineConfig.production()
    : name = 'DSRT Production',
      targetFPS = 60,
      enableProfiling = false,
      debugMode = false,
      enablePhysics = true,
      enableAudio = true,
      enableUI = false;
  
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExsEngineConfig &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          targetFPS == other.targetFPS &&
          enableProfiling == other.enableProfiling &&
          debugMode == other.debugMode &&
          enablePhysics == other.enablePhysics &&
          enableAudio == other.enableAudio &&
          enableUI == other.enableUI;
  
  @override
  int get hashCode =>
      name.hashCode ^
      targetFPS.hashCode ^
      enableProfiling.hashCode ^
      debugMode.hashCode ^
      enablePhysics.hashCode ^
      enableAudio.hashCode ^
      enableUI.hashCode;
  
  @override
  String toString() {
    return 'ExsEngineConfig(name: $name, targetFPS: $targetFPS, '
           'debugMode: $debugMode, enablePhysics: $enablePhysics, '
           'enableAudio: $enableAudio, enableUI: $enableUI)';
  }
  
  /// Create a copy with overridden values
  ExsEngineConfig copyWith({
    String? name,
    int? targetFPS,
    bool? enableProfiling,
    bool? debugMode,
    bool? enablePhysics,
    bool? enableAudio,
    bool? enableUI,
  }) {
    return ExsEngineConfig(
      name: name ?? this.name,
      targetFPS: targetFPS ?? this.targetFPS,
      enableProfiling: enableProfiling ?? this.enableProfiling,
      debugMode: debugMode ?? this.debugMode,
      enablePhysics: enablePhysics ?? this.enablePhysics,
      enableAudio: enableAudio ?? this.enableAudio,
      enableUI: enableUI ?? this.enableUI,
    );
  }
}
