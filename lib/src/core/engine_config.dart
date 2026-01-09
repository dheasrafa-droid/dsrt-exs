/// Engine configuration system for DSRT Engine
/// 
/// Provides configuration management, validation, and presets
/// for engine initialization and runtime settings.
/// 
/// [preset]: Configuration preset to start from.
/// [overrides]: Configuration overrides to apply.
part of dsrt_engine.core.internal;

/// Engine configuration class
/// 
/// Contains all configurable parameters for the DSRT Engine.
/// Use [EngineConfig.defaultConfig] for sensible defaults or
/// [EngineConfigBuilder] for custom configuration.
/// 
/// Example:
/// ```dart
/// final config = EngineConfig(
///   renderBackend: RenderBackend.webgl,
///   resolution: Resolution(1920, 1080),
///   physicsEnabled: true,
///   audioEnabled: true,
/// );
/// ```
class EngineConfig {
  /// Rendering backend to use
  final RenderBackend renderBackend;
  
  /// Target resolution
  final Resolution resolution;
  
  /// Whether rendering is enabled
  final bool renderEnabled;
  
  /// Whether physics simulation is enabled
  final bool physicsEnabled;
  
  /// Physics backend to use
  final PhysicsBackend physicsBackend;
  
  /// Physics configuration
  final PhysicsConfig physicsConfig;
  
  /// Whether audio is enabled
  final bool audioEnabled;
  
  /// Audio sample rate
  final int audioSampleRate;
  
  /// Audio channel count
  final int audioChannels;
  
  /// Whether UI system is enabled
  final bool uiEnabled;
  
  /// UI rendering mode
  final UIRenderMode uiRenderMode;
  
  /// UI resolution
  final Resolution uiResolution;
  
  /// List of plugins to load
  final List<PluginDescriptor> plugins;
  
  /// Maximum texture size
  final int maxTextureSize;
  
  /// Maximum geometry buffers
  final int maxGeometryBuffers;
  
  /// Maximum shader programs
  final int maxShaderPrograms;
  
  /// Whether antialiasing is enabled
  final bool antialias;
  
  /// Whether alpha channel is enabled
  final bool alpha;
  
  /// Whether depth buffer is enabled
  final bool depth;
  
  /// Whether stencil buffer is enabled
  final bool stencil;
  
  /// Whether to preserve drawing buffer
  final bool preserveDrawingBuffer;
  
  /// WebGL power preference
  final PowerPreference powerPreference;
  
  /// Gravity vector for physics
  final Vector3 gravity;
  
  /// Shadow quality setting
  final ShadowQuality shadowQuality;
  
  /// Texture quality setting
  final TextureQuality textureQuality;
  
  /// Anisotropy level
  final int anisotropy;
  
  /// Mipmap filter quality
  final MipmapFilter mipmapFilter;
  
  /// Memory warning threshold in MB
  final int memoryWarningThreshold;
  
  /// CPU warning threshold (0.0 to 1.0)
  final double cpuWarningThreshold;
  
  /// GPU warning threshold (0.0 to 1.0)
  final double gpuWarningThreshold;
  
  /// Creates an engine configuration
  EngineConfig({
    this.renderBackend = RenderBackend.webgl,
    this.resolution = const Resolution(1280, 720),
    this.renderEnabled = true,
    this.physicsEnabled = false,
    this.physicsBackend = PhysicsBackend.bullet,
    PhysicsConfig? physicsConfig,
    this.audioEnabled = true,
    this.audioSampleRate = 44100,
    this.audioChannels = 2,
    this.uiEnabled = true,
    this.uiRenderMode = UIRenderMode.canvas2d,
    Resolution? uiResolution,
    this.plugins = const [],
    this.maxTextureSize = 4096,
    this.maxGeometryBuffers = 1024,
    this.maxShaderPrograms = 256,
    this.antialias = true,
    this.alpha = true,
    this.depth = true,
    this.stencil = false,
    this.preserveDrawingBuffer = false,
    this.powerPreference = PowerPreference.defaultPreference,
    Vector3? gravity,
    this.shadowQuality = ShadowQuality.medium,
    this.textureQuality = TextureQuality.medium,
    this.anisotropy = 1,
    this.mipmapFilter = MipmapFilter.linear,
    this.memoryWarningThreshold = 512,
    this.cpuWarningThreshold = 0.8,
    this.gpuWarningThreshold = 0.8,
  })  : physicsConfig = physicsConfig ?? PhysicsConfig.defaultConfig(),
        uiResolution = uiResolution ?? resolution,
        gravity = gravity ?? Vector3(0, -9.81, 0);
  
