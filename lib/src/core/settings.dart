// lib/src/core/settings.dart

/// DSRT Engine - Settings Management System
/// 
/// Provides persistent settings management with categories, scopes,
/// and automatic synchronization capabilities.
/// 
/// @category Core
/// @version 1.0.0
/// @license MIT
/// @copyright DSRT Engine Team

library dsrt_engine.core.settings;

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;

import 'engine_config.dart';

/// Settings scope defines the visibility and persistence level
enum DsrtSettingsScope {
  /// Application-wide settings (persistent across sessions)
  application,
  
  /// User-specific settings (different per user)
  user,
  
  /// Project-specific settings (different per project)
  project,
  
  /// Session-specific settings (temporary, not persisted)
  session,
  
  /// Runtime-only settings (in-memory, not saved)
  runtime,
  
  /// Global settings (shared across all instances)
  global,
  
  /// Local settings (specific to local environment)
  local,
  
  /// Development settings (for development only)
  development,
  
  /// Production settings (for production only)
  production,
  
  /// Testing settings (for testing only)
  testing
}

/// Settings change event
class DsrtSettingsChangeEvent {
  /// Settings category
  final String category;
  
  /// Settings key
  final String key;
  
  /// Old value (may be null)
  final dynamic oldValue;
  
  /// New value
  final dynamic newValue;
  
  /// Change timestamp
  final DateTime timestamp;
  
  /// Change source
  final String source;
  
