// lib/src/core/version.dart

/// DSRT Engine - Version Management System
/// 
/// Provides comprehensive version tracking, comparison, and validation
/// for the DSRT Engine and its components.
/// 
/// @category Core
/// @version 1.0.0
/// @license MIT
/// @copyright DSRT Engine Team

library dsrt_engine.core.version;

import 'dart:math' as math;

/// Version component type for semantic versioning
enum DsrtVersionComponent {
  /// Major version (breaking changes)
  major,
  
  /// Minor version (new features, backward compatible)
  minor,
  
  /// Patch version (bug fixes)
  patch,
  
  /// Pre-release identifier
  prerelease,
  
  /// Build metadata
  build
}

/// Represents a semantic version (SemVer) with parsing, comparison,
/// and validation capabilities.
class DsrtVersion implements Comparable<DsrtVersion> {
  /// Major version number
  final int major;
  
  /// Minor version number
  final int minor;
  
  /// Patch version number
  final int patch;
  
  /// Pre-release identifier (may be null)
  final String? prerelease;
  
  /// Build metadata (may be null)
  final String? build;
  
  /// Creates a new version instance.
  /// 
  /// [major]: Major version number (non-negative)
  /// [minor]: Minor version number (non-negative)
  /// [patch]: Patch version number (non-negative)
  /// [prerelease]: Optional pre-release identifier
  /// [build]: Optional build metadata
  /// 
  /// Throws [ArgumentError] if any version component is negative.
  factory DsrtVersion(
    int major,
    int minor,
    int patch, {
    String? prerelease,
    String? build,
  }) {
    // Validate version components
    _validateVersionComponent(major, 'major');
    _validateVersionComponent(minor, 'minor');
    _validateVersionComponent(patch, 'patch');
    
    // Validate pre-release identifier if provided
    if (prerelease != null && prerelease.isNotEmpty) {
      _validatePreReleaseIdentifier(prerelease);
    }
    
    // Validate build metadata if provided
    if (build != null && build.isNotEmpty) {
      _validateBuildMetadata(build);
    }
    
    return DsrtVersion._internal(
      major,
      minor,
      patch,
      prerelease,
      build,
    );
  }
  
  /// Internal constructor for validated data
  const DsrtVersion._internal(
    this.major,
    this.minor,
    this.patch,
    this.prerelease,
    this.build,
  );
  
  /// Parses a version string into a DsrtVersion instance.
  /// 
  /// [versionString]: Version string in SemVer format (e.g., "1.2.3-alpha+build")
  /// 
  /// Returns a DsrtVersion instance.
  /// 
  /// Throws [FormatException] if the string is not valid SemVer.
  factory DsrtVersion.parse(String versionString) {
    if (versionString.isEmpty) {
      throw FormatException('Version string cannot be empty');
    }
    
    // Match SemVer pattern
    final regex = RegExp(
      r'^(0|[1-9]\d*)\.(0|[1-9]\d*)\.(0|[1-9]\d*)' // Major.minor.patch
      r'(?:-([0-9A-Za-z-]+(?:\.[0-9A-Za-z-]+)*))?' // Pre-release
      r'(?:\+([0-9A-Za-z-]+(?:\.[0-9A-Za-z-]+)*))?$' // Build metadata
    );
    
    final match = regex.firstMatch(versionString);
    if (match == null) {
      throw FormatException(
        'Invalid version format: $versionString. Expected format: major.minor.patch[-prerelease][+build]',
      );
    }
    
    try {
      final major = int.parse(match[1]!);
      final minor = int.parse(match[2]!);
      final patch = int.parse(match[3]!);
      final prerelease = match[4];
      final build = match[5];
      
      return DsrtVersion(
        major,
        minor,
        patch,
        prerelease: prerelease,
        build: build,
      );
    } catch (e) {
      throw FormatException(
        'Failed to parse version components: $versionString',
        versionString,
      );
    }
  }
  
  /// Creates a version from a version code integer.
  /// 
  /// [versionCode]: Version code in format: major * 10000 + minor * 100 + patch
  /// [prerelease]: Optional pre-release identifier
  /// [build]: Optional build metadata
  /// 
  /// Returns a DsrtVersion instance.
  factory DsrtVersion.fromCode(
    int versionCode, {
    String? prerelease,
    String? build,
  }) {
    if (versionCode < 0) {
      throw ArgumentError('Version code must be non-negative');
    }
    
    final major = versionCode ~/ 10000;
    final minor = (versionCode % 10000) ~/ 100;
    final patch = versionCode % 100;
    
    return DsrtVersion(
      major,
      minor,
      patch,
      prerelease: prerelease,
      build: build,
    );
  }
  
