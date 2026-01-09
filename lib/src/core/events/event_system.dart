/// Event system for DSRT Engine
/// 
/// Provides a centralized event dispatch and listening system for
/// engine-wide communication between components.
/// 
/// [maxListeners]: Maximum number of listeners per event type.
part of dsrt_engine.core.internal;

/// Event system implementation
/// 
/// Manages event registration, dispatch, and listener management
/// for the entire engine. Supports event bubbling, capture phases,
/// and priority-based dispatch.
/// 
/// Example:
/// ```dart
/// final eventSystem = EventSystem();
/// eventSystem.addEventListener(EventType.click, (event) {
///   print('Click event received: $event');
/// });
/// eventSystem.dispatchEvent(MouseEvent(EventType.click, position: Vector2.zero()));
/// ```
class EventSystem implements IEventSystem {
  /// Event listener registry
  final Map<EventType, List<EventListener>> _listeners = {};
  
  /// Event capture listeners
  final Map<EventType, List<EventListener>> _captureListeners = {};
  
  /// Maximum listeners per event type
  final int _maxListeners;
  
  /// Event dispatch depth (for preventing infinite recursion)
  int _dispatchDepth = 0;
  
  /// Maximum dispatch depth
  static const int _maxDispatchDepth = 100;
  
  /// Events currently being processed
  final List<BaseEvent> _processingEvents = [];
  
  /// Event queue for deferred dispatch
  final List<BaseEvent> _eventQueue = [];
  
  /// Whether event system is paused
  bool _paused = false;
  
  /// Statistics
  final _EventStats _stats = _EventStats();
  
  /// Creates an event system
  /// 
  /// [maxListeners]: Maximum number of listeners per event type.
  /// Defaults to 1000.
  EventSystem({int maxListeners = 1000}) : _maxListeners = maxListeners;
  
  /// Adds an event listener
  /// 
  /// [type]: Type of event to listen for.
  /// [listener]: Callback function to execute when event is dispatched.
  /// [options]: Listener options including priority, capture, and once.
  /// 
  /// Returns: Listener ID that can be used to remove the listener.
  @override
  String addEventListener(
    EventType type,
    EventListener listener, {
    EventListenerOptions? options,
  }) {
    _validateListener(type, listener);
    
    final listenerId = _generateListenerId();
    final wrappedListener = _WrappedEventListener(
      id: listenerId,
      listener: listener,
      priority: options?.priority ?? EventPriority.normal,
      capture: options?.capture ?? false,
      once: options?.once ?? false,
      passive: options?.passive ?? false,
    );
    
    final listeners = options?.capture == true ? _captureListeners : _listeners;
    
    if (!listeners.containsKey(type)) {
      listeners[type] = [];
    }
    
    final typeListeners = listeners[type]!;
    
    // Check listener limit
    if (typeListeners.length >= _maxListeners) {
      throw EventSystemError(
        'Maximum listeners ($_maxListeners) reached for event type: $type',
        errorCode: ErrorCode.maxListenersExceeded,
      );
    }
    
    // Insert listener based on priority
    _insertListenerByPriority(typeListeners, wrappedListener);
    
    _stats.listenerAdded(type, options?.capture ?? false);
    return listenerId;
  }
  
  /// Removes an event listener
  /// 
  /// [type]: Type of event to remove listener from.
  /// [listener]: Listener callback to remove.
  /// [options]: Listener options to match for removal.
  /// 
  /// Returns: true if listener was removed, false otherwise.
  @override
  bool removeEventListener(
    EventType type,
    EventListener listener, {
    EventListenerOptions? options,
  }) {
    final listeners = options?.capture == true ? _captureListeners : _listeners;
    
    if (!listeners.containsKey(type)) {
      return false;
    }
    
    final typeListeners = listeners[type]!;
    final initialLength = typeListeners.length;
    
    // Remove matching listeners
    typeListeners.removeWhere((wrapped) {
      return wrapped.listener == listener &&
             (options == null ||
              (wrapped.capture == options.capture &&
               wrapped.priority == options.priority));
    });
    
    final removed = typeListeners.length < initialLength;
    
    if (removed) {
      _stats.listenerRemoved(type, options?.capture ?? false);
      
      // Clean up empty listener lists
      if (typeListeners.isEmpty) {
        listeners.remove(type);
      }
    }
    
    return removed;
  }
  
