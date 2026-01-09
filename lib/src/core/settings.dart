import 'dart:convert';
import 'dart:io';

/// Internal settings management system for DSRT Engine.
/// 
/// This class manages user settings and preferences, providing persistence,
/// validation, and change notification for all configurable user options.
/// 
/// @internal This class is for internal DSRT Engine use only.
class _Settings {
  /// Current settings version for migration.
  static final int _settingsVersion = 2;
  
  /// Storage key for persistence.
  final String _storageKey = 'dsrt_engine_settings_v$_settingsVersion';

  /// Default settings values.
  static final Map<String, dynamic> _defaultSettings = {
    // Graphics settings
    'graphics': {
      'resolution': 'auto',
      'displayMode': 'windowed',
      'vsync': true,
      'frameRateLimit': 0, // 0 = unlimited
      'brightness': 1.0,
      'contrast': 1.0,
      'saturation': 1.0,
      'gamma': 2.2,
      'hdr': false,
      'antiAliasing': 'msaa',
      'textureQuality': 'high',
      'shadowQuality': 'high',
      'lightingQuality': 'high',
      'postProcessing': true,
      'ambientOcclusion': true,
      'depthOfField': true,
      'motionBlur': true,
      'bloom': true,
      'vignette': true,
      'chromaticAberration': false,
      'filmGrain': false,
      'lensFlare': true,
      'colorGrading': true,
    },

    // Controls settings
    'controls': {
      'mouseSensitivity': 1.0,
      'mouseInvertX': false,
      'mouseInvertY': false,
      'mouseAcceleration': false,
      'gamepadSensitivity': 1.0,
      'gamepadInvertX': false,
      'gamepadInvertY': false,
      'gamepadDeadzone': 0.15,
      'keyboardLayout': 'qwerty',
      'controlScheme': 'standard',
      'autoAim': true,
      'aimAssist': true,
      'vibration': true,
      'rumbleIntensity': 1.0,
    },

    // Audio settings
    'audio': {
      'masterVolume': 1.0,
      'musicVolume': 0.8,
      'sfxVolume': 1.0,
      'voiceVolume': 1.0,
      'ambientVolume': 0.7,
      'uiVolume': 0.6,
      'mute': false,
      'outputDevice': 'default',
      'spatialAudio': true,
      'hrtfEnabled': true,
      'dynamicRange': 'high',
      'compression': false,
      'sampleRate': 44100,
      'bitDepth': 16,
    },

    // Gameplay settings
    'gameplay': {
      'difficulty': 'normal',
      'tutorials': true,
      'hints': true,
      'subtitles': true,
      'subtitleSize': 'medium',
      'language': 'english',
      'units': 'metric',
      'timeFormat': '24h',
      'dateFormat': 'dd/mm/yyyy',
      'currency': 'usd',
      'autoSave': true,
      'autoSaveInterval': 300, // seconds
      'quickSaveSlots': 10,
      'permaDeath': false,
      'ironmanMode': false,
    },

    // Interface settings
    'interface': {
      'uiScale': 1.0,
      'uiOpacity': 1.0,
      'fontSize': 'medium',
      'fontStyle': 'default',
      'colorBlindMode': 'none',
      'highContrast': false,
      'showFps': false,
      'showPing': false,
      'showCoordinates': false,
      'showMinimap': true,
      'showCompass': true,
      'showHud': true,
      'hudPosition': 'bottom',
      'crosshair': 'default',
      'crosshairColor': 0xffffff,
      'crosshairSize': 1.0,
      'notifications': true,
      'notificationDuration': 5.0,
      'tooltips': true,
      'tooltipDelay': 0.5,
    },

    // Accessibility settings
    'accessibility': {
      'textToSpeech': false,
      'speechToText': false,
      'closedCaptions': true,
      'audioDescriptions': false,
      'highVisibilityMode': false,
      'reducedMotion': false,
      'colorBlindCorrection': 'none',
      'dyslexiaFont': false,
      'buttonRemapping': false,
      'oneHandedMode': false,
      'eyeTracking': false,
      'headTracking': false,
      'assistiveTouch': false,
      'screenReader': false,
      'magnifier': false,
    },

    // Network settings
    'network': {
      'region': 'auto',
      'matchmakingPriority': 'balanced',
      'crossplay': true,
      'voiceChat': true,
      'voiceActivation': true,
      'voiceActivationThreshold': 0.5,
      'pushToTalk': false,
      'pushToTalkKey': 'v',
      'voiceVolume': 1.0,
      'microphoneVolume': 1.0,
      'latency': 'auto',
      'bandwidth': 'auto',
      'packetLoss': 'auto',
      'natType': 'auto',
      'upnp': true,
      'portForwarding': false,
      'dedicatedServer': false,
    },

    // System settings
    'system': {
      'autoUpdate': true,
      'betaUpdates': false,
      'analytics': true,
      'crashReports': true,
      'telemetry': true,
      'saveLocation': 'default',
      'cacheLocation': 'default',
      'tempLocation': 'default',
      'maxCacheSize': 1024, // MB
      'autoCleanup': true,
      'cleanupInterval': 7, // days
      'backupSaves': true,
      'backupInterval': 1, // days
      'maxBackups': 10,
      'powerSaving': false,
      'performanceMode': 'balanced',
      'priority': 'normal',
      'affinity': 'all',
    },
  };

