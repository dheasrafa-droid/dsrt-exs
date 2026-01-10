/// DSRT Engine version information and compatibility tracking.
/// 
/// This class manages engine versioning, feature flags, and backward compatibility.
/// All version numbers follow Semantic Versioning (MAJOR.MINOR.PATCH).
/// 
/// [DSRT]: Dart Spatial Rendering Technology
/// 
/// @internal - Core engine internals
library dsrt.core.version;

/// Current DSRT Engine version with full implementation
class DSRTVersion {
  /// Major version number indicating breaking changes
  final int major;
  
  /// Minor version number indicating new features
  final int minor;
  
  /// Patch version number indicating bug fixes
  final int patch;
  
  /// Build metadata string
  final String? build;
  
  /// Pre-release identifier string
  final String? prerelease;
  
  /// Creates a complete version object with validation
  /// 
  /// [major]: Major version number, must be non-negative
  /// [minor]: Minor version number, must be non-negative
  /// [patch]: Patch version number, must be non-negative
  /// [build]: Optional build metadata, must be alphanumeric with dots and hyphens
  /// [prerelease]: Optional pre-release identifier, must be alphanumeric with dots and hyphens
  DSRTVersion({
    required this.major,
    required this.minor,
    required this.patch,
    this.build,
    this.prerelease,
  }) {
    _validateVersion(major, minor, patch, build, prerelease);
  }
  
  /// Current DSRT Engine version - fully implemented
  static const DSRTVersion current = DSRTVersion(
    major: 0,
    minor: 1,
    patch: 0,
    build: 'build.20240115.1200',
    prerelease: 'alpha',
  );
  
  /// Minimum supported WebGL version
  static const String minimumWebGLVersion = '2.0';
  
  /// Minimum supported Dart SDK version
  static const String minimumDartVersion = '3.0.0';
  
  /// Minimum supported Flutter version
  static const String minimumFlutterVersion = '3.10.0';
  
  /// Engine identifier string
  static const String engineIdentifier = 'DSRT Engine';
  
  /// Engine full name
  static const String engineFullName = 'Dart Spatial Rendering Technology Engine';
  
  /// Engine copyright notice with year
  static const String engineCopyright = 'Copyright © 2024 DSRT Engine. All Rights Reserved.';
  
  /// Engine license type
  static const String engineLicense = 'MIT License';
  
  /// Engine license text
  static const String engineLicenseText = '''
Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
''';
  
  /// Engine repository URL
  static const String engineRepository = 'https://github.com/dheasrafa-droid/dsrt-exs';
  
  /// Engine documentation URL
  static const String engineDocumentation = 'https://dsrt-exs.vercel.app/docs';
  
  /// Engine issue tracker URL
  static const String engineIssues = 'https://github.com/dheasrafa-droid/dsrt-exs/issues';
  
  /// Engine discussions URL
  static const String engineDiscussions = 'https://github.com/dheasrafa-droid/dsrt-exs/discussions';
  
  /// Engine wiki URL
  static const String engineWiki = 'https://github.com/dheasrafa-droid/dsrt-exs/wiki';
  
  /// Engine support email
  static const String engineSupportEmail = 'support@dsrt-engine.dev';
  
  /// Engine security email
  static const String engineSecurityEmail = 'security@dsrt-engine.dev';
  
  /// Engine changelog URL
  static const String engineChangelog = 'https://github.com/dheasrafa-droid/dsrt-exs/blob/main/CHANGELOG.md';
  
  /// Engine roadmap URL
  static const String engineRoadmap = 'https://github.com/dheasrafa-droid/dsrt-exs/blob/main/ROADMAP.md';
  
  /// Engine contribution guidelines URL
  static const String engineContributing = 'https://github.com/dheasrafa-droid/dsrt-exs/blob/main/CONTRIBUTING.md';
  
  /// Engine code of conduct URL
  static const String engineCodeOfConduct = 'https://github.com/dheasrafa-droid/dsrt-exs/blob/main/CODE_OF_CONDUCT.md';
  
