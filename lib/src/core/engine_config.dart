// lib/src/core/engine_config.dart

/// DSRT Engine - Configuration System
/// 
/// Provides comprehensive configuration management for the DSRT Engine,
/// including validation, merging, and persistence capabilities.
/// 
/// @category Core
/// @version 1.0.0
/// @license MIT
/// @copyright DSRT Engine Team

library dsrt_engine.core.engine_config;

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'constants.dart';

/// Configuration source type
enum DsrtConfigSource {
  /// Default configuration (built-in)
  defaults,
  
  /// File-based configuration
  file,
  
  /// Environment variables
  environment,
  
  /// Command-line arguments
  commandLine,
  
  /// Runtime overrides
  runtime,
  
  /// User preferences
  user,
  
  /// System settings
  system,
  
  /// Network configuration
  network,
  
  /// Plugin-provided configuration
  plugin,
  
  /// Unknown source
  unknown
}

/// Configuration data type
enum DsrtConfigType {
  /// Boolean value
  boolean,
  
  /// Integer value
  integer,
  
  /// Floating-point value
  double,
  
  /// String value
  string,
  
  /// List of values
  list,
  
  /// Map of key-value pairs
  map,
  
  /// Binary data
  binary,
  
  /// JSON data
  json,
  
  /// Color value (RGBA)
  color,
  
  /// Vector value (2D, 3D, 4D)
  vector,
  
  /// Matrix value
  matrix,
  
  /// Enumeration value
  enumeration,
  
  /// Dynamic value (type inferred)
  dynamic
}

/// Configuration validation result
class DsrtConfigValidationResult {
  /// Whether the configuration is valid
  final bool isValid;
  
  /// Validation errors (if any)
  final List<String> errors;
  
  /// Validation warnings (if any)
  final List<String> warnings;
  
  /// Creates a validation result
  DsrtConfigValidationResult({
    required this.isValid,
    this.errors = const [],
    this.warnings = const [],
  });
  
  /// Creates a successful validation result
  factory DsrtConfigValidationResult.success() {
    return DsrtConfigValidationResult(isValid: true);
  }
  
  /// Creates a failed validation result
  factory DsrtConfigValidationResult.failure(List<String> errors) {
    return DsrtConfigValidationResult(isValid: false, errors: errors);
  }
  
  /// Creates a validation result with warnings
  factory DsrtConfigValidationResult.withWarnings(List<String> warnings) {
    return DsrtConfigValidationResult(
      isValid: true,
      warnings: warnings,
    );
  }
  
  /// Combines multiple validation results
  static DsrtConfigValidationResult combine(
    List<DsrtConfigValidationResult> results,
  ) {
    final errors = <String>[];
    final warnings = <String>[];
    var isValid = true;
    
    for (final result in results) {
      if (!result.isValid) {
        isValid = false;
      }
      errors.addAll(result.errors);
      warnings.addAll(result.warnings);
    }
    
    return DsrtConfigValidationResult(
      isValid: isValid,
      errors: errors,
      warnings: warnings,
    );
  }
  
  /// Gets a formatted error message
  String get errorMessage {
    if (isValid) return 'Configuration is valid';
    
    final buffer = StringBuffer();
    buffer.writeln('Configuration validation failed:');
    for (var i = 0; i < errors.length; i++) {
      buffer.writeln('  ${i + 1}. ${errors[i]}');
    }
    return buffer.toString();
  }
}

/// Configuration entry with metadata
class DsrtConfigEntry {
  /// Configuration key
  final String key;
  
  /// Configuration value
  final dynamic value;
  
  /// Configuration type
  final DsrtConfigType type;
  
  /// Configuration source
  final DsrtConfigSource source;
  
  /// Whether this value is required
  final bool required;
  
  /// Default value (if any)
  final dynamic defaultValue;
  
  /// Validation constraints
  final Map<String, dynamic> constraints;
  
  /// Description of this configuration
  final String description;
  
  /// Last modification timestamp
  final DateTime lastModified;
  
  /// Creates a configuration entry
  DsrtConfigEntry({
    required this.key,
    required this.value,
    required this.type,
    this.source = DsrtConfigSource.runtime,
    this.required = false,
    this.defaultValue,
    this.constraints = const {},
    this.description = '',
    DateTime? lastModified,
  }) : lastModified = lastModified ?? DateTime.now() {
    // Validate value against type
    _validateValue(value, type);
    
    // Apply constraints validation
    if (constraints.isNotEmpty) {
      _validateConstraints(value, constraints);
    }
  }
  
