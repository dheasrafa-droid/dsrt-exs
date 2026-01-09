/// Core system facade - exports only public core APIs
/// 
/// @license MIT
/// @copyright (c) 2024 DSRT Engine

library dsrt_core;

export '../src/core/engine.dart' show ExsEngine;
export '../src/core/engine_config.dart' show ExsEngineConfig;
export '../src/core/constants.dart' show ExsConstants;
export '../src/core/settings.dart' show ExsSettings;
export '../src/core/loop/game_loop.dart' show ExsGameLoop, ExsFixedStepLoop;
export '../src/core/events/event_system.dart' show ExsEventSystem, ExsEvent;
export '../src/core/events/event_types.dart' show ExsEventType;
export '../src/core/performance/profiler.dart' show ExsProfiler;
export '../src/core/performance/stats.dart' show ExsStats;
