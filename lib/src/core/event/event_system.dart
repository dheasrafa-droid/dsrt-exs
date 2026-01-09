/// Event system for engine-wide communication
/// 
/// Provides a pub/sub system for decoupled communication
/// between engine systems.
/// 
/// @license MIT
/// @copyright (c) 2024 DSRT Engine

import 'dart:async';
import 'event_types.dart';
import '../utils/disposables.dart';
import '../utils/logger.dart';

/// Event listener callback type
typedef ExsEventListener = void Function(ExsEvent event);

/// Event listener with priority
class _ExsEventListenerEntry {
  /// The listener callback
  final ExsEventListener listener;
  
  /// Priority (higher = called earlier)
  final int priority;
  
  /// Whether this is a one-time listener
  final bool once;
  
  /// Constructor
  _ExsEventListenerEntry(this.listener, this.priority, this.once);
}

/// Event system implementation
class ExsEventSystem implements ExsDisposable {
  /// Logger instance
  final ExsLogger _logger;
  
  /// Event listeners map
  final Map<ExsEventType, List<_ExsEventListenerEntry>> _listeners = {};
  
  /// Is disposed flag
  bool _isDisposed = false;
  
  /// Event queue for deferred processing
  final List<ExsEvent> _eventQueue = [];
  
  /// Is processing events flag
  bool _isProcessing = false;
  
  /// Constructor
  ExsEventSystem() : _logger = ExsLogger('ExsEventSystem');
  
  /// Add an event listener
  void addListener(ExsEventType type, ExsEventListener listener, {
    int priority = 0,
    bool once = false,
  }) {
    _checkDisposed();
    
    final entry = _ExsEventListenerEntry(listener, priority, once);
    final listeners = _listeners[type] ??= [];
    listeners.add(entry);
    
    // Sort by priority (higher priority first)
    listeners.sort((a, b) => b.priority.compareTo(a.priority));
  }
  
  /// Remove an event listener
  void removeListener(ExsEventType type, ExsEventListener listener) {
    _checkDisposed();
    
    final listeners = _listeners[type];
    if (listeners != null) {
      listeners.removeWhere((entry) => entry.listener == listener);
      if (listeners.isEmpty) {
        _listeners.remove(type);
      }
    }
  }
  
  /// Check if there are listeners for an event type
  bool hasListeners(ExsEventType type) {
    _checkDisposed();
    return _listeners[type]?.isNotEmpty ?? false;
  }
  
  /// Dispatch an event immediately
  void dispatch(ExsEvent event) {
    _checkDisposed();
    
    final type = event.type;
    final listeners = _listeners[type];
    
    if (listeners == null || listeners.isEmpty) {
      return;
    }
    
    // Call listeners, removing one-time listeners after calling
    final listenersToRemove = <_ExsEventListenerEntry>[];
    
    for (final entry in List.from(listeners)) {
      try {
        entry.listener(event);
        
        if (entry.once) {
          listenersToRemove.add(entry);
        }
        
        // Stop propagation if event is stopped
        if (event.isPropagationStopped) {
          break;
        }
      } catch (e, stackTrace) {
        _logger.error('Error in event listener for ${type.name}: $e', stackTrace);
      }
    }
    
    // Remove one-time listeners
    if (listenersToRemove.isNotEmpty) {
      listeners.removeWhere(listenersToRemove.contains);
      if (listeners.isEmpty) {
        _listeners.remove(type);
      }
    }
  }
  
  /// Queue an event for deferred processing
  void queue(ExsEvent event) {
    _checkDisposed();
    _eventQueue.add(event);
  }
  
  /// Process all queued events
  void processQueue() {
    _checkDisposed();
    
    if (_isProcessing || _eventQueue.isEmpty) {
      return;
    }
    
    _isProcessing = true;
    
    try {
      // Process all events in queue (new events added during processing
      // will be processed in the next frame)
      final eventsToProcess = List<ExsEvent>.from(_eventQueue);
      _eventQueue.clear();
      
      for (final event in eventsToProcess) {
        dispatch(event);
      }
    } finally {
      _isProcessing = false;
    }
  }
  
  /// Clear all event listeners
  void clear() {
    _checkDisposed();
    _listeners.clear();
    _eventQueue.clear();
    _logger.info('All event listeners cleared');
  }
  
  /// Clear listeners for a specific event type
  void clearType(ExsEventType type) {
    _checkDisposed();
    _listeners.remove(type);
    _eventQueue.removeWhere((event) => event.type == type);
  }
  
  /// Get number of listeners for a type
  int listenerCount(ExsEventType type) {
    _checkDisposed();
    return _listeners[type]?.length ?? 0;
  }
  
  /// Check if disposed
  void _checkDisposed() {
    if (_isDisposed) {
      throw StateError('ExsEventSystem is disposed');
    }
  }
  
  @override
  void dispose() {
    if (_isDisposed) return;
    
    clear();
    _isDisposed = true;
    _logger.info('Event system disposed');
  }
  
  @override
  bool get isDisposed => _isDisposed;
}

/// Event class representing a single event
class ExsEvent {
  /// Event type
  final ExsEventType type;
  
  /// Event data (optional)
  final dynamic data;
  
  /// Time when event was created
  final DateTime timestamp;
  
  /// Is propagation stopped flag
  bool _propagationStopped = false;
  
  /// Constructor
  ExsEvent(this.type, {this.data}) : timestamp = DateTime.now();
  
  /// Stop further propagation of this event
  void stopPropagation() {
    _propagationStopped = true;
  }
  
  /// Check if propagation is stopped
  bool get isPropagationStopped => _propagationStopped;
  
  /// Get string representation
  @override
  String toString() {
    return 'ExsEvent(type: ${type.name}, timestamp: $timestamp, '
           'data: ${data != null ? data.runtimeType : "none"})';
  }
  
  /// Create a copy of this event
  ExsEvent copy() {
    return ExsEvent(type, data: data);
  }
}
