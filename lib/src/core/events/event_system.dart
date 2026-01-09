/// DSRT Engine - Event System
/// Event dispatching and handling system.
library dsrt_engine.src.core.events.event_system;

import 'dart:async';
import 'dart:collection';
import '../../utils/disposables.dart';
import '../../utils/logger.dart';

/// Event system for handling game and engine events
class EventSystem with Disposable {
  /// Logger instance
  final Logger logger = Logger('EventSystem');
  
  /// Event listeners by event type
  final Map<Type, List<_EventListener>> _listeners = {};
  
  /// Pending events
  final Queue<_PendingEvent> _eventQueue = Queue();
  
  /// Processing events flag
  bool _isProcessing = false;
  
  /// Enable/disable event logging
  bool debugLogging = false;
  
  /// Dispatch an event
  void dispatch<T>(T event) {
    if (debugLogging) {
      logger.debug('Dispatching event: ${event.runtimeType}');
    }
    
    _eventQueue.add(_PendingEvent(event, event.runtimeType));
    
    if (!_isProcessing) {
      _processEvents();
    }
  }
  
  /// Add event listener
  EventListenerHandle<T> on<T>(void Function(T) callback) {
    final listeners = _listeners.putIfAbsent(T, () => []);
    final listener = _EventListener<T>(callback);
    listeners.add(listener);
    
    if (debugLogging) {
      logger.debug('Added listener for: $T');
    }
    
    return EventListenerHandle<T>(this, T, listener);
  }
  
  /// Add one-time event listener
  EventListenerHandle<T> once<T>(void Function(T) callback) {
    final listeners = _listeners.putIfAbsent(T, () => []);
    final listener = _EventListener<T>(callback, once: true);
    listeners.add(listener);
    
    if (debugLogging) {
      logger.debug('Added one-time listener for: $T');
    }
    
    return EventListenerHandle<T>(this, T, listener);
  }
  
  /// Remove event listener
  void removeListener<T>(_EventListener listener) {
    final listeners = _listeners[T];
    if (listeners != null) {
      listeners.remove(listener);
      
      if (listeners.isEmpty) {
        _listeners.remove(T);
      }
      
      if (debugLogging) {
        logger.debug('Removed listener for: $T');
      }
    }
  }
  
  /// Remove all listeners for event type
  void removeAllListeners<T>() {
    _listeners.remove(T);
    
    if (debugLogging) {
      logger.debug('Removed all listeners for: $T');
    }
  }
  
  /// Check if there are listeners for event type
  bool hasListeners<T>() {
    return _listeners.containsKey(T) && _listeners[T]!.isNotEmpty;
  }
  
  /// Get listener count for event type
  int listenerCount<T>() {
    return _listeners[T]?.length ?? 0;
  }
  
  /// Dispose event system
  @override
  void dispose() {
    _listeners.clear();
    _eventQueue.clear();
    super.dispose();
    
    logger.debug('Event system disposed');
  }
  
  // Private methods
  
  /// Process pending events
  void _processEvents() {
    if (_isProcessing) return;
    
    _isProcessing = true;
    
    try {
      while (_eventQueue.isNotEmpty) {
        final pending = _eventQueue.removeFirst();
        _dispatchToListeners(pending.event, pending.type);
      }
    } finally {
      _isProcessing = false;
    }
  }
  
  /// Dispatch event to listeners
  void _dispatchToListeners(dynamic event, Type type) {
    final listeners = _listeners[type];
    if (listeners == null || listeners.isEmpty) return;
    
    // Copy listeners list to allow modification during iteration
    final listenersCopy = List<_EventListener>.from(listeners);
    
    for (final listener in listenersCopy) {
      try {
        listener.invoke(event);
        
        // Remove one-time listeners
        if (listener.once) {
          listeners.remove(listener);
        }
      } catch (error, stackTrace) {
        logger.error('Error in event listener for $type: $error', stackTrace);
      }
    }
    
    // Clean up empty listener lists
    if (listeners.isEmpty) {
      _listeners.remove(type);
    }
  }
}

/// Pending event wrapper
class _PendingEvent {
  final dynamic event;
  final Type type;
  
  _PendingEvent(this.event, this.type);
}

/// Event listener wrapper
class _EventListener<T> {
  final void Function(T) callback;
  final bool once;
  
  _EventListener(this.callback, {this.once = false});
  
  void invoke(dynamic event) {
    callback(event as T);
  }
}

/// Event listener handle for cleanup
class EventListenerHandle<T> with Disposable {
  final EventSystem _eventSystem;
  final Type _eventType;
  final _EventListener _listener;
  
  EventListenerHandle(
    this._eventSystem,
    this._eventType,
    this._listener,
  );
  
  /// Remove this listener
  @override
  void dispose() {
    _eventSystem.removeListener(_eventType, _listener);
    super.dispose();
  }
}

/// Event priority levels
enum EventPriority {
  highest,
  high,
  normal,
  low,
  lowest,
}

/// Base event class
abstract class Event {
  /// Event timestamp
  final DateTime timestamp = DateTime.now();
  
  /// Event propagation flag
  bool get isPropagating => true;
  
  /// Stop event propagation
  void stopPropagation() {
    // Implementation depends on concrete event class
  }
}

/// Event with data
class DataEvent<T> extends Event {
  final T data;
  
  DataEvent(this.data);
}

/// Event with source
class SourceEvent<T> extends Event {
  final T source;
  
  SourceEvent(this.source);
}

/// Event with source and data
class SourceDataEvent<T, U> extends Event {
  final T source;
  final U data;
  
  SourceDataEvent(this.source, this.data);
}
