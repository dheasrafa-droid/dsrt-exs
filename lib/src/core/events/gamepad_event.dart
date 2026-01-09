/// DSRT Engine - Gamepad Events
/// Gamepad/controller input event handling.
library dsrt_engine.src.core.events.gamepad_event;

import 'dart:math' as math;
import 'event_system.dart';
import '../../utils/uuid.dart';

/// Gamepad axis information
class GamepadAxis {
  /// Axis index (0-based)
  final int index;
  
  /// Axis value (-1.0 to 1.0)
  final double value;
  
  /// Previous axis value
  final double previousValue;
  
  /// Create gamepad axis
  GamepadAxis({
    required this.index,
    required this.value,
    this.previousValue = 0.0,
  });
  
  /// Check if axis value changed
  bool get changed => value != previousValue;
  
  /// Get axis change delta
  double get delta => value - previousValue;
  
  /// Check if axis is pressed (absolute value > threshold)
  bool isPressed(double threshold) {
    return value.abs() > threshold;
  }
}

/// Gamepad button information
class GamepadButton {
  /// Button index (0-based)
  final int index;
  
  /// Button value (0.0 to 1.0)
  final double value;
  
  /// Previous button value
  final double previousValue;
  
  /// Button pressed state
  final bool pressed;
  
  /// Previous pressed state
  final bool previousPressed;
  
  /// Button touched state
  final bool touched;
  
  /// Create gamepad button
  GamepadButton({
    required this.index,
    required this.value,
    required this.pressed,
    required this.touched,
    this.previousValue = 0.0,
    this.previousPressed = false,
  });
  
  /// Check if button value changed
  bool get valueChanged => value != previousValue;
  
  /// Check if pressed state changed
  bool get pressedChanged => pressed != previousPressed;
  
  /// Check if button was just pressed
  bool get wasPressed => pressed && !previousPressed;
  
  /// Check if button was just released
  bool get wasReleased => !pressed && previousPressed;
  
  /// Get button value delta
  double get delta => value - previousValue;
}

/// Gamepad state
class GamepadState {
  /// Gamepad index
  final int index;
  
  /// Gamepad ID
  final String id;
  
  /// Gamepad mapping
  final String mapping;
  
  /// Gamepad connected state
  final bool connected;
  
  /// Gamepad timestamp
  final double timestamp;
  
  /// Gamepad axes
  final List<GamepadAxis> axes;
  
  /// Gamepad buttons
  final List<GamepadButton> buttons;
  
  /// Previous gamepad state
  final GamepadState? previous;
  
  /// Create gamepad state
  GamepadState({
    required this.index,
    required this.id,
    required this.mapping,
    required this.connected,
    required this.timestamp,
    required this.axes,
    required this.buttons,
    this.previous,
  });
  
  /// Get axis by index
  GamepadAxis? getAxis(int index) {
    if (index >= 0 && index < axes.length) {
      return axes[index];
    }
    return null;
  }
  
  /// Get button by index
  GamepadButton? getButton(int index) {
    if (index >= 0 && index < buttons.length) {
      return buttons[index];
    }
    return null;
  }
  
  /// Check if any button is pressed
  bool get anyButtonPressed {
    for (final button in buttons) {
      if (button.pressed) return true;
    }
    return false;
  }
  
  /// Check if any axis is active (above threshold)
  bool get anyAxisActive {
    for (final axis in axes) {
      if (axis.value.abs() > 0.1) return true;
    }
    return false;
  }
  
  /// Get deadzone-adjusted axis value
  double getAxisWithDeadzone(int index, double deadzone) {
    final axis = getAxis(index);
    if (axis == null) return 0.0;
    
    final value = axis.value;
    if (value.abs() < deadzone) return 0.0;
    
    // Apply circular deadzone for joysticks
    if (index == 0 || index == 1) {
      // Left stick
      final x = getAxis(0)?.value ?? 0.0;
      final y = getAxis(1)?.value ?? 0.0;
      
      final magnitude = math.sqrt(x * x + y * y);
      if (magnitude < deadzone) return 0.0;
      
      // Scale to maintain direction
      final scale = (magnitude - deadzone) / (1.0 - deadzone);
      return value / magnitude * scale;
    }
    
    // Linear scaling for other axes
    return value.sign * (value.abs() - deadzone) / (1.0 - deadzone);
  }
  
  /// Copy gamepad state
  GamepadState copy() {
    return GamepadState(
      index: index,
      id: id,
      mapping: mapping,
      connected: connected,
      timestamp: timestamp,
      axes: List.from(axes),
      buttons: List.from(buttons),
      previous: this,
    );
  }
}

/// Gamepad event base class
abstract class GamepadEvent extends Event {
  /// Gamepad index
  final int gamepadIndex;
  
  /// Gamepad ID
  final String gamepadId;
  
