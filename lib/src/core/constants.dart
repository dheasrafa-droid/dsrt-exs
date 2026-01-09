/// Engine constants for DSRT Engine
/// 
/// Provides mathematical constants, rendering limits, default
/// values, and configuration presets used throughout the engine.
part of dsrt_engine.core.internal;

/// Mathematical constants
abstract class MathConstants {
  /// Machine epsilon for floating point comparisons
  static const double epsilon = 1e-10;
  
  /// Pi constant
  static const double pi = 3.14159265358979323846;
  
  /// Tau constant (2 * pi)
  static const double tau = 6.28318530717958647692;
  
  /// Half pi
  static const double halfPi = 1.57079632679489661923;
  
  /// Quarter pi
  static const double quarterPi = 0.78539816339744830962;
  
  /// Square root of 2
  static const double sqrt2 = 1.41421356237309504880;
  
  /// Square root of 1/2
  static const double sqrt1_2 = 0.70710678118654752440;
  
  /// Degrees to radians conversion factor
  static const double deg2rad = pi / 180.0;
  
  /// Radians to degrees conversion factor
  static const double rad2deg = 180.0 / pi;
  
  /// Natural logarithm of 2
  static const double ln2 = 0.69314718055994530942;
  
  /// Natural logarithm of 10
  static const double ln10 = 2.30258509299404568402;
  
  /// Base 2 logarithm of e
  static const double log2e = 1.44269504088896340736;
  
  /// Base 10 logarithm of e
  static const double log10e = 0.43429448190325182765;
}

/// Engine-wide constants
abstract class DsrtConstants {
  /// Engine name
  static const String engineName = 'DSRT Engine';
  
  /// Engine version (major.minor.patch)
  static const String engineVersion = '1.0.0';
  
  /// API version
  static const String apiVersion = '1.0.0';
  
  /// Minimum supported Dart SDK version
  static const String minDartVersion = '3.0.0';
  
  /// Minimum supported Flutter SDK version
  static const String minFlutterVersion = '3.0.0';
  
  /// Default gravity value (m/s²)
  static const double defaultGravity = 9.81;
  
  /// Default time step for physics (60 FPS)
  static const double defaultTimeStep = 1.0 / 60.0;
  
  /// Maximum physics sub-steps
  static const int maxPhysicsSubSteps = 10;
  
  /// Default solver iterations
  static const int defaultSolverIterations = 10;
  
  /// Default audio sample rate
  static const int defaultSampleRate = 44100;
  
  /// Default audio buffer size
  static const int defaultAudioBufferSize = 2048;
  
  /// Default FFT size for audio analysis
  static const int defaultFFTSize = 2048;
  
  /// Default maximum point lights
  static const int maxPointLights = 8;
  
  /// Default maximum directional lights
  static const int maxDirectionalLights = 4;
  
  /// Default maximum spot lights
  static const int maxSpotLights = 4;
  
  /// Default maximum bones per skeleton
  static const int maxBones = 128;
  
  /// Default maximum morph targets
  static const int maxMorphTargets = 8;
  
  /// Default maximum texture units
  static const int maxTextureUnits = 16;
  
  /// Default render target size
  static const int defaultRenderTargetSize = 2048;
  
  /// Default shadow map size
  static const int defaultShadowMapSize = 1024;
  
  /// Maximum vertices per geometry batch
  static const int maxVerticesPerBatch = 65536;
  
  /// Maximum indices per geometry batch
  static const int maxIndicesPerBatch = 65536;
  
  /// Maximum instances per draw call
  static const int maxInstancesPerDraw = 1024;
  
  /// Maximum uniform buffer size (bytes)
  static const int maxUniformBufferSize = 65536;
  
  /// Maximum shader storage buffer size (bytes)
  static const int maxShaderStorageBufferSize = 134217728; // 128 MB
  
