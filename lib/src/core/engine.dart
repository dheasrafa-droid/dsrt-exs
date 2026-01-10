// lib/src/core/engine.dart

/// DSRT Engine - Main Engine Class
/// 
/// The central orchestrator of the DSRT Engine, managing initialization,
/// lifecycle, subsystems, and resource management.
/// 
/// @category Core
/// @version 1.0.0
/// @license MIT
/// @copyright DSRT Engine Team

library dsrt_engine.core.engine;

import 'dart:async';
import 'dart:collection';
import 'dart:developer';
import 'dart:io';
import 'dart:math' as math;

import 'engine_config.dart';
import 'settings.dart';
import 'version.dart';
import '../utils/logger.dart';
import '../utils/disposable.dart';
import '../events/event_system.dart';

/// Engine initialization flags
class DsrtEngineFlags {
  /// Enable debug mode
  static const int DEBUG = 1 << 0;
  
  /// Enable profiling
  static const int PROFILE = 1 << 1;
  
  /// Enable verbose logging
  static const int VERBOSE = 1 << 2;
  
  /// Enable memory tracking
  static const int MEMORY_TRACKING = 1 << 3;
  
  /// Enable hot reload
  static const int HOT_RELOAD = 1 << 4;
  
  /// Enable asset caching
  static const int ASSET_CACHING = 1 << 5;
  
  /// Enable multithreading
  static const int MULTITHREADING = 1 << 6;
  
  /// Enable GPU profiling
  static const int GPU_PROFILING = 1 << 7;
  
  /// Enable validation layers
  static const int VALIDATION = 1 << 8;
  
  /// Enable backward compatibility
  static const int BACKWARD_COMPAT = 1 << 9;
  
  /// Enable experimental features
  static const int EXPERIMENTAL = 1 << 10;
  
  /// Default engine flags
  static const int DEFAULT = DEBUG | ASSET_CACHING | VALIDATION;
  
  /// Production engine flags
  static const int PRODUCTION = ASSET_CACHING | BACKWARD_COMPAT;
  
  /// Development engine flags
  static const int DEVELOPMENT = DEBUG | PROFILE | VERBOSE | VALIDATION | HOT_RELOAD;
}

/// Engine state
enum DsrtEngineState {
  /// Engine is not initialized
  UNINITIALIZED,
  
  /// Engine is initializing
  INITIALIZING,
  
  /// Engine is initialized but not running
  INITIALIZED,
  
  /// Engine is starting up
  STARTING,
  
  /// Engine is running
  RUNNING,
  
  /// Engine is pausing
  PAUSING,
  
  /// Engine is paused
  PAUSED,
  
  /// Engine is resuming
  RESUMING,
  
  /// Engine is stopping
  STOPPING,
  
  /// Engine is stopped
  STOPPED,
  
  /// Engine is disposing
  DISPOSING,
  
  /// Engine is disposed
  DISPOSED,
  
  /// Engine encountered an error
  ERROR
}

/// Engine initialization options
class DsrtEngineOptions {
  /// Engine flags (see DsrtEngineFlags)
  final int flags;
  
  /// Configuration overrides
  final Map<String, dynamic>? configOverrides;
  
  /// Initial settings overrides
  final Map<String, dynamic>? settingsOverrides;
  
  /// Platform-specific options
  final Map<String, dynamic>? platformOptions;
  
  /// Custom logger instance (optional)
  final DsrtLogger? logger;
  
  /// Event system instance (optional)
  final DsrtEventSystem? eventSystem;
  
  /// Maximum frame rate (0 for unlimited)
  final int maxFrameRate;
  
  /// Minimum frame time (in seconds)
  final double minFrameTime;
  
  /// Target frame time (in seconds)
  final double targetFrameTime;
  
  /// Creates engine initialization options
  const DsrtEngineOptions({
    this.flags = DsrtEngineFlags.DEFAULT,
    this.configOverrides,
    this.settingsOverrides,
    this.platformOptions,
    this.logger,
    this.eventSystem,
    this.maxFrameRate = 60,
    this.minFrameTime = 1.0 / 1000.0, // 1000 FPS max
    this.targetFrameTime = 1.0 / 60.0, // 60 FPS target
  });
  
  /// Creates development options
  factory DsrtEngineOptions.development({
    Map<String, dynamic>? configOverrides,
    Map<String, dynamic>? settingsOverrides,
  }) {
    return DsrtEngineOptions(
      flags: DsrtEngineFlags.DEVELOPMENT,
      configOverrides: configOverrides,
      settingsOverrides: settingsOverrides,
      maxFrameRate: 0, // Unlimited in development
    );
  }
  
