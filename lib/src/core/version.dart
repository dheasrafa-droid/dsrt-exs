/// Internal version management system for DSRT Engine.
/// 
/// This class manages engine version information, providing semantic versioning,
/// build metadata, and version comparison capabilities.
/// 
/// @internal This class is for internal DSRT Engine use only.
class _Version {
  /// Major version number (incompatible API changes).
  final int major;

  /// Minor version number (backwards-compatible functionality).
  final int minor;

  /// Patch version number (backwards-compatible bug fixes).
  final int patch;

  /// Pre-release identifier (e.g., 'alpha', 'beta', 'rc').
  final String? preRelease;

  /// Build metadata (e.g., build number, commit hash).
  final String? buildMetadata;

  /// Engine name.
  final String engineName = 'DSRT Engine';

  /// Engine codename.
  final String codename = 'Aurora';

  /// Engine license.
  final String license = 'MIT License';

  /// Engine copyright.
  final String copyright = 'Copyright © 2024 DSRT Engine Team';

  /// Engine repository URL.
  final String repository = 'https://github.com/dsrt-engine/dsrt-engine';

  /// Engine documentation URL.
  final String documentation = 'https://docs.dsrt-engine.dev';

  /// Engine support URL.
  final String support = 'https://support.dsrt-engine.dev';

  /// Default constructor for internal version manager.
  /// 
  /// [major]: Major version number (defaults to 0).
  /// [minor]: Minor version number (defaults to 1).
  /// [patch]: Patch version number (defaults to 0).
  /// [preRelease]: Pre-release identifier (optional).
  /// [buildMetadata]: Build metadata (optional).
  _Version({
    this.major = 0,
    this.minor = 1,
    this.patch = 0,
    this.preRelease,
    this.buildMetadata,
  });

  /// Gets the full semantic version string.
  /// 
  /// Returns the version string in format 'major.minor.patch[-preRelease][+buildMetadata]'.
  String getVersionString() {
    var version = '$major.$minor.$patch';
    
    if (preRelease != null && preRelease!.isNotEmpty) {
      version = '$version-$preRelease';
    }
    
    if (buildMetadata != null && buildMetadata!.isNotEmpty) {
      version = '$version+$buildMetadata';
    }
    
    return version;
  }

  /// Gets the version without pre-release or build metadata.
  /// 
  /// Returns the core version string in format 'major.minor.patch'.
  String getCoreVersionString() {
    return '$major.$minor.$patch';
  }

  /// Gets the major.minor version string.
  /// 
  /// Returns the major.minor version string.
  String getMajorMinorString() {
    return '$major.$minor';
  }

  /// Checks if this version is a pre-release.
  /// 
  /// Returns true if this is a pre-release version, false otherwise.
  bool isPreRelease() {
    return preRelease != null && preRelease!.isNotEmpty;
  }

  /// Checks if this version is a stable release.
  /// 
  /// Returns true if this is a stable release version, false otherwise.
  bool isStable() {
    return !isPreRelease() && major > 0;
  }

  /// Checks if this version is a development version.
  /// 
  /// Returns true if this is a development version (major version 0), false otherwise.
  bool isDevelopment() {
    return major == 0;
  }

  /// Compares this version with another version.
  /// 
  /// [other]: The other version to compare with.
  /// 
  /// Returns:
  /// - -1 if this version is less than the other version
  /// - 0 if this version is equal to the other version
  /// - 1 if this version is greater than the other version
  int compareTo(_Version other) {
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
    final preReleaseCompare = _comparePreRelease(other);
    if (preReleaseCompare != 0) {
      return preReleaseCompare;
    }
    
    // Build metadata does not affect version precedence
    return 0;
  }

  /// Compares pre-release identifiers.
  /// 
  /// [other]: The other version to compare with.
  /// 
  /// Returns comparison result for pre-release identifiers.
  int _comparePreRelease(_Version other) {
    // A version with a pre-release identifier has lower precedence than a version without one
    if (preRelease == null && other.preRelease != null) {
      return 1;
    }
    
    if (preRelease != null && other.preRelease == null) {
      return -1;
    }
    
    // Both have pre-release identifiers
    if (preRelease != null && other.preRelease != null) {
      final thisIdentifiers = preRelease!.split('.');
      final otherIdentifiers = other.preRelease!.split('.');
      
      final maxLength = thisIdentifiers.length > otherIdentifiers.length 
          ? thisIdentifiers.length 
          : otherIdentifiers.length;
      
      for (int i = 0; i < maxLength; i++) {
        if (i >= thisIdentifiers.length) {
          return -1; // This version has fewer identifiers
        }
        
        if (i >= otherIdentifiers.length) {
          return 1; // Other version has fewer identifiers
        }
        
        final thisId = thisIdentifiers[i];
        final otherId = otherIdentifiers[i];
        
        // Try to parse as numbers
        final thisNum = int.tryParse(thisId);
        final otherNum = int.tryParse(otherId);
        
        if (thisNum != null && otherNum != null) {
          // Both are numeric
          if (thisNum != otherNum) {
            return thisNum.compareTo(otherNum);
          }
        } else if (thisNum != null && otherNum == null) {
          // Numeric identifiers have lower precedence than non-numeric identifiers
          return -1;
        } else if (thisNum == null && otherNum != null) {
          // Non-numeric identifiers have higher precedence than numeric identifiers
          return 1;
        } else {
          // Both are non-numeric, compare lexically
          final comparison = thisId.compareTo(otherId);
          if (comparison != 0) {
            return comparison;
          }
        }
      }
    }
    
    return 0;
  }