  /// Creates default configuration for current platform
  /// 
  /// Returns: Platform-optimized default configuration.
  factory EngineConfig.defaultConfig() {
    final platform = PlatformUtils.currentPlatform;
    
    return switch (platform) {
      PlatformType.web => EngineConfig(
          renderBackend: RenderBackend.webgl,
          resolution: Resolution(1920, 1080),
          physicsEnabled: true,
          physicsBackend: PhysicsBackend.ammo, // WASM-friendly
          audioEnabled: true,
          audioSampleRate: 44100,
          uiEnabled: true,
          maxTextureSize: 4096,
          antialias: true,
        ),
      PlatformType.mobile => EngineConfig(
          renderBackend: RenderBackend.webgl,
          resolution: Resolution(1080, 1920),
          physicsEnabled: false, // Save battery
          audioEnabled: true,
          audioSampleRate: 48000,
          uiEnabled: true,
          maxTextureSize: 2048,
          antialias: false, // Performance
        ),
      PlatformType.desktop => EngineConfig(
          renderBackend: RenderBackend.webgl,
          resolution: Resolution(2560, 1440),
          physicsEnabled: true,
          physicsBackend: PhysicsBackend.bullet,
          audioEnabled: true,
          audioSampleRate: 48000,
          uiEnabled: true,
          maxTextureSize: 8192,
          antialias: true,
          anisotropy: 16,
        ),
      _ => EngineConfig(),
    };
  }
  
  /// Creates minimal configuration for headless/server use
  /// 
  /// Returns: Configuration with rendering and UI disabled.
  factory EngineConfig.headless() {
    return EngineConfig(
      renderEnabled: false,
      physicsEnabled: true,
      audioEnabled: false,
      uiEnabled: false,
      renderBackend: RenderBackend.none,
    );
  }
  
  /// Creates high-performance configuration
  /// 
  /// Returns: Configuration optimized for maximum performance.
  factory EngineConfig.highPerformance() {
    return EngineConfig(
      renderBackend: RenderBackend.webgl,
      resolution: Resolution(1920, 1080),
      antialias: false,
      anisotropy: 0,
      mipmapFilter: MipmapFilter.nearest,
      shadowQuality: ShadowQuality.low,
      textureQuality: TextureQuality.low,
      physicsEnabled: true,
      audioEnabled: true,
      uiEnabled: true,
    );
  }
  
  /// Creates high-quality configuration
  /// 
  /// Returns: Configuration optimized for visual quality.
  factory EngineConfig.highQuality() {
    return EngineConfig(
      renderBackend: RenderBackend.webgl,
      resolution: Resolution(3840, 2160),
      antialias: true,
      anisotropy: 16,
      mipmapFilter: MipmapFilter.linear,
      shadowQuality: ShadowQuality.high,
      textureQuality: TextureQuality.high,
      physicsEnabled: true,
      audioEnabled: true,
      uiEnabled: true,
      maxTextureSize: 16384,
    );
  }
  
  /// Applies configuration overrides
  /// 
  /// [overrides]: Map of configuration values to override.
  void applyOverrides(Map<String, dynamic> overrides) {
    // Note: Since EngineConfig is immutable, this creates a new config
    // In actual implementation, this would use a builder pattern
    _validateOverrides(overrides);
  }
  
