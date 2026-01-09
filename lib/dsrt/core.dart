/// Core Engine API for DSRT Engine
/// 
/// Provides access to engine initialization, configuration, event system,
/// performance monitoring, and core utilities.
/// 
/// [includeDebugTools]: Whether to include debug utilities in exports.
/// Defaults to kDebugMode.
library dsrt_engine.public.core;

// Engine Main Class
export '../src/core/engine.dart' show DsrtEngine, DsrtEngineState;

// Engine Configuration
export '../src/core/engine_config.dart' 
    show EngineConfig, RenderBackend, PlatformTarget;

// Engine Settings
export '../src/core/settings.dart' 
    show EngineSettings, RenderQuality, AntiAliasing;

// Engine Constants
export '../src/core/constants.dart' show DsrtConstants;

// Engine Version
export '../src/core/version.dart' show EngineVersion, VersionInfo;

// Event System
export '../src/core/events/event_system.dart' 
    show EventSystem, EventType, EventPriority, EventListener;

// Keyboard Events
export '../src/core/events/keyboard_event.dart' 
    show KeyboardEvent, KeyCode, KeyAction, KeyModifier;

// Mouse Events
export '../src/core/events/mouse_event.dart' 
    show MouseEvent, MouseButton, MouseAction, MouseScrollDirection;

// Touch Events
export '../src/core/events/touch_event.dart' 
    show TouchEvent, TouchPhase, TouchType;

// Gamepad Events
export '../src/core/events/gamepad_event.dart' 
    show GamepadEvent, GamepadButton, GamepadAxis;

// Performance Monitoring
export '../src/core/performance/profiler.dart' 
    show Profiler, PerformanceMetric, FrameProfile;

// Performance Statistics
export '../src/core/performance/stats.dart' 
    show PerformanceStats, MemoryUsage, FrameTiming;

// Performance Monitor
export '../src/core/performance/monitor.dart' 
    show PerformanceMonitor, PerformanceThreshold;

// Logger System
export '../src/core/utils/logger.dart' 
    show Logger, LogLevel, LogFormatter, LogEntry;

// UUID Generator
export '../src/core/utils/uuid.dart' show UUID, UUIDGenerator;

// Debug Utilities
export '../src/core/utils/debug_utils.dart' 
    show DebugUtils, DebugDraw, DebugVisualization;

// Math Utilities
export '../src/core/utils/math_utils.dart' 
    show MathUtils, clamp, lerp, smoothStep;

// Game Loop System
export '../src/core/loop/game_loop.dart' 
    show GameLoop, LoopMode, LoopCallback;

// Game Clock
export '../src/core/loop/clock.dart' 
    show GameClock, ClockTime, TimeScale;

// Fixed Step Loop
export '../src/core/loop/fixed_step.dart' 
    show FixedStepLoop, FixedStepConfig;

// Variable Step Loop
export '../src/core/loop/variable_step.dart' 
    show VariableStepLoop, VariableStepConfig;