  /// Creates a settings change event
  DsrtSettingsChangeEvent({
    required this.category,
    required this.key,
    required this.oldValue,
    required this.newValue,
    required this.source,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();
  
  /// Creates a settings change event from a map
  factory DsrtSettingsChangeEvent.fromMap(Map<String, dynamic> map) {
    return DsrtSettingsChangeEvent(
      category: map['category'],
      key: map['key'],
      oldValue: map['oldValue'],
      newValue: map['newValue'],
      source: map['source'],
      timestamp: map['timestamp'] != null
          ? DateTime.parse(map['timestamp'])
          : null,
    );
  }
  
  /// Converts to a map
  Map<String, dynamic> toMap() {
    return {
      'category': category,
      'key': key,
      'oldValue': oldValue,
      'newValue': newValue,
      'source': source,
      'timestamp': timestamp.toIso8601String(),
    };
  }
  
  /// Checks if the value actually changed
  bool get hasChanged => oldValue != newValue;
  
  /// Gets a string representation
  @override
  String toString() {
    return 'SettingsChange[$category.$key]: $oldValue -> $newValue ($source)';
  }
}

/// Settings entry with metadata and constraints
class DsrtSettingsEntry {
  /// Entry key
  final String key;
  
  /// Entry value
  dynamic _value;
  
  /// Entry type
  final DsrtConfigType type;
  
  /// Entry category
  final String category;
  
  /// Entry scope
  final DsrtSettingsScope scope;
  
  /// Whether this setting is persistent
  final bool persistent;
  
  /// Default value
  final dynamic defaultValue;
  
  /// Minimum value (for numeric types)
  final dynamic minValue;
  
  /// Maximum value (for numeric types)
  final dynamic maxValue;
  
  /// Allowed values (for enum types)
  final List<dynamic>? allowedValues;
  
  /// Validation pattern (for string types)
  final String? validationPattern;
  
  /// Description of this setting
  final String description;
  
  /// Whether this setting is read-only
  final bool readOnly;
  
  /// Whether this setting is hidden from UI
  final bool hidden;
  
  /// Last modification timestamp
  DateTime _lastModified;
  
  /// Modification count
  int _modificationCount = 0;
  
  /// Creates a settings entry
  DsrtSettingsEntry({
    required this.key,
    required dynamic value,
    required this.type,
    required this.category,
    this.scope = DsrtSettingsScope.application,
    this.persistent = true,
    this.defaultValue,
    this.minValue,
    this.maxValue,
    this.allowedValues,
    this.validationPattern,
    this.description = '',
    this.readOnly = false,
    this.hidden = false,
    DateTime? lastModified,
  })  : _value = value,
        _lastModified = lastModified ?? DateTime.now() {
    // Validate initial value
    _validateValue(value);
  }
  
  /// Gets the current value
  dynamic get value => _value;
  
  /// Gets the last modification timestamp
  DateTime get lastModified => _lastModified;
  
  /// Gets the modification count
  int get modificationCount => _modificationCount;
  
  /// Gets the effective value (value if set, otherwise default)
  dynamic get effectiveValue => _value ?? defaultValue;
  
  /// Checks if the value is set
  bool get hasValue => _value != null;
  
  /// Checks if this entry has a default value
  bool get hasDefault => defaultValue != null;
  
  /// Sets the value with validation
  set value(dynamic newValue) {
    if (readOnly) {
      throw StateError('Cannot modify read-only setting: $key');
    }
    
    _validateValue(newValue);
    
    final oldValue = _value;
    _value = newValue;
    _lastModified = DateTime.now();
    _modificationCount++;
  }
  
  /// Resets the value to default
  void resetToDefault() {
    if (readOnly) {
      throw StateError('Cannot modify read-only setting: $key');
    }
    
    _value = defaultValue;
    _lastModified = DateTime.now();
    _modificationCount++;
  }
  
  /// Validates a value against this entry's constraints
  bool validateValue(dynamic value) {
    try {
      _validateValue(value);
      return true;
    } catch (_) {
      return false;
    }
  }
  
  /// Validates the current value
  bool validate() {
    return validateValue(_value);
  }
  
  /// Converts to a map
  Map<String, dynamic> toMap() {
    return {
      'key': key,
      'value': _value,
      'type': type.name,
      'category': category,
      'scope': scope.name,
      'persistent': persistent,
      'defaultValue': defaultValue,
      'minValue': minValue,
      'maxValue': maxValue,
      'allowedValues': allowedValues,
      'validationPattern': validationPattern,
      'description': description,
      'readOnly': readOnly,
      'hidden': hidden,
      'lastModified': _lastModified.toIso8601String(),
      'modificationCount': _modificationCount,
    };
  }
  
  /// Creates from a map
  factory DsrtSettingsEntry.fromMap(Map<String, dynamic> map) {
    return DsrtSettingsEntry(
      key: map['key'],
      value: map['value'],
      type: DsrtConfigType.values.firstWhere(
        (e) => e.name == map['type'],
        orElse: () => DsrtConfigType.dynamic,
      ),
      category: map['category'],
      scope: DsrtSettingsScope.values.firstWhere(
        (e) => e.name == map['scope'],
        orElse: () => DsrtSettingsScope.application,
      ),
      persistent: map['persistent'] ?? true,
      defaultValue: map['defaultValue'],
      minValue: map['minValue'],
      maxValue: map['maxValue'],
      allowedValues: map['allowedValues'],
      validationPattern: map['validationPattern'],
      description: map['description'] ?? '',
      readOnly: map['readOnly'] ?? false,
      hidden: map['hidden'] ?? false,
      lastModified: map['lastModified'] != null
          ? DateTime.parse(map['lastModified'])
          : null,
    );
  }
  
  /// Creates a copy with overrides
  DsrtSettingsEntry copyWith({
    String? key,
    dynamic value,
    DsrtConfigType? type,
    String? category,
    DsrtSettingsScope? scope,
    bool? persistent,
    dynamic defaultValue,
    dynamic minValue,
    dynamic maxValue,
    List<dynamic>? allowedValues,
    String? validationPattern,
    String? description,
    bool? readOnly,
    bool? hidden,
  }) {
    return DsrtSettingsEntry(
      key: key ?? this.key,
      value: value ?? this._value,
      type: type ?? this.type,
      category: category ?? this.category,
      scope: scope ?? this.scope,
      persistent: persistent ?? this.persistent,
      defaultValue: defaultValue ?? this.defaultValue,
      minValue: minValue ?? this.minValue,
      maxValue: maxValue ?? this.maxValue,
      allowedValues: allowedValues ?? this.allowedValues,
      validationPattern: validationPattern ?? this.validationPattern,
      description: description ?? this.description,
      readOnly: readOnly ?? this.readOnly,
      hidden: hidden ?? this.hidden,
      lastModified: _lastModified,
    );
  }
  
  /// Validates a value against type and constraints
  void _validateValue(dynamic value) {
    if (value == null) {
      if (defaultValue == null) {
        throw ArgumentError('Value cannot be null for setting: $key');
      }
      return;
    }
    
    // Type validation
    switch (type) {
      case DsrtConfigType.boolean:
        if (value is! bool) {
          throw ArgumentError('Expected boolean for setting: $key');
        }
        break;
      case DsrtConfigType.integer:
        if (value is! int) {
          throw ArgumentError('Expected integer for setting: $key');
        }
        if (minValue != null && value < minValue) {
          throw ArgumentError('Value $value is less than minimum $minValue for setting: $key');
        }
        if (maxValue != null && value > maxValue) {
          throw ArgumentError('Value $value is greater than maximum $maxValue for setting: $key');
        }
        break;
      case DsrtConfigType.double:
        if (value is! double && value is! int) {
          throw ArgumentError('Expected double for setting: $key');
        }
        final numValue = value.toDouble();
        if (minValue != null && numValue < minValue) {
          throw ArgumentError('Value $value is less than minimum $minValue for setting: $key');
        }
        if (maxValue != null && numValue > maxValue) {
          throw ArgumentError('Value $value is greater than maximum $maxValue for setting: $key');
        }
        break;
      case DsrtConfigType.string:
        if (value is! String) {
          throw ArgumentError('Expected string for setting: $key');
        }
        if (minValue != null && value.length < minValue) {
          throw ArgumentError('String length ${value.length} is less than minimum $minValue for setting: $key');
        }
        if (maxValue != null && value.length > maxValue) {
          throw ArgumentError('String length ${value.length} is greater than maximum $maxValue for setting: $key');
        }
        if (validationPattern != null) {
          final pattern = RegExp(validationPattern!);
          if (!pattern.hasMatch(value)) {
            throw ArgumentError('String does not match pattern $validationPattern for setting: $key');
          }
        }
        break;
      case DsrtConfigType.list:
        if (value is! List) {
          throw ArgumentError('Expected list for setting: $key');
        }
        if (minValue != null && value.length < minValue) {
          throw ArgumentError('List length ${value.length} is less than minimum $minValue for setting: $key');
        }
        if (maxValue != null && value.length > maxValue) {
          throw ArgumentError('List length ${value.length} is greater than maximum $maxValue for setting: $key');
        }
        break;
      case DsrtConfigType.map:
        if (value is! Map) {
          throw ArgumentError('Expected map for setting: $key');
        }
        break;
      case DsrtConfigType.enumeration:
        if (allowedValues != null && !allowedValues!.contains(value)) {
          throw ArgumentError('Value $value is not in allowed values $allowedValues for setting: $key');
        }
        break;
      case DsrtConfigType.color:
        if (value is! int) {
          throw ArgumentError('Expected color integer for setting: $key');
        }
        if (value < 0 || value > 0xFFFFFFFF) {
          throw ArgumentError('Color value out of range for setting: $key');
        }
        break;
      default:
        // Dynamic type accepts anything
        break;
    }
  }
}

/// Settings category groups related settings
class DsrtSettingsCategory {
  /// Category name
  final String name;
  
  /// Category description
  final String description;
  
  /// Category icon (optional)
  final String? icon;
  
  /// Category order (for sorting)
  final int order;
  
  /// Settings entries in this category
  final Map<String, DsrtSettingsEntry> entries;
  
  /// Creates a settings category
  DsrtSettingsCategory({
    required this.name,
    this.description = '',
    this.icon,
    this.order = 0,
    Map<String, DsrtSettingsEntry>? entries,
  }) : entries = entries ?? {};
  
  /// Adds an entry to this category
  void addEntry(DsrtSettingsEntry entry) {
    if (entry.category != name) {
      throw ArgumentError('Entry category ${entry.category} does not match category $name');
    }
    entries[entry.key] = entry;
  }
  
  /// Removes an entry from this category
  bool removeEntry(String key) {
    return entries.remove(key) != null;
  }
  
  /// Gets an entry by key
  DsrtSettingsEntry? getEntry(String key) {
    return entries[key];
  }
  
  /// Gets a value by key
  dynamic getValue(String key) {
    return entries[key]?.effectiveValue;
  }
  
  /// Sets a value for a key
  void setValue(String key, dynamic value, {String source = 'manual'}) {
    final entry = entries[key];
    if (entry == null) {
      throw ArgumentError('Setting not found: $key');
    }
    
    final oldValue = entry.value;
    entry.value = value;
    
    // Notify change
    DsrtSettingsManager.instance?.notifyChange(
      DsrtSettingsChangeEvent(
        category: name,
        key: key,
        oldValue: oldValue,
        newValue: value,
        source: source,
      ),
    );
  }
  
  /// Checks if this category contains a key
  bool hasKey(String key) {
    return entries.containsKey(key);
  }
  
  /// Gets all entry keys
  List<String> get entryKeys => entries.keys.toList();
  
  /// Gets all entries
  List<DsrtSettingsEntry> get entryList => entries.values.toList();
  
  /// Validates all entries in this category
  bool validate() {
    for (final entry in entries.values) {
      if (!entry.validate()) {
        return false;
      }
    }
    return true;
  }
  
  /// Converts to a map
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'icon': icon,
      'order': order,
      'entries': entries.map((key, entry) => MapEntry(key, entry.toMap())),
    };
  }
  