  /// Creates a configuration entry from a map
  factory DsrtConfigEntry.fromMap(
    String key,
    dynamic value, {
    DsrtConfigSource source = DsrtConfigSource.runtime,
    Map<String, dynamic>? metadata,
  }) {
    final metadataMap = metadata ?? {};
    
    return DsrtConfigEntry(
      key: key,
      value: value,
      type: _inferType(value),
      source: source,
      required: metadataMap['required'] ?? false,
      defaultValue: metadataMap['default'],
      constraints: metadataMap['constraints'] ?? const {},
      description: metadataMap['description'] ?? '',
      lastModified: metadataMap['lastModified'] != null
          ? DateTime.parse(metadataMap['lastModified'])
          : null,
    );
  }
  
  /// Gets the effective value (value if not null, otherwise default)
  dynamic get effectiveValue => value ?? defaultValue;
  
  /// Checks if the value is set (not null)
  bool get hasValue => value != null;
  
  /// Checks if this entry has a default value
  bool get hasDefault => defaultValue != null;
  
  /// Validates this configuration entry
  DsrtConfigValidationResult validate() {
    final errors = <String>[];
    
    // Check required field
    if (required && !hasValue && !hasDefault) {
      errors.add('Required configuration "$key" is missing');
    }
    
    // Validate type
    try {
      _validateValue(value, type);
    } catch (e) {
      errors.add('Invalid type for "$key": $e');
    }
    
    // Validate constraints
    if (constraints.isNotEmpty && hasValue) {
      try {
        _validateConstraints(value, constraints);
      } catch (e) {
        errors.add('Constraint violation for "$key": $e');
      }
    }
    
    return DsrtConfigValidationResult(
      isValid: errors.isEmpty,
      errors: errors,
    );
  }
  
  /// Converts this entry to a map
  Map<String, dynamic> toMap() {
    return {
      'key': key,
      'value': value,
      'type': type.name,
      'source': source.name,
      'required': required,
      'defaultValue': defaultValue,
      'constraints': constraints,
      'description': description,
      'lastModified': lastModified.toIso8601String(),
    };
  }
  
  /// Creates a copy of this entry with overrides
  DsrtConfigEntry copyWith({
    String? key,
    dynamic value,
    DsrtConfigType? type,
    DsrtConfigSource? source,
    bool? required,
    dynamic defaultValue,
    Map<String, dynamic>? constraints,
    String? description,
    DateTime? lastModified,
  }) {
    return DsrtConfigEntry(
      key: key ?? this.key,
      value: value ?? this.value,
      type: type ?? this.type,
      source: source ?? this.source,
      required: required ?? this.required,
      defaultValue: defaultValue ?? this.defaultValue,
      constraints: constraints ?? this.constraints,
      description: description ?? this.description,
      lastModified: lastModified ?? this.lastModified,
    );
  }
  
  /// Validates a value against its type
  static void _validateValue(dynamic value, DsrtConfigType type) {
    if (value == null) return;
    
    switch (type) {
      case DsrtConfigType.boolean:
        if (value is! bool) {
          throw ArgumentError('Expected boolean, got ${value.runtimeType}');
        }
        break;
      case DsrtConfigType.integer:
        if (value is! int) {
          throw ArgumentError('Expected integer, got ${value.runtimeType}');
        }
        break;
      case DsrtConfigType.double:
        if (value is! double) {
          throw ArgumentError('Expected double, got ${value.runtimeType}');
        }
        break;
      case DsrtConfigType.string:
        if (value is! String) {
          throw ArgumentError('Expected string, got ${value.runtimeType}');
        }
        break;
      case DsrtConfigType.list:
        if (value is! List) {
          throw ArgumentError('Expected list, got ${value.runtimeType}');
        }
        break;
      case DsrtConfigType.map:
        if (value is! Map) {
          throw ArgumentError('Expected map, got ${value.runtimeType}');
        }
        break;
      case DsrtConfigType.binary:
        if (value is! Uint8List) {
          throw ArgumentError('Expected binary data, got ${value.runtimeType}');
        }
        break;
      case DsrtConfigType.json:
        try {
          jsonEncode(value);
        } catch (e) {
          throw ArgumentError('Invalid JSON: $e');
        }
        break;
      case DsrtConfigType.color:
        if (value is! int) {
          throw ArgumentError('Expected color integer, got ${value.runtimeType}');
        }
        if (value < 0 || value > 0xFFFFFFFF) {
          throw ArgumentError('Color value out of range: $value');
        }
        break;
      case DsrtConfigType.vector:
        if (value is! List<num>) {
          throw ArgumentError('Expected number list for vector, got ${value.runtimeType}');
        }
        break;
      case DsrtConfigType.matrix:
        if (value is! List<List<num>>) {
          throw ArgumentError('Expected matrix, got ${value.runtimeType}');
        }
        break;
      case DsrtConfigType.enumeration:
        if (value is! String && value is! int) {
          throw ArgumentError('Expected string or int for enum, got ${value.runtimeType}');
        }
        break;
      case DsrtConfigType.dynamic:
        // All types accepted
        break;
    }
  }
  
