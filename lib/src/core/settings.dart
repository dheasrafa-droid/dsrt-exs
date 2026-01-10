/// Engine configuration settings and runtime options.
/// 
/// This class manages engine-wide settings that affect rendering quality,
/// performance, and behavior. Settings can be adjusted at runtime.
/// 
/// [DSRT]: Dart Spatial Rendering Technology
/// 
/// @internal - Core engine internals
library dsrt.core.settings;

import 'dart:math' as math;
import 'constants.dart';

/// Size representation for width and height
class DSRTSize {
  /// Width in pixels
  final int width;
  
  /// Height in pixels
  final int height;
  
  /// Creates a size object with specified dimensions
  /// 
  /// [width]: Width in pixels, must be positive
  /// [height]: Height in pixels, must be positive
  DSRTSize(this.width, this.height) {
    if (width <= 0) {
      throw ArgumentError('Width must be positive');
    }
    if (height <= 0) {
      throw ArgumentError('Height must be positive');
    }
  }
  
  /// Aspect ratio (width / height)
  double get aspectRatio => width / height;
  
  /// Total pixel count
  int get pixelCount => width * height;
  
  /// Whether this size is square
  bool get isSquare => width == height;
  
  /// Creates a copy with optional new dimensions
  DSRTSize copyWith({
    int? width,
    int? height,
  }) {
    return DSRTSize(
      width ?? this.width,
      height ?? this.height,
    );
  }
  
  /// Scales this size by a factor
  DSRTSize scale(double factor) {
    return DSRTSize(
      (width * factor).round(),
      (height * factor).round(),
    );
  }
  
  /// Fits this size into another size while maintaining aspect ratio
  DSRTSize fitInto(DSRTSize container) {
    final scale = math.min(
      container.width / width,
      container.height / height,
    );
    return scale(scale);
  }
  
  /// Covers another size while maintaining aspect ratio
  DSRTSize cover(DSRTSize container) {
    final scale = math.max(
      container.width / width,
      container.height / height,
    );
    return scale(scale);
  }
  
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is DSRTSize &&
            runtimeType == other.runtimeType &&
            width == other.width &&
            height == other.height);
  }
  
  @override
  int get hashCode => width.hashCode ^ height.hashCode;
  
  @override
  String toString() => '${width}x$height';
}

/// Anti-aliasing methods
enum DSRTAntiAliasing {
  /// No anti-aliasing
  none,
  
  /// Fast Approximate Anti-Aliasing
  fxaa,
  
  /// Multi-Sample Anti-Aliasing
  msaa,
  
  /// Temporal Anti-Aliasing
  taa,
  
  /// Subpixel Morphological Anti-Aliasing
  smaa,
}

/// Shadow quality levels
enum DSRTShadowQuality {
  /// No shadows
  none,
  
  /// Low quality shadows
  low,
  
  /// Medium quality shadows
  medium,
  
  /// High quality shadows
  high,
  
  /// Ultra quality shadows
  ultra,
}

/// Reflection quality levels
enum DSRTReflectionQuality {
  /// No reflections
  none,
  
  /// Low quality reflections
  low,
  
  /// Medium quality reflections
  medium,
  
  /// High quality reflections
  high,
  
  /// Ultra quality reflections
  ultra,
}

/// Ambient occlusion quality levels
enum DSRTAOQuality {
  /// No ambient occlusion
  none,
  
  /// Low quality ambient occlusion
  low,
  
  /// Medium quality ambient occlusion
  medium,
  
  /// High quality ambient occlusion
  high,
  
  /// Ultra quality ambient occlusion
  ultra,
}

/// Texture filtering modes
enum DSRTTextureFilterMode {
  /// Nearest neighbor filtering
  nearest,
  
  /// Bilinear filtering
  bilinear,
  
  /// Trilinear filtering
  trilinear,
  
  /// Anisotropic filtering
  anisotropic,
}

/// Texture compression formats
enum DSRTTextureCompression {
  /// No compression
  none,
  
  /// S3TC/DXT compression
  s3tc,
  
  /// ETC compression
  etc,
  
  /// ASTC compression
  astc,
  
  /// PVRTC compression
  pvrtc,
}

/// Engine settings manager with full implementation
class DSRTSettings {
  /// Singleton instance
  static final DSRTSettings _instance = DSRTSettings._internal();
  
  /// Gets the singleton instance
  static DSRTSettings get instance => _instance;
  
  /// Render settings
  final DSRTRenderSettings render;
  
  /// Quality settings
  final DSRTQualitySettings quality;
  
  /// Performance settings
  final DSRTPerformanceSettings performance;
  
  /// Debug settings
  final DSRTDebugSettings debug;
  
  /// System settings
  final DSRTSystemSettings system;
  
  /// Private constructor
  DSRTSettings._internal()
      : render = DSRTRenderSettings(),
        quality = DSRTQualitySettings(),
        performance = DSRTPerformanceSettings(),
        debug = DSRTDebugSettings(),
        system = DSRTSystemSettings();
  
  /// Applies settings from configuration
  /// 
  /// [config]: Configuration to apply
  /// [validate]: Whether to validate settings
  /// 
  /// Returns true if applied successfully
  bool applyConfiguration(DSRTSettingsConfig config, {bool validate = true}) {
    if (validate && !_validateConfiguration(config)) {
      return false;
    }
    
    render.apply(config.render);
    quality.apply(config.quality);
    performance.apply(config.performance);
    debug.apply(config.debug);
    system.apply(config.system);
    
    _notifySettingsChanged();
    return true;
  }
  
  /// Resets to default values
  void resetToDefaults() {
    render.reset();
    quality.reset();
    performance.reset();
    debug.reset();
    system.reset();
    
    _notifySettingsChanged();
  }
  
  /// Validates configuration
  bool _validateConfiguration(DSRTSettingsConfig config) {
    // Validate render settings
    if (config.render.renderTargetSize.width <= 0 ||
        config.render.renderTargetSize.height <= 0) {
      return false;
    }
    
    if (config.render.maxTextureSize < 1 ||
        config.render.maxTextureSize > dsrtMaxTextureSize) {
      return false;
    }
    
    if (config.render.gammaValue <= 0) {
      return false;
    }
    
    if (config.render.toneMappingExposure <= 0) {
      return false;
    }
    
    if (config.render.toneMappingWhitePoint <= 0) {
      return false;
    }
    
    if (config.render.hdrMaxLuminance <= 0) {
      return false;
    }
    
    if (config.render.alphaCutoff < 0 || config.render.alphaCutoff > 1) {
      return false;
    }
    
    // Validate quality settings
    if (config.quality.msaaSamples < 1 || config.quality.msaaSamples > 32) {
      return false;
    }
    
    if (config.quality.anisotropy < 1 || config.quality.anisotropy > 16) {
      return false;
    }
    
    if (config.quality.shadowResolution < 64 || config.quality.shadowResolution > 8192) {
      return false;
    }
    
    if (config.quality.shadowSoftness < 0 || config.quality.shadowSoftness > 1) {
      return false;
    }
    
    if (config.quality.bloomIntensity < 0) {
      return false;
    }
    
    if (config.quality.bloomThreshold < 0 || config.quality.bloomThreshold > 1) {
      return false;
    }
    
    if (config.quality.dofFocusDistance <= 0) {
      return false;
    }
    
    if (config.quality.dofAperture <= 0) {
      return false;
    }
    
    // Validate performance settings
    if (config.performance.maxDrawCalls < 1) {
      return false;
    }
    
    if (config.performance.maxTriangles < 1) {
      return false;
    }
    
    if (config.performance.maxLights < 1 ||
        config.performance.maxLights > dsrtMaxPointLights + dsrtMaxDirectionalLights + dsrtMaxSpotLights) {
      return false;
    }
    
    if (config.performance.occlusionQuerySize < 1 ||
        config.performance.occlusionQuerySize > 1024) {
      return false;
    }
    
    if (config.performance.lodDistances.any((d) => d <= 0)) {
      return false;
    }
    
    if (config.performance.maxInstances < 1) {
      return false;
    }
    
    if (config.performance.atlasSize < 1 ||
        config.performance.atlasSize > dsrtMaxTextureSize) {
      return false;
    }
    
    // Validate debug settings
    if (config.debug.wireframeLineWidth <= 0) {
      return false;
    }
    
    if (config.debug.boundingBoxLineWidth <= 0) {
      return false;
    }
    
    if (config.debug.frustumLineWidth <= 0) {
      return false;
    }
    
    if (config.debug.normalLineLength <= 0) {
      return false;
    }
    
    if (config.debug.normalLineWidth <= 0) {
      return false;
    }
    
    if (config.debug.gridSize <= 0) {
      return false;
    }
    
    if (config.debug.gridDivisions < 1) {
      return false;
    }
    
    // Validate system settings
    if (config.system.maxTextureCacheSizeMB < 0) {
      return false;
    }
    
    if (config.system.maxGeometryCacheSizeMB < 0) {
      return false;
    }
    
    if (config.system.maxMaterialCacheSizeMB < 0) {
      return false;
    }
    
    if (config.system.maxShaderCacheSizeMB < 0) {
      return false;
    }
    
    if (config.system.maxAudioCacheSizeMB < 0) {
      return false;
    }
    
    if (config.system.maxConcurrentDownloads < 1) {
      return false;
    }
    
    if (config.system.downloadTimeoutSeconds < 1) {
      return false;
    }
    
    if (config.system.maxDownloadRetries < 0) {
      return false;
    }
    
    if (config.system.compressionLevel < 0 || config.system.compressionLevel > 9) {
      return false;
    }
    
    if (config.system.mipmapQuality < 0 || config.system.mipmapQuality > 2) {
      return false;
    }
    
    return true;
  }
  