  /// Creates from a map
  factory DsrtSettingsCategory.fromMap(Map<String, dynamic> map) {
    final entries = <String, DsrtSettingsEntry>{};
    final entriesMap = map['entries'] as Map<String, dynamic>? ?? {};
    
    for (final entryEntry in entriesMap.entries) {
      entries[entryEntry.key] = DsrtSettingsEntry.fromMap(
        Map<String, dynamic>.from(entryEntry.value),
      );
    }
    
    return DsrtSettingsCategory(
      name: map['name'],
      description: map['description'] ?? '',
      icon: map['icon'],
      order: map['order'] ?? 0,
      entries: entries,
    );
  }
  
  /// Creates a copy with overrides
  DsrtSettingsCategory copyWith({
    String? name,
    String? description,
    String? icon,
    int? order,
    Map<String, DsrtSettingsEntry>? entries,
  }) {
    return DsrtSettingsCategory(
      name: name ?? this.name,
      description: description ?? this.description,
      icon: icon ?? this.icon,
      order: order ?? this.order,
      entries: entries ?? Map.from(this.entries),
    );
  }
}

/// Settings storage interface
abstract class DsrtSettingsStorage {
  /// Loads settings for a specific scope
  Future<Map<String, dynamic>> load(DsrtSettingsScope scope, String identifier);
  
