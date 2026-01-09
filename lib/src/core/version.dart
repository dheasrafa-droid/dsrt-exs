/// Version management system for DSRT Engine
/// 
/// Provides semantic versioning, build metadata, and version comparison
/// capabilities for engine and API version tracking.
/// 
/// [major]: Major version number (incompatible API changes).
/// [minor]: Minor version number (backwards-compatible functionality).
/// [patch]: Patch version number (backwards-compatible bug fixes).
/// [preRelease]: Pre-release identifier (e.g., 'alpha', 'beta', 'rc').
/// [buildMetadata]: Build metadata (e.g., build number, commit hash).
part of dsrt_engine.core.internal;

/// Public engine version information
/// 
/// This class is exported to users and provides read-only access
/// to engine version information.
class EngineVersion {
  /// Major version number (incompatible API changes)
  final int major;
  
  /// Minor version number (backwards-compatible functionality)
  final int minor;
  
  /// Patch version number (backwards-compatible bug fixes)
  final int patch;
  
  /// Pre-release identifier
  final String? preRelease;
  
  /// Build metadata
  final String? buildMetadata;
  
  /// Engine name
  final String engineName = 'DSRT Engine';
  
  /// Engine codename
  final String codename = 'Aurora';
  
  /// Engine license
  final String license = 'MIT License';
  
  /// Engine copyright
  final String copyright = 'Copyright © 2024 DSRT Engine Team';
  
  /// Engine repository URL
  final String repository = 'https://github.com/dheasrafa-droid/dsrt-exs';
  
  /// Engine documentation URL
  final String documentation = 'https://dsrt-exs.vercel.app/docs';
  
  /// Engine website URL
  final String website = 'https://dsrt-exs.vercel.app';
  
  /// Engine support URL
  final String support = 'https://dsrt-exs.vercel.app/support';
  
  /// Internal version implementation
  final _Version _internalVersion;
  
  /// Creates engine version information
  EngineVersion({
    int? major,
    int? minor,
    int? patch,
    String? preRelease,
    String? buildMetadata,
  })  : major = major ?? 0,
        minor = minor ?? 1,
        patch = patch ?? 0,
        preRelease = preRelease,
        buildMetadata = buildMetadata,
        _internalVersion = _Version(
          major: major ?? 0,
          minor: minor ?? 1,
          patch: patch ?? 0,
          preRelease: preRelease,
          buildMetadata: buildMetadata,
        );
  
  /// Current engine version
  static final EngineVersion current = EngineVersion(
    major: 0,
    minor: 1,
    patch: 0,
    preRelease: null,
    buildMetadata: null,
  );
  
  /// API version (separate from engine version)
  static final EngineVersion apiVersion = EngineVersion(
    major: 1,
    minor: 0,
    patch: 0,
    preRelease: null,
    buildMetadata: null,
  );
  
  /// Gets the full semantic version string
  /// 
  /// Returns: Version string in format 'major.minor.patch[-preRelease][+buildMetadata]'.
  String get versionString => _internalVersion.getVersionString();
  
  /// Gets the core version string (without pre-release or build metadata)
  /// 
  /// Returns: Version string in format 'major.minor.patch'.
  String get coreVersionString => _internalVersion.getCoreVersionString();
  
  /// Gets the major.minor version string
  /// 
  /// Returns: Version string in format 'major.minor'.
  String get majorMinorString => _internalVersion.getMajorMinorString();
  
  /// Checks if this is a pre-release version
  /// 
  /// Returns: true if this is a pre-release version.
  bool get isPreRelease => _internalVersion.isPreRelease();
  
  /// Checks if this is a stable release version
  /// 
  /// Returns: true if this is a stable release version.
  bool get isStable => _internalVersion.isStable();
  
  /// Checks if this is a development version
  /// 
  /// Returns: true if this is a development version (major version 0).
  bool get isDevelopment => _internalVersion.isDevelopment();
  
  /// Compares this version with another version
  /// 
  /// [other]: The other version to compare with.
  /// 
  /// Returns:
  /// - -1 if this version is less than the other version
  /// - 0 if this version is equal to the other version  
  /// - 1 if this version is greater than the other version
  int compareTo(EngineVersion other) {
    return _internalVersion.compareTo(other._internalVersion);
  }
  