  /// Validates configuration overrides
  /// 
  /// [overrides]: Overrides to validate.
  /// 
  /// Throws [EngineConfigurationError] if overrides are invalid.
  void _validateOverrides(Map<String, dynamic> overrides) {
    for (final entry in overrides.entries) {
      switch (entry.key) {
        case 'resolution':
          if (entry.value is! Resolution) {
            throw EngineConfigurationError(
              'Resolution must be a Resolution object',
            );
          }
          break;
          
        case 'maxTextureSize':
          if (entry.value is! int || entry.value <= 0) {
            throw EngineConfigurationError(
              'maxTextureSize must be a positive integer',
            );
          }
          break;
          
        case 'audioSampleRate':
          if (entry.value is! int || 
              ![44100, 48000, 96000].contains(entry.value)) {
            throw EngineConfigurationError(
              'audioSampleRate must be 44100, 48000, or 96000',
            );
          }
          break;
          
        // Add more validations as needed
      }
    }
  }
  
  /// Converts configuration to JSON
  /// 
  /// Returns: JSON representation of configuration.
  Map<String, dynamic> toJson() {
    return {
      'renderBackend': renderBackend.name,
      'resolution': {
        'width': resolution.width,
        'height': resolution.height,
      },
      'renderEnabled': renderEnabled,
      'physicsEnabled': physicsEnabled,
      'physicsBackend': physicsBackend.name,
      'physicsConfig': physicsConfig.toJson(),
      'audioEnabled': audioEnabled,
      'audioSampleRate': audioSampleRate,
      'audioChannels': audioChannels,
      'uiEnabled': uiEnabled,
      'uiRenderMode': uiRenderMode.name,
      'uiResolution': {
        'width': uiResolution.width,
        'height': uiResolution.height,
      },
      'plugins': plugins.map((p) => p.toJson()).toList(),
      'maxTextureSize': maxTextureSize,
      'maxGeometryBuffers': maxGeometryBuffers,
      'maxShaderPrograms': maxShaderPrograms,
      'antialias': antialias,
      'alpha': alpha,
      'depth': depth,
      'stencil': stencil,
      'preserveDrawingBuffer': preserveDrawingBuffer,
      'powerPreference': powerPreference.name,
      'gravity': {
        'x': gravity.x,
        'y': gravity.y,
        'z': gravity.z,
      },
      'shadowQuality': shadowQuality.name,
      'textureQuality': textureQuality.name,
      'anisotropy': anisotropy,
      'mipmapFilter': mipmapFilter.name,
      'memoryWarningThreshold': memoryWarningThreshold,
      'cpuWarningThreshold': cpuWarningThreshold,
      'gpuWarningThreshold': gpuWarningThreshold,
    };
  }
  