  /// Saves settings for a specific scope
  Future<void> save(
    DsrtSettingsScope scope,
    String identifier,
    Map<String, dynamic> settings,
  );
  
  /// Deletes settings for a specific scope
  Future<void> delete(DsrtSettingsScope scope, String identifier);
  
  /// Lists all saved identifiers for a scope
  Future<List<String>> list(DsrtSettingsScope scope);
}

/// JSON file-based settings storage
class DsrtJsonSettingsStorage implements DsrtSettingsStorage {
  /// Base directory for settings storage
  final Directory baseDirectory;
  
  /// Creates JSON settings storage
  DsrtJsonSettingsStorage({Directory? baseDirectory})
      : baseDirectory = baseDirectory ??
            Directory('${Platform.environment['HOME'] ?? '.'}/.dsrt/settings');
  
  @override
  Future<Map<String, dynamic>> load(
    DsrtSettingsScope scope,
    String identifier,
  ) async {
    final file = _getSettingsFile(scope, identifier);
    
    if (!await file.exists()) {
      return {};
    }
    
    try {
      final content = await file.readAsString();
      return jsonDecode(content) as Map<String, dynamic>;
    } catch (e) {
      throw IOException('Failed to load settings: $e');
    }
  }
  
  @override
  Future<void> save(
    DsrtSettingsScope scope,
    String identifier,
    Map<String, dynamic> settings,
  ) async {
    final file = _getSettingsFile(scope, identifier);
    
    // Ensure directory exists
    await file.parent.create(recursive: true);
    
    try {
      final content = jsonEncode(settings);
      await file.writeAsString(content);
    } catch (e) {
      throw IOException('Failed to save settings: $e');
    }
  }
  
