/// Version information for DSRT Engine
/// 
/// Provides version parsing, comparison, and validation functionality.
class DsrtVersion {
  /// Major version (incompatible API changes)
  final int major;
  
  /// Minor version (backwards compatible new features)
  final int minor;
  
  /// Patch version (backwards compatible bug fixes)
  final int patch;
  
  /// Pre-release identifier (e.g., 'alpha', 'beta', 'rc')
  final String preRelease;
  
  /// Build metadata (e.g., build number, commit hash)
  final String build;
  
  /// Current engine version
  static final DsrtVersion current = DsrtVersion(
    major: DsrtConstants.versionMajor,
    minor: DsrtConstants.versionMinor,
    patch: DsrtConstants.versionPatch,
    preRelease: DsrtConstants.versionPreRelease,
    build: DsrtConstants.versionBuild,
  );
  
  /// Create version instance
  DsrtVersion({
    required this.major,
    required this.minor,
    required this.patch,
    this.preRelease = '',
    this.build = '',
  }) {
    _validate();
  }
  
  /// Parse version from string
  /// 
  /// [versionString]: Version string in SemVer format.
  /// 
  /// Returns parsed DsrtVersion instance.
  /// 
  /// Throws FormatException if version string is invalid.
  factory DsrtVersion.parse(String versionString) {
    // Remove leading 'v' if present
    var cleaned = versionString.trim();
    if (cleaned.startsWith('v') || cleaned.startsWith('V')) {
      cleaned = cleaned.substring(1);
    }
    
    // Split into core and pre-release/build parts
    final coreEnd = cleaned.indexOf('-');
    final buildStart = cleaned.indexOf('+');
    
    String corePart;
    String preReleasePart = '';
    String buildPart = '';
    
    if (coreEnd != -1 && (buildStart == -1 || coreEnd < buildStart)) {
      corePart = cleaned.substring(0, coreEnd);
      final rest = cleaned.substring(coreEnd + 1);
      
      if (buildStart != -1 && buildStart > coreEnd) {
        final relativeBuildStart = rest.indexOf('+');
        if (relativeBuildStart != -1) {
          preReleasePart = rest.substring(0, relativeBuildStart);
          buildPart = rest.substring(relativeBuildStart + 1);
        } else {
          preReleasePart = rest;
        }
      } else {
        preReleasePart = rest;
      }
    } else if (buildStart != -1) {
      corePart = cleaned.substring(0, buildStart);
      buildPart = cleaned.substring(buildStart + 1);
    } else {
      corePart = cleaned;
    }
    
    // Parse core version (major.minor.patch)
    final coreParts = corePart.split('.');
    if (coreParts.length != 3) {
      throw FormatException('Invalid version format: $versionString');
    }
    
    final major = int.tryParse(coreParts[0]);
    final minor = int.tryParse(coreParts[1]);
    final patch = int.tryParse(coreParts[2]);
    
    if (major == null || minor == null || patch == null) {
      throw FormatException('Invalid version numbers: $versionString');
    }
    
    return DsrtVersion(
      major: major,
      minor: minor,
      patch: patch,
      preRelease: preReleasePart,
      build: buildPart,
    );
  }
  
  /// Try to parse version from string
  /// 
  /// [versionString]: Version string to parse.
  /// 
  /// Returns parsed DsrtVersion or null if parsing fails.
  static DsrtVersion? tryParse(String versionString) {
    try {
      return DsrtVersion.parse(versionString);
    } catch (e) {
      return null;
    }
  }
  
