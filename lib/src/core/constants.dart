// lib/src/core/constants.dart

/// DSRT Engine - Core Constants
/// 
/// This file contains all global constants used throughout the DSRT Engine.
/// These constants are immutable and should not be modified at runtime.
/// 
/// @category Core
/// @version 1.0.0
/// @license MIT
/// @copyright DSRT Engine Team

library dsrt_engine.core.constants;

/// DSRT Engine identification constants
class DsrtConstants {
  /// Engine name
  static const String ENGINE_NAME = 'DSRT Engine';
  
  /// Engine version (major.minor.patch)
  static const String ENGINE_VERSION = '1.0.0';
  
  /// Engine version code
  static const int ENGINE_VERSION_CODE = 10000;
  
  /// Engine build identifier
  static const String ENGINE_BUILD = 'alpha.2024.01';
  
  /// Engine vendor
  static const String ENGINE_VENDOR = 'DSRT Engine Team';
  
  /// Engine website
  static const String ENGINE_WEBSITE = 'https://dsrt-engine.dev';
  
  /// Engine documentation URL
  static const String ENGINE_DOCS = 'https://docs.dsrt-engine.dev';
  
  /// Engine repository URL
  static const String ENGINE_REPO = 'https://github.com/dsrt-engine/dsrt';
  
  /// Engine license
  static const String ENGINE_LICENSE = 'MIT License';
  
  /// Engine copyright
  static const String ENGINE_COPYRIGHT = 'Copyright (c) 2024 DSRT Engine Team';
  
  /// Engine description
  static const String ENGINE_DESCRIPTION = 
      'A high-performance, modular 3D engine built with Dart for multi-platform applications.';
}

/// Mathematical constants with high precision
class DsrtMathConstants {
  /// Pi constant (π)
  static const double PI = 3.14159265358979323846;
  
  /// Tau constant (τ = 2π)
  static const double TAU = 6.28318530717958647692;
  
  /// Pi over 2 (π/2)
  static const double HALF_PI = 1.57079632679489661923;
  
  /// Pi over 4 (π/4)
  static const double QUARTER_PI = 0.78539816339744830962;
  
  /// Two times Pi (2π)
  static const double TWO_PI = 6.28318530717958647692;
  
  /// Inverse of Pi (1/π)
  static const double INV_PI = 0.31830988618379067154;
  
  /// Inverse of Tau (1/τ)
  static const double INV_TAU = 0.15915494309189533577;
  
  /// Degree to Radian conversion factor (π/180)
  static const double DEG_TO_RAD = 0.01745329251994329577;
  
  /// Radian to Degree conversion factor (180/π)
  static const double RAD_TO_DEG = 57.2957795130823208768;
  
  /// Euler's number (e)
  static const double E = 2.71828182845904523536;
  
  /// Natural logarithm of 2 (ln2)
  static const double LN2 = 0.69314718055994530942;
  
  /// Natural logarithm of 10 (ln10)
  static const double LN10 = 2.30258509299404568402;
  
  /// Base 2 logarithm of e (log2(e))
  static const double LOG2E = 1.44269504088896340736;
  
  /// Base 10 logarithm of e (log10(e))
  static const double LOG10E = 0.43429448190325182765;
  
  /// Square root of 2 (√2)
  static const double SQRT2 = 1.41421356237309504880;
  
  /// Square root of 1/2 (√½)
  static const double SQRT_HALF = 0.70710678118654752440;
  
  /// Square root of 3 (√3)
  static const double SQRT3 = 1.73205080756887729353;
  
  /// Square root of 5 (√5)
  static const double SQRT5 = 2.23606797749978969641;
  
  /// Golden ratio (φ)
  static const double PHI = 1.61803398874989484820;
  
  /// Machine epsilon for double precision
  static const double EPSILON = 1e-15;
  
  /// Small epsilon value for floating point comparisons
  static const double EPSILON_SMALL = 1e-9;
  
  /// Large epsilon value for floating point comparisons
  static const double EPSILON_LARGE = 1e-6;
  
  /// Maximum safe integer for double precision
  static const double MAX_SAFE_INTEGER = 9007199254740991.0;
  
  /// Minimum safe integer for double precision
  static const double MIN_SAFE_INTEGER = -9007199254740991.0;
}

/// Rendering and graphics constants
class DsrtGraphicsConstants {
  /// Default canvas width
  static const int DEFAULT_CANVAS_WIDTH = 800;
  
  /// Default canvas height
  static const int DEFAULT_CANVAS_HEIGHT = 600;
  
  /// Default background color (black)
  static const int DEFAULT_BACKGROUND_COLOR = 0xFF000000;
  