  /// Removes an event listener by ID
  /// 
  /// [listenerId]: ID of the listener to remove.
  /// 
  /// Returns: true if listener was removed, false otherwise.
  @override
  bool removeEventListenerById(String listenerId) {
    var removed = false;
    
    // Search in regular listeners
    for (final entry in _listeners.entries) {
      final initialLength = entry.value.length;
      entry.value.removeWhere((wrapped) => wrapped.id == listenerId);
      
      if (entry.value.length < initialLength) {
        removed = true;
        _stats.listenerRemoved(entry.key, false);
        
        // Clean up empty listener lists
        if (entry.value.isEmpty) {
          _listeners.remove(entry.key);
        }
      }
    }
    
    // Search in capture listeners
    for (final entry in _captureListeners.entries) {
      final initialLength = entry.value.length;
      entry.value.removeWhere((wrapped) => wrapped.id == listenerId);
      
      if (entry.value.length < initialLength) {
        removed = true;
        _stats.listenerRemoved(entry.key, true);
        
        // Clean up empty listener lists
        if (entry.value.isEmpty) {
          _captureListeners.remove(entry.key);
        }
      }
    }
    
    return removed;
  }
  
  /// Checks if event type has any listeners
  /// 
  /// [type]: Event type to check.
  /// [capture]: Whether to check capture phase listeners.
  /// 
  /// Returns: true if event type has listeners.
  @override
  bool hasEventListener(EventType type, {bool capture = false}) {
    final listeners = capture ? _captureListeners : _listeners;
    return listeners.containsKey(type) && listeners[type]!.isNotEmpty;
  }
  
  /// Dispatches an event
  /// 
  /// [event]: Event to dispatch.
  /// [target]: Optional event target.
  /// 
  /// Returns: true if event was not cancelled, false if default was prevented.
  @override
  bool dispatchEvent(BaseEvent event, [Object? target]) {
    if (_paused) {
      return true;
    }
    
    // Check dispatch depth to prevent infinite recursion
    if (_dispatchDepth >= _maxDispatchDepth) {
      throw EventSystemError(
        'Maximum dispatch depth ($_maxDispatchDepth) exceeded',
        errorCode: ErrorCode.maxDispatchDepthExceeded,
      );
    }
    
    _dispatchDepth++;
    _processingEvents.add(event);
    
    try {
      _stats.eventDispatched(event.type);
      
      // Set event target if provided
      if (target != null) {
        event.target = target;
      }
      
      // Set current target
      event.currentTarget = target;
      
      // CAPTURE PHASE (from window to target)
      event.eventPhase = EventPhase.capturing;
      _dispatchToListeners(event, _captureListeners, EventPhase.capturing);
      
      // AT_TARGET PHASE
      event.eventPhase = EventPhase.atTarget;
      _dispatchToListeners(event, _listeners, EventPhase.atTarget);
      _dispatchToListeners(event, _captureListeners, EventPhase.atTarget);
      
      // BUBBLING PHASE (from target to window)
      if (event.bubbles) {
        event.eventPhase = EventPhase.bubbling;
        _dispatchToListeners(event, _listeners, EventPhase.bubbling);
      }
      
      // Remove once listeners
      _removeOnceListeners(event);
      
      _stats.eventProcessed(event.type, !event.defaultPrevented);
      
      return !event.defaultPrevented;
      
    } catch (error, stackTrace) {
      _stats.eventError(event.type);
      
      // Dispatch error event
      final errorEvent = EngineErrorEvent(
        message: 'Error processing event: ${event.type}',
        error: error,
        stackTrace: stackTrace,
      );
      
      // Dispatch error event synchronously
      _dispatchDepth--;
      _dispatchErrorEvent(errorEvent);
      
      rethrow;
      
    } finally {
      _dispatchDepth--;
      _processingEvents.remove(event);
      
      // Process queued events if we're back at top level
      if (_dispatchDepth == 0) {
        _processEventQueue();
      }
    }
  }
  
