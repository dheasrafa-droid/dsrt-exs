/// Engine settings system for DSRT Engine
/// 
/// Provides runtime settings management, quality presets, and
/// user preferences that can be changed at runtime.
/// 
/// [initialSettings]: Initial settings to apply.
/// [persist]: Whether to persist settings to storage.
part of dsrt_engine.core.internal;

/// Engine settings manager
/// 
/// Manages runtime settings and quality presets that affect
/// rendering, physics, audio, and other engine systems.
/// 
/// Example:
/// ```dart
/// final settings = EngineSettings();
/// settings.renderQuality = RenderQuality.high;
/// settings.shadowQuality = ShadowQuality.ultra;
/// settings.apply();
/// ```
class EngineSettings {
  /// Render quality preset
  RenderQuality renderQuality;
  
  /// Shadow quality level
  ShadowQuality shadowQuality;
  
  /// Texture quality level
  TextureQuality textureQuality;
  
  /// Anti-aliasing method
  AntiAliasing antiAliasing;
  
  /// Anisotropic filtering level
  int anisotropy;
  
  /// VSync enabled
  bool vsync;
  
  /// Target frame rate (0 for unlimited)
  double targetFPS;
  
  /// Physics quality level
  PhysicsQuality physicsQuality;
  
  /// Audio quality level
  AudioQuality audioQuality;
  
  /// UI scale factor
  double uiScale;
  
  /// Master volume (0.0 to 1.0)
  double masterVolume;
  
  /// Music volume (0.0 to 1.0)
  double musicVolume;
  
  /// SFX volume (0.0 to 1.0)
  double sfxVolume;
  
  /// Voice volume (0.0 to 1.0)
  double voiceVolume;
  
  /// Ambient volume (0.0 to 1.0)
  double ambientVolume;
  
  /// Language code (ISO 639-1)
  String language;
  
  /// Subtitles enabled
  bool subtitles;
  
  /// Subtitles size
  double subtitleSize;
  
  /// Color blind mode
  ColorBlindMode colorBlindMode;
  
  /// Motion blur enabled
  bool motionBlur;
  
  /// Depth of field enabled
  bool depthOfField;
  
  /// Bloom effect enabled
  bool bloom;
  
  /// Lens flare enabled
  bool lensFlare;
  
  /// Chromatic aberration enabled
  bool chromaticAberration;
  
  /// Vignette effect enabled
  bool vignette;
  
  /// Film grain enabled
  bool filmGrain;
  
  /// Camera shake enabled
  bool cameraShake;
  
  /// Field of view (degrees)
  double fieldOfView;
  
  /// Mouse sensitivity
  double mouseSensitivity;
  
  /// Invert Y axis
  bool invertYAxis;
  
  /// Controller sensitivity
  double controllerSensitivity;
  
  /// Vibration enabled
  bool vibration;
  
  /// Show FPS counter
  bool showFPS;
  
  /// Show performance stats
  bool showStats;
  
  /// Show wireframe
  bool showWireframe;
  
  /// Show bounding boxes
  bool showBoundingBoxes;
  
  /// Show normals
  bool showNormals;
  
  /// Show collision shapes
  bool showCollisionShapes;
  
  /// Show physics debug
  bool showPhysicsDebug;
  
  /// Show UI debug
  bool showUIDebug;
  
  /// Autosave enabled
  bool autosave;
  
  /// Autosave interval (minutes)
  int autosaveInterval;
  
  /// Cloud save enabled
  bool cloudSave;
  
  /// Auto-update enabled
  bool autoUpdate;
  
  /// Telemetry enabled
  bool telemetry;
  
  /// Crash reporting enabled
  bool crashReporting;
  
  /// Storage provider for persistence
  final SettingsStorage? _storage;
  
  /// Settings change listeners
  final List<SettingsListener> _listeners = [];
  