  /// Checks if this version is compatible with another version.
  /// 
  /// [other]: The other version to check compatibility with.
  /// [allowBackwardsCompatible]: Whether to allow backwards-compatible changes (defaults to true).
  /// 
  /// Returns true if the versions are compatible, false otherwise.
  bool isCompatibleWith(_Version other, {bool allowBackwardsCompatible = true}) {
    if (major != other.major) {
      // Major version changes are always incompatible
      return false;
    }
    
    if (!allowBackwardsCompatible) {
      // Strict compatibility requires exact match
      return minor == other.minor && patch == other.patch;
    }
    
    // Backwards-compatible: same major version
    return true;
  }

  /// Checks if this version satisfies a version range.
  /// 
  /// [range]: The version range to check (e.g., '^1.2.3', '~1.2.0', '>=1.0.0 <2.0.0').
  /// 
  /// Returns true if this version satisfies the range, false otherwise.
  bool satisfies(String range) {
    try {
      final parsedRange = _parseVersionRange(range);
      return _evaluateRange(parsedRange);
    } catch (e) {
      return false;
    }
  }

  /// Parses a version range string.
  /// 
  /// [range]: The version range string to parse.
  /// 
  /// Returns a list of range constraints.
  List<Map<String, dynamic>> _parseVersionRange(String range) {
    final constraints = <Map<String, dynamic>>[];
    final parts = range.split(' ');
    
    for (final part in parts) {
      if (part.isEmpty) continue;
      
      if (part.startsWith('^')) {
        // Caret range: ^1.2.3 means >=1.2.3 <2.0.0
        final versionStr = part.substring(1);
        final version = _parseVersionString(versionStr);
        
        constraints.add({
          'operator': '>=',
          'version': version,
        });
        
        constraints.add({
          'operator': '<',
          'version': _Version(major: version.major + 1, minor: 0, patch: 0),
        });
      } else if (part.startsWith('~')) {
        // Tilde range: ~1.2.3 means >=1.2.3 <1.3.0
        final versionStr = part.substring(1);
        final version = _parseVersionString(versionStr);
        
        constraints.add({
          'operator': '>=',
          'version': version,
        });
        
        constraints.add({
          'operator': '<',
          'version': _Version(major: version.major, minor: version.minor + 1, patch: 0),
        });
      } else if (part.startsWith('>=')) {
        final versionStr = part.substring(2);
        final version = _parseVersionString(versionStr);
        constraints.add({'operator': '>=', 'version': version});
      } else if (part.startsWith('<=')) {
        final versionStr = part.substring(2);
        final version = _parseVersionString(versionStr);
        constraints.add({'operator': '<=', 'version': version});
      } else if (part.startsWith('>')) {
        final versionStr = part.substring(1);
        final version = _parseVersionString(versionStr);
        constraints.add({'operator': '>', 'version': version});
      } else if (part.startsWith('<')) {
        final versionStr = part.substring(1);
        final version = _parseVersionString(versionStr);
        constraints.add({'operator': '<', 'version': version});
      } else if (part.startsWith('=')) {
        final versionStr = part.substring(1);
        final version = _parseVersionString(versionStr);
        constraints.add({'operator': '=', 'version': version});
      } else {
        // Assume exact version
        final version = _parseVersionString(part);
        constraints.add({'operator': '=', 'version': version});
      }
    }
    
    return constraints;
  }

