/// Engine event types
/// 
/// Defines all event types used throughout the engine.
/// Events are categorized by system for organization.
/// 
/// @license MIT
/// @copyright (c) 2024 DSRT Engine

/// Engine lifecycle events
enum ExsEngineEvent {
  /// Engine initialization started
  engineInit,
  
  /// Engine initialization completed
  engineInitComplete,
  
  /// Engine started
  engineStart,
  
  /// Engine stopped
  engineStop,
  
  /// Engine paused
  enginePause,
  
  /// Engine resumed
  engineResume,
  
  /// Engine disposing
  engineDispose,
  
  /// Engine disposed
  engineDisposed,
  
  /// Engine update (frame)
  engineUpdate,
  
  /// Engine render (frame)
  engineRender,
  
  /// Engine pre-update
  enginePreUpdate,
  
  /// Engine post-update
  enginePostUpdate,
  
  /// Engine pre-render
  enginePreRender,
  
  /// Engine post-render
  enginePostRender,
}

/// Scene events
enum ExsSceneEvent {
  /// Scene created
  sceneCreated,
  
  /// Scene disposed
  sceneDisposed,
  
  /// Object added to scene
  objectAdded,
  
  /// Object removed from scene
  objectRemoved,
  
  /// Scene cleared
  sceneCleared,
  
  /// Scene pre-update
  scenePreUpdate,
  
  /// Scene post-update
  scenePostUpdate,
  
  /// Scene pre-render
  scenePreRender,
  
  /// Scene post-render
  scenePostRender,
}

/// Object events
enum ExsObjectEvent {
  /// Object created
  objectCreated,
  
  /// Object disposed
  objectDisposed,
  
  /// Object updated
  objectUpdated,
  
  /// Object transform changed
  transformChanged,
  
  /// Object visibility changed
  visibilityChanged,
  
  /// Object selected
  objectSelected,
  
  /// Object deselected
  objectDeselected,
  
  /// Object clicked
  objectClicked,
  
  /// Object hovered
  objectHovered,
  
  /// Object unhovered
  objectUnhovered,
}

/// Camera events
enum ExsCameraEvent {
  /// Camera created
  cameraCreated,
  
  /// Camera disposed
  cameraDisposed,
  
  /// Camera position changed
  cameraPositionChanged,
  
  /// Camera rotation changed
  cameraRotationChanged,
  
  /// Camera projection changed
  cameraProjectionChanged,
  
  /// Camera frustum changed
  cameraFrustumChanged,
  
  /// Camera activated
  cameraActivated,
  
  /// Camera deactivated
  cameraDeactivated,
}

/// Renderer events
enum ExsRendererEvent {
  /// Renderer created
  rendererCreated,
  
  /// Renderer disposed
  rendererDisposed,
  
  /// Renderer initialized
  rendererInitialized,
  
  /// Renderer resize
  rendererResize,
  
  /// Renderer context lost
  rendererContextLost,
  
  /// Renderer context restored
  rendererContextRestored,
  
  /// Render target created
  renderTargetCreated,
  
  /// Render target disposed
  renderTargetDisposed,
  
  /// Shader compiled
  shaderCompiled,
  
  /// Shader compilation failed
  shaderCompileFailed,
  
  /// Texture loaded
  textureLoaded,
  
  /// Texture load failed
  textureLoadFailed,
}

/// Resource events
enum ExsResourceEvent {
  /// Resource loading started
  resourceLoadStart,
  
  /// Resource loading progress
  resourceLoadProgress,
  
  /// Resource loading completed
  resourceLoadComplete,
  
  /// Resource loading failed
  resourceLoadFailed,
  
  /// Resource disposed
  resourceDisposed,
  
  /// Resource cache cleared
  resourceCacheCleared,
  
  /// Memory usage changed
  memoryUsageChanged,
}

/// Animation events
enum ExsAnimationEvent {
  /// Animation started
  animationStarted,
  
  /// Animation paused
  animationPaused,
  
  /// Animation resumed
  animationResumed,
  
  /// Animation stopped
  animationStopped,
  
  /// Animation completed
  animationCompleted,
  
  /// Animation looped
  animationLooped,
  