  /// Graphics presets for quick configuration.
  static final Map<String, Map<String, dynamic>> _graphicsPresets = {
    'low': {
      'graphics.resolution': '1080p',
      'graphics.textureQuality': 'low',
      'graphics.shadowQuality': 'low',
      'graphics.lightingQuality': 'low',
      'graphics.antiAliasing': 'none',
      'graphics.postProcessing': false,
      'graphics.ambientOcclusion': false,
      'graphics.depthOfField': false,
      'graphics.motionBlur': false,
      'graphics.bloom': false,
      'graphics.lensFlare': false,
    },
    'medium': {
      'graphics.resolution': '1080p',
      'graphics.textureQuality': 'medium',
      'graphics.shadowQuality': 'medium',
      'graphics.lightingQuality': 'medium',
      'graphics.antiAliasing': 'fxaa',
      'graphics.postProcessing': true,
      'graphics.ambientOcclusion': true,
      'graphics.depthOfField': false,
      'graphics.motionBlur': false,
      'graphics.bloom': true,
      'graphics.lensFlare': true,
    },
    'high': {
      'graphics.resolution': '1440p',
      'graphics.textureQuality': 'high',
      'graphics.shadowQuality': 'high',
      'graphics.lightingQuality': 'high',
      'graphics.antiAliasing': 'msaa',
      'graphics.postProcessing': true,
      'graphics.ambientOcclusion': true,
      'graphics.depthOfField': true,
      'graphics.motionBlur': true,
      'graphics.bloom': true,
      'graphics.lensFlare': true,
    },
    'ultra': {
      'graphics.resolution': '4k',
      'graphics.textureQuality': 'ultra',
      'graphics.shadowQuality': 'ultra',
      'graphics.lightingQuality': 'ultra',
      'graphics.antiAliasing': 'smaa',
      'graphics.postProcessing': true,
      'graphics.ambientOcclusion': true,
      'graphics.depthOfField': true,
      'graphics.motionBlur': true,
      'graphics.bloom': true,
      'graphics.lensFlare': true,
      'graphics.hdr': true,
    },
  };

  /// Setting definitions with metadata.
  final Map<String, _SettingDefinition> _settingDefinitions = {};

  /// Current settings values.
  final Map<String, dynamic> _settings = {};

  /// Settings change listeners.
  final Map<String, List<void Function(dynamic, dynamic)>> _listeners = {};

  /// Global change listeners.
  final List<void Function(String, dynamic, dynamic)> _globalListeners = [];

  /// Whether settings have been loaded from storage.
  bool _loaded = false;

  /// Whether settings have unsaved changes.
  bool _dirty = false;

  /// Settings storage directory.
  String _storageDir = '';

  /// Setting change event type.
  enum _SettingChangeType { added, modified, removed, reset }

  /// Setting definition class.
  class _SettingDefinition {
    final String path;
    final String name;
    final String description;
    final String category;
    final dynamic min;
    final dynamic max;
    final List<dynamic> options;
    final dynamic defaultValue;
    final bool requiresRestart;
    final bool isSensitive;

    _SettingDefinition({
      required this.path,
      required this.name,
      required this.description,
      required this.category,
      this.min,
      this.max,
      this.options = const [],
      required this.defaultValue,
      this.requiresRestart = false,
      this.isSensitive = false,
    });

    /// Validates a value against this setting definition.
    bool validate(dynamic value) {
      if (value == null) return false;
      
      // Check type
      if (defaultValue != null) {
        if (value.runtimeType != defaultValue.runtimeType) {
          return false;
        }
      }
      
      // Check min/max for numeric values
      if (min != null && value is num && value < min) {
        return false;
      }
      if (max != null && value is num && value > max) {
        return false;
      }
      
      // Check allowed options
      if (options.isNotEmpty && !options.contains(value)) {
        return false;
      }
      
      return true;
    }
  }

  /// Setting constraint for validation.
  class _SettingConstraint {
    final dynamic min;
    final dynamic max;
    final List<dynamic> allowedValues;
    final RegExp? pattern;
    final Type expectedType;
    
    const _SettingConstraint({
      this.min,
      this.max,
      this.allowedValues = const [],
      this.pattern,
      required this.expectedType,
    });
    
    bool validate(dynamic value) {
      if (value == null) return false;
      
      // Check type
      if (value.runtimeType != expectedType) {
        return false;
      }
      
      // Check min/max for numeric values
      if (min != null && value is num && value < min) {
        return false;
      }
      if (max != null && value is num && value > max) {
        return false;
      }
      
      // Check allowed values
      if (allowedValues.isNotEmpty && !allowedValues.contains(value)) {
        return false;
      }
      
      // Check pattern for strings
      if (pattern != null && value is String && !pattern!.hasMatch(value)) {
        return false;
      }
      
      return true;
    }
  }

  /// Settings validators.
  final Map<String, _SettingConstraint> _validators = {};

  /// Default constructor for internal settings manager.
  _Settings() {
    _initializeSettingDefinitions();
    _initializeValidators();
    _initializeStorageDir();
    _loadSettings();
  }

  /// Initializes setting definitions.
  void _initializeSettingDefinitions() {
    // Graphics settings
    _settingDefinitions['graphics.resolution'] = _SettingDefinition(
      path: 'graphics.resolution',
      name: 'Resolution',
      description: 'Game rendering resolution',
      category: 'Graphics',
      options: ['auto', '720p', '1080p', '1440p', '4k', '8k'],
      defaultValue: 'auto',
      requiresRestart: true,
    );
    
    _settingDefinitions['graphics.displayMode'] = _SettingDefinition(
      path: 'graphics.displayMode',
      name: 'Display Mode',
      description: 'Window display mode',
      category: 'Graphics',
      options: ['windowed', 'borderless', 'fullscreen'],
      defaultValue: 'windowed',
      requiresRestart: true,
    );
    
    // Add more definitions as needed...
  }