  /// Gets the version component at the specified index.
  /// 
  /// [index]: Index of the component (0=major, 1=minor, 2=patch)
  /// 
  /// Returns the component value.
  /// 
  /// Throws [RangeError] if index is out of bounds.
  int operator [](int index) {
    switch (index) {
      case 0:
        return major;
      case 1:
        return minor;
      case 2:
        return patch;
      default:
        throw RangeError.index(index, this, 'index', 'Index must be 0, 1, or 2');
    }
  }
  
  /// Compares this version with another version.
  /// 
  /// [other]: The version to compare with
  /// 
  /// Returns:
  /// - Negative if this version is older than [other]
  /// - Zero if versions are equal
  /// - Positive if this version is newer than [other]
  /// 
  /// Note: Build metadata is ignored in comparison.
  @override
  int compareTo(DsrtVersion other) {
    // Compare major version
    if (major != other.major) {
      return major.compareTo(other.major);
    }
    
    // Compare minor version
    if (minor != other.minor) {
      return minor.compareTo(other.minor);
    }
    
    // Compare patch version
    if (patch != other.patch) {
      return patch.compareTo(other.patch);
    }
    
    // Compare pre-release identifiers
    return _comparePreRelease(prerelease, other.prerelease);
  }
  
  /// Checks if this version satisfies a version range.
  /// 
  /// [range]: Version range specification
  /// 
  /// Returns true if this version is within the specified range.
  bool satisfies(String range) {
    try {
      final parsedRange = DsrtVersionRange.parse(range);
      return parsedRange.contains(this);
    } catch (e) {
      return false;
    }
  }
  
  /// Checks if this version is compatible with another version
  /// based on semantic versioning rules.
  /// 
  /// [other]: Version to check compatibility with
  /// 
  /// Returns true if versions are compatible.
  bool isCompatibleWith(DsrtVersion other) {
    // Same major version and this version >= other version
    return major == other.major && compareTo(other) >= 0;
  }
  
  /// Checks if this version is a pre-release version.
  bool get isPreRelease => prerelease != null && prerelease!.isNotEmpty;
  
  /// Checks if this version is a stable release.
  bool get isStable => !isPreRelease;
  
  /// Gets the version code as integer.
  /// 
  /// Format: major * 10000 + minor * 100 + patch
  int get versionCode => major * 10000 + minor * 100 + patch;
  
  /// Gets the next version based on the specified component.
  /// 
  /// [component]: Component to increment
  /// 
  /// Returns a new version with the specified component incremented
  /// and lower components reset to zero.
  DsrtVersion nextVersion(DsrtVersionComponent component) {
    switch (component) {
      case DsrtVersionComponent.major:
        return DsrtVersion(major + 1, 0, 0);
      case DsrtVersionComponent.minor:
        return DsrtVersion(major, minor + 1, 0);
      case DsrtVersionComponent.patch:
        return DsrtVersion(major, minor, patch + 1);
      case DsrtVersionComponent.prerelease:
        throw StateError('Cannot automatically generate next pre-release');
      case DsrtVersionComponent.build:
        throw StateError('Cannot automatically generate next build');
    }
  }
  
  /// Gets the string representation of this version.
  @override
  String toString() {
    final buffer = StringBuffer();
    buffer.write('$major.$minor.$patch');
    
    if (prerelease != null && prerelease!.isNotEmpty) {
      buffer.write('-');
      buffer.write(prerelease);
    }
    
    if (build != null && build!.isNotEmpty) {
      buffer.write('+');
      buffer.write(build);
    }
    
    return buffer.toString();
  }
  
  /// Gets the hash code for this version.
  @override
  int get hashCode {
    return Object.hash(
      major,
      minor,
      patch,
      prerelease,
      build,
    );
  }
  
  /// Checks equality with another object.
  @override
  bool operator ==(Object other) {
    return other is DsrtVersion &&
        major == other.major &&
        minor == other.minor &&
        patch == other.patch &&
        prerelease == other.prerelease &&
        build == other.build;
  }
  
  /// Validates a version component.
  static void _validateVersionComponent(int value, String name) {
    if (value < 0) {
      throw ArgumentError('$name version must be non-negative: $value');
    }
  }
  