  /// Maximum texture size (assume minimum WebGL requirement)
  static const int maxTextureSize = 4096;
  
  /// Maximum cube map texture size
  static const int maxCubeMapTextureSize = 4096;
  
  /// Maximum 3D texture size
  static const int max3DTextureSize = 2048;
  
  /// Maximum array texture layers
  static const int maxArrayTextureLayers = 256;
  
  /// Maximum color attachments
  static const int maxColorAttachments = 8;
  
  /// Maximum draw buffers
  static const int maxDrawBuffers = 8;
  
  /// Maximum vertex attributes
  static const int maxVertexAttributes = 16;
  
  /// Maximum vertex uniform vectors
  static const int maxVertexUniformVectors = 256;
  
  /// Maximum fragment uniform vectors
  static const int maxFragmentUniformVectors = 256;
  
  /// Maximum varying vectors
  static const int maxVaryingVectors = 15;
  
  /// Maximum texture image units
  static const int maxTextureImageUnits = 16;
  
  /// Maximum combined texture image units
  static const int maxCombinedTextureImageUnits = 32;
  
  /// Maximum vertex texture image units
  static const int maxVertexTextureImageUnits = 16;
  
  /// Maximum uniform buffer bindings
  static const int maxUniformBufferBindings = 24;
  
  /// Maximum shader storage buffer bindings
  static const int maxShaderStorageBufferBindings = 8;
  
  /// Default memory warning threshold (MB)
  static const int defaultMemoryWarningThreshold = 512;
  
  /// Default CPU warning threshold (0.0 to 1.0)
  static const double defaultCpuWarningThreshold = 0.8;
  
  /// Default GPU warning threshold (0.0 to 1.0)
  static const double defaultGpuWarningThreshold = 0.8;
  
  /// Default frame time warning threshold (ms)
  static const double defaultFrameTimeWarning = 16.67; // 60 FPS
  
  /// Default frame time critical threshold (ms)
  static const double defaultFrameTimeCritical = 33.33; // 30 FPS
  
  /// Default GC warning threshold (MB)
  static const int defaultGCWarningThreshold = 100;
  
  /// Default texture compression quality (0-100)
  static const int defaultTextureCompressionQuality = 90;
  
  /// Default mesh compression ratio (0.0-1.0)
  static const double defaultMeshCompressionRatio = 0.5;
  
  /// Default LOD distance threshold multiplier
  static const double defaultLODDistanceMultiplier = 1.0;
  
  /// Default frustum culling margin
  static const double defaultFrustumCullingMargin = 0.1;
  
  /// Default occlusion culling query size
  static const int defaultOcclusionQuerySize = 256;
  
  /// Default screen space error threshold (pixels)
  static const double defaultScreenSpaceError = 2.0;
  
  /// Default maximum anisotropy level
  static const int defaultMaxAnisotropy = 16;
  
  /// Default mipmap bias
  static const double defaultMipmapBias = 0.0;
  
  /// Default texture filtering mode
  static const int defaultTextureFilter = 0x2601; // GL_LINEAR
  
  /// Default texture wrap mode
  static const int defaultTextureWrap = 0x2901; // GL_REPEAT
  
  /// Default clear color (RGBA)
  static const List<double> defaultClearColor = [0.0, 0.0, 0.0, 1.0];
  
  /// Default clear depth
  static const double defaultClearDepth = 1.0;
  
  /// Default clear stencil
  static const int defaultClearStencil = 0;
  
  /// Default depth test function
  static const int defaultDepthFunc = 0x0203; // GL_LEQUAL
  
  /// Default blend source factor
  static const int defaultBlendSrc = 0x0302; // GL_SRC_ALPHA
  
  /// Default blend destination factor
  static const int defaultBlendDst = 0x0303; // GL_ONE_MINUS_SRC_ALPHA
  
  /// Default blend equation
  static const int defaultBlendEquation = 0x8006; // GL_FUNC_ADD
  