  /// Creates production options
  factory DsrtEngineOptions.production({
    Map<String, dynamic>? configOverrides,
    Map<String, dynamic>? settingsOverrides,
  }) {
    return DsrtEngineOptions(
      flags: DsrtEngineFlags.PRODUCTION,
      configOverrides: configOverrides,
      settingsOverrides: settingsOverrides,
    );
  }
  
  /// Checks if a flag is set
  bool hasFlag(int flag) {
    return (flags & flag) == flag;
  }
}

/// Engine subsystem interface
abstract class DsrtEngineSubsystem implements DsrtDisposable {
  /// Subsystem name
  String get name;
  
  /// Subsystem priority (higher = initialized earlier)
  int get priority;
  
  /// Whether this subsystem is required
  bool get required;
  
  /// Initializes the subsystem
  Future<void> initialize(DsrtEngine engine);
  
  /// Starts the subsystem
  Future<void> start();
  
  /// Stops the subsystem
  Future<void> stop();
  
  /// Updates the subsystem
  void update(double deltaTime);
  
  /// Renders the subsystem
  void render(double interpolation);
  
  /// Gets subsystem status
  String get status;
  
  /// Checks if subsystem is initialized
  bool get isInitialized;
  
  /// Checks if subsystem is running
  bool get isRunning;
}

/// Engine statistics
class DsrtEngineStats {
  /// Total frames rendered
  int totalFrames = 0;
  
  /// Total time running (seconds)
  double totalTime = 0.0;
  
  /// Average FPS
  double averageFps = 0.0;
  
  /// Current FPS
  double currentFps = 0.0;
  
  /// Minimum FPS
  double minFps = double.infinity;
  
  /// Maximum FPS
  double maxFps = 0.0;
  
  /// Average frame time (ms)
  double averageFrameTime = 0.0;
  
  /// Current frame time (ms)
  double currentFrameTime = 0.0;
  
  /// Minimum frame time (ms)
  double minFrameTime = double.infinity;
  
  /// Maximum frame time (ms)
  double maxFrameTime = 0.0;
  
  /// Memory usage in bytes
  int memoryUsage = 0;
  
  /// Peak memory usage in bytes
  int peakMemoryUsage = 0;
  
  /// GPU memory usage in bytes
  int gpuMemoryUsage = 0;
  
  /// Draw calls per frame
  int drawCalls = 0;
  
  /// Triangles rendered per frame
  int triangles = 0;
  
  /// Vertices processed per frame
  int vertices = 0;
  
  /// Texture count
  int textureCount = 0;
  
  /// Shader program count
  int shaderProgramCount = 0;
  
  /// Buffer count
  int bufferCount = 0;
  
  /// Creates engine statistics
  DsrtEngineStats();
  
  /// Updates statistics with new frame data
  void update(double frameTime, int frameCount) {
    currentFrameTime = frameTime * 1000.0; // Convert to ms
    currentFps = frameTime > 0 ? 1.0 / frameTime : 0.0;
    
    totalFrames += frameCount;
    totalTime += frameTime * frameCount;
    
    // Update min/max
    minFrameTime = math.min(minFrameTime, currentFrameTime);
    maxFrameTime = math.max(maxFrameTime, currentFrameTime);
    minFps = math.min(minFps, currentFps);
    maxFps = math.max(maxFps, currentFps);
    
    // Update averages
    averageFrameTime = totalTime > 0 
        ? (totalTime * 1000.0) / totalFrames 
        : 0.0;
    averageFps = totalTime > 0 
        ? totalFrames / totalTime 
        : 0.0;
  }
  
  /// Resets statistics
  void reset() {
    totalFrames = 0;
    totalTime = 0.0;
    averageFps = 0.0;
    currentFps = 0.0;
    minFps = double.infinity;
    maxFps = 0.0;
    averageFrameTime = 0.0;
    currentFrameTime = 0.0;
    minFrameTime = double.infinity;
    maxFrameTime = 0.0;
    drawCalls = 0;
    triangles = 0;
    vertices = 0;
  }
  