  /// Validates a pre-release identifier.
  static void _validatePreReleaseIdentifier(String identifier) {
    final parts = identifier.split('.');
    
    for (final part in parts) {
      if (part.isEmpty) {
        throw ArgumentError('Pre-release identifier part cannot be empty');
      }
      
      // Check if part contains only alphanumeric characters and hyphens
      if (!RegExp(r'^[0-9A-Za-z-]+$').hasMatch(part)) {
        throw ArgumentError(
          'Pre-release identifier part contains invalid characters: $part',
        );
      }
      
      // Numeric identifiers must not have leading zeros
      if (RegExp(r'^\d+$').hasMatch(part)) {
        if (part.length > 1 && part.startsWith('0')) {
          throw ArgumentError(
            'Numeric pre-release identifier cannot have leading zeros: $part',
          );
        }
      }
    }
  }
  
  /// Validates build metadata.
  static void _validateBuildMetadata(String metadata) {
    final parts = metadata.split('.');
    
    for (final part in parts) {
      if (part.isEmpty) {
        throw ArgumentError('Build metadata part cannot be empty');
      }
      
      // Check if part contains only alphanumeric characters and hyphens
      if (!RegExp(r'^[0-9A-Za-z-]+$').hasMatch(part)) {
        throw ArgumentError(
          'Build metadata part contains invalid characters: $part',
        );
      }
    }
  }
  
  /// Compares pre-release identifiers according to SemVer rules.
  static int _comparePreRelease(String? a, String? b) {
    // Stable releases have higher precedence than pre-releases
    if (a == null && b == null) return 0;
    if (a == null) return 1; // This is stable, other is pre-release
    if (b == null) return -1; // This is pre-release, other is stable
    
    final aParts = a.split('.');
    final bParts = b.split('.');
    
    final length = math.max(aParts.length, bParts.length);
    
    for (var i = 0; i < length; i++) {
      final aPart = i < aParts.length ? aParts[i] : null;
      final bPart = i < bParts.length ? bParts[i] : null;
      
      // If one identifier has more parts, it has higher precedence
      if (aPart == null) return -1;
      if (bPart == null) return 1;
      
      final aIsNumeric = RegExp(r'^\d+$').hasMatch(aPart);
      final bIsNumeric = RegExp(r'^\d+$').hasMatch(bPart);
      
      // Numeric identifiers have lower precedence than non-numeric
      if (aIsNumeric && !bIsNumeric) return -1;
      if (!aIsNumeric && bIsNumeric) return 1;
      
      if (aIsNumeric && bIsNumeric) {
        final aNum = int.parse(aPart);
        final bNum = int.parse(bPart);
        final comparison = aNum.compareTo(bNum);
        if (comparison != 0) return comparison;
      } else {
        final comparison = aPart.compareTo(bPart);
        if (comparison != 0) return comparison;
      }
    }
    
    return 0;
  }
}

/// Represents a version range with inclusive/exclusive bounds.
class DsrtVersionRange {
  /// Minimum version (inclusive)
  final DsrtVersion min;
  
  /// Maximum version (inclusive)
  final DsrtVersion max;
  
  /// Whether the minimum bound is inclusive
  final bool minInclusive;
  
  /// Whether the maximum bound is inclusive
  final bool maxInclusive;
  
  /// Creates a version range.
  /// 
  /// [min]: Minimum version
  /// [max]: Maximum version
  /// [minInclusive]: Whether minimum bound is inclusive (default: true)
  /// [maxInclusive]: Whether maximum bound is inclusive (default: true)
  /// 
  /// Throws [ArgumentError] if min > max.
  DsrtVersionRange({
    required this.min,
    required this.max,
    this.minInclusive = true,
    this.maxInclusive = true,
  }) {
    if (min.compareTo(max) > 0) {
      throw ArgumentError('Minimum version cannot be greater than maximum version');
    }
  }
  