  /// Creates configuration from JSON
  /// 
  /// [json]: JSON data to parse.
  /// 
  /// Returns: EngineConfig instance.
  /// 
  /// Throws [EngineConfigurationError] if JSON is invalid.
  factory EngineConfig.fromJson(Map<String, dynamic> json) {
    try {
      return EngineConfig(
        renderBackend: RenderBackend.values.firstWhere(
          (e) => e.name == json['renderBackend'],
          orElse: () => RenderBackend.webgl,
        ),
        resolution: Resolution(
          json['resolution']['width'],
          json['resolution']['height'],
        ),
        renderEnabled: json['renderEnabled'] ?? true,
        physicsEnabled: json['physicsEnabled'] ?? false,
        physicsBackend: PhysicsBackend.values.firstWhere(
          (e) => e.name == json['physicsBackend'],
          orElse: () => PhysicsBackend.bullet,
        ),
        physicsConfig: json['physicsConfig'] != null
            ? PhysicsConfig.fromJson(json['physicsConfig'])
            : PhysicsConfig.defaultConfig(),
        audioEnabled: json['audioEnabled'] ?? true,
        audioSampleRate: json['audioSampleRate'] ?? 44100,
        audioChannels: json['audioChannels'] ?? 2,
        uiEnabled: json['uiEnabled'] ?? true,
        uiRenderMode: UIRenderMode.values.firstWhere(
          (e) => e.name == json['uiRenderMode'],
          orElse: () => UIRenderMode.canvas2d,
        ),
        uiResolution: json['uiResolution'] != null
            ? Resolution(
                json['uiResolution']['width'],
                json['uiResolution']['height'],
              )
            : Resolution(
                json['resolution']['width'],
                json['resolution']['height'],
              ),
        plugins: (json['plugins'] as List?)
                ?.map((p) => PluginDescriptor.fromJson(p))
                .toList() ??
            const [],
        maxTextureSize: json['maxTextureSize'] ?? 4096,
        maxGeometryBuffers: json['maxGeometryBuffers'] ?? 1024,
        maxShaderPrograms: json['maxShaderPrograms'] ?? 256,
        antialias: json['antialias'] ?? true,
        alpha: json['alpha'] ?? true,
        depth: json['depth'] ?? true,
        stencil: json['stencil'] ?? false,
        preserveDrawingBuffer: json['preserveDrawingBuffer'] ?? false,
        powerPreference: PowerPreference.values.firstWhere(
          (e) => e.name == json['powerPreference'],
          orElse: () => PowerPreference.defaultPreference,
        ),
        gravity: json['gravity'] != null
            ? Vector3(
                json['gravity']['x'],
                json['gravity']['y'],
                json['gravity']['z'],
              )
            : Vector3(0, -9.81, 0),
        shadowQuality: ShadowQuality.values.firstWhere(
          (e) => e.name == json['shadowQuality'],
          orElse: () => ShadowQuality.medium,
        ),
        textureQuality: TextureQuality.values.firstWhere(
          (e) => e.name == json['textureQuality'],
          orElse: () => TextureQuality.medium,
        ),
        anisotropy: json['anisotropy'] ?? 1,
        mipmapFilter: MipmapFilter.values.firstWhere(
          (e) => e.name == json['mipmapFilter'],
          orElse: () => MipmapFilter.linear,
        ),
        memoryWarningThreshold: json['memoryWarningThreshold'] ?? 512,
        cpuWarningThreshold: json['cpuWarningThreshold'] ?? 0.8,
        gpuWarningThreshold: json['gpuWarningThreshold'] ?? 0.8,
      );
    } catch (error, stackTrace) {
      throw EngineConfigurationError(
        'Failed to parse configuration JSON: $error',
        errorCode: ErrorCode.configParseError,
        data: {'json': json, 'error': error, 'stackTrace': stackTrace},
      );
    }
  }
  
  @override
  String toString() {
    return 'EngineConfig('
        'renderBackend: $renderBackend, '
        'resolution: $resolution, '
        'physicsEnabled: $physicsEnabled, '
        'audioEnabled: $audioEnabled'
        ')';
  }
}

/// Resolution representation
class Resolution {
  final int width;
  final int height;
  
  const Resolution(this.width, this.height);
  
  /// Aspect ratio (width / height)
  double get aspectRatio => width / height;
  
  /// Whether resolution is portrait
  bool get isPortrait => height > width;
  
  /// Whether resolution is landscape
  bool get isLandscape => width > height;
  
  /// Whether resolution is square
  bool get isSquare => width == height;
  
  /// Creates HD resolution (1280x720)
  static const Resolution hd = Resolution(1280, 720);
  
  /// Creates Full HD resolution (1920x1080)
  static const Resolution fullHd = Resolution(1920, 1080);
  
  /// Creates 4K resolution (3840x2160)
  static const Resolution fourK = Resolution(3840, 2160);
  
  /// Creates mobile portrait resolution (1080x1920)
  static const Resolution mobilePortrait = Resolution(1080, 1920);
  
  /// Creates mobile landscape resolution (1920x1080)
  static const Resolution mobileLandscape = Resolution(1920, 1080);
  
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Resolution &&
          runtimeType == other.runtimeType &&
          width == other.width &&
          height == other.height;
  
  @override
  int get hashCode => width.hashCode ^ height.hashCode;
  
  @override
  String toString() => '${width}x$height';
}

/// Render backend enumeration
enum RenderBackend {
  /// No rendering (headless mode)
  none,
  
  /// WebGL 1.0 rendering
  webgl,
  
  /// WebGL 2.0 rendering
  webgl2,
  
  /// WebGPU rendering
  webgpu,
  