  /// Gets a formatted string of statistics
  String get formattedStats {
    final buffer = StringBuffer();
    buffer.writeln('=== DSRT Engine Statistics ===');
    buffer.writeln('Frames: $totalFrames');
    buffer.writeln('Time: ${totalTime.toStringAsFixed(2)}s');
    buffer.writeln('FPS: ${currentFps.toStringAsFixed(1)} (Avg: ${averageFps.toStringAsFixed(1)}, Min: ${minFps.toStringAsFixed(1)}, Max: ${maxFps.toStringAsFixed(1)})');
    buffer.writeln('Frame Time: ${currentFrameTime.toStringAsFixed(2)}ms (Avg: ${averageFrameTime.toStringAsFixed(2)}ms, Min: ${minFrameTime.toStringAsFixed(2)}ms, Max: ${maxFrameTime.toStringAsFixed(2)}ms)');
    buffer.writeln('Memory: ${(memoryUsage / 1024 / 1024).toStringAsFixed(2)}MB (Peak: ${(peakMemoryUsage / 1024 / 1024).toStringAsFixed(2)}MB)');
    buffer.writeln('GPU Memory: ${(gpuMemoryUsage / 1024 / 1024).toStringAsFixed(2)}MB');
    buffer.writeln('Draw Calls: $drawCalls');
    buffer.writeln('Triangles: $triangles');
    buffer.writeln('Vertices: $vertices');
    buffer.writeln('Textures: $textureCount');
    buffer.writeln('Shaders: $shaderProgramCount');
    buffer.writeln('Buffers: $bufferCount');
    return buffer.toString();
  }
}

/// Main DSRT Engine class
class DsrtEngine implements DsrtDisposable {
  /// Singleton instance
  static DsrtEngine? _instance;
  
  /// Gets the singleton instance (throws if not initialized)
  static DsrtEngine get instance {
    if (_instance == null) {
      throw StateError('DSRT Engine is not initialized. Call initialize() first.');
    }
    return _instance!;
  }
  
  /// Checks if engine is initialized
  static bool get isInitialized => _instance != null;
  
  /// Engine options
  final DsrtEngineOptions options;
  
  /// Engine configuration
  final DsrtEngineConfig config;
  
  /// Engine settings manager
  final DsrtSettingsManager settings;
  
  /// Engine version manager
  final DsrtVersionManager versionManager;
  
  /// Engine logger
  final DsrtLogger logger;
  
  /// Engine event system
  final DsrtEventSystem eventSystem;
  
  /// Engine state
  DsrtEngineState _state = DsrtEngineState.UNINITIALIZED;
  
  /// Engine subsystems
  final Map<String, DsrtEngineSubsystem> _subsystems;
  
  /// Engine statistics
  final DsrtEngineStats stats;
  
  /// Frame timer
  final Stopwatch _frameTimer;
  
  /// Last frame time
  double _lastFrameTime = 0.0;
  
  /// Accumulated time for fixed updates
  double _accumulatedTime = 0.0;
  
  /// Frame count for FPS calculation
  int _frameCount = 0;
  
  /// FPS calculation interval
  double _fpsInterval = 1.0;
  
  /// Time since last FPS calculation
  double _fpsTime = 0.0;
  
  /// Main update loop
  Timer? _updateTimer;
  
  /// Whether the engine is currently in the update loop
  bool _inUpdateLoop = false;
  
  /// Pending operations queue
  final Queue<void Function()> _pendingOperations;
  
  /// Engine initialization completer
  Completer<void>? _initializationCompleter;
  
  /// Engine start completer
  Completer<void>? _startCompleter;
  
  /// Engine stop completer
  Completer<void>? _stopCompleter;
  
  /// Engine error
  Object? _lastError;
  StackTrace? _lastStackTrace;
  
  /// Creates a DSRT Engine instance
  DsrtEngine._internal({
    required this.options,
    required this.config,
    required this.settings,
    required this.versionManager,
    required this.logger,
    required this.eventSystem,
  })  : _subsystems = {},
        stats = DsrtEngineStats(),
        _frameTimer = Stopwatch(),
        _pendingOperations = Queue();
  