  /// Parses a version range string.
  /// 
  /// Supported formats:
  /// - "1.2.3": Exact version
  /// - "^1.2.3": Compatible with 1.2.3 (>=1.2.3 <2.0.0)
  /// - "~1.2.3": Approximately equivalent to 1.2.3 (>=1.2.3 <1.3.0)
  /// - ">=1.2.3 <2.0.0": Explicit range
  /// - "1.2.3 - 2.0.0": Inclusive range
  /// 
  /// [range]: Range specification string
  /// 
  /// Returns a DsrtVersionRange instance.
  /// 
  /// Throws [FormatException] if the range string is invalid.
  factory DsrtVersionRange.parse(String range) {
    if (range.isEmpty) {
      throw FormatException('Version range cannot be empty');
    }
    
    // Trim whitespace
    range = range.trim();
    
    // Check for exact version
    if (!range.contains(RegExp(r'[<>=^~\-]'))) {
      try {
        final version = DsrtVersion.parse(range);
        return DsrtVersionRange(
          min: version,
          max: version,
        );
      } catch (e) {
        throw FormatException('Invalid version range: $range', range);
      }
    }
    
    // Check for caret (^) range
    if (range.startsWith('^')) {
      final versionString = range.substring(1);
      try {
        final version = DsrtVersion.parse(versionString);
        return DsrtVersionRange._caretRange(version);
      } catch (e) {
        throw FormatException('Invalid caret range: $range', range);
      }
    }
    
    // Check for tilde (~) range
    if (range.startsWith('~')) {
      final versionString = range.substring(1);
      try {
        final version = DsrtVersion.parse(versionString);
        return DsrtVersionRange._tildeRange(version);
      } catch (e) {
        throw FormatException('Invalid tilde range: $range', range);
      }
    }
    
    // Check for hyphen range
    if (range.contains(' - ')) {
      final parts = range.split(' - ');
      if (parts.length != 2) {
        throw FormatException('Invalid hyphen range format: $range', range);
      }
      
      try {
        final minVersion = DsrtVersion.parse(parts[0].trim());
        final maxVersion = DsrtVersion.parse(parts[1].trim());
        
        return DsrtVersionRange(
          min: minVersion,
          max: maxVersion,
        );
      } catch (e) {
        throw FormatException('Invalid hyphen range: $range', range);
      }
    }
    
    // Parse as comparison range
    return _parseComparisonRange(range);
  }
  
  /// Checks if this range contains the specified version.
  /// 
  /// [version]: Version to check
  /// 
  /// Returns true if the version is within this range.
  bool contains(DsrtVersion version) {
    final minComparison = version.compareTo(min);
    final maxComparison = version.compareTo(max);
    
    final satisfiesMin = minInclusive ? minComparison >= 0 : minComparison > 0;
    final satisfiesMax = maxInclusive ? maxComparison <= 0 : maxComparison < 0;
    
    return satisfiesMin && satisfiesMax;
  }
  
  /// Checks if this range intersects with another range.
  /// 
  /// [other]: Other range to check
  /// 
  /// Returns true if the ranges intersect.
  bool intersects(DsrtVersionRange other) {
    // Check if any part of the ranges overlap
    final thisContainsOtherMin = contains(other.min);
    final thisContainsOtherMax = contains(other.max);
    final otherContainsThisMin = other.contains(min);
    final otherContainsThisMax = other.contains(max);
    
    return thisContainsOtherMin ||
        thisContainsOtherMax ||
        otherContainsThisMin ||
        otherContainsThisMax ||
        (min.compareTo(other.max) == 0 && minInclusive && other.maxInclusive) ||
        (max.compareTo(other.min) == 0 && maxInclusive && other.minInclusive);
  }
  
  /// Gets the string representation of this range.
  @override
  String toString() {
    final minOperator = minInclusive ? '>=' : '>';
    final maxOperator = maxInclusive ? '<=' : '<';
    
    return '$minOperator $min && $maxOperator $max';
  }
  
  /// Creates a caret (^) range.
  static DsrtVersionRange _caretRange(DsrtVersion version) {
    if (version.major > 0) {
      // ^1.2.3 -> >=1.2.3 <2.0.0
      return DsrtVersionRange(
        min: version,
        max: DsrtVersion(version.major + 1, 0, 0),
        maxInclusive: false,
      );
    } else if (version.minor > 0) {
      // ^0.2.3 -> >=0.2.3 <0.3.0
      return DsrtVersionRange(
        min: version,
        max: DsrtVersion(0, version.minor + 1, 0),
        maxInclusive: false,
      );
    } else {
      // ^0.0.3 -> >=0.0.3 <0.0.4
      return DsrtVersionRange(
        min: version,
        max: DsrtVersion(0, 0, version.patch + 1),
        maxInclusive: false,
      );
    }
  }
  
