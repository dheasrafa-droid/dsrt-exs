/// Main engine class that manages the entire rendering pipeline and game loop.
/// 
/// The Engine is the central orchestrator that coordinates all subsystems:
/// - Rendering pipeline
/// - Game loop and timing
/// - Event system
/// - Resource management
/// - Plugin system
/// 
/// ## Usage
/// 
/// ```dart
/// final engine = Engine(
///   config: EngineConfig(
///     renderer: RendererType.webgl,
///     antialias: true,
///     alpha: false,
///   ),
/// );
/// 
/// // Initialize the engine
/// await engine.initialize();
/// 
/// // Create a scene
/// final scene = Scene();
/// 
/// // Set the camera
/// final camera = PerspectiveCamera(
///   fov: 75,
///   aspect: width / height,
///   near: 0.1,
///   far: 1000,
/// );
/// 
/// // Start the rendering loop
/// engine.start(scene, camera);
/// ```
/// 
/// ## Lifecycle
/// 
/// 1. **initialize()**: Sets up all subsystems
/// 2. **start()**: Begins the game loop
/// 3. **update()**: Called every frame (physics, logic)
/// 4. **render()**: Renders the current scene
/// 5. **stop()**: Stops the engine and cleans up resources
/// 
/// @category Core
/// @see [EngineConfig] for configuration options
/// @see [GameLoop] for the game loop implementation
/// @see [Renderer] for rendering details
class Engine {
  /// Creates a new Engine instance.
  /// 
  /// @param config The engine configuration. If not provided, defaults are used.
  /// @param canvas The HTML canvas element for WebGL rendering (web only).
  ///               For Flutter, use the `Texture` widget.
  /// 
  /// @throws EngineException if initialization fails
  Engine({EngineConfig? config, dynamic canvas});
  
  /// Initializes all engine subsystems.
  /// 
  /// This method must be called before starting the engine.
  /// It initializes:
  /// - Renderer (WebGL/WebGPU)
  /// - Event system
  /// - Audio context
  /// - Plugin system
  /// - Resource managers
  /// 
  /// @returns Future that completes when initialization is done
  /// @throws EngineException if any subsystem fails to initialize
  Future<void> initialize();
  
  /// Starts the engine with the given scene and camera.
  /// 
  /// @param scene The main scene to render
  /// @param camera The camera to use for rendering
  /// @returns Future that completes when the engine starts
  Future<void> start(Scene scene, Camera camera);
  
  /// Stops the engine and cleans up all resources.
  /// 
  /// This method should be called when the application is closing
  /// to properly dispose of WebGL contexts, audio contexts, and other resources.
  void stop();
  
  /// Gets the current frame rate.
  /// 
  /// @returns Current FPS as a double
  double get fps;
  
  /// Gets the delta time since the last frame.
  /// 
  /// @returns Delta time in seconds
  double get deltaTime;
  
  /// Gets the total elapsed time since engine start.
  /// 
  /// @returns Elapsed time in seconds
  double get elapsedTime;
  
  /// Gets the current renderer instance.
  /// 
  /// @returns The active renderer
  Renderer get renderer;
  
  /// Gets the current scene.
  /// 
  /// @returns The active scene
  Scene get scene;
  
  /// Gets the current camera.
  /// 
  /// @returns The active camera
  Camera get camera;
}