  /// Initializes the DSRT Engine
  /// 
  /// [options]: Optional engine initialization options
  /// 
  /// Returns a Future that completes when initialization is done.
  /// 
  /// Throws [StateError] if engine is already initialized.
  /// Throws [DsrtEngineError] if initialization fails.
  static Future<DsrtEngine> initialize({
    DsrtEngineOptions? options,
  }) async {
    if (_instance != null) {
      throw StateError('DSRT Engine is already initialized');
    }
    
    final engineOptions = options ?? const DsrtEngineOptions();
    
    try {
      // Create core components
      final logger = engineOptions.logger ?? DsrtLogger();
      final eventSystem = engineOptions.eventSystem ?? DsrtEventSystem();
      final config = DsrtEngineConfig();
      final settings = DsrtSettingsManager.instance;
      final versionManager = DsrtCurrentVersions.createVersionManager();
      
      // Create engine instance
      _instance = DsrtEngine._internal(
        options: engineOptions,
        config: config,
        settings: settings,
        versionManager: versionManager,
        logger: logger,
        eventSystem: eventSystem,
      );
      
      // Initialize engine
      await _instance!._initialize();
      
      logger.info('DSRT Engine initialized successfully');
      return _instance!;
    } catch (error, stackTrace) {
      // Clean up on initialization failure
      await _instance?.dispose();
      _instance = null;
      
      throw DsrtEngineError(
        'Failed to initialize DSRT Engine: $error',
        error,
        stackTrace,
      );
    }
  }
  
  /// Gets the current engine state
  DsrtEngineState get state => _state;
  
  /// Gets the last error (if any)
  Object? get lastError => _lastError;
  
  /// Gets the last stack trace (if any)
  StackTrace? get lastStackTrace => _lastStackTrace;
  
  /// Checks if engine is running
  bool get isRunning => _state == DsrtEngineState.RUNNING;
  
  /// Checks if engine is paused
  bool get isPaused => _state == DsrtEngineState.PAUSED;
  
  /// Checks if engine is stopped
  bool get isStopped => _state == DsrtEngineState.STOPPED;
  
  /// Checks if engine is disposed
  bool get isDisposed => _state == DsrtEngineState.DISPOSED;
  
  /// Gets the last frame time in seconds
  double get lastFrameTime => _lastFrameTime;
  
  /// Gets the current FPS
  double get currentFps => stats.currentFps;
  
  /// Gets the average FPS
  double get averageFps => stats.averageFps;
  
  /// Registers a subsystem
  void registerSubsystem(DsrtEngineSubsystem subsystem) {
    if (_state != DsrtEngineState.UNINITIALIZED &&
        _state != DsrtEngineState.INITIALIZING) {
      throw StateError('Cannot register subsystem after initialization');
    }
    
    if (_subsystems.containsKey(subsystem.name)) {
      throw ArgumentError('Subsystem "${subsystem.name}" already registered');
    }
    
    _subsystems[subsystem.name] = subsystem;
    logger.debug('Subsystem registered: ${subsystem.name}');
  }
  
  /// Gets a subsystem by name
  DsrtEngineSubsystem? getSubsystem(String name) {
    return _subsystems[name];
  }
  
  /// Checks if a subsystem is registered
  bool hasSubsystem(String name) {
    return _subsystems.containsKey(name);
  }
  
  /// Gets all subsystem names
  List<String> get subsystemNames => _subsystems.keys.toList();
  
  /// Gets all subsystems sorted by priority
  List<DsrtEngineSubsystem> get subsystemsSorted {
    return _subsystems.values.toList()
      ..sort((a, b) => b.priority.compareTo(a.priority)); // Higher priority first
  }
  
  /// Starts the engine
  /// 
  /// Returns a Future that completes when the engine is started.
  /// 
  /// Throws [StateError] if engine is not initialized or already running.
  Future<void> start() async {
    if (_state != DsrtEngineState.INITIALIZED) {
      throw StateError('Cannot start engine in state $_state');
    }
    
    _startCompleter = Completer();
    _setState(DsrtEngineState.STARTING);
    
    try {
      // Start all subsystems
      final subsystems = subsystemsSorted;
      for (final subsystem in subsystems) {
        if (subsystem.isInitialized) {
          await subsystem.start();
          logger.debug('Subsystem started: ${subsystem.name}');
        }
      }
      
      // Start frame timer
      _frameTimer.start();
      
      // Start update loop
      _startUpdateLoop();
      
      _setState(DsrtEngineState.RUNNING);
      _startCompleter?.complete();
      logger.info('DSRT Engine started');
    } catch (error, stackTrace) {
      _setError(error, stackTrace);
      _startCompleter?.completeError(error, stackTrace);
      rethrow;
    }
  }
  