  /// Creates engine settings
  EngineSettings({
    RenderQuality? renderQuality,
    ShadowQuality? shadowQuality,
    TextureQuality? textureQuality,
    AntiAliasing? antiAliasing,
    int? anisotropy,
    bool? vsync,
    double? targetFPS,
    PhysicsQuality? physicsQuality,
    AudioQuality? audioQuality,
    double? uiScale,
    double? masterVolume,
    double? musicVolume,
    double? sfxVolume,
    double? voiceVolume,
    double? ambientVolume,
    String? language,
    bool? subtitles,
    double? subtitleSize,
    ColorBlindMode? colorBlindMode,
    bool? motionBlur,
    bool? depthOfField,
    bool? bloom,
    bool? lensFlare,
    bool? chromaticAberration,
    bool? vignette,
    bool? filmGrain,
    bool? cameraShake,
    double? fieldOfView,
    double? mouseSensitivity,
    bool? invertYAxis,
    double? controllerSensitivity,
    bool? vibration,
    bool? showFPS,
    bool? showStats,
    bool? showWireframe,
    bool? showBoundingBoxes,
    bool? showNormals,
    bool? showCollisionShapes,
    bool? showPhysicsDebug,
    bool? showUIDebug,
    bool? autosave,
    int? autosaveInterval,
    bool? cloudSave,
    bool? autoUpdate,
    bool? telemetry,
    bool? crashReporting,
    SettingsStorage? storage,
  })  : renderQuality = renderQuality ?? RenderQuality.medium,
        shadowQuality = shadowQuality ?? ShadowQuality.medium,
        textureQuality = textureQuality ?? TextureQuality.medium,
        antiAliasing = antiAliasing ?? AntiAliasing.msaa4x,
        anisotropy = anisotropy ?? 4,
        vsync = vsync ?? true,
        targetFPS = targetFPS ?? 60.0,
        physicsQuality = physicsQuality ?? PhysicsQuality.medium,
        audioQuality = audioQuality ?? AudioQuality.high,
        uiScale = uiScale ?? 1.0,
        masterVolume = masterVolume ?? 1.0,
        musicVolume = musicVolume ?? 0.8,
        sfxVolume = sfxVolume ?? 1.0,
        voiceVolume = voiceVolume ?? 1.0,
        ambientVolume = ambientVolume ?? 0.6,
        language = language ?? 'en',
        subtitles = subtitles ?? false,
        subtitleSize = subtitleSize ?? 1.0,
        colorBlindMode = colorBlindMode ?? ColorBlindMode.none,
        motionBlur = motionBlur ?? true,
        depthOfField = depthOfField ?? false,
        bloom = bloom ?? true,
        lensFlare = lensFlare ?? true,
        chromaticAberration = chromaticAberration ?? false,
        vignette = vignette ?? false,
        filmGrain = filmGrain ?? false,
        cameraShake = cameraShake ?? true,
        fieldOfView = fieldOfView ?? 70.0,
        mouseSensitivity = mouseSensitivity ?? 1.0,
        invertYAxis = invertYAxis ?? false,
        controllerSensitivity = controllerSensitivity ?? 1.0,
        vibration = vibration ?? true,
        showFPS = showFPS ?? false,
        showStats = showStats ?? false,
        showWireframe = showWireframe ?? false,
        showBoundingBoxes = showBoundingBoxes ?? false,
        showNormals = showNormals ?? false,
        showCollisionShapes = showCollisionShapes ?? false,
        showPhysicsDebug = showPhysicsDebug ?? false,
        showUIDebug = showUIDebug ?? false,
        autosave = autosave ?? true,
        autosaveInterval = autosaveInterval ?? 5,
        cloudSave = cloudSave ?? true,
        autoUpdate = autoUpdate ?? true,
        telemetry = telemetry ?? true,
        crashReporting = crashReporting ?? true,
        _storage = storage;
  
  /// Creates low quality settings for performance
  factory EngineSettings.lowQuality() {
    return EngineSettings(
      renderQuality: RenderQuality.low,
      shadowQuality: ShadowQuality.low,
      textureQuality: TextureQuality.low,
      antiAliasing: AntiAliasing.none,
      anisotropy: 0,
      vsync: false,
      targetFPS: 30.0,
      physicsQuality: PhysicsQuality.low,
      audioQuality: AudioQuality.low,
      motionBlur: false,
      depthOfField: false,
      bloom: false,
      lensFlare: false,
    );
  }
  
  /// Creates medium quality settings (balanced)
  factory EngineSettings.mediumQuality() {
    return EngineSettings(
      renderQuality: RenderQuality.medium,
      shadowQuality: ShadowQuality.medium,
      textureQuality: TextureQuality.medium,
      antiAliasing: AntiAliasing.msaa2x,
      anisotropy: 4,
      vsync: true,
      targetFPS: 60.0,
      physicsQuality: PhysicsQuality.medium,
      audioQuality: AudioQuality.medium,
    );
  }
  