  /// Validate version components
  void _validate() {
    if (major < 0) {
      throw ArgumentError('Major version cannot be negative');
    }
    if (minor < 0) {
      throw ArgumentError('Minor version cannot be negative');
    }
    if (patch < 0) {
      throw ArgumentError('Patch version cannot be negative');
    }
    
    // Validate pre-release identifier
    if (preRelease.isNotEmpty) {
      final parts = preRelease.split('.');
      for (final part in parts) {
        if (part.isEmpty) {
          throw ArgumentError('Pre-release identifier part cannot be empty');
        }
        
        // Check if it's numeric
        if (int.tryParse(part) != null) {
          // Numeric identifier cannot have leading zeros
          if (part.length > 1 && part.startsWith('0')) {
            throw ArgumentError('Numeric pre-release identifier cannot have leading zeros');
          }
        } else {
          // Alphabetic identifier must contain only alphanumeric characters and hyphens
          if (!RegExp(r'^[0-9A-Za-z-]+$').hasMatch(part)) {
            throw ArgumentError('Invalid characters in pre-release identifier');
          }
        }
      }
    }
    
    // Validate build metadata
    if (build.isNotEmpty) {
      final parts = build.split('.');
      for (final part in parts) {
        if (part.isEmpty) {
          throw ArgumentError('Build metadata part cannot be empty');
        }
        
        if (!RegExp(r'^[0-9A-Za-z-]+$').hasMatch(part)) {
          throw ArgumentError('Invalid characters in build metadata');
        }
      }
    }
  }
  
  /// Check if this version is stable (no pre-release identifier)
  bool get isStable => preRelease.isEmpty;
  
  /// Check if this version is pre-release
  bool get isPreRelease => preRelease.isNotEmpty;
  
  /// Check if this version is a development version
  bool get isDevelopment => preRelease.contains('dev') || preRelease.contains('alpha');
  
  /// Check if this version is a release candidate
  bool get isReleaseCandidate => preRelease.contains('rc');
  
  /// Check if this version is a beta version
  bool get isBeta => preRelease.contains('beta');
  
  /// Check if this version is compatible with another version
  /// 
  /// [other]: Version to compare with.
  /// [allowPreRelease]: Whether to allow pre-release versions.
  /// 
  /// Returns true if versions are compatible.
  bool isCompatibleWith(DsrtVersion other, {bool allowPreRelease = false}) {
    // Major version must match for compatibility
    if (major != other.major) return false;
    
    // If major is 0, minor must also match
    if (major == 0 && minor != other.minor) return false;
    
    // Check pre-release compatibility
    if (!allowPreRelease) {
      if (isPreRelease != other.isPreRelease) return false;
    }
    
    return true;
  }
  
  /// Compare this version with another
  /// 
  /// [other]: Version to compare with.
  /// 
  /// Returns:
  /// -1 if this version is older than other
  /// 0 if versions are equal
  /// 1 if this version is newer than other
  int compareTo(DsrtVersion other) {
    // Compare major version
    if (major != other.major) {
      return major > other.major ? 1 : -1;
    }
    
    // Compare minor version
    if (minor != other.minor) {
      return minor > other.minor ? 1 : -1;
    }
    
    // Compare patch version
    if (patch != other.patch) {
      return patch > other.patch ? 1 : -1;
    }
    
    // Compare pre-release identifiers
    if (preRelease != other.preRelease) {
      // Stable version is greater than pre-release version
      if (preRelease.isEmpty) return 1;
      if (other.preRelease.isEmpty) return -1;
      
      // Compare pre-release identifiers
      return _comparePreRelease(other.preRelease);
    }
    
    // Versions are equal (build metadata is ignored for comparison)
    return 0;
  }
  
  /// Compare pre-release identifiers
  int _comparePreRelease(String otherPreRelease) {
    final thisParts = preRelease.split('.');
    final otherParts = otherPreRelease.split('.');
    
    final maxLength = thisParts.length > otherParts.length 
        ? thisParts.length 
        : otherParts.length;
    
    for (int i = 0; i < maxLength; i++) {
      final thisPart = i < thisParts.length ? thisParts[i] : '';
      final otherPart = i < otherParts.length ? otherParts[i] : '';
      
      // Empty identifier is smaller than any non-empty identifier
      if (thisPart.isEmpty && otherPart.isNotEmpty) return -1;
      if (thisPart.isNotEmpty && otherPart.isEmpty) return 1;
      if (thisPart.isEmpty && otherPart.isEmpty) continue;
      
      final thisIsNumeric = int.tryParse(thisPart) != null;
      final otherIsNumeric = int.tryParse(otherPart) != null;
      
      // Numeric identifiers have lower precedence than non-numeric identifiers
      if (thisIsNumeric && !otherIsNumeric) return -1;
      if (!thisIsNumeric && otherIsNumeric) return 1;
      
      if (thisIsNumeric && otherIsNumeric) {
        final thisNum = int.parse(thisPart);
        final otherNum = int.parse(otherPart);
        if (thisNum != otherNum) {
          return thisNum > otherNum ? 1 : -1;
        }
      } else {
        // Compare lexically in ASCII sort order
        final comparison = thisPart.compareTo(otherPart);
        if (comparison != 0) return comparison;
      }
    }
    
    return 0;
  }
  
