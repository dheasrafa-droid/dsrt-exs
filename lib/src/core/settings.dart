/// DSRT Engine - Engine Settings
/// Runtime settings that can be changed dynamically.
library dsrt_engine.src.core.settings;

import 'package:meta/meta.dart';
import '../utils/observable.dart';
import '../utils/validators.dart';

/// Engine runtime settings
class Settings with Observable<Settings> {
  /// Graphics settings
  final GraphicsSettings graphics;
  
  /// Audio settings
  final AudioSettings audio;
  
  /// Input settings
  final InputSettings input;
  
  /// Physics settings
  final PhysicsSettings physics;
  
  /// Debug settings
  final DebugSettings debug;
  
  /// Create engine settings
  Settings({
    GraphicsSettings? graphics,
    AudioSettings? audio,
    InputSettings? input,
    PhysicsSettings? physics,
    DebugSettings? debug,
  }) : 
    graphics = graphics ?? GraphicsSettings(),
    audio = audio ?? AudioSettings(),
    input = input ?? InputSettings(),
    physics = physics ?? PhysicsSettings(),
    debug = debug ?? DebugSettings();
  
  /// Default settings
  factory Settings.defaults() => Settings();
  
  /// Copy with overrides
  Settings copyWith({
    GraphicsSettings? graphics,
    AudioSettings? audio,
    InputSettings? input,
    PhysicsSettings? physics,
    DebugSettings? debug,
  }) {
    return Settings(
      graphics: graphics ?? this.graphics.copy(),
      audio: audio ?? this.audio.copy(),
      input: input ?? this.input.copy(),
      physics: physics ?? this.physics.copy(),
      debug: debug ?? this.debug.copy(),
    );
  }
  
  /// Validate all settings
  bool validate() {
    return graphics.validate() &&
           audio.validate() &&
           input.validate() &&
           physics.validate() &&
           debug.validate();
  }
  
  /// Convert to map
  Map<String, dynamic> toMap() {
    return {
      'graphics': graphics.toMap(),
      'audio': audio.toMap(),
      'input': input.toMap(),
      'physics': physics.toMap(),
      'debug': debug.toMap(),
    };
  }
  
  /// Load from map
  factory Settings.fromMap(Map<String, dynamic> map) {
    return Settings(
      graphics: GraphicsSettings.fromMap(Map<String, dynamic>.from(map['graphics'] as Map)),
      audio: AudioSettings.fromMap(Map<String, dynamic>.from(map['audio'] as Map)),
      input: InputSettings.fromMap(Map<String, dynamic>.from(map['input'] as Map)),
      physics: PhysicsSettings.fromMap(Map<String, dynamic>.from(map['physics'] as Map)),
      debug: DebugSettings.fromMap(Map<String, dynamic>.from(map['debug'] as Map)),
    );
  }
  
  /// Apply settings from another settings object
  void apply(Settings other) {
    graphics.apply(other.graphics);
    audio.apply(other.audio);
    input.apply(other.input);
    physics.apply(other.physics);
    debug.apply(other.debug);
    notifyListeners();
  }
}

/// Graphics settings
class GraphicsSettings with Observable<GraphicsSettings> {
  /// Enable/disable antialiasing
  bool antialiasing;
  
  /// Shadow quality
  ShadowQuality shadowQuality;
  
  /// Texture quality
  TextureQuality textureQuality;
  
  /// Anisotropic filtering level
  int anisotropicFiltering;
  
  /// Maximum anisotropic filtering supported
  static const int maxAnisotropicFiltering = 16;
  
  /// Enable/disable vsync
  bool vsync;
  
  /// Gamma correction factor
  double gammaFactor;
  
  /// Tone mapping type
  ToneMapping toneMapping;
  
  /// Exposure for tone mapping
  double exposure;
  
  /// Enable/disable HDR rendering
  bool hdr;
  
  /// Create graphics settings
  GraphicsSettings({
    this.antialiasing = true,
    this.shadowQuality = ShadowQuality.medium,
    this.textureQuality = TextureQuality.high,
    this.anisotropicFiltering = 4,
    this.vsync = true,
    this.gammaFactor = 2.2,
    this.toneMapping = ToneMapping.accesFilm,
    this.exposure = 1.0,
    this.hdr = false,
  });
  
  /// Copy settings
  GraphicsSettings copy() {
    return GraphicsSettings(
      antialiasing: antialiasing,
      shadowQuality: shadowQuality,
      textureQuality: textureQuality,
      anisotropicFiltering: anisotropicFiltering,
      vsync: vsync,
      gammaFactor: gammaFactor,
      toneMapping: toneMapping,
      exposure: exposure,
      hdr: hdr,
    );
  }
  
