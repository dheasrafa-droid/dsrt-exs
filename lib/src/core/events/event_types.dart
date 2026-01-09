/// Event types and enumerations for DSRT Engine
/// 
/// Defines all event types, phases, priorities, and options used
/// throughout the engine event system.
part of dsrt_engine.core.internal;

/// Event type enumeration
/// 
/// Categorizes all events in the engine system.
enum EventType {
  /// No event (placeholder)
  none,
  
  // Engine events
  engineInitialized,
  engineStarted,
  engineStopped,
  enginePaused,
  engineResumed,
  engineDisposed,
  engineError,
  engineUpdate,
  engineFixedUpdate,
  engineRender,
  engineResize,
  
  // Input events
  keyDown,
  keyUp,
  keyPress,
  mouseDown,
  mouseUp,
  mouseMove,
  mouseEnter,
  mouseLeave,
  mouseWheel,
  mouseClick,
  mouseDoubleClick,
  mouseContextMenu,
  touchStart,
  touchMove,
  touchEnd,
  touchCancel,
  gamepadConnected,
  gamepadDisconnected,
  gamepadButtonDown,
  gamepadButtonUp,
  gamepadAxisChanged,
  
  // Scene events
  sceneLoaded,
  sceneUnloaded,
  sceneUpdated,
  objectAdded,
  objectRemoved,
  objectTransformed,
  objectSelected,
  objectDeselected,
  cameraChanged,
  cameraMoved,
  cameraRotated,
  cameraZoomed,
  
  // Render events
  renderStarted,
  renderFinished,
  renderPassStarted,
  renderPassFinished,
  shaderCompiled,
  shaderError,
  textureLoaded,
  textureError,
  framebufferBound,
  framebufferUnbound,
  
  // Physics events
  physicsUpdate,
  physicsFixedUpdate,
  collisionStarted,
  collisionPersists,
  collisionEnded,
  triggerEnter,
  triggerExit,
  constraintAdded,
  constraintRemoved,
  bodyAdded,
  bodyRemoved,
  bodySleep,
  bodyWake,
  
  // Audio events
  audioLoaded,
  audioError,
  audioPlay,
  audioPause,
  audioStop,
  audioEnded,
  audioVolumeChanged,
  audioMuted,
  audioUnmuted,
  
  // UI events
  uiLoaded,
  uiError,
  uiElementAdded,
  uiElementRemoved,
  uiElementMoved,
  uiElementResized,
  uiElementClicked,
  uiElementHovered,
  uiElementFocused,
  uiElementBlurred,
  uiElementChanged,
  uiElementSubmitted,
  uiElementCancelled,
  uiScroll,
  uiDragStart,
  uiDrag,
  uiDragEnd,
  uiDrop,
  
  // Network events
  networkConnected,
  networkDisconnected,
  networkError,
  networkDataReceived,
  networkDataSent,
  networkLatencyUpdate,
  
  // Resource events
  resourceLoaded,
  resourceError,
  resourceProgress,
  resourceUnloaded,
  resourceCacheHit,
  resourceCacheMiss,
  resourceCacheEvicted,
  
  // Plugin events
  pluginLoaded,
  pluginError,
  pluginInitialized,
  pluginDisposed,
  pluginEnabled,
  pluginDisabled,
  
  // Custom events (user-defined)
  custom,
}

/// Event phase enumeration
enum EventPhase {
  /// No phase (event not being processed)
  none,
  
  /// Capture phase (from window to target)
  capturing,
  
  /// Target phase (at the event target)
  atTarget,
  
  /// Bubble phase (from target to window)
  bubbling,
}

/// Event priority levels
enum EventPriority {
  /// Highest priority (executed first)
  highest(100),
  
  /// High priority
  high(75),
  
  /// Normal priority (default)
  normal(50),
  
  /// Low priority
  low(25),
  
  /// Lowest priority (executed last)
  lowest(0);
  
  final int value;
  const EventPriority(this.value);
  
  /// Gets priority from value
  static EventPriority fromValue(int value) {
    for (final priority in EventPriority.values) {
      if (priority.value == value) {
        return priority;
      }
    }
    return EventPriority.normal;
  }
}

/// Event listener options
class EventListenerOptions {
  /// Event priority
  final EventPriority priority;
  
  /// Whether listener is for capture phase
  final bool capture;
  
  /// Whether listener should be removed after first invocation
  final bool once;
  
  /// Whether listener will not call preventDefault()
  final bool passive;
  
  /// Creates event listener options
  const EventListenerOptions({
    this.priority = EventPriority.normal,
    this.capture = false,
    this.once = false,
    this.passive = false,
  });
}

/// Event listener callback type
typedef EventListener = void Function(BaseEvent event);

/// Event dispatcher interface
abstract class EventDispatcher {
  /// Dispatches an event
  bool dispatchEvent(BaseEvent event);
  
  /// Adds event listener
  String addEventListener(EventType type, EventListener listener,
      {EventListenerOptions? options});
  
  /// Removes event listener
  bool removeEventListener(EventType type, EventListener listener,
      {EventListenerOptions? options});
}

/// Event target interface
abstract class EventTarget implements EventDispatcher {
  /// Event system reference
  EventSystem get eventSystem;
}