  /// Stops the engine
  /// 
  /// [immediate]: Whether to stop immediately or gracefully
  /// 
  /// Returns a Future that completes when the engine is stopped.
  Future<void> stop({bool immediate = false}) async {
    if (_state != DsrtEngineState.RUNNING &&
        _state != DsrtEngineState.PAUSED) {
      throw StateError('Cannot stop engine in state $_state');
    }
    
    _stopCompleter = Completer();
    _setState(DsrtEngineState.STOPPING);
    
    try {
      // Stop update loop
      _stopUpdateLoop();
      
      // Stop frame timer
      _frameTimer.stop();
      
      // Stop subsystems in reverse order
      final subsystems = subsystemsSorted.reversed.toList();
      for (final subsystem in subsystems) {
        if (subsystem.isRunning) {
          await subsystem.stop();
          logger.debug('Subsystem stopped: ${subsystem.name}');
        }
      }
      
      _setState(DsrtEngineState.STOPPED);
      _stopCompleter?.complete();
      logger.info('DSRT Engine stopped');
    } catch (error, stackTrace) {
      _setError(error, stackTrace);
      _stopCompleter?.completeError(error, stackTrace);
      rethrow;
    }
  }
  
  /// Pauses the engine
  void pause() {
    if (_state != DsrtEngineState.RUNNING) {
      throw StateError('Cannot pause engine in state $_state');
    }
    
    _setState(DsrtEngineState.PAUSING);
    
    // Pause frame timer
    _frameTimer.stop();
    
    // Stop update loop
    _stopUpdateLoop();
    
    _setState(DsrtEngineState.PAUSED);
    logger.info('DSRT Engine paused');
  }
  
  /// Resumes the engine
  void resume() {
    if (_state != DsrtEngineState.PAUSED) {
      throw StateError('Cannot resume engine in state $_state');
    }
    
    _setState(DsrtEngineState.RESUMING);
    
    // Resume frame timer
    _frameTimer.start();
    
    // Restart update loop
    _startUpdateLoop();
    
    _setState(DsrtEngineState.RUNNING);
    logger.info('DSRT Engine resumed');
  }
  
  /// Executes an operation on the main engine thread
  /// 
  /// [operation]: The operation to execute
  /// 
  /// Returns a Future that completes when the operation is executed.
  Future<void> executeOnMainThread(void Function() operation) {
    final completer = Completer<void>();
    
    _pendingOperations.add(() {
      try {
        operation();
        completer.complete();
      } catch (error, stackTrace) {
        completer.completeError(error, stackTrace);
      }
    });
    
    return completer.future;
  }
  
  /// Updates the engine (called by the main loop)
  void update() {
    if (_state != DsrtEngineState.RUNNING) {
      return;
    }
    
    if (_inUpdateLoop) {
      logger.warning('Recursive update detected');
      return;
    }
    
    _inUpdateLoop = true;
    
    try {
      // Calculate delta time
      final currentTime = _frameTimer.elapsedMicroseconds / 1000000.0;
      final deltaTime = currentTime - _lastFrameTime;
      _lastFrameTime = currentTime;
      
      // Clamp delta time to prevent spiral of death
      final clampedDeltaTime = math.min(deltaTime, options.targetFrameTime * 2.0);
      
      // Update statistics
      _updateStatistics(clampedDeltaTime);
      
      // Process pending operations
      _processPendingOperations();
      
      // Update subsystems
      for (final subsystem in _subsystems.values) {
        if (subsystem.isRunning) {
          try {
            subsystem.update(clampedDeltaTime);
          } catch (error, stackTrace) {
            logger.error('Error updating subsystem ${subsystem.name}: $error', stackTrace);
          }
        }
      }
      
      // Fixed update (if needed)
      if (options.targetFrameTime > 0) {
        _accumulatedTime += clampedDeltaTime;
        const maxSteps = 5; // Prevent spiral of death
        
        var steps = 0;
        while (_accumulatedTime >= options.targetFrameTime && steps < maxSteps) {
          _fixedUpdate(options.targetFrameTime);
          _accumulatedTime -= options.targetFrameTime;
          steps++;
        }
        
        // If we still have accumulated time after max steps, discard it
        if (steps >= maxSteps && _accumulatedTime > options.targetFrameTime) {
          _accumulatedTime = 0.0;
          logger.warning('Fixed update spiral detected, discarding accumulated time');
        }
      }
      
      // Trigger update event
      eventSystem.trigger('engine.update', {
        'deltaTime': clampedDeltaTime,
        'frameTime': clampedDeltaTime,
        'currentTime': currentTime,
      });
    } catch (error, stackTrace) {
      _setError(error, stackTrace);
      logger.error('Error in engine update: $error', stackTrace);
    } finally {
      _inUpdateLoop = false;
    }
  }
  
