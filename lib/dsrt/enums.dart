/// Enumerations for DSRT Engine
/// 
/// Provides enumerated types for states, modes, types, and options
/// used throughout the engine API.
/// 
/// [includeAll]: Whether to include all enums or only commonly used ones.
/// Defaults to true.
library dsrt_engine.public.enums;

// Engine States
export '../src/core/engine.dart' 
    show
    EngineState,
    InitializationState,
    RenderState;

// Render Backends
export '../src/core/engine_config.dart' 
    show
    RenderBackend,
    WebGLVersion,
    ShaderLanguage;

// Platform Targets
export '../src/core/utils/platform.dart' 
    show
    PlatformType,
    OperatingSystem,
    Architecture;

// Math Enums
export '../src/math/euler.dart' 
    show
    EulerOrder,
    RotationOrder;

export '../src/math/color.dart' 
    show
    ColorFormat,
    ColorSpace,
    GammaEncoding;

// Geometry Enums
export '../src/geometry/geometry.dart' 
    show
    PrimitiveType,
    IndexFormat,
    VertexFormat;

export '../src/geometry/buffer/buffer_attribute.dart' 
    show
    AttributeType,
    AttributeUsage,
    DataType;

// Material Enums
export '../src/materials/material.dart' 
    show
    MaterialType,
    BlendMode,
    Side,
    DepthFunc,
    StencilFunc,
    StencilOp;

// Renderer Enums
export '../src/renderer/renderer.dart' 
    show
    RendererType,
    ClearMask,
    CullFace,
    FrontFace,
    PolygonMode;

export '../src/renderer/webgl/webgl_constants.dart' 
    show
    GLenum,
    GLbitfield,
    GLboolean,
    GLint,
    GLsizei,
    GLfloat;

// Scene Enums
export '../src/scene/scene.dart' 
    show
    ObjectType,
    Layer,
    FrustumTestResult;

export '../src/scene/layers.dart' 
    show
    LayerMask,
    LayerOperation;

// Camera Enums
export '../src/camera/camera.dart' 
    show
    CameraType,
    ProjectionType,
    StereoMode;

// Light Enums
export '../src/lights/light.dart' 
    show
    LightType,
    ShadowType,
    ShadowMapType;

// Texture Enums
export '../src/textures/texture.dart' 
    show
    TextureType,
    WrapMode,
    MinFilter,
    MagFilter,
    MipmapFilter;

// Loader Enums
export '../src/loaders/loader.dart' 
    show
    LoaderState,
    FileFormat,
    ParseMode;

// Animation Enums
export '../src/animation/animation_clip.dart' 
    show
    AnimationState,
    PlaybackDirection,
    WrapMode;

export '../src/animation/animation_mixer.dart' 
    show
    BlendMode,
    InterpolationType;

// Physics Enums
export '../src/physics/world.dart' 
    show
    PhysicsType,
    BodyType,
    ConstraintType;

export '../src/physics/collision/collision_system.dart' 
    show
    CollisionType,
    BroadPhaseType,
    NarrowPhaseType;

// Audio Enums
export '../src/audio/audio_context.dart' 
    show
    AudioState,
    ChannelLayout,
    SampleFormat;

export '../src/audio/effects/filter_node.dart' 
    show
    FilterType,
    BiquadFilterType;

// UI Enums
export '../src/ui/ui_element.dart' 
    show
    UIState,
    Visibility,
    Overflow,
    PositionType;

export '../src/ui/layout/ui_layout.dart' 
    show
    LayoutType,
    AlignItems,
    JustifyContent,
    FlexWrap;

// Plugin Enums
export '../src/plugins/plugin_manager.dart' 
    show
    PluginState,
    LoadPriority,
    CompatibilityLevel;

// VR/AR Enums
export '../src/plugins/vr/vr_manager.dart' 
    show
    VRDeviceType,
    TrackingState,
    EyeType;

export '../src/plugins/ar/ar_manager.dart' 
    show
    ARTrackingState,
    PlaneDetection,
    WorldAlignment;

// Event Enums
export '../src/core/events/event_types.dart' 
    show
    EventType,
    EventPhase,
    EventPriority;

export '../src/core/events/keyboard_event.dart' 
    show
    KeyCode,
    KeyAction,
    KeyModifier;

export '../src/core/events/mouse_event.dart' 
    show
    MouseButton,
    MouseAction,
    WheelDeltaMode;

// Performance Enums
export '../src/core/performance/profiler.dart' 
    show
    MetricType,
    UnitType,
    AggregationMethod;

// Logging Enums
export '../src/core/utils/logger.dart' 
    show
    LogLevel,
    LogCategory,
    OutputTarget;

// Error Enums
export '../src/core/utils/error_utils.dart' 
    show
    ErrorCode,
    ErrorSeverity,
    RecoveryAction;
