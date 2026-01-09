/// DSRT Engine - Event Types
/// Core event type definitions.
library dsrt_engine.src.core.events.event_types;

import 'event_system.dart';
import '../../utils/uuid.dart';

/// Engine lifecycle events
class EngineEvent extends Event {
  /// Event type
  final EngineEventType type;
  
  /// Event data
  final Map<String, dynamic> data;
  
  /// Create engine event
  EngineEvent({
    required this.type,
    this.data = const {},
  });
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

/// Window resize event
class ResizeEvent extends Event {
  final int width;
  final int height;
  final double aspectRatio;
  
  ResizeEvent(this.width, this.height)
      : aspectRatio = width / height;
}

/// Frame event
class FrameEvent extends Event {
  final int frameNumber;
  final double deltaTime;
  final double elapsedTime;
  
  FrameEvent({
    required this.frameNumber,
    required this.deltaTime,
    required this.elapsedTime,
  });
}

/// Asset loading events
class AssetLoadEvent extends Event {
  final String assetId;
  final String assetType;
  final double progress; // 0.0 to 1.0
  final AssetLoadStatus status;
  
  AssetLoadEvent({
    required this.assetId,
    required this.assetType,
    required this.progress,
    required this.status,
  });
}

/// Asset load status
enum AssetLoadStatus {
  queued,
  loading,
  loaded,
  error,
  cancelled,
}

/// Resource management events
class ResourceEvent extends Event {
  final String resourceId;
  final ResourceEventType type;
  final Map<String, dynamic> data;
  
  ResourceEvent({
    required this.resourceId,
    required this.type,
    this.data = const {},
  });
}

/// Resource event types
enum ResourceEventType {
  created,
  loaded,
  unloaded,
  disposed,
  error,
}

/// Scene events
class SceneEvent extends Event {
  final String sceneId;
  final SceneEventType type;
  final Map<String, dynamic> data;
  
  SceneEvent({
    required this.sceneId,
    required this.type,
    this.data = const {},
  });
}

/// Scene event types
enum SceneEventType {
  created,
  loaded,
  unloaded,
  objectAdded,
  objectRemoved,
  objectUpdated,
  cleared,
}

/// Object events
class ObjectEvent extends Event {
  final String objectId;
  final ObjectEventType type;
  final Map<String, dynamic> data;
  
  ObjectEvent({
    required this.objectId,
    required this.type,
    this.data = const {},
  });
}

/// Object event types
enum ObjectEventType {
  created,
  added,
  removed,
  updated,
  selected,
  deselected,
  visibilityChanged,
  transformChanged,
}

/// Camera events
class CameraEvent extends Event {
  final String cameraId;
  final CameraEventType type;
  final Map<String, dynamic> data;
  
  CameraEvent({
    required this.cameraId,
    required this.type,
    this.data = const {},
  });
}

/// Camera event types
enum CameraEventType {
  created,
  activated,
  deactivated,
  transformChanged,
  projectionChanged,
  frustumChanged,
}

/// Render events
class RenderEvent extends Event {
  final RenderEventType type;
  final Map<String, dynamic> data;
  
  RenderEvent({
    required this.type,
    this.data = const {},
  });
}

/// Render event types
enum RenderEventType {
  preRender,
  postRender,
  renderPassStarted,
  renderPassCompleted,
  frameBufferSwitched,
  shaderCompiled,
  textureLoaded,
}

/// Physics events
class PhysicsEvent extends Event {
  final PhysicsEventType type;
  final Map<String, dynamic> data;
  
  PhysicsEvent({
    required this.type,
    this.data = const {},
  });
}

/// Physics event types
enum PhysicsEventType {
  worldCreated,
  worldDestroyed,
  bodyAdded,
  bodyRemoved,
  collisionStarted,
  collisionEnded,
  triggerEntered,
  triggerExited,
  constraintAdded,
  constraintRemoved,
}

/// Audio events
class AudioEvent extends Event {
  final String audioId;
  final AudioEventType type;
  final Map<String, dynamic> data;
  
  AudioEvent({
    required this.audioId,
    required this.type,
    this.data = const {},
  });
}

/// Audio event types
enum AudioEventType {
  contextCreated,
  contextDestroyed,
  sourceCreated,
  sourceDestroyed,
  bufferLoaded,
  playbackStarted,
  playbackStopped,
  playbackPaused,
  playbackEnded,
  volumeChanged,
  pitchChanged,
}

/// UI events
class UIEvent extends Event {
  final String elementId;
  final UIEventType type;
  final Map<String, dynamic> data;
  
