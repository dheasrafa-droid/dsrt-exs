/// DSRT Engine - Keyboard Events
/// Keyboard input event handling.
library dsrt_engine.src.core.events.keyboard_event;

import 'event_system.dart';
import '../../utils/uuid.dart';

/// Keyboard event base class
abstract class KeyboardEvent extends Event {
  /// Key code
  final int keyCode;
  
  /// Key character
  final String? keyChar;
  
  /// Key location
  final KeyLocation location;
  
  /// Modifier keys state
  final ModifierKeys modifiers;
  
  /// Create keyboard event
  KeyboardEvent({
    required this.keyCode,
    this.keyChar,
    this.location = KeyLocation.standard,
    ModifierKeys? modifiers,
  }) : modifiers = modifiers ?? ModifierKeys.none();
  
  /// Check if a specific modifier is pressed
  bool isModifierPressed(ModifierKey modifier) {
    return modifiers.isPressed(modifier);
  }
}

/// Key pressed event
class KeyDownEvent extends KeyboardEvent {
  /// Repeat count (0 for first press)
  final int repeatCount;
  
  /// Create key down event
  KeyDownEvent({
    required super.keyCode,
    super.keyChar,
    super.location,
    super.modifiers,
    this.repeatCount = 0,
  });
  
  /// Check if this is a repeat key press
  bool get isRepeat => repeatCount > 0;
}

/// Key released event
class KeyUpEvent extends KeyboardEvent {
  /// Create key up event
  KeyUpEvent({
    required super.keyCode,
    super.keyChar,
    super.location,
    super.modifiers,
  });
}

/// Key typed event (character input)
class KeyTypedEvent extends Event {
  /// Typed character
  final String character;
  
  /// Modifier keys state
  final ModifierKeys modifiers;
  
  /// Create key typed event
  KeyTypedEvent({
    required this.character,
    ModifierKeys? modifiers,
  }) : modifiers = modifiers ?? ModifierKeys.none();
}

/// Modifier keys state
class ModifierKeys {
  /// Shift key pressed
  final bool shift;
  
  /// Control key pressed
  final bool control;
  
  /// Alt key pressed
  final bool alt;
  
  /// Meta key pressed (Command on Mac, Windows key on Windows)
  final bool meta;
  
  /// Caps lock enabled
  final bool capsLock;
  
  /// Num lock enabled
  final bool numLock;
  
  /// Scroll lock enabled
  final bool scrollLock;
  
  /// Create modifier keys state
  const ModifierKeys({
    this.shift = false,
    this.control = false,
    this.alt = false,
    this.meta = false,
    this.capsLock = false,
    this.numLock = false,
    this.scrollLock = false,
  });
  
  /// No modifiers pressed
  factory ModifierKeys.none() => const ModifierKeys();
  
  /// All modifiers pressed
  factory ModifierKeys.all() => const ModifierKeys(
    shift: true,
    control: true,
    alt: true,
    meta: true,
  );
  
  /// Check if any modifier is pressed
  bool get anyPressed => shift || control || alt || meta;
  
  /// Check if specific modifier is pressed
  bool isPressed(ModifierKey modifier) {
    switch (modifier) {
      case ModifierKey.shift:
        return shift;
      case ModifierKey.control:
        return control;
      case ModifierKey.alt:
        return alt;
      case ModifierKey.meta:
        return meta;
      case ModifierKey.capsLock:
        return capsLock;
      case ModifierKey.numLock:
        return numLock;
      case ModifierKey.scrollLock:
        return scrollLock;
    }
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ModifierKeys &&
        shift == other.shift &&
        control == other.control &&
        alt == other.alt &&
        meta == other.meta &&
        capsLock == other.capsLock &&
        numLock == other.numLock &&
        scrollLock == other.scrollLock;
  }
  
  @override
  int get hashCode {
    return Object.hash(
      shift,
      control,
      alt,
      meta,
      capsLock,
      numLock,
      scrollLock,
    );
  }
  
  @override
  String toString() {
    final parts = <String>[];
    if (shift) parts.add('Shift');
    if (control) parts.add('Ctrl');
    if (alt) parts.add('Alt');
    if (meta) parts.add('Meta');
    if (capsLock) parts.add('CapsLock');
    if (numLock) parts.add('NumLock');
    if (scrollLock) parts.add('ScrollLock');
    return parts.isEmpty ? 'None' : parts.join('+');
  }
}

/// Modifier key types
enum ModifierKey {
  shift,
  control,
  alt,
  meta,
  capsLock,
  numLock,
  scrollLock,
}

/// Key location on keyboard
enum KeyLocation {
  standard,    // Standard key location
  left,        // Left variant (e.g., left Shift)
  right,       // Right variant (e.g., right Shift)
  numpad,      // Numpad key
}

/// Key code constants
class KeyCodes {
  // Special keys
  static const int backspace = 8;
  static const int tab = 9;
  static const int enter = 13;
  static const int shift = 16;
  static const int ctrl = 17;
  static const int alt = 18;
  static const int pause = 19;
  static const int capsLock = 20;
  static const int escape = 27;
  static const int space = 32;
  static const int pageUp = 33;
  static const int pageDown = 34;
  static const int end = 35;
  static const int home = 36;
  static const int arrowLeft = 37;
  static const int arrowUp = 38;
  static const int arrowRight = 39;
  static const int arrowDown = 40;
  static const int insert = 45;
  static const int delete = 46;
  