  /// Dispatches event to listeners
  void _dispatchToListeners(
    BaseEvent event,
    Map<EventType, List<EventListener>> listeners,
    EventPhase phase,
  ) {
    if (!listeners.containsKey(event.type)) {
      return;
    }
    
    final typeListeners = listeners[event.type]!.toList(); // Copy for iteration
    
    for (final wrapped in typeListeners) {
      // Skip listeners not for this phase
      if (phase == EventPhase.capturing && !wrapped.capture) continue;
      if (phase == EventPhase.bubbling && wrapped.capture) continue;
      if (phase == EventPhase.atTarget && wrapped.capture != (event.target == event.currentTarget)) {
        continue;
      }
      
      try {
        // Update event phase for this listener
        event.eventPhase = phase;
        
        // Call listener
        wrapped.listener(event);
        
        // Stop propagation if requested
        if (event.propagationStopped) {
          break;
        }
        
        // Stop immediate propagation if requested
        if (event.immediatePropagationStopped) {
          return;
        }
        
      } catch (error, stackTrace) {
        _stats.listenerError(event.type);
        
        // If listener is passive, we can't throw
        if (!wrapped.passive) {
          rethrow;
        }
      }
    }
  }
  
  /// Removes once listeners after event dispatch
  void _removeOnceListeners(BaseEvent event) {
    // Remove once listeners from regular listeners
    if (_listeners.containsKey(event.type)) {
      final regularListeners = _listeners[event.type]!;
      final onceListeners = regularListeners.where((wrapped) => wrapped.once).toList();
      
      for (final wrapped in onceListeners) {
        regularListeners.remove(wrapped);
        _stats.listenerRemoved(event.type, false);
      }
      
      if (regularListeners.isEmpty) {
        _listeners.remove(event.type);
      }
    }
    
    // Remove once listeners from capture listeners
    if (_captureListeners.containsKey(event.type)) {
      final captureListeners = _captureListeners[event.type]!;
      final onceListeners = captureListeners.where((wrapped) => wrapped.once).toList();
      
      for (final wrapped in onceListeners) {
        captureListeners.remove(wrapped);
        _stats.listenerRemoved(event.type, true);
      }
      
      if (captureListeners.isEmpty) {
        _captureListeners.remove(event.type);
      }
    }
  }
  
  /// Dispatches error event
  void _dispatchErrorEvent(EngineErrorEvent errorEvent) {
    // Try to dispatch to error listeners
    if (_listeners.containsKey(EventType.error)) {
      final errorListeners = _listeners[EventType.error]!.toList();
      
      for (final wrapped in errorListeners) {
        try {
          wrapped.listener(errorEvent);
        } catch (_) {
          // Ignore errors in error handlers
        }
      }
    }
  }
  
  /// Queues an event for deferred dispatch
  /// 
  /// [event]: Event to queue.
  /// [target]: Optional event target.
  @override
  void queueEvent(BaseEvent event, [Object? target]) {
    if (target != null) {
      event.target = target;
    }
    
    _eventQueue.add(event);
    _stats.eventQueued(event.type);
    
    // Process queue immediately if not in dispatch
    if (_dispatchDepth == 0) {
      _processEventQueue();
    }
  }
  
  /// Processes queued events
  void _processEventQueue() {
    while (_eventQueue.isNotEmpty && !_paused) {
      final event = _eventQueue.removeAt(0);
      try {
        dispatchEvent(event);
      } catch (error, stackTrace) {
        // Log but don't stop processing
        print('Error processing queued event: $error');
      }
    }
  }
  
  /// Pauses event processing
  @override
  void pause() {
    _paused = true;
  }
  
  /// Resumes event processing
  @override
  void resume() {
    _paused = false;
    
    // Process any queued events
    if (_dispatchDepth == 0) {
      _processEventQueue();
    }
  }
  
  /// Clears all event listeners
  @override
  void clear() {
    _listeners.clear();
    _captureListeners.clear();
    _eventQueue.clear();
    _stats.reset();
  }
  
  /// Clears listeners for specific event type
  /// 
  /// [type]: Event type to clear.
  /// [capture]: Whether to clear capture phase listeners.
  @override
  void clearEventType(EventType type, {bool capture = false}) {
    final listeners = capture ? _captureListeners : _listeners;
    
    if (listeners.containsKey(type)) {
      final count = listeners[type]!.length;
      listeners.remove(type);
      
      for (var i = 0; i < count; i++) {
        _stats.listenerRemoved(type, capture);
      }
    }
  }
  
  /// Gets event statistics
  @override
  EventStats getStats() {
    return _stats.toEventStats();
  }
  
  /// Validates listener parameters
  void _validateListener(EventType type, EventListener listener) {
    if (type == EventType.none) {
      throw ArgumentError('Cannot add listener for EventType.none');
    }
    
    if (listener == null) {
      throw ArgumentError('Listener cannot be null');
    }
  }
  