  @override
  Future<void> delete(DsrtSettingsScope scope, String identifier) async {
    final file = _getSettingsFile(scope, identifier);
    
    if (await file.exists()) {
      await file.delete();
    }
  }
  
  @override
  Future<List<String>> list(DsrtSettingsScope scope) async {
    final dir = _getSettingsDirectory(scope);
    
    if (!await dir.exists()) {
      return [];
    }
    
    final files = await dir.list().toList();
    return files
        .where((entity) => entity is File && entity.path.endsWith('.json'))
        .map((entity) => File(entity.path).uri.pathSegments.last)
        .map((filename) => filename.substring(0, filename.length - 5))
        .toList();
  }
  
  /// Gets the settings file for a scope and identifier
  File _getSettingsFile(DsrtSettingsScope scope, String identifier) {
    final dir = _getSettingsDirectory(scope);
    final safeIdentifier = identifier.replaceAll(RegExp(r'[^a-zA-Z0-9_-]'), '_');
    return File('${dir.path}/$safeIdentifier.json');
  }
  
  /// Gets the settings directory for a scope
  Directory _getSettingsDirectory(DsrtSettingsScope scope) {
    return Directory('${baseDirectory.path}/${scope.name}');
  }
}

/// Main settings manager
class DsrtSettingsManager {
  /// Singleton instance
  static DsrtSettingsManager? _instance;
  
  /// Gets the singleton instance
  static DsrtSettingsManager get instance {
    return _instance ??= DsrtSettingsManager._internal();
  }
  
  /// Settings categories
  final Map<String, DsrtSettingsCategory> _categories;
  
  /// Settings storage
  final DsrtSettingsStorage _storage;
  
  /// Settings change stream controller
  final StreamController<DsrtSettingsChangeEvent> _changeController;
  
  /// Pending changes to save
  final Map<String, Map<String, dynamic>> _pendingChanges;
  
  /// Auto-save timer
  Timer? _autoSaveTimer;
  
  /// Whether auto-save is enabled
  bool _autoSaveEnabled = true;
  
  /// Auto-save interval in seconds
  int _autoSaveInterval = 30;
  
  /// Creates the settings manager
  DsrtSettingsManager._internal({
    DsrtSettingsStorage? storage,
  })  : _categories = {},
        _storage = storage ?? DsrtJsonSettingsStorage(),
        _changeController = StreamController.broadcast(),
        _pendingChanges = {} {
    // Initialize with default categories
    _initializeDefaultCategories();
    
    // Start auto-save timer
    _startAutoSaveTimer();
  }
  
  /// Gets a category by name
  DsrtSettingsCategory? getCategory(String name) {
    return _categories[name];
  }
  
  /// Creates a new category
  DsrtSettingsCategory createCategory({
    required String name,
    String description = '',
    String? icon,
    int order = 0,
  }) {
    if (_categories.containsKey(name)) {
      throw ArgumentError('Category "$name" already exists');
    }
    
    final category = DsrtSettingsCategory(
      name: name,
      description: description,
      icon: icon,
      order: order,
    );
    
    _categories[name] = category;
    return category;
  }
  
  /// Removes a category
  bool removeCategory(String name) {
    return _categories.remove(name) != null;
  }
  
  /// Gets a setting value
  dynamic getValue(String category, String key) {
    final cat = _categories[category];
    if (cat == null) {
      throw ArgumentError('Category "$category" not found');
    }
    
    return cat.getValue(key);
  }
  
  /// Sets a setting value
  void setValue(
    String category,
    String key,
    dynamic value, {
    String source = 'manual',
  }) {
    final cat = _categories[category];
    if (cat == null) {
      throw ArgumentError('Category "$category" not found');
    }
    
    cat.setValue(key, value, source: source);
    
    // Mark for auto-save if persistent
    final entry = cat.getEntry(key);
    if (entry != null && entry.persistent) {
      _markForSave(category, key, value);
    }
  }
  
  /// Checks if a setting exists
  bool hasValue(String category, String key) {
    final cat = _categories[category];
    return cat != null && cat.hasKey(key);
  }
  
