/// DSRT Engine - Mouse Events
/// Mouse input event handling.
library dsrt_engine.src.core.events.mouse_event;

import 'dart:math' as math;
import 'event_system.dart';
import 'keyboard_event.dart';
import '../../utils/uuid.dart';

/// Mouse event base class
abstract class MouseEvent extends Event {
  /// Mouse position in viewport coordinates
  final double clientX;
  final double clientY;
  
  /// Mouse position in screen coordinates
  final double screenX;
  final double screenY;
  
  /// Mouse button (0: left, 1: middle, 2: right)
  final int button;
  
  /// Modifier keys state
  final ModifierKeys modifiers;
  
  /// Mouse wheel delta (for wheel events)
  final double deltaX;
  final double deltaY;
  final double deltaZ;
  
  /// Create mouse event
  MouseEvent({
    required this.clientX,
    required this.clientY,
    required this.screenX,
    required this.screenY,
    this.button = 0,
    ModifierKeys? modifiers,
    this.deltaX = 0.0,
    this.deltaY = 0.0,
    this.deltaZ = 0.0,
  }) : modifiers = modifiers ?? ModifierKeys.none();
  
  /// Get distance from another mouse event
  double distanceTo(MouseEvent other) {
    final dx = clientX - other.clientX;
    final dy = clientY - other.clientY;
    return math.sqrt(dx * dx + dy * dy);
  }
  
  /// Get movement vector from another mouse event
  (double, double) movementFrom(MouseEvent other) {
    return (clientX - other.clientX, clientY - other.clientY);
  }
}

/// Mouse move event
class MouseMoveEvent extends MouseEvent {
  /// Movement since last mouse move
  final double movementX;
  final double movementY;
  
  /// Create mouse move event
  MouseMoveEvent({
    required super.clientX,
    required super.clientY,
    required super.screenX,
    required super.screenY,
    super.modifiers,
    this.movementX = 0.0,
    this.movementY = 0.0,
  });
  
  /// Create with movement calculated from previous event
  factory MouseMoveEvent.withMovement({
    required double clientX,
    required double clientY,
    required double screenX,
    required double screenY,
    required MouseEvent? previous,
    ModifierKeys? modifiers,
  }) {
    if (previous == null) {
      return MouseMoveEvent(
        clientX: clientX,
        clientY: clientY,
        screenX: screenX,
        screenY: screenY,
        modifiers: modifiers,
      );
    }
    
    return MouseMoveEvent(
      clientX: clientX,
      clientY: clientY,
      screenX: screenX,
      screenY: screenY,
      modifiers: modifiers,
      movementX: clientX - previous.clientX,
      movementY: clientY - previous.clientY,
    );
  }
}

/// Mouse down event
class MouseDownEvent extends MouseEvent {
  /// Click count (for double/triple clicks)
  final int clickCount;
  
  /// Create mouse down event
  MouseDownEvent({
    required super.clientX,
    required super.clientY,
    required super.screenX,
    required super.screenY,
    required super.button,
    super.modifiers,
    this.clickCount = 1,
  });
}

/// Mouse up event
class MouseUpEvent extends MouseEvent {
  /// Click count (for double/triple clicks)
  final int clickCount;
  
  /// Create mouse up event
  MouseUpEvent({
    required super.clientX,
    required super.clientY,
    required super.screenX,
    required super.screenY,
    required super.button,
    super.modifiers,
    this.clickCount = 1,
  });
}

/// Mouse click event
class MouseClickEvent extends MouseEvent {
  /// Click count (for double/triple clicks)
  final int clickCount;
  
  /// Time between mousedown and mouseup (in milliseconds)
  final int clickDuration;
  
  /// Create mouse click event
  MouseClickEvent({
    required super.clientX,
    required super.clientY,
    required super.screenX,
    required super.screenY,
    required super.button,
    super.modifiers,
    this.clickCount = 1,
    this.clickDuration = 0,
  });
}

/// Mouse double click event
class MouseDoubleClickEvent extends MouseClickEvent {
  /// Create mouse double click event
  MouseDoubleClickEvent({
    required super.clientX,
    required super.clientY,
    required super.screenX,
    required super.screenY,
    required super.button,
    super.modifiers,
    super.clickDuration,
  }) : super(clickCount: 2);
}

/// Mouse wheel event
class MouseWheelEvent extends MouseEvent {
  /// Wheel mode (pixel, line, page)
  final WheelMode mode;
  
  /// Wheel delta in lines or pixels
  final double delta;
  
  /// Create mouse wheel event
  MouseWheelEvent({
    required super.clientX,
    required super.clientY,
    required super.screenX,
    required super.screenY,
    super.modifiers,
    required super.deltaX,
    required super.deltaY,
    super.deltaZ = 0.0,
    this.mode = WheelMode.pixel,
    this.delta = 0.0,
  });
}

/// Mouse enter event
class MouseEnterEvent extends MouseEvent {
  /// Create mouse enter event
  MouseEnterEvent({
    required super.clientX,
    required super.clientY,
    required super.screenX,
    required super.screenY,
    super.modifiers,
  });
}

/// Mouse leave event
class MouseLeaveEvent extends MouseEvent {
  /// Create mouse leave event
  MouseLeaveEvent({
    required super.clientX,
    required super.clientY,
    required super.screenX,
    required super.screenY,
    super.modifiers,
  });
}