  /// Default clear color (transparent black)
  static const int DEFAULT_CLEAR_COLOR = 0x00000000;
  
  /// Default clear depth value
  static const double DEFAULT_CLEAR_DEPTH = 1.0;
  
  /// Default clear stencil value
  static const int DEFAULT_CLEAR_STENCIL = 0;
  
  /// Default near clipping plane
  static const double DEFAULT_NEAR = 0.1;
  
  /// Default far clipping plane
  static const double DEFAULT_FAR = 1000.0;
  
  /// Default field of view (in degrees)
  static const double DEFAULT_FOV = 60.0;
  
  /// Default aspect ratio
  static const double DEFAULT_ASPECT = 4.0 / 3.0;
  
  /// Default render target size
  static const int DEFAULT_RENDER_TARGET_SIZE = 512;
  
  /// Maximum texture size (conservative estimate)
  static const int MAX_TEXTURE_SIZE = 4096;
  
  /// Maximum cube map size
  static const int MAX_CUBE_MAP_SIZE = 2048;
  
  /// Maximum render buffer size
  static const int MAX_RENDER_BUFFER_SIZE = 8192;
  
  /// Maximum anisotropy level
  static const int MAX_ANISOTROPY = 16;
  
  /// Maximum mipmap levels
  static const int MAX_MIPMAP_LEVELS = 16;
  
  /// Default antialiasing samples
  static const int DEFAULT_ANTIALIAS_SAMPLES = 4;
  
  /// Default shadow map size
  static const int DEFAULT_SHADOW_MAP_SIZE = 1024;
  
  /// Default light map size
  static const int DEFAULT_LIGHT_MAP_SIZE = 512;
  
  /// Default environment map size
  static const int DEFAULT_ENV_MAP_SIZE = 256;
}

/// Physics and simulation constants
class DsrtPhysicsConstants {
  /// Default gravity (Earth gravity in m/s²)
  static const double DEFAULT_GRAVITY = 9.81;
  
  /// Default physics time step (60 FPS)
  static const double DEFAULT_TIME_STEP = 1.0 / 60.0;
  
  /// Default physics sub-steps
  static const int DEFAULT_SUB_STEPS = 1;
  
  /// Default solver iterations
  static const int DEFAULT_SOLVER_ITERATIONS = 10;
  
  /// Default collision margin
  static const double DEFAULT_COLLISION_MARGIN = 0.04;
  
  /// Default restitution (bounciness)
  static const double DEFAULT_RESTITUTION = 0.0;
  
  /// Default friction coefficient
  static const double DEFAULT_FRICTION = 0.5;
  
  /// Default linear damping
  static const double DEFAULT_LINEAR_DAMPING = 0.01;
  
  /// Default angular damping
  static const double DEFAULT_ANGULAR_DAMPING = 0.01;
  
  /// Default sleep threshold
  static const double DEFAULT_SLEEP_THRESHOLD = 0.8;
  
  /// Default contact processing threshold
  static const double DEFAULT_CONTACT_THRESHOLD = 0.02;
  
  /// Maximum linear velocity
  static const double MAX_LINEAR_VELOCITY = 1000.0;
  
  /// Maximum angular velocity
  static const double MAX_ANGULAR_VELOCITY = 100.0;
  
  /// Default CCD (Continuous Collision Detection) margin
  static const double DEFAULT_CCD_MARGIN = 0.01;
}

/// Audio and sound constants
class DsrtAudioConstants {
  /// Default sample rate
  static const int DEFAULT_SAMPLE_RATE = 44100;
  
  /// Default channels (stereo)
  static const int DEFAULT_CHANNELS = 2;
  
  /// Default bit depth
  static const int DEFAULT_BIT_DEPTH = 16;
  
  /// Default buffer size
  static const int DEFAULT_BUFFER_SIZE = 4096;
  
  /// Default listener distance model
  static const String DEFAULT_DISTANCE_MODEL = 'inverse';
  
  /// Default speed of sound (m/s)
  static const double DEFAULT_SPEED_OF_SOUND = 343.0;
  
  /// Default doppler factor
  static const double DEFAULT_DOPPLER_FACTOR = 1.0;
  
  /// Default rolloff factor
  static const double DEFAULT_ROLLOFF_FACTOR = 1.0;
  
  /// Default reference distance
  static const double DEFAULT_REFERENCE_DISTANCE = 1.0;
  
  /// Default max distance
  static const double DEFAULT_MAX_DISTANCE = 10000.0;
  
  /// Default master volume
  static const double DEFAULT_MASTER_VOLUME = 1.0;
  