  /// Resets a setting to its default value
  void resetValue(String category, String key, {String source = 'manual'}) {
    final cat = _categories[category];
    if (cat == null) {
      throw ArgumentError('Category "$category" not found');
    }
    
    final entry = cat.getEntry(key);
    if (entry == null) {
      throw ArgumentError('Setting "$key" not found in category "$category"');
    }
    
    final oldValue = entry.value;
    entry.resetToDefault();
    
    // Notify change
    notifyChange(
      DsrtSettingsChangeEvent(
        category: category,
        key: key,
        oldValue: oldValue,
        newValue: entry.value,
        source: source,
      ),
    );
    
    // Mark for save
    _markForSave(category, key, entry.value);
  }
  
  /// Resets all settings to defaults
  void resetAll({String source = 'manual'}) {
    for (final category in _categories.values) {
      for (final entry in category.entries.values) {
        final oldValue = entry.value;
        entry.resetToDefault();
        
        // Notify change
        notifyChange(
          DsrtSettingsChangeEvent(
            category: category.name,
            key: entry.key,
            oldValue: oldValue,
            newValue: entry.value,
            source: source,
          ),
        );
        
        // Mark for save
        _markForSave(category.name, entry.key, entry.value);
      }
    }
  }
  
  /// Validates all settings
  bool validate() {
    for (final category in _categories.values) {
      if (!category.validate()) {
        return false;
      }
    }
    return true;
  }
  
  /// Gets settings change stream
  Stream<DsrtSettingsChangeEvent> get changes => _changeController.stream;
  
  /// Notifies a settings change
  void notifyChange(DsrtSettingsChangeEvent event) {
    _changeController.add(event);
  }
  
  /// Loads settings from storage
  Future<void> loadFromStorage({
    DsrtSettingsScope scope = DsrtSettingsScope.user,
    String identifier = 'default',
  }) async {
    try {
      final settings = await _storage.load(scope, identifier);
      
      // Apply loaded settings
      for (final categoryEntry in settings.entries) {
        final categoryName = categoryEntry.key;
        final categorySettings = categoryEntry.value as Map<String, dynamic>;
        
        var category = _categories[categoryName];
        if (category == null) {
          category = createCategory(name: categoryName);
        }
        
        for (final settingEntry in categorySettings.entries) {
          final key = settingEntry.key;
          final value = settingEntry.value;
          
          if (category.hasKey(key)) {
            try {
              category.setValue(key, value, source: 'storage');
            } catch (_) {
              // Ignore invalid stored values
            }
          }
        }
      }
    } catch (e) {
      // Log error but continue
      print('Failed to load settings: $e');
    }
  }
  
  /// Saves settings to storage
  Future<void> saveToStorage({
    DsrtSettingsScope scope = DsrtSettingsScope.user,
    String identifier = 'default',
  }) async {
    try {
      // Get all persistent settings
      final settings = <String, Map<String, dynamic>>{};
      
      for (final category in _categories.values) {
        final categorySettings = <String, dynamic>{};
        
        for (final entry in category.entries.values) {
          if (entry.persistent) {
            categorySettings[entry.key] = entry.value;
          }
        }
        
        if (categorySettings.isNotEmpty) {
          settings[category.name] = categorySettings;
        }
      }
      
      await _storage.save(scope, identifier, settings);
      
      // Clear pending changes
      _pendingChanges.clear();
    } catch (e) {
      throw IOException('Failed to save settings: $e');
    }
  }
  
  /// Enables or disables auto-save
  void setAutoSaveEnabled(bool enabled) {
    _autoSaveEnabled = enabled;
    
    if (enabled) {
      _startAutoSaveTimer();
    } else {
      _stopAutoSaveTimer();
    }
  }
  
  /// Sets auto-save interval
  void setAutoSaveInterval(int seconds) {
    _autoSaveInterval = math.max(1, seconds);
    
    if (_autoSaveEnabled) {
      _stopAutoSaveTimer();
      _startAutoSaveTimer();
    }
  }
  
  /// Gets all category names
  List<String> get categoryNames => _categories.keys.toList();
  
  /// Gets all categories sorted by order
  List<DsrtSettingsCategory> get categoriesSorted {
    return _categories.values.toList()
      ..sort((a, b) => a.order.compareTo(b.order));
  }
  