  /// Notifies listeners of settings change
  void _notifySettingsChanged() {
    // Implementation would notify registered listeners
    // This is a placeholder for the notification system
  }
  
  /// Creates a settings snapshot
  DSRTSettingsConfig createSnapshot() {
    return DSRTSettingsConfig(
      render: render.createSnapshot(),
      quality: quality.createSnapshot(),
      performance: performance.createSnapshot(),
      debug: debug.createSnapshot(),
      system: system.createSnapshot(),
    );
  }
  
  /// Restores from snapshot
  bool restoreFromSnapshot(DSRTSettingsConfig snapshot) {
    return applyConfiguration(snapshot, validate: false);
  }
  
  /// Gets current settings as map
  Map<String, dynamic> toMap() {
    return {
      'render': render.toMap(),
      'quality': quality.toMap(),
      'performance': performance.toMap(),
      'debug': debug.toMap(),
      'system': system.toMap(),
    };
  }
  
  /// Applies settings from map
  bool fromMap(Map<String, dynamic> map) {
    try {
      final config = DSRTSettingsConfig.fromMap(map);
      return applyConfiguration(config);
    } catch (_) {
      return false;
    }
  }
}

/// Render settings implementation
class DSRTRenderSettings {
  DSRTSize _renderTargetSize;
  int _maxTextureSize;
  bool _gammaCorrection;
  double _gammaValue;
  bool _toneMapping;
  double _toneMappingExposure;
  double _toneMappingWhitePoint;
  bool _hdrRendering;
  double _hdrMaxLuminance;
  bool _alphaBlending;
  double _alphaCutoff;
  bool _premultipliedAlpha;
  bool _preserveDrawingBuffer;
  bool _depthTesting;
  bool _stencilTesting;
  bool _faceCulling;
  
  /// Creates render settings with defaults
  DSRTRenderSettings()
      : _renderTargetSize = DSRTSize(dsrtDefaultRenderWidth, dsrtDefaultRenderHeight),
        _maxTextureSize = 4096,
        _gammaCorrection = true,
        _gammaValue = dsrtDefaultGamma,
        _toneMapping = true,
        _toneMappingExposure = dsrtDefaultExposure,
        _toneMappingWhitePoint = dsrtDefaultWhitePoint,
        _hdrRendering = false,
        _hdrMaxLuminance = 1000.0,
        _alphaBlending = true,
        _alphaCutoff = 0.5,
        _premultipliedAlpha = false,
        _preserveDrawingBuffer = false,
        _depthTesting = true,
        _stencilTesting = false,
        _faceCulling = true;
  
  /// Render target size
  DSRTSize get renderTargetSize => _renderTargetSize;
  set renderTargetSize(DSRTSize value) {
    _renderTargetSize = value;
  }
  
  /// Maximum texture size
  int get maxTextureSize => _maxTextureSize;
  set maxTextureSize(int value) {
    if (value >= 1 && value <= dsrtMaxTextureSize) {
      _maxTextureSize = value;
    }
  }
  
  /// Gamma correction enabled
  bool get gammaCorrection => _gammaCorrection;
  set gammaCorrection(bool value) {
    _gammaCorrection = value;
  }
  
  /// Gamma value
  double get gammaValue => _gammaValue;
  set gammaValue(double value) {
    if (value > 0) {
      _gammaValue = value;
    }
  }
  
  /// Tone mapping enabled
  bool get toneMapping => _toneMapping;
  set toneMapping(bool value) {
    _toneMapping = value;
  }
  
  /// Tone mapping exposure
  double get toneMappingExposure => _toneMappingExposure;
  set toneMappingExposure(double value) {
    if (value > 0) {
      _toneMappingExposure = value;
    }
  }
  
  /// Tone mapping white point
  double get toneMappingWhitePoint => _toneMappingWhitePoint;
  set toneMappingWhitePoint(double value) {
    if (value > 0) {
      _toneMappingWhitePoint = value;
    }
  }
  
  /// HDR rendering enabled
  bool get hdrRendering => _hdrRendering;
  set hdrRendering(bool value) {
    _hdrRendering = value;
  }
  
  /// HDR maximum luminance
  double get hdrMaxLuminance => _hdrMaxLuminance;
  set hdrMaxLuminance(double value) {
    if (value > 0) {
      _hdrMaxLuminance = value;
    }
  }
  
  /// Alpha blending enabled
  bool get alphaBlending => _alphaBlending;
  set alphaBlending(bool value) {
    _alphaBlending = value;
  }
  
  /// Alpha cutoff value
  double get alphaCutoff => _alphaCutoff;
  set alphaCutoff(double value) {
    if (value >= 0 && value <= 1) {
      _alphaCutoff = value;
    }
  }
  
  /// Premultiplied alpha enabled
  bool get premultipliedAlpha => _premultipliedAlpha;
  set premultipliedAlpha(bool value) {
    _premultipliedAlpha = value;
  }
  
  /// Preserve drawing buffer
  bool get preserveDrawingBuffer => _preserveDrawingBuffer;
  set preserveDrawingBuffer(bool value) {
    _preserveDrawingBuffer = value;
  }
  
  /// Depth testing enabled
  bool get depthTesting => _depthTesting;
  set depthTesting(bool value) {
    _depthTesting = value;
  }
  
  /// Stencil testing enabled
  bool get stencilTesting => _stencilTesting;
  set stencilTesting(bool value) {
    _stencilTesting = value;
  }
  
  /// Face culling enabled
  bool get faceCulling => _faceCulling;
  set faceCulling(bool value) {
    _faceCulling = value;
  }
  
  /// Applies settings from config
  void apply(DSRTRenderSettings config) {
    _renderTargetSize = config._renderTargetSize;
    _maxTextureSize = config._maxTextureSize;
    _gammaCorrection = config._gammaCorrection;
    _gammaValue = config._gammaValue;
    _toneMapping = config._toneMapping;
    _toneMappingExposure = config._toneMappingExposure;
    _toneMappingWhitePoint = config._toneMappingWhitePoint;
    _hdrRendering = config._hdrRendering;
    _hdrMaxLuminance = config._hdrMaxLuminance;
    _alphaBlending = config._alphaBlending;
    _alphaCutoff = config._alphaCutoff;
    _premultipliedAlpha = config._premultipliedAlpha;
    _preserveDrawingBuffer = config._preserveDrawingBuffer;
    _depthTesting = config._depthTesting;
    _stencilTesting = config._stencilTesting;
    _faceCulling = config._faceCulling;
  }
  
