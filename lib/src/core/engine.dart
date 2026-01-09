/// Main engine implementation for DSRT Engine
/// 
/// Core engine class that initializes, manages, and coordinates all
/// subsystems including rendering, physics, audio, and scene management.
/// 
/// [config]: Engine configuration parameters.
/// [canvas]: Optional HTML canvas element for WebGL rendering.
part of dsrt_engine.core.internal;

/// Main engine class implementing the public IEngine interface
/// 
/// This class is the central coordinator for all engine subsystems.
/// Users interact with the engine through this class for initialization,
/// updates, and resource management.
/// 
/// Example:
/// ```dart
/// final engine = DsrtEngine(
///   config: EngineConfig.defaultConfig(),
///   canvas: html.querySelector('#canvas'),
/// );
/// await engine.initialize();
/// engine.start();
/// ```
class DsrtEngine implements IEngine {
  /// Engine configuration
  final EngineConfig _config;
  
  /// Internal engine state
  EngineState _state = EngineState.uninitialized;
  
  /// Event system for engine-wide events
  final EventSystem _eventSystem;
  
  /// Performance profiler
  final Profiler _profiler;
  
  /// Logger instance
  final Logger _logger;
  
  /// Game loop controller
  final GameLoop _gameLoop;
  
  /// Scene manager
  final Scene _scene;
  
  /// Renderer instance
  final Renderer? _renderer;
  
  /// Physics world
  final PhysicsWorld? _physicsWorld;
  
  /// Audio context
  final AudioContext? _audioContext;
  
  /// UI manager
  final UIManager? _uiManager;
  
  /// Plugin manager
  final PluginManager _pluginManager;
  
  /// Resource loading manager
  final LoadingManager _loadingManager;
  
  /// Engine start time
  final DateTime _startTime = DateTime.now();
  
  /// Frame counter
  int _frameCount = 0;
  
  /// Last frame time
  double _lastFrameTime = 0;
  
  /// Delta time accumulator
  double _deltaTimeAccumulator = 0;
  
  /// Fixed timestep for physics
  static const double _fixedTimeStep = 1.0 / 60.0; // 60 FPS
  
  /// Creates a new DSRT Engine instance
  /// 
  /// [config]: Engine configuration settings. If null, default
  /// configuration will be used.
  /// [canvas]: Optional canvas element for WebGL rendering. Required
  /// for WebGL backend.
  /// 
  /// Throws [EngineConfigurationError] if configuration is invalid.
  DsrtEngine({
    EngineConfig? config,
    dynamic canvas,
  })  : _config = config ?? EngineConfig.defaultConfig(),
        _eventSystem = EventSystem(),
        _profiler = Profiler(),
        _logger = Logger('DsrtEngine'),
        _gameLoop = GameLoop(),
        _scene = Scene(),
        _pluginManager = PluginManager(),
        _loadingManager = LoadingManager() {
    
    _validateConfiguration();
    _initializeSubsystems(canvas);
    _setupEventListeners();
    
    _logger.info('Engine instance created with config: $_config');
  }
  
  /// Validates engine configuration
  /// 
  /// Checks for invalid configuration combinations and platform
  /// compatibility issues.
  /// 
  /// Throws [EngineConfigurationError] if configuration is invalid.
  void _validateConfiguration() {
    if (_config.renderBackend == RenderBackend.webgl &&
        !PlatformUtils.supportsWebGL) {
      throw EngineConfigurationError(
        'WebGL backend requested but not supported on this platform',
        errorCode: ErrorCode.webglNotSupported,
      );
    }
    
    if (_config.maxTextureSize > PlatformUtils.maxTextureSize) {
      _logger.warning(
        'Requested max texture size (${_config.maxTextureSize}) '
        'exceeds platform limit (${PlatformUtils.maxTextureSize})',
      );
    }
    
    if (_config.physicsEnabled && 
        _config.physicsBackend == PhysicsBackend.bullet &&
        !PlatformUtils.supportsWasm) {
      throw EngineConfigurationError(
        'Bullet physics requires WASM support',
        errorCode: ErrorCode.wasmNotSupported,
      );
    }
  }
  