  /// Validates constraints
  static void _validateConstraints(dynamic value, Map<String, dynamic> constraints) {
    if (value == null) return;
    
    for (final entry in constraints.entries) {
      final constraint = entry.key;
      final constraintValue = entry.value;
      
      switch (constraint) {
        case 'min':
          if (value is num && value < constraintValue) {
            throw ArgumentError('Value $value is less than minimum $constraintValue');
          }
          if (value is List && value.length < constraintValue) {
            throw ArgumentError('List length ${value.length} is less than minimum $constraintValue');
          }
          break;
        case 'max':
          if (value is num && value > constraintValue) {
            throw ArgumentError('Value $value is greater than maximum $constraintValue');
          }
          if (value is List && value.length > constraintValue) {
            throw ArgumentError('List length ${value.length} is greater than maximum $constraintValue');
          }
          break;
        case 'minLength':
          if (value is String && value.length < constraintValue) {
            throw ArgumentError('String length ${value.length} is less than minimum $constraintValue');
          }
          break;
        case 'maxLength':
          if (value is String && value.length > constraintValue) {
            throw ArgumentError('String length ${value.length} is greater than maximum $constraintValue');
          }
          break;
        case 'pattern':
          if (value is String) {
            final pattern = RegExp(constraintValue);
            if (!pattern.hasMatch(value)) {
              throw ArgumentError('String does not match pattern $constraintValue');
            }
          }
          break;
        case 'enum':
          if (value is! String && value is! int) {
            throw ArgumentError('Enum constraint requires string or int value');
          }
          if (constraintValue is List && !constraintValue.contains(value)) {
            throw ArgumentError('Value $value is not in allowed values $constraintValue');
          }
          break;
        case 'required':
          if (constraintValue == true && value == null) {
            throw ArgumentError('Value is required');
          }
          break;
        case 'custom':
          if (constraintValue is Function) {
            final isValid = constraintValue(value);
            if (isValid != true) {
              throw ArgumentError('Custom validation failed for value $value');
            }
          }
          break;
      }
    }
  }
  
  /// Infers the type from a value
  static DsrtConfigType _inferType(dynamic value) {
    if (value == null) return DsrtConfigType.dynamic;
    
    if (value is bool) return DsrtConfigType.boolean;
    if (value is int) return DsrtConfigType.integer;
    if (value is double) return DsrtConfigType.double;
    if (value is String) return DsrtConfigType.string;
    if (value is List) return DsrtConfigType.list;
    if (value is Map) return DsrtConfigType.map;
    if (value is Uint8List) return DsrtConfigType.binary;
    
    // Try to detect JSON-compatible structures
    try {
      jsonEncode(value);
      return DsrtConfigType.json;
    } catch (_) {
      // Not JSON serializable
    }
    
    return DsrtConfigType.dynamic;
  }
}

/// Configuration section grouping related entries
class DsrtConfigSection {
  /// Section name
  final String name;
  
  /// Section description
  final String description;
  
  /// Configuration entries in this section
  final Map<String, DsrtConfigEntry> entries;
  
  /// Creates a configuration section
  DsrtConfigSection({
    required this.name,
    this.description = '',
    Map<String, DsrtConfigEntry>? entries,
  }) : entries = entries ?? {};
  