  /// Software rendering (fallback)
  software,
  
  /// CSS 3D rendering
  css3d,
  
  /// SVG rendering
  svg,
}

/// Physics backend enumeration
enum PhysicsBackend {
  /// No physics
  none,
  
  /// Built-in physics engine
  builtin,
  
  /// Ammo.js physics (WASM)
  ammo,
  
  /// Bullet physics (WASM)
  bullet,
  
  /// Cannon.js physics
  cannon,
  
  /// PhysX physics
  physx,
}

/// UI render mode enumeration
enum UIRenderMode {
  /// Canvas 2D rendering
  canvas2d,
  
  /// WebGL rendering
  webgl,
  
  /// DOM-based rendering
  dom,
  
  /// SVG rendering
  svg,
}

/// Power preference for WebGL
enum PowerPreference {
  /// Default power preference
  defaultPreference,
  
  /// High performance
  highPerformance,
  
  /// Low power consumption
  lowPower,
}

/// Shadow quality levels
enum ShadowQuality {
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

/// Texture quality levels
enum TextureQuality {
  /// Low texture quality
  low,
  
  /// Medium texture quality
  medium,
  
  /// High texture quality
  high,
  
  /// Ultra texture quality
  ultra,
}

/// Mipmap filter modes
enum MipmapFilter {
  /// No mipmapping
  none,
  
  /// Nearest neighbor filtering
  nearest,
  
  /// Linear filtering
  linear,
}

/// Plugin descriptor for configuration
class PluginDescriptor {
  final String id;
  final String name;
  final String version;
  final Map<String, dynamic>? config;
  final bool enabled;
  
  const PluginDescriptor({
    required this.id,
    required this.name,
    required this.version,
    this.config,
    this.enabled = true,
  });
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'version': version,
      'config': config,
      'enabled': enabled,
    };
  }
  
  factory PluginDescriptor.fromJson(Map<String, dynamic> json) {
    return PluginDescriptor(
      id: json['id'],
      name: json['name'],
      version: json['version'],
      config: json['config'],
      enabled: json['enabled'] ?? true,
    );
  }
}

/// Engine configuration builder for fluent configuration
class EngineConfigBuilder {
  RenderBackend _renderBackend = RenderBackend.webgl;
  Resolution _resolution = const Resolution(1280, 720);
  bool _renderEnabled = true;
  bool _physicsEnabled = false;
  PhysicsBackend _physicsBackend = PhysicsBackend.bullet;
  PhysicsConfig _physicsConfig = PhysicsConfig.defaultConfig();
  bool _audioEnabled = true;
  int _audioSampleRate = 44100;
  int _audioChannels = 2;
  bool _uiEnabled = true;
  UIRenderMode _uiRenderMode = UIRenderMode.canvas2d;
  Resolution _uiResolution = const Resolution(1280, 720);
  final List<PluginDescriptor> _plugins = [];
  int _maxTextureSize = 4096;
  int _maxGeometryBuffers = 1024;
  int _maxShaderPrograms = 256;
  bool _antialias = true;
  bool _alpha = true;
  bool _depth = true;
  bool _stencil = false;
  bool _preserveDrawingBuffer = false;
  PowerPreference _powerPreference = PowerPreference.defaultPreference;
  Vector3 _gravity = Vector3(0, -9.81, 0);
  ShadowQuality _shadowQuality = ShadowQuality.medium;
  TextureQuality _textureQuality = TextureQuality.medium;
  int _anisotropy = 1;
  MipmapFilter _mipmapFilter = MipmapFilter.linear;
  int _memoryWarningThreshold = 512;
  double _cpuWarningThreshold = 0.8;
  double _gpuWarningThreshold = 0.8;
  
  /// Sets the render backend
  EngineConfigBuilder setRenderBackend(RenderBackend backend) {
    _renderBackend = backend;
    return this;
  }
  
  /// Sets the resolution
  EngineConfigBuilder setResolution(int width, int height) {
    _resolution = Resolution(width, height);
    return this;
  }
  
  /// Enables or disables rendering
  EngineConfigBuilder setRenderEnabled(bool enabled) {
    _renderEnabled = enabled;
    return this;
  }
  