  /// Creates high quality settings for visual fidelity
  factory EngineSettings.highQuality() {
    return EngineSettings(
      renderQuality: RenderQuality.high,
      shadowQuality: ShadowQuality.high,
      textureQuality: TextureQuality.high,
      antiAliasing: AntiAliasing.msaa4x,
      anisotropy: 8,
      vsync: true,
      targetFPS: 60.0,
      physicsQuality: PhysicsQuality.high,
      audioQuality: AudioQuality.high,
    );
  }
  
  /// Creates ultra quality settings for maximum fidelity
  factory EngineSettings.ultraQuality() {
    return EngineSettings(
      renderQuality: RenderQuality.ultra,
      shadowQuality: ShadowQuality.ultra,
      textureQuality: TextureQuality.ultra,
      antiAliasing: AntiAliasing.msaa8x,
      anisotropy: 16,
      vsync: true,
      targetFPS: 60.0,
      physicsQuality: PhysicsQuality.ultra,
      audioQuality: AudioQuality.ultra,
    );
  }
  
  /// Loads settings from storage
  /// 
  /// Returns: Future that completes when settings are loaded.
  Future<void> load() async {
    if (_storage == null) return;
    
    try {
      final data = await _storage!.load();
      _applyJson(data);
      _notifyListeners(SettingsChangeType.loaded);
    } catch (error) {
      // Use defaults if loading fails
      print('Failed to load settings: $error');
    }
  }
  
  /// Saves settings to storage
  /// 
  /// Returns: Future that completes when settings are saved.
  Future<void> save() async {
    if (_storage == null) return;
    
    try {
      await _storage!.save(toJson());
      _notifyListeners(SettingsChangeType.saved);
    } catch (error) {
      print('Failed to save settings: $error');
    }
  }
  
  /// Applies settings to engine systems
  /// 
  /// This method should be called after changing settings to
  /// apply them to the running engine.
  void apply() {
    _notifyListeners(SettingsChangeType.applied);
  }
  
  /// Resets settings to defaults
  void reset() {
    final defaults = EngineSettings();
    
    renderQuality = defaults.renderQuality;
    shadowQuality = defaults.shadowQuality;
    textureQuality = defaults.textureQuality;
    antiAliasing = defaults.antiAliasing;
    anisotropy = defaults.anisotropy;
    vsync = defaults.vsync;
    targetFPS = defaults.targetFPS;
    physicsQuality = defaults.physicsQuality;
    audioQuality = defaults.audioQuality;
    uiScale = defaults.uiScale;
    masterVolume = defaults.masterVolume;
    musicVolume = defaults.musicVolume;
    sfxVolume = defaults.sfxVolume;
    voiceVolume = defaults.voiceVolume;
    ambientVolume = defaults.ambientVolume;
    language = defaults.language;
    subtitles = defaults.subtitles;
    subtitleSize = defaults.subtitleSize;
    colorBlindMode = defaults.colorBlindMode;
    motionBlur = defaults.motionBlur;
    depthOfField = defaults.depthOfField;
    bloom = defaults.bloom;
    lensFlare = defaults.lensFlare;
    chromaticAberration = defaults.chromaticAberration;
    vignette = defaults.vignette;
    filmGrain = defaults.filmGrain;
    cameraShake = defaults.cameraShake;
    fieldOfView = defaults.fieldOfView;
    mouseSensitivity = defaults.mouseSensitivity;
    invertYAxis = defaults.invertYAxis;
    controllerSensitivity = defaults.controllerSensitivity;
    vibration = defaults.vibration;
    showFPS = defaults.showFPS;
    showStats = defaults.showStats;
    showWireframe = defaults.showWireframe;
    showBoundingBoxes = defaults.showBoundingBoxes;
    showNormals = defaults.showNormals;
    showCollisionShapes = defaults.showCollisionShapes;
    showPhysicsDebug = defaults.showPhysicsDebug;
    showUIDebug = defaults.showUIDebug;
    autosave = defaults.autosave;
    autosaveInterval = defaults.autosaveInterval;
    cloudSave = defaults.cloudSave;
    autoUpdate = defaults.autoUpdate;
    telemetry = defaults.telemetry;
    crashReporting = defaults.crashReporting;
    
    _notifyListeners(SettingsChangeType.reset);
  }
  
  /// Adds a settings change listener
  void addListener(SettingsListener listener) {
    _listeners.add(listener);
  }
  
  /// Removes a settings change listener
  void removeListener(SettingsListener listener) {
    _listeners.remove(listener);
  }
  