  /// Apply settings from another object
  void apply(GraphicsSettings other) {
    antialiasing = other.antialiasing;
    shadowQuality = other.shadowQuality;
    textureQuality = other.textureQuality;
    anisotropicFiltering = other.anisotropicFiltering;
    vsync = other.vsync;
    gammaFactor = other.gammaFactor;
    toneMapping = other.toneMapping;
    exposure = other.exposure;
    hdr = other.hdr;
    notifyListeners();
  }
  
  /// Validate settings
  bool validate() {
    return Validators.isInRange(anisotropicFiltering, 1, maxAnisotropicFiltering) &&
           Validators.isPositive(gammaFactor) &&
           Validators.isPositive(exposure);
  }
  
  /// Convert to map
  Map<String, dynamic> toMap() {
    return {
      'antialiasing': antialiasing,
      'shadowQuality': shadowQuality.index,
      'textureQuality': textureQuality.index,
      'anisotropicFiltering': anisotropicFiltering,
      'vsync': vsync,
      'gammaFactor': gammaFactor,
      'toneMapping': toneMapping.index,
      'exposure': exposure,
      'hdr': hdr,
    };
  }
  
  /// Create from map
  factory GraphicsSettings.fromMap(Map<String, dynamic> map) {
    return GraphicsSettings(
      antialiasing: map['antialiasing'] as bool? ?? true,
      shadowQuality: ShadowQuality.values[map['shadowQuality'] as int? ?? ShadowQuality.medium.index],
      textureQuality: TextureQuality.values[map['textureQuality'] as int? ?? TextureQuality.high.index],
      anisotropicFiltering: map['anisotropicFiltering'] as int? ?? 4,
      vsync: map['vsync'] as bool? ?? true,
      gammaFactor: (map['gammaFactor'] as num?)?.toDouble() ?? 2.2,
      toneMapping: ToneMapping.values[map['toneMapping'] as int? ?? ToneMapping.accesFilm.index],
      exposure: (map['exposure'] as num?)?.toDouble() ?? 1.0,
      hdr: map['hdr'] as bool? ?? false,
    );
  }
}

/// Audio settings
class AudioSettings with Observable<AudioSettings> {
  /// Master volume (0.0 to 1.0)
  double masterVolume;
  
  /// Music volume (0.0 to 1.0)
  double musicVolume;
  
  /// SFX volume (0.0 to 1.0)
  double sfxVolume;
  
  /// Enable/disable audio
  bool enabled;
  
  /// Spatial audio enabled
  bool spatialAudio;
  
  /// Reverb level
  double reverbLevel;
  
  /// Create audio settings
  AudioSettings({
    this.masterVolume = 1.0,
    this.musicVolume = 0.8,
    this.sfxVolume = 1.0,
    this.enabled = true,
    this.spatialAudio = true,
    this.reverbLevel = 0.5,
  });
  
  /// Copy settings
  AudioSettings copy() {
    return AudioSettings(
      masterVolume: masterVolume,
      musicVolume: musicVolume,
      sfxVolume: sfxVolume,
      enabled: enabled,
      spatialAudio: spatialAudio,
      reverbLevel: reverbLevel,
    );
  }
  
  /// Apply settings from another object
  void apply(AudioSettings other) {
    masterVolume = other.masterVolume;
    musicVolume = other.musicVolume;
    sfxVolume = other.sfxVolume;
    enabled = other.enabled;
    spatialAudio = other.spatialAudio;
    reverbLevel = other.reverbLevel;
    notifyListeners();
  }
  
  /// Validate settings
  bool validate() {
    return Validators.isInRange(masterVolume, 0.0, 1.0) &&
           Validators.isInRange(musicVolume, 0.0, 1.0) &&
           Validators.isInRange(sfxVolume, 0.0, 1.0) &&
           Validators.isInRange(reverbLevel, 0.0, 1.0);
  }
  
  /// Convert to map
  Map<String, dynamic> toMap() {
    return {
      'masterVolume': masterVolume,
      'musicVolume': musicVolume,
      'sfxVolume': sfxVolume,
      'enabled': enabled,
      'spatialAudio': spatialAudio,
      'reverbLevel': reverbLevel,
    };
  }
  
  /// Create from map
  factory AudioSettings.fromMap(Map<String, dynamic> map) {
    return AudioSettings(
      masterVolume: (map['masterVolume'] as num?)?.toDouble() ?? 1.0,
      musicVolume: (map['musicVolume'] as num?)?.toDouble() ?? 0.8,
      sfxVolume: (map['sfxVolume'] as num?)?.toDouble() ?? 1.0,
      enabled: map['enabled'] as bool? ?? true,
      spatialAudio: map['spatialAudio'] as bool? ?? true,
      reverbLevel: (map['reverbLevel'] as num?)?.toDouble() ?? 0.5,
    );
  }
}