  /// Parses a version string.
  /// 
  /// [versionStr]: The version string to parse.
  /// 
  /// Returns a _Version instance.
  _Version _parseVersionString(String versionStr) {
    // Remove build metadata
    final parts = versionStr.split('+');
    final versionWithoutBuild = parts[0];
    
    // Split version and pre-release
    final versionPreRelease = versionWithoutBuild.split('-');
    final versionCore = versionPreRelease[0];
    final preRelease = versionPreRelease.length > 1 ? versionPreRelease[1] : null;
    
    // Parse core version
    final coreParts = versionCore.split('.');
    if (coreParts.length < 3) {
      throw FormatException('Invalid version string: $versionStr');
    }
    
    final major = int.parse(coreParts[0]);
    final minor = int.parse(coreParts[1]);
    final patch = int.parse(coreParts[2]);
    
    // Parse build metadata if present
    final buildMetadata = parts.length > 1 ? parts[1] : null;
    
    return _Version(
      major: major,
      minor: minor,
      patch: patch,
      preRelease: preRelease,
      buildMetadata: buildMetadata,
    );
  }

  /// Evaluates if this version satisfies a range.
  /// 
  /// [constraints]: The range constraints to evaluate.
  /// 
  /// Returns true if all constraints are satisfied.
  bool _evaluateRange(List<Map<String, dynamic>> constraints) {
    for (final constraint in constraints) {
      final operator = constraint['operator'] as String;
      final version = constraint['version'] as _Version;
      final comparison = compareTo(version);
      
      switch (operator) {
        case '=':
          if (comparison != 0) return false;
          break;
        case '>':
          if (comparison <= 0) return false;
          break;
        case '>=':
          if (comparison < 0) return false;
          break;
        case '<':
          if (comparison >= 0) return false;
          break;
        case '<=':
          if (comparison > 0) return false;
          break;
        default:
          return false;
      }
    }
    
    return true;
  }

  /// Gets the next major version.
  /// 
  /// Returns a new version with major version incremented by 1.
  _Version nextMajor() {
    return _Version(major: major + 1, minor: 0, patch: 0);
  }

  /// Gets the next minor version.
  /// 
  /// Returns a new version with minor version incremented by 1.
  _Version nextMinor() {
    return _Version(major: major, minor: minor + 1, patch: 0);
  }

  /// Gets the next patch version.
  /// 
  /// Returns a new version with patch version incremented by 1.
  _Version nextPatch() {
    return _Version(major: major, minor: minor, patch: patch + 1);
  }

  /// Creates a pre-release version.
  /// 
  /// [identifier]: The pre-release identifier.
  /// [increment]: Whether to increment the patch version (defaults to false).
  /// 
  /// Returns a new pre-release version.
  _Version asPreRelease(String identifier, {bool increment = false}) {
    return _Version(
      major: major,
      minor: minor,
      patch: increment ? patch + 1 : patch,
      preRelease: identifier,
      buildMetadata: buildMetadata,
    );
  }

  /// Creates a build version.
  /// 
  /// [metadata]: The build metadata.
  /// 
  /// Returns a new version with build metadata.
  _Version withBuildMetadata(String metadata) {
    return _Version(
      major: major,
      minor: minor,
      patch: patch,
      preRelease: preRelease,
      buildMetadata: metadata,
    );
  }

  /// Gets engine information.
  /// 
  /// Returns a map containing engine information.
  Map<String, dynamic> getEngineInfo() {
    return {
      'name': engineName,
      'version': getVersionString(),
      'codename': codename,
      'license': license,
      'copyright': copyright,
      'repository': repository,
      'documentation': documentation,
      'support': support,
      'isStable': isStable(),
      'isDevelopment': isDevelopment(),
      'isPreRelease': isPreRelease(),
    };
  }

  /// Gets version information as a map.
  /// 
  /// Returns a map containing version information.
  Map<String, dynamic> toMap() {
    return {
      'major': major,
      'minor': minor,
      'patch': patch,
      'preRelease': preRelease,
      'buildMetadata': buildMetadata,
      'versionString': getVersionString(),
      'coreVersionString': getCoreVersionString(),
      'majorMinorString': getMajorMinorString(),
    };
  }

  /// Creates a version from a map.
  /// 
  /// [map]: The map containing version information.
  /// 
  /// Returns a new _Version instance.
  static _Version fromMap(Map<String, dynamic> map) {
    return _Version(
      major: map['major'] as int? ?? 0,
      minor: map['minor'] as int? ?? 0,
      patch: map['patch'] as int? ?? 0,
      preRelease: map['preRelease'] as String?,
      buildMetadata: map['buildMetadata'] as String?,
    );
  }