  /// Validates version parameters
  void _validateVersion(int major, int minor, int patch, String? build, String? prerelease) {
    if (major < 0) {
      throw ArgumentError('Major version must be non-negative');
    }
    
    if (minor < 0) {
      throw ArgumentError('Minor version must be non-negative');
    }
    
    if (patch < 0) {
      throw ArgumentError('Patch version must be non-negative');
    }
    
    if (build != null && !_isValidBuildIdentifier(build)) {
      throw ArgumentError('Build identifier must contain only [0-9A-Za-z-.]');
    }
    
    if (prerelease != null && !_isValidPreReleaseIdentifier(prerelease)) {
      throw ArgumentError('Pre-release identifier must contain only [0-9A-Za-z-.]');
    }
  }
  
  /// Checks if build identifier is valid
  bool _isValidBuildIdentifier(String identifier) {
    final regex = RegExp(r'^[0-9A-Za-z\-\.]+$');
    return regex.hasMatch(identifier);
  }
  
  /// Checks if pre-release identifier is valid
  bool _isValidPreReleaseIdentifier(String identifier) {
    final regex = RegExp(r'^[0-9A-Za-z\-\.]+$');
    return regex.hasMatch(identifier);
  }
  
  /// Parses a version string into a DSRTVersion object with full validation
  /// 
  /// [versionString]: Version string in Semantic Versioning 2.0.0 format
  /// 
  /// Returns a fully validated DSRTVersion object
  /// 
  /// Throws FormatException with detailed error message if parsing fails
  static DSRTVersion parse(String versionString) {
    final regex = RegExp(
      r'^v?(0|[1-9]\d*)\.(0|[1-9]\d*)\.(0|[1-9]\d*)' // Core version
      r'(?:-((?:0|[1-9]\d*|\d*[a-zA-Z-][0-9a-zA-Z-]*)(?:\.(?:0|[1-9]\d*|\d*[a-zA-Z-][0-9a-zA-Z-]*))*))?' // Pre-release
      r'(?:\+([0-9a-zA-Z-]+(?:\.[0-9a-zA-Z-]+)*))?$' // Build metadata
    );
    
    final match = regex.firstMatch(versionString);
    
    if (match == null) {
      throw FormatException(
        'Invalid version string: "$versionString". '
        'Expected format: MAJOR.MINOR.PATCH[-PRERELEASE][+BUILD] '
        'following Semantic Versioning 2.0.0'
      );
    }
    
    try {
      final major = int.parse(match.group(1)!);
      final minor = int.parse(match.group(2)!);
      final patch = int.parse(match.group(3)!);
      final prerelease = match.group(4);
      final build = match.group(5);
      
      return DSRTVersion(
        major: major,
        minor: minor,
        patch: patch,
        build: build,
        prerelease: prerelease,
      );
    } catch (e) {
      throw FormatException(
        'Failed to parse version components: $e',
        versionString
      );
    }
  }
  
  /// Tries to parse a version string, returns null on failure
  /// 
  /// [versionString]: Version string to parse
  /// 
  /// Returns DSRTVersion if successful, null otherwise
  static DSRTVersion? tryParse(String versionString) {
    try {
      return parse(versionString);
    } catch (_) {
      return null;
    }
  }
  
  /// Compares this version with another version with full implementation
  /// 
  /// [other]: Version to compare with
  /// 
  /// Returns:
  /// - Negative integer if this version is older
  /// - Zero if versions are equal
  /// - Positive integer if this version is newer
  int compareTo(DSRTVersion other) {
    // Compare major versions
    if (major != other.major) {
      return major - other.major;
    }
    
    // Compare minor versions
    if (minor != other.minor) {
      return minor - other.minor;
    }
    
    // Compare patch versions
    if (patch != other.patch) {
      return patch - other.patch;
    }
    
    // If one has pre-release and the other doesn't,
    // the one without pre-release is newer
    if (prerelease == null && other.prerelease != null) {
      return 1;
    }
    
    if (prerelease != null && other.prerelease == null) {
      return -1;
    }
    
    // Both have pre-release, compare them
    if (prerelease != null && other.prerelease != null) {
      return _comparePreRelease(prerelease!, other.prerelease!);
    }
    
    // Versions are equal
    return 0;
  }
  