  /// Resets to defaults
  void reset() {
    _renderTargetSize = DSRTSize(dsrtDefaultRenderWidth, dsrtDefaultRenderHeight);
    _maxTextureSize = 4096;
    _gammaCorrection = true;
    _gammaValue = dsrtDefaultGamma;
    _toneMapping = true;
    _toneMappingExposure = dsrtDefaultExposure;
    _toneMappingWhitePoint = dsrtDefaultWhitePoint;
    _hdrRendering = false;
    _hdrMaxLuminance = 1000.0;
    _alphaBlending = true;
    _alphaCutoff = 0.5;
    _premultipliedAlpha = false;
    _preserveDrawingBuffer = false;
    _depthTesting = true;
    _stencilTesting = false;
    _faceCulling = true;
  }
  
  /// Creates a snapshot
  DSRTRenderSettings createSnapshot() {
    final snapshot = DSRTRenderSettings();
    snapshot.apply(this);
    return snapshot;
  }
  
  /// Converts to map
  Map<String, dynamic> toMap() {
    return {
      'renderTargetSize': {
        'width': _renderTargetSize.width,
        'height': _renderTargetSize.height,
      },
      'maxTextureSize': _maxTextureSize,
      'gammaCorrection': _gammaCorrection,
      'gammaValue': _gammaValue,
      'toneMapping': _toneMapping,
      'toneMappingExposure': _toneMappingExposure,
      'toneMappingWhitePoint': _toneMappingWhitePoint,
      'hdrRendering': _hdrRendering,
      'hdrMaxLuminance': _hdrMaxLuminance,
      'alphaBlending': _alphaBlending,
      'alphaCutoff': _alphaCutoff,
      'premultipliedAlpha': _premultipliedAlpha,
      'preserveDrawingBuffer': _preserveDrawingBuffer,
      'depthTesting': _depthTesting,
      'stencilTesting': _stencilTesting,
      'faceCulling': _faceCulling,
    };
  }
  
  /// Creates from map
  static DSRTRenderSettings fromMap(Map<String, dynamic> map) {
    final settings = DSRTRenderSettings();
    
    if (map['renderTargetSize'] != null) {
      final size = map['renderTargetSize'] as Map<String, dynamic>;
      settings._renderTargetSize = DSRTSize(
        (size['width'] as num).toInt(),
        (size['height'] as num).toInt(),
      );
    }
    
    settings._maxTextureSize = (map['maxTextureSize'] as num?)?.toInt() ?? settings._maxTextureSize;
    settings._gammaCorrection = map['gammaCorrection'] as bool? ?? settings._gammaCorrection;
    settings._gammaValue = (map['gammaValue'] as num?)?.toDouble() ?? settings._gammaValue;
    settings._toneMapping = map['toneMapping'] as bool? ?? settings._toneMapping;
    settings._toneMappingExposure = (map['toneMappingExposure'] as num?)?.toDouble() ?? settings._toneMappingExposure;
    settings._toneMappingWhitePoint = (map['toneMappingWhitePoint'] as num?)?.toDouble() ?? settings._toneMappingWhitePoint;
    settings._hdrRendering = map['hdrRendering'] as bool? ?? settings._hdrRendering;
    settings._hdrMaxLuminance = (map['hdrMaxLuminance'] as num?)?.toDouble() ?? settings._hdrMaxLuminance;
    settings._alphaBlending = map['alphaBlending'] as bool? ?? settings._alphaBlending;
    settings._alphaCutoff = (map['alphaCutoff'] as num?)?.toDouble() ?? settings._alphaCutoff;
    settings._premultipliedAlpha = map['premultipliedAlpha'] as bool? ?? settings._premultipliedAlpha;
    settings._preserveDrawingBuffer = map['preserveDrawingBuffer'] as bool? ?? settings._preserveDrawingBuffer;
    settings._depthTesting = map['depthTesting'] as bool? ?? settings._depthTesting;
    settings._stencilTesting = map['stencilTesting'] as bool? ?? settings._stencilTesting;
    settings._faceCulling = map['faceCulling'] as bool? ?? settings._faceCulling;
    
    return settings;
  }
}

/// Quality settings implementation
class DSRTQualitySettings {
  DSRTAntiAliasing _antiAliasing;
  int _msaaSamples;
  DSRTTextureFilterMode _textureFiltering;
  int _anisotropy;
  DSRTShadowQuality _shadowQuality;
  int _shadowResolution;
  bool _softShadows;
  double _shadowSoftness;
  DSRTReflectionQuality _reflectionQuality;
  bool _screenSpaceReflections;
  bool _ambientOcclusion;
  DSRTAOQuality _aoQuality;
  bool _bloom;
  double _bloomIntensity;
  double _bloomThreshold;
  bool _depthOfField;
  double _dofFocusDistance;
  double _dofAperture;
  
  /// Creates quality settings with defaults
  DSRTQualitySettings()
      : _antiAliasing = DSRTAntiAliasing.fxaa,
        _msaaSamples = 4,
        _textureFiltering = DSRTTextureFilterMode.trilinear,
        _anisotropy = 4,
        _shadowQuality = DSRTShadowQuality.medium,
        _shadowResolution = 1024,
        _softShadows = true,
        _shadowSoftness = 0.5,
        _reflectionQuality = DSRTReflectionQuality.medium,
        _screenSpaceReflections = true,
        _ambientOcclusion = true,
        _aoQuality = DSRTAOQuality.medium,
        _bloom = true,
        _bloomIntensity = dsrtDefaultBloomIntensity,
        _bloomThreshold = dsrtDefaultBloomThreshold,
        _depthOfField = false,
        _dofFocusDistance = dsrtDefaultDOFFocusDistance,
        _dofAperture = dsrtDefaultDOFAperture;
  
  /// Anti-aliasing method
  DSRTAntiAliasing get antiAliasing => _antiAliasing;
  set antiAliasing(DSRTAntiAliasing value) {
    _antiAliasing = value;
  }
  
  /// MSAA sample count
  int get msaaSamples => _msaaSamples;
  set msaaSamples(int value) {
    if (value >= 1 && value <= 32) {
      _msaaSamples = value;
    }
  }
  
  /// Texture filtering mode
  DSRTTextureFilterMode get textureFiltering => _textureFiltering;
  set textureFiltering(DSRTTextureFilterMode value) {
    _textureFiltering = value;
  }
  
  /// Anisotropy level
  int get anisotropy => _anisotropy;
  set anisotropy(int value) {
    if (value >= 1 && value <= 16) {
      _anisotropy = value;
    }
  }
  
  /// Shadow quality
  DSRTShadowQuality get shadowQuality => _shadowQuality;
  set shadowQuality(DSRTShadowQuality value) {
    _shadowQuality = value;
  }
  
  /// Shadow resolution
  int get shadowResolution => _shadowResolution;
  set shadowResolution(int value) {
    if (value >= 64 && value <= 8192) {
      _shadowResolution = value;
    }
  }
  
  /// Soft shadows enabled
  bool get softShadows => _softShadows;
  set softShadows(bool value) {
    _softShadows = value;
  }
  
  /// Shadow softness
  double get shadowSoftness => _shadowSoftness;
  set shadowSoftness(double value) {
    if (value >= 0 && value <= 1) {
      _shadowSoftness = value;
    }
  }
  
  /// Reflection quality
  DSRTReflectionQuality get reflectionQuality => _reflectionQuality;
  set reflectionQuality(DSRTReflectionQuality value) {
    _reflectionQuality = value;
  }
  
  /// Screen space reflections enabled
  bool get screenSpaceReflections => _screenSpaceReflections;
  set screenSpaceReflections(bool value) {
    _screenSpaceReflections = value;
  }
  
  /// Ambient occlusion enabled
  bool get ambientOcclusion => _ambientOcclusion;
  set ambientOcclusion(bool value) {
    _ambientOcclusion = value;
  }
  