/// Input settings
class InputSettings with Observable<InputSettings> {
  /// Mouse sensitivity
  double mouseSensitivity;
  
  /// Invert mouse Y axis
  bool invertMouseY;
  
  /// Gamepad deadzone
  double gamepadDeadzone;
  
  /// Enable/disable touch input
  bool touchEnabled;
  
  /// Key repeat delay (ms)
  int keyRepeatDelay;
  
  /// Key repeat rate (ms)
  int keyRepeatRate;
  
  /// Create input settings
  InputSettings({
    this.mouseSensitivity = 1.0,
    this.invertMouseY = false,
    this.gamepadDeadzone = 0.2,
    this.touchEnabled = true,
    this.keyRepeatDelay = 500,
    this.keyRepeatRate = 50,
  });
  
  /// Copy settings
  InputSettings copy() {
    return InputSettings(
      mouseSensitivity: mouseSensitivity,
      invertMouseY: invertMouseY,
      gamepadDeadzone: gamepadDeadzone,
      touchEnabled: touchEnabled,
      keyRepeatDelay: keyRepeatDelay,
      keyRepeatRate: keyRepeatRate,
    );
  }
  
  /// Apply settings from another object
  void apply(InputSettings other) {
    mouseSensitivity = other.mouseSensitivity;
    invertMouseY = other.invertMouseY;
    gamepadDeadzone = other.gamepadDeadzone;
    touchEnabled = other.touchEnabled;
    keyRepeatDelay = other.keyRepeatDelay;
    keyRepeatRate = other.keyRepeatRate;
    notifyListeners();
  }
  
  /// Validate settings
  bool validate() {
    return Validators.isPositive(mouseSensitivity) &&
           Validators.isInRange(gamepadDeadzone, 0.0, 1.0) &&
           Validators.isPositive(keyRepeatDelay) &&
           Validators.isPositive(keyRepeatRate);
  }
  
  /// Convert to map
  Map<String, dynamic> toMap() {
    return {
      'mouseSensitivity': mouseSensitivity,
      'invertMouseY': invertMouseY,
      'gamepadDeadzone': gamepadDeadzone,
      'touchEnabled': touchEnabled,
      'keyRepeatDelay': keyRepeatDelay,
      'keyRepeatRate': keyRepeatRate,
    };
  }
  
  /// Create from map
  factory InputSettings.fromMap(Map<String, dynamic> map) {
    return InputSettings(
      mouseSensitivity: (map['mouseSensitivity'] as num?)?.toDouble() ?? 1.0,
      invertMouseY: map['invertMouseY'] as bool? ?? false,
      gamepadDeadzone: (map['gamepadDeadzone'] as num?)?.toDouble() ?? 0.2,
      touchEnabled: map['touchEnabled'] as bool? ?? true,
      keyRepeatDelay: map['keyRepeatDelay'] as int? ?? 500,
      keyRepeatRate: map['keyRepeatRate'] as int? ?? 50,
    );
  }
}

/// Physics settings
class PhysicsSettings with Observable<PhysicsSettings> {
  /// Enable/disable physics
  bool enabled;
  
  /// Gravity magnitude
  double gravity;
  
  /// Physics sub-steps
  int subSteps;
  
  /// Enable/disable collision detection
  bool collisionDetection;
  
  /// Enable/disable continuous collision detection
  bool continuousCollision;
  
  /// Physics simulation frequency
  double simulationFrequency;
  
  /// Create physics settings
  PhysicsSettings({
    this.enabled = true,
    this.gravity = 9.81,
    this.subSteps = 1,
    this.collisionDetection = true,
    this.continuousCollision = false,
    this.simulationFrequency = 60.0,
  });
  
  /// Copy settings
  PhysicsSettings copy() {
    return PhysicsSettings(
      enabled: enabled,
      gravity: gravity,
      subSteps: subSteps,
      collisionDetection: collisionDetection,
      continuousCollision: continuousCollision,
      simulationFrequency: simulationFrequency,
    );
  }
  
  /// Apply settings from another object
  void apply(PhysicsSettings other) {
    enabled = other.enabled;
    gravity = other.gravity;
    subSteps = other.subSteps;
    collisionDetection = other.collisionDetection;
    continuousCollision = other.continuousCollision;
    simulationFrequency = other.simulationFrequency;
    notifyListeners();
  }
  
