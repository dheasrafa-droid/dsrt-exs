/// Type Definitions for DSRT Engine
/// 
/// Provides type aliases, function signatures, and generic types
/// used throughout the engine API.
/// 
/// [includeAdvanced]: Whether to include advanced type utilities.
/// Defaults to true.
library dsrt_engine.public.types;

// Core Types
export '../src/core/engine.dart' 
    show
    EngineState,
    RenderBackend,
    PlatformTarget;

// Math Types
export '../src/math/vector3.dart' 
    show
    Vector3Like,
    Vector3Array,
    Vector3Tuple;

export '../src/math/matrix4.dart' 
    show
    Matrix4Like,
    Matrix4Array,
    Matrix4Tuple;

export '../src/math/quaternion.dart' 
    show
    QuaternionLike,
    QuaternionArray,
    QuaternionTuple;

// Geometry Types
export '../src/geometry/geometry.dart' 
    show
    VertexArray,
    IndexArray,
    NormalArray,
    UVArray,
    ColorArray,
    TangentArray;

// Buffer Types
export '../src/geometry/buffer/buffer_attribute.dart' 
    show
    TypedArray,
    Float32Array,
    Uint32Array,
    Uint16Array,
    Uint8Array,
    Int32Array,
    Int16Array,
    Int8Array;

// Material Types
export '../src/materials/material.dart' 
    show
    UniformValue,
    TextureSlot,
    ShaderDefine,
    RenderState;

// Renderer Types
export '../src/renderer/renderer.dart' 
    show
    RenderPass,
    RenderTarget,
    ShaderProgram,
    VertexBuffer,
    IndexBuffer,
    UniformBuffer;

// Scene Types
export '../src/scene/scene.dart' 
    show
    ObjectID,
    LayerMask,
    TransformMatrix,
    WorldMatrix,
    LocalMatrix;

// Camera Types
export '../src/camera/camera.dart' 
    show
    ViewMatrix,
    ProjectionMatrix,
    ViewProjectionMatrix,
    FrustumCorners;

// Light Types
export '../src/lights/light.dart' 
    show
    LightColor,
    LightIntensity,
    ShadowMap,
    ShadowMatrix;

// Animation Types
export '../src/animation/animation_clip.dart' 
    show
    TimeRange,
    Keyframe,
    AnimationTrack,
    PropertyPath;

// Physics Types
export '../src/physics/world.dart' 
    show
    PhysicsID,
    CollisionMask,
    CollisionGroup,
    ForceVector,
    TorqueVector;

// Audio Types
export '../src/audio/audio_context.dart' 
    show
    AudioBuffer,
    AudioNode,
    AudioParam,
    AudioTime;

// UI Types
export '../src/ui/ui_element.dart' 
    show
    PixelRect,
    ScreenSpace,
    ViewportRect,
    ZIndex;

// Plugin Types
export '../src/plugins/plugin_manager.dart' 
    show
    PluginID,
    PluginMetadata,
    DependencyGraph;

// Event Types
export '../src/core/events/event_types.dart' 
    show
    EventCallback,
    EventFilter,
    EventPriority;

// Callback Types
export '../src/core/loop/game_loop.dart' 
    show
    UpdateCallback,
    RenderCallback,
    AnimationCallback;

// Utility Types
export '../src/core/utils/disposables.dart' 
    show
    Disposable,
    Initializable,
    Serializable;

// Promise/Future Types
export '../src/core/utils/async_utils.dart' 
    show
    AsyncResult,
    ProgressCallback,
    ErrorHandler;

// Generic Collection Types
export '../src/core/utils/array_utils.dart' 
    show
    ObjectMap,
    StringMap,
    NumberMap,
    TypedList,
    Pool;

// Configuration Types
export '../src/core/engine_config.dart' 
    show
    ConfigSection,
    ConfigValue,
    ConfigOverride;

// Serialization Types
export '../src/core/utils/json_utils.dart' 
    show
    JSONObject,
    JSONArray,
    JSONValue,
    SerializedData;

// Platform Types
export '../src/core/utils/platform.dart' 
    show
    PlatformInfo,
    DeviceCapabilities,
    BrowserInfo;

// Performance Types
export '../src/core/performance/profiler.dart' 
    show
    PerformanceSample,
    TimelineEvent,
    MetricCollection;

// Memory Types
export '../src/core/utils/memory_utils.dart' 
    show
    MemoryStats,
    AllocationInfo,
    GarbageCollection;