  /// Creates a tilde (~) range.
  static DsrtVersionRange _tildeRange(DsrtVersion version) {
    if (version.major > 0) {
      // ~1.2.3 -> >=1.2.3 <1.3.0
      return DsrtVersionRange(
        min: version,
        max: DsrtVersion(version.major, version.minor + 1, 0),
        maxInclusive: false,
      );
    } else if (version.minor > 0) {
      // ~0.2.3 -> >=0.2.3 <0.3.0
      return DsrtVersionRange(
        min: version,
        max: DsrtVersion(0, version.minor + 1, 0),
        maxInclusive: false,
      );
    } else {
      // ~0.0.3 -> >=0.0.3 <0.0.4
      return DsrtVersionRange(
        min: version,
        max: DsrtVersion(0, 0, version.patch + 1),
        maxInclusive: false,
      );
    }
  }
  
  /// Parses a comparison-based range.
  static DsrtVersionRange _parseComparisonRange(String range) {
    // Split by && to handle multiple comparisons
    final parts = range.split('&&').map((p) => p.trim()).toList();
    
    DsrtVersion? minVersion;
    DsrtVersion? maxVersion;
    bool minInclusive = true;
    bool maxInclusive = true;
    
    for (final part in parts) {
      if (part.startsWith('>=')) {
        final versionString = part.substring(2).trim();
        final version = DsrtVersion.parse(versionString);
        minVersion = version;
        minInclusive = true;
      } else if (part.startsWith('>')) {
        final versionString = part.substring(1).trim();
        final version = DsrtVersion.parse(versionString);
        minVersion = version;
        minInclusive = false;
      } else if (part.startsWith('<=')) {
        final versionString = part.substring(2).trim();
        final version = DsrtVersion.parse(versionString);
        maxVersion = version;
        maxInclusive = true;
      } else if (part.startsWith('<')) {
        final versionString = part.substring(1).trim();
        final version = DsrtVersion.parse(versionString);
        maxVersion = version;
        maxInclusive = false;
      } else if (part.startsWith('=')) {
        final versionString = part.substring(1).trim();
        final version = DsrtVersion.parse(versionString);
        minVersion = version;
        maxVersion = version;
        minInclusive = true;
        maxInclusive = true;
      } else {
        throw FormatException('Invalid comparison operator in range: $part', range);
      }
    }
    
    if (minVersion == null && maxVersion == null) {
      throw FormatException('No valid version constraints found in range: $range', range);
    }
    
    minVersion ??= DsrtVersion(0, 0, 0);
    maxVersion ??= DsrtVersion(999, 999, 999);
    
    return DsrtVersionRange(
      min: minVersion,
      max: maxVersion,
      minInclusive: minInclusive,
      maxInclusive: maxInclusive,
    );
  }
}

/// Version information for a specific engine component.
class DsrtComponentVersion {
  /// Component name
  final String name;
  
  /// Component version
  final DsrtVersion version;
  
  /// Component description
  final String description;
  
  /// Component dependencies
  final Map<String, DsrtVersionRange> dependencies;
  
  /// Creates component version information.
  DsrtComponentVersion({
    required this.name,
    required this.version,
    required this.description,
    this.dependencies = const {},
  });
  
  /// Checks if this component is compatible with another component version.
  /// 
  /// [other]: Other component version to check
  /// 
  /// Returns true if components are compatible.
  bool isCompatibleWith(DsrtComponentVersion other) {
    // Check if other component is a dependency
    final dependencyRange = dependencies[other.name];
    if (dependencyRange != null) {
      return dependencyRange.contains(other.version);
    }
    
    return true;
  }
  
  /// Gets the string representation.
  @override
  String toString() {
    return '$name $version';
  }
}

/// Manages engine-wide version information and compatibility.
class DsrtVersionManager {
  /// Engine core version
  final DsrtComponentVersion engineCore;
  
  /// Registered component versions
  final Map<String, DsrtComponentVersion> _components;
  
  /// Creates a version manager.
  DsrtVersionManager({required this.engineCore})
      : _components = {'core': engineCore};
  
  /// Registers a component version.
  /// 
  /// [component]: Component version to register
  /// 
  /// Throws [StateError] if component with same name already registered.
  void registerComponent(DsrtComponentVersion component) {
    if (_components.containsKey(component.name)) {
      throw StateError('Component "${component.name}" is already registered');
    }
    
    // Check dependencies
    for (final entry in component.dependencies.entries) {
      final dependencyName = entry.key;
      final dependencyRange = entry.value;
      
      final dependencyVersion = _components[dependencyName];
      if (dependencyVersion == null) {
        throw StateError(
          'Dependency "$dependencyName" not found for component "${component.name}"',
        );
      }
      
      if (!dependencyRange.contains(dependencyVersion.version)) {
        throw StateError(
          'Component "${component.name}" requires $dependencyName $dependencyRange '
          'but found $dependencyVersion',
        );
      }
    }
    
    _components[component.name] = component;
  }
  