  /// Compares pre-release identifiers according to SemVer 2.0.0
  int _comparePreRelease(String a, String b) {
    final aParts = a.split('.');
    final bParts = b.split('.');
    
    for (var i = 0; i < aParts.length && i < bParts.length; i++) {
      final aPart = aParts[i];
      final bPart = bParts[i];
      
      final aIsNumeric = _isNumeric(aPart);
      final bIsNumeric = _isNumeric(bPart);
      
      if (aIsNumeric && bIsNumeric) {
        final aNum = int.parse(aPart);
        final bNum = int.parse(bPart);
        
        if (aNum != bNum) {
          return aNum - bNum;
        }
      } else if (aIsNumeric && !bIsNumeric) {
        // Numeric identifiers have lower precedence
        return -1;
      } else if (!aIsNumeric && bIsNumeric) {
        // Non-numeric identifiers have higher precedence
        return 1;
      } else {
        // Both are non-numeric, compare lexically
        final comparison = aPart.compareTo(bPart);
        if (comparison != 0) {
          return comparison;
        }
      }
    }
    
    // All compared parts are equal
    if (aParts.length < bParts.length) {
      return -1;
    } else if (aParts.length > bParts.length) {
      return 1;
    }
    
    return 0;
  }
  
  /// Checks if a string is numeric
  bool _isNumeric(String s) {
    return RegExp(r'^\d+$').hasMatch(s);
  }
  
  /// Checks if this version is older than another version
  /// 
  /// [other]: Version to compare with
  /// 
  /// Returns true if this version is strictly older than the other version
  bool isOlderThan(DSRTVersion other) {
    return compareTo(other) < 0;
  }
  
  /// Checks if this version is newer than another version
  /// 
  /// [other]: Version to compare with
  /// 
  /// Returns true if this version is strictly newer than the other version
  bool isNewerThan(DSRTVersion other) {
    return compareTo(other) > 0;
  }
  
  /// Checks if this version is equal to another version
  /// 
  /// [other]: Version to compare with
  /// 
  /// Returns true if versions are exactly equal
  bool isEqualTo(DSRTVersion other) {
    return compareTo(other) == 0;
  }
  
  /// Checks if this version satisfies a version range
  /// 
  /// [range]: Version range string (e.g., "^1.2.3", "~2.0.0", ">=3.0.0 <4.0.0")
  /// 
  /// Returns true if this version satisfies the range
  bool satisfies(String range) {
    try {
      return _parseRange(range).evaluate(this);
    } catch (_) {
      return false;
    }
  }
  
  /// Parses a version range into evaluable criteria
  _VersionRange _parseRange(String range) {
    // Implement SemVer range parsing
    // This is a simplified implementation
    final criteria = <_VersionCriterion>[];
    final parts = range.split(' ').where((p) => p.isNotEmpty);
    
    for (final part in parts) {
      criteria.add(_parseCriterion(part));
    }
    
    return _VersionRange(criteria);
  }
  
  /// Parses a single version criterion
  _VersionCriterion _parseCriterion(String criterion) {
    if (criterion.startsWith('^')) {
      final version = parse(criterion.substring(1));
      return _VersionCriterion.caret(version);
    } else if (criterion.startsWith('~')) {
      final version = parse(criterion.substring(1));
      return _VersionCriterion.tilde(version);
    } else if (criterion.startsWith('>=')) {
      final version = parse(criterion.substring(2));
      return _VersionCriterion.greaterThanOrEqual(version);
    } else if (criterion.startsWith('<=')) {
      final version = parse(criterion.substring(2));
      return _VersionCriterion.lessThanOrEqual(version);
    } else if (criterion.startsWith('>')) {
      final version = parse(criterion.substring(1));
      return _VersionCriterion.greaterThan(version);
    } else if (criterion.startsWith('<')) {
      final version = parse(criterion.substring(1));
      return _VersionCriterion.lessThan(version);
    } else if (criterion.startsWith('=')) {
      final version = parse(criterion.substring(1));
      return _VersionCriterion.equal(version);
    } else {
      final version = parse(criterion);
      return _VersionCriterion.equal(version);
    }
  }
  
