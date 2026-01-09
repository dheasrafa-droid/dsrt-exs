/// DSRT Engine - Engine Configuration
/// Configuration system for engine behavior and settings.
library dsrt_engine.src.core.engine_config;

import 'constants.dart';
import '../utils/logger.dart';

/// Main engine configuration class
class EngineConfig {
  /// Default width of the viewport
  final int defaultWidth;
  
  /// Default height of the viewport
  final int defaultHeight;
  
  /// Target frames per second
  final double targetFPS;
  
  /// Maximum delta time (prevents spiral of death)
  final double maxDeltaTime;
  
  /// Enable/disable profiling
  final bool enableProfiling;
  
  /// Enable/disable debug mode
  final bool debug;
  
  /// Log level for engine logging
  final LogLevel logLevel;
  
  /// Include engine info in log messages
  final bool logEngineInfo;
  
  /// Stop engine on error
  final bool stopOnError;
  
  /// Game loop configuration
  final LoopConfig loopConfig;
  
  /// Renderer options
  final Map<String, dynamic> rendererOptions;
  
  /// Create engine configuration
  EngineConfig({
    this.defaultWidth = DSRTConstants.defaultWidth,
    this.defaultHeight = DSRTConstants.defaultHeight,
    this.targetFPS = DSRTConstants.targetFPS,
    this.maxDeltaTime = DSRTConstants.maxDeltaTime,
    this.enableProfiling = false,
    this.debug = false,
    this.logLevel = LogLevel.info,
    this.logEngineInfo = true,
    this.stopOnError = true,
    LoopConfig? loopConfig,
    this.rendererOptions = const {},
  }) : loopConfig = loopConfig ?? LoopConfig.defaults();
  
  /// Default engine configuration
  factory EngineConfig.defaults() => EngineConfig();
  
  /// Production configuration
  factory EngineConfig.production() => EngineConfig(
    enableProfiling: false,
    debug: false,
    logLevel: LogLevel.warning,
    logEngineInfo: false,
    stopOnError: false,
  );
  
  /// Development configuration
  factory EngineConfig.development() => EngineConfig(
    enableProfiling: true,
    debug: true,
    logLevel: LogLevel.debug,
    logEngineInfo: true,
    stopOnError: true,
    loopConfig: LoopConfig.development(),
  );
  
  /// Create a copy with overrides
  EngineConfig copyWith({
    int? defaultWidth,
    int? defaultHeight,
    double? targetFPS,
    double? maxDeltaTime,
    bool? enableProfiling,
    bool? debug,
    LogLevel? logLevel,
    bool? logEngineInfo,
    bool? stopOnError,
    LoopConfig? loopConfig,
    Map<String, dynamic>? rendererOptions,
  }) {
    return EngineConfig(
      defaultWidth: defaultWidth ?? this.defaultWidth,
      defaultHeight: defaultHeight ?? this.defaultHeight,
      targetFPS: targetFPS ?? this.targetFPS,
      maxDeltaTime: maxDeltaTime ?? this.maxDeltaTime,
      enableProfiling: enableProfiling ?? this.enableProfiling,
      debug: debug ?? this.debug,
      logLevel: logLevel ?? this.logLevel,
      logEngineInfo: logEngineInfo ?? this.logEngineInfo,
      stopOnError: stopOnError ?? this.stopOnError,
      loopConfig: loopConfig ?? this.loopConfig,
      rendererOptions: rendererOptions ?? this.rendererOptions,
    );
  }
  
  /// Convert to map for serialization
  Map<String, dynamic> toMap() {
    return {
      'defaultWidth': defaultWidth,
      'defaultHeight': defaultHeight,
      'targetFPS': targetFPS,
      'maxDeltaTime': maxDeltaTime,
      'enableProfiling': enableProfiling,
      'debug': debug,
      'logLevel': logLevel.index,
      'logEngineInfo': logEngineInfo,
      'stopOnError': stopOnError,
      'loopConfig': loopConfig.toMap(),
      'rendererOptions': Map.from(rendererOptions),
    };
  }
  
  /// Create from map
  factory EngineConfig.fromMap(Map<String, dynamic> map) {
    return EngineConfig(
      defaultWidth: map['defaultWidth'] as int? ?? DSRTConstants.defaultWidth,
      defaultHeight: map['defaultHeight'] as int? ?? DSRTConstants.defaultHeight,
      targetFPS: (map['targetFPS'] as num?)?.toDouble() ?? DSRTConstants.targetFPS,
      maxDeltaTime: (map['maxDeltaTime'] as num?)?.toDouble() ?? DSRTConstants.maxDeltaTime,
      enableProfiling: map['enableProfiling'] as bool? ?? false,
      debug: map['debug'] as bool? ?? false,
      logLevel: LogLevel.values[map['logLevel'] as int? ?? LogLevel.info.index],
      logEngineInfo: map['logEngineInfo'] as bool? ?? true,
      stopOnError: map['stopOnError'] as bool? ?? true,
      loopConfig: map['loopConfig'] != null 
          ? LoopConfig.fromMap(Map<String, dynamic>.from(map['loopConfig'] as Map))
          : LoopConfig.defaults(),
      rendererOptions: Map<String, dynamic>.from(map['rendererOptions'] as Map? ?? const {}),
    );
  }
}

/// Game loop configuration
class LoopConfig {
  /// Type of game loop
  final LoopType type;
  
  /// Target FPS (0 for unlimited)
  final double targetFPS;
  
  /// Maximum updates per frame (for fixed step loops)
  final int maxUpdatesPerFrame;
  
  /// Enable frame skipping
  final bool enableFrameSkipping;
  
  /// Create loop configuration
  LoopConfig({
    this.type = LoopType.variable,
    this.targetFPS = 60.0,
    this.maxUpdatesPerFrame = 5,
    this.enableFrameSkipping = true,
  });
  
  /// Default loop configuration
  factory LoopConfig.defaults() => LoopConfig();
  
  /// Development loop configuration
  factory LoopConfig.development() => LoopConfig(
    type: LoopType.fixed,
    targetFPS: 60.0,
    maxUpdatesPerFrame: 10,
    enableFrameSkipping: false,
  );
  
  /// Convert to map
  Map<String, dynamic> toMap() {
    return {
      'type': type.index,
      'targetFPS': targetFPS,
      'maxUpdatesPerFrame': maxUpdatesPerFrame,
      'enableFrameSkipping': enableFrameSkipping,
    };
  }
  
  /// Create from map
  factory LoopConfig.fromMap(Map<String, dynamic> map) {
    return LoopConfig(
      type: LoopType.values[map['type'] as int? ?? LoopType.variable.index],
      targetFPS: (map['targetFPS'] as num?)?.toDouble() ?? 60.0,
      maxUpdatesPerFrame: map['maxUpdatesPerFrame'] as int? ?? 5,
      enableFrameSkipping: map['enableFrameSkipping'] as bool? ?? true,
    );
  }
}

/// Game loop types
enum LoopType {
  /// Fixed time step loop
  fixed,
  
  /// Variable time step loop
  variable,
}