  /// Generates unique listener ID
  String _generateListenerId() {
    return 'listener_${DateTime.now().microsecondsSinceEpoch}_${_stats.totalListenersAdded}';
  }
  
  /// Inserts listener based on priority
  void _insertListenerByPriority(
    List<_WrappedEventListener> listeners,
    _WrappedEventListener newListener,
  ) {
    var insertIndex = listeners.length;
    
    for (var i = 0; i < listeners.length; i++) {
      if (listeners[i].priority < newListener.priority) {
        insertIndex = i;
        break;
      }
    }
    
    listeners.insert(insertIndex, newListener);
  }
  
  /// Gets number of listeners for event type
  @override
  int getListenerCount(EventType type, {bool capture = false}) {
    final listeners = capture ? _captureListeners : _listeners;
    
    if (!listeners.containsKey(type)) {
      return 0;
    }
    
    return listeners[type]!.length;
  }
  
  /// Gets all listener IDs for event type
  @override
  List<String> getListenerIds(EventType type, {bool capture = false}) {
    final listeners = capture ? _captureListeners : _listeners;
    
    if (!listeners.containsKey(type)) {
      return [];
    }
    
    return listeners[type]!.map((wrapped) => wrapped.id).toList();
  }
}

/// Wrapped event listener with metadata
class _WrappedEventListener {
  final String id;
  final EventListener listener;
  final EventPriority priority;
  final bool capture;
  final bool once;
  final bool passive;
  
  _WrappedEventListener({
    required this.id,
    required this.listener,
    required this.priority,
    required this.capture,
    required this.once,
    required this.passive,
  });
}

/// Event statistics collector
class _EventStats {
  int _eventsDispatched = 0;
  int _eventsProcessed = 0;
  int _eventsCancelled = 0;
  int _eventsQueued = 0;
  int _eventsErrored = 0;
  int _listenersAdded = 0;
  int _listenersRemoved = 0;
  int _listenerErrors = 0;
  
  final Map<EventType, int> _eventCounts = {};
  final Map<EventType, int> _listenerCounts = {};
  
  /// Records event dispatch
  void eventDispatched(EventType type) {
    _eventsDispatched++;
    _incrementCount(_eventCounts, type);
  }
  
  /// Records event processing
  void eventProcessed(EventType type, bool notCancelled) {
    _eventsProcessed++;
    
    if (!notCancelled) {
      _eventsCancelled++;
    }
  }
  
  /// Records event queuing
  void eventQueued(EventType type) {
    _eventsQueued++;
  }
  
  /// Records event error
  void eventError(EventType type) {
    _eventsErrored++;
  }
  
  /// Records listener addition
  void listenerAdded(EventType type, bool capture) {
    _listenersAdded++;
    _incrementCount(_listenerCounts, type);
  }
  
  /// Records listener removal
  void listenerRemoved(EventType type, bool capture) {
    _listenersRemoved++;
    _decrementCount(_listenerCounts, type);
  }
  
  /// Records listener error
  void listenerError(EventType type) {
    _listenerErrors++;
  }
  
  /// Gets total listeners added
  int get totalListenersAdded => _listenersAdded;
  
  /// Converts to public EventStats
  EventStats toEventStats() {
    return EventStats(
      eventsDispatched: _eventsDispatched,
      eventsProcessed: _eventsProcessed,
      eventsCancelled: _eventsCancelled,
      eventsQueued: _eventsQueued,
      eventsErrored: _eventsErrored,
      listenersAdded: _listenersAdded,
      listenersRemoved: _listenersRemoved,
      listenerErrors: _listenerErrors,
      eventCounts: Map.from(_eventCounts),
      listenerCounts: Map.from(_listenerCounts),
    );
  }
  
  /// Resets statistics
  void reset() {
    _eventsDispatched = 0;
    _eventsProcessed = 0;
    _eventsCancelled = 0;
    _eventsQueued = 0;
    _eventsErrored = 0;
    _listenersAdded = 0;
    _listenersRemoved = 0;
    _listenerErrors = 0;
    _eventCounts.clear();
    _listenerCounts.clear();
  }
  
  /// Increments count in map
  void _incrementCount(Map<EventType, int> map, EventType type) {
    map[type] = (map[type] ?? 0) + 1;
  }
  