  /// Converts settings to JSON
  Map<String, dynamic> toJson() {
    return {
      'renderQuality': renderQuality.name,
      'shadowQuality': shadowQuality.name,
      'textureQuality': textureQuality.name,
      'antiAliasing': antiAliasing.name,
      'anisotropy': anisotropy,
      'vsync': vsync,
      'targetFPS': targetFPS,
      'physicsQuality': physicsQuality.name,
      'audioQuality': audioQuality.name,
      'uiScale': uiScale,
      'masterVolume': masterVolume,
      'musicVolume': musicVolume,
      'sfxVolume': sfxVolume,
      'voiceVolume': voiceVolume,
      'ambientVolume': ambientVolume,
      'language': language,
      'subtitles': subtitles,
      'subtitleSize': subtitleSize,
      'colorBlindMode': colorBlindMode.name,
      'motionBlur': motionBlur,
      'depthOfField': depthOfField,
      'bloom': bloom,
      'lensFlare': lensFlare,
      'chromaticAberration': chromaticAberration,
      'vignette': vignette,
      'filmGrain': filmGrain,
      'cameraShake': cameraShake,
      'fieldOfView': fieldOfView,
      'mouseSensitivity': mouseSensitivity,
      'invertYAxis': invertYAxis,
      'controllerSensitivity': controllerSensitivity,
      'vibration': vibration,
      'showFPS': showFPS,
      'showStats': showStats,
      'showWireframe': showWireframe,
      'showBoundingBoxes': showBoundingBoxes,
      'showNormals': showNormals,
      'showCollisionShapes': showCollisionShapes,
      'showPhysicsDebug': showPhysicsDebug,
      'showUIDebug': showUIDebug,
      'autosave': autosave,
      'autosaveInterval': autosaveInterval,
      'cloudSave': cloudSave,
      'autoUpdate': autoUpdate,
      'telemetry': telemetry,
      'crashReporting': crashReporting,
    };
  }
  
  /// Applies JSON data to settings
  void _applyJson(Map<String, dynamic> json) {
    try {
      renderQuality = RenderQuality.values.firstWhere(
        (e) => e.name == json['renderQuality'],
        orElse: () => RenderQuality.medium,
      );
      
      shadowQuality = ShadowQuality.values.firstWhere(
        (e) => e.name == json['shadowQuality'],
        orElse: () => ShadowQuality.medium,
      );
      
      textureQuality = TextureQuality.values.firstWhere(
        (e) => e.name == json['textureQuality'],
        orElse: () => TextureQuality.medium,
      );
      
      antiAliasing = AntiAliasing.values.firstWhere(
        (e) => e.name == json['antiAliasing'],
        orElse: () => AntiAliasing.msaa4x,
      );
      
      anisotropy = json['anisotropy'] as int? ?? 4;
      vsync = json['vsync'] as bool? ?? true;
      targetFPS = json['targetFPS'] as double? ?? 60.0;
      
      physicsQuality = PhysicsQuality.values.firstWhere(
        (e) => e.name == json['physicsQuality'],
        orElse: () => PhysicsQuality.medium,
      );
      
      audioQuality = AudioQuality.values.firstWhere(
        (e) => e.name == json['audioQuality'],
        orElse: () => AudioQuality.high,
      );
      
      uiScale = json['uiScale'] as double? ?? 1.0;
      masterVolume = json['masterVolume'] as double? ?? 1.0;
      musicVolume = json['musicVolume'] as double? ?? 0.8;
      sfxVolume = json['sfxVolume'] as double? ?? 1.0;
      voiceVolume = json['voiceVolume'] as double? ?? 1.0;
      ambientVolume = json['ambientVolume'] as double? ?? 0.6;
      language = json['language'] as String? ?? 'en';
      subtitles = json['subtitles'] as bool? ?? false;
      subtitleSize = json['subtitleSize'] as double? ?? 1.0;
      
      colorBlindMode = ColorBlindMode.values.firstWhere(
        (e) => e.name == json['colorBlindMode'],
        orElse: () => ColorBlindMode.none,
      );
      
      motionBlur = json['motionBlur'] as bool? ?? true;
      depthOfField = json['depthOfField'] as bool? ?? false;
      bloom = json['bloom'] as bool? ?? true;
      lensFlare = json['lensFlare'] as bool? ?? true;
      chromaticAberration = json['chromaticAberration'] as bool? ?? false;
      vignette = json['vignette'] as bool? ?? false;
      filmGrain = json['filmGrain'] as bool? ?? false;
      cameraShake = json['cameraShake'] as bool? ?? true;
      fieldOfView = json['fieldOfView'] as double? ?? 70.0;
      mouseSensitivity = json['mouseSensitivity'] as double? ?? 1.0;
      invertYAxis = json['invertYAxis'] as bool? ?? false;
      controllerSensitivity = json['controllerSensitivity'] as double? ?? 1.0;
      vibration = json['vibration'] as bool? ?? true;
      showFPS = json['showFPS'] as bool? ?? false;
      showStats = json['showStats'] as bool? ?? false;
      showWireframe = json['showWireframe'] as bool? ?? false;
      showBoundingBoxes = json['showBoundingBoxes'] as bool? ?? false;
      showNormals = json['showNormals'] as bool? ?? false;
      showCollisionShapes = json['showCollisionShapes'] as bool? ?? false;
      showPhysicsDebug = json['showPhysicsDebug'] as bool? ?? false;
      showUIDebug = json['showUIDebug'] as bool? ?? false;
      autosave = json['autosave'] as bool? ?? true;
      autosaveInterval = json['autosaveInterval'] as int? ?? 5;
      cloudSave = json['cloudSave'] as bool? ?? true;
      autoUpdate = json['autoUpdate'] as bool? ?? true;
      telemetry = json['telemetry'] as bool? ?? true;
      crashReporting = json['crashReporting'] as bool? ?? true;
      
    } catch (error) {
      print('Failed to parse settings JSON: $error');
    }
  }
  