  /// Enables or disables physics
  EngineConfigBuilder setPhysicsEnabled(bool enabled) {
    _physicsEnabled = enabled;
    return this;
  }
  
  /// Sets the physics backend
  EngineConfigBuilder setPhysicsBackend(PhysicsBackend backend) {
    _physicsBackend = backend;
    return this;
  }
  
  /// Sets the physics configuration
  EngineConfigBuilder setPhysicsConfig(PhysicsConfig config) {
    _physicsConfig = config;
    return this;
  }
  
  /// Enables or disables audio
  EngineConfigBuilder setAudioEnabled(bool enabled) {
    _audioEnabled = enabled;
    return this;
  }
  
  /// Sets audio sample rate
  EngineConfigBuilder setAudioSampleRate(int sampleRate) {
    _audioSampleRate = sampleRate;
    return this;
  }
  
  /// Sets audio channel count
  EngineConfigBuilder setAudioChannels(int channels) {
    _audioChannels = channels;
    return this;
  }
  
  /// Enables or disables UI
  EngineConfigBuilder setUIEnabled(bool enabled) {
    _uiEnabled = enabled;
    return this;
  }
  
  /// Sets UI render mode
  EngineConfigBuilder setUIRenderMode(UIRenderMode mode) {
    _uiRenderMode = mode;
    return this;
  }
  
  /// Sets UI resolution
  EngineConfigBuilder setUIResolution(int width, int height) {
    _uiResolution = Resolution(width, height);
    return this;
  }
  
  /// Adds a plugin
  EngineConfigBuilder addPlugin(PluginDescriptor plugin) {
    _plugins.add(plugin);
    return this;
  }
  
  /// Sets maximum texture size
  EngineConfigBuilder setMaxTextureSize(int size) {
    _maxTextureSize = size;
    return this;
  }
  
  /// Enables or disables antialiasing
  EngineConfigBuilder setAntialias(bool enabled) {
    _antialias = enabled;
    return this;
  }
  
  /// Sets gravity vector
  EngineConfigBuilder setGravity(double x, double y, double z) {
    _gravity = Vector3(x, y, z);
    return this;
  }
  
  /// Sets shadow quality
  EngineConfigBuilder setShadowQuality(ShadowQuality quality) {
    _shadowQuality = quality;
    return this;
  }
  
  /// Sets texture quality
  EngineConfigBuilder setTextureQuality(TextureQuality quality) {
    _textureQuality = quality;
    return this;
  }
  
  /// Sets anisotropy level
  EngineConfigBuilder setAnisotropy(int level) {
    _anisotropy = level;
    return this;
  }
  
  /// Builds the final EngineConfig
  EngineConfig build() {
    return EngineConfig(
      renderBackend: _renderBackend,
      resolution: _resolution,
      renderEnabled: _renderEnabled,
      physicsEnabled: _physicsEnabled,
      physicsBackend: _physicsBackend,
      physicsConfig: _physicsConfig,
      audioEnabled: _audioEnabled,
      audioSampleRate: _audioSampleRate,
      audioChannels: _audioChannels,
      uiEnabled: _uiEnabled,
      uiRenderMode: _uiRenderMode,
      uiResolution: _uiResolution,
      plugins: _plugins,
      maxTextureSize: _maxTextureSize,
      maxGeometryBuffers: _maxGeometryBuffers,
      maxShaderPrograms: _maxShaderPrograms,
      antialias: _antialias,
      alpha: _alpha,
      depth: _depth,
      stencil: _stencil,
      preserveDrawingBuffer: _preserveDrawingBuffer,
      powerPreference: _powerPreference,
      gravity: _gravity,
      shadowQuality: _shadowQuality,
      textureQuality: _textureQuality,
      anisotropy: _anisotropy,
      mipmapFilter: _mipmapFilter,
      memoryWarningThreshold: _memoryWarningThreshold,
      cpuWarningThreshold: _cpuWarningThreshold,
      gpuWarningThreshold: _gpuWarningThreshold,
    );
  }
}