  /// Renders the engine (called by the main loop)
  void render() {
    if (_state != DsrtEngineState.RUNNING && _state != DsrtEngineState.PAUSED) {
      return;
    }
    
    try {
      // Calculate interpolation factor for smooth rendering
      final interpolation = options.targetFrameTime > 0
          ? _accumulatedTime / options.targetFrameTime
          : 1.0;
      
      // Render subsystems
      for (final subsystem in _subsystems.values) {
        if (subsystem.isRunning || _state == DsrtEngineState.PAUSED) {
          try {
            subsystem.render(interpolation);
          } catch (error, stackTrace) {
            logger.error('Error rendering subsystem ${subsystem.name}: $error', stackTrace);
          }
        }
      }
      
      // Trigger render event
      eventSystem.trigger('engine.render', {
        'interpolation': interpolation,
        'frameCount': stats.totalFrames,
      });
    } catch (error, stackTrace) {
      _setError(error, stackTrace);
      logger.error('Error in engine render: $error', stackTrace);
    }
  }
  
  /// Gets engine information
  String get info {
    final buffer = StringBuffer();
    buffer.writeln('=== DSRT Engine Information ===');
    buffer.writeln('Version: ${DsrtConstants.ENGINE_NAME} ${DsrtConstants.ENGINE_VERSION}');
    buffer.writeln('State: $_state');
    buffer.writeln('Flags: ${options.flags}');
    buffer.writeln('Subsystems: ${_subsystems.length}');
    buffer.writeln('Frame Time: ${_lastFrameTime.toStringAsFixed(4)}s');
    buffer.writeln('FPS: ${stats.currentFps.toStringAsFixed(1)}');
    return buffer.toString();
  }
  
  /// Disposes the engine and all resources
  @override
  Future<void> dispose() async {
    if (_state == DsrtEngineState.DISPOSED) {
      return;
    }
    
    _setState(DsrtEngineState.DISPOSING);
    
    try {
      // Stop engine if running
      if (_state == DsrtEngineState.RUNNING || _state == DsrtEngineState.PAUSED) {
        await stop(immediate: true);
      }
      
      // Dispose subsystems in reverse order
      final subsystems = subsystemsSorted.reversed.toList();
      for (final subsystem in subsystems) {
        try {
          await subsystem.dispose();
          logger.debug('Subsystem disposed: ${subsystem.name}');
        } catch (error, stackTrace) {
          logger.error('Error disposing subsystem ${subsystem.name}: $error', stackTrace);
        }
      }
      
      // Clear subsystems
      _subsystems.clear();
      
      // Dispose core components
      await eventSystem.dispose();
      await settings.close();
      
      // Clear singleton instance
      _instance = null;
      
      _setState(DsrtEngineState.DISPOSED);
      logger.info('DSRT Engine disposed');
    } catch (error, stackTrace) {
      logger.error('Error disposing engine: $error', stackTrace);
      rethrow;
    }
  }
  
  /// Initializes the engine
  Future<void> _initialize() async {
    if (_state != DsrtEngineState.UNINITIALIZED) {
      throw StateError('Engine already initialized');
    }
    
    _initializationCompleter = Completer();
    _setState(DsrtEngineState.INITIALIZING);
    
    try {
      // Apply configuration overrides
      if (options.configOverrides != null) {
        config.loadFromMap(options.configOverrides!);
      }
      
      // Apply settings overrides
      if (options.settingsOverrides != null) {
        for (final entry in options.settingsOverrides!.entries) {
          final key = entry.key;
          final value = entry.value;
          
          final parts = key.split('.');
          if (parts.length >= 2) {
            final section = parts[0];
            final settingKey = parts.sublist(1).join('.');
            
            settings.setValue(section, settingKey, value, source: 'initialization');
          }
        }
      }
      
      // Load settings from storage
      await settings.loadFromStorage();
      
      // Initialize subsystems
      final subsystems = subsystemsSorted;
      for (final subsystem in subsystems) {
        try {
          await subsystem.initialize(this);
          logger.debug('Subsystem initialized: ${subsystem.name}');
        } catch (error, stackTrace) {
          if (subsystem.required) {
            throw DsrtEngineError(
              'Failed to initialize required subsystem ${subsystem.name}: $error',
              error,
              stackTrace,
            );
          } else {
            logger.warning('Failed to initialize optional subsystem ${subsystem.name}: $error', stackTrace);
          }
        }
      }
      
      // Validate engine state
      final validationResult = _validateEngine();
      if (!validationResult.isValid) {
        throw DsrtEngineError(
          'Engine validation failed: ${validationResult.errorMessage}',
        );
      }
      
      _setState(DsrtEngineState.INITIALIZED);
      _initializationCompleter?.complete();
      logger.info('DSRT Engine initialization complete');
    } catch (error, stackTrace) {
      _setError(error, stackTrace);
      _initializationCompleter?.completeError(error, stackTrace);
      rethrow;
    }
  }
  