  /// AO quality
  DSRTAOQuality get aoQuality => _aoQuality;
  set aoQuality(DSRTAOQuality value) {
    _aoQuality = value;
  }
  
  /// Bloom enabled
  bool get bloom => _bloom;
  set bloom(bool value) {
    _bloom = value;
  }
  
  /// Bloom intensity
  double get bloomIntensity => _bloomIntensity;
  set bloomIntensity(double value) {
    if (value >= 0) {
      _bloomIntensity = value;
    }
  }
  
  /// Bloom threshold
  double get bloomThreshold => _bloomThreshold;
  set bloomThreshold(double value) {
    if (value >= 0 && value <= 1) {
      _bloomThreshold = value;
    }
  }
  
  /// Depth of field enabled
  bool get depthOfField => _depthOfField;
  set depthOfField(bool value) {
    _depthOfField = value;
  }
  
  /// DOF focus distance
  double get dofFocusDistance => _dofFocusDistance;
  set dofFocusDistance(double value) {
    if (value > 0) {
      _dofFocusDistance = value;
    }
  }
  
  /// DOF aperture
  double get dofAperture => _dofAperture;
  set dofAperture(double value) {
    if (value > 0) {
      _dofAperture = value;
    }
  }
  
  /// Applies settings from config
  void apply(DSRTQualitySettings config) {
    _antiAliasing = config._antiAliasing;
    _msaaSamples = config._msaaSamples;
    _textureFiltering = config._textureFiltering;
    _anisotropy = config._anisotropy;
    _shadowQuality = config._shadowQuality;
    _shadowResolution = config._shadowResolution;
    _softShadows = config._softShadows;
    _shadowSoftness = config._shadowSoftness;
    _reflectionQuality = config._reflectionQuality;
    _screenSpaceReflections = config._screenSpaceReflections;
    _ambientOcclusion = config._ambientOcclusion;
    _aoQuality = config._aoQuality;
    _bloom = config._bloom;
    _bloomIntensity = config._bloomIntensity;
    _bloomThreshold = config._bloomThreshold;
    _depthOfField = config._depthOfField;
    _dofFocusDistance = config._dofFocusDistance;
    _dofAperture = config._dofAperture;
  }
  
  /// Resets to defaults
  void reset() {
    _antiAliasing = DSRTAntiAliasing.fxaa;
    _msaaSamples = 4;
    _textureFiltering = DSRTTextureFilterMode.trilinear;
    _anisotropy = 4;
    _shadowQuality = DSRTShadowQuality.medium;
    _shadowResolution = 1024;
    _softShadows = true;
    _shadowSoftness = 0.5;
    _reflectionQuality = DSRTReflectionQuality.medium;
    _screenSpaceReflections = true;
    _ambientOcclusion = true;
    _aoQuality = DSRTAOQuality.medium;
    _bloom = true;
    _bloomIntensity = dsrtDefaultBloomIntensity;
    _bloomThreshold = dsrtDefaultBloomThreshold;
    _depthOfField = false;
    _dofFocusDistance = dsrtDefaultDOFFocusDistance;
    _dofAperture = dsrtDefaultDOFAperture;
  }
  
  /// Creates a snapshot
  DSRTQualitySettings createSnapshot() {
    final snapshot = DSRTQualitySettings();
    snapshot.apply(this);
    return snapshot;
  }
  
  /// Converts to map
  Map<String, dynamic> toMap() {
    return {
      'antiAliasing': _antiAliasing.index,
      'msaaSamples': _msaaSamples,
      'textureFiltering': _textureFiltering.index,
      'anisotropy': _anisotropy,
      'shadowQuality': _shadowQuality.index,
      'shadowResolution': _shadowResolution,
      'softShadows': _softShadows,
      'shadowSoftness': _shadowSoftness,
      'reflectionQuality': _reflectionQuality.index,
      'screenSpaceReflections': _screenSpaceReflections,
      'ambientOcclusion': _ambientOcclusion,
      'aoQuality': _aoQuality.index,
      'bloom': _bloom,
      'bloomIntensity': _bloomIntensity,
      'bloomThreshold': _bloomThreshold,
      'depthOfField': _depthOfField,
      'dofFocusDistance': _dofFocusDistance,
      'dofAperture': _dofAperture,
    };
  }
  
  /// Creates from map
  static DSRTQualitySettings fromMap(Map<String, dynamic> map) {
    final settings = DSRTQualitySettings();
    
    settings._antiAliasing = DSRTAntiAliasing.values[(map['antiAliasing'] as num?)?.toInt() ?? 1];
    settings._msaaSamples = (map['msaaSamples'] as num?)?.toInt() ?? settings._msaaSamples;
    settings._textureFiltering = DSRTTextureFilterMode.values[(map['textureFiltering'] as num?)?.toInt() ?? 2];
    settings._anisotropy = (map['anisotropy'] as num?)?.toInt() ?? settings._anisotropy;
    settings._shadowQuality = DSRTShadowQuality.values[(map['shadowQuality'] as num?)?.toInt() ?? 2];
    settings._shadowResolution = (map['shadowResolution'] as num?)?.toInt() ?? settings._shadowResolution;
    settings._softShadows = map['softShadows'] as bool? ?? settings._softShadows;
    settings._shadowSoftness = (map['shadowSoftness'] as num?)?.toDouble() ?? settings._shadowSoftness;
    settings._reflectionQuality = DSRTReflectionQuality.values[(map['reflectionQuality'] as num?)?.toInt() ?? 2];
    settings._screenSpaceReflections = map['screenSpaceReflections'] as bool? ?? settings._screenSpaceReflections;
    settings._ambientOcclusion = map['ambientOcclusion'] as bool? ?? settings._ambientOcclusion;
    settings._aoQuality = DSRTAOQuality.values[(map['aoQuality'] as num?)?.toInt() ?? 2];
    settings._bloom = map['bloom'] as bool? ?? settings._bloom;
    settings._bloomIntensity = (map['bloomIntensity'] as num?)?.toDouble() ?? settings._bloomIntensity;
    settings._bloomThreshold = (map['bloomThreshold'] as num?)?.toDouble() ?? settings._bloomThreshold;
    settings._depthOfField = map['depthOfField'] as bool? ?? settings._depthOfField;
    settings._dofFocusDistance = (map['dofFocusDistance'] as num?)?.toDouble() ?? settings._dofFocusDistance;
    settings._dofAperture = (map['dofAperture'] as num?)?.toDouble() ?? settings._dofAperture;
    
    return settings;
  }
}

/// Performance settings implementation
class DSRTPerformanceSettings {
  int _maxDrawCalls;
  int _maxTriangles;
  int _maxLights;
  bool _frustumCulling;
  bool _occlusionCulling;
  int _occlusionQuerySize;
  bool _levelOfDetail;
  List<double> _lodDistances;
  bool _instancedRendering;
  int _maxInstances;
  bool _textureAtlas;
  int _atlasSize;
  bool _mipmapping;
  bool _textureCompression;
  
  /// Creates performance settings with defaults
  DSRTPerformanceSettings()
      : _maxDrawCalls = 1000,
        _maxTriangles = 1000000,
        _maxLights = dsrtMaxPointLights + dsrtMaxDirectionalLights + dsrtMaxSpotLights,
        _frustumCulling = true,
        _occlusionCulling = false,
        _occlusionQuerySize = 256,
        _levelOfDetail = true,
        _lodDistances = [10.0, 25.0, 50.0, 100.0],
        _instancedRendering = true,
        _maxInstances = 1000,
        _textureAtlas = true,
        _atlasSize = 2048,
        _mipmapping = true,
        _textureCompression = true;
  
  /// Maximum draw calls per frame
  int get maxDrawCalls => _maxDrawCalls;
  set maxDrawCalls(int value) {
    if (value >= 1) {
      _maxDrawCalls = value;
    }
  }
  
  /// Maximum triangles per frame
  int get maxTriangles => _maxTriangles;
  set maxTriangles(int value) {
    if (value >= 1) {
      _maxTriangles = value;
    }
  }
  
