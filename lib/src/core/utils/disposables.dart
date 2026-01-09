/// DSRT Engine - Disposables System
/// Resource management and disposal utilities.
library dsrt_engine.src.core.utils.disposables;

import 'dart:async';
import 'dart:collection';
import 'dart:developer' as developer;
import '../../core/constants.dart';
import 'debug_utils.dart';
import 'logger.dart';

/// Disposable interface for resource management
abstract class Disposable {
  /// Whether the object has been disposed
  bool get isDisposed;
  
  /// Dispose the object and release resources
  void dispose();
  
  /// Assert that the object is not disposed
  void assertNotDisposed() {
    if (isDisposed) {
      throw StateError('${runtimeType} has been disposed');
    }
  }
}

/// Base disposable implementation
abstract class BaseDisposable implements Disposable {
  bool _disposed = false;
  
  @override
  bool get isDisposed => _disposed;
  
  @override
  @mustCallSuper
  void dispose() {
    if (!_disposed) {
      _disposed = true;
      _onDispose();
    }
  }
  
  /// Called when the object is disposed
  @protected
  void _onDispose() {}
}

/// Disposable container for multiple disposables
class CompositeDisposable implements Disposable {
  final Set<Disposable> _disposables = {};
  bool _disposed = false;
  
  /// Logger instance
  final Logger _logger = Logger('CompositeDisposable');
  
  @override
  bool get isDisposed => _disposed;
  
  /// Add a disposable to the container
  void add(Disposable disposable) {
    assertNotDisposed();
    
    if (_disposables.contains(disposable)) {
      return;
    }
    
    _disposables.add(disposable);
    
    if (DebugUtils.debugEnabled) {
      _logger.debug('Added disposable: ${disposable.runtimeType}');
    }
  }
  
  /// Add multiple disposables
  void addAll(Iterable<Disposable> disposables) {
    for (final disposable in disposables) {
      add(disposable);
    }
  }
  
  /// Remove a disposable from the container (does not dispose it)
  bool remove(Disposable disposable) {
    assertNotDisposed();
    final removed = _disposables.remove(disposable);
    
    if (removed && DebugUtils.debugEnabled) {
      _logger.debug('Removed disposable: ${disposable.runtimeType}');
    }
    
    return removed;
  }
  
  /// Clear all disposables (does not dispose them)
  void clear() {
    assertNotDisposed();
    _disposables.clear();
    
    if (DebugUtils.debugEnabled) {
      _logger.debug('Cleared all disposables');
    }
  }
  
  /// Get number of disposables
  int get count => _disposables.length;
  
  /// Check if contains disposable
  bool contains(Disposable disposable) {
    return _disposables.contains(disposable);
  }
  
  @override
  @mustCallSuper
  void dispose() {
    if (_disposed) return;
    
    _disposed = true;
    
    if (DebugUtils.debugEnabled) {
      _logger.debug('Disposing $count disposables');
    }
    
    // Dispose all in reverse order (LIFO)
    final disposables = _disposables.toList().reversed;
    int disposedCount = 0;
    int errorCount = 0;
    
    for (final disposable in disposables) {
      try {
        disposable.dispose();
        disposedCount++;
      } catch (error, stackTrace) {
        errorCount++;
        _logger.error(
          'Error disposing ${disposable.runtimeType}: $error',
          error,
          stackTrace,
        );
      }
    }
    
    _disposables.clear();
    
    if (DebugUtils.debugEnabled) {
      _logger.debug('Disposed $disposedCount/$count disposables ($errorCount errors)');
    }
  }
  
  @override
  void assertNotDisposed() {
    if (_disposed) {
      throw StateError('CompositeDisposable has been disposed');
    }
  }
}

/// Disposable that wraps a callback
class CallbackDisposable implements Disposable {
  final void Function() _callback;
  bool _disposed = false;
  final String? _name;
  
  CallbackDisposable(this._callback, {String? name}) : _name = name;
  
  @override
  bool get isDisposed => _disposed;
  
  @override
  void dispose() {
    if (!_disposed) {
      _disposed = true;
      
      try {
        _callback();
      } catch (error, stackTrace) {
        Logger('CallbackDisposable').error(
          'Error in disposable callback${_name != null ? " ($_name)" : ""}: $error',
          error,
          stackTrace,
        );
      }
    }
  }
}