  /// Checks if this version is compatible with another version
  /// 
  /// [other]: The other version to check compatibility with.
  /// [allowBackwardsCompatible]: Whether to allow backwards-compatible changes.
  /// 
  /// Returns: true if the versions are compatible.
  bool isCompatibleWith(EngineVersion other, {bool allowBackwardsCompatible = true}) {
    return _internalVersion.isCompatibleWith(
      other._internalVersion,
      allowBackwardsCompatible: allowBackwardsCompatible,
    );
  }
  
  /// Checks if this version satisfies a version range
  /// 
  /// [range]: The version range to check.
  /// 
  /// Returns: true if this version satisfies the range.
  bool satisfies(String range) {
    return _internalVersion.satisfies(range);
  }
  
  /// Gets engine information as a map
  /// 
  /// Returns: Map containing engine information.
  Map<String, dynamic> toMap() {
    return {
      'name': engineName,
      'version': versionString,
      'codename': codename,
      'license': license,
      'copyright': copyright,
      'repository': repository,
      'documentation': documentation,
      'website': website,
      'support': support,
      'isStable': isStable,
      'isDevelopment': isDevelopment,
      'isPreRelease': isPreRelease,
      'major': major,
      'minor': minor,
      'patch': patch,
      'preRelease': preRelease,
      'buildMetadata': buildMetadata,
    };
  }
  
  /// Creates version from a map
  /// 
  /// [map]: Map containing version information.
  /// 
  /// Returns: New EngineVersion instance.
  factory EngineVersion.fromMap(Map<String, dynamic> map) {
    return EngineVersion(
      major: map['major'] as int?,
      minor: map['minor'] as int?,
      patch: map['patch'] as int?,
      preRelease: map['preRelease'] as String?,
      buildMetadata: map['buildMetadata'] as String?,
    );
  }
  
  /// Creates version from a string
  /// 
  /// [versionStr]: Version string to parse.
  /// 
  /// Returns: New EngineVersion instance.
  /// 
  /// Throws [FormatException] if string format is invalid.
  factory EngineVersion.fromString(String versionStr) {
    final internal = _Version.fromString(versionStr);
    return EngineVersion(
      major: internal.major,
      minor: internal.minor,
      patch: internal.patch,
      preRelease: internal.preRelease,
      buildMetadata: internal.buildMetadata,
    );
  }
  
  @override
  String toString() => versionString;
  
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EngineVersion &&
          runtimeType == other.runtimeType &&
          major == other.major &&
          minor == other.minor &&
          patch == other.patch &&
          preRelease == other.preRelease;
  
  @override
  int get hashCode =>
      major.hashCode ^
      minor.hashCode ^
      patch.hashCode ^
      (preRelease?.hashCode ?? 0);
}

/// Version information container
class VersionInfo {
  /// Engine version
  final EngineVersion engineVersion;
  
  /// API version
  final EngineVersion apiVersion;
  
  /// Build timestamp
  final DateTime buildTime;
  
  /// Build environment information
  final Map<String, dynamic> buildEnvironment;
  
  /// Creates version information
  VersionInfo({
    EngineVersion? engineVersion,
    EngineVersion? apiVersion,
    DateTime? buildTime,
    Map<String, dynamic>? buildEnvironment,
  })  : engineVersion = engineVersion ?? EngineVersion.current,
        apiVersion = apiVersion ?? EngineVersion.apiVersion,
        buildTime = buildTime ?? DateTime.now(),
        buildEnvironment = buildEnvironment ?? {
          'dartVersion': '3.0.0',
          'buildType': 'development',
          'platform': 'web',
          'architecture': 'x64',
        };
  
  /// Current version information
  static final VersionInfo current = VersionInfo();
  
  /// Gets full version information as a map
  Map<String, dynamic> toMap() {
    return {
      'engine': engineVersion.toMap(),
      'api': apiVersion.toMap(),
      'buildTime': buildTime.toIso8601String(),
      'buildEnvironment': buildEnvironment,
    };
  }
  
  /// Gets human-readable version description
  String get description {
    if (engineVersion.isDevelopment) {
      return 'DSRT Engine Development ${engineVersion.versionString}';
    } else if (engineVersion.isPreRelease) {
      return 'DSRT Engine ${engineVersion.preRelease?.toUpperCase()} ${engineVersion.versionString}';
    } else {
      return 'DSRT Engine ${engineVersion.versionString}';
    }
  }
  
  @override
  String toString() => description;
}