  /// Create gamepad event
  GamepadEvent({
    required this.gamepadIndex,
    required this.gamepadId,
  });
}

/// Gamepad connected event
class GamepadConnectedEvent extends GamepadEvent {
  /// Gamepad mapping
  final String mapping;
  
  /// Number of axes
  final int axesCount;
  
  /// Number of buttons
  final int buttonsCount;
  
  /// Create gamepad connected event
  GamepadConnectedEvent({
    required super.gamepadIndex,
    required super.gamepadId,
    required this.mapping,
    required this.axesCount,
    required this.buttonsCount,
  });
}

/// Gamepad disconnected event
class GamepadDisconnectedEvent extends GamepadEvent {
  /// Create gamepad disconnected event
  GamepadDisconnectedEvent({
    required super.gamepadIndex,
    required super.gamepadId,
  });
}

/// Gamepad button event
class GamepadButtonEvent extends GamepadEvent {
  /// Button index
  final int buttonIndex;
  
  /// Button value (0.0 to 1.0)
  final double value;
  
  /// Previous button value
  final double previousValue;
  
  /// Button pressed state
  final bool pressed;
  
  /// Previous pressed state
  final bool previousPressed;
  
  /// Button touched state
  final bool touched;
  
  /// Create gamepad button event
  GamepadButtonEvent({
    required super.gamepadIndex,
    required super.gamepadId,
    required this.buttonIndex,
    required this.value,
    required this.pressed,
    required this.touched,
    this.previousValue = 0.0,
    this.previousPressed = false,
  });
  
  /// Check if button was just pressed
  bool get wasPressed => pressed && !previousPressed;
  
  /// Check if button was just released
  bool get wasReleased => !pressed && previousPressed;
}

/// Gamepad axis event
class GamepadAxisEvent extends GamepadEvent {
  /// Axis index
  final int axisIndex;
  
  /// Axis value (-1.0 to 1.0)
  final double value;
  
  /// Previous axis value
  final double previousValue;
  
  /// Create gamepad axis event
  GamepadAxisEvent({
    required super.gamepadIndex,
    required super.gamepadId,
    required this.axisIndex,
    required this.value,
    this.previousValue = 0.0,
  });
  
  /// Check if axis value changed
  bool get changed => value != previousValue;
  
  /// Get axis change delta
  double get delta => value - previousValue;
}

/// Gamepad state event
class GamepadStateEvent extends GamepadEvent {
  /// Gamepad state
  final GamepadState state;
  
  /// Previous gamepad state
  final GamepadState? previousState;
  
  /// Create gamepad state event
  GamepadStateEvent({
    required super.gamepadIndex,
    required super.gamepadId,
    required this.state,
    this.previousState,
  });
}

/// Gamepad vibration event
class GamepadVibrationEvent extends GamepadEvent {
  /// Vibration duration in milliseconds
  final int duration;
  
  /// Weak motor intensity (0.0 to 1.0)
  final double weakMagnitude;
  
  /// Strong motor intensity (0.0 to 1.0)
  final double strongMagnitude;
  
  /// Create gamepad vibration event
  GamepadVibrationEvent({
    required super.gamepadIndex,
    required super.gamepadId,
    required this.duration,
    required this.weakMagnitude,
    required this.strongMagnitude,
  });
}

/// Gamepad button constants
class GamepadButtons {
  // Standard gamepad buttons (Xbox layout)
  static const int a = 0;
  static const int b = 1;
  static const int x = 2;
  static const int y = 3;
  static const int leftShoulder = 4;
  static const int rightShoulder = 5;
  static const int leftTrigger = 6;
  static const int rightTrigger = 7;
  static const int back = 8;
  static const int start = 9;
  static const int leftStick = 10;
  static const int rightStick = 11;
  static const int dpadUp = 12;
  static const int dpadDown = 13;
  static const int dpadLeft = 14;
  static const int dpadRight = 15;
  static const int guide = 16;
  
  /// Get button name
  static String getName(int button) {
    switch (button) {
      case a:
        return 'A';
      case b:
        return 'B';
      case x:
        return 'X';
      case y:
        return 'Y';
      case leftShoulder:
        return 'Left Shoulder';
      case rightShoulder:
        return 'Right Shoulder';
      case leftTrigger:
        return 'Left Trigger';
      case rightTrigger:
        return 'Right Trigger';
      case back:
        return 'Back';
      case start:
        return 'Start';
      case leftStick:
        return 'Left Stick';
      case rightStick:
        return 'Right Stick';
      case dpadUp:
        return 'D-Pad Up';
      case dpadDown:
        return 'D-Pad Down';
      case dpadLeft:
        return 'D-Pad Left';
      case dpadRight:
        return 'D-Pad Right';
      case guide:
        return 'Guide';
      default:
        return 'Button $button';
    }
  }
}

