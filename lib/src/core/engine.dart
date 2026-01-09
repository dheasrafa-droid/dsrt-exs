/// Core Engine class - manages the entire engine lifecycle
/// 
/// The engine follows a strict initialization order:
/// 1. Constructor with config
/// 2. init() - sets up all systems
/// 3. start() - begins the game loop
/// 4. stop() - stops the game loop
/// 5. dispose() - cleans up all resources
/// 
/// @license MIT
/// @copyright (c) 2024 DSRT Engine

import 'dart:async';
import 'engine_config.dart';
import 'loop/game_loop.dart';
import 'events/event_system.dart';
import '../utils/logger.dart';
import '../utils/disposables.dart';

/// Main engine class implementing the Disposable interface
class ExsEngine implements ExsDisposable {
  /// Engine configuration
  final ExsEngineConfig config;
  
  /// Event system for engine-wide events
  final ExsEventSystem events;
  
  /// Game loop controller
  final ExsGameLoop _loop;
  
  /// Logger instance
  final ExsLogger _logger;
  
  /// Engine state flags
  bool _isInitialized = false;
  bool _isRunning = false;
  bool _isDisposed = false;
  
  /// Engine start time
  DateTime? _startTime;
  
  /// Engine constructor
  ExsEngine(this.config) 
    : events = ExsEventSystem(),
      _loop = ExsGameLoop(),
      _logger = ExsLogger('ExsEngine') {
    _logger.info('Engine instance created with config: ${config.name}');
  }
  
  /// Initialize all engine systems
  Future<void> init() async {
    if (_isInitialized) {
      _logger.warning('Engine already initialized');
      return;
    }
    
    try {
      _logger.info('Initializing engine...');
      
      // Initialize subsystems
      await _loop.init();
      
      _isInitialized = true;
      _startTime = DateTime.now();
      
      events.dispatch(ExsEvent(ExsEventType.engineInit));
      _logger.info('Engine initialized successfully');
    } catch (e, stackTrace) {
      _logger.error('Failed to initialize engine: $e', stackTrace);
      rethrow;
    }
  }
  
  /// Start the engine game loop
  void start() {
    if (!_isInitialized) {
      throw StateError('Engine must be initialized before starting');
    }
    
    if (_isRunning) {
      _logger.warning('Engine already running');
      return;
    }
    
    _logger.info('Starting engine...');
    _loop.start((double deltaTime) {
      // Update all systems
      _update(deltaTime);
    });
    
    _isRunning = true;
    events.dispatch(ExsEvent(ExsEventType.engineStart));
    _logger.info('Engine started');
  }
  
  /// Stop the engine game loop
  void stop() {
    if (!_isRunning) {
      _logger.warning('Engine not running');
      return;
    }
    
    _logger.info('Stopping engine...');
    _loop.stop();
    _isRunning = false;
    events.dispatch(ExsEvent(ExsEventType.engineStop));
    _logger.info('Engine stopped');
  }
  
  /// Main update method called by game loop
  void _update(double deltaTime) {
    events.dispatch(ExsEvent(ExsEventType.engineUpdate, data: deltaTime));
    
    // Update profiling if enabled
    if (config.enableProfiling) {
      // Profiling update logic would go here
    }
  }
  
  /// Get engine uptime in seconds
  double get uptime {
    if (_startTime == null) return 0.0;
    return DateTime.now().difference(_startTime!).inMilliseconds / 1000.0;
  }
  
  /// Check if engine is running
  bool get isRunning => _isRunning;
  
  /// Check if engine is initialized
  bool get isInitialized => _isInitialized;
  
  @override
  void dispose() {
    if (_isDisposed) return;
    
    _logger.info('Disposing engine...');
    
    stop();
    
    // Dispose subsystems
    _loop.dispose();
    events.dispose();
    
    _isDisposed = true;
    _isInitialized = false;
    
    events.dispatch(ExsEvent(ExsEventType.engineDispose));
    _logger.info('Engine disposed');
  }
  
  @override
  bool get isDisposed => _isDisposed;
}