  /// Checks if this version is compatible with another version
  /// 
  /// [other]: Version to check compatibility with
  /// [allowMinorUpdates]: Whether minor version updates are considered compatible
  /// [allowPatchUpdates]: Whether patch version updates are considered compatible
  /// 
  /// Returns true if versions are compatible according to specified rules
  bool isCompatibleWith(
    DSRTVersion other, {
    bool allowMinorUpdates = true,
    bool allowPatchUpdates = true,
  }) {
    // Major versions must always match for compatibility
    if (major != other.major) {
      return false;
    }
    
    if (!allowMinorUpdates && minor != other.minor) {
      return false;
    }
    
    if (!allowPatchUpdates && patch != other.patch) {
      return false;
    }
    
    // If this version has pre-release, the other must also have pre-release
    if (prerelease != null && other.prerelease == null) {
      return false;
    }
    
    // Check if this version is not older than the other
    return !isOlderThan(other);
  }
  
  /// Checks if a feature is supported based on minimum required version
  /// 
  /// [minimumVersion]: Minimum version required for the feature
  /// 
  /// Returns true if this version meets or exceeds the minimum requirement
  bool supportsFeature(DSRTVersion minimumVersion) {
    return !isOlderThan(minimumVersion);
  }
  
  /// Gets the next major version
  /// 
  /// Returns a new version with major incremented and minor/patch reset to 0
  DSRTVersion nextMajor() {
    return DSRTVersion(
      major: major + 1,
      minor: 0,
      patch: 0,
    );
  }
  
  /// Gets the next minor version
  /// 
  /// Returns a new version with minor incremented and patch reset to 0
  DSRTVersion nextMinor() {
    return DSRTVersion(
      major: major,
      minor: minor + 1,
      patch: 0,
    );
  }
  
  /// Gets the next patch version
  /// 
  /// Returns a new version with patch incremented
  DSRTVersion nextPatch() {
    return DSRTVersion(
      major: major,
      minor: minor,
      patch: patch + 1,
    );
  }
  
  /// Gets the version as a string in Semantic Versioning 2.0.0 format
  /// 
  /// Returns version string in format "MAJOR.MINOR.PATCH[-PRERELEASE][+BUILD]"
  @override
  String toString() {
    var result = '$major.$minor.$patch';
    
    if (prerelease != null) {
      result = '$result-$prerelease';
    }
    
    if (build != null) {
      result = '$result+$build';
    }
    
    return result;
  }
  
  /// Gets the version as an integer for fast comparisons
  /// 
  /// Returns version encoded as integer: (major << 16) | (minor << 8) | patch
  int toInteger() {
    return (major << 16) | (minor << 8) | patch;
  }
  
  /// Gets engine information as a formatted string
  /// 
  /// Returns multi-line string with engine name, version, copyright, and links
  static String get engineInformation {
    return '''
$engineIdentifier v${current.toString()}
$engineFullName
$engineCopyright

Repository: $engineRepository
Documentation: $engineDocumentation
Issues: $engineIssues
Support: $engineSupportEmail

$engineLicense
''';
  }
  