  /// Animation frame changed
  animationFrameChanged,
  
  /// Animation speed changed
  animationSpeedChanged,
}

/// Physics events
enum ExsPhysicsEvent {
  /// Physics world created
  physicsWorldCreated,
  
  /// Physics world disposed
  physicsWorldDisposed,
  
  /// Physics step started
  physicsStepStart,
  
  /// Physics step completed
  physicsStepComplete,
  
  /// Collision detected
  collisionDetected,
  
  /// Collision started
  collisionStarted,
  
  /// Collision ended
  collisionEnded,
  
  /// Trigger entered
  triggerEntered,
  
  /// Trigger exited
  triggerExited,
  
  /// Body added
  bodyAdded,
  
  /// Body removed
  bodyRemoved,
  
  /// Body sleep started
  bodySleepStart,
  
  /// Body sleep ended
  bodySleepEnd,
}

/// Input events
enum ExsInputEvent {
  /// Key pressed
  keyDown,
  
  /// Key released
  keyUp,
  
  /// Mouse moved
  mouseMove,
  
  /// Mouse button pressed
  mouseDown,
  
  /// Mouse button released
  mouseUp,
  
  /// Mouse wheel
  mouseWheel,
  
  /// Touch started
  touchStart,
  
  /// Touch moved
  touchMove,
  
  /// Touch ended
  touchEnd,
  
  /// Touch cancelled
  touchCancel,
  
  /// Gamepad connected
  gamepadConnected,
  
  /// Gamepad disconnected
  gamepadDisconnected,
  
  /// Gamepad button pressed
  gamepadButtonDown,
  
  /// Gamepad button released
  gamepadButtonUp,
  
  /// Gamepad axis changed
  gamepadAxisChanged,
}

/// UI events
enum ExsUIEvent {
  /// UI element created
  uiElementCreated,
  
  /// UI element disposed
  uiElementDisposed,
  
  /// UI element shown
  uiElementShown,
  
  /// UI element hidden
  uiElementHidden,
  
  /// UI element clicked
  uiElementClicked,
  
  /// UI element hovered
  uiElementHovered,
  
  /// UI element unhovered
  uiElementUnhovered,
  
  /// UI element focused
  uiElementFocused,
  
  /// UI element blurred
  uiElementBlurred,
  
  /// UI element value changed
  uiElementValueChanged,
  
  /// UI layout changed
  uiLayoutChanged,
  
  /// UI theme changed
  uiThemeChanged,
}

/// Audio events
enum ExsAudioEvent {
  /// Audio context created
  audioContextCreated,
  
  /// Audio context disposed
  audioContextDisposed,
  
  /// Audio source created
  audioSourceCreated,
  
  /// Audio source disposed
  audioSourceDisposed,
  
  /// Audio started playing
  audioPlay,
  
  /// Audio paused
  audioPause,
  
  /// Audio resumed
  audioResume,
  
  /// Audio stopped
  audioStop,
  
  /// Audio completed
  audioComplete,
  
  /// Audio looped
  audioLooped,
  
  /// Audio volume changed
  audioVolumeChanged,
  
  /// Audio pitch changed
  audioPitchChanged,
  
  /// Audio position changed
  audioPositionChanged,
}

/// Debug events
enum ExsDebugEvent {
  /// Debug message
  debugMessage,
  
  /// Debug warning
  debugWarning,
  
  /// Debug error
  debugError,
  
  /// Debug info
  debugInfo,
  
  /// Debug log
  debugLog,
  
  /// Debug assertion failed
  debugAssertFailed,
  
  /// Debug breakpoint
  debugBreakpoint,
  
  /// Debug profile start
  debugProfileStart,
  
  /// Debug profile end
  debugProfileEnd,
  
  /// Debug statistics updated
  debugStatsUpdated,
}

/// Combined event type enum that includes all event categories
enum ExsEventType {
  // Engine events
  engineInit(ExsEngineEvent.engineInit),
  engineInitComplete(ExsEngineEvent.engineInitComplete),
  engineStart(ExsEngineEvent.engineStart),
  engineStop(ExsEngineEvent.engineStop),
  enginePause(ExsEngineEvent.enginePause),
  engineResume(ExsEngineEvent.engineResume),
  engineDispose(ExsEngineEvent.engineDispose),
  engineDisposed(ExsEngineEvent.engineDisposed),
  engineUpdate(ExsEngineEvent.engineUpdate),
  engineRender(ExsEngineEvent.engineRender),
  