  UIEvent({
    required this.elementId,
    required this.type,
    this.data = const {},
  });
}

/// UI event types
enum UIEventType {
  elementCreated,
  elementDestroyed,
  elementShown,
  elementHidden,
  elementClicked,
  elementHovered,
  elementUnhovered,
  elementFocused,
  elementBlurred,
  valueChanged,
}

/// Network events
class NetworkEvent extends Event {
  final String connectionId;
  final NetworkEventType type;
  final Map<String, dynamic> data;
  
  NetworkEvent({
    required this.connectionId,
    required this.type,
    this.data = const {},
  });
}

/// Network event types
enum NetworkEventType {
  connected,
  disconnected,
  connectionError,
  dataReceived,
  dataSent,
  latencyUpdated,
}

/// Plugin events
class PluginEvent extends Event {
  final String pluginId;
  final PluginEventType type;
  final Map<String, dynamic> data;
  
  PluginEvent({
    required this.pluginId,
    required this.type,
    this.data = const {},
  });
}

/// Plugin event types
enum PluginEventType {
  loaded,
  unloaded,
  initialized,
  disposed,
  error,
}

/// Debug events
class DebugEvent extends Event {
  final DebugEventType type;
  final Map<String, dynamic> data;
  
  DebugEvent({
    required this.type,
    this.data = const {},
  });
}

/// Debug event types
enum DebugEventType {
  logMessage,
  warningMessage,
  errorMessage,
  performanceWarning,
  performanceCritical,
  breakpointHit,
  variableChanged,
  stackTraceCaptured,
}

/// Error event
class ErrorEvent extends Event {
  final String message;
  final dynamic error;
  final StackTrace? stackTrace;
  final ErrorSeverity severity;
  
  ErrorEvent({
    required this.message,
    required this.error,
    this.stackTrace,
    this.severity = ErrorSeverity.error,
  });
  
  @override
  String toString() {
    return 'ErrorEvent: $message\nError: $error\nStackTrace: $stackTrace';
  }
}

/// Error severity levels
enum ErrorSeverity {
  info,
  warning,
  error,
  critical,
}

/// Custom event builder
class EventBuilder {
  final Map<String, dynamic> _data = {};
  String? _eventId;
  String? _sourceId;
  EventPriority _priority = EventPriority.normal;
  bool _propagating = true;
  
  /// Set event ID
  EventBuilder withId(String id) {
    _eventId = id;
    return this;
  }
  
  /// Generate new event ID
  EventBuilder withGeneratedId() {
    _eventId = generateUuid();
    return this;
  }
  
  /// Set source ID
  EventBuilder withSource(String sourceId) {
    _sourceId = sourceId;
    return this;
  }
  
  /// Set priority
  EventBuilder withPriority(EventPriority priority) {
    _priority = priority;
    return this;
  }
  
  /// Set propagation
  EventBuilder withPropagation(bool propagating) {
    _propagating = propagating;
    return this;
  }
  
  /// Add data
  EventBuilder withData(String key, dynamic value) {
    _data[key] = value;
    return this;
  }
  
  /// Add multiple data
  EventBuilder withDataMap(Map<String, dynamic> data) {
    _data.addAll(data);
    return this;
  }
  
  /// Build custom event
  CustomEvent build() {
    return CustomEvent(
      id: _eventId ?? generateUuid(),
      sourceId: _sourceId,
      data: Map.from(_data),
      priority: _priority,
      propagating: _propagating,
    );
  }
}

/// Custom event for user-defined events
class CustomEvent extends Event {
  final String id;
  final String? sourceId;
  final Map<String, dynamic> data;
  final EventPriority priority;
  
  @override
  final bool propagating;
  
  CustomEvent({
    required this.id,
    this.sourceId,
    this.data = const {},
    this.priority = EventPriority.normal,
    this.propagating = true,
  });
  
  /// Get data value
  T? get<T>(String key) {
    return data[key] as T?;
  }
  
  /// Get data value with default
  T getOrDefault<T>(String key, T defaultValue) {
    return data[key] as T? ?? defaultValue;
  }
}