  /// Check if this version is older than another
  bool isOlderThan(DsrtVersion other) => compareTo(other) < 0;
  
  /// Check if this version is newer than another
  bool isNewerThan(DsrtVersion other) => compareTo(other) > 0;
  
  /// Check if this version is equal to another
  bool isEqualTo(DsrtVersion other) => compareTo(other) == 0;
  
  /// Get the next major version
  DsrtVersion get nextMajor => DsrtVersion(
    major: major + 1,
    minor: 0,
    patch: 0,
  );
  
  /// Get the next minor version
  DsrtVersion get nextMinor => DsrtVersion(
    major: major,
    minor: minor + 1,
    patch: 0,
  );
  
  /// Get the next patch version
  DsrtVersion get nextPatch => DsrtVersion(
    major: major,
    minor: minor,
    patch: patch + 1,
  );
  
  /// Create a pre-release version
  DsrtVersion withPreRelease(String preReleaseId) => DsrtVersion(
    major: major,
    minor: minor,
    patch: patch,
    preRelease: preReleaseId,
    build: build,
  );
  
  /// Create a build version
  DsrtVersion withBuild(String buildId) => DsrtVersion(
    major: major,
    minor: minor,
    patch: patch,
    preRelease: preRelease,
    build: buildId,
  );
  
  /// Get version as string in SemVer format
  @override
  String toString() {
    final buffer = StringBuffer();
    buffer.write('$major.$minor.$patch');
    
    if (preRelease.isNotEmpty) {
      buffer.write('-$preRelease');
    }
    
    if (build.isNotEmpty) {
      buffer.write('+$build');
    }
    
    return buffer.toString();
  }
  
  /// Get version as string with optional prefix
  String toStringWithPrefix([String prefix = 'v']) {
    return '$prefix${toString()}';
  }
  
  /// Get version as map
  Map<String, dynamic> toMap() {
    return {
      'major': major,
      'minor': minor,
      'patch': patch,
      'preRelease': preRelease,
      'build': build,
      'string': toString(),
    };
  }
  
  /// Get version as JSON
  String toJson() {
    return DsrtJsonUtils.encode(toMap());
  }
  
  /// Create version from map
  /// 
  /// [map]: Map containing version data.
  /// 
  /// Returns DsrtVersion instance.
  factory DsrtVersion.fromMap(Map<String, dynamic> map) {
    return DsrtVersion(
      major: map['major'] as int,
      minor: map['minor'] as int,
      patch: map['patch'] as int,
      preRelease: map['preRelease'] as String? ?? '',
      build: map['build'] as String? ?? '',
    );
  }
  
  /// Create version from JSON
  /// 
  /// [json]: JSON string containing version data.
  /// 
  /// Returns DsrtVersion instance.
  factory DsrtVersion.fromJson(String json) {
    final map = DsrtJsonUtils.decode(json) as Map<String, dynamic>;
    return DsrtVersion.fromMap(map);
  }
  
  /// Check if version satisfies a range
  /// 
  /// [range]: Version range string (e.g., '^1.0.0', '~1.2.0', '>=1.0.0 <2.0.0').
  /// 
  /// Returns true if version satisfies the range.
  bool satisfies(String range) {
    try {
      final constraints = _parseRange(range);
      return constraints.every((constraint) => _satisfiesConstraint(constraint));
    } catch (e) {
      return false;
    }
  }
  