  /// Initializes engine subsystems
  /// 
  /// [canvas]: Optional canvas element for rendering.
  void _initializeSubsystems(dynamic canvas) {
    _profiler.startSection('EngineInitialization');
    
    try {
      // Initialize renderer based on backend
      if (_config.renderEnabled) {
        _renderer = _createRenderer(canvas);
      }
      
      // Initialize physics world
      if (_config.physicsEnabled) {
        _physicsWorld = PhysicsWorld(
          config: _config.physicsConfig,
          gravity: _config.gravity,
        );
      }
      
      // Initialize audio context
      if (_config.audioEnabled) {
        _audioContext = AudioContext(
          sampleRate: _config.audioSampleRate,
          channels: _config.audioChannels,
        );
      }
      
      // Initialize UI manager
      if (_config.uiEnabled) {
        _uiManager = UIManager(
          renderMode: _config.uiRenderMode,
          resolution: _config.uiResolution,
        );
      }
      
      // Initialize plugins
      _pluginManager.initialize(_config.plugins);
      
      // Set up game loop callbacks
      _gameLoop.onUpdate = _onUpdate;
      _gameLoop.onRender = _onRender;
      _gameLoop.onFixedUpdate = _onFixedUpdate;
      
      _profiler.endSection('EngineInitialization');
      _logger.info('Engine subsystems initialized successfully');
      
    } catch (error, stackTrace) {
      _profiler.endSection('EngineInitialization');
      _logger.error('Failed to initialize engine subsystems', error, stackTrace);
      rethrow;
    }
  }
  
  /// Creates the appropriate renderer based on configuration
  /// 
  /// [canvas]: Canvas element for WebGL rendering.
  /// Returns: Configured renderer instance.
  /// 
  /// Throws [RendererCreationError] if renderer cannot be created.
  Renderer _createRenderer(dynamic canvas) {
    _profiler.startSection('RendererCreation');
    
    try {
      final renderer = switch (_config.renderBackend) {
        RenderBackend.webgl => WebGLRenderer(
            canvas: canvas,
            options: WebGLRendererOptions(
              antialias: _config.antialias,
              alpha: _config.alpha,
              depth: _config.depth,
              stencil: _config.stencil,
              preserveDrawingBuffer: _config.preserveDrawingBuffer,
              powerPreference: _config.powerPreference,
            ),
          ),
        RenderBackend.webgpu => WebGPURenderer(
            canvas: canvas,
            options: WebGPURendererOptions(
              powerPreference: _config.powerPreference,
            ),
          ),
        RenderBackend.software => SoftwareRenderer(
            canvas: canvas,
            options: SoftwareRendererOptions(
              resolution: _config.resolution,
            ),
          ),
        _ => throw RendererCreationError(
            'Unsupported render backend: ${_config.renderBackend}',
            errorCode: ErrorCode.unsupportedBackend,
          ),
      };
      
      _profiler.endSection('RendererCreation');
      return renderer;
      
    } catch (error, stackTrace) {
      _profiler.endSection('RendererCreation');
      _logger.error('Failed to create renderer', error, stackTrace);
      rethrow;
    }
  }
  
  /// Sets up engine event listeners
  void _setupEventListeners() {
    // Engine lifecycle events
    _eventSystem.addEventListener(EventType.engineInitialized, (event) {
      _logger.info('Engine initialized successfully');
    });
    
    _eventSystem.addEventListener(EventType.engineStarted, (event) {
      _logger.info('Engine started');
    });
    
    _eventSystem.addEventListener(EventType.engineStopped, (event) {
      _logger.info('Engine stopped');
    });
    
    _eventSystem.addEventListener(EventType.engineDisposed, (event) {
      _logger.info('Engine disposed');
    });
    
    // Error events
    _eventSystem.addEventListener(EventType.engineError, (event) {
      final errorEvent = event as EngineErrorEvent;
      _logger.error('Engine error: ${errorEvent.message}', errorEvent.error);
    });
    
    // Performance events
    _eventSystem.addEventListener(EventType.performanceWarning, (event) {
      final perfEvent = event as PerformanceEvent;
      _logger.warning('Performance warning: ${perfEvent.metric} = ${perfEvent.value}');
    });
  }
  