  /// Maximum lights in scene
  int get maxLights => _maxLights;
  set maxLights(int value) {
    final maxTotalLights = dsrtMaxPointLights + dsrtMaxDirectionalLights + dsrtMaxSpotLights;
    if (value >= 1 && value <= maxTotalLights) {
      _maxLights = value;
    }
  }
  
  /// Frustum culling enabled
  bool get frustumCulling => _frustumCulling;
  set frustumCulling(bool value) {
    _frustumCulling = value;
  }
  
  /// Occlusion culling enabled
  bool get occlusionCulling => _occlusionCulling;
  set occlusionCulling(bool value) {
    _occlusionCulling = value;
  }
  
  /// Occlusion query size
  int get occlusionQuerySize => _occlusionQuerySize;
  set occlusionQuerySize(int value) {
    if (value >= 1 && value <= 1024) {
      _occlusionQuerySize = value;
    }
  }
  
  /// Level of detail enabled
  bool get levelOfDetail => _levelOfDetail;
  set levelOfDetail(bool value) {
    _levelOfDetail = value;
  }
  
  /// LOD distance thresholds
  List<double> get lodDistances => List.unmodifiable(_lodDistances);
  set lodDistances(List<double> value) {
    if (value.every((d) => d > 0)) {
      _lodDistances = List.from(value);
    }
  }
  
  /// Instanced rendering enabled
  bool get instancedRendering => _instancedRendering;
  set instancedRendering(bool value) {
    _instancedRendering = value;
  }
  
  /// Maximum instance count
  int get maxInstances => _maxInstances;
  set maxInstances(int value) {
    if (value >= 1) {
      _maxInstances = value;
    }
  }
  
  /// Texture atlas enabled
  bool get textureAtlas => _textureAtlas;
  set textureAtlas(bool value) {
    _textureAtlas = value;
  }
  
  /// Atlas size
  int get atlasSize => _atlasSize;
  set atlasSize(int value) {
    if (value >= 1 && value <= dsrtMaxTextureSize) {
      _atlasSize = value;
    }
  }
  
  /// Mipmapping enabled
  bool get mipmapping => _mipmapping;
  set mipmapping(bool value) {
    _mipmapping = value;
  }
  
  /// Texture compression enabled
  bool get textureCompression => _textureCompression;
  set textureCompression(bool value) {
    _textureCompression = value;
  }
  
  /// Applies settings from config
  void apply(DSRTPerformanceSettings config) {
    _maxDrawCalls = config._maxDrawCalls;
    _maxTriangles = config._maxTriangles;
    _maxLights = config._maxLights;
    _frustumCulling = config._frustumCulling;
    _occlusionCulling = config._occlusionCulling;
    _occlusionQuerySize = config._occlusionQuerySize;
    _levelOfDetail = config._levelOfDetail;
    _lodDistances = List.from(config._lodDistances);
    _instancedRendering = config._instancedRendering;
    _maxInstances = config._maxInstances;
    _textureAtlas = config._textureAtlas;
    _atlasSize = config._atlasSize;
    _mipmapping = config._mipmapping;
    _textureCompression = config._textureCompression;
  }
  
  /// Resets to defaults
  void reset() {
    _maxDrawCalls = 1000;
    _maxTriangles = 1000000;
    _maxLights = dsrtMaxPointLights + dsrtMaxDirectionalLights + dsrtMaxSpotLights;
    _frustumCulling = true;
    _occlusionCulling = false;
    _occlusionQuerySize = 256;
    _levelOfDetail = true;
    _lodDistances = [10.0, 25.0, 50.0, 100.0];
    _instancedRendering = true;
    _maxInstances = 1000;
    _textureAtlas = true;
    _atlasSize = 2048;
    _mipmapping = true;
    _textureCompression = true;
  }
  
  /// Creates a snapshot
  DSRTPerformanceSettings createSnapshot() {
    final snapshot = DSRTPerformanceSettings();
    snapshot.apply(this);
    return snapshot;
  }
  
  /// Converts to map
  Map<String, dynamic> toMap() {
    return {
      'maxDrawCalls': _maxDrawCalls,
      'maxTriangles': _maxTriangles,
      'maxLights': _maxLights,
      'frustumCulling': _frustumCulling,
      'occlusionCulling': _occlusionCulling,
      'occlusionQuerySize': _occlusionQuerySize,
      'levelOfDetail': _levelOfDetail,
      'lodDistances': _lodDistances,
      'instancedRendering': _instancedRendering,
      'maxInstances': _maxInstances,
      'textureAtlas': _textureAtlas,
      'atlasSize': _atlasSize,
      'mipmapping': _mipmapping,
      'textureCompression': _textureCompression,
    };
  }
  
  /// Creates from map
  static DSRTPerformanceSettings fromMap(Map<String, dynamic> map) {
    final settings = DSRTPerformanceSettings();
    
    settings._maxDrawCalls = (map['maxDrawCalls'] as num?)?.toInt() ?? settings._maxDrawCalls;
    settings._maxTriangles = (map['maxTriangles'] as num?)?.toInt() ?? settings._maxTriangles;
    settings._maxLights = (map['maxLights'] as num?)?.toInt() ?? settings._maxLights;
    settings._frustumCulling = map['frustumCulling'] as bool? ?? settings._frustumCulling;
    settings._occlusionCulling = map['occlusionCulling'] as bool? ?? settings._occlusionCulling;
    settings._occlusionQuerySize = (map['occlusionQuerySize'] as num?)?.toInt() ?? settings._occlusionQuerySize;
    settings._levelOfDetail = map['levelOfDetail'] as bool? ?? settings._levelOfDetail;
    
    if (map['lodDistances'] != null) {
      final distances = (map['lodDistances'] as List).cast<num>();
      settings._lodDistances = distances.map((d) => d.toDouble()).toList();
    }
    
    settings._instancedRendering = map['instancedRendering'] as bool? ?? settings._instancedRendering;
    settings._maxInstances = (map['maxInstances'] as num?)?.toInt() ?? settings._maxInstances;
    settings._textureAtlas = map['textureAtlas'] as bool? ?? settings._textureAtlas;
    settings._atlasSize = (map['atlasSize'] as num?)?.toInt() ?? settings._atlasSize;
    settings._mipmapping = map['mipmapping'] as bool? ?? settings._mipmapping;
    settings._textureCompression = map['textureCompression'] as bool? ?? settings._textureCompression;
    
    return settings;
  }
}

/// Debug settings implementation
class DSRTDebugSettings {
  bool _wireframe;
  double _wireframeLineWidth;
  bool _boundingBoxes;
  double _boundingBoxLineWidth;
  bool _frustumVisualization;
  double _frustumLineWidth;
  bool _normalsVisualization;
  double _normalLineLength;
  double _normalLineWidth;
  bool _gridEnabled;
  double _gridSize;
  int _gridDivisions;
  bool _statsEnabled;
  bool _memoryStats;
  bool _performanceStats;
  bool _renderStats;
  bool _physicsStats;
  bool _audioStats;
  bool _uiStats;
  bool _logEnabled;
  int _logLevel;
  int _maxLogEntries;
  bool _breakOnError;
  bool _breakOnWarning;
  bool _breakOnAssert;
  
  /// Creates debug settings with defaults
  DSRTDebugSettings()
      : _wireframe = false,
        _wireframeLineWidth = 1.0,
        _boundingBoxes = false,
        _boundingBoxLineWidth = 1.0,
        _frustumVisualization = false,
        _frustumLineWidth = 1.0,
        _normalsVisualization = false,
        _normalLineLength = 1.0,
        _normalLineWidth = 1.0,
        _gridEnabled = false,
        _gridSize = 10.0,
        _gridDivisions = 10,
        _statsEnabled = false,
        _memoryStats = false,
        _performanceStats = false,
        _renderStats = false,
        _physicsStats = false,
        _audioStats = false,
        _uiStats = false,
        _logEnabled = true,
        _logLevel = 2, // INFO
        _maxLogEntries = 1000,
        _breakOnError = false,
        _breakOnWarning = false,
        _breakOnAssert = false;
  