  /// Default cull face mode
  static const int defaultCullFace = 0x0405; // GL_BACK
  
  /// Default front face winding
  static const int defaultFrontFace = 0x0900; // GL_CCW
  
  /// Default polygon mode (not available in WebGL)
  static const int defaultPolygonMode = 0x1B02; // GL_FILL
  
  /// Default line width
  static const double defaultLineWidth = 1.0;
  
  /// Default point size
  static const double defaultPointSize = 1.0;
  
  /// Default scissor test enabled
  static const bool defaultScissorTest = false;
  
  /// Default stencil test enabled
  static const bool defaultStencilTest = false;
  
  /// Default depth test enabled
  static const bool defaultDepthTest = true;
  
  /// Default depth write enabled
  static const bool defaultDepthWrite = true;
  
  /// Default color write enabled
  static const bool defaultColorWrite = true;
  
  /// Default alpha test enabled
  static const bool defaultAlphaTest = false;
  
  /// Default alpha test reference value
  static const double defaultAlphaTestRef = 0.5;
  
  /// Default alpha test function
  static const int defaultAlphaTestFunc = 0x0204; // GL_GREATER
  
  /// Default dithering enabled
  static const bool defaultDither = false;
  
  /// Default premultiplied alpha
  static const bool defaultPremultipliedAlpha = false;
  
  /// Default preserve drawing buffer
  static const bool defaultPreserveDrawingBuffer = false;
  
  /// Default antialias
  static const bool defaultAntialias = true;
  
  /// Default alpha
  static const bool defaultAlpha = true;
  
  /// Default depth
  static const bool defaultDepth = true;
  
  /// Default stencil
  static const bool defaultStencil = false;
  
  /// Default fail-if-major-performance-caveat
  static const bool defaultFailIfMajorPerformanceCaveat = false;
  
  /// Default power preference
  static const String defaultPowerPreference = 'default';
  
  /// Default XR compatible
  static const bool defaultXRCompatible = false;
  
  /// Default desynchronized
  static const bool defaultDesynchronized = false;
  
  /// Default willReadFrequently
  static const bool defaultWillReadFrequently = false;
  
  /// Default color space
  static const String defaultColorSpace = 'srgb';
  
  /// Default vertex precision
  static const String defaultVertexPrecision = 'highp';
  
  /// Default fragment precision
  static const String defaultFragmentPrecision = 'mediump';
  
  /// Default shader language
  static const String defaultShaderLanguage = 'glsl';
  
  /// Default shader version
  static const String defaultShaderVersion = '300 es';
  
  /// Default shader precision format
  static const Map<String, dynamic> defaultShaderPrecisionFormat = {
    'rangeMin': 0,
    'rangeMax': 0,
    'precision': 0,
  };
  
  /// Default extensions
  static const List<String> defaultExtensions = [
    'EXT_color_buffer_float',
    'EXT_texture_filter_anisotropic',
    'OES_texture_float',
    'OES_texture_float_linear',
    'OES_texture_half_float',
    'OES_texture_half_float_linear',
    'OES_standard_derivatives',
    'OES_vertex_array_object',
    'WEBGL_compressed_texture_s3tc',
    'WEBGL_compressed_texture_etc',
    'WEBGL_compressed_texture_pvrtc',
    'WEBGL_compressed_texture_astc',
    'WEBGL_depth_texture',
    'WEBGL_draw_buffers',
    'WEBGL_lose_context',
    'WEBGL_multi_draw',
  ];
  