/// Disposable that cancels a subscription
class SubscriptionDisposable implements Disposable {
  final StreamSubscription _subscription;
  bool _disposed = false;
  final String? _name;
  
  SubscriptionDisposable(this._subscription, {String? name}) : _name = name;
  
  @override
  bool get isDisposed => _disposed;
  
  @override
  void dispose() {
    if (!_disposed) {
      _disposed = true;
      _subscription.cancel();
    }
  }
}

/// Disposable that cancels a timer
class TimerDisposable implements Disposable {
  final Timer _timer;
  bool _disposed = false;
  final String? _name;
  
  TimerDisposable(this._timer, {String? name}) : _name = name;
  
  @override
  bool get isDisposed => _disposed;
  
  @override
  void dispose() {
    if (!_disposed) {
      _disposed = true;
      _timer.cancel();
    }
  }
}

/// Disposable that closes a sink
class SinkDisposable<T> implements Disposable {
  final StreamSink<T> _sink;
  bool _disposed = false;
  final String? _name;
  
  SinkDisposable(this._sink, {String? name}) : _name = name;
  
  @override
  bool get isDisposed => _disposed;
  
  @override
  void dispose() {
    if (!_disposed) {
      _disposed = true;
      _sink.close();
    }
  }
}

/// Disposable scope for resource management
class DisposableScope implements Disposable {
  final CompositeDisposable _disposables = CompositeDisposable();
  bool _disposed = false;
  final String _name;
  
  /// Logger instance
  final Logger _logger = Logger('DisposableScope');
  
  DisposableScope([String name = 'DisposableScope']) : _name = name;
  
  @override
  bool get isDisposed => _disposed;
  
  /// Register a disposable
  T register<T extends Disposable>(T disposable) {
    assertNotDisposed();
    _disposables.add(disposable);
    return disposable;
  }
  
  /// Register a callback
  Disposable registerCallback(void Function() callback, {String? name}) {
    return register(CallbackDisposable(callback, name: name));
  }
  
  /// Register a subscription
  Disposable registerSubscription(StreamSubscription subscription, {String? name}) {
    return register(SubscriptionDisposable(subscription, name: name));
  }
  
  /// Register a timer
  Disposable registerTimer(Timer timer, {String? name}) {
    return register(TimerDisposable(timer, name: name));
  }
  
  /// Register a sink
  Disposable registerSink<T>(StreamSink<T> sink, {String? name}) {
    return register(SinkDisposable(sink, name: name));
  }
  
  /// Execute action and register result
  T executeAndRegister<T extends Disposable>(T Function() action) {
    final result = action();
    return register(result);
  }
  
  /// Get number of registered disposables
  int get disposableCount => _disposables.count;
  
  @override
  @mustCallSuper
  void dispose() {
    if (_disposed) return;
    
    _disposed = true;
    
    if (DebugUtils.debugEnabled) {
      _logger.debug('Disposing scope "$_name" with $disposableCount disposables');
    }
    
    _disposables.dispose();
    
    if (DebugUtils.debugEnabled) {
      _logger.debug('Scope "$_name" disposed');
    }
  }
  
  @override
  void assertNotDisposed() {
    if (_disposed) {
      throw StateError('DisposableScope "$_name" has been disposed');
    }
  }
}

/// Resource manager for tracking and disposing resources
class ResourceManager implements Disposable {
  final Map<String, Disposable> _resources = {};
  bool _disposed = false;
  
  /// Logger instance
  final Logger _logger = Logger('ResourceManager');
  
  @override
  bool get isDisposed => _disposed;
  
  /// Register a resource with a key
  void register(String key, Disposable resource) {
    assertNotDisposed();
    
    if (_resources.containsKey(key)) {
      _logger.warning('Resource "$key" already registered, replacing');
      _resources[key]?.dispose();
    }
    
    _resources[key] = resource;
    
    if (DebugUtils.debugEnabled) {
      _logger.debug('Registered resource: $key (${resource.runtimeType})');
    }
  }
  
  /// Get a resource by key
  T? get<T extends Disposable>(String key) {
    assertNotDisposed();
    final resource = _resources[key];
    return resource is T ? resource : null;
  }
  
