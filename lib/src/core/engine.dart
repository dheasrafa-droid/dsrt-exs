/// DSRT Engine - Core Engine Implementation
/// Main engine class handling lifecycle, initialization, and core systems.
library dsrt_engine.src.core.engine;

import 'dart:async';
import 'dart:collection';
import 'dart:math' as math;
import 'engine_config.dart';
import 'settings.dart';
import 'events/event_system.dart';
import '../utils/logger.dart';
import '../utils/platform.dart';
import '../utils/disposables.dart';
import '../performance/monitor.dart';
import '../loop/game_loop.dart';
import '../loop/loop_manager.dart';
import '../scene/scene.dart';
import '../renderer/renderer.dart';
import '../camera/camera.dart';

/// Main engine class providing the core functionality of DSRT Engine.
/// 
/// The Engine manages:
/// - Lifecycle (init, update, render, dispose)
/// - Core systems (rendering, scene management, event handling)
/// - Performance monitoring
/// - Platform abstraction
class Engine with Disposable {
  /// Engine version
  static const String version = '1.0.0-alpha';
  
  /// Engine build number
  static const int buildNumber = 1;
  
  /// Engine configuration
  final EngineConfig config;
  
  /// Engine settings
  final Settings settings;
  
  /// Event system for handling engine events
  final EventSystem events;
  
  /// Performance monitor
  final PerformanceMonitor performance;
  
  /// Platform detection utilities
  final PlatformInfo platform;
  
  /// Logger instance
  final Logger logger;
  
  /// Game loop manager
  final LoopManager loopManager;
  
  /// Current game loop
  GameLoop? _currentLoop;
  
  /// Main scene
  Scene? _scene;
  
  /// Active camera
  Camera? _activeCamera;
  
  /// Renderer instance
  Renderer? _renderer;
  
  /// Engine state
  EngineState _state = EngineState.uninitialized;
  
  /// Frame counter
  int _frameCount = 0;
  
  /// Total elapsed time since engine start
  double _elapsedTime = 0.0;
  
  /// Last frame time (for delta calculation)
  double _lastFrameTime = 0.0;
  
  /// Request animation frame ID
  int? _animationFrameId;
  
  /// Engine startup timestamp
  final DateTime _startTime = DateTime.now();
  
  /// Engine initialization completer
  final Completer<void> _initCompleter = Completer<void>();
  
  /// Engine systems registry
  final Map<String, dynamic> _systems = {};
  
  /// Plugins registry
  final Map<String, Disposable> _plugins = {};
  
  /// Engine constructor
  /// 
  /// [config]: Optional engine configuration
  /// [settings]: Optional engine settings
  Engine({
    EngineConfig? config,
    Settings? settings,
  }) : 
    config = config ?? EngineConfig.defaults(),
    settings = settings ?? Settings.defaults(),
    events = EventSystem(),
    performance = PerformanceMonitor(),
    platform = PlatformInfo(),
    logger = Logger('DSRTEngine'),
    loopManager = LoopManager() {
    _setupLogging();
    logger.info('DSRT Engine v$version (build $buildNumber) initializing...');
  }
  
  /// Engine state getter
  EngineState get state => _state;
  
  /// Current scene
  Scene? get scene => _scene;
  
  /// Active camera
  Camera? get activeCamera => _activeCamera;
  
  /// Renderer instance
  Renderer? get renderer => _renderer;
  
  /// Frame counter
  int get frameCount => _frameCount;
  
  /// Elapsed time in seconds
  double get elapsedTime => _elapsedTime;
  
  /// Engine uptime in seconds
  double get uptime => DateTime.now().difference(_startTime).inMilliseconds / 1000.0;
  
  /// Check if engine is running
  bool get isRunning => _state == EngineState.running;
  
  /// Initialize the engine
  /// 
  /// [canvas]: Optional canvas element for rendering
  /// [options]: Additional initialization options
  Future<void> initialize({
    dynamic canvas,
    Map<String, dynamic> options = const {},
  }) async {
    if (_state != EngineState.uninitialized) {
      throw StateError('Engine already initialized (current state: $_state)');
    }
    
    _state = EngineState.initializing;
    logger.info('Engine initialization started');
    
    try {
      // Setup performance monitoring
      performance.enable(config.enableProfiling);
      
      // Initialize platform detection
      await platform.detect();
      
      // Setup game loop
      _setupGameLoop();
      
      // Initialize renderer if canvas is provided
      if (canvas != null) {
        await _initializeRenderer(canvas, options);
      }
      
      // Initialize default systems
      await _initializeSystems();
      
      // Mark initialization complete
      _initCompleter.complete();
      _state = EngineState.ready;
      
      logger.info('Engine initialized successfully');
      logger.info('Platform: ${platform.name} ${platform.version}');
      logger.info('Graphics: ${platform.gpuInfo}');
      
      // Dispatch engine ready event
      events.dispatch(EngineEvent(
        type: EngineEventType.initialized,
        data: {'timestamp': DateTime.now()},
      ));
      
    } catch (error, stackTrace) {
      logger.error('Engine initialization failed: $error', stackTrace);
      _state = EngineState.error;
      _initCompleter.completeError(error, stackTrace);
      rethrow;
    }
  }
  