  /// Default compressed texture formats
  static const List<String> defaultCompressedTextureFormats = [
    'RGB_S3TC_DXT1',
    'RGBA_S3TC_DXT1',
    'RGBA_S3TC_DXT3',
    'RGBA_S3TC_DXT5',
    'RGB_PVRTC_4BPPV1',
    'RGB_PVRTC_2BPPV1',
    'RGBA_PVRTC_4BPPV1',
    'RGBA_PVRTC_2BPPV1',
    'RGB_ETC1',
    'RGBA_ETC2_EAC',
    'RGBA_ASTC_4x4',
    'RGBA_ASTC_5x4',
    'RGBA_ASTC_5x5',
    'RGBA_ASTC_6x5',
    'RGBA_ASTC_6x6',
    'RGBA_ASTC_8x5',
    'RGBA_ASTC_8x6',
    'RGBA_ASTC_8x8',
    'RGBA_ASTC_10x5',
    'RGBA_ASTC_10x6',
    'RGBA_ASTC_10x8',
    'RGBA_ASTC_10x10',
    'RGBA_ASTC_12x10',
    'RGBA_ASTC_12x12',
  ];
  
  /// Default supported image formats
  static const List<String> defaultSupportedImageFormats = [
    'image/png',
    'image/jpeg',
    'image/webp',
    'image/bmp',
    'image/gif',
  ];
  
  /// Default supported model formats
  static const List<String> defaultSupportedModelFormats = [
    'model/gltf+json',
    'model/gltf-binary',
    'model/obj',
    'model/fbx',
    'model/stl',
    'model/ply',
    'model/collada',
  ];
  
  /// Default supported audio formats
  static const List<String> defaultSupportedAudioFormats = [
    'audio/mpeg',
    'audio/ogg',
    'audio/wav',
    'audio/webm',
    'audio/aac',
    'audio/flac',
  ];
  
  /// Default supported font formats
  static const List<String> defaultSupportedFontFormats = [
    'font/ttf',
    'font/otf',
    'font/woff',
    'font/woff2',
    'font/eot',
  ];
  
  /// Default supported video formats
  static const List<String> defaultSupportedVideoFormats = [
    'video/mp4',
    'video/webm',
    'video/ogg',
  ];
  
  /// Default supported shader formats
  static const List<String> defaultSupportedShaderFormats = [
    'text/glsl',
    'text/wgsl',
    'text/spirv',
  ];
  
  /// Default maximum file size for loading (MB)
  static const int defaultMaxFileSize = 100;
  
  /// Default maximum total memory usage (MB)
  static const int defaultMaxMemoryUsage = 1024;
  
  /// Default maximum texture memory (MB)
  static const int defaultMaxTextureMemory = 512;
  
  /// Default maximum geometry memory (MB)
  static const int defaultMaxGeometryMemory = 256;
  
  /// Default maximum audio memory (MB)
  static const int defaultMaxAudioMemory = 128;
  
  /// Default maximum cache size (MB)
  static const int defaultMaxCacheSize = 256;
  
  /// Default cache expiration time (days)
  static const int defaultCacheExpirationDays = 7;
  
  /// Default HTTP timeout (seconds)
  static const int defaultHttpTimeout = 30;
  
  /// Default retry attempts
  static const int defaultRetryAttempts = 3;
  
  /// Default retry delay (seconds)
  static const int defaultRetryDelay = 1;
  
  /// Default connection pool size
  static const int defaultConnectionPoolSize = 6;
  
  /// Default user agent string
  static const String defaultUserAgent = 'DSRT-Engine/1.0.0';
  
  /// Default referrer policy
  static const String defaultReferrerPolicy = 'no-referrer-when-downgrade';
  
  /// Default credentials mode
  static const String defaultCredentialsMode = 'same-origin';
  
  /// Default cache mode
  static const String defaultCacheMode = 'default';
  
  /// Default redirect mode
  static const String defaultRedirectMode = 'follow';
  
  /// Default integrity check
  static const String defaultIntegrity = '';
  
  /// Default keepalive flag
  static const bool defaultKeepalive = false;
  
  /// Default signal (AbortSignal)
  static const dynamic defaultSignal = null;
  
  /// Default window (for Service Workers)
  static const dynamic defaultWindow = null;
}