  /// Check if resource exists
  bool contains(String key) {
    return _resources.containsKey(key);
  }
  
  /// Remove and dispose a resource
  bool remove(String key) {
    assertNotDisposed();
    
    final resource = _resources.remove(key);
    if (resource != null) {
      resource.dispose();
      
      if (DebugUtils.debugEnabled) {
        _logger.debug('Removed resource: $key');
      }
      
      return true;
    }
    
    return false;
  }
  
  /// Remove without disposing
  Disposable? removeWithoutDisposing(String key) {
    assertNotDisposed();
    return _resources.remove(key);
  }
  
  /// Clear all resources
  void clear() {
    assertNotDisposed();
    
    if (DebugUtils.debugEnabled) {
      _logger.debug('Clearing ${_resources.length} resources');
    }
    
    disposeAll();
    _resources.clear();
  }
  
  /// Dispose all resources
  void disposeAll() {
    assertNotDisposed();
    
    final resources = Map<String, Disposable>.from(_resources);
    int disposedCount = 0;
    int errorCount = 0;
    
    for (final entry in resources.entries) {
      try {
        entry.value.dispose();
        disposedCount++;
      } catch (error, stackTrace) {
        errorCount++;
        _logger.error(
          'Error disposing resource "${entry.key}": $error',
          error,
          stackTrace,
        );
      }
    }
    
    if (DebugUtils.debugEnabled) {
      _logger.debug('Disposed $disposedCount/${resources.length} resources ($errorCount errors)');
    }
  }
  
  /// Get all resource keys
  Set<String> get keys => Set.unmodifiable(_resources.keys);
  
  /// Get resource count
  int get count => _resources.length;
  
  @override
  void dispose() {
    if (_disposed) return;
    
    _disposed = true;
    
    if (DebugUtils.debugEnabled) {
      _logger.debug('Disposing resource manager with $count resources');
    }
    
    disposeAll();
    _resources.clear();
  }
  
  @override
  void assertNotDisposed() {
    if (_disposed) {
      throw StateError('ResourceManager has been disposed');
    }
  }
}

/// Async disposable interface
abstract class AsyncDisposable {
  /// Whether the object has been disposed
  bool get isDisposed;
  
  /// Dispose the object asynchronously
  Future<void> dispose();
}

/// Async disposable container
class AsyncCompositeDisposable implements AsyncDisposable {
  final Set<AsyncDisposable> _disposables = {};
  bool _disposed = false;
  
  /// Logger instance
  final Logger _logger = Logger('AsyncCompositeDisposable');
  
  @override
  bool get isDisposed => _disposed;
  
  /// Add an async disposable
  void add(AsyncDisposable disposable) {
    if (_disposed) {
      throw StateError('AsyncCompositeDisposable has been disposed');
    }
    
    if (_disposables.contains(disposable)) {
      return;
    }
    
    _disposables.add(disposable);
  }
  
  /// Remove an async disposable (does not dispose it)
  bool remove(AsyncDisposable disposable) {
    if (_disposed) {
      throw StateError('AsyncCompositeDisposable has been disposed');
    }
    
    return _disposables.remove(disposable);
  }
  
  /// Clear all async disposables (does not dispose them)
  void clear() {
    if (_disposed) {
      throw StateError('AsyncCompositeDisposable has been disposed');
    }
    
    _disposables.clear();
  }
  
  /// Get number of async disposables
  int get count => _disposables.length;
  
  @override
  Future<void> dispose() async {
    if (_disposed) return;
    
    _disposed = true;
    
    if (DebugUtils.debugEnabled) {
      _logger.debug('Async disposing $count disposables');
    }
    
    // Dispose all asynchronously
    final disposables = _disposables.toList();
    int disposedCount = 0;
    int errorCount = 0;
    
    for (final disposable in disposables) {
      try {
        await disposable.dispose();
        disposedCount++;
      } catch (error, stackTrace) {
        errorCount++;
        _logger.error(
          'Error async disposing ${disposable.runtimeType}: $error',
          error,
          stackTrace,
        );
      }
    }
    
    _disposables.clear();
    
    if (DebugUtils.debugEnabled) {
      _logger.debug('Async disposed $disposedCount/$count disposables ($errorCount errors)');
    }
  }
}