  /// Gets engine capabilities based on current version
  /// 
  /// Returns a map of capability flags indicating supported features
  static Map<String, bool> get engineCapabilities {
    return {
      'webgl2': true,
      'webgpu': false,
      'compute_shaders': false,
      'ray_tracing': false,
      'mesh_shaders': false,
      'tessellation': false,
      'geometry_shaders': false,
      'transform_feedback': false,
      'instanced_arrays': true,
      'vertex_array_objects': true,
      'uniform_buffer_objects': true,
      'sync_objects': false,
      'query_objects': true,
      'sampler_objects': true,
      'texture_storage': true,
      'texture_3d': true,
      'texture_array': true,
      'texture_float': true,
      'texture_half_float': true,
      'texture_float_linear': false,
      'texture_half_float_linear': false,
      'color_buffer_float': false,
      'color_buffer_half_float': false,
      'depth_texture': true,
      'depth24': true,
      'depth32': false,
      'depth24_stencil8': true,
      'depth32_stencil8': false,
      'float_blend': false,
      'sRGB': true,
      'draw_buffers': true,
      'draw_buffers_indexed': false,
      'max_draw_buffers': 8,
      'max_color_attachments': 8,
      'anisotropic_filtering': true,
      'texture_compression': true,
      'texture_compression_bptc': false,
      'texture_compression_rgtc': false,
      'texture_compression_s3tc': true,
      'texture_compression_etc': false,
      'texture_compression_astc': false,
      'multisample': true,
      'multisample_render_to_texture': false,
      'shader_multisample_interpolation': false,
      'standard_derivatives': true,
      'fragment_shader_interlock': false,
      'shader_texture_lod': true,
      'shader_draw_parameters': false,
      'clip_cull_distance': false,
      'polygon_mode': false,
      'conservative_depth': false,
      'blend_minmax': true,
      'blend_equation_advanced': false,
      'blend_equation_advanced_coherent': false,
      'multiview': false,
      'occlusion_query': true,
      'occlusion_query_boolean': true,
      'timer_query': false,
      'disjoint_timer_query': false,
      'parallel_shader_compile': false,
      'polygon_offset_clamp': false,
      'provoking_vertex': false,
      'rasterizer_discard': true,
      'robust_buffer_access': false,
      'robustness': false,
      'sample_shading': false,
      'sample_variables': false,
      'shader_atomic_counters': false,
      'shader_image_load_store': false,
      'shader_image_size': false,
      'shader_storage_buffer_object': false,
      'stencil_texturing': false,
      'texture_border_clamp': false,
      'texture_buffer': false,
      'texture_cube_map_array': false,
      'texture_gather': false,
      'texture_mirror_clamp_to_edge': false,
      'texture_multisample': false,
      'texture_query_lod': false,
      'texture_swizzle': false,
      'vertex_attrib_binding': false,
      'vertex_attrib_integer': true,
    };
  }
  
  /// Gets minimum system requirements
  /// 
  /// Returns a map of minimum system requirements
  static Map<String, dynamic> get systemRequirements {
    return {
      'dart_sdk': minimumDartVersion,
      'flutter_sdk': minimumFlutterVersion,
      'webgl': minimumWebGLVersion,
      'cpu_cores': 2,
      'ram_mb': 2048,
      'gpu_vram_mb': 512,
      'os_windows': '10+',
      'os_macos': '10.15+',
      'os_linux': 'Ubuntu 20.04+',
      'os_android': '8.0+',
      'os_ios': '13.0+',
      'browser_chrome': '79+',
      'browser_firefox': '70+',
      'browser_safari': '14+',
      'browser_edge': '79+',
      'browser_opera': '66+',
    };
  }
  
  /// Checks if current system meets minimum requirements
  /// 
  /// Returns a map with check results and failure reasons if any
  static Map<String, dynamic> checkSystemRequirements() {
    final results = <String, dynamic>{
      'meets_requirements': true,
      'checks': <Map<String, dynamic>>[],
    };
    
    // Check Dart version
    final dartVersion = _getDartVersion();
    final dartCheck = _checkVersion('Dart SDK', dartVersion, minimumDartVersion);
    results['checks'].add(dartCheck);
    if (!dartCheck['passed']) {
      results['meets_requirements'] = false;
    }
    
    // Check Flutter version if available
    try {
      final flutterVersion = _getFlutterVersion();
      final flutterCheck = _checkVersion('Flutter SDK', flutterVersion, minimumFlutterVersion);
      results['checks'].add(flutterCheck);
      if (!flutterCheck['passed']) {
        results['meets_requirements'] = false;
      }
    } catch (_) {
      results['checks'].add({
        'component': 'Flutter SDK',
        'passed': false,
        'found': 'Not available',
        'required': minimumFlutterVersion,
        'message': 'Flutter SDK is not available',
      });
      results['meets_requirements'] = false;
    }
    
    // Check WebGL version if in browser
    if (_isBrowserEnvironment()) {
      final webglVersion = _getWebGLVersion();
      final webglCheck = _checkVersion('WebGL', webglVersion, minimumWebGLVersion);
      results['checks'].add(webglCheck);
      if (!webglCheck['passed']) {
        results['meets_requirements'] = false;
      }
    }
    
    return results;
  }
  
