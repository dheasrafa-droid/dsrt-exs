/// Engine Constants for DSRT Engine
/// 
/// Provides mathematical constants, rendering limits,
/// default values, and configuration presets.
/// 
/// [includePlatform]: Whether to include platform-specific constants.
/// Defaults to true.
library dsrt_engine.public.constants;

// Mathematical Constants
export '../src/core/constants.dart' 
    show 
    EPSILON,
    DEG2RAD,
    RAD2DEG,
    PI,
    TAU,
    HALF_PI,
    QUARTER_PI,
    SQRT2,
    SQRT1_2,
    LOG2E,
    LOG10E,
    LN2,
    LN10;

// Rendering Constants
export '../src/renderer/webgl/webgl_constants.dart' 
    show
    GL_VERSION,
    GL_VENDOR,
    GL_RENDERER,
    GL_MAX_TEXTURE_SIZE,
    GL_MAX_CUBE_MAP_TEXTURE_SIZE,
    GL_MAX_TEXTURE_IMAGE_UNITS,
    GL_MAX_VERTEX_ATTRIBS,
    GL_MAX_VARYING_VECTORS,
    GL_MAX_VERTEX_UNIFORM_VECTORS,
    GL_MAX_FRAGMENT_UNIFORM_VECTORS;

// Physics Constants
export '../src/physics/physics_config.dart' 
    show
    DEFAULT_GRAVITY,
    MAX_SUB_STEPS,
    FIXED_TIME_STEP,
    SOLVER_ITERATIONS,
    CONTACT_SLOP,
    RESTITUTION_THRESHOLD;

// Audio Constants
export '../src/audio/audio_config.dart' 
    show
    DEFAULT_SAMPLE_RATE,
    MAX_CHANNELS,
    BUFFER_SIZE,
    FFT_SIZE,
    MIN_DECIBELS,
    MAX_DECIBELS,
    SMOOTHING_TIME_CONSTANT;

// Memory Constants
export '../src/core/utils/memory_utils.dart' 
    show
    MAX_BUFFER_SIZE,
    MAX_TEXTURE_MEMORY,
    MAX_GEOMETRY_BUFFERS,
    MAX_SHADER_PROGRAMS,
    MAX_FRAME_BUFFERS;

// Platform Limits
export '../src/core/utils/platform.dart' 
    show
    IS_WEB,
    IS_MOBILE,
    IS_DESKTOP,
    MAX_CANVAS_WIDTH,
    MAX_CANVAS_HEIGHT,
    WEBGL_VERSION,
    MAX_WEBGL_DRAW_BUFFERS;

// Default Values
export '../src/core/settings.dart' 
    show
    DEFAULT_RENDER_QUALITY,
    DEFAULT_ANTI_ALIASING,
    DEFAULT_SHADOW_QUALITY,
    DEFAULT_TEXTURE_QUALITY,
    DEFAULT_ANISOTROPY,
    DEFAULT_MIPMAP_FILTER;

// Performance Limits
export '../src/core/performance/performance_utils.dart' 
    show
    MAX_FRAME_TIME,
    MIN_FRAME_RATE,
    MAX_FRAME_RATE,
    MEMORY_WARNING_THRESHOLD,
    CPU_WARNING_THRESHOLD,
    GPU_WARNING_THRESHOLD;

// File Format Constants
export '../src/loaders/loader_utils.dart' 
    show
    MAX_FILE_SIZE,
    SUPPORTED_IMAGE_FORMATS,
    SUPPORTED_MODEL_FORMATS,
    SUPPORTED_AUDIO_FORMATS,
    SUPPORTED_FONT_FORMATS,
    SUPPORTED_TEXTURE_COMPRESSION;

// Color Constants
export '../src/math/color.dart' 
    show
    BLACK,
    WHITE,
    RED,
    GREEN,
    BLUE,
    YELLOW,
    CYAN,
    MAGENTA,
    GRAY,
    TRANSPARENT;

// Unit Conversion
export '../src/core/constants.dart' 
    show
    METERS_TO_UNITS,
    UNITS_TO_METERS,
    DEGREES_TO_RADIANS,
    RADIANS_TO_DEGREES,
    INCHES_TO_METERS,
    FEET_TO_METERS;

// Engine Version
export '../src/core/version.dart' 
    show
    ENGINE_VERSION,
    API_VERSION,
    MINIMUM_DART_VERSION,
    MINIMUM_FLUTTER_VERSION,
    BUILD_TIMESTAMP,
    GIT_COMMIT_HASH;