  /// Minimum volume (muted)
  static const double MIN_VOLUME = 0.0;
  
  /// Maximum volume
  static const double MAX_VOLUME = 1.0;
  
  /// Default panning value (center)
  static const double DEFAULT_PAN = 0.0;
}

/// Animation and timing constants
class DsrtAnimationConstants {
  /// Default animation frame rate (FPS)
  static const double DEFAULT_FRAME_RATE = 60.0;
  
  /// Default animation duration (seconds)
  static const double DEFAULT_DURATION = 1.0;
  
  /// Default animation start time
  static const double DEFAULT_START_TIME = 0.0;
  
  /// Default animation end time
  static const double DEFAULT_END_TIME = 1.0;
  
  /// Default animation time scale
  static const double DEFAULT_TIME_SCALE = 1.0;
  
  /// Default blending duration
  static const double DEFAULT_BLEND_DURATION = 0.2;
  
  /// Default interpolation mode
  static const String DEFAULT_INTERPOLATION = 'linear';
  
  /// Default wrap mode
  static const String DEFAULT_WRAP_MODE = 'clamp';
  
  /// Maximum bone count per skeleton
  static const int MAX_BONES = 256;
  
  /// Maximum morph target count
  static const int MAX_MORPH_TARGETS = 16;
  
  /// Maximum blend shape count
  static const int MAX_BLEND_SHAPES = 8;
  
  /// Default keyframe tolerance
  static const double DEFAULT_KEYFRAME_TOLERANCE = 0.001;
}

/// Memory and performance constants
class DsrtMemoryConstants {
  /// Default memory pool size (bytes)
  static const int DEFAULT_MEMORY_POOL_SIZE = 64 * 1024 * 1024; // 64MB
  
  /// Default geometry pool size
  static const int DEFAULT_GEOMETRY_POOL_SIZE = 16 * 1024 * 1024; // 16MB
  
  /// Default texture pool size
  static const int DEFAULT_TEXTURE_POOL_SIZE = 32 * 1024 * 1024; // 32MB
  
  /// Default shader pool size
  static const int DEFAULT_SHADER_POOL_SIZE = 4 * 1024 * 1024; // 4MB
  
  /// Default buffer alignment
  static const int DEFAULT_BUFFER_ALIGNMENT = 16;
  
  /// Default cache size for objects
  static const int DEFAULT_OBJECT_CACHE_SIZE = 1024;
  
  /// Default cache size for materials
  static const int DEFAULT_MATERIAL_CACHE_SIZE = 256;
  
  /// Default cache size for textures
  static const int DEFAULT_TEXTURE_CACHE_SIZE = 128;
  
  /// Default cache size for shaders
  static const int DEFAULT_SHADER_CACHE_SIZE = 64;
  
  /// Maximum vertices per geometry
  static const int MAX_VERTICES_PER_GEOMETRY = 65536;
  
  /// Maximum indices per geometry
  static const int MAX_INDICES_PER_GEOMETRY = 65536 * 3;
  
  /// Maximum uniforms per shader
  static const int MAX_UNIFORMS_PER_SHADER = 256;
  
  /// Maximum attributes per geometry
  static const int MAX_ATTRIBUTES_PER_GEOMETRY = 16;
  
  /// Maximum texture units
  static const int MAX_TEXTURE_UNITS = 16;
}

/// Platform and compatibility constants
class DsrtPlatformConstants {
  /// WebGL 1.0 identifier
  static const String WEBGL1 = 'webgl';
  
  /// WebGL 2.0 identifier
  static const String WEBGL2 = 'webgl2';
  
  /// WebGPU identifier
  static const String WEBGPU = 'webgpu';
  
  /// Canvas 2D identifier
  static const String CANVAS2D = '2d';
  
  /// SVG renderer identifier
  static const String SVG = 'svg';
  
  /// CSS 3D renderer identifier
  static const String CSS3D = 'css3d';
  
  /// Software renderer identifier
  static const String SOFTWARE = 'software';
  
  /// Default renderer type
  static const String DEFAULT_RENDERER = WEBGL2;
  
  /// Minimum WebGL version required
  static const int MIN_WEBGL_VERSION = 1;
  
  /// Minimum WebGL 2 version required
  static const int MIN_WEBGL2_VERSION = 2;
  
  /// Default precision for shaders
  static const String DEFAULT_PRECISION = 'highp';
  
  /// Fallback precision for mobile
  static const String FALLBACK_PRECISION = 'mediump';
  
  /// Low precision for compatibility
  static const String LOW_PRECISION = 'lowp';
  