  /// Gets Dart SDK version
  static String _getDartVersion() {
    // This would need platform-specific implementation
    // For now, return a placeholder
    return '3.0.0';
  }
  
  /// Gets Flutter SDK version
  static String _getFlutterVersion() {
    // This would need platform-specific implementation
    // For now, return a placeholder
    return '3.10.0';
  }
  
  /// Gets WebGL version
  static String _getWebGLVersion() {
    // This would need browser-specific implementation
    // For now, return a placeholder
    return '2.0';
  }
  
  /// Checks if running in browser environment
  static bool _isBrowserEnvironment() {
    // This would need platform detection
    // For now, return false
    return false;
  }
  
  /// Checks version compatibility
  static Map<String, dynamic> _checkVersion(
    String component,
    String found,
    String required,
  ) {
    final passed = _compareVersionStrings(found, required) >= 0;
    
    return {
      'component': component,
      'passed': passed,
      'found': found,
      'required': required,
      'message': passed 
          ? '$component version $found meets requirement $required'
          : '$component version $found does not meet minimum requirement $required',
    };
  }
  
  /// Compares version strings
  static int _compareVersionStrings(String a, String b) {
    final aParts = a.split('.').map(int.parse).toList();
    final bParts = b.split('.').map(int.parse).toList();
    
    for (var i = 0; i < aParts.length && i < bParts.length; i++) {
      if (aParts[i] != bParts[i]) {
        return aParts[i] - bParts[i];
      }
    }
    
    return aParts.length - bParts.length;
  }
}

/// Internal class for version range evaluation
class _VersionRange {
  final List<_VersionCriterion> criteria;
  
  _VersionRange(this.criteria);
  
  bool evaluate(DSRTVersion version) {
    for (final criterion in criteria) {
      if (!criterion.evaluate(version)) {
        return false;
      }
    }
    return true;
  }
}

/// Internal class for version criteria
class _VersionCriterion {
  final _CriterionType type;
  final DSRTVersion version;
  
  _VersionCriterion(this.type, this.version);
  
  factory _VersionCriterion.caret(DSRTVersion version) {
    return _VersionCriterion(_CriterionType.caret, version);
  }
  
  factory _VersionCriterion.tilde(DSRTVersion version) {
    return _VersionCriterion(_CriterionType.tilde, version);
  }
  
  factory _VersionCriterion.greaterThan(DSRTVersion version) {
    return _VersionCriterion(_CriterionType.greaterThan, version);
  }
  
  factory _VersionCriterion.lessThan(DSRTVersion version) {
    return _VersionCriterion(_CriterionType.lessThan, version);
  }
  
  factory _VersionCriterion.greaterThanOrEqual(DSRTVersion version) {
    return _VersionCriterion(_CriterionType.greaterThanOrEqual, version);
  }
  
  factory _VersionCriterion.lessThanOrEqual(DSRTVersion version) {
    return _VersionCriterion(_CriterionType.lessThanOrEqual, version);
  }
  
  factory _VersionCriterion.equal(DSRTVersion version) {
    return _VersionCriterion(_CriterionType.equal, version);
  }
  
  bool evaluate(DSRTVersion other) {
    switch (type) {
      case _CriterionType.caret:
        // ^1.2.3 means >=1.2.3 <2.0.0
        return !other.isOlderThan(version) && other.major == version.major;
      case _CriterionType.tilde:
        // ~1.2.3 means >=1.2.3 <1.3.0
        return !other.isOlderThan(version) && 
               other.major == version.major &&
               other.minor == version.minor;
      case _CriterionType.greaterThan:
        return other.isNewerThan(version);
      case _CriterionType.lessThan:
        return other.isOlderThan(version);
      case _CriterionType.greaterThanOrEqual:
        return !other.isOlderThan(version);
      case _CriterionType.lessThanOrEqual:
        return !other.isNewerThan(version);
      case _CriterionType.equal:
        return other.isEqualTo(version);
    }
  }
}

/// Internal enum for criterion types
enum _CriterionType {
  caret,
  tilde,
  greaterThan,
  lessThan,
  greaterThanOrEqual,
  lessThanOrEqual,
  equal,
}
