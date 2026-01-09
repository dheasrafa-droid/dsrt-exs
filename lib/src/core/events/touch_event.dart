/// DSRT Engine - Touch Events
/// Touch input event handling for mobile devices.
library dsrt_engine.src.core.events.touch_event;

import 'dart:math' as math;
import 'event_system.dart';
import '../../utils/uuid.dart';

/// Touch point information
class TouchPoint {
  /// Touch identifier
  final int identifier;
  
  /// Touch position in viewport coordinates
  final double clientX;
  final double clientY;
  
  /// Touch position in screen coordinates
  final double screenX;
  final double screenY;
  
  /// Touch radius
  final double radiusX;
  final double radiusY;
  
  /// Touch rotation angle
  final double rotationAngle;
  
  /// Touch force/pressure (0.0 to 1.0)
  final double force;
  
  /// Create touch point
  TouchPoint({
    required this.identifier,
    required this.clientX,
    required this.clientY,
    required this.screenX,
    required this.screenY,
    this.radiusX = 0.0,
    this.radiusY = 0.0,
    this.rotationAngle = 0.0,
    this.force = 0.0,
  });
  
  /// Get distance to another touch point
  double distanceTo(TouchPoint other) {
    final dx = clientX - other.clientX;
    final dy = clientY - other.clientY;
    return math.sqrt(dx * dx + dy * dy);
  }
  
  /// Copy with new values
  TouchPoint copyWith({
    int? identifier,
    double? clientX,
    double? clientY,
    double? screenX,
    double? screenY,
    double? radiusX,
    double? radiusY,
    double? rotationAngle,
    double? force,
  }) {
    return TouchPoint(
      identifier: identifier ?? this.identifier,
      clientX: clientX ?? this.clientX,
      clientY: clientY ?? this.clientY,
      screenX: screenX ?? this.screenX,
      screenY: screenY ?? this.screenY,
      radiusX: radiusX ?? this.radiusX,
      radiusY: radiusY ?? this.radiusY,
      rotationAngle: rotationAngle ?? this.rotationAngle,
      force: force ?? this.force,
    );
  }
}

/// Touch event base class
abstract class TouchEvent extends Event {
  /// List of touch points
  final List<TouchPoint> touches;
  
  /// List of changed touch points
  final List<TouchPoint> changedTouches;
  
  /// List of target touch points
  final List<TouchPoint> targetTouches;
  
  /// Create touch event
  TouchEvent({
    required this.touches,
    required this.changedTouches,
    required this.targetTouches,
  });
  
  /// Get touch point by identifier
  TouchPoint? getTouchById(int identifier) {
    for (final touch in touches) {
      if (touch.identifier == identifier) {
        return touch;
      }
    }
    return null;
  }
  
  /// Get first touch point
  TouchPoint? get firstTouch => touches.isNotEmpty ? touches.first : null;
  
  /// Get center of all touch points
  (double, double) get center {
    if (touches.isEmpty) return (0.0, 0.0);
    
    double sumX = 0.0;
    double sumY = 0.0;
    
    for (final touch in touches) {
      sumX += touch.clientX;
      sumY += touch.clientY;
    }
    
    return (sumX / touches.length, sumY / touches.length);
  }
  
  /// Calculate pinch/zoom scale relative to another touch event
  double getPinchScale(TouchEvent other) {
    if (touches.length < 2 || other.touches.length < 2) {
      return 1.0;
    }
    
    final currentDistance = touches[0].distanceTo(touches[1]);
    final previousDistance = other.touches[0].distanceTo(other.touches[1]);
    
    if (previousDistance == 0.0) return 1.0;
    
    return currentDistance / previousDistance;
  }
  
  /// Calculate rotation angle relative to another touch event
  double getRotationAngle(TouchEvent other) {
    if (touches.length < 2 || other.touches.length < 2) {
      return 0.0;
    }
    
    final currentVector = (
      touches[1].clientX - touches[0].clientX,
      touches[1].clientY - touches[0].clientY,
    );
    
    final previousVector = (
      other.touches[1].clientX - other.touches[0].clientX,
      other.touches[1].clientY - other.touches[0].clientY,
    );
    
    final currentAngle = math.atan2(currentVector.$2, currentVector.$1);
    final previousAngle = math.atan2(previousVector.$2, previousVector.$1);
    
    return currentAngle - previousAngle;
  }
}

/// Touch start event
class TouchStartEvent extends TouchEvent {
  /// Create touch start event
  TouchStartEvent({
    required super.touches,
    required super.changedTouches,
    required super.targetTouches,
  });
}

/// Touch end event
class TouchEndEvent extends TouchEvent {
  /// Create touch end event
  TouchEndEvent({
    required super.touches,
    required super.changedTouches,
    required super.targetTouches,
  });
}

/// Touch move event
class TouchMoveEvent extends TouchEvent {
  /// Create touch move event
  TouchMoveEvent({
    required super.touches,
    required super.changedTouches,
    required super.targetTouches,
  });
}

/// Touch cancel event
class TouchCancelEvent extends TouchEvent {
  /// Create touch cancel event
  TouchCancelEvent({
    required super.touches,
    required super.changedTouches,
    required super.targetTouches,
  });
}

/// Gesture event base class
abstract class GestureEvent extends Event {
  /// Gesture center position
  final double centerX;
  final double centerY;
  
  /// Gesture scale
  final double scale;
  
  /// Gesture rotation
  final double rotation;
  
  /// Gesture velocity
  final double velocityX;
  final double velocityY;
  