  /// Adds an entry to this section
  void addEntry(DsrtConfigEntry entry) {
    entries[entry.key] = entry;
  }
  
  /// Removes an entry from this section
  bool removeEntry(String key) {
    return entries.remove(key) != null;
  }
  
  /// Gets an entry by key
  DsrtConfigEntry? getEntry(String key) {
    return entries[key];
  }
  
  /// Checks if this section contains a key
  bool hasKey(String key) {
    return entries.containsKey(key);
  }
  
  /// Gets a value by key
  dynamic getValue(String key) {
    return entries[key]?.effectiveValue;
  }
  
  /// Sets a value for a key
  void setValue(
    String key,
    dynamic value, {
    DsrtConfigSource source = DsrtConfigSource.runtime,
  }) {
    final entry = entries[key];
    if (entry != null) {
      entries[key] = entry.copyWith(value: value, source: source);
    } else {
      entries[key] = DsrtConfigEntry.fromMap(key, value, source: source);
    }
  }
  
  /// Validates all entries in this section
  DsrtConfigValidationResult validate() {
    final results = <DsrtConfigValidationResult>[];
    
    for (final entry in entries.values) {
      results.add(entry.validate());
    }
    
    return DsrtConfigValidationResult.combine(results);
  }
  
  /// Converts this section to a map
  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{};
    
    for (final entry in entries.values) {
      map[entry.key] = entry.effectiveValue;
    }
    
    return {
      'name': name,
      'description': description,
      'entries': entries.map((key, entry) => MapEntry(key, entry.toMap())),
    };
  }
  
  /// Creates a copy of this section
  DsrtConfigSection copyWith({
    String? name,
    String? description,
    Map<String, DsrtConfigEntry>? entries,
  }) {
    return DsrtConfigSection(
      name: name ?? this.name,
      description: description ?? this.description,
      entries: entries ?? Map.from(this.entries),
    );
  }
  
  /// Merges another section into this one
  void merge(DsrtConfigSection other, {bool overwrite = true}) {
    for (final entry in other.entries.values) {
      if (overwrite || !entries.containsKey(entry.key)) {
        entries[entry.key] = entry;
      }
    }
  }
}

/// Main engine configuration manager
class DsrtEngineConfig {
  /// Configuration sections
  final Map<String, DsrtConfigSection> _sections;
  
  /// Configuration change listeners
  final List<void Function(String, String, dynamic)> _listeners;
  
  /// Configuration persistence provider
  final DsrtConfigPersistence? _persistence;
  
  /// Creates an engine configuration instance
  DsrtEngineConfig({DsrtConfigPersistence? persistence})
      : _sections = {},
        _listeners = [],
        _persistence = persistence {
    // Initialize with default sections
    _initializeDefaultSections();
  }
  
  /// Gets a section by name
  DsrtConfigSection? getSection(String name) {
    return _sections[name];
  }
  
  /// Creates a new section
  DsrtConfigSection createSection(String name, {String description = ''}) {
    if (_sections.containsKey(name)) {
      throw ArgumentError('Section "$name" already exists');
    }
    
    final section = DsrtConfigSection(name: name, description: description);
    _sections[name] = section;
    return section;
  }
  
  /// Removes a section
  bool removeSection(String name) {
    return _sections.remove(name) != null;
  }
  
  /// Gets a value from a section
  dynamic getValue(String sectionName, String key) {
    final section = _sections[sectionName];
    if (section == null) {
      throw ArgumentError('Section "$sectionName" not found');
    }
    
    return section.getValue(key);
  }
  
  /// Sets a value in a section
  void setValue(
    String sectionName,
    String key,
    dynamic value, {
    DsrtConfigSource source = DsrtConfigSource.runtime,
  }) {
    var section = _sections[sectionName];
    if (section == null) {
      section = createSection(sectionName);
    }
    
    final oldValue = section.getValue(key);
    section.setValue(key, value, source: source);
    
    // Notify listeners
    if (oldValue != value) {
      _notifyListeners(sectionName, key, value);
    }
  }
  
  /// Checks if a configuration exists
  bool hasValue(String sectionName, String key) {
    final section = _sections[sectionName];
    return section != null && section.hasKey(key);
  }
  