/// Disposable mixin for automatic resource management
mixin DisposableMixin implements Disposable {
  final CompositeDisposable _disposables = CompositeDisposable();
  bool _disposed = false;
  
  @override
  bool get isDisposed => _disposed;
  
  /// Track a disposable
  void trackDisposable(Disposable disposable) {
    assertNotDisposed();
    _disposables.add(disposable);
  }
  
  /// Track a callback
  void trackCallback(void Function() callback, {String? name}) {
    trackDisposable(CallbackDisposable(callback, name: name));
  }
  
  /// Track a subscription
  void trackSubscription(StreamSubscription subscription, {String? name}) {
    trackDisposable(SubscriptionDisposable(subscription, name: name));
  }
  
  /// Track a timer
  void trackTimer(Timer timer, {String? name}) {
    trackDisposable(TimerDisposable(timer, name: name));
  }
  
  /// Track a sink
  void trackSink<T>(StreamSink<T> sink, {String? name}) {
    trackDisposable(SinkDisposable(sink, name: name));
  }
  
  /// Untrack a disposable (does not dispose it)
  bool untrackDisposable(Disposable disposable) {
    return _disposables.remove(disposable);
  }
  
  /// Clear all tracked disposables (does not dispose them)
  void clearTracked() {
    _disposables.clear();
  }
  
  /// Get number of tracked disposables
  int get trackedCount => _disposables.count;
  
  @override
  @mustCallSuper
  void dispose() {
    if (_disposed) return;
    
    _disposed = true;
    _disposables.dispose();
    _onDispose();
  }
  
  /// Called when the object is disposed
  @protected
  void _onDispose() {}
}

/// Automatic disposal using finalizer
class AutoDisposable {
  static final Finalizer<Disposable> _finalizer = Finalizer((disposable) {
    if (!disposable.isDisposed) {
      try {
        disposable.dispose();
      } catch (error, stackTrace) {
        Logger('AutoDisposable').error(
          'Error in finalizer disposing ${disposable.runtimeType}: $error',
          error,
          stackTrace,
        );
      }
    }
  });
  
  /// Make an object auto-disposable
  static void attach(Disposable disposable, Object owner) {
    _finalizer.attach(owner, disposable, detach: owner);
  }
  
  /// Detach auto-disposal
  static void detach(Object owner) {
    _finalizer.detach(owner);
  }
}

/// Leak detection utility
class LeakDetector {
  static final Map<String, Set<String>> _allocations = {};
  static final Map<String, Set<String>> _deallocations = {};
  static bool _enabled = false;
  
  /// Enable leak detection
  static void enable() {
    _enabled = true;
    _allocations.clear();
    _deallocations.clear();
  }
  
  /// Disable leak detection
  static void disable() {
    _enabled = false;
  }
  
  /// Track allocation
  static void trackAllocation(String type, String id) {
    if (!_enabled) return;
    
    _allocations.putIfAbsent(type, () => {}).add(id);
    _deallocations.putIfAbsent(type, () => {}).remove(id);
  }
  
  /// Track deallocation
  static void trackDeallocation(String type, String id) {
    if (!_enabled) return;
    
    _deallocations.putIfAbsent(type, () => {}).add(id);
    _allocations.putIfAbsent(type, () => {}).remove(id);
  }
  
  /// Check for leaks
  static Map<String, int> checkLeaks() {
    final leaks = <String, int>{};
    
    for (final entry in _allocations.entries) {
      if (entry.value.isNotEmpty) {
        leaks[entry.key] = entry.value.length;
      }
    }
    
    return leaks;
  }
  
  /// Print leak report
  static void printLeakReport() {
    final leaks = checkLeaks();
    
    if (leaks.isEmpty) {
      print('No leaks detected');
      return;
    }
    
    print('=== LEAK DETECTION REPORT ===');
    for (final entry in leaks.entries) {
      print('${entry.key}: ${entry.value} potential leaks');
      final allocations = _allocations[entry.key] ?? {};
      for (final id in allocations.take(10)) {
        print('  - $id');
      }
      if (allocations.length > 10) {
        print('  ... and ${allocations.length - 10} more');
      }
    }
    print('=============================');
  }
  
  /// Clear all tracking
  static void clear() {
    _allocations.clear();
    _deallocations.clear();
  }
}