  /// Initializes settings validators.
  void _initializeValidators() {
    // Graphics validators
    _validators['graphics.resolution'] = _SettingConstraint(
      allowedValues: ['auto', '720p', '1080p', '1440p', '4k', '8k'],
      expectedType: String,
    );
    
    _validators['graphics.displayMode'] = _SettingConstraint(
      allowedValues: ['windowed', 'borderless', 'fullscreen'],
      expectedType: String,
    );
    
    _validators['graphics.vsync'] = _SettingConstraint(
      expectedType: bool,
    );
    
    _validators['graphics.frameRateLimit'] = _SettingConstraint(
      min: 0,
      max: 1000,
      expectedType: int,
    );
    
    _validators['graphics.brightness'] = _SettingConstraint(
      min: 0.0,
      max: 2.0,
      expectedType: double,
    );
    
    _validators['graphics.contrast'] = _SettingConstraint(
      min: 0.0,
      max: 2.0,
      expectedType: double,
    );
    
    _validators['graphics.saturation'] = _SettingConstraint(
      min: 0.0,
      max: 2.0,
      expectedType: double,
    );
    
    _validators['graphics.gamma'] = _SettingConstraint(
      min: 1.0,
      max: 3.0,
      expectedType: double,
    );
    
    _validators['graphics.hdr'] = _SettingConstraint(
      expectedType: bool,
    );
    
    _validators['graphics.antiAliasing'] = _SettingConstraint(
      allowedValues: ['none', 'fxaa', 'msaa', 'smaa', 'taa'],
      expectedType: String,
    );
    
    _validators['graphics.textureQuality'] = _SettingConstraint(
      allowedValues: ['low', 'medium', 'high', 'ultra'],
      expectedType: String,
    );
    
    _validators['graphics.shadowQuality'] = _SettingConstraint(
      allowedValues: ['low', 'medium', 'high', 'ultra'],
      expectedType: String,
    );
    
    _validators['graphics.lightingQuality'] = _SettingConstraint(
      allowedValues: ['low', 'medium', 'high', 'ultra'],
      expectedType: String,
    );
    
    _validators['graphics.postProcessing'] = _SettingConstraint(
      expectedType: bool,
    );
    
    _validators['graphics.ambientOcclusion'] = _SettingConstraint(
      expectedType: bool,
    );
    
    _validators['graphics.depthOfField'] = _SettingConstraint(
      expectedType: bool,
    );
    
    _validators['graphics.motionBlur'] = _SettingConstraint(
      expectedType: bool,
    );
    
    _validators['graphics.bloom'] = _SettingConstraint(
      expectedType: bool,
    );
    
    _validators['graphics.vignette'] = _SettingConstraint(
      expectedType: bool,
    );
    
    _validators['graphics.chromaticAberration'] = _SettingConstraint(
      expectedType: bool,
    );
    
    _validators['graphics.filmGrain'] = _SettingConstraint(
      expectedType: bool,
    );
    
    _validators['graphics.lensFlare'] = _SettingConstraint(
      expectedType: bool,
    );
    
    _validators['graphics.colorGrading'] = _SettingConstraint(
      expectedType: bool,
    );

    // Controls validators
    _validators['controls.mouseSensitivity'] = _SettingConstraint(
      min: 0.1,
      max: 5.0,
      expectedType: double,
    );
    
    _validators['controls.mouseInvertX'] = _SettingConstraint(
      expectedType: bool,
    );
    
    _validators['controls.mouseInvertY'] = _SettingConstraint(
      expectedType: bool,
    );
    
    _validators['controls.mouseAcceleration'] = _SettingConstraint(
      expectedType: bool,
    );
    
    _validators['controls.gamepadSensitivity'] = _SettingConstraint(
      min: 0.1,
      max: 5.0,
      expectedType: double,
    );
    
    _validators['controls.gamepadInvertX'] = _SettingConstraint(
      expectedType: bool,
    );
    
    _validators['controls.gamepadInvertY'] = _SettingConstraint(
      expectedType: bool,
    );
    
    _validators['controls.gamepadDeadzone'] = _SettingConstraint(
      min: 0.0,
      max: 1.0,
      expectedType: double,
    );
    
    _validators['controls.keyboardLayout'] = _SettingConstraint(
      allowedValues: ['qwerty', 'azerty', 'qwertz', 'dvorak'],
      expectedType: String,
    );
    
    _validators['controls.controlScheme'] = _SettingConstraint(
      allowedValues: ['standard', 'alternate', 'custom'],
      expectedType: String,
    );
    
    _validators['controls.autoAim'] = _SettingConstraint(
      expectedType: bool,
    );
    
    _validators['controls.aimAssist'] = _SettingConstraint(
      expectedType: bool,
    );
    
    _validators['controls.vibration'] = _SettingConstraint(
      expectedType: bool,
    );
    
    _validators['controls.rumbleIntensity'] = _SettingConstraint(
      min: 0.0,
      max: 1.0,
      expectedType: double,
    );

    // Audio validators
    _validators['audio.masterVolume'] = _SettingConstraint(
      min: 0.0,
      max: 1.0,
      expectedType: double,
    );
    
    _validators['audio.musicVolume'] = _SettingConstraint(
      min: 0.0,
      max: 1.0,
      expectedType: double,
    );
    
    _validators['audio.sfxVolume'] = _SettingConstraint(
      min: 0.0,
      max: 1.0,
      expectedType: double,
    );
    
    _validators['audio.voiceVolume'] = _SettingConstraint(
      min: 0.0,
      max: 1.0,
      expectedType: double,
    );
    
    _validators['audio.ambientVolume'] = _SettingConstraint(
      min: 0.0,
      max: 1.0,
      expectedType: double,
    );
    
    _validators['audio.uiVolume'] = _SettingConstraint(
      min: 0.0,
      max: 1.0,
      expectedType: double,
    );
    
    _validators['audio.mute'] = _SettingConstraint(
      expectedType: bool,
    );
    
    _validators['audio.outputDevice'] = _SettingConstraint(
      expectedType: String,
    );
    
    _validators['audio.spatialAudio'] = _SettingConstraint(
      expectedType: bool,
    );
    
    _validators['audio.hrtfEnabled'] = _SettingConstraint(
      expectedType: bool,
    );
    
    _validators['audio.dynamicRange'] = _SettingConstraint(
      allowedValues: ['low', 'medium', 'high'],
      expectedType: String,
    );
    
    _validators['audio.compression'] = _SettingConstraint(
      expectedType: bool,
    );
    
    _validators['audio.sampleRate'] = _SettingConstraint(
      allowedValues: [22050, 44100, 48000, 96000],
      expectedType: int,
    );
    
    _validators['audio.bitDepth'] = _SettingConstraint(
      allowedValues: [8, 16, 24, 32],
      expectedType: int,
    );

    // Gameplay validators
    _validators['gameplay.difficulty'] = _SettingConstraint(
      allowedValues: ['very_easy', 'easy', 'normal', 'hard', 'very_hard'],
      expectedType: String,
    );
    
    _validators['gameplay.tutorials'] = _SettingConstraint(
      expectedType: bool,
    );
    
    _validators['gameplay.hints'] = _SettingConstraint(
      expectedType: bool,
    );
    
    _validators['gameplay.subtitles'] = _SettingConstraint(
      expectedType: bool,
    );
    
    _validators['gameplay.subtitleSize'] = _SettingConstraint(
      allowedValues: ['small', 'medium', 'large', 'extra_large'],
      expectedType: String,
    );
    
    _validators['gameplay.language'] = _SettingConstraint(
      allowedValues: ['english', 'french', 'german', 'spanish', 'japanese', 'chinese', 'korean', 'russian'],
      expectedType: String,
    );
    
    _validators['gameplay.units'] = _SettingConstraint(
      allowedValues: ['metric', 'imperial'],
      expectedType: String,
    );
    
    _validators['gameplay.timeFormat'] = _SettingConstraint(
      allowedValues: ['12h', '24h'],
      expectedType: String,
    );
    
    _validators['gameplay.dateFormat'] = _SettingConstraint(
      allowedValues: ['dd/mm/yyyy', 'mm/dd/yyyy', 'yyyy/mm/dd'],
      expectedType: String,
    );
    
    _validators['gameplay.currency'] = _SettingConstraint(
      allowedValues: ['usd', 'eur', 'gbp', 'jpy', 'cny'],
      expectedType: String,
    );
    
    _validators['gameplay.autoSave'] = _SettingConstraint(
      expectedType: bool,
    );
    
    _validators['gameplay.autoSaveInterval'] = _SettingConstraint(
      min: 60,
      max: 3600,
      expectedType: int,
    );
    
    _validators['gameplay.quickSaveSlots'] = _SettingConstraint(
      min: 1,
      max: 100,
      expectedType: int,
    );
    
    _validators['gameplay.permaDeath'] = _SettingConstraint(
      expectedType: bool,
    );
    
    _validators['gameplay.ironmanMode'] = _SettingConstraint(
      expectedType: bool,
    );

    // Interface validators
    _validators['interface.uiScale'] = _SettingConstraint(
      min: 0.5,
      max: 2.0,
      expectedType: double,
    );
    
    _validators['interface.uiOpacity'] = _SettingConstraint(
      min: 0.0,
      max: 1.0,
      expectedType: double,
    );
    
    _validators['interface.fontSize'] = _SettingConstraint(
      allowedValues: ['small', 'medium', 'large', 'extra_large'],
      expectedType: String,
    );
    
    _validators['interface.fontStyle'] = _SettingConstraint(
      allowedValues: ['default', 'bold', 'italic', 'monospace'],
      expectedType: String,
    );
    
    _validators['interface.colorBlindMode'] = _SettingConstraint(
      allowedValues: ['none', 'protanopia', 'deuteranopia', 'tritanopia'],
      expectedType: String,
    );
    
    _validators['interface.highContrast'] = _SettingConstraint(
      expectedType: bool,
    );
    
    _validators['interface.showFps'] = _SettingConstraint(
      expectedType: bool,
    );
    
    _validators['interface.showPing'] = _SettingConstraint(
      expectedType: bool,
    );
    
    _validators['interface.showCoordinates'] = _SettingConstraint(
      expectedType: bool,
    );
    
    _validators['interface.showMinimap'] = _SettingConstraint(
      expectedType: bool,
    );
    
    _validators['interface.showCompass'] = _SettingConstraint(
      expectedType: bool,
    );
    
    _validators['interface.showHud'] = _SettingConstraint(
      expectedType: bool,
    );
    
    _validators['interface.hudPosition'] = _SettingConstraint(
      allowedValues: ['top', 'bottom', 'left', 'right', 'custom'],
      expectedType: String,
    );
    
    _validators['interface.crosshair'] = _SettingConstraint(
      allowedValues: ['default', 'dot', 'circle', 'cross', 'custom'],
      expectedType: String,
    );
    
    _validators['interface.crosshairColor'] = _SettingConstraint(
      min: 0x000000,
      max: 0xffffff,
      expectedType: int,
    );
    
    _validators['interface.crosshairSize'] = _SettingConstraint(
      min: 0.5,
      max: 3.0,
      expectedType: double,
    );
    
    _validators['interface.notifications'] = _SettingConstraint(
      expectedType: bool,
    );
    
    _validators['interface.notificationDuration'] = _SettingConstraint(
      min: 1.0,
      max: 30.0,
      expectedType: double,
    );
    
    _validators['interface.tooltips'] = _SettingConstraint(
      expectedType: bool,
    );
    
    _validators['interface.tooltipDelay'] = _SettingConstraint(
      min: 0.0,
      max: 5.0,
      expectedType: double,
    );

    // Accessibility validators
    _validators['accessibility.textToSpeech'] = _SettingConstraint(
      expectedType: bool,
    );
    
    _validators['accessibility.speechToText'] = _SettingConstraint(
      expectedType: bool,
    );
    
    _validators['accessibility.closedCaptions'] = _SettingConstraint(
      expectedType: bool,
    );
    
    _validators['accessibility.audioDescriptions'] = _SettingConstraint(
      expectedType: bool,
    );
    
    _validators['accessibility.highVisibilityMode'] = _SettingConstraint(
      expectedType: bool,
    );
    
    _validators['accessibility.reducedMotion'] = _SettingConstraint(
      expectedType: bool,
    );
    
    _validators['accessibility.colorBlindCorrection'] = _SettingConstraint(
      allowedValues: ['none', 'protanopia', 'deuteranopia', 'tritanopia'],
      expectedType: String,
    );
    
    _validators['accessibility.dyslexiaFont'] = _SettingConstraint(
      expectedType: bool,
    );
    
    _validators['accessibility.buttonRemapping'] = _SettingConstraint(
      expectedType: bool,
    );
    
    _validators['accessibility.oneHandedMode'] = _SettingConstraint(
      expectedType: bool,
    );
    
    _validators['accessibility.eyeTracking'] = _SettingConstraint(
      expectedType: bool,
    );
    
    _validators['accessibility.headTracking'] = _SettingConstraint(
      expectedType: bool,
    );
    
    _validators['accessibility.assistiveTouch'] = _SettingConstraint(
      expectedType: bool,
    );
    
    _validators['accessibility.screenReader'] = _SettingConstraint(
      expectedType: bool,
    );
    
    _validators['accessibility.magnifier'] = _SettingConstraint(
      expectedType: bool,
    );

    // Network validators
    _validators['network.region'] = _SettingConstraint(
      allowedValues: ['auto', 'na', 'eu', 'asia', 'sa', 'oceania', 'africa'],
      expectedType: String,
    );
    
    _validators['network.matchmakingPriority'] = _SettingConstraint(
      allowedValues: ['fast', 'balanced', 'quality'],
      expectedType: String,
    );
    
    _validators['network.crossplay'] = _SettingConstraint(
      expectedType: bool,
    );
    
    _validators['network.voiceChat'] = _SettingConstraint(
      expectedType: bool,
    );
    
    _validators['network.voiceActivation'] = _SettingConstraint(
      expectedType: bool,
    );
    
    _validators['network.voiceActivationThreshold'] = _SettingConstraint(
      min: 0.0,
      max: 1.0,
      expectedType: double,
    );
    
    _validators['network.pushToTalk'] = _SettingConstraint(
      expectedType: bool,
    );
    
    _validators['network.pushToTalkKey'] = _SettingConstraint(
      pattern: RegExp(r'^[a-zA-Z0-9]$'),
      expectedType: String,
    );
    
    _validators['network.voiceVolume'] = _SettingConstraint(
      min: 0.0,
      max: 1.0,
      expectedType: double,
    );
    
    _validators['network.microphoneVolume'] = _SettingConstraint(
      min: 0.0,
      max: 1.0,
      expectedType: double,
    );
    
    _validators['network.latency'] = _SettingConstraint(
      allowedValues: ['auto', 'low', 'medium', 'high'],
      expectedType: String,
    );
    
    _validators['network.bandwidth'] = _SettingConstraint(
      allowedValues: ['auto', 'low', 'medium', 'high'],
      expectedType: String,
    );
    
    _validators['network.packetLoss'] = _SettingConstraint(
      allowedValues: ['auto', 'low', 'medium', 'high'],
      expectedType: String,
    );
    
    _validators['network.natType'] = _SettingConstraint(
      allowedValues: ['auto', 'open', 'moderate', 'strict'],
      expectedType: String,
    );
    
    _validators['network.upnp'] = _SettingConstraint(
      expectedType: bool,
    );
    
    _validators['network.portForwarding'] = _SettingConstraint(
      expectedType: bool,
    );
    
    _validators['network.dedicatedServer'] = _SettingConstraint(
      expectedType: bool,
    );

    // System validators
    _validators['system.autoUpdate'] = _SettingConstraint(
      expectedType: bool,
    );
    
    _validators['system.betaUpdates'] = _SettingConstraint(
      expectedType: bool,
    );
    
    _validators['system.analytics'] = _SettingConstraint(
      expectedType: bool,
    );
    
    _validators['system.crashReports'] = _SettingConstraint(
      expectedType: bool,
    );
    
    _validators['system.telemetry'] = _SettingConstraint(
      expectedType: bool,
    );
    
    _validators['system.saveLocation'] = _SettingConstraint(
      expectedType: String,
    );
    
    _validators['system.cacheLocation'] = _SettingConstraint(
      expectedType: String,
    );
    
    _validators['system.tempLocation'] = _SettingConstraint(
      expectedType: String,
    );
    
    _validators['system.maxCacheSize'] = _SettingConstraint(
      min: 64,
      max: 16384,
      expectedType: int,
    );
    
    _validators['system.autoCleanup'] = _SettingConstraint(
      expectedType: bool,
    );
    
    _validators['system.cleanupInterval'] = _SettingConstraint(
      min: 1,
      max: 30,
      expectedType: int,
    );
    
    _validators['system.backupSaves'] = _SettingConstraint(
      expectedType: bool,
    );
    
    _validators['system.backupInterval'] = _SettingConstraint(
      min: 1,
      max: 30,
      expectedType: int,
    );
    
    _validators['system.maxBackups'] = _SettingConstraint(
      min: 1,
      max: 100,
      expectedType: int,
    );
    
    _validators['system.powerSaving'] = _SettingConstraint(
      expectedType: bool,
    );
    
    _validators['system.performanceMode'] = _SettingConstraint(
      allowedValues: ['power_saving', 'balanced', 'performance'],
      expectedType: String,
    );
    
    _validators['system.priority'] = _SettingConstraint(
      allowedValues: ['low', 'normal', 'high', 'realtime'],
      expectedType: String,
    );
    
    _validators['system.affinity'] = _SettingConstraint(
      allowedValues: ['all', 'cpu0', 'cpu1', 'cpu2', 'cpu3'],
      expectedType: String,
    );
  }