  /// Validates all configuration sections
  DsrtConfigValidationResult validate() {
    final results = <DsrtConfigValidationResult>[];
    
    for (final section in _sections.values) {
      results.add(section.validate());
    }
    
    return DsrtConfigValidationResult.combine(results);
  }
  
  /// Adds a configuration change listener
  void addListener(void Function(String, String, dynamic) listener) {
    _listeners.add(listener);
  }
  
  /// Removes a configuration change listener
  bool removeListener(void Function(String, String, dynamic) listener) {
    return _listeners.remove(listener);
  }
  
  /// Loads configuration from a map
  void loadFromMap(Map<String, dynamic> configMap) {
    for (final sectionEntry in configMap.entries) {
      final sectionName = sectionEntry.key;
      final sectionData = sectionEntry.value;
      
      if (sectionData is Map) {
        final section = createSection(sectionName);
        
        for (final entry in sectionData.entries) {
          final key = entry.key;
          final value = entry.value;
          
          section.setValue(key, value, source: DsrtConfigSource.file);
        }
      }
    }
  }
  
  /// Saves configuration to a map
  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{};
    
    for (final section in _sections.values) {
      map[section.name] = section.toMap();
    }
    
    return map;
  }
  
  /// Loads configuration from JSON
  Future<void> loadFromJson(String jsonString) async {
    try {
      final configMap = jsonDecode(jsonString) as Map<String, dynamic>;
      loadFromMap(configMap);
    } catch (e) {
      throw FormatException('Failed to parse configuration JSON: $e');
    }
  }
  
  /// Saves configuration to JSON
  String toJson({bool pretty = false}) {
    final map = toMap();
    final encoder = pretty ? JsonEncoder.withIndent('  ') : JsonEncoder();
    return encoder.convert(map);
  }
  
  /// Loads configuration from a file
  Future<void> loadFromFile(String filePath) async {
    if (_persistence != null) {
      await _persistence!.loadFromFile(filePath, this);
    } else {
      final file = File(filePath);
      final jsonString = await file.readAsString();
      await loadFromJson(jsonString);
    }
  }
  
  /// Saves configuration to a file
  Future<void> saveToFile(String filePath) async {
    if (_persistence != null) {
      await _persistence!.saveToFile(filePath, this);
    } else {
      final file = File(filePath);
      final jsonString = toJson(pretty: true);
      await file.writeAsString(jsonString);
    }
  }
  
  /// Resets configuration to defaults
  void resetToDefaults() {
    _sections.clear();
    _initializeDefaultSections();
  }
  
  /// Merges another configuration into this one
  void merge(DsrtEngineConfig other, {bool overwrite = true}) {
    for (final otherSection in other._sections.values) {
      var section = _sections[otherSection.name];
      if (section == null) {
        section = createSection(otherSection.name, description: otherSection.description);
      }
      
      section.merge(otherSection, overwrite: overwrite);
    }
  }
  
  /// Gets all section names
  List<String> get sectionNames => _sections.keys.toList();
  
  /// Gets the number of configuration entries
  int get entryCount {
    var count = 0;
    for (final section in _sections.values) {
      count += section.entries.length;
    }
    return count;
  }
  
  /// Initializes default configuration sections
  void _initializeDefaultSections() {
    // Core engine settings
    final coreSection = createSection('core', description: 'Core engine settings');
    coreSection.addEntry(DsrtConfigEntry(
      key: 'debug',
      value: false,
      type: DsrtConfigType.boolean,
      source: DsrtConfigSource.defaults,
      description: 'Enable debug mode',
      defaultValue: false,
    ));
    coreSection.addEntry(DsrtConfigEntry(
      key: 'logLevel',
      value: 'info',
      type: DsrtConfigType.string,
      source: DsrtConfigSource.defaults,
      description: 'Logging level (verbose, debug, info, warning, error)',
      defaultValue: 'info',
      constraints: {
        'enum': ['verbose', 'debug', 'info', 'warning', 'error'],
      },
    ));
    coreSection.addEntry(DsrtConfigEntry(
      key: 'maxFrameRate',
      value: 60,
      type: DsrtConfigType.integer,
      source: DsrtConfigSource.defaults,
      description: 'Maximum frame rate (0 for unlimited)',
      defaultValue: 60,
      constraints: {
        'min': 0,
        'max': 1000,
      },
    ));
    
    // Graphics settings
    final graphicsSection = createSection('graphics', description: 'Graphics settings');
    graphicsSection.addEntry(DsrtConfigEntry(
      key: 'renderer',
      value: 'webgl2',
      type: DsrtConfigType.string,
      source: DsrtConfigSource.defaults,
      description: 'Renderer type (webgl, webgl2, webgpu, canvas)',
      defaultValue: 'webgl2',
      constraints: {
        'enum': ['webgl', 'webgl2', 'webgpu', 'canvas', 'svg', 'css3d'],
      },
    ));
    graphicsSection.addEntry(DsrtConfigEntry(
      key: 'antialias',
      value: true,
      type: DsrtConfigType.boolean,
      source: DsrtConfigSource.defaults,
      description: 'Enable antialiasing',
      defaultValue: true,
    ));
    graphicsSection.addEntry(DsrtConfigEntry(
      key: 'alpha',
      value: false,
      type: DsrtConfigType.boolean,
      source: DsrtConfigSource.defaults,
      description: 'Enable alpha channel',
      defaultValue: false,
    ));
    graphicsSection.addEntry(DsrtConfigEntry(
      key: 'premultipliedAlpha',
      value: true,
      type: DsrtConfigType.boolean,
      source: DsrtConfigSource.defaults,
      description: 'Use premultiplied alpha',
      defaultValue: true,
    ));
    graphicsSection.addEntry(DsrtConfigEntry(
      key: 'preserveDrawingBuffer',
      value: false,
      type: DsrtConfigType.boolean,
      source: DsrtConfigSource.defaults,
      description: 'Preserve drawing buffer',
      defaultValue: false,
    ));
    graphicsSection.addEntry(DsrtConfigEntry(
      key: 'powerPreference',
      value: 'default',
      type: DsrtConfigType.string,
      source: DsrtConfigSource.defaults,
      description: 'Power preference (default, high-performance, low-power)',
      defaultValue: 'default',
      constraints: {
        'enum': ['default', 'high-performance', 'low-power'],
      },
    ));
    
    // Physics settings
    final physicsSection = createSection('physics', description: 'Physics settings');
    physicsSection.addEntry(DsrtConfigEntry(
      key: 'enabled',
      value: true,
      type: DsrtConfigType.boolean,
      source: DsrtConfigSource.defaults,
      description: 'Enable physics simulation',
      defaultValue: true,
    ));
    physicsSection.addEntry(DsrtConfigEntry(
      key: 'gravity',
      value: DsrtPhysicsConstants.DEFAULT_GRAVITY,
      type: DsrtConfigType.double,
      source: DsrtConfigSource.defaults,
      description: 'Gravity force (m/s²)',
      defaultValue: DsrtPhysicsConstants.DEFAULT_GRAVITY,
      constraints: {
        'min': -100.0,
        'max': 100.0,
      },
    ));
    physicsSection.addEntry(DsrtConfigEntry(
      key: 'timeStep',
      value: DsrtPhysicsConstants.DEFAULT_TIME_STEP,
      type: DsrtConfigType.double,
      source: DsrtConfigSource.defaults,
      description: 'Physics time step (seconds)',
      defaultValue: DsrtPhysicsConstants.DEFAULT_TIME_STEP,
      constraints: {
        'min': 0.001,
        'max': 0.1,
      },
    ));
    
    // Audio settings
    final audioSection = createSection('audio', description: 'Audio settings');
    audioSection.addEntry(DsrtConfigEntry(
      key: 'enabled',
      value: true,
      type: DsrtConfigType.boolean,
      source: DsrtConfigSource.defaults,
      description: 'Enable audio system',
      defaultValue: true,
    ));
    audioSection.addEntry(DsrtConfigEntry(
      key: 'volume',
      value: DsrtAudioConstants.DEFAULT_MASTER_VOLUME,
      type: DsrtConfigType.double,
      source: DsrtConfigSource.defaults,
      description: 'Master volume (0.0 to 1.0)',
      defaultValue: DsrtAudioConstants.DEFAULT_MASTER_VOLUME,
      constraints: {
        'min': 0.0,
        'max': 1.0,
      },
    ));
    
    // Memory settings
    final memorySection = createSection('memory', description: 'Memory management settings');
    memorySection.addEntry(DsrtConfigEntry(
      key: 'poolSize',
      value: DsrtMemoryConstants.DEFAULT_MEMORY_POOL_SIZE,
      type: DsrtConfigType.integer,
      source: DsrtConfigSource.defaults,
      description: 'Memory pool size in bytes',
      defaultValue: DsrtMemoryConstants.DEFAULT_MEMORY_POOL_SIZE,
      constraints: {
        'min': 1024 * 1024, // 1MB
        'max': 1024 * 1024 * 1024, // 1GB
      },
    ));
  }
  
  /// Notifies all listeners of configuration changes
  void _notifyListeners(String section, String key, dynamic value) {
    for (final listener in _listeners) {
      try {
        listener(section, key, value);
      } catch (e) {
        // Ignore listener errors
      }
    }
  }
}