  /// Validates engine state
  DsrtConfigValidationResult _validateEngine() {
    final errors = <String>[];
    
    // Check required subsystems
    for (final subsystem in _subsystems.values) {
      if (subsystem.required && !subsystem.isInitialized) {
        errors.add('Required subsystem "${subsystem.name}" is not initialized');
      }
    }
    
    // Check configuration
    final configValidation = config.validate();
    if (!configValidation.isValid) {
      errors.addAll(configValidation.errors);
    }
    
    // Check settings
    if (!settings.validate()) {
      errors.add('Settings validation failed');
    }
    
    return DsrtConfigValidationResult(
      isValid: errors.isEmpty,
      errors: errors,
    );
  }
  
  /// Updates engine statistics
  void _updateStatistics(double deltaTime) {
    // Update frame count
    _frameCount++;
    _fpsTime += deltaTime;
    
    // Update FPS every second
    if (_fpsTime >= _fpsInterval) {
      stats.update(_fpsTime / _frameCount, _frameCount);
      _frameCount = 0;
      _fpsTime = 0.0;
      
      // Update memory stats (platform dependent)
      _updateMemoryStats();
    }
  }
  
  /// Updates memory statistics
  void _updateMemoryStats() {
    // Platform-specific memory tracking
    // This is a simplified implementation
    // In a real engine, this would use platform-specific APIs
    
    if (options.hasFlag(DsrtEngineFlags.MEMORY_TRACKING)) {
      try {
        // Get memory usage (approximation)
        final process = Process.runSync('ps', ['-o', 'rss=', '-p', '${pid}']);
        if (process.exitCode == 0) {
          final output = process.stdout.toString().trim();
          final memoryKb = int.tryParse(output) ?? 0;
          stats.memoryUsage = memoryKb * 1024;
          stats.peakMemoryUsage = math.max(stats.peakMemoryUsage, stats.memoryUsage);
        }
      } catch (_) {
        // Memory tracking not available on this platform
      }
    }
  }
  
  /// Processes pending operations
  void _processPendingOperations() {
    while (_pendingOperations.isNotEmpty) {
      final operation = _pendingOperations.removeFirst();
      try {
        operation();
      } catch (error, stackTrace) {
        logger.error('Error processing pending operation: $error', stackTrace);
      }
    }
  }
  
  /// Performs fixed update
  void _fixedUpdate(double fixedDeltaTime) {
    for (final subsystem in _subsystems.values) {
      if (subsystem.isRunning) {
        try {
          // Some subsystems might have fixedUpdate methods
          // For now, we just call update with fixed delta time
          subsystem.update(fixedDeltaTime);
        } catch (error, stackTrace) {
          logger.error('Error in fixed update for subsystem ${subsystem.name}: $error', stackTrace);
        }
      }
    }
    
    // Trigger fixed update event
    eventSystem.trigger('engine.fixedUpdate', {
      'fixedDeltaTime': fixedDeltaTime,
      'accumulatedTime': _accumulatedTime,
    });
  }
  
  /// Starts the update loop
  void _startUpdateLoop() {
    if (_updateTimer != null && _updateTimer!.isActive) {
      return;
    }
    
    final updateInterval = options.maxFrameRate > 0
        ? Duration(microseconds: (1000000.0 / options.maxFrameRate).round())
        : Duration.zero;
    
    if (updateInterval > Duration.zero) {
      // Fixed interval update loop
      _updateTimer = Timer.periodic(updateInterval, (_) {
        update();
        render();
      });
    } else {
      // Variable interval update loop (as fast as possible)
      _updateTimer = Timer.periodic(Duration(milliseconds: 1), (_) {
        final frameTime = _frameTimer.elapsedMicroseconds / 1000000.0 - _lastFrameTime;
        if (frameTime >= options.minFrameTime) {
          update();
          render();
        }
      });
    }
  }
  
  /// Stops the update loop
  void _stopUpdateLoop() {
    _updateTimer?.cancel();
    _updateTimer = null;
  }
  
