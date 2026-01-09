/// Engine version information
/// 
/// Follows Semantic Versioning (SemVer)
/// 
/// @license MIT
/// @copyright (c) 2024 DSRT Engine

/// Version information class
class ExsVersion {
  /// Major version - incompatible API changes
  final int major;
  
  /// Minor version - backwards compatible functionality
  final int minor;
  
  /// Patch version - backwards compatible bug fixes
  final int patch;
  
  /// Pre-release identifier (optional)
  final String? preRelease;
  
  /// Build metadata (optional)
  final String? build;
  
  /// Engine name
  final String name;
  
  /// Engine codename
  final String codename;
  
  /// Engine description
  final String description;
  
  /// Default constructor
  const ExsVersion({
    required this.major,
    required this.minor,
    required this.patch,
    this.preRelease,
    this.build,
    this.name = 'DSRT Engine',
    this.codename = 'Aether',
    this.description = 'Standalone 3D Rendering Engine',
  });
  
  /// Current engine version
  static const ExsVersion current = ExsVersion(
    major: 0,
    minor: 1,
    patch: 0,
    preRelease: 'alpha',
    build: '2024.12.20',
    name: 'DSRT Engine',
    codename: 'Aether',
    description: 'Standalone 3D Rendering Engine',
  );
  
  /// Get version as string (SemVer format)
  String get versionString {
    var result = '$major.$minor.$patch';
    if (preRelease != null) {
      result += '-$preRelease';
    }
    if (build != null) {
      result += '+$build';
    }
    return result;
  }
  
  /// Get version as integer (for comparisons)
  int get versionNumber => major * 1000000 + minor * 1000 + patch;
  
  /// Check if this is a pre-release version
  bool get isPreRelease => preRelease != null;
  
  /// Check if this is a stable version
  bool get isStable => !isPreRelease && major > 0;
  
  /// Check compatibility with another version
  bool isCompatibleWith(ExsVersion other) {
    // Same major version = compatible
    return major == other.major;
  }
  
  /// Compare versions
  /// Returns: -1 if this < other, 0 if equal, 1 if this > other
  int compareTo(ExsVersion other) {
    if (major != other.major) return major.compareTo(other.major);
    if (minor != other.minor) return minor.compareTo(other.minor);
    if (patch != other.patch) return patch.compareTo(other.patch);
    
    // Pre-release versions are considered lower than stable versions
    if (preRelease != null && other.preRelease == null) return -1;
    if (preRelease == null && other.preRelease != null) return 1;
    if (preRelease != null && other.preRelease != null) {
      return preRelease!.compareTo(other.preRelease!);
    }
    
    return 0;
  }
  
  /// Check if this version is greater than another
  bool operator >(ExsVersion other) => compareTo(other) > 0;
  
  /// Check if this version is less than another
  bool operator <(ExsVersion other) => compareTo(other) < 0;
  
  /// Check if this version is greater than or equal to another
  bool operator >=(ExsVersion other) => compareTo(other) >= 0;
  
  /// Check if this version is less than or equal to another
  bool operator <=(ExsVersion other) => compareTo(other) <= 0;
  
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExsVersion &&
          runtimeType == other.runtimeType &&
          major == other.major &&
          minor == other.minor &&
          patch == other.patch &&
          preRelease == other.preRelease &&
          build == other.build;
  
  @override
  int get hashCode =>
      major.hashCode ^
      minor.hashCode ^
      patch.hashCode ^
      preRelease.hashCode ^
      build.hashCode;
  
  @override
  String toString() {
    return '$name $versionString "$codename"';
  }
  
  /// Get detailed version info as a map
  Map<String, dynamic> toMap() {
    return {
      'major': major,
      'minor': minor,
      'patch': patch,
      'preRelease': preRelease,
      'build': build,
      'version': versionString,
      'name': name,
      'codename': codename,
      'description': description,
      'isPreRelease': isPreRelease,
      'isStable': isStable,
    };
  }
  
  /// Create version from map
  static ExsVersion fromMap(Map<String, dynamic> map) {
    return ExsVersion(
      major: map['major'] as int,
      minor: map['minor'] as int,
      patch: map['patch'] as int,
      preRelease: map['preRelease'] as String?,
      build: map['build'] as String?,
      name: map['name'] as String? ?? 'DSRT Engine',
      codename: map['codename'] as String? ?? 'Unknown',
      description: map['description'] as String? ?? '',
    );
  }
}