  /// Start the engine
  void start() {
    if (_state != EngineState.ready) {
      throw StateError('Engine not ready (current state: $_state)');
    }
    
    if (_currentLoop == null) {
      throw StateError('Game loop not initialized');
    }
    
    _state = EngineState.running;
    _lastFrameTime = DateTime.now().millisecondsSinceEpoch / 1000.0;
    
    logger.info('Engine starting...');
    
    // Start the game loop
    _currentLoop!.start();
    
    events.dispatch(EngineEvent(
      type: EngineEventType.started,
      data: {'frameCount': _frameCount},
    ));
  }
  
  /// Stop the engine
  void stop() {
    if (_state != EngineState.running) {
      return;
    }
    
    logger.info('Engine stopping...');
    
    _state = EngineState.stopping;
    
    if (_currentLoop != null) {
      _currentLoop!.stop();
    }
    
    events.dispatch(EngineEvent(
      type: EngineEventType.stopped,
      data: {'frameCount': _frameCount, 'elapsedTime': _elapsedTime},
    ));
    
    _state = EngineState.ready;
  }
  
  /// Set the active scene
  void setScene(Scene newScene) {
    if (_scene != null) {
      // Dispose old scene
      _scene!.dispose();
    }
    
    _scene = newScene;
    
    // Update scene reference in renderer
    if (_renderer != null) {
      _renderer!.scene = newScene;
    }
    
    events.dispatch(EngineEvent(
      type: EngineEventType.sceneChanged,
      data: {'scene': newScene},
    ));
  }
  
  /// Set the active camera
  void setActiveCamera(Camera camera) {
    _activeCamera = camera;
    
    if (_scene != null) {
      _scene!.activeCamera = camera;
    }
    
    if (_renderer != null) {
      _renderer!.camera = camera;
    }
    
    events.dispatch(EngineEvent(
      type: EngineEventType.cameraChanged,
      data: {'camera': camera},
    ));
  }
  
  /// Register a system
  void registerSystem(String name, dynamic system) {
    if (_systems.containsKey(name)) {
      logger.warning('System "$name" already registered, replacing');
    }
    
    _systems[name] = system;
    
    // If system is disposable, track it
    if (system is Disposable) {
      trackDisposable(system);
    }
    
    logger.debug('System "$name" registered');
  }
  
  /// Get a registered system
  T? getSystem<T>(String name) {
    final system = _systems[name];
    return system is T ? system : null;
  }
  
  /// Register a plugin
  void registerPlugin(String name, Disposable plugin) {
    if (_plugins.containsKey(name)) {
      logger.warning('Plugin "$name" already registered, replacing');
    }
    
    _plugins[name] = plugin;
    trackDisposable(plugin);
    
    logger.info('Plugin "$name" registered');
  }
  