  /// Default extension requirements
  static const List<String> DEFAULT_EXTENSIONS = [
    'OES_texture_float',
    'OES_texture_float_linear',
    'OES_standard_derivatives',
    'EXT_shader_texture_lod',
    'WEBGL_depth_texture',
    'OES_element_index_uint',
  ];
}

/// Error and validation constants
class DsrtErrorConstants {
  /// Success code (no error)
  static const int SUCCESS = 0;
  
  /// Generic error code
  static const int ERROR_GENERIC = -1;
  
  /// Initialization error
  static const int ERROR_INITIALIZATION = -100;
  
  /// Resource loading error
  static const int ERROR_RESOURCE_LOADING = -200;
  
  /// Graphics context error
  static const int ERROR_GRAPHICS_CONTEXT = -300;
  
  /// Shader compilation error
  static const int ERROR_SHADER_COMPILATION = -400;
  
  /// Memory allocation error
  static const int ERROR_MEMORY_ALLOCATION = -500;
  
  /// Parameter validation error
  static const int ERROR_VALIDATION = -600;
  
  /// File system error
  static const int ERROR_FILE_SYSTEM = -700;
  
  /// Network error
  static const int ERROR_NETWORK = -800;
  
  /// Platform unsupported error
  static const int ERROR_PLATFORM_UNSUPPORTED = -900;
  
  /// Feature unsupported error
  static const int ERROR_FEATURE_UNSUPPORTED = -1000;
  
  /// Maximum error message length
  static const int MAX_ERROR_MESSAGE_LENGTH = 1024;
  
  /// Default error message
  static const String DEFAULT_ERROR_MESSAGE = 'An unknown error occurred';
  
  /// Validation failed message
  static const String VALIDATION_FAILED = 'Validation failed';
  
  /// Resource not found message
  static const String RESOURCE_NOT_FOUND = 'Resource not found';
  
  /// Context lost message
  static const String CONTEXT_LOST = 'Graphics context lost';
  
  /// Out of memory message
  static const String OUT_OF_MEMORY = 'Out of memory';
  
  /// Timeout message
  static const String TIMEOUT = 'Operation timed out';
}

/// Input and interaction constants
class DsrtInputConstants {
  /// Default mouse sensitivity
  static const double DEFAULT_MOUSE_SENSITIVITY = 1.0;
  
  /// Default touch sensitivity
  static const double DEFAULT_TOUCH_SENSITIVITY = 1.0;
  
  /// Default gamepad deadzone
  static const double DEFAULT_GAMEPAD_DEADZONE = 0.1;
  
  /// Default gamepad sensitivity
  static const double DEFAULT_GAMEPAD_SENSITIVITY = 1.0;
  
  /// Default double-click interval (ms)
  static const int DEFAULT_DOUBLE_CLICK_INTERVAL = 500;
  
  /// Default long-press duration (ms)
  static const int DEFAULT_LONG_PRESS_DURATION = 1000;
  
  /// Default drag threshold (pixels)
  static const double DEFAULT_DRAG_THRESHOLD = 5.0;
  
  /// Default scroll sensitivity
  static const double DEFAULT_SCROLL_SENSITIVITY = 1.0;
  
  /// Maximum touch points
  static const int MAX_TOUCH_POINTS = 10;
  
  /// Maximum gamepad count
  static const int MAX_GAMEPADS = 4;
  
  /// Maximum buttons per gamepad
  static const int MAX_GAMEPAD_BUTTONS = 20;
  
  /// Maximum axes per gamepad
  static const int MAX_GAMEPAD_AXES = 10;
}

/// Default values for various engine components
class DsrtDefaultValues {
  /// Default material color (white)
  static const int DEFAULT_MATERIAL_COLOR = 0xFFFFFFFF;
  
  /// Default material opacity
  static const double DEFAULT_MATERIAL_OPACITY = 1.0;
  
  /// Default material roughness
  static const double DEFAULT_MATERIAL_ROUGHNESS = 0.5;
  
  /// Default material metalness
  static const double DEFAULT_MATERIAL_METALNESS = 0.0;
  
  /// Default material emissive intensity
  static const double DEFAULT_MATERIAL_EMISSIVE_INTENSITY = 1.0;
  
  /// Default material normal scale
  static const double DEFAULT_MATERIAL_NORMAL_SCALE = 1.0;
  
  /// Default material displacement scale
  static const double DEFAULT_MATERIAL_DISPLACEMENT_SCALE = 1.0;
  
  /// Default material ambient occlusion strength
  static const double DEFAULT_MATERIAL_AO_STRENGTH = 1.0;
  
  /// Default light color (white)
  static const int DEFAULT_LIGHT_COLOR = 0xFFFFFF;
  
