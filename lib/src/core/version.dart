/// DSRT Engine - Version Information
/// Version tracking and comparison utilities.
library dsrt_engine.src.core.version;

/// Engine version information
class EngineVersion {
  /// Major version number
  final int major;
  
  /// Minor version number
  final int minor;
  
  /// Patch version number
  final int patch;
  
  /// Pre-release identifier
  final String? preRelease;
  
  /// Build metadata
  final String? build;
  
  /// Create version object
  EngineVersion({
    required this.major,
    required this.minor,
    required this.patch,
    this.preRelease,
    this.build,
  });
  
  /// Current engine version
  static EngineVersion get current => EngineVersion(
    major: 1,
    minor: 0,
    patch: 0,
    preRelease: 'alpha',
    build: '1',
  );
  
  /// Parse version from string
  factory EngineVersion.parse(String versionString) {
    final regex = RegExp(r'^(\d+)\.(\d+)\.(\d+)(?:-([0-9A-Za-z-]+(?:\.[0-9A-Za-z-]+)*))?(?:\+([0-9A-Za-z-]+(?:\.[0-9A-Za-z-]+)*))?$');
    
    final match = regex.firstMatch(versionString);
    if (match == null) {
      throw FormatException('Invalid version string: $versionString');
    }
    
    return EngineVersion(
      major: int.parse(match.group(1)!),
      minor: int.parse(match.group(2)!),
      patch: int.parse(match.group(3)!),
      preRelease: match.group(4),
      build: match.group(5),
    );
  }
  
  /// Check if this version is compatible with another
  bool isCompatibleWith(EngineVersion other) {
    // Major versions must match for compatibility
    if (major != other.major) return false;
    
    // If this is a newer minor version, it should be backward compatible
    if (minor > other.minor) return true;
    
    // If minors are equal, check patch
    if (minor == other.minor) {
      return patch >= other.patch;
    }
    
    return false;
  }
  
  /// Check if this version is newer than another
  bool isNewerThan(EngineVersion other) {
    if (major > other.major) return true;
    if (major < other.major) return false;
    
    if (minor > other.minor) return true;
    if (minor < other.minor) return false;
    
    if (patch > other.patch) return true;
    if (patch < other.patch) return false;
    
    // Versions are equal
    return false;
  }
  
  /// Compare this version with another
  int compareTo(EngineVersion other) {
    if (major != other.major) return major.compareTo(other.major);
    if (minor != other.minor) return minor.compareTo(other.minor);
    if (patch != other.patch) return patch.compareTo(other.patch);
    return 0;
  }
  
  @override
  String toString() {
    var result = '$major.$minor.$patch';
    if (preRelease != null) {
      result = '$result-$preRelease';
    }
    if (build != null) {
      result = '$result+$build';
    }
    return result;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is EngineVersion &&
        major == other.major &&
        minor == other.minor &&
        patch == other.patch &&
        preRelease == other.preRelease &&
        build == other.build;
  }
  
  @override
  int get hashCode {
    return Object.hash(major, minor, patch, preRelease, build);
  }
  
  /// Convert to map for serialization
  Map<String, dynamic> toMap() {
    return {
      'major': major,
      'minor': minor,
      'patch': patch,
      'preRelease': preRelease,
      'build': build,
    };
  }
  
  /// Create from map
  factory EngineVersion.fromMap(Map<String, dynamic> map) {
    return EngineVersion(
      major: map['major'] as int,
      minor: map['minor'] as int,
      patch: map['patch'] as int,
      preRelease: map['preRelease'] as String?,
      build: map['build'] as String?,
    );
  }
}

/// Version range for compatibility checking
class VersionRange {
  /// Minimum compatible version
  final EngineVersion min;
  
  /// Maximum compatible version
  final EngineVersion? max;
  
  /// Create version range
  VersionRange({
    required this.min,
    this.max,
  });
  
  /// Parse version range from string
  factory VersionRange.parse(String rangeString) {
    final parts = rangeString.split('-');
    if (parts.length == 1) {
      final version = EngineVersion.parse(parts[0]);
      return VersionRange(min: version, max: version);
    } else if (parts.length == 2) {
      return VersionRange(
        min: EngineVersion.parse(parts[0]),
        max: EngineVersion.parse(parts[1]),
      );
    } else {
      throw FormatException('Invalid version range: $rangeString');
    }
  }
  
  /// Check if version is within range
  bool contains(EngineVersion version) {
    if (version.compareTo(min) < 0) return false;
    if (max != null && version.compareTo(max!) > 0) return false;
    return true;
  }
  
  @override
  String toString() {
    if (max == null || min == max) {
      return min.toString();
    }
    return '${min}-${max}';
  }
}