  /// Update engine state (called by game loop)
  void update(double deltaTime) {
    if (_state != EngineState.running) {
      return;
    }
    
    performance.beginFrame();
    
    try {
      // Update elapsed time
      final currentTime = DateTime.now().millisecondsSinceEpoch / 1000.0;
      if (_lastFrameTime > 0) {
        deltaTime = currentTime - _lastFrameTime;
      }
      _lastFrameTime = currentTime;
      _elapsedTime += deltaTime;
      _frameCount++;
      
      // Clamp delta time to prevent spiral of death
      deltaTime = math.min(deltaTime, config.maxDeltaTime);
      
      // Dispatch pre-update event
      events.dispatch(EngineEvent(
        type: EngineEventType.preUpdate,
        data: {
          'deltaTime': deltaTime,
          'frameCount': _frameCount,
          'elapsedTime': _elapsedTime,
        },
      ));
      
      // Update scene
      if (_scene != null) {
        _scene!.update(deltaTime);
      }
      
      // Update active camera
      if (_activeCamera != null) {
        _activeCamera!.update(deltaTime);
      }
      
      // Update systems
      for (final system in _systems.values) {
        if (system is Updatable) {
          system.update(deltaTime);
        }
      }
      
      // Update plugins
      for (final plugin in _plugins.values) {
        if (plugin is Updatable) {
          plugin.update(deltaTime);
        }
      }
      
      // Dispatch update event
      events.dispatch(EngineEvent(
        type: EngineEventType.update,
        data: {'deltaTime': deltaTime},
      ));
      
      // Render if renderer is available
      if (_renderer != null && _scene != null && _activeCamera != null) {
        _renderScene(deltaTime);
      }
      
      // Dispatch post-update event
      events.dispatch(EngineEvent(
        type: EngineEventType.postUpdate,
        data: {
          'deltaTime': deltaTime,
          'frameDuration': performance.frameDuration,
        },
      ));
      
    } catch (error, stackTrace) {
      logger.error('Error in engine update: $error', stackTrace);
      
      events.dispatch(EngineEvent(
        type: EngineEventType.error,
        data: {
          'error': error,
          'stackTrace': stackTrace.toString(),
          'phase': 'update',
        },
      ));
      
      // If error is fatal, stop engine
      if (config.stopOnError) {
        stop();
      }
    } finally {
      performance.endFrame();
    }
  }
  
  /// Resize the engine viewport
  void resize(int width, int height) {
    if (_renderer != null) {
      _renderer!.setSize(width, height);
    }
    
    if (_activeCamera != null) {
      if (_activeCamera!.aspect != null) {
        _activeCamera!.aspect = width / height;
        _activeCamera!.updateProjectionMatrix();
      }
    }
    
    events.dispatch(EngineEvent(
      type: EngineEventType.resized,
      data: {'width': width, 'height': height},
    ));
    
    logger.debug('Viewport resized to ${width}x$height');
  }
  
  /// Render a single frame (manual rendering)
  void renderFrame() {
    if (_state != EngineState.ready && _state != EngineState.running) {
      return;
    }
    
    if (_renderer != null && _scene != null && _activeCamera != null) {
      _renderer!.render(_scene!, _activeCamera!);
    }
  }
  
  /// Dispose engine resources
  @override
  void dispose() {
    if (_state == EngineState.disposed) {
      return;
    }
    
    logger.info('Engine disposing...');
    _state = EngineState.disposing;
    
    // Stop engine if running
    if (isRunning) {
      stop();
    }
    
    // Dispose systems
    for (final system in _systems.values) {
      if (system is Disposable) {
        system.dispose();
      }
    }
    _systems.clear();
    
    // Dispose plugins
    for (final plugin in _plugins.values) {
      plugin.dispose();
    }
    _plugins.clear();
    
    // Dispose scene
    if (_scene != null) {
      _scene!.dispose();
      _scene = null;
    }
    
    // Dispose renderer
    if (_renderer != null) {
      _renderer!.dispose();
      _renderer = null;
    }
    
    // Dispose game loop
    if (_currentLoop != null) {
      _currentLoop!.dispose();
      _currentLoop = null;
    }
    
    // Dispose event system
    events.dispose();
    
    // Dispose performance monitor
    performance.dispose();
    
    _state = EngineState.disposed;
    logger.info('Engine disposed');
    
    super.dispose();
  }
  
  // Private methods
  
  /// Setup logging configuration
  void _setupLogging() {
    logger.level = config.logLevel;
    
    // Add engine info to log messages
    logger.formatter = (level, message, error, stackTrace) {
      final time = DateTime.now().toIso8601String();
      final levelStr = level.toString().toUpperCase().padRight(8);
      final prefix = config.logEngineInfo ? '[DSRT] [$time] $levelStr' : '';
      return '$prefix$message${error != null ? '\nError: $error' : ''}${stackTrace != null ? '\n$stackTrace' : ''}';
    };
  }
  
  /// Setup game loop
  void _setupGameLoop() {
    final loopConfig = config.loopConfig;
    
    switch (loopConfig.type) {
      case LoopType.fixed:
        _currentLoop = FixedStepLoop(
          updateCallback: update,
          targetFPS: loopConfig.targetFPS,
          maxUpdatesPerFrame: loopConfig.maxUpdatesPerFrame,
        );
        break;
      case LoopType.variable:
        _currentLoop = VariableStepLoop(
          updateCallback: update,
          targetFPS: loopConfig.targetFPS,
        );
        break;
      default:
        throw ArgumentError('Unsupported loop type: ${loopConfig.type}');
    }
    
    _currentLoop!.onError = (error, stackTrace) {
      logger.error('Game loop error: $error', stackTrace);
      
      events.dispatch(EngineEvent(
        type: EngineEventType.error,
        data: {
          'error': error,
          'stackTrace': stackTrace.toString(),
          'phase': 'gameLoop',
        },
      ));
    };
    
    loopManager.registerLoop('main', _currentLoop!);
    logger.debug('Game loop initialized (${loopConfig.type})');
  }
  