  /// Default light intensity
  static const double DEFAULT_LIGHT_INTENSITY = 1.0;
  
  /// Default light distance
  static const double DEFAULT_LIGHT_DISTANCE = 100.0;
  
  /// Default light angle
  static const double DEFAULT_LIGHT_ANGLE = Math.PI / 3.0;
  
  /// Default light penumbra
  static const double DEFAULT_LIGHT_PENUMBRA = 0.0;
  
  /// Default light decay
  static const double DEFAULT_LIGHT_DECAY = 2.0;
  
  /// Default camera zoom
  static const double DEFAULT_CAMERA_ZOOM = 1.0;
  
  /// Default camera rotation speed
  static const double DEFAULT_CAMERA_ROTATION_SPEED = 1.0;
  
  /// Default camera pan speed
  static const double DEFAULT_CAMERA_PAN_SPEED = 1.0;
  
  /// Default camera zoom speed
  static const double DEFAULT_CAMERA_ZOOM_SPEED = 1.0;
  
  /// Default camera min distance
  static const double DEFAULT_CAMERA_MIN_DISTANCE = 0.1;
  
  /// Default camera max distance
  static const double DEFAULT_CAMERA_MAX_DISTANCE = 1000.0;
  
  /// Default camera min zoom
  static const double DEFAULT_CAMERA_MIN_ZOOM = 0.1;
  
  /// Default camera max zoom
  static const double DEFAULT_CAMERA_MAX_ZOOM = 10.0;
  
  /// Default camera min polar angle (degrees)
  static const double DEFAULT_CAMERA_MIN_POLAR_ANGLE = 0.0;
  
  /// Default camera max polar angle (degrees)
  static const double DEFAULT_CAMERA_MAX_POLAR_ANGLE = 180.0;
  
  /// Default camera min azimuth angle (degrees)
  static const double DEFAULT_CAMERA_MIN_AZIMUTH_ANGLE = -180.0;
  
  /// Default camera max azimuth angle (degrees)
  static const double DEFAULT_CAMERA_MAX_AZIMUTH_ANGLE = 180.0;
  
  /// Default camera damping factor
  static const double DEFAULT_CAMERA_DAMPING = 0.25;
  
  /// Default camera enable damping
  static const bool DEFAULT_CAMERA_ENABLE_DAMPING = true;
  
  /// Default camera enable zoom
  static const bool DEFAULT_CAMERA_ENABLE_ZOOM = true;
  
  /// Default camera enable rotate
  static const bool DEFAULT_CAMERA_ENABLE_ROTATE = true;
  
  /// Default camera enable pan
  static const bool DEFAULT_CAMERA_ENABLE_PAN = true;
  
  /// Default camera screen space panning
  static const bool DEFAULT_CAMERA_SCREEN_SPACE_PANNING = false;
  
  /// Default camera key pan speed
  static const double DEFAULT_CAMERA_KEY_PAN_SPEED = 7.0;
  
  /// Default camera auto rotate
  static const bool DEFAULT_CAMERA_AUTO_ROTATE = false;
  
  /// Default camera auto rotate speed
  static const double DEFAULT_CAMERA_AUTO_ROTATE_SPEED = 2.0;
}

/// Utility class for math operations
class Math {
  /// Pi constant from DsrtMathConstants
  static const double PI = DsrtMathConstants.PI;
}

/// Main constants export class
/// 
/// This class provides access to all DSRT Engine constants.
/// Use these constants throughout your application for consistency.
class DsrtConstantsExport {
  /// Mathematical constants
  static const DsrtMathConstants math = DsrtMathConstants();
  
  /// Graphics constants
  static const DsrtGraphicsConstants graphics = DsrtGraphicsConstants();
  
  /// Physics constants
  static const DsrtPhysicsConstants physics = DsrtPhysicsConstants();
  
  /// Audio constants
  static const DsrtAudioConstants audio = DsrtAudioConstants();
  
  /// Animation constants
  static const DsrtAnimationConstants animation = DsrtAnimationConstants();
  
  /// Memory constants
  static const DsrtMemoryConstants memory = DsrtMemoryConstants();
  
  /// Platform constants
  static const DsrtPlatformConstants platform = DsrtPlatformConstants();
  
  /// Error constants
  static const DsrtErrorConstants error = DsrtErrorConstants();
  
  /// Input constants
  static const DsrtInputConstants input = DsrtInputConstants();
  
  /// Default values
  static const DsrtDefaultValues defaults = DsrtDefaultValues();
  
  /// Engine identification
  static const DsrtConstants engine = DsrtConstants();
}