  /// Decrements count in map
  void _decrementCount(Map<EventType, int> map, EventType type) {
    if (map.containsKey(type)) {
      map[type] = map[type]! - 1;
      
      if (map[type]! <= 0) {
        map.remove(type);
      }
    }
  }
}

/// Base event class
abstract class BaseEvent {
  /// Event type
  final EventType type;
  
  /// Event target (original dispatcher)
  Object? target;
  
  /// Current event target (during dispatch)
  Object? currentTarget;
  
  /// Event phase
  EventPhase eventPhase = EventPhase.none;
  
  /// Timestamp when event was created
  final int timestamp;
  
  /// Whether event bubbles up through parent chain
  final bool bubbles;
  
  /// Whether event can be cancelled
  final bool cancelable;
  
  /// Whether default action was prevented
  bool defaultPrevented = false;
  
  /// Whether event propagation was stopped
  bool propagationStopped = false;
  
  /// Whether immediate propagation was stopped
  bool immediatePropagationStopped = false;
  
  /// Creates a base event
  BaseEvent(
    this.type, {
    this.bubbles = true,
    this.cancelable = true,
    int? timestamp,
  }) : timestamp = timestamp ?? DateTime.now().millisecondsSinceEpoch;
  
  /// Prevents default action
  void preventDefault() {
    if (cancelable) {
      defaultPrevented = true;
    }
  }
  
  /// Stops event propagation
  void stopPropagation() {
    propagationStopped = true;
  }
  
  /// Stops immediate event propagation
  void stopImmediatePropagation() {
    immediatePropagationStopped = true;
    propagationStopped = true;
  }
  
  /// Creates a copy of the event
  BaseEvent copy();
}

/// Engine-specific events
class EngineEvent extends BaseEvent {
  /// Creates engine event
  EngineEvent({
    required super.type,
    super.bubbles,
    super.cancelable,
    super.timestamp,
  });
  
  @override
  EngineEvent copy() {
    return EngineEvent(
      type: type,
      bubbles: bubbles,
      cancelable: cancelable,
      timestamp: timestamp,
    );
  }
}

/// Engine error event
class EngineErrorEvent extends EngineEvent {
  /// Error message
  final String message;
  
  /// Error object
  final Object? error;
  
  /// Stack trace
  final StackTrace? stackTrace;
  
  /// Creates engine error event
  EngineErrorEvent({
    required this.message,
    this.error,
    this.stackTrace,
    super.timestamp,
  }) : super(
          type: EventType.engineError,
          bubbles: true,
          cancelable: false,
        );
  
  @override
  EngineErrorEvent copy() {
    return EngineErrorEvent(
      message: message,
      error: error,
      stackTrace: stackTrace,
      timestamp: timestamp,
    );
  }
}

/// Engine update event
class EngineUpdateEvent extends EngineEvent {
  /// Time since last update in seconds
  final double deltaTime;
  
  /// Current game time in seconds
  final double time;
  
  /// Frame count
  final int frameCount;
  
  /// Creates engine update event
  EngineUpdateEvent({
    required this.deltaTime,
    required this.time,
    required this.frameCount,
    super.timestamp,
  }) : super(
          type: EventType.engineUpdate,
          bubbles: false,
          cancelable: false,
        );
  
  @override
  EngineUpdateEvent copy() {
    return EngineUpdateEvent(
      deltaTime: deltaTime,
      time: time,
      frameCount: frameCount,
      timestamp: timestamp,
    );
  }
}

/// Event statistics
class EventStats {
  final int eventsDispatched;
  final int eventsProcessed;
  final int eventsCancelled;
  final int eventsQueued;
  final int eventsErrored;
  final int listenersAdded;
  final int listenersRemoved;
  final int listenerErrors;
  final Map<EventType, int> eventCounts;
  final Map<EventType, int> listenerCounts;
  
  EventStats({
    required this.eventsDispatched,
    required this.eventsProcessed,
    required this.eventsCancelled,
    required this.eventsQueued,
    required this.eventsErrored,
    required this.listenersAdded,
    required this.listenersRemoved,
    required this.listenerErrors,
    required this.eventCounts,
    required this.listenerCounts,
  });
}

/// Event system error
class EventSystemError extends EngineError {
  EventSystemError(
    String message, {
    super.errorCode,
    super.data,
  }) : super(message);
}