  /// Initializes the engine and all subsystems
  /// 
  /// This method must be called before starting the engine. It performs
  /// asynchronous initialization of all subsystems including renderer,
  /// physics, audio, and plugins.
  /// 
  /// [configOverrides]: Optional configuration overrides to apply
  /// during initialization.
  /// 
  /// Returns: Future that completes when initialization is done.
  /// Returns true if initialization was successful.
  /// 
  /// Throws [EngineInitializationError] if initialization fails.
  @override
  Future<bool> initialize({Map<String, dynamic>? configOverrides}) async {
    if (_state != EngineState.uninitialized) {
      throw EngineInitializationError(
        'Engine is already initialized',
        currentState: _state,
      );
    }
    
    _profiler.startSection('EngineInitialize');
    _state = EngineState.initializing;
    
    try {
      _logger.info('Starting engine initialization...');
      
      // Apply configuration overrides
      if (configOverrides != null) {
        _config.applyOverrides(configOverrides);
      }
      
      // Initialize renderer
      if (_renderer != null) {
        await _renderer!.initialize();
        _logger.debug('Renderer initialized');
      }
      
      // Initialize physics
      if (_physicsWorld != null) {
        await _physicsWorld!.initialize();
        _logger.debug('Physics world initialized');
      }
      
      // Initialize audio
      if (_audioContext != null) {
        await _audioContext!.initialize();
        _logger.debug('Audio context initialized');
      }
      
      // Initialize UI
      if (_uiManager != null) {
        await _uiManager!.initialize();
        _logger.debug('UI manager initialized');
      }
      
      // Initialize plugins
      await _pluginManager.loadPlugins();
      _logger.debug('Plugins loaded');
      
      // Set up default scene
      await _scene.initialize();
      _logger.debug('Default scene created');
      
      // Update state
      _state = EngineState.initialized;
      
      // Notify listeners
      _eventSystem.dispatchEvent(EngineEvent(
        type: EventType.engineInitialized,
        timestamp: DateTime.now().millisecondsSinceEpoch,
      ));
      
      _profiler.endSection('EngineInitialize');
      _logger.info('Engine initialization complete');
      
      return true;
      
    } catch (error, stackTrace) {
      _profiler.endSection('EngineInitialize');
      _state = EngineState.error;
      
      _logger.error('Engine initialization failed', error, stackTrace);
      
      _eventSystem.dispatchEvent(EngineErrorEvent(
        message: 'Initialization failed: $error',
        error: error,
        stackTrace: stackTrace,
      ));
      
      throw EngineInitializationError(
        'Failed to initialize engine: $error',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }
  
  /// Starts the engine main loop
  /// 
  /// Begins the game loop which calls update and render methods.
  /// Engine must be initialized before calling this method.
  /// 
  /// [targetFPS]: Target frames per second. If null, uses vsync.
  /// 
  /// Throws [EngineStateError] if engine is not initialized.
  @override
  void start({double? targetFPS}) {
    if (_state != EngineState.initialized) {
      throw EngineStateError(
        'Engine must be initialized before starting',
        expectedState: EngineState.initialized,
        actualState: _state,
      );
    }
    
    _profiler.startSection('EngineStart');
    
    // Configure game loop
    if (targetFPS != null) {
      _gameLoop.setTargetFPS(targetFPS);
    }
    
    // Start game loop
    _gameLoop.start();
    
    // Update state
    _state = EngineState.running;
    
    // Reset frame timing
    _lastFrameTime = _gameLoop.currentTime;
    _deltaTimeAccumulator = 0;
    _frameCount = 0;
    
    // Notify listeners
    _eventSystem.dispatchEvent(EngineEvent(
      type: EventType.engineStarted,
      timestamp: DateTime.now().millisecondsSinceEpoch,
    ));
    
    _profiler.endSection('EngineStart');
    _logger.info('Engine started');
  }
  
  /// Stops the engine main loop
  /// 
  /// Pauses the game loop and stops updates/rendering.
  /// Engine can be restarted after stopping.
  @override
  void stop() {
    if (_state != EngineState.running) {
      _logger.warning('Attempted to stop engine that is not running');
      return;
    }
    
    _profiler.startSection('EngineStop');
    
    // Stop game loop
    _gameLoop.stop();
    
    // Update state
    _state = EngineState.stopped;
    
    // Notify listeners
    _eventSystem.dispatchEvent(EngineEvent(
      type: EventType.engineStopped,
      timestamp: DateTime.now().millisecondsSinceEpoch,
    ));
    
    _profiler.endSection('EngineStop');
    _logger.info('Engine stopped');
  }
  
  /// Pauses the engine
  /// 
  /// Temporarily pauses updates while keeping renderer alive.
  @override
  void pause() {
    if (_state != EngineState.running) {
      return;
    }
    
    _gameLoop.pause();
    _state = EngineState.paused;
    
    _eventSystem.dispatchEvent(EngineEvent(
      type: EventType.enginePaused,
      timestamp: DateTime.now().millisecondsSinceEpoch,
    ));
    
    _logger.info('Engine paused');
  }
  
  /// Resumes the engine from paused state
  @override
  void resume() {
    if (_state != EngineState.paused) {
      return;
    }
    
    _gameLoop.resume();
    _state = EngineState.running;
    
    _eventSystem.dispatchEvent(EngineEvent(
      type: EventType.engineResumed,
      timestamp: DateTime.now().millisecondsSinceEpoch,
    ));
    
    _logger.info('Engine resumed');
  }
  
  /// Game loop update callback
  /// 
  /// [deltaTime]: Time since last update in seconds.
  /// [time]: Current game time in seconds.
  void _onUpdate(double deltaTime, double time) {
    _profiler.startSection('EngineUpdate');
    
    // Update frame timing
    _deltaTimeAccumulator += deltaTime;
    _lastFrameTime = time;
    _frameCount++;
    
    try {
      // Update plugins
      _pluginManager.update(deltaTime);
      
      // Update scene
      _scene.update(deltaTime);
      
      // Update physics (variable timestep updates)
      if (_physicsWorld != null) {
        _physicsWorld!.update(deltaTime);
      }
      
      // Update audio
      if (_audioContext != null) {
        _audioContext!.update(deltaTime);
      }
      
      // Update UI
      if (_uiManager != null) {
        _uiManager!.update(deltaTime);
      }
      
      // Dispatch update event
      _eventSystem.dispatchEvent(EngineUpdateEvent(
        deltaTime: deltaTime,
        time: time,
        frameCount: _frameCount,
      ));
      
      _profiler.endSection('EngineUpdate');
      
    } catch (error, stackTrace) {
      _profiler.endSection('EngineUpdate');
      _logger.error('Error in engine update', error, stackTrace);
      
      _eventSystem.dispatchEvent(EngineErrorEvent(
        message: 'Update error: $error',
        error: error,
        stackTrace: stackTrace,
      ));
    }
  }
  
  /// Fixed update callback for physics
  /// 
  /// [deltaTime]: Fixed time step for physics simulation.
  void _onFixedUpdate(double deltaTime) {
    _profiler.startSection('EngineFixedUpdate');
    
    try {
      // Fixed physics update
      if (_physicsWorld != null) {
        _physicsWorld!.fixedUpdate(deltaTime);
      }
      
      // Dispatch fixed update event
      _eventSystem.dispatchEvent(EngineFixedUpdateEvent(
        deltaTime: deltaTime,
      ));
      
      _profiler.endSection('EngineFixedUpdate');
      
    } catch (error, stackTrace) {
      _profiler.endSection('EngineFixedUpdate');
      _logger.error('Error in engine fixed update', error, stackTrace);
    }
  }
  
  /// Game loop render callback
  /// 
  /// [alpha]: Interpolation factor for frame smoothing.
  void _onRender(double alpha) {
    _profiler.startSection('EngineRender');
    
    try {
      // Update performance metrics
      _profiler.recordMetric('fps', _gameLoop.currentFPS);
      _profiler.recordMetric('frameTime', _gameLoop.frameTime);
      
      // Render scene
      if (_renderer != null && _scene.needsRender) {
        _renderer!.render(_scene, alpha);
      }
      
      // Render UI
      if (_uiManager != null && _uiManager!.needsRender) {
        _uiManager!.render(_renderer);
      }
      
      // Dispatch render event
      _eventSystem.dispatchEvent(EngineRenderEvent(
        alpha: alpha,
        frameCount: _frameCount,
      ));
      
      _profiler.endSection('EngineRender');
      
    } catch (error, stackTrace) {
      _profiler.endSection('EngineRender');
      _logger.error('Error in engine render', error, stackTrace);
      
      _eventSystem.dispatchEvent(EngineErrorEvent(
        message: 'Render error: $error',
        error: error,
        stackTrace: stackTrace,
      ));
    }
  }
  
  /// Gets the current engine state
  @override
  EngineState get state => _state;
  
  /// Gets the engine configuration
  @override
  EngineConfig get config => _config;
  
  /// Gets the main scene
  @override
  Scene get scene => _scene;
  
  /// Gets the renderer (if enabled)
  @override
  Renderer? get renderer => _renderer;
  
  /// Gets the physics world (if enabled)
  @override
  PhysicsWorld? get physicsWorld => _physicsWorld;
  
  /// Gets the audio context (if enabled)
  @override
  AudioContext? get audioContext => _audioContext;
  
  /// Gets the UI manager (if enabled)
  @override
  UIManager? get uiManager => _uiManager;
  
  /// Gets the plugin manager
  @override
  PluginManager get pluginManager => _pluginManager;
  
  /// Gets the event system
  @override
  EventSystem get eventSystem => _eventSystem;
  
  /// Gets the performance profiler
  @override
  Profiler get profiler => _profiler;
  
  /// Gets the logger
  @override
  Logger get logger => _logger;
  
  /// Gets the current frame count
  @override
  int get frameCount => _frameCount;
  
  /// Gets the engine uptime in seconds
  @override
  double get uptime => (DateTime.now().difference(_startTime)).inMilliseconds / 1000.0;
  
  /// Gets the current FPS
  @override
  double get fps => _gameLoop.currentFPS;
  
  /// Gets the average frame time in milliseconds
  @override
  double get averageFrameTime => _gameLoop.averageFrameTime;
  
  /// Sets the engine time scale
  /// 
  /// [scale]: Time scale factor. 1.0 = normal, 0.5 = half speed,
  /// 2.0 = double speed.
  @override
  void setTimeScale(double scale) {
    if (scale <= 0) {
      throw ArgumentError('Time scale must be greater than 0');
    }
    
    _gameLoop.timeScale = scale;
    _logger.debug('Time scale set to $scale');
  }
  
  /// Resizes the engine viewport
  /// 
  /// [width]: New width in pixels.
  /// [height]: New height in pixels.
  /// [updateStyle]: Whether to update CSS style of canvas.
  @override
  void resize(int width, int height, {bool updateStyle = true}) {
    if (width <= 0 || height <= 0) {
      throw ArgumentError('Width and height must be positive');
    }
    
    _profiler.startSection('EngineResize');
    
    try {
      // Resize renderer
      if (_renderer != null) {
        _renderer!.setSize(width, height, updateStyle);
      }
      
      // Resize UI
      if (_uiManager != null) {
        _uiManager!.setSize(width, height);
      }
      
      // Update configuration
      _config.resolution = Resolution(width, height);
      
      // Dispatch resize event
      _eventSystem.dispatchEvent(EngineResizeEvent(
        width: width,
        height: height,
      ));
      
      _profiler.endSection('EngineResize');
      _logger.debug('Engine resized to ${width}x$height');
      
    } catch (error, stackTrace) {
      _profiler.endSection('EngineResize');
      _logger.error('Error resizing engine', error, stackTrace);
      rethrow;
    }
  }
  
  /// Takes a screenshot of the current view
  /// 
  /// [format]: Image format (png, jpeg, webp).
  /// [quality]: Quality for lossy formats (0.0 to 1.0).
  /// 
  /// Returns: Future with image data URL.
  @override
  Future<String> screenshot({
    ImageFormat format = ImageFormat.png,
    double quality = 1.0,
  }) async {
    if (_renderer == null) {
      throw EngineStateError('Renderer not available for screenshot');
    }
    
    return await _renderer!.screenshot(format: format, quality: quality);
  }
  
  /// Disposes engine resources
  /// 
  /// Releases all resources and stops all subsystems.
  /// Engine cannot be used after disposal.
  @override
  Future<void> dispose() async {
    if (_state == EngineState.disposed) {
      return;
    }
    
    _profiler.startSection('EngineDispose');
    _state = EngineState.disposing;
    
    _logger.info('Disposing engine...');
    
    try {
      // Stop game loop
      if (_gameLoop.isRunning) {
        _gameLoop.stop();
      }
      
      // Dispose subsystems in reverse order
      final futures = <Future>[];
      
      if (_uiManager != null) {
        futures.add(_uiManager!.dispose());
      }
      
      if (_audioContext != null) {
        futures.add(_audioContext!.dispose());
      }
      
      if (_physicsWorld != null) {
        futures.add(_physicsWorld!.dispose());
      }
      
      if (_renderer != null) {
        futures.add(_renderer!.dispose());
      }
      
      // Dispose scene
      futures.add(_scene.dispose());
      
      // Dispose plugins
      futures.add(_pluginManager.dispose());
      
      // Wait for all disposals
      await Future.wait(futures);
      
      // Clear event listeners
      _eventSystem.clear();
      
      // Update state
      _state = EngineState.disposed;
      
      // Notify listeners
      _eventSystem.dispatchEvent(EngineEvent(
        type: EventType.engineDisposed,
        timestamp: DateTime.now().millisecondsSinceEpoch,
      ));
      
      _profiler.endSection('EngineDispose');
      _logger.info('Engine disposed successfully');
      
    } catch (error, stackTrace) {
      _profiler.endSection('EngineDispose');
      _state = EngineState.error;
      
      _logger.error('Error disposing engine', error, stackTrace);
      
      _eventSystem.dispatchEvent(EngineErrorEvent(
        message: 'Disposal error: $error',
        error: error,
        stackTrace: stackTrace,
      ));
      
      rethrow;
    }
  }
}

/// Engine state enumeration
enum EngineState {
  /// Engine has not been initialized
  uninitialized,
  
  /// Engine is currently initializing
  initializing,
  
  /// Engine is initialized and ready
  initialized,
  
  /// Engine is running (game loop active)
  running,
  
  /// Engine is paused
  paused,
  
  /// Engine is stopped
  stopped,
  
  /// Engine is currently disposing resources
  disposing,
  
  /// Engine has been disposed
  disposed,
  
  /// Engine is in error state
  error,
}

/// Engine-specific error types
class EngineError extends Error {
  final String message;
  final ErrorCode errorCode;
  final dynamic data;
  
  EngineError(this.message, {this.errorCode = ErrorCode.unknown, this.data});
  
  @override
  String toString() => 'EngineError: $message (code: $errorCode)';
}

class EngineConfigurationError extends EngineError {
  EngineConfigurationError(String message, {super.errorCode, super.data})
      : super(message);
}

class EngineInitializationError extends EngineError {
  final EngineState? currentState;
  
  EngineInitializationError(
    String message, {
    super.errorCode,
    dynamic error,
    StackTrace? stackTrace,
    this.currentState,
  }) : super(message, data: {
          'error': error,
          'stackTrace': stackTrace,
          'currentState': currentState,
        });
}

class EngineStateError extends EngineError {
  final EngineState? expectedState;
  final EngineState? actualState;
  
  EngineStateError(
    String message, {
    this.expectedState,
    this.actualState,
    super.errorCode,
  }) : super(message, data: {
          'expectedState': expectedState,
          'actualState': actualState,
        });
}

class RendererCreationError extends EngineError {
  RendererCreationError(String message, {super.errorCode, super.data})
      : super(message);
}
