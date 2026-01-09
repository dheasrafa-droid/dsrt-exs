/// Alternative Exports for DSRT Engine
/// 
/// Provides alternative export groupings for tree-shaking and
/// specialized use cases like web-only or mobile-only builds.
/// 
/// [target]: The target platform for optimized exports.
/// Defaults to 'all'.
library dsrt_engine.public.exports;

// Web-only exports (tree-shaken for web)
export 'core.dart' if (dart.library.html) 'web/core_web.dart';
export 'renderer.dart' if (dart.library.html) 'web/renderer_web.dart';
export 'audio.dart' if (dart.library.html) 'web/audio_web.dart';

// Mobile-only exports
export 'camera.dart' if (dart.library.io) 'mobile/camera_mobile.dart';
export 'ui.dart' if (dart.library.io) 'mobile/ui_mobile.dart';

// Desktop-only exports  
export 'tools.dart' if (dart.library.io) 'desktop/tools_desktop.dart';

// Minimal core (no renderer)
export 'core.dart';
export 'math.dart';
export 'scene.dart';
export 'camera.dart';
export 'geometry.dart';
export 'materials.dart'
    hide WebGLRenderer, WebGPURenderer, EffectComposer;
export 'objects.dart';
export 'lights.dart';
export 'textures.dart';
export 'loaders.dart';
export 'animation.dart';
export 'physics.dart'
    hide AmmoPlugin, BulletPlugin, CannonPlugin, PhysXPlugin;
export 'audio.dart'
    hide WebAudioContext, MediaElementSourceNode;
export 'ui.dart'
    hide DOMOverlay, VROverlay, AROverlay;
export 'constants.dart';
export 'types.dart';
export 'enums.dart';

// Graphics only (no physics/audio)
export 'core.dart'
    hide PhysicsWorld, AudioContext, UIManager;
export 'math.dart';
export 'scene.dart';
export 'camera.dart';
export 'geometry.dart';
export 'materials.dart';
export 'renderer.dart';
export 'objects.dart';
export 'lights.dart';
export 'textures.dart';
export 'loaders.dart';
export 'animation.dart';
export 'constants.dart';
export 'types.dart';
export 'enums.dart';

// Physics only (no rendering)
export 'core.dart'
    hide Renderer, Camera, Material, Texture;
export 'math.dart';
export 'scene.dart'
    hide Material, Texture, Renderer;
export 'geometry.dart';
export 'physics.dart';
export 'constants.dart';
export 'types.dart';
export 'enums.dart';

// Audio only (no graphics/physics)
export 'core.dart'
    hide Renderer, PhysicsWorld, Camera, Material;
export 'math.dart';
export 'audio.dart';
export 'constants.dart';
export 'types.dart';
export 'enums.dart';

// UI only (no 3D)
export 'core.dart'
    hide Renderer, PhysicsWorld, AudioContext, Camera;
export 'math.dart';
export 'ui.dart';
export 'constants.dart';
export 'types.dart';
export 'enums.dart';

// VR/AR only
export 'core.dart';
export 'math.dart';
export 'scene.dart';
export 'camera.dart';
export 'renderer.dart';
export 'plugins.dart'
    show VRManager, ARManager, XRManager;
export 'constants.dart';
export 'types.dart';
export 'enums.dart';

// Editor tools only
export 'core.dart';
export 'math.dart';
export 'scene.dart';
export 'camera.dart';
export 'geometry.dart';
export 'materials.dart';
export 'objects.dart';
export 'lights.dart';
export 'textures.dart';
export 'loaders.dart';
export 'animation.dart';
export 'tools.dart';
export 'constants.dart';
export 'types.dart';
export 'enums.dart';

// Server-side (headless)
export 'core.dart'
    hide Renderer, AudioContext, UIManager;
export 'math.dart';
export 'scene.dart'
    hide Material, Texture, Renderer;
export 'geometry.dart';
export 'physics.dart';
export 'animation.dart';
export 'loaders.dart';
export 'constants.dart';
export 'types.dart';
export 'enums.dart';

// Testing utilities
export 'core.dart'
    show Logger, Profiler, DebugUtils;
export 'math.dart'
    show Vector3, Matrix4, MathUtils;
export 'constants.dart';
export 'types.dart';
export 'enums.dart';

// Extension points
export 'interfaces.dart';
export 'types.dart';
export 'enums.dart';
export 'constants.dart';