  // Scene events
  sceneCreated(ExsSceneEvent.sceneCreated),
  sceneDisposed(ExsSceneEvent.sceneDisposed),
  objectAdded(ExsSceneEvent.objectAdded),
  objectRemoved(ExsSceneEvent.objectRemoved),
  
  // Object events
  objectCreated(ExsObjectEvent.objectCreated),
  objectDisposed(ExsObjectEvent.objectDisposed),
  transformChanged(ExsObjectEvent.transformChanged),
  
  // Camera events
  cameraCreated(ExsCameraEvent.cameraCreated),
  cameraDisposed(ExsCameraEvent.cameraDisposed),
  cameraPositionChanged(ExsCameraEvent.cameraPositionChanged),
  
  // Renderer events
  rendererCreated(ExsRendererEvent.rendererCreated),
  rendererDisposed(ExsRendererEvent.rendererDisposed),
  rendererResize(ExsRendererEvent.rendererResize),
  
  // Resource events
  resourceLoadStart(ExsResourceEvent.resourceLoadStart),
  resourceLoadComplete(ExsResourceEvent.resourceLoadComplete),
  resourceLoadFailed(ExsResourceEvent.resourceLoadFailed),
  
  // Animation events
  animationStarted(ExsAnimationEvent.animationStarted),
  animationCompleted(ExsAnimationEvent.animationCompleted),
  
  // Physics events
  physicsWorldCreated(ExsPhysicsEvent.physicsWorldCreated),
  collisionDetected(ExsPhysicsEvent.collisionDetected),
  
  // Input events
  keyDown(ExsInputEvent.keyDown),
  keyUp(ExsInputEvent.keyUp),
  mouseMove(ExsInputEvent.mouseMove),
  mouseDown(ExsInputEvent.mouseDown),
  
  // UI events
  uiElementCreated(ExsUIEvent.uiElementCreated),
  uiElementClicked(ExsUIEvent.uiElementClicked),
  
  // Audio events
  audioContextCreated(ExsAudioEvent.audioContextCreated),
  audioPlay(ExsAudioEvent.audioPlay),
  
  // Debug events
  debugMessage(ExsDebugEvent.debugMessage),
  debugError(ExsDebugEvent.debugError);
  
  /// The underlying enum value
  final Enum value;
  
  /// Constructor
  const ExsEventType(this.value);
  
  /// Get the category of this event
  String get category {
    if (value is ExsEngineEvent) return 'engine';
    if (value is ExsSceneEvent) return 'scene';
    if (value is ExsObjectEvent) return 'object';
    if (value is ExsCameraEvent) return 'camera';
    if (value is ExsRendererEvent) return 'renderer';
    if (value is ExsResourceEvent) return 'resource';
    if (value is ExsAnimationEvent) return 'animation';
    if (value is ExsPhysicsEvent) return 'physics';
    if (value is ExsInputEvent) return 'input';
    if (value is ExsUIEvent) return 'ui';
    if (value is ExsAudioEvent) return 'audio';
    if (value is ExsDebugEvent) return 'debug';
    return 'unknown';
  }
  
  /// Check if this is an engine event
  bool get isEngineEvent => value is ExsEngineEvent;
  
  /// Check if this is a scene event
  bool get isSceneEvent => value is ExsSceneEvent;
  
  /// Check if this is an input event
  bool get isInputEvent => value is ExsInputEvent;
  
  /// Get all event types in a category
  static List<ExsEventType> getByCategory(String category) {
    return ExsEventType.values
        .where((type) => type.category == category)
        .toList();
  }
  
  /// Create event type from string
  static ExsEventType? fromString(String name) {
    try {
      return ExsEventType.values.firstWhere((type) => type.name == name);
    } catch (e) {
      return null;
    }
  }
  
  /// Get the underlying enum value cast to specific type
  T getAs<T extends Enum>() {
    return value as T;
  }
}