  /// Closes the settings manager
  void close() {
    // Save pending changes
    if (_pendingChanges.isNotEmpty) {
      _savePendingChanges();
    }
    
    // Stop auto-save timer
    _stopAutoSaveTimer();
    
    // Close change stream
    _changeController.close();
    
    // Clear instance
    _instance = null;
  }
  
  /// Initializes default categories and settings
  void _initializeDefaultCategories() {
    // Graphics settings
    final graphicsCategory = createCategory(
      name: 'graphics',
      description: 'Graphics and rendering settings',
      icon: 'palette',
      order: 100,
    );
    
    graphicsCategory.addEntry(DsrtSettingsEntry(
      key: 'resolution',
      value: '1920x1080',
      type: DsrtConfigType.string,
      category: 'graphics',
      description: 'Screen resolution',
      allowedValues: [
        '800x600',
        '1024x768',
        '1280x720',
        '1366x768',
        '1600x900',
        '1920x1080',
        '2560x1440',
        '3840x2160',
      ],
    ));
    
    graphicsCategory.addEntry(DsrtSettingsEntry(
      key: 'fullscreen',
      value: false,
      type: DsrtConfigType.boolean,
      category: 'graphics',
      description: 'Enable fullscreen mode',
    ));
    
    graphicsCategory.addEntry(DsrtSettingsEntry(
      key: 'vsync',
      value: true,
      type: DsrtConfigType.boolean,
      category: 'graphics',
      description: 'Enable vertical synchronization',
    ));
    
    graphicsCategory.addEntry(DsrtSettingsEntry(
      key: 'textureQuality',
      value: 'high',
      type: DsrtConfigType.string,
      category: 'graphics',
      description: 'Texture quality',
      allowedValues: ['low', 'medium', 'high', 'ultra'],
    ));
    
    // Audio settings
    final audioCategory = createCategory(
      name: 'audio',
      description: 'Audio and sound settings',
      icon: 'volume-high',
      order: 200,
    );
    
    audioCategory.addEntry(DsrtSettingsEntry(
      key: 'masterVolume',
      value: 0.8,
      type: DsrtConfigType.double,
      category: 'audio',
      description: 'Master volume level',
      minValue: 0.0,
      maxValue: 1.0,
    ));
    
    audioCategory.addEntry(DsrtSettingsEntry(
      key: 'musicVolume',
      value: 0.7,
      type: DsrtConfigType.double,
      category: 'audio',
      description: 'Music volume level',
      minValue: 0.0,
      maxValue: 1.0,
    ));
    
    audioCategory.addEntry(DsrtSettingsEntry(
      key: 'sfxVolume',
      value: 0.9,
      type: DsrtConfigType.double,
      category: 'audio',
      description: 'Sound effects volume level',
      minValue: 0.0,
      maxValue: 1.0,
    ));
    
    // Controls settings
    final controlsCategory = createCategory(
      name: 'controls',
      description: 'Input and control settings',
      icon: 'gamepad',
      order: 300,
    );
    
    controlsCategory.addEntry(DsrtSettingsEntry(
      key: 'mouseSensitivity',
      value: 1.0,
      type: DsrtConfigType.double,
      category: 'controls',
      description: 'Mouse sensitivity',
      minValue: 0.1,
      maxValue: 5.0,
    ));
    
    controlsCategory.addEntry(DsrtSettingsEntry(
      key: 'invertMouseY',
      value: false,
      type: DsrtConfigType.boolean,
      category: 'controls',
      description: 'Invert mouse Y axis',
    ));
    
    // Game settings
    final gameCategory = createCategory(
      name: 'game',
      description: 'Game-specific settings',
      icon: 'controller',
      order: 400,
    );
    
    gameCategory.addEntry(DsrtSettingsEntry(
      key: 'difficulty',
      value: 'normal',
      type: DsrtConfigType.string,
      category: 'game',
      description: 'Game difficulty',
      allowedValues: ['easy', 'normal', 'hard', 'expert'],
    ));
    
    // Performance settings
    final performanceCategory = createCategory(
      name: 'performance',
      description: 'Performance and optimization settings',
      icon: 'speedometer',
      order: 500,
    );
    
    performanceCategory.addEntry(DsrtSettingsEntry(
      key: 'maxFps',
      value: 60,
      type: DsrtConfigType.integer,
      category: 'performance',
      description: 'Maximum frames per second (0 for unlimited)',
      minValue: 0,
      maxValue: 1000,
    ));
    
    performanceCategory.addEntry(DsrtSettingsEntry(
      key: 'shadowQuality',
      value: 'medium',
      type: DsrtConfigType.string,
      category: 'performance',
      description: 'Shadow quality',
      allowedValues: ['low', 'medium', 'high', 'ultra'],
    ));
  }
  