  /// Initialize renderer
  Future<void> _initializeRenderer(dynamic canvas, Map<String, dynamic> options) async {
    logger.info('Initializing renderer...');
    
    // Import renderer implementation based on platform
    // This is a simplified version - actual implementation would conditionally import
    // WebGLRenderer for web, or other renderers for different platforms
    
    try {
      // Dynamically load appropriate renderer
      if (platform.isWeb) {
        // Load WebGL renderer
        // import '../renderer/webgl/webgl_renderer.dart';
        // _renderer = WebGLRenderer(canvas, options);
      } else if (platform.isMobile) {
        // Load OpenGL ES renderer
        // _renderer = GLESRenderer(canvas, options);
      } else {
        // Load desktop renderer
        // _renderer = OpenGLRenderer(canvas, options);
      }
      
      // For now, use a placeholder renderer
      _renderer = PlaceholderRenderer(canvas, options);
      
      await _renderer!.initialize();
      
      // Set renderer size
      final width = options['width'] ?? config.defaultWidth;
      final height = options['height'] ?? config.defaultHeight;
      _renderer!.setSize(width, height);
      
      logger.info('Renderer initialized: ${_renderer!.info}');
      
    } catch (error, stackTrace) {
      logger.error('Failed to initialize renderer: $error', stackTrace);
      throw Exception('Renderer initialization failed: $error');
    }
  }
  
  /// Initialize core systems
  Future<void> _initializeSystems() async {
    logger.debug('Initializing core systems...');
    
    // Initialize performance system
    performance.initialize();
    
    // Initialize other systems here
    // This would include:
    // - Input system
    // - Audio system
    // - Physics system
    // - etc.
    
    // Register event listeners for core events
    _setupEventListeners();
    
    logger.debug('Core systems initialized');
  }
  
  /// Setup event listeners for core events
  void _setupEventListeners() {
    events.on<EngineEvent>((event) {
      if (event.type == EngineEventType.error) {
        // Handle engine errors
        logger.error('Engine error: ${event.data['error']}');
      }
    });
  }
  
  /// Render the current scene
  void _renderScene(double deltaTime) {
    performance.beginOperation('render');
    
    try {
      // Dispatch pre-render event
      events.dispatch(EngineEvent(
        type: EngineEventType.preRender,
        data: {
          'deltaTime': deltaTime,
          'scene': _scene,
          'camera': _activeCamera,
        },
      ));
      
      // Render the scene
      _renderer!.render(_scene!, _activeCamera!);
      
      // Dispatch post-render event
      events.dispatch(EngineEvent(
        type: EngineEventType.postRender,
        data: {'frameNumber': _frameCount},
      ));
      
    } catch (error, stackTrace) {
      logger.error('Render error: $error', stackTrace);
      
      events.dispatch(EngineEvent(
        type: EngineEventType.error,
        data: {
          'error': error,
          'stackTrace': stackTrace.toString(),
          'phase': 'render',
        },
      ));
    } finally {
      performance.endOperation('render');
    }
  }
}

/// Engine state enum
enum EngineState {
  uninitialized,
  initializing,
  ready,
  running,
  stopping,
  paused,
  error,
  disposing,
  disposed,
}

/// Engine event types
enum EngineEventType {
  initialized,
  started,
  stopped,
  paused,
  resumed,
  preUpdate,
  update,
  postUpdate,
  preRender,
  postRender,
  resized,
  sceneChanged,
  cameraChanged,
  error,
}

/// Engine event data
class EngineEvent {
  final EngineEventType type;
  final Map<String, dynamic> data;
  final DateTime timestamp;
  
  EngineEvent({
    required this.type,
    this.data = const {},
  }) : timestamp = DateTime.now();
}

/// Interface for updatable objects
abstract class Updatable {
  void update(double deltaTime);
}

/// Placeholder renderer (to be replaced with actual implementation)
class PlaceholderRenderer extends Renderer {
  PlaceholderRenderer(super.canvas, super.options);
  
  @override
  Future<void> initialize() async {
    // No-op for placeholder
  }
  
  @override
  void render(Scene scene, Camera camera) {
    // No-op for placeholder
  }
  
  @override
  void setSize(int width, int height) {
    // No-op for placeholder
  }
  
  @override
  void dispose() {
    // No-op for placeholder
  }
}