  // Number keys
  static const int digit0 = 48;
  static const int digit1 = 49;
  static const int digit2 = 50;
  static const int digit3 = 51;
  static const int digit4 = 52;
  static const int digit5 = 53;
  static const int digit6 = 54;
  static const int digit7 = 55;
  static const int digit8 = 56;
  static const int digit9 = 57;
  
  // Letter keys
  static const int a = 65;
  static const int b = 66;
  static const int c = 67;
  static const int d = 68;
  static const int e = 69;
  static const int f = 70;
  static const int g = 71;
  static const int h = 72;
  static const int i = 73;
  static const int j = 74;
  static const int k = 75;
  static const int l = 76;
  static const int m = 77;
  static const int n = 78;
  static const int o = 79;
  static const int p = 80;
  static const int q = 81;
  static const int r = 82;
  static const int s = 83;
  static const int t = 84;
  static const int u = 85;
  static const int v = 86;
  static const int w = 87;
  static const int x = 88;
  static const int y = 89;
  static const int z = 90;
  
  // Function keys
  static const int f1 = 112;
  static const int f2 = 113;
  static const int f3 = 114;
  static const int f4 = 115;
  static const int f5 = 116;
  static const int f6 = 117;
  static const int f7 = 118;
  static const int f8 = 119;
  static const int f9 = 120;
  static const int f10 = 121;
  static const int f11 = 122;
  static const int f12 = 123;
  
  // Symbol keys
  static const int semicolon = 186;
  static const int equal = 187;
  static const int comma = 188;
  static const int minus = 189;
  static const int period = 190;
  static const int slash = 191;
  static const int backquote = 192;
  static const int bracketLeft = 219;
  static const int backslash = 220;
  static const int bracketRight = 221;
  static const int quote = 222;
  
  // Numpad keys
  static const int numpad0 = 96;
  static const int numpad1 = 97;
  static const int numpad2 = 98;
  static const int numpad3 = 99;
  static const int numpad4 = 100;
  static const int numpad5 = 101;
  static const int numpad6 = 102;
  static const int numpad7 = 103;
  static const int numpad8 = 104;
  static const int numpad9 = 105;
  static const int numpadMultiply = 106;
  static const int numpadAdd = 107;
  static const int numpadSubtract = 109;
  static const int numpadDecimal = 110;
  static const int numpadDivide = 111;
  
  /// Get key name from code
  static String getName(int keyCode) {
    switch (keyCode) {
      case backspace:
        return 'Backspace';
      case tab:
        return 'Tab';
      case enter:
        return 'Enter';
      case shift:
        return 'Shift';
      case ctrl:
        return 'Ctrl';
      case alt:
        return 'Alt';
      case pause:
        return 'Pause';
      case capsLock:
        return 'CapsLock';
      case escape:
        return 'Escape';
      case space:
        return 'Space';
      case pageUp:
        return 'PageUp';
      case pageDown:
        return 'PageDown';
      case end:
        return 'End';
      case home:
        return 'Home';
      case arrowLeft:
        return 'ArrowLeft';
      case arrowUp:
        return 'ArrowUp';
      case arrowRight:
        return 'ArrowRight';
      case arrowDown:
        return 'ArrowDown';
      case insert:
        return 'Insert';
      case delete:
        return 'Delete';
        
      // Numbers
      case digit0:
        return '0';
      case digit1:
        return '1';
      case digit2:
        return '2';
      case digit3:
        return '3';
      case digit4:
        return '4';
      case digit5:
        return '5';
      case digit6:
        return '6';
      case digit7:
        return '7';
      case digit8:
        return '8';
      case digit9:
        return '9';
        
      // Letters
      case a:
        return 'A';
      case b:
        return 'B';
      case c:
        return 'C';
      case d:
        return 'D';
      case e:
        return 'E';
      case f:
        return 'F';
      case g:
        return 'G';
      case h:
        return 'H';
      case i:
        return 'I';
      case j:
        return 'J';
      case k:
        return 'K';
      case l:
        return 'L';
      case m:
        return 'M';
      case n:
        return 'N';
      case o:
        return 'O';
      case p:
        return 'P';
      case q:
        return 'Q';
      case r:
        return 'R';
      case s:
        return 'S';
      case t:
        return 'T';
      case u:
        return 'U';
      case v:
        return 'V';
      case w:
        return 'W';
      case x:
        return 'X';
      case y:
        return 'Y';
      case z:
        return 'Z';
        
      // Function keys
      case f1:
        return 'F1';
      case f2:
        return 'F2';
      case f3:
        return 'F3';
      case f4:
        return 'F4';
      case f5:
        return 'F5';
      case f6:
        return 'F6';
      case f7:
        return 'F7';
      case f8:
        return 'F8';
      case f9:
        return 'F9';
      case f10:
        return 'F10';
      case f11:
        return 'F11';
      case f12:
        return 'F12';
        
      // Symbols
      case semicolon:
        return ';';
      case equal:
        return '=';
      case comma:
        return ',';
      case minus:
        return '-';
      case period:
        return '.';
      case slash:
        return '/';
      case backquote:
        return '`';
      case bracketLeft:
        return '[';
      case backslash:
        return '\\';
      case bracketRight:
        return ']';
      case quote:
        return "'";
        
      default:
        return 'Key($keyCode)';
    }
  }
}