  /// Creates a version from a string.
  /// 
  /// [versionStr]: The version string to parse.
  /// 
  /// Returns a new _Version instance.
  static _Version fromString(String versionStr) {
    // Remove build metadata
    final parts = versionStr.split('+');
    final versionWithoutBuild = parts[0];
    
    // Split version and pre-release
    final versionPreRelease = versionWithoutBuild.split('-');
    final versionCore = versionPreRelease[0];
    final preRelease = versionPreRelease.length > 1 ? versionPreRelease[1] : null;
    
    // Parse core version
    final coreParts = versionCore.split('.');
    if (coreParts.length != 3) {
      throw FormatException('Invalid version string: $versionStr');
    }
    
    final major = int.parse(coreParts[0]);
    final minor = int.parse(coreParts[1]);
    final patch = int.parse(coreParts[2]);
    
    // Parse build metadata if present
    final buildMetadata = parts.length > 1 ? parts[1] : null;
    
    return _Version(
      major: major,
      minor: minor,
      patch: patch,
      preRelease: preRelease,
      buildMetadata: buildMetadata,
    );
  }

  /// Gets the current build timestamp.
  /// 
  /// Returns the build timestamp as a string.
  String getBuildTimestamp() {
    return DateTime.now().toIso8601String();
  }

  /// Gets the build environment information.
  /// 
  /// Returns a map containing build environment information.
  Map<String, dynamic> getBuildEnvironment() {
    return {
      'dartVersion': '3.0.0', // This would be determined at build time
      'buildType': 'release',
      'buildTime': getBuildTimestamp(),
      'platform': 'web', // This would be determined at build time
      'architecture': 'x64', // This would be determined at build time
    };
  }

  /// Validates the version.
  /// 
  /// Returns true if the version is valid, false otherwise.
  bool validate() {
    if (major < 0 || minor < 0 || patch < 0) {
      return false;
    }
    
    if (preRelease != null && preRelease!.isEmpty) {
      return false;
    }
    
    if (buildMetadata != null && buildMetadata!.isEmpty) {
      return false;
    }
    
    return true;
  }

  /// Gets the version changelog URL.
  /// 
  /// Returns the URL to the changelog for this version.
  String getChangelogUrl() {
    return '$repository/releases/tag/v${getCoreVersionString()}';
  }

  /// Checks if an update is available.
  /// 
  /// [latestVersion]: The latest available version.
  /// 
  /// Returns true if an update is available, false otherwise.
  bool isUpdateAvailable(_Version latestVersion) {
    return compareTo(latestVersion) < 0;
  }

  /// Gets the update type (major, minor, patch).
  /// 
  /// [latestVersion]: The latest available version.
  /// 
  /// Returns the update type as a string.
  String getUpdateType(_Version latestVersion) {
    if (latestVersion.major > major) {
      return 'major';
    } else if (latestVersion.minor > minor) {
      return 'minor';
    } else if (latestVersion.patch > patch) {
      return 'patch';
    } else {
      return 'none';
    }
  }

  /// Gets a human-readable version description.
  /// 
  /// Returns a human-readable description of the version.
  String getDescription() {
    if (isDevelopment()) {
      return 'Development Version $major.$minor.$patch';
    } else if (isPreRelease()) {
      return 'Pre-release $preRelease Version $major.$minor.$patch';
    } else if (isStable()) {
      return 'Stable Version $major.$minor.$patch';
    } else {
      return 'Version $major.$minor.$patch';
    }
  }

  /// Overrides the toString method.
  /// 
  /// Returns the version string.
  @override
  String toString() {
    return getVersionString();
  }

  /// Overrides the equality operator.
  /// 
  /// [other]: The object to compare with.
  /// 
  /// Returns true if the versions are equal, false otherwise.
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! _Version) return false;
    
    return major == other.major &&
           minor == other.minor &&
           patch == other.patch &&
           preRelease == other.preRelease;
  }

  /// Overrides the hash code.
  /// 
  /// Returns the hash code.
  @override
  int get hashCode {
    return major.hashCode ^
           minor.hashCode ^
           patch.hashCode ^
           (preRelease?.hashCode ?? 0);
  }

  /// Less than operator.
  /// 
  /// [other]: The other version to compare with.
  /// 
  /// Returns true if this version is less than the other version.
  bool operator <(_Version other) => compareTo(other) < 0;

  /// Less than or equal operator.
  /// 
  /// [other]: The other version to compare with.
  /// 
  /// Returns true if this version is less than or equal to the other version.
  bool operator <=(_Version other) => compareTo(other) <= 0;

  /// Greater than operator.
  /// 
  /// [other]: The other version to compare with.
  /// 
  /// Returns true if this version is greater than the other version.
  bool operator >(_Version other) => compareTo(other) > 0;

  /// Greater than or equal operator.
  /// 
  /// [other]: The other version to compare with.
  /// 
  /// Returns true if this version is greater than or equal to the other version.
  bool operator >=(_Version other) => compareTo(other) >= 0;
}