  /// Initializes storage directory.
  void _initializeStorageDir() {
    // Determine platform-specific storage directory
    if (Platform.isWindows) {
      _storageDir = '${Platform.environment['APPDATA']}\\DSRT Engine\\Settings';
    } else if (Platform.isMacOS) {
      _storageDir = '${Platform.environment['HOME']}/Library/Application Support/DSRT Engine/Settings';
    } else if (Platform.isLinux) {
      _storageDir = '${Platform.environment['HOME']}/.config/dsrt-engine/settings';
    } else {
      _storageDir = './settings';
    }
    
    // Create directory if it doesn't exist
    final dir = Directory(_storageDir);
    if (!dir.existsSync()) {
      dir.createSync(recursive: true);
    }
  }

  /// Deep copies a map.
  Map<String, dynamic> _deepCopy(Map<String, dynamic> source) {
    final result = <String, dynamic>{};
    
    for (final key in source.keys) {
      final value = source[key];
      if (value is Map<String, dynamic>) {
        result[key] = _deepCopy(value);
      } else if (value is List) {
        result[key] = List.from(value);
      } else {
        result[key] = value;
      }
    }
    
    return result;
  }

  /// Loads settings from storage.
  Future<void> _loadSettings() async {
    try {
      final file = File('$_storageDir/$_storageKey.json');
      
      if (file.existsSync()) {
        final jsonString = file.readAsStringSync();
        final loaded = jsonDecode(jsonString) as Map<String, dynamic>;
        
        // Apply migrations if needed
        final migrated = await _migrateSettings(loaded);
        
        // Merge with defaults
        _settings.clear();
        _settings.addAll(_deepCopy(_defaultSettings));
        _mergeSettings(migrated);
        
        _loaded = true;
      } else {
        // Use defaults
        _settings.addAll(_deepCopy(_defaultSettings));
        _loaded = true;
        
        // Save defaults
        _saveSettings();
      }
    } catch (e) {
      // Fallback to defaults
      _settings.clear();
      _settings.addAll(_deepCopy(_defaultSettings));
      _loaded = false;
    }
  }