  /// Parse version range string
  List<Map<String, dynamic>> _parseRange(String range) {
    final constraints = <Map<String, dynamic>>[];
    final parts = range.split(' ');
    
    for (final part in parts) {
      if (part.isEmpty) continue;
      
      final constraint = <String, dynamic>{};
      
      if (part.startsWith('^')) {
        // Caret range: ^1.2.3 means >=1.2.3 <2.0.0
        final version = DsrtVersion.parse(part.substring(1));
        constraint['min'] = version;
        constraint['max'] = version.nextMajor;
        constraint['includeMin'] = true;
        constraint['includeMax'] = false;
      } else if (part.startsWith('~')) {
        // Tilde range: ~1.2.3 means >=1.2.3 <1.3.0
        final version = DsrtVersion.parse(part.substring(1));
        constraint['min'] = version;
        constraint['max'] = version.nextMinor;
        constraint['includeMin'] = true;
        constraint['includeMax'] = false;
      } else if (part.startsWith('>=')) {
        // Greater than or equal
        final version = DsrtVersion.parse(part.substring(2));
        constraint['min'] = version;
        constraint['includeMin'] = true;
      } else if (part.startsWith('>')) {
        // Greater than
        final version = DsrtVersion.parse(part.substring(1));
        constraint['min'] = version;
        constraint['includeMin'] = false;
      } else if (part.startsWith('<=')) {
        // Less than or equal
        final version = DsrtVersion.parse(part.substring(2));
        constraint['max'] = version;
        constraint['includeMax'] = true;
      } else if (part.startsWith('<')) {
        // Less than
        final version = DsrtVersion.parse(part.substring(1));
        constraint['max'] = version;
        constraint['includeMax'] = false;
      } else if (part.startsWith('=')) {
        // Exact version (with = prefix)
        final version = DsrtVersion.parse(part.substring(1));
        constraint['min'] = version;
        constraint['max'] = version;
        constraint['includeMin'] = true;
        constraint['includeMax'] = true;
      } else {
        // Exact version (without prefix)
        final version = DsrtVersion.parse(part);
        constraint['min'] = version;
        constraint['max'] = version;
        constraint['includeMin'] = true;
        constraint['includeMax'] = true;
      }
      
      constraints.add(constraint);
    }
    
    return constraints;
  }
  
  /// Check if version satisfies a single constraint
  bool _satisfiesConstraint(Map<String, dynamic> constraint) {
    final hasMin = constraint.containsKey('min');
    final hasMax = constraint.containsKey('max');
    final includeMin = constraint['includeMin'] as bool? ?? true;
    final includeMax = constraint['includeMax'] as bool? ?? true;
    
    if (hasMin) {
      final minVersion = constraint['min'] as DsrtVersion;
      final comparison = compareTo(minVersion);
      if (includeMin ? comparison < 0 : comparison <= 0) {
        return false;
      }
    }
    
    if (hasMax) {
      final maxVersion = constraint['max'] as DsrtVersion;
      final comparison = compareTo(maxVersion);
      if (includeMax ? comparison > 0 : comparison >= 0) {
        return false;
      }
    }
    
    return true;
  }
  
  @override
  bool operator ==(Object other) {
    return other is DsrtVersion && compareTo(other) == 0;
  }
  
  @override
  int get hashCode {
    return major.hashCode ^ minor.hashCode ^ patch.hashCode ^ preRelease.hashCode;
  }
  
  /// Get engine name with version
  String get engineNameWithVersion {
    return '${DsrtConstants.engineName} ${toStringWithPrefix()}';
  }
  
  /// Get copyright information
  String get copyright {
    final year = DateTime.now().year;
    return '© $year ${DsrtConstants.engineVendor}. All rights reserved.';
  }
  
  /// Get license information
  String get license {
    return 'Licensed under the DSRT Engine License. See LICENSE file for details.';
  }
}