/// WebGL-specific constants
abstract class WebGLConstants {
  /// WebGL 1.0 context name
  static const String webgl1 = 'webgl';
  
  /// WebGL 2.0 context name
  static const String webgl2 = 'webgl2';
  
  /// Experimental WebGL context name
  static const String experimentalWebgl = 'experimental-webgl';
  
  /// WebGL power preference high-performance
  static const String highPerformance = 'high-performance';
  
  /// WebGL power preference low-power
  static const String lowPower = 'low-power';
  
  /// WebGL power preference default
  static const String defaultPreference = 'default';
  
  /// Maximum WebGL 1.0 texture size (minimum requirement)
  static const int webgl1MaxTextureSize = 4096;
  
  /// Maximum WebGL 2.0 texture size (minimum requirement)
  static const int webgl2MaxTextureSize = 16384;
  
  /// Maximum WebGL 1.0 cube map texture size
  static const int webgl1MaxCubeMapTextureSize = 4096;
  
  /// Maximum WebGL 2.0 cube map texture size
  static const int webgl2MaxCubeMapTextureSize = 16384;
  
  /// Maximum WebGL 1.0 texture image units
  static const int webgl1MaxTextureImageUnits = 8;
  
  /// Maximum WebGL 2.0 texture image units
  static const int webgl2MaxTextureImageUnits = 16;
  
  /// Maximum WebGL 1.0 vertex texture image units
  static const int webgl1MaxVertexTextureImageUnits = 0;
  
  /// Maximum WebGL 2.0 vertex texture image units
  static const int webgl2MaxVertexTextureImageUnits = 16;
  
  /// Maximum WebGL 1.0 combined texture image units
  static const int webgl1MaxCombinedTextureImageUnits = 8;
  
  /// Maximum WebGL 2.0 combined texture image units
  static const int webgl2MaxCombinedTextureImageUnits = 32;
  
  /// Maximum WebGL 1.0 vertex attributes
  static const int webgl1MaxVertexAttribs = 8;
  
  /// Maximum WebGL 2.0 vertex attributes
  static const int webgl2MaxVertexAttribs = 16;
  
  /// Maximum WebGL 1.0 vertex uniform vectors
  static const int webgl1MaxVertexUniformVectors = 128;
  
  /// Maximum WebGL 2.0 vertex uniform vectors
  static const int webgl2MaxVertexUniformVectors = 256;
  
  /// Maximum WebGL 1.0 fragment uniform vectors
  static const int webgl1MaxFragmentUniformVectors = 64;
  
  /// Maximum WebGL 2.0 fragment uniform vectors
  static const int webgl2MaxFragmentUniformVectors = 256;
  
  /// Maximum WebGL 1.0 varying vectors
  static const int webgl1MaxVaryingVectors = 8;
  
  /// Maximum WebGL 2.0 varying vectors
  static const int webgl2MaxVaryingVectors = 15;
  
  /// Maximum WebGL 1.0 draw buffers
  static const int webgl1MaxDrawBuffers = 0;
  
  /// Maximum WebGL 2.0 draw buffers
  static const int webgl2MaxDrawBuffers = 8;
  
  /// Maximum WebGL 1.0 color attachments
  static const int webgl1MaxColorAttachments = 0;
  
  /// Maximum WebGL 2.0 color attachments
  static const int webgl2MaxColorAttachments = 8;
  
  /// WebGL 1.0 shader version
  static const String webgl1ShaderVersion = '100';
  
  /// WebGL 2.0 shader version
  static const String webgl2ShaderVersion = '300 es';
}

/// File format constants
abstract class FileFormatConstants {
  /// GLTF JSON format MIME type
  static const String gltfJson = 'model/gltf+json';
  
  /// GLTF binary format MIME type
  static const String gltfBinary = 'model/gltf-binary';
  
  /// OBJ format MIME type
  static const String obj = 'model/obj';
  