  /// Sets engine state
  void _setState(DsrtEngineState newState) {
    final oldState = _state;
    _state = newState;
    
    // Log state change
    if (options.hasFlag(DsrtEngineFlags.VERBOSE)) {
      logger.debug('Engine state changed: $oldState -> $newState');
    }
    
    // Trigger state change event
    eventSystem.trigger('engine.stateChange', {
      'oldState': oldState.name,
      'newState': newState.name,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }
  
  /// Sets engine error
  void _setError(Object error, StackTrace stackTrace) {
    _lastError = error;
    _lastStackTrace = stackTrace;
    _setState(DsrtEngineState.ERROR);
    
    // Trigger error event
    eventSystem.trigger('engine.error', {
      'error': error.toString(),
      'stackTrace': stackTrace.toString(),
      'timestamp': DateTime.now().toIso8601String(),
    });
  }
  
  /// Gets process ID (platform specific)
  static int get pid => Platform.pid;
}

/// Engine error class
class DsrtEngineError implements Exception {
  /// Error message
  final String message;
  
  /// Underlying error (if any)
  final Object? cause;
  
  /// Stack trace (if any)
  final StackTrace? stackTrace;
  
  /// Creates an engine error
  DsrtEngineError(this.message, [this.cause, this.stackTrace]);
  
  @override
  String toString() {
    final buffer = StringBuffer();
    buffer.write('DsrtEngineError: $message');
    
    if (cause != null) {
      buffer.write('\nCaused by: $cause');
    }
    
    if (stackTrace != null) {
      buffer.write('\n$stackTrace');
    }
    
    return buffer.toString();
  }
}

/// Default engine subsystems
class DsrtCoreSubsystem implements DsrtEngineSubsystem {
  @override
  final String name = 'core';
  
  @override
  final int priority = 1000;
  
  @override
  final bool required = true;
  
  bool _initialized = false;
  bool _running = false;
  
  @override
  Future<void> initialize(DsrtEngine engine) async {
    _initialized = true;
  }
  
  @override
  Future<void> start() async {
    _running = true;
  }
  
  @override
  Future<void> stop() async {
    _running = false;
  }
  
  @override
  void update(double deltaTime) {
    // Core subsystem doesn't need per-frame updates
  }
  
  @override
  void render(double interpolation) {
    // Core subsystem doesn't render
  }
  
  @override
  String get status => _running ? 'Running' : _initialized ? 'Initialized' : 'Uninitialized';
  
  @override
  bool get isInitialized => _initialized;
  
  @override
  bool get isRunning => _running;
  
  @override
  Future<void> dispose() async {
    _initialized = false;
    _running = false;
  }
}

/// Engine utilities
class DsrtEngineUtils {
  /// Creates a minimal engine instance for testing
  static Future<DsrtEngine> createTestEngine({
    DsrtEngineOptions? options,
  }) async {
    final testOptions = options ?? DsrtEngineOptions(
      flags: DsrtEngineFlags.DEBUG | DsrtEngineFlags.VALIDATION,
      maxFrameRate: 30,
    );
    
    final engine = await DsrtEngine.initialize(options: testOptions);
    
    // Register core subsystem
    engine.registerSubsystem(DsrtCoreSubsystem());
    
    return engine;
  }
  
  /// Benchmarks engine performance
  static Future<DsrtEngineStats> benchmark({
    Duration duration = const Duration(seconds: 10),
    DsrtEngineOptions? options,
  }) async {
    final engine = await createTestEngine(options: options);
    
    try {
      await engine.start();
      
      // Wait for benchmark duration
      await Future.delayed(duration);
      
      // Stop engine
      await engine.stop();
      
      return engine.stats;
    } finally {
      await engine.dispose();
    }
  }
  
  /// Validates engine compatibility with current platform
  static Future<DsrtConfigValidationResult> validatePlatform() async {
    final errors = <String>[];
    final warnings = <String>[];
    
    // Check platform
    if (!Platform.isLinux &&
        !Platform.isMacOS &&
        !Platform.isWindows &&
        !Platform.isAndroid &&
        !Platform.isIOS) {
      warnings.add('Platform ${Platform.operatingSystem} is not officially supported');
    }
    
    // Check Dart version
    final dartVersion = Platform.version;
    if (!dartVersion.contains('2.18')) { // Minimum required version
      warnings.add('Dart version $dartVersion may not be fully compatible');
    }
    
    // Check memory
    try {
      // Attempt to allocate a large buffer to test memory availability
      final testBuffer = Uint8List(64 * 1024 * 1024); // 64MB
      testBuffer.fillRange(0, testBuffer.length, 0);
    } catch (_) {
      warnings.add('Limited memory available on this platform');
    }
    
    return DsrtConfigValidationResult(
      isValid: errors.isEmpty,
      errors: errors,
      warnings: warnings,
    );
  }
}