  /// Validate settings
  bool validate() {
    return Validators.isPositive(gravity) &&
           Validators.isPositive(subSteps) &&
           Validators.isPositive(simulationFrequency);
  }
  
  /// Convert to map
  Map<String, dynamic> toMap() {
    return {
      'enabled': enabled,
      'gravity': gravity,
      'subSteps': subSteps,
      'collisionDetection': collisionDetection,
      'continuousCollision': continuousCollision,
      'simulationFrequency': simulationFrequency,
    };
  }
  
  /// Create from map
  factory PhysicsSettings.fromMap(Map<String, dynamic> map) {
    return PhysicsSettings(
      enabled: map['enabled'] as bool? ?? true,
      gravity: (map['gravity'] as num?)?.toDouble() ?? 9.81,
      subSteps: map['subSteps'] as int? ?? 1,
      collisionDetection: map['collisionDetection'] as bool? ?? true,
      continuousCollision: map['continuousCollision'] as bool? ?? false,
      simulationFrequency: (map['simulationFrequency'] as num?)?.toDouble() ?? 60.0,
    );
  }
}

/// Debug settings
class DebugSettings with Observable<DebugSettings> {
  /// Enable/disable debug mode
  bool enabled;
  
  /// Show wireframe
  bool showWireframe;
  
  /// Show normals
  bool showNormals;
  
  /// Show bounding boxes
  bool showBoundingBoxes;
  
  /// Show physics shapes
  bool showPhysicsShapes;
  
  /// Show FPS counter
  bool showFPS;
  
  /// Show performance stats
  bool showPerformanceStats;
  
  /// Create debug settings
  DebugSettings({
    this.enabled = false,
    this.showWireframe = false,
    this.showNormals = false,
    this.showBoundingBoxes = false,
    this.showPhysicsShapes = false,
    this.showFPS = false,
    this.showPerformanceStats = false,
  });
  
  /// Copy settings
  DebugSettings copy() {
    return DebugSettings(
      enabled: enabled,
      showWireframe: showWireframe,
      showNormals: showNormals,
      showBoundingBoxes: showBoundingBoxes,
      showPhysicsShapes: showPhysicsShapes,
      showFPS: showFPS,
      showPerformanceStats: showPerformanceStats,
    );
  }
  
  /// Apply settings from another object
  void apply(DebugSettings other) {
    enabled = other.enabled;
    showWireframe = other.showWireframe;
    showNormals = other.showNormals;
    showBoundingBoxes = other.showBoundingBoxes;
    showPhysicsShapes = other.showPhysicsShapes;
    showFPS = other.showFPS;
    showPerformanceStats = other.showPerformanceStats;
    notifyListeners();
  }
  
  /// Validate settings
  bool validate() {
    return true; // All debug settings are valid by default
  }
  
  /// Convert to map
  Map<String, dynamic> toMap() {
    return {
      'enabled': enabled,
      'showWireframe': showWireframe,
      'showNormals': showNormals,
      'showBoundingBoxes': showBoundingBoxes,
      'showPhysicsShapes': showPhysicsShapes,
      'showFPS': showFPS,
      'showPerformanceStats': showPerformanceStats,
    };
  }
  
  /// Create from map
  factory DebugSettings.fromMap(Map<String, dynamic> map) {
    return DebugSettings(
      enabled: map['enabled'] as bool? ?? false,
      showWireframe: map['showWireframe'] as bool? ?? false,
      showNormals: map['showNormals'] as bool? ?? false,
      showBoundingBoxes: map['showBoundingBoxes'] as bool? ?? false,
      showPhysicsShapes: map['showPhysicsShapes'] as bool? ?? false,
      showFPS: map['showFPS'] as bool? ?? false,
      showPerformanceStats: map['showPerformanceStats'] as bool? ?? false,
    );
  }
}

/// Shadow quality levels
enum ShadowQuality {
  off,
  low,
  medium,
  high,
  ultra,
}

/// Texture quality levels
enum TextureQuality {
  low,
  medium,
  high,
  ultra,
}

/// Tone mapping types
enum ToneMapping {
  none,
  linear,
  reinhard,
  cineon,
  accesFilm,
  filmic,
}

/// Observable mixin for settings
mixin Observable<T> {
  final List<void Function(T)> _listeners = [];
  
  /// Add change listener
  void addListener(void Function(T) listener) {
    _listeners.add(listener);
  }
  
  /// Remove change listener
  void removeListener(void Function(T) listener) {
    _listeners.remove(listener);
  }
  
  /// Notify all listeners
  @protected
  void notifyListeners() {
    for (final listener in _listeners) {
      listener(this as T);
    }
  }
}