  /// Wireframe rendering enabled
  bool get wireframe => _wireframe;
  set wireframe(bool value) {
    _wireframe = value;
  }
  
  /// Wireframe line width
  double get wireframeLineWidth => _wireframeLineWidth;
  set wireframeLineWidth(double value) {
    if (value > 0) {
      _wireframeLineWidth = value;
    }
  }
  
  /// Bounding boxes visualization enabled
  bool get boundingBoxes => _boundingBoxes;
  set boundingBoxes(bool value) {
    _boundingBoxes = value;
  }
  
  /// Bounding box line width
  double get boundingBoxLineWidth => _boundingBoxLineWidth;
  set boundingBoxLineWidth(double value) {
    if (value > 0) {
      _boundingBoxLineWidth = value;
    }
  }
  
  /// Frustum visualization enabled
  bool get frustumVisualization => _frustumVisualization;
  set frustumVisualization(bool value) {
    _frustumVisualization = value;
  }
  
  /// Frustum line width
  double get frustumLineWidth => _frustumLineWidth;
  set frustumLineWidth(double value) {
    if (value > 0) {
      _frustumLineWidth = value;
    }
  }
  
  /// Normals visualization enabled
  bool get normalsVisualization => _normalsVisualization;
  set normalsVisualization(bool value) {
    _normalsVisualization = value;
  }
  
  /// Normal line length
  double get normalLineLength => _normalLineLength;
  set normalLineLength(double value) {
    if (value > 0) {
      _normalLineLength = value;
    }
  }
  
  /// Normal line width
  double get normalLineWidth => _normalLineWidth;
  set normalLineWidth(double value) {
    if (value > 0) {
      _normalLineWidth = value;
    }
  }
  
  /// Grid enabled
  bool get gridEnabled => _gridEnabled;
  set gridEnabled(bool value) {
    _gridEnabled = value;
  }
  
  /// Grid size
  double get gridSize => _gridSize;
  set gridSize(double value) {
    if (value > 0) {
      _gridSize = value;
    }
  }
  
  /// Grid divisions
  int get gridDivisions => _gridDivisions;
  set gridDivisions(int value) {
    if (value >= 1) {
      _gridDivisions = value;
    }
  }
  
  /// Statistics enabled
  bool get statsEnabled => _statsEnabled;
  set statsEnabled(bool value) {
    _statsEnabled = value;
  }
  
  /// Memory statistics enabled
  bool get memoryStats => _memoryStats;
  set memoryStats(bool value) {
    _memoryStats = value;
  }
  
  /// Performance statistics enabled
  bool get performanceStats => _performanceStats;
  set performanceStats(bool value) {
    _performanceStats = value;
  }
  
  /// Render statistics enabled
  bool get renderStats => _renderStats;
  set renderStats(bool value) {
    _renderStats = value;
  }
  
  /// Physics statistics enabled
  bool get physicsStats => _physicsStats;
  set physicsStats(bool value) {
    _physicsStats = value;
  }
  
  /// Audio statistics enabled
  bool get audioStats => _audioStats;
  set audioStats(bool value) {
    _audioStats = value;
  }
  
  /// UI statistics enabled
  bool get uiStats => _uiStats;
  set uiStats(bool value) {
    _uiStats = value;
  }
  
  /// Logging enabled
  bool get logEnabled => _logEnabled;
  set logEnabled(bool value) {
    _logEnabled = value;
  }
  
  /// Log level (0=verbose, 1=debug, 2=info, 3=warning, 4=error, 5=critical)
  int get logLevel => _logLevel;
  set logLevel(int value) {
    if (value >= 0 && value <= 5) {
      _logLevel = value;
    }
  }
  
  /// Maximum log entries
  int get maxLogEntries => _maxLogEntries;
  set maxLogEntries(int value) {
    if (value >= 1) {
      _maxLogEntries = value;
    }
  }
  
  /// Break on error
  bool get breakOnError => _breakOnError;
  set breakOnError(bool value) {
    _breakOnError = value;
  }
  
  /// Break on warning
  bool get breakOnWarning => _breakOnWarning;
  set breakOnWarning(bool value) {
    _breakOnWarning = value;
  }
  
  /// Break on assert
  bool get breakOnAssert => _breakOnAssert;
  set breakOnAssert(bool value) {
    _breakOnAssert = value;
  }
  
  /// Applies settings from config
  void apply(DSRTDebugSettings config) {
    _wireframe = config._wireframe;
    _wireframeLineWidth = config._wireframeLineWidth;
    _boundingBoxes = config._boundingBoxes;
    _boundingBoxLineWidth = config._boundingBoxLineWidth;
    _frustumVisualization = config._frustumVisualization;
    _frustumLineWidth = config._frustumLineWidth;
    _normalsVisualization = config._normalsVisualization;
    _normalLineLength = config._normalLineLength;
    _normalLineWidth = config._normalLineWidth;
    _gridEnabled = config._gridEnabled;
    _gridSize = config._gridSize;
    _gridDivisions = config._gridDivisions;
    _statsEnabled = config._statsEnabled;
    _memoryStats = config._memoryStats;
    _performanceStats = config._performanceStats;
    _renderStats = config._renderStats;
    _physicsStats = config._physicsStats;
    _audioStats = config._audioStats;
    _uiStats = config._uiStats;
    _logEnabled = config._logEnabled;
    _logLevel = config._logLevel;
    _maxLogEntries = config._maxLogEntries;
    _breakOnError = config._breakOnError;
    _breakOnWarning = config._breakOnWarning;
    _breakOnAssert = config._breakOnAssert;
  }
  
  /// Resets to defaults
  void reset() {
    _wireframe = false;
    _wireframeLineWidth = 1.0;
    _boundingBoxes = false;
    _boundingBoxLineWidth = 1.0;
    _frustumVisualization = false;
    _frustumLineWidth = 1.0;
    _normalsVisualization = false;
    _normalLineLength = 1.0;
    _normalLineWidth = 1.0;
    _gridEnabled = false;
    _gridSize = 10.0;
    _gridDivisions = 10;
    _statsEnabled = false;
    _memoryStats = false;
    _performanceStats = false;
    _renderStats = false;
    _physicsStats = false;
    _audioStats = false;
    _uiStats = false;
    _logEnabled = true;
    _logLevel = 2;
    _maxLogEntries = 1000;
    _breakOnError = false;
    _breakOnWarning = false;
    _breakOnAssert = false;
  }
  
  /// Creates a snapshot
  DSRTDebugSettings createSnapshot() {
    final snapshot = DSRTDebugSettings();
    snapshot.apply(this);
    return snapshot;
  }
  
  /// Converts to map
  Map<String, dynamic> toMap() {
    return {
      'wireframe': _wireframe,
      'wireframeLineWidth': _wireframeLineWidth,
      'boundingBoxes': _boundingBoxes,
      'boundingBoxLineWidth': _boundingBoxLineWidth,
      'frustumVisualization': _frustumVisualization,
      'frustumLineWidth': _frustumLineWidth,
      'normalsVisualization': _normalsVisualization,
      'normalLineLength': _normalLineLength,
      'normalLineWidth': _normalLineWidth,
      'gridEnabled': _gridEnabled,
      'gridSize': _gridSize,
      'gridDivisions': _gridDivisions,
      'statsEnabled': _statsEnabled,
      'memoryStats': _memoryStats,
      'performanceStats': _performanceStats,
      'renderStats': _renderStats,
      'physicsStats': _physicsStats,
      'audioStats': _audioStats,
      'uiStats': _uiStats,
      'logEnabled': _logEnabled,
      'logLevel': _logLevel,
      'maxLogEntries': _maxLogEntries,
      'breakOnError': _breakOnError,
      'breakOnWarning': _breakOnWarning,
      'breakOnAssert': _breakOnAssert,
    };
  }
  