/// Configuration persistence interface
abstract class DsrtConfigPersistence {
  /// Loads configuration from a file
  Future<void> loadFromFile(String filePath, DsrtEngineConfig config);
  
  /// Saves configuration to a file
  Future<void> saveToFile(String filePath, DsrtEngineConfig config);
  
  /// Loads configuration from a URL
  Future<void> loadFromUrl(String url, DsrtEngineConfig config);
  
  /// Saves configuration to a URL
  Future<void> saveToUrl(String url, DsrtEngineConfig config);
}

/// JSON-based configuration persistence
class DsrtJsonConfigPersistence implements DsrtConfigPersistence {
  @override
  Future<void> loadFromFile(String filePath, DsrtEngineConfig config) async {
    final file = File(filePath);
    final jsonString = await file.readAsString();
    await config.loadFromJson(jsonString);
  }
  
  @override
  Future<void> saveToFile(String filePath, DsrtEngineConfig config) async {
    final file = File(filePath);
    final jsonString = config.toJson(pretty: true);
    await file.writeAsString(jsonString);
  }
  
  @override
  Future<void> loadFromUrl(String url, DsrtEngineConfig config) async {
    final client = HttpClient();
    final request = await client.getUrl(Uri.parse(url));
    final response = await request.close();
    final jsonString = await response.transform(utf8.decoder).join();
    await config.loadFromJson(jsonString);
    client.close();
  }
  