  /// Notifies listeners of settings changes
  void _notifyListeners(SettingsChangeType type) {
    for (final listener in _listeners) {
      listener(this, type);
    }
  }
}

/// Render quality presets
enum RenderQuality {
  /// Lowest quality, maximum performance
  veryLow,
  
  /// Low quality, high performance
  low,
  
  /// Medium quality, balanced performance
  medium,
  
  /// High quality, moderate performance
  high,
  
  /// Highest quality, lower performance
  ultra,
  
  /// Custom quality settings
  custom,
}

/// Anti-aliasing methods
enum AntiAliasing {
  /// No anti-aliasing
  none,
  
  /// Fast approximate anti-aliasing (FXAA)
  fxaa,
  
  /// Multisample anti-aliasing 2x
  msaa2x,
  
  /// Multisample anti-aliasing 4x
  msaa4x,
  
  /// Multisample anti-aliasing 8x
  msaa8x,
  
  /// Temporal anti-aliasing (TAA)
  taa,
  
  /// Supersampling anti-aliasing (SSAA)
  ssaa,
}

/// Physics quality levels
enum PhysicsQuality {
  /// Simplified physics, maximum performance
  low,
  
  /// Standard physics, balanced performance
  medium,
  
  /// High-fidelity physics, lower performance
  high,
  
  /// Highest fidelity physics, lowest performance
  ultra,
}

/// Audio quality levels
enum AudioQuality {
  /// Low quality, maximum performance
  low,
  
  /// Medium quality, balanced performance
  medium,
  
  /// High quality, lower performance
  high,
  
  /// Highest quality, lowest performance
  ultra,
}

/// Color blind modes
enum ColorBlindMode {
  /// No color correction
  none,
  
  /// Protanopia (red-blind)
  protanopia,
  
  /// Deuteranopia (green-blind)
  deuteranopia,
  
  /// Tritanopia (blue-blind)
  tritanopia,
  
  /// Achromatopsia (monochromacy)
  achromatopsia,
}

/// Settings change types
enum SettingsChangeType {
  /// Settings were loaded from storage
  loaded,
  
  /// Settings were saved to storage
  saved,
  
  /// Settings were applied to engine
  applied,
  
  /// Settings were reset to defaults
  reset,
  
  /// Individual setting was changed
  changed,
}

/// Settings change listener callback
typedef SettingsListener = void Function(
  EngineSettings settings,
  SettingsChangeType changeType,
);

/// Storage interface for settings persistence
abstract class SettingsStorage {
  /// Loads settings from storage
  Future<Map<String, dynamic>> load();
  
  /// Saves settings to storage
  Future<void> save(Map<String, dynamic> settings);
}

/// Local storage implementation
class LocalStorageSettings extends SettingsStorage {
  final String _key;
  
  LocalStorageSettings({String key = 'dsrt_engine_settings'}) : _key = key;
  
  @override
  Future<Map<String, dynamic>> load() async {
    // Implementation depends on platform
    // For web: window.localStorage
    // For Flutter: shared_preferences
    // For server: file system
    return {};
  }
  
  @override
  Future<void> save(Map<String, dynamic> settings) async {
    // Implementation depends on platform
  }
}
