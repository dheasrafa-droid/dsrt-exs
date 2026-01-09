/// Runtime settings for the engine
/// 
/// These settings can be changed during runtime and affect
/// engine behavior and rendering quality.
/// 
/// @license MIT
/// @copyright (c) 2024 DSRT Engine

/// Anti-aliasing mode
enum ExsAntiAliasing {
  /// No anti-aliasing
  none,
  
  /// 2x Multi-sample anti-aliasing
  msaa2x,
  
  /// 4x Multi-sample anti-aliasing
  msaa4x,
  
  /// 8x Multi-sample anti-aliasing
  msaa8x,
  
  /// Fast approximate anti-aliasing
  fxaa,
  
  /// Temporal anti-aliasing
  taa,
}

/// Shadow quality settings
enum ExsShadowQuality {
  /// No shadows
  disabled,
  
  /// Low quality shadows (256x256)
  low,
  
  /// Medium quality shadows (512x512)
  medium,
  
  /// High quality shadows (1024x1024)
  high,
  
  /// Ultra quality shadows (2048x2048)
  ultra,
}

/// Texture filtering mode
enum ExsTextureFilter {
  /// Nearest neighbor filtering
  nearest,
  
  /// Linear filtering
  linear,
  
  /// Mipmapped linear filtering
  linearMipmapLinear,
  
  /// Anisotropic filtering
  anisotropic,
}

/// Engine runtime settings
class ExsSettings {
  /// Current anti-aliasing mode
  ExsAntiAliasing antiAliasing;
  
  /// Shadow quality setting
  ExsShadowQuality shadowQuality;
  
  /// Maximum anisotropic filtering level
  int maxAnisotropy;
  
  /// Texture filtering mode
  ExsTextureFilter textureFilter;
  
  /// Enable gamma correction
  bool gammaCorrection;
  
  /// Gamma correction value
  double gammaFactor;
  
  /// Enable HDR rendering
  bool hdrEnabled;
  
  /// Tone mapping enabled
  bool toneMapping;
  
  /// Ambient occlusion enabled
  bool ambientOcclusion;
  
  /// Screen space reflections enabled
  bool screenSpaceReflections;
  
  /// Bloom effect enabled
  bool bloomEnabled;
  
  /// Depth of field enabled
  bool depthOfField;
  
  /// Motion blur enabled
  bool motionBlur;
  
  /// V-Sync enabled
  bool vSync;
  
  /// Show frame rate counter
  bool showFPS;
  
  /// Show performance stats
  bool showStats;
  
  /// Show wireframe overlay
  bool showWireframe;
  
  /// Show bounding boxes
  bool showBoundingBoxes;
  
  /// Show normals
  bool showNormals;
  
  /// Default constructor with quality presets
  ExsSettings({
    this.antiAliasing = ExsAntiAliasing.none,
    this.shadowQuality = ExsShadowQuality.medium,
    this.maxAnisotropy = 4,
    this.textureFilter = ExsTextureFilter.linearMipmapLinear,
    this.gammaCorrection = true,
    this.gammaFactor = 2.2,
    this.hdrEnabled = false,
    this.toneMapping = false,
    this.ambientOcclusion = false,
    this.screenSpaceReflections = false,
    this.bloomEnabled = false,
    this.depthOfField = false,
    this.motionBlur = false,
    this.vSync = true,
    this.showFPS = false,
    this.showStats = false,
    this.showWireframe = false,
    this.showBoundingBoxes = false,
    this.showNormals = false,
  });
  
  /// Create low quality settings for performance
  factory ExsSettings.low() {
    return ExsSettings(
      antiAliasing: ExsAntiAliasing.none,
      shadowQuality: ExsShadowQuality.low,
      maxAnisotropy: 1,
      textureFilter: ExsTextureFilter.linear,
      gammaCorrection: false,
      hdrEnabled: false,
      toneMapping: false,
      ambientOcclusion: false,
      bloomEnabled: false,
      depthOfField: false,
      motionBlur: false,
      vSync: false,
    );
  }
  