  @override
  Future<void> saveToUrl(String url, DsrtEngineConfig config) async {
    // Typically not implemented for HTTP URLs
    throw UnimplementedError('Saving to URL is not implemented');
  }
}

/// Environment variable configuration source
class DsrtEnvironmentConfig {
  /// Loads configuration from environment variables
  static void loadFromEnvironment(DsrtEngineConfig config) {
    final envVars = Platform.environment;
    
    for (final entry in envVars.entries) {
      final key = entry.key;
      final value = entry.value;
      
      // Parse DSRT_ prefixed environment variables
      if (key.startsWith('DSRT_')) {
        final parts = key.substring(5).split('_');
        if (parts.length >= 2) {
          final section = parts[0].toLowerCase();
          final configKey = parts.sublist(1).map((p) => p.toLowerCase()).join('.');
          
          // Try to parse value based on content
          dynamic parsedValue;
          if (value.toLowerCase() == 'true') {
            parsedValue = true;
          } else if (value.toLowerCase() == 'false') {
            parsedValue = false;
          } else if (int.tryParse(value) != null) {
            parsedValue = int.parse(value);
          } else if (double.tryParse(value) != null) {
            parsedValue = double.parse(value);
          } else {
            parsedValue = value;
          }
          
          config.setValue(section, configKey, parsedValue,
              source: DsrtConfigSource.environment);
        }
      }
    }
  }
}

/// Command-line argument configuration source
class DsrtCommandLineConfig {
  /// Loads configuration from command-line arguments
  static void loadFromArgs(
    DsrtEngineConfig config,
    List<String> args, {
    Map<String, String> argMap = const {},
  }) {
    final argPattern = RegExp(r'^--([a-zA-Z0-9-]+)(?:=(.*))?$');
    
    for (final arg in args) {
      final match = argPattern.firstMatch(arg);
      if (match != null) {
        final key = match.group(1)!;
        final value = match.group(2) ?? 'true';
        
        // Map argument to configuration key
        final configKey = argMap[key] ?? key.replaceAll('-', '.');
        final parts = configKey.split('.');
        
        if (parts.length >= 2) {
          final section = parts[0];
          final configKey = parts.sublist(1).join('.');
          
          // Parse value
          dynamic parsedValue;
          if (value.toLowerCase() == 'true') {
            parsedValue = true;
          } else if (value.toLowerCase() == 'false') {
            parsedValue = false;
          } else if (int.tryParse(value) != null) {
            parsedValue = int.parse(value);
          } else if (double.tryParse(value) != null) {
            parsedValue = double.parse(value);
          } else {
            parsedValue = value;
          }
          
          config.setValue(section, configKey, parsedValue,
              source: DsrtConfigSource.commandLine);
        }
      }
    }
  }
}