  /// Migrates settings from older versions.
  Future<Map<String, dynamic>> _migrateSettings(Map<String, dynamic> settings) async {
    final version = settings['_version'] as int? ?? 1;
    
    if (version < _settingsVersion) {
      // Apply migrations
      for (int i = version; i < _settingsVersion; i++) {
        final migration = _getMigration(i, i + 1);
        if (migration != null) {
          settings = migration(settings);
        }
      }
    }
    
    settings['_version'] = _settingsVersion;
    return settings;
  }

  /// Gets migration function for version transition.
  Function(Map<String, dynamic>)? _getMigration(int fromVersion, int toVersion) {
    final migrations = {
      '1_to_2': (Map<String, dynamic> settings) {
        // Migration from version 1 to 2
        // Example: Rename old setting keys
        if (settings.containsKey('graphics')) {
          final graphics = settings['graphics'] as Map<String, dynamic>;
          if (graphics.containsKey('aa')) {
            graphics['antiAliasing'] = graphics['aa'];
            graphics.remove('aa');
          }
        }
        return settings;
      },
    };
    
    return migrations['${fromVersion}_to_$toVersion'];
  }

  /// Saves settings to storage.
  Future<bool> _saveSettings() async {
    try {
      final file = File('$_storageDir/$_storageKey.json');
      
      // Add version info
      final settingsToSave = _deepCopy(_settings);
      settingsToSave['_version'] = _settingsVersion;
      settingsToSave['_lastModified'] = DateTime.now().toIso8601String();
      
      // Convert to JSON
      final jsonString = JsonEncoder.withIndent('  ').convert(settingsToSave);
      
      // Write to file
      await file.writeAsString(jsonString);
      
      _dirty = false;
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Gets a setting value.
  dynamic get(String path, [dynamic defaultValue]) {
    final parts = path.split('.');
    if (parts.length < 2) {
      return defaultValue;
    }

    var current = _settings;
    for (int i = 0; i < parts.length - 1; i++) {
      final part = parts[i];
      if (!current.containsKey(part) || current[part] is! Map<String, dynamic>) {
        return defaultValue;
      }
      current = current[part] as Map<String, dynamic>;
    }

    final key = parts.last;
    return current.containsKey(key) ? current[key] : defaultValue;
  }

  /// Gets a setting value as boolean.
  bool getBool(String path, [bool defaultValue = false]) {
    final value = get(path, defaultValue);
    return value is bool ? value : defaultValue;
  }

  /// Gets a setting value as double.
  double getDouble(String path, [double defaultValue = 0.0]) {
    final value = get(path, defaultValue);
    if (value is double) return value;
    if (value is int) return value.toDouble();
    return defaultValue;
  }

  /// Gets a setting value as integer.
  int getInt(String path, [int defaultValue = 0]) {
    final value = get(path, defaultValue);
    if (value is int) return value;
    if (value is double) return value.toInt();
    return defaultValue;
  }

  /// Gets a setting value as string.
  String getString(String path, [String defaultValue = '']) {
    final value = get(path, defaultValue);
    return value is String ? value : defaultValue;
  }

  /// Gets a setting value as list.
  List<dynamic> getList(String path, [List<dynamic> defaultValue = const []]) {
    final value = get(path, defaultValue);
    return value is List ? value : defaultValue;
  }

  /// Sets a setting value.
  Future<bool> set(String path, dynamic value, [bool saveImmediately = true]) async {
    // Validate the value
    if (!_validateValue(path, value)) {
      return false;
    }

    // Split path into parts
    final parts = path.split('.');
    if (parts.length < 2) {
      return false;
    }

    // Navigate to the target setting section
    var current = _settings;
    for (int i = 0; i < parts.length - 1; i++) {
      final part = parts[i];
      if (!current.containsKey(part)) {
        current[part] = <String, dynamic>{};
      }
      
      if (current[part] is! Map<String, dynamic>) {
        return false;
      }
      
      current = current[part] as Map<String, dynamic>;
    }

    // Get the old value
    final key = parts.last;
    final oldValue = current[key];

    // Set the new value
    current[key] = value;
    _dirty = true;

    // Notify listeners
    _notifyListeners(path, oldValue, value);

    // Save if requested
    if (saveImmediately) {
      return await _saveSettings();
    }

    return true;
  }

  /// Validates a setting value.
  bool _validateValue(String path, dynamic value) {
    if (_validators.containsKey(path)) {
      return _validators[path]!.validate(value);
    }
    return true;
  }

  /// Updates multiple settings.
  Future<bool> update(Map<String, dynamic> updates, [bool saveImmediately = true]) async {
    bool allSuccessful = true;

    for (final key in updates.keys) {
      final value = updates[key];
      final success = await set(key, value, false);
      
      if (!success) {
        allSuccessful = false;
      }
    }

    if (saveImmediately && allSuccessful) {
      return await _saveSettings();
    }

    return allSuccessful;
  }

  /// Resets settings to defaults.
  Future<bool> reset([bool saveImmediately = true]) async {
    _settings.clear();
    _settings.addAll(_deepCopy(_defaultSettings));
    _dirty = true;

    // Notify all listeners of reset
    for (final path in _listeners.keys) {
      final value = get(path);
      _notifyListeners(path, null, value);
    }

    // Notify global listeners
    for (final listener in _globalListeners) {
      listener('*', null, null);
    }

    if (saveImmediately) {
      return await _saveSettings();
    }

    return true;
  }

  /// Resets a specific setting to default.
  Future<bool> resetSetting(String path, [bool saveImmediately = true]) async {
    final parts = path.split('.');
    if (parts.length < 2) {
      return false;
    }

    // Get default value
    var currentDefault = _defaultSettings;
    for (int i = 0; i < parts.length - 1; i++) {
      final part = parts[i];
      if (!currentDefault.containsKey(part) || currentDefault[part] is! Map<String, dynamic>) {
        return false;
      }
      currentDefault = currentDefault[part] as Map<String, dynamic>;
    }

    final key = parts.last;
    if (!currentDefault.containsKey(key)) {
      return false;
    }

    final defaultValue = currentDefault[key];
    return await set(path, defaultValue, saveImmediately);
  }

  /// Notifies listeners of setting changes.
  void _notifyListeners(String path, dynamic oldValue, dynamic newValue) {
    // Notify specific listeners
    if (_listeners.containsKey(path)) {
      final listeners = _listeners[path]!;
      for (final listener in listeners) {
        listener(oldValue, newValue);
      }
    }
    
    // Notify global listeners
    for (final listener in _globalListeners) {
      listener(path, oldValue, newValue);
    }
  }

  /// Adds a settings change listener.
  bool addListener(String path, void Function(dynamic oldValue, dynamic newValue) listener) {
    if (!_listeners.containsKey(path)) {
      _listeners[path] = [];
    }
    
    _listeners[path]!.add(listener);
    return true;
  }

  /// Adds a global settings change listener.
  bool addGlobalListener(void Function(String path, dynamic oldValue, dynamic newValue) listener) {
    _globalListeners.add(listener);
    return true;
  }

  /// Removes a settings change listener.
  bool removeListener(String path, void Function(dynamic oldValue, dynamic newValue) listener) {
    if (!_listeners.containsKey(path)) {
      return false;
    }
    
    return _listeners[path]!.remove(listener);
  }

  /// Removes a global settings change listener.
  bool removeGlobalListener(void Function(String path, dynamic oldValue, dynamic newValue) listener) {
    return _globalListeners.remove(listener);
  }

  /// Saves all pending changes to storage.
  Future<bool> save() async {
    return await _saveSettings();
  }

  /// Loads settings from storage (reload).
  Future<bool> load() async {
    _loaded = false;
    await _loadSettings();
    return _loaded;
  }

  /// Checks if settings have unsaved changes.
  bool hasUnsavedChanges() {
    return _dirty;
  }

  /// Gets all settings as a map.
  Map<String, dynamic> getAll() {
    return Map<String, dynamic>.unmodifiable(_deepCopy(_settings));
  }

  /// Gets settings for a specific section.
  Map<String, dynamic> getSection(String section) {
    final value = get(section);
    if (value is Map<String, dynamic>) {
      return Map<String, dynamic>.unmodifiable(_deepCopy(value));
    }
    return const {};
  }

  /// Exports settings to JSON string.
  String exportToJson([bool pretty = false]) {
    try {
      final encoder = pretty ? JsonEncoder.withIndent('  ') : JsonEncoder();
      return encoder.convert(_settings);
    } catch (e) {
      return '{}';
    }
  }

  /// Imports settings from JSON string.
  Future<bool> importFromJson(String json, [bool merge = false, bool saveImmediately = true]) async {
    try {
      final imported = jsonDecode(json) as Map<String, dynamic>;
      
      if (merge) {
        _mergeSettings(imported);
      } else {
        _settings.clear();
        _settings.addAll(_deepCopy(imported));
      }
      
      _dirty = true;
      _notifyAllListeners();
      
      if (saveImmediately) {
        return await _saveSettings();
      }
      
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Merges settings with imported settings.
  void _mergeSettings(Map<String, dynamic> imported) {
    for (final key in imported.keys) {
      final value = imported[key];
      
      if (value is Map<String, dynamic>) {
        if (!_settings.containsKey(key)) {
          _settings[key] = <String, dynamic>{};
        }
        
        if (_settings[key] is Map<String, dynamic>) {
          _mergeMaps(_settings[key] as Map<String, dynamic>, value);
        }
      } else {
        _settings[key] = value;
      }
    }
  }

  /// Recursively merges two maps.
  void _mergeMaps(Map<String, dynamic> target, Map<String, dynamic> source) {
    for (final key in source.keys) {
      final sourceValue = source[key];
      
      if (sourceValue is Map<String, dynamic>) {
        if (!target.containsKey(key) || target[key] is! Map<String, dynamic>) {
          target[key] = <String, dynamic>{};
        }
        
        final targetValue = target[key] as Map<String, dynamic>;
        _mergeMaps(targetValue, sourceValue);
      } else {
        target[key] = sourceValue;
      }
    }
  }

  /// Notifies all listeners of settings changes.
  void _notifyAllListeners() {
    for (final path in _listeners.keys) {
      final value = get(path);
      _notifyListeners(path, null, value);
    }
    
    // Notify global listeners
    for (final listener in _globalListeners) {
      listener('*', null, null);
    }
  }

  /// Validates all settings.
  bool validate() {
    for (final path in _validators.keys) {
      final value = get(path);
      if (!_validateValue(path, value)) {
        return false;
      }
    }
    return true;
  }

  /// Gets invalid settings entries.
  List<Map<String, dynamic>> getInvalidEntries() {
    final invalid = <Map<String, dynamic>>[];
    
    for (final path in _validators.keys) {
      final value = get(path);
      if (!_validateValue(path, value)) {
        final definition = _settingDefinitions[path];
        invalid.add({
          'path': path,
          'value': value,
          'expectedType': _validators[path]!.expectedType.toString(),
          'description': definition?.description ?? 'No description',
        });
      }
    }
    
    return invalid;
  }

  /// Gets a settings summary.
  Map<String, dynamic> getSummary() {
    return {
      'graphics': {
        'resolution': get('graphics.resolution'),
        'displayMode': get('graphics.displayMode'),
        'vsync': getBool('graphics.vsync'),
        'textureQuality': get('graphics.textureQuality'),
      },
      'audio': {
        'masterVolume': getDouble('audio.masterVolume'),
        'mute': getBool('audio.mute'),
      },
      'gameplay': {
        'difficulty': get('gameplay.difficulty'),
        'language': get('gameplay.language'),
      },
      'interface': {
        'uiScale': getDouble('interface.uiScale'),
        'showFps': getBool('interface.showFps'),
      },
      'version': _settingsVersion,
      'lastModified': get('_lastModified', 'Never'),
    };
  }

  /// Applies a graphics preset.
  Future<bool> applyGraphicsPreset(String presetName) async {
    final preset = _graphicsPresets[presetName.toLowerCase()];
    if (preset == null) {
      return false;
    }
    
    return await update(preset);
  }

  /// Gets available graphics presets.
  List<String> getAvailableGraphicsPresets() {
    return _graphicsPresets.keys.toList();
  }

  /// Gets settings that require restart.
  List<String> getSettingsRequiringRestart() {
    final result = <String>[];
    
    for (final entry in _settingDefinitions.entries) {
      if (entry.value.requiresRestart) {
        result.add(entry.key);
      }
    }
    
    return result;
  }

  /// Gets settings by category.
  Map<String, dynamic> getSettingsByCategory(String category) {
    final result = <String, dynamic>{};
    
    for (final entry in _settingDefinitions.entries) {
      if (entry.value.category == category) {
        result[entry.key] = get(entry.key);
      }
    }
    
    return result;
  }

  /// Sets settings by category.
  Future<bool> setSettingsByCategory(String category, Map<String, dynamic> values) async {
    bool allSuccess = true;
    
    for (final entry in values.entries) {
      final path = entry.key;
      final value = entry.value;
      
      // Verify this setting belongs to the category
      final def = _settingDefinitions[path];
      if (def?.category == category) {
        if (!await set(path, value, false)) {
          allSuccess = false;
        }
      }
    }
    
    if (allSuccess) {
      return await _saveSettings();
    }
    
    return false;
  }

  /// Gets the setting definition for a path.
  _SettingDefinition? getSettingDefinition(String path) {
    return _settingDefinitions[path];
  }

  /// Gets all setting definitions.
  Map<String, _SettingDefinition> getAllSettingDefinitions() {
    return Map<String, _SettingDefinition>.unmodifiable(_settingDefinitions);
  }

  /// Gets setting categories.
  Set<String> getCategories() {
    final categories = <String>{};
    
    for (final def in _settingDefinitions.values) {
      categories.add(def.category);
    }
    
    return categories;
  }

  /// Backs up current settings.
  Future<bool> backup() async {
    try {
      final timestamp = DateTime.now().toIso8601String().replaceAll(':', '-');
      final backupFile = File('$_storageDir/backup/settings_backup_$timestamp.json');
      
      if (!backupFile.parent.existsSync()) {
        backupFile.parent.createSync(recursive: true);
      }
      
      final settingsToBackup = _deepCopy(_settings);
      settingsToBackup['_version'] = _settingsVersion;
      settingsToBackup['_backupTime'] = timestamp;
      
      final jsonString = JsonEncoder.withIndent('  ').convert(settingsToBackup);
      await backupFile.writeAsString(jsonString);
      
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Restores settings from backup.
  Future<bool> restoreFromBackup(String backupFilePath) async {
    try {
      final backupFile = File(backupFilePath);
      if (!backupFile.existsSync()) {
        return false;
      }
      
      final jsonString = backupFile.readAsStringSync();
      return await importFromJson(jsonString, false);
    } catch (e) {
      return false;
    }
  }

  /// Gets available backups.
  List<String> getAvailableBackups() {
    final backupDir = Directory('$_storageDir/backup');
    if (!backupDir.existsSync()) {
      return [];
    }
    
    return backupDir
        .listSync()
        .whereType<File>()
        .where((file) => file.path.endsWith('.json'))
        .map((file) => file.path)
        .toList();
  }

  /// Cleans up old backups.
  Future<void> cleanupOldBackups({int keepLast = 5}) async {
    final backups = getAvailableBackups();
    if (backups.length <= keepLast) {
      return;
    }
    
    // Sort by modification time (oldest first)
    backups.sort((a, b) {
      final fileA = File(a);
      final fileB = File(b);
      return fileA.lastModifiedSync().compareTo(fileB.lastModifiedSync());
    });
    
    // Delete oldest backups
    for (int i = 0; i < backups.length - keepLast; i++) {
      try {
        File(backups[i]).deleteSync();
      } catch (e) {
        // Ignore deletion errors
      }
    }
  }

  /// Gets whether settings have been loaded from storage.
  bool isLoaded() {
    return _loaded;
  }
}