  /// Create gesture event
  GestureEvent({
    required this.centerX,
    required this.centerY,
    this.scale = 1.0,
    this.rotation = 0.0,
    this.velocityX = 0.0,
    this.velocityY = 0.0,
  });
}

/// Pinch gesture event
class PinchGestureEvent extends GestureEvent {
  /// Pinch start scale
  final double startScale;
  
  /// Pinch delta scale
  final double deltaScale;
  
  /// Create pinch gesture event
  PinchGestureEvent({
    required super.centerX,
    required super.centerY,
    required super.scale,
    required this.startScale,
    required this.deltaScale,
    super.rotation,
    super.velocityX,
    super.velocityY,
  });
}

/// Rotate gesture event
class RotateGestureEvent extends GestureEvent {
  /// Rotation delta in radians
  final double deltaRotation;
  
  /// Create rotate gesture event
  RotateGestureEvent({
    required super.centerX,
    required super.centerY,
    required super.rotation,
    required this.deltaRotation,
    super.scale,
    super.velocityX,
    super.velocityY,
  });
}

/// Pan gesture event
class PanGestureEvent extends GestureEvent {
  /// Pan start position
  final double startX;
  final double startY;
  
  /// Pan delta
  final double deltaX;
  final double deltaY;
  
  /// Create pan gesture event
  PanGestureEvent({
    required super.centerX,
    required super.centerY,
    required this.startX,
    required this.startY,
    required this.deltaX,
    required this.deltaY,
    super.scale,
    super.rotation,
    super.velocityX,
    super.velocityY,
  });
}

/// Swipe gesture event
class SwipeGestureEvent extends PanGestureEvent {
  /// Swipe direction
  final SwipeDirection direction;
  
  /// Swipe velocity
  final double velocity;
  
  /// Create swipe gesture event
  SwipeGestureEvent({
    required super.centerX,
    required super.centerY,
    required super.startX,
    required super.startY,
    required super.deltaX,
    required super.deltaY,
    required this.direction,
    required this.velocity,
    super.scale,
    super.rotation,
  });
}

/// Swipe direction
enum SwipeDirection {
  left,
  right,
  up,
  down,
  upLeft,
  upRight,
  downLeft,
  downRight,
}

/// Long press gesture event
class LongPressGestureEvent extends GestureEvent {
  /// Press duration in milliseconds
  final int duration;
  
  /// Create long press gesture event
  LongPressGestureEvent({
    required super.centerX,
    required super.centerY,
    required this.duration,
    super.scale,
    super.rotation,
    super.velocityX,
    super.velocityY,
  });
}

/// Tap gesture event
class TapGestureEvent extends GestureEvent {
  /// Tap count (for double/triple tap)
  final int tapCount;
  
  /// Create tap gesture event
  TapGestureEvent({
    required super.centerX,
    required super.centerY,
    this.tapCount = 1,
    super.scale,
    super.rotation,
    super.velocityX,
    super.velocityY,
  });
}

/// Touch state tracker
class TouchState {
  /// Active touch points by identifier
  final Map<int, TouchPoint> activeTouches = {};
  
  /// Previous touch state for delta calculations
  TouchState? previousState;
  
  /// Gesture recognition thresholds
  double swipeThreshold = 50.0; // pixels
  double swipeVelocityThreshold = 0.5; // pixels per millisecond
  int longPressThreshold = 500; // milliseconds
  double pinchThreshold = 0.1; // scale delta
  double rotationThreshold = 0.1; // radians
  
  /// Update touch state from event
  void updateFromEvent(TouchEvent event) {
    previousState = copy();
    
    // Update active touches
    for (final touch in event.touches) {
      activeTouches[touch.identifier] = touch;
    }
    
    // Remove ended touches
    for (final touch in event.changedTouches) {
      if (event is TouchEndEvent || event is TouchCancelEvent) {
        activeTouches.remove(touch.identifier);
      }
    }
  }
  
  /// Get touch point by identifier
  TouchPoint? getTouch(int identifier) {
    return activeTouches[identifier];
  }
  
  /// Check if touch is active
  bool isTouchActive(int identifier) {
    return activeTouches.containsKey(identifier);
  }
  
  /// Get number of active touches
  int get touchCount => activeTouches.length;
  
  /// Get all active touches
  List<TouchPoint> get touches => activeTouches.values.toList();
  
  /// Get center of all active touches
  (double, double) get center {
    if (activeTouches.isEmpty) return (0.0, 0.0);
    
    double sumX = 0.0;
    double sumY = 0.0;
    
    for (final touch in activeTouches.values) {
      sumX += touch.clientX;
      sumY += touch.clientY;
    }
    
    return (sumX / activeTouches.length, sumY / activeTouches.length);
  }
  
  /// Copy touch state
  TouchState copy() {
    final copy = TouchState();
    copy.activeTouches.addAll(activeTouches);
    return copy;
  }
  
  /// Reset touch state
  void reset() {
    activeTouches.clear();
    previousState = null;
  }
  
  /// Check if gesture can be recognized
  bool canRecognizeGesture(GestureType type) {
    switch (type) {
      case GestureType.pan:
        return touchCount == 1;
      case GestureType.pinch:
        return touchCount == 2;
      case GestureType.rotate:
        return touchCount == 2;
      case GestureType.swipe:
        return touchCount == 1;
      case GestureType.longPress:
        return touchCount == 1;
      case GestureType.tap:
        return touchCount == 1;
    }
  }
}

/// Gesture types
enum GestureType {
  pan,
  pinch,
  rotate,
  swipe,
  longPress,
  tap,
}