  /// Create medium quality balanced settings
  factory ExsSettings.medium() {
    return ExsSettings(
      antiAliasing: ExsAntiAliasing.msaa2x,
      shadowQuality: ExsShadowQuality.medium,
      maxAnisotropy: 4,
      textureFilter: ExsTextureFilter.linearMipmapLinear,
      gammaCorrection: true,
      hdrEnabled: false,
      toneMapping: true,
      ambientOcclusion: false,
      bloomEnabled: false,
      depthOfField: false,
      motionBlur: false,
      vSync: true,
    );
  }
  
  /// Create high quality settings for visual fidelity
  factory ExsSettings.high() {
    return ExsSettings(
      antiAliasing: ExsAntiAliasing.msaa4x,
      shadowQuality: ExsShadowQuality.high,
      maxAnisotropy: 8,
      textureFilter: ExsTextureFilter.anisotropic,
      gammaCorrection: true,
      hdrEnabled: true,
      toneMapping: true,
      ambientOcclusion: true,
      bloomEnabled: true,
      depthOfField: false,
      motionBlur: false,
      vSync: true,
    );
  }
  
  /// Create ultra quality settings for maximum visuals
  factory ExsSettings.ultra() {
    return ExsSettings(
      antiAliasing: ExsAntiAliasing.msaa8x,
      shadowQuality: ExsShadowQuality.ultra,
      maxAnisotropy: 16,
      textureFilter: ExsTextureFilter.anisotropic,
      gammaCorrection: true,
      hdrEnabled: true,
      toneMapping: true,
      ambientOcclusion: true,
      screenSpaceReflections: true,
      bloomEnabled: true,
      depthOfField: true,
      motionBlur: true,
      vSync: true,
    );
  }
  
  /// Get shadow map resolution based on quality setting
  int get shadowMapResolution {
    switch (shadowQuality) {
      case ExsShadowQuality.disabled:
        return 0;
      case ExsShadowQuality.low:
        return 256;
      case ExsShadowQuality.medium:
        return 512;
      case ExsShadowQuality.high:
        return 1024;
      case ExsShadowQuality.ultra:
        return 2048;
    }
  }
  
  /// Check if shadows are enabled
  bool get shadowsEnabled => shadowQuality != ExsShadowQuality.disabled;
  
  /// Check if anti-aliasing is enabled
  bool get antiAliasingEnabled => antiAliasing != ExsAntiAliasing.none;
  
  /// Apply quality preset
  void applyPreset(ExsQualityPreset preset) {
    switch (preset) {
      case ExsQualityPreset.low:
        final low = ExsSettings.low();
        _copySettings(low);
        break;
      case ExsQualityPreset.medium:
        final medium = ExsSettings.medium();
        _copySettings(medium);
        break;
      case ExsQualityPreset.high:
        final high = ExsSettings.high();
        _copySettings(high);
        break;
      case ExsQualityPreset.ultra:
        final ultra = ExsSettings.ultra();
        _copySettings(ultra);
        break;
    }
  }
  
  /// Copy settings from another instance
  void _copySettings(ExsSettings other) {
    antiAliasing = other.antiAliasing;
    shadowQuality = other.shadowQuality;
    maxAnisotropy = other.maxAnisotropy;
    textureFilter = other.textureFilter;
    gammaCorrection = other.gammaCorrection;
    gammaFactor = other.gammaFactor;
    hdrEnabled = other.hdrEnabled;
    toneMapping = other.toneMapping;
    ambientOcclusion = other.ambientOcclusion;
    screenSpaceReflections = other.screenSpaceReflections;
    bloomEnabled = other.bloomEnabled;
    depthOfField = other.depthOfField;
    motionBlur = other.motionBlur;
    vSync = other.vSync;
    showFPS = other.showFPS;
    showStats = other.showStats;
    showWireframe = other.showWireframe;
    showBoundingBoxes = other.showBoundingBoxes;
    showNormals = other.showNormals;
  }
  
  @override
  String toString() {
    return 'ExsSettings('
           'antiAliasing: $antiAliasing, '
           'shadowQuality: $shadowQuality, '
           'maxAnisotropy: $maxAnisotropy, '
           'shadowsEnabled: $shadowsEnabled)';
  }
}

/// Quality presets for quick configuration
enum ExsQualityPreset {
  /// Low quality for maximum performance
  low,
  
  /// Medium quality balanced
  medium,
  
  /// High quality for good visuals
  high,
  
  /// Ultra quality for maximum visuals
  ultra,
}