  /// FBX format MIME type
  static const String fbx = 'model/fbx';
  
  /// STL format MIME type
  static const String stl = 'model/stl';
  
  /// PLY format MIME type
  static const String ply = 'model/ply';
  
  /// Collada format MIME type
  static const String collada = 'model/collada';
  
  /// PNG image format MIME type
  static const String png = 'image/png';
  
  /// JPEG image format MIME type
  static const String jpeg = 'image/jpeg';
  
  /// WebP image format MIME type
  static const String webp = 'image/webp';
  
  /// BMP image format MIME type
  static const String bmp = 'image/bmp';
  
  /// GIF image format MIME type
  static const String gif = 'image/gif';
  
  /// MP3 audio format MIME type
  static const String mp3 = 'audio/mpeg';
  
  /// OGG audio format MIME type
  static const String ogg = 'audio/ogg';
  
  /// WAV audio format MIME type
  static const String wav = 'audio/wav';
  
  /// WebM audio format MIME type
  static const String webmAudio = 'audio/webm';
  
  /// AAC audio format MIME type
  static const String aac = 'audio/aac';
  
  /// FLAC audio format MIME type
  static const String flac = 'audio/flac';
  
  /// TTF font format MIME type
  static const String ttf = 'font/ttf';
  
  /// OTF font format MIME type
  static const String otf = 'font/otf';
  
  /// WOFF font format MIME type
  static const String woff = 'font/woff';
  
  /// WOFF2 font format MIME type
  static const String woff2 = 'font/woff2';
  
  /// EOT font format MIME type
  static const String eot = 'font/eot';
  
  /// MP4 video format MIME type
  static const String mp4 = 'video/mp4';
  
  /// WebM video format MIME type
  static const String webmVideo = 'video/webm';
  
  /// OGG video format MIME type
  static const String oggVideo = 'video/ogg';
  
  /// GLSL shader format MIME type
  static const String glsl = 'text/glsl';
  
  /// WGSL shader format MIME type
  static const String wgsl = 'text/wgsl';
  
  /// SPIR-V shader format MIME type
  static const String spirv = 'text/spirv';
  
  /// JSON data format MIME type
  static const String json = 'application/json';
  
  /// Binary data format MIME type
  static const String binary = 'application/octet-stream';
  
  /// Text data format MIME type
  static const String text = 'text/plain';
  
  /// XML data format MIME type
  static const String xml = 'application/xml';
  
  /// ZIP archive format MIME type
  static const String zip = 'application/zip';
  
  /// GZIP archive format MIME type
  static const String gzip = 'application/gzip';
}

/// Unit conversion constants
abstract class UnitConstants {
  /// Meters to engine units conversion
  static const double metersToUnits = 1.0;
  
  /// Engine units to meters conversion
  static const double unitsToMeters = 1.0;
  
  /// Centimeters to meters conversion
  static const double centimetersToMeters = 0.01;
  
  /// Millimeters to meters conversion
  static const double millimetersToMeters = 0.001;
  
  /// Kilometers to meters conversion
  static const double kilometersToMeters = 1000.0;
  
  /// Inches to meters conversion
  static const double inchesToMeters = 0.0254;
  
  /// Feet to meters conversion
  static const double feetToMeters = 0.3048;
  
  /// Yards to meters conversion
  static const double yardsToMeters = 0.9144;
  
  /// Miles to meters conversion
  static const double milesToMeters = 1609.344;
  
  /// Degrees to radians conversion
  static const double degreesToRadians = MathConstants.deg2rad;
  
  /// Radians to degrees conversion
  static const double radiansToDegrees = MathConstants.rad2deg;
  
  /// Revolutions to radians conversion
  static const double revolutionsToRadians = MathConstants.tau;
  
  /// Radians to revolutions conversion
  static const double radiansToRevolutions = 1.0 / MathConstants.tau;
}