/// Mouse drag event
class MouseDragEvent extends MouseEvent {
  /// Drag start position
  final double startX;
  final double startY;
  
  /// Total drag distance
  final double distanceX;
  final double distanceY;
  
  /// Create mouse drag event
  MouseDragEvent({
    required super.clientX,
    required super.clientY,
    required super.screenX,
    required super.screenY,
    required super.button,
    super.modifiers,
    required this.startX,
    required this.startY,
    this.distanceX = 0.0,
    this.distanceY = 0.0,
  });
}

/// Mouse drag start event
class MouseDragStartEvent extends MouseDragEvent {
  /// Create mouse drag start event
  MouseDragStartEvent({
    required double clientX,
    required double clientY,
    required double screenX,
    required double screenY,
    required int button,
    ModifierKeys? modifiers,
  }) : super(
          clientX: clientX,
          clientY: clientY,
          screenX: screenX,
          screenY: screenY,
          button: button,
          modifiers: modifiers,
          startX: clientX,
          startY: clientY,
        );
}

/// Mouse drag end event
class MouseDragEndEvent extends MouseDragEvent {
  /// Drag duration in milliseconds
  final int dragDuration;
  
  /// Create mouse drag end event
  MouseDragEndEvent({
    required super.clientX,
    required super.clientY,
    required super.screenX,
    required super.screenY,
    required super.button,
    super.modifiers,
    required super.startX,
    required super.startY,
    required this.dragDuration,
  });
}

/// Mouse context menu event
class MouseContextMenuEvent extends MouseEvent {
  /// Create mouse context menu event
  MouseContextMenuEvent({
    required super.clientX,
    required super.clientY,
    required super.screenX,
    required super.screenY,
    super.modifiers,
  });
}

/// Mouse button constants
class MouseButtons {
  static const int none = 0;
  static const int left = 1;
  static const int right = 2;
  static const int middle = 4;
  static const int back = 8;
  static const int forward = 16;
  
  /// Check if button is pressed in button mask
  static bool isPressed(int buttonMask, int button) {
    return (buttonMask & button) != 0;
  }
  
  /// Get button name
  static String getName(int button) {
    switch (button) {
      case left:
        return 'Left';
      case right:
        return 'Right';
      case middle:
        return 'Middle';
      case back:
        return 'Back';
      case forward:
        return 'Forward';
      default:
        return 'Button($button)';
    }
  }
}

/// Wheel mode
enum WheelMode {
  pixel,
  line,
  page,
}

/// Mouse state tracker
class MouseState {
  /// Current mouse position
  double clientX = 0.0;
  double clientY = 0.0;
  
  /// Previous mouse position
  double previousClientX = 0.0;
  double previousClientY = 0.0;
  
  /// Mouse button states
  int buttonMask = 0;
  
  /// Modifier keys state
  ModifierKeys modifiers = ModifierKeys.none();
  
  /// Mouse wheel state
  double wheelX = 0.0;
  double wheelY = 0.0;
  double wheelZ = 0.0;
  
  /// Mouse over state
  bool isOver = false;
  
  /// Last click time for double click detection
  DateTime? lastClickTime;
  
  /// Last click position for double click detection
  double lastClickX = 0.0;
  double lastClickY = 0.0;
  
  /// Double click threshold in milliseconds
  int doubleClickThreshold = 500;
  
  /// Double click distance threshold in pixels
  double doubleClickDistanceThreshold = 5.0;
  
  /// Update mouse position
  void updatePosition(double x, double y) {
    previousClientX = clientX;
    previousClientY = clientY;
    clientX = x;
    clientY = y;
  }
  
  /// Set button state
  void setButton(int button, bool pressed) {
    if (pressed) {
      buttonMask |= button;
    } else {
      buttonMask &= ~button;
    }
  }
  
  /// Check if button is pressed
  bool isButtonPressed(int button) {
    return (buttonMask & button) != 0;
  }
  
  /// Check if any button is pressed
  bool get anyButtonPressed => buttonMask != 0;
  
  /// Get movement since last update
  (double, double) get movement {
    return (clientX - previousClientX, clientY - previousClientY);
  }
  
  /// Record click for double click detection
  bool recordClick(double x, double y) {
    final now = DateTime.now();
    final isDoubleClick = lastClickTime != null &&
        now.difference(lastClickTime!).inMilliseconds <= doubleClickThreshold &&
        (x - lastClickX).abs() <= doubleClickDistanceThreshold &&
        (y - lastClickY).abs() <= doubleClickDistanceThreshold;
    
    lastClickTime = now;
    lastClickX = x;
    lastClickY = y;
    
    return isDoubleClick;
  }
  
  /// Reset mouse state
  void reset() {
    clientX = 0.0;
    clientY = 0.0;
    previousClientX = 0.0;
    previousClientY = 0.0;
    buttonMask = 0;
    modifiers = ModifierKeys.none();
    wheelX = 0.0;
    wheelY = 0.0;
    wheelZ = 0.0;
    isOver = false;
    lastClickTime = null;
    lastClickX = 0.0;
    lastClickY = 0.0;
  }
}