/// Configuration utilities
class DsrtConfigUtils {
  /// Creates a configuration from multiple sources
  static DsrtEngineConfig createFromSources({
    Map<String, dynamic>? defaults,
    Map<String, dynamic>? fileConfig,
    Map<String, String>? environment,
    List<String>? commandLineArgs,
    Map<String, dynamic>? runtimeOverrides,
  }) {
    final config = DsrtEngineConfig();
    
    // Load defaults
    if (defaults != null) {
      config.loadFromMap(defaults);
    }
    
    // Load from file config
    if (fileConfig != null) {
      config.merge(DsrtEngineConfig()..loadFromMap(fileConfig));
    }
    
    // Load from environment
    if (environment != null) {
      // Simulate environment variables
      Platform.environment.forEach((key, value) {
        if (key.startsWith('DSRT_')) {
          DsrtEnvironmentConfig.loadFromEnvironment(config);
          return;
        }
      });
    }
    
    // Load from command line
    if (commandLineArgs != null && commandLineArgs.isNotEmpty) {
      DsrtCommandLineConfig.loadFromArgs(config, commandLineArgs);
    }
    
    // Apply runtime overrides
    if (runtimeOverrides != null) {
      for (final entry in runtimeOverrides.entries) {
        final key = entry.key;
        final value = entry.value;
        
        final parts = key.split('.');
        if (parts.length >= 2) {
          final section = parts[0];
          final configKey = parts.sublist(1).join('.');
          
          config.setValue(section, configKey, value,
              source: DsrtConfigSource.runtime);
        }
      }
    }
    
    return config;
  }
  
  /// Validates configuration against a schema
  static DsrtConfigValidationResult validateAgainstSchema(
    DsrtEngineConfig config,
    Map<String, dynamic> schema,
  ) {
    final errors = <String>[];
    final warnings = <String>[];
    
    for (final schemaEntry in schema.entries) {
      final sectionName = schemaEntry.key;
      final sectionSchema = schemaEntry.value;
      
      if (sectionSchema is Map) {
        final section = config.getSection(sectionName);
        if (section == null) {
          if (sectionSchema['required'] == true) {
            errors.add('Required section "$sectionName" is missing');
          }
          continue;
        }
        
        for (final fieldEntry in sectionSchema['fields']?.entries ?? [].cast<MapEntry>()) {
          final fieldName = fieldEntry.key;
          final fieldSchema = fieldEntry.value;
          
          if (fieldSchema is Map) {
            final value = section.getValue(fieldName);
            
            // Check required fields
            if (fieldSchema['required'] == true && value == null) {
              errors.add('Required field "$sectionName.$fieldName" is missing');
            }
            
            // Check type
            if (value != null && fieldSchema['type'] != null) {
              final expectedType = fieldSchema['type'];
              final actualType = value.runtimeType.toString().toLowerCase();
              
              if (!actualType.contains(expectedType.toLowerCase())) {
                warnings.add('Type mismatch for "$sectionName.$fieldName": '
                    'expected $expectedType, got $actualType');
              }
            }
            
            // Check constraints
            if (value != null && fieldSchema['constraints'] != null) {
              final constraints = fieldSchema['constraints'];
              
              if (constraints['min'] != null && value is num && value < constraints['min']) {
                errors.add('Value for "$sectionName.$fieldName" is less than minimum ${constraints['min']}');
              }
              
              if (constraints['max'] != null && value is num && value > constraints['max']) {
                errors.add('Value for "$sectionName.$fieldName" is greater than maximum ${constraints['max']}');
              }
            }
          }
        }
      }
    }
    
    return DsrtConfigValidationResult(
      isValid: errors.isEmpty,
      errors: errors,
      warnings: warnings,
    );
  }
}