  /// Creates from map
  static DSRTDebugSettings fromMap(Map<String, dynamic> map) {
    final settings = DSRTDebugSettings();
    
    settings._wireframe = map['wireframe'] as bool? ?? settings._wireframe;
    settings._wireframeLineWidth = (map['wireframeLineWidth'] as num?)?.toDouble() ?? settings._wireframeLineWidth;
    settings._boundingBoxes = map['boundingBoxes'] as bool? ?? settings._boundingBoxes;
    settings._boundingBoxLineWidth = (map['boundingBoxLineWidth'] as num?)?.toDouble() ?? settings._boundingBoxLineWidth;
    settings._frustumVisualization = map['frustumVisualization'] as bool? ?? settings._frustumVisualization;
    settings._frustumLineWidth = (map['frustumLineWidth'] as num?)?.toDouble() ?? settings._frustumLineWidth;
    settings._normalsVisualization = map['normalsVisualization'] as bool? ?? settings._normalsVisualization;
    settings._normalLineLength = (map['normalLineLength'] as num?)?.toDouble() ?? settings._normalLineLength;
    settings._normalLineWidth = (map['normalLineWidth'] as num?)?.toDouble() ?? settings._normalLineWidth;
    settings._gridEnabled = map['gridEnabled'] as bool? ?? settings._gridEnabled;
    settings._gridSize = (map['gridSize'] as num?)?.toDouble() ?? settings._gridSize;
    settings._gridDivisions = (map['gridDivisions'] as num?)?.toInt() ?? settings._gridDivisions;
    settings._statsEnabled = map['statsEnabled'] as bool? ?? settings._statsEnabled;
    settings._memoryStats = map['memoryStats'] as bool? ?? settings._memoryStats;
    settings._performanceStats = map['performanceStats'] as bool? ?? settings._performanceStats;
    settings._renderStats = map['renderStats'] as bool? ?? settings._renderStats;
    settings._physicsStats = map['physicsStats'] as bool? ?? settings._physicsStats;
    settings._audioStats = map['audioStats'] as bool? ?? settings._audioStats;
    settings._uiStats = map['uiStats'] as bool? ?? settings._uiStats;
    settings._logEnabled = map['logEnabled'] as bool? ?? settings._logEnabled;
    settings._logLevel = (map['logLevel'] as num?)?.toInt() ?? settings._logLevel;
    settings._maxLogEntries = (map['maxLogEntries'] as num?)?.toInt() ?? settings._maxLogEntries;
    settings._breakOnError = map['breakOnError'] as bool? ?? settings._breakOnError;
    settings._breakOnWarning = map['breakOnWarning'] as bool? ?? settings._breakOnWarning;
    settings._breakOnAssert = map['breakOnAssert'] as bool? ?? settings._breakOnAssert;
    
    return settings;
  }
}

/// System settings implementation
class DSRTSystemSettings {
  int _maxTextureCacheSizeMB;
  int _maxGeometryCacheSizeMB;
  int _maxMaterialCacheSizeMB;
  int _maxShaderCacheSizeMB;
  int _maxAudioCacheSizeMB;
  int _maxConcurrentDownloads;
  int _downloadTimeoutSeconds;
  int _maxDownloadRetries;
  int _compressionLevel;
  int _mipmapQuality;
  bool _asyncLoading;
  bool _preloadAssets;
  bool _cacheAssets;
  bool _validateAssets;
  bool _optimizeAssets;
  String _assetPath;
  String _cachePath;
  String _logPath;
  String _tempPath;
  
  /// Creates system settings with defaults
  DSRTSystemSettings()
      : _maxTextureCacheSizeMB = dsrtDefaultTextureCacheSizeMB,
        _maxGeometryCacheSizeMB = dsrtDefaultGeometryCacheSizeMB,
        _maxMaterialCacheSizeMB = dsrtDefaultMaterialCacheSizeMB,
        _maxShaderCacheSizeMB = dsrtDefaultShaderCacheSizeMB,
        _maxAudioCacheSizeMB = dsrtDefaultAudioCacheSizeMB,
        _maxConcurrentDownloads = dsrtMaxConcurrentDownloads,
        _downloadTimeoutSeconds = dsrtDefaultDownloadTimeoutSeconds,
        _maxDownloadRetries = dsrtMaxDownloadRetries,
        _compressionLevel = dsrtDefaultCompressionLevel,
        _mipmapQuality = dsrtDefaultMipmapQuality,
        _asyncLoading = true,
        _preloadAssets = false,
        _cacheAssets = true,
        _validateAssets = true,
        _optimizeAssets = true,
        _assetPath = 'assets/',
        _cachePath = 'cache/',
        _logPath = 'logs/',
        _tempPath = 'temp/';
  
  /// Maximum texture cache size in MB
  int get maxTextureCacheSizeMB => _maxTextureCacheSizeMB;
  set maxTextureCacheSizeMB(int value) {
    if (value >= 0) {
      _maxTextureCacheSizeMB = value;
    }
  }
  
  /// Maximum geometry cache size in MB
  int get maxGeometryCacheSizeMB => _maxGeometryCacheSizeMB;
  set maxGeometryCacheSizeMB(int value) {
    if (value >= 0) {
      _maxGeometryCacheSizeMB = value;
    }
  }
  
  /// Maximum material cache size in MB
  int get maxMaterialCacheSizeMB => _maxMaterialCacheSizeMB;
  set maxMaterialCacheSizeMB(int value) {
    if (value >= 0) {
      _maxMaterialCacheSizeMB = value;
    }
  }
  
  /// Maximum shader cache size in MB
  int get maxShaderCacheSizeMB => _maxShaderCacheSizeMB;
  set maxShaderCacheSizeMB(int value) {
    if (value >= 0) {
      _maxShaderCacheSizeMB = value;
    }
  }
  
  /// Maximum audio cache size in MB
  int get maxAudioCacheSizeMB => _maxAudioCacheSizeMB;
  set maxAudioCacheSizeMB(int value) {
    if (value >= 0) {
      _maxAudioCacheSizeMB = value;
    }
  }
  
  /// Maximum concurrent downloads
  int get maxConcurrentDownloads => _maxConcurrentDownloads;
  set maxConcurrentDownloads(int value) {
    if (value >= 1) {
      _maxConcurrentDownloads = value;
    }
  }
  
  /// Download timeout in seconds
  int get downloadTimeoutSeconds => _downloadTimeoutSeconds;
  set downloadTimeoutSeconds(int value) {
    if (value >= 1) {
      _downloadTimeoutSeconds = value;
    }
  }
  
  /// Maximum download retries
  int get maxDownloadRetries => _maxDownloadRetries;
  set maxDownloadRetries(int value) {
    if (value >= 0) {
      _maxDownloadRetries = value;
    }
  }
  
  /// Compression level (0-9)
  int get compressionLevel => _compressionLevel;
  set compressionLevel(int value) {
    if (value >= 0 && value <= 9) {
      _compressionLevel = value;
    }
  }
  
  /// Mipmap quality (0=fast, 1=normal, 2=high)
  int get mipmapQuality => _mipmapQuality;
  set mipmapQuality(int value) {
    if (value >= 0 && value <= 2) {
      _mipmapQuality = value;
    }
  }
  
  /// Async loading enabled
  bool get asyncLoading => _asyncLoading;
  set asyncLoading(bool value) {
    _asyncLoading = value;
  }
  
  /// Preload assets enabled
  bool get preloadAssets => _preloadAssets;
  set preloadAssets(bool value) {
    _preloadAssets = value;
  }
  
  /// Cache assets enabled
  bool get cacheAssets => _cacheAssets;
  set cacheAssets(bool value) {
    _cacheAssets = value;
  }
  
  /// Validate assets enabled
  bool get validateAssets => _validateAssets;
  set validateAssets(bool value) {
    _validateAssets = value;
  }
  
  /// Optimize assets enabled
  bool get optimizeAssets => _optimizeAssets;
  set optimizeAssets(bool value) {
    _optimizeAssets = value;
  }
  
  /// Asset path
  String get assetPath => _assetPath;
  set assetPath(String value) {
    _assetPath = value;
  }
  