  /// Gets a component version by name.
  /// 
  /// [name]: Component name
  /// 
  /// Returns the component version or null if not found.
  DsrtComponentVersion? getComponent(String name) {
    return _components[name];
  }
  
  /// Checks if all registered components are compatible with each other.
  /// 
  /// Returns a list of compatibility issues, empty if all compatible.
  List<String> checkCompatibility() {
    final issues = <String>[];
    
    for (final component in _components.values) {
      for (final entry in component.dependencies.entries) {
        final dependencyName = entry.key;
        final dependencyRange = entry.value;
        
        final dependency = _components[dependencyName];
        if (dependency == null) {
          issues.add(
            'Component "${component.name}" depends on "$dependencyName" which is not registered',
          );
          continue;
        }
        
        if (!dependencyRange.contains(dependency.version)) {
          issues.add(
            'Component "${component.name}" requires $dependencyName $dependencyRange '
            'but found $dependency',
          );
        }
      }
    }
    
    return issues;
  }
  
  /// Gets the version information as a formatted string.
  String getVersionInfo() {
    final buffer = StringBuffer();
    buffer.writeln('DSRT Engine Version Information');
    buffer.writeln('=' * 50);
    
    for (final component in _components.values) {
      buffer.write('• ${component.name}: ${component.version}');
      if (component.description.isNotEmpty) {
        buffer.write(' - ${component.description}');
      }
      buffer.writeln();
      
      if (component.dependencies.isNotEmpty) {
        buffer.writeln('  Dependencies:');
        for (final entry in component.dependencies.entries) {
          buffer.writeln('    - ${entry.key}: ${entry.value}');
        }
      }
    }
    
    final compatibilityIssues = checkCompatibility();
    if (compatibilityIssues.isNotEmpty) {
      buffer.writeln();
      buffer.writeln('Compatibility Issues:');
      for (final issue in compatibilityIssues) {
        buffer.writeln('  ⚠ $issue');
      }
    }
    
    return buffer.toString();
  }
  
  /// Gets all registered component names.
  List<String> get componentNames => _components.keys.toList();
  
  /// Gets all registered component versions.
  List<DsrtComponentVersion> get components => _components.values.toList();
}

/// Current engine version constants
class DsrtCurrentVersions {
  /// Current engine version
  static final DsrtVersion engine = DsrtVersion.parse('1.0.0');
  
  /// Current core version
  static final DsrtComponentVersion core = DsrtComponentVersion(
    name: 'core',
    version: engine,
    description: 'DSRT Engine Core Module',
  );
  
  /// Current foundation version
  static final DsrtComponentVersion foundation = DsrtComponentVersion(
    name: 'foundation',
    version: DsrtVersion.parse('1.0.0'),
    description: 'DSRT Engine Foundation Module',
    dependencies: {
      'core': DsrtVersionRange.parse('^1.0.0'),
    },
  );
  
  /// Current implementation version
  static final DsrtComponentVersion implementation = DsrtComponentVersion(
    name: 'implementation',
    version: DsrtVersion.parse('1.0.0'),
    description: 'DSRT Engine Implementation Module',
    dependencies: {
      'foundation': DsrtVersionRange.parse('^1.0.0'),
    },
  );
  
  /// Current systems version
  static final DsrtComponentVersion systems = DsrtComponentVersion(
    name: 'systems',
    version: DsrtVersion.parse('1.0.0'),
    description: 'DSRT Engine Systems Module',
    dependencies: {
      'implementation': DsrtVersionRange.parse('^1.0.0'),
    },
  );
  
  /// Current extensions version
  static final DsrtComponentVersion extensions = DsrtComponentVersion(
    name: 'extensions',
    version: DsrtVersion.parse('1.0.0'),
    description: 'DSRT Engine Extensions Module',
    dependencies: {
      'systems': DsrtVersionRange.parse('^1.0.0'),
    },
  );
  
  /// Creates a version manager with all current versions.
  static DsrtVersionManager createVersionManager() {
    final manager = DsrtVersionManager(engineCore: core);
    
    manager.registerComponent(foundation);
    manager.registerComponent(implementation);
    manager.registerComponent(systems);
    manager.registerComponent(extensions);
    
    return manager;
  }
}