/// Gamepad axis constants
class GamepadAxes {
  // Standard gamepad axes (Xbox layout)
  static const int leftStickX = 0;
  static const int leftStickY = 1;
  static const int rightStickX = 2;
  static const int rightStickY = 3;
  
  /// Get axis name
  static String getName(int axis) {
    switch (axis) {
      case leftStickX:
        return 'Left Stick X';
      case leftStickY:
        return 'Left Stick Y';
      case rightStickX:
        return 'Right Stick X';
      case rightStickY:
        return 'Right Stick Y';
      default:
        return 'Axis $axis';
    }
  }
}

/// Gamepad manager for tracking gamepad states
class GamepadManager {
  /// Connected gamepads by index
  final Map<int, GamepadState> _gamepads = {};
  
  /// Gamepad update interval in milliseconds
  int updateInterval = 16; // ~60Hz
  
  /// Gamepad deadzone
  double deadzone = 0.1;
  
  /// Vibration support
  bool vibrationSupported = false;
  
  /// Get connected gamepads
  List<GamepadState> get gamepads => _gamepads.values.toList();
  
  /// Get gamepad by index
  GamepadState? getGamepad(int index) {
    return _gamepads[index];
  }
  
  /// Check if gamepad is connected
  bool isGamepadConnected(int index) {
    return _gamepads.containsKey(index);
  }
  
  /// Get number of connected gamepads
  int get connectedCount => _gamepads.length;
  
  /// Update gamepad state
  void updateGamepad(int index, GamepadState state) {
    final previous = _gamepads[index];
    _gamepads[index] = state.copy();
    
    // Dispatch events for changes
    if (previous == null) {
      // Gamepad connected
      _dispatchGamepadConnected(index, state);
    } else {
      // Check for button changes
      _checkButtonChanges(index, previous, state);
      
      // Check for axis changes
      _checkAxisChanges(index, previous, state);
    }
  }
  
  /// Remove gamepad
  void removeGamepad(int index) {
    final state = _gamepads.remove(index);
    if (state != null) {
      _dispatchGamepadDisconnected(index, state);
    }
  }
  
  /// Vibrate gamepad
  Future<bool> vibrate(
    int index, {
    double weakMagnitude = 0.5,
    double strongMagnitude = 0.5,
    int duration = 1000,
  }) async {
    if (!vibrationSupported) return false;
    
    final gamepad = _gamepads[index];
    if (gamepad == null) return false;
    
    // Implementation depends on platform
    // Web: navigator.getGamepads()[index].vibrationActuator
    // Native: platform-specific implementation
    
    return false; // Placeholder
  }
  
  /// Reset all gamepads
  void reset() {
    _gamepads.clear();
  }
  
  // Private methods
  
  /// Dispatch gamepad connected event
  void _dispatchGamepadConnected(int index, GamepadState state) {
    // This would be connected to the event system
    // eventSystem.dispatch(GamepadConnectedEvent(...));
  }
  
  /// Dispatch gamepad disconnected event
  void _dispatchGamepadDisconnected(int index, GamepadState state) {
    // This would be connected to the event system
    // eventSystem.dispatch(GamepadDisconnectedEvent(...));
  }
  
  /// Check for button changes
  void _checkButtonChanges(int index, GamepadState previous, GamepadState current) {
    for (int i = 0; i < current.buttons.length; i++) {
      final currentButton = current.buttons[i];
      final previousButton = i < previous.buttons.length ? previous.buttons[i] : null;
      
      if (previousButton == null) continue;
      
      if (currentButton.value != previousButton.value ||
          currentButton.pressed != previousButton.pressed) {
        _dispatchButtonEvent(index, current, currentButton, previousButton);
      }
    }
  }
  
  /// Check for axis changes
  void _checkAxisChanges(int index, GamepadState previous, GamepadState current) {
    for (int i = 0; i < current.axes.length; i++) {
      final currentAxis = current.axes[i];
      final previousAxis = i < previous.axes.length ? previous.axes[i] : null;
      
      if (previousAxis == null) continue;
      
      if (currentAxis.value != previousAxis.value) {
        _dispatchAxisEvent(index, current, currentAxis, previousAxis);
      }
    }
  }
  
  /// Dispatch button event
  void _dispatchButtonEvent(
    int index,
    GamepadState state,
    GamepadButton current,
    GamepadButton previous,
  ) {
    // This would be connected to the event system
    // eventSystem.dispatch(GamepadButtonEvent(...));
  }
  
  /// Dispatch axis event
  void _dispatchAxisEvent(
    int index,
    GamepadState state,
    GamepadAxis current,
    GamepadAxis previous,
  ) {
    // This would be connected to the event system
    // eventSystem.dispatch(GamepadAxisEvent(...));
  }
}