  /// Cache path
  String get cachePath => _cachePath;
  set cachePath(String value) {
    _cachePath = value;
  }
  
  /// Log path
  String get logPath => _logPath;
  set logPath(String value) {
    _logPath = value;
  }
  
  /// Temp path
  String get tempPath => _tempPath;
  set tempPath(String value) {
    _tempPath = value;
  }
  
  /// Applies settings from config
  void apply(DSRTSystemSettings config) {
    _maxTextureCacheSizeMB = config._maxTextureCacheSizeMB;
    _maxGeometryCacheSizeMB = config._maxGeometryCacheSizeMB;
    _maxMaterialCacheSizeMB = config._maxMaterialCacheSizeMB;
    _maxShaderCacheSizeMB = config._maxShaderCacheSizeMB;
    _maxAudioCacheSizeMB = config._maxAudioCacheSizeMB;
    _maxConcurrentDownloads = config._maxConcurrentDownloads;
    _downloadTimeoutSeconds = config._downloadTimeoutSeconds;
    _maxDownloadRetries = config._maxDownloadRetries;
    _compressionLevel = config._compressionLevel;
    _mipmapQuality = config._mipmapQuality;
    _asyncLoading = config._asyncLoading;
    _preloadAssets = config._preloadAssets;
    _cacheAssets = config._cacheAssets;
    _validateAssets = config._validateAssets;
    _optimizeAssets = config._optimizeAssets;
    _assetPath = config._assetPath;
    _cachePath = config._cachePath;
    _logPath = config._logPath;
    _tempPath = config._tempPath;
  }
  
  /// Resets to defaults
  void reset() {
    _maxTextureCacheSizeMB = dsrtDefaultTextureCacheSizeMB;
    _maxGeometryCacheSizeMB = dsrtDefaultGeometryCacheSizeMB;
    _maxMaterialCacheSizeMB = dsrtDefaultMaterialCacheSizeMB;
    _maxShaderCacheSizeMB = dsrtDefaultShaderCacheSizeMB;
    _maxAudioCacheSizeMB = dsrtDefaultAudioCacheSizeMB;
    _maxConcurrentDownloads = dsrtMaxConcurrentDownloads;
    _downloadTimeoutSeconds = dsrtDefaultDownloadTimeoutSeconds;
    _maxDownloadRetries = dsrtMaxDownloadRetries;
    _compressionLevel = dsrtDefaultCompressionLevel;
    _mipmapQuality = dsrtDefaultMipmapQuality;
    _asyncLoading = true;
    _preloadAssets = false;
    _cacheAssets = true;
    _validateAssets = true;
    _optimizeAssets = true;
    _assetPath = 'assets/';
    _cachePath = 'cache/';
    _logPath = 'logs/';
    _tempPath = 'temp/';
  }
  
  /// Creates a snapshot
  DSRTSystemSettings createSnapshot() {
    final snapshot = DSRTSystemSettings();
    snapshot.apply(this);
    return snapshot;
  }
  
  /// Converts to map
  Map<String, dynamic> toMap() {
    return {
      'maxTextureCacheSizeMB': _maxTextureCacheSizeMB,
      'maxGeometryCacheSizeMB': _maxGeometryCacheSizeMB,
      'maxMaterialCacheSizeMB': _maxMaterialCacheSizeMB,
      'maxShaderCacheSizeMB': _maxShaderCacheSizeMB,
      'maxAudioCacheSizeMB': _maxAudioCacheSizeMB,
      'maxConcurrentDownloads': _maxConcurrentDownloads,
      'downloadTimeoutSeconds': _downloadTimeoutSeconds,
      'maxDownloadRetries': _maxDownloadRetries,
      'compressionLevel': _compressionLevel,
      'mipmapQuality': _mipmapQuality,
      'asyncLoading': _asyncLoading,
      'preloadAssets': _preloadAssets,
      'cacheAssets': _cacheAssets,
      'validateAssets': _validateAssets,
      'optimizeAssets': _optimizeAssets,
      'assetPath': _assetPath,
      'cachePath': _cachePath,
      'logPath': _logPath,
      'tempPath': _tempPath,
    };
  }
  
  /// Creates from map
  static DSRTSystemSettings fromMap(Map<String, dynamic> map) {
    final settings = DSRTSystemSettings();
    
    settings._maxTextureCacheSizeMB = (map['maxTextureCacheSizeMB'] as num?)?.toInt() ?? settings._maxTextureCacheSizeMB;
    settings._maxGeometryCacheSizeMB = (map['maxGeometryCacheSizeMB'] as num?)?.toInt() ?? settings._maxGeometryCacheSizeMB;
    settings._maxMaterialCacheSizeMB = (map['maxMaterialCacheSizeMB'] as num?)?.toInt() ?? settings._maxMaterialCacheSizeMB;
    settings._maxShaderCacheSizeMB = (map['maxShaderCacheSizeMB'] as num?)?.toInt() ?? settings._maxShaderCacheSizeMB;
    settings._maxAudioCacheSizeMB = (map['maxAudioCacheSizeMB'] as num?)?.toInt() ?? settings._maxAudioCacheSizeMB;
    settings._maxConcurrentDownloads = (map['maxConcurrentDownloads'] as num?)?.toInt() ?? settings._maxConcurrentDownloads;
    settings._downloadTimeoutSeconds = (map['downloadTimeoutSeconds'] as num?)?.toInt() ?? settings._downloadTimeoutSeconds;
    settings._maxDownloadRetries = (map['maxDownloadRetries'] as num?)?.toInt() ?? settings._maxDownloadRetries;
    settings._compressionLevel = (map['compressionLevel'] as num?)?.toInt() ?? settings._compressionLevel;
    settings._mipmapQuality = (map['mipmapQuality'] as num?)?.toInt() ?? settings._mipmapQuality;
    settings._asyncLoading = map['asyncLoading'] as bool? ?? settings._asyncLoading;
    settings._preloadAssets = map['preloadAssets'] as bool? ?? settings._preloadAssets;
    settings._cacheAssets = map['cacheAssets'] as bool? ?? settings._cacheAssets;
    settings._validateAssets = map['validateAssets'] as bool? ?? settings._validateAssets;
    settings._optimizeAssets = map['optimizeAssets'] as bool? ?? settings._optimizeAssets;
    settings._assetPath = map['assetPath'] as String? ?? settings._assetPath;
    settings._cachePath = map['cachePath'] as String? ?? settings._cachePath;
    settings._logPath = map['logPath'] as String? ?? settings._logPath;
    settings._tempPath = map['tempPath'] as String? ?? settings._tempPath;
    
    return settings;
  }
}

/// Settings configuration container
class DSRTSettingsConfig {
  final DSRTRenderSettings render;
  final DSRTQualitySettings quality;
  final DSRTPerformanceSettings performance;
  final DSRTDebugSettings debug;
  final DSRTSystemSettings system;
  
  /// Creates settings configuration
  DSRTSettingsConfig({
    required this.render,
    required this.quality,
    required this.performance,
    required this.debug,
    required this.system,
  });
  
  /// Creates from map
  static DSRTSettingsConfig fromMap(Map<String, dynamic> map) {
    return DSRTSettingsConfig(
      render: DSRTRenderSettings.fromMap(map['render'] as Map<String, dynamic>? ?? {}),
      quality: DSRTQualitySettings.fromMap(map['quality'] as Map<String, dynamic>? ?? {}),
      performance: DSRTPerformanceSettings.fromMap(map['performance'] as Map<String, dynamic>? ?? {}),
      debug: DSRTDebugSettings.fromMap(map['debug'] as Map<String, dynamic>? ?? {}),
      system: DSRTSystemSettings.fromMap(map['system'] as Map<String, dynamic>? ?? {}),
    );
  }
  
  /// Converts to map
  Map<String, dynamic> toMap() {
    return {
      'render': render.toMap(),
      'quality': quality.toMap(),
      'performance': performance.toMap(),
      'debug': debug.toMap(),
      'system': system.toMap(),
    };
  }
}