  /// Marks a setting for auto-save
  void _markForSave(String category, String key, dynamic value) {
    if (!_pendingChanges.containsKey(category)) {
      _pendingChanges[category] = {};
    }
    _pendingChanges[category]![key] = value;
  }
  
  /// Saves pending changes
  Future<void> _savePendingChanges() async {
    if (_pendingChanges.isEmpty) {
      return;
    }
    
    try {
      await saveToStorage();
    } catch (e) {
      print('Auto-save failed: $e');
    }
  }
  
  /// Starts the auto-save timer
  void _startAutoSaveTimer() {
    _stopAutoSaveTimer();
    
    _autoSaveTimer = Timer.periodic(
      Duration(seconds: _autoSaveInterval),
      (_) async {
        if (_autoSaveEnabled && _pendingChanges.isNotEmpty) {
          await _savePendingChanges();
        }
      },
    );
  }
  
  /// Stops the auto-save timer
  void _stopAutoSaveTimer() {
    _autoSaveTimer?.cancel();
    _autoSaveTimer = null;
  }
}

/// Settings utilities
class DsrtSettingsUtils {
  /// Creates a settings manager with default configuration
  static DsrtSettingsManager createDefaultManager() {
    return DsrtSettingsManager.instance;
  }
  
  /// Migrates settings from old format to new format
  static Future<void> migrateSettings(
    Map<String, dynamic> oldSettings,
    DsrtSettingsManager manager,
  ) async {
    // Example migration logic
    // This would be customized based on actual migration needs
    
    for (final entry in oldSettings.entries) {
      final key = entry.key;
      final value = entry.value;
      
      // Parse old key format (e.g., "graphics.resolution")
      final parts = key.split('.');
      if (parts.length >= 2) {
        final category = parts[0];
        final settingKey = parts.sublist(1).join('.');
        
        try {
          manager.setValue(category, settingKey, value, source: 'migration');
        } catch (_) {
          // Ignore migration errors
        }
      }
    }
  }
  
  /// Exports settings to a portable format
  static Map<String, dynamic> exportSettings(DsrtSettingsManager manager) {
    final export = <String, dynamic>{};
    
    for (final category in manager.categoryNames) {
      final cat = manager.getCategory(category);
      if (cat != null) {
        final categoryExport = <String, dynamic>{};
        
        for (final entry in cat.entryList) {
          if (entry.persistent && !entry.hidden) {
            categoryExport[entry.key] = {
              'value': entry.value,
              'type': entry.type.name,
              'description': entry.description,
            };
          }
        }
        
        if (categoryExport.isNotEmpty) {
          export[category] = categoryExport;
        }
      }
    }
    
    return {
      'version': '1.0.0',
      'exportDate': DateTime.now().toIso8601String(),
      'settings': export,
    };
  }
  
  /// Imports settings from a portable format
  static Future<void> importSettings(
    Map<String, dynamic> importData,
    DsrtSettingsManager manager,
  ) async {
    final version = importData['version'] as String? ?? '1.0.0';
    final settings = importData['settings'] as Map<String, dynamic>? ?? {};
    
    // Version-specific import logic
    if (version.startsWith('1.')) {
      for (final categoryEntry in settings.entries) {
        final category = categoryEntry.key;
        final categorySettings = categoryEntry.value as Map<String, dynamic>;
        
        for (final settingEntry in categorySettings.entries) {
          final key = settingEntry.key;
          final settingData = settingEntry.value as Map<String, dynamic>;
          final value = settingData['value'];
          
          try {
            manager.setValue(category, key, value, source: 'import');
          } catch (_) {
            // Ignore import errors
          }
        }
      }
    }
  }
}
