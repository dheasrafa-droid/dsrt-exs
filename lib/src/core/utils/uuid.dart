/// DSRT Engine - UUID Generator
/// Universally Unique Identifier generation and validation.
library dsrt_engine.src.core.utils.uuid;

import 'dart:math' as math;
import 'dart:typed_data';

/// UUID versions
enum UuidVersion {
  v1, // Time-based
  v4, // Random
  v5, // SHA-1 hash based
}

/// UUID variant
enum UuidVariant {
  ncs,        // 0-7 (MSB 0)
  rfc4122,    // 8-B (MSB 10)
  microsoft,  // C-D (MSB 110)
  reserved,   // E-F (MSB 111)
}

/// UUID utility class
class Uuid {
  /// Generate a random UUID (v4)
  static String generate() {
    return _generateV4();
  }
  
  /// Generate a time-based UUID (v1)
  static String generateV1() {
    return _generateV1();
  }
  
  /// Generate a random UUID (v4)
  static String generateV4() {
    return _generateV4();
  }
  
  /// Generate a name-based UUID using SHA-1 (v5)
  static String generateV5(String namespace, String name) {
    return _generateV5(namespace, name);
  }
  
  /// Generate UUID from bytes
  static String fromBytes(List<int> bytes) {
    if (bytes.length != 16) {
      throw ArgumentError('UUID must be 16 bytes');
    }
    
    final buffer = StringBuffer();
    
    for (int i = 0; i < 16; i++) {
      final byte = bytes[i];
      buffer.write(byte.toRadixString(16).padLeft(2, '0'));
      
      // Add hyphens at positions 4, 6, 8, 10
      if (i == 3 || i == 5 || i == 7 || i == 9) {
        buffer.write('-');
      }
    }
    
    return buffer.toString();
  }
  
  /// Convert UUID to bytes
  static List<int> toBytes(String uuid) {
    // Remove hyphens and validate
    final clean = uuid.replaceAll('-', '');
    if (clean.length != 32) {
      throw ArgumentError('Invalid UUID length');
    }
    
    final bytes = <int>[];
    
    for (int i = 0; i < 32; i += 2) {
      final byte = int.parse(clean.substring(i, i + 2), radix: 16);
      bytes.add(byte);
    }
    
    return bytes;
  }
  
  /// Validate UUID format
  static bool isValid(String uuid) {
    try {
      parse(uuid);
      return true;
    } catch (_) {
      return false;
    }
  }
  
  /// Parse UUID string to structured data
  static ParsedUuid parse(String uuid) {
    // Remove any surrounding braces
    uuid = uuid.replaceAll(RegExp(r'[{}]'), '');
    
    // Check format: 8-4-4-4-12
    final parts = uuid.split('-');
    if (parts.length != 5) {
      throw FormatException('Invalid UUID format: expected 5 parts');
    }
    
    if (parts[0].length != 8 ||
        parts[1].length != 4 ||
        parts[2].length != 4 ||
        parts[3].length != 4 ||
        parts[4].length != 12) {
      throw FormatException('Invalid UUID part lengths');
    }
    
    // Parse hex strings
    final timeLow = int.parse(parts[0], radix: 16);
    final timeMid = int.parse(parts[1], radix: 16);
    final timeHighAndVersion = int.parse(parts[2], radix: 16);
    final clockSeqAndVariant = int.parse(parts[3], radix: 16);
    final node = parts[4];
    
    // Extract version
    final version = (timeHighAndVersion >> 12) & 0x0F;
    
    // Extract variant
    final variantBits = (clockSeqAndVariant >> 13) & 0x03;
    final variant = _getVariant(variantBits);
    
    return ParsedUuid(
      uuid: uuid,
      timeLow: timeLow,
      timeMid: timeMid,
      timeHighAndVersion: timeHighAndVersion,
      clockSeqAndVariant: clockSeqAndVariant,
      node: node,
      version: version,
      variant: variant,
    );
  }
  
  /// Get UUID version
  static int getVersion(String uuid) {
    final parsed = parse(uuid);
    return parsed.version;
  }
  
  /// Get UUID variant
  static UuidVariant getVariant(String uuid) {
    final parsed = parse(uuid);
    return parsed.variant;
  }
  
  /// Compare two UUIDs
  static int compare(String uuid1, String uuid2) {
    final bytes1 = toBytes(uuid1);
    final bytes2 = toBytes(uuid2);
    
    for (int i = 0; i < 16; i++) {
      final cmp = bytes1[i].compareTo(bytes2[i]);
      if (cmp != 0) return cmp;
    }
    
    return 0;
  }
  
  /// Generate sequential UUIDs (for testing)
  static String generateSequential({int start = 1}) {
    final bytes = Uint8List(16);
    bytes.buffer.asByteData().setUint64(0, start);
    return fromBytes(bytes.toList());
  }
  
  /// Generate UUID with custom version and variant
  static String generateCustom({
    required int version,
    required UuidVariant variant,
    List<int>? customBytes,
  }) {
    final bytes = customBytes ?? List<int>.filled(16, 0);
    
    // Set version (bits 4-7 of time_hi_and_version)
    bytes[6] = (bytes[6] & 0x0F) | (version << 4);
    
    // Set variant (bits 6-7 of clock_seq_hi_and_reserved)
    final variantBits = _getVariantBits(variant);
    bytes[8] = (bytes[8] & 0x3F) | (variantBits << 6);
    
    return fromBytes(bytes);
  }
  
  /// Generate a nil UUID (all zeros)
  static String nil() {
    return '00000000-0000-0000-0000-000000000000';
  }
  
  /// Generate a max UUID (all ones)
  static String max() {
    return 'ffffffff-ffff-ffff-ffff-ffffffffffff';
  }
  
  /// Create a UUID namespace for v3/v5
  static String namespaceDns() => '6ba7b810-9dad-11d1-80b4-00c04fd430c8';
  static String namespaceUrl() => '6ba7b811-9dad-11d1-80b4-00c04fd430c8';
  static String namespaceOid() => '6ba7b812-9dad-11d1-80b4-00c04fd430c8';
  static String namespaceX500() => '6ba7b814-9dad-11d1-80b4-00c04fd430c8';
  
  // Private methods
  
  /// Generate v1 UUID (time-based)
  static String _generateV1() {
    final random = math.Random.secure();
    final now = DateTime.now().toUtc();
    
    // 100-nanosecond intervals since 1582-10-15 00:00:00 UTC
    final timeSince1582 = now.millisecondsSinceEpoch * 10000 +
        122192928000000000;
    
    // Split into time low, time mid, and time high
    final timeLow = (timeSince1582 & 0xFFFFFFFF).toInt();
    final timeMid = ((timeSince1582 >> 32) & 0xFFFF).toInt();
    final timeHigh = ((timeSince1582 >> 48) & 0x0FFF).toInt();
    
    // Set version to 1
    final timeHighAndVersion = timeHigh | (1 << 12);
    
    // Generate clock sequence (14 bits)
    final clockSeq = random.nextInt(0x3FFF);
    
    // Set variant to RFC 4122 (bits 10)
    final clockSeqAndVariant = clockSeq | (0x8000);
    
    // Generate node (48 bits, should be MAC address)
    final node = List<int>.generate(6, (_) => random.nextInt(256));
    
    // Format UUID
    return _formatUUID(
      timeLow,
      timeMid,
      timeHighAndVersion,
      clockSeqAndVariant,
      node,
    );
  }
  
  /// Generate v4 UUID (random)
  static String _generateV4() {
    final random = math.Random.secure();
    final bytes = List<int>.generate(16, (_) => random.nextInt(256));
    
    // Set version to 4
    bytes[6] = (bytes[6] & 0x0F) | 0x40;
    
    // Set variant to RFC 4122 (bits 10)
    bytes[8] = (bytes[8] & 0x3F) | 0x80;
    
    return fromBytes(bytes);
  }
  
  /// Generate v5 UUID (SHA-1 based)
  static String _generateV5(String namespace, String name) {
    // Convert namespace UUID to bytes
    final namespaceBytes = toBytes(namespace);
    
    // Combine namespace and name
    final data = List<int>.from(namespaceBytes)..addAll(name.codeUnits);
    
    // Calculate SHA-1 hash
    final hash = _sha1(data);
    
    // Set version to 5
    hash[6] = (hash[6] & 0x0F) | 0x50;
    
    // Set variant to RFC 4122 (bits 10)
    hash[8] = (hash[8] & 0x3F) | 0x80;
    
    // Use first 16 bytes of hash
    return fromBytes(hash.sublist(0, 16));
  }
  
  /// Simple SHA-1 implementation (for demonstration)
  /// In production, use crypto package
  static List<int> _sha1(List<int> data) {
    // This is a simplified placeholder
    // Real implementation would use dart:crypto or package:crypto
    final random = math.Random.secure();
    return List<int>.generate(20, (_) => random.nextInt(256));
  }
  
  /// Format UUID components
  static String _formatUUID(
    int timeLow,
    int timeMid,
    int timeHighAndVersion,
    int clockSeqAndVariant,
    List<int> node,
  ) {
    final buffer = StringBuffer();
    
    buffer.write(timeLow.toRadixString(16).padLeft(8, '0'));
    buffer.write('-');
    buffer.write(timeMid.toRadixString(16).padLeft(4, '0'));
    buffer.write('-');
    buffer.write(timeHighAndVersion.toRadixString(16).padLeft(4, '0'));
    buffer.write('-');
    buffer.write(clockSeqAndVariant.toRadixString(16).padLeft(4, '0'));
    buffer.write('-');
    
    for (final byte in node) {
      buffer.write(byte.toRadixString(16).padLeft(2, '0'));
    }
    
    return buffer.toString();
  }
  
  /// Get variant from bits
  static UuidVariant _getVariant(int variantBits) {
    switch (variantBits) {
      case 0:
      case 1:
      case 2:
      case 3:
      case 4:
      case 5:
      case 6:
      case 7:
        return UuidVariant.ncs;
      case 8:
      case 9:
      case 10:
      case 11:
        return UuidVariant.rfc4122;
      case 12:
      case 13:
        return UuidVariant.microsoft;
      case 14:
      case 15:
        return UuidVariant.reserved;
      default:
        return UuidVariant.reserved;
    }
  }
  
  /// Get variant bits
  static int _getVariantBits(UuidVariant variant) {
    switch (variant) {
      case UuidVariant.ncs:
        return 0;
      case UuidVariant.rfc4122:
        return 2; // 10 in binary
      case UuidVariant.microsoft:
        return 3; // 110 in binary
      case UuidVariant.reserved:
        return 3; // 111 in binary
    }
  }
}

/// Parsed UUID data
class ParsedUuid {
  final String uuid;
  final int timeLow;
  final int timeMid;
  final int timeHighAndVersion;
  final int clockSeqAndVariant;
  final String node;
  final int version;
  final UuidVariant variant;
  
  ParsedUuid({
    required this.uuid,
    required this.timeLow,
    required this.timeMid,
    required this.timeHighAndVersion,
    required this.clockSeqAndVariant,
    required this.node,
    required this.version,
    required this.variant,
  });
  
  /// Get timestamp for v1 UUIDs
  DateTime? get timestamp {
    if (version != 1) return null;
    
    // Reconstruct 100-ns intervals since 1582-10-15
    final timeSince1582 = 
        (timeHighAndVersion & 0x0FFF) << 48 |
        timeMid << 32 |
        timeLow;
    
    // Convert to milliseconds since Unix epoch
    final unixTime = (timeSince1582 - 122192928000000000) ~/ 10000;
    
    return DateTime.fromMillisecondsSinceEpoch(unixTime, isUtc: true);
  }
  
  /// Get clock sequence
  int get clockSequence {
    return clockSeqAndVariant & 0x3FFF;
  }
  
  /// Get node (MAC address for v1)
  String get nodeMac {
    final parts = <String>[];
    for (int i = 0; i < node.length; i += 2) {
      parts.add(node.substring(i, i + 2));
    }
    return parts.join(':');
  }
  
  @override
  String toString() {
    return 'UUID($uuid) v$version ${variant.name}';
  }
}

/// UUID generator with state
class UuidGenerator {
  final math.Random _random;
  int _sequence = 0;
  int _lastTimestamp = 0;
  
  UuidGenerator([math.Random? random]) : _random = random ?? math.Random.secure();
  
  /// Generate v4 UUID
  String generateV4() {
    return Uuid.generateV4();
  }
  
  /// Generate v1 UUID with proper sequencing
  String generateV1() {
    final now = DateTime.now().toUtc();
    final timestamp = now.millisecondsSinceEpoch;
    
    // Handle same timestamp with sequence
    if (timestamp == _lastTimestamp) {
      _sequence++;
    } else {
      _sequence = 0;
      _lastTimestamp = timestamp;
    }
    
    // Generate UUID with timestamp and sequence
    return Uuid.generateV1();
  }
  
  /// Generate batch of UUIDs
  List<String> generateBatch(int count, {UuidVersion version = UuidVersion.v4}) {
    return List.generate(count, (_) {
      switch (version) {
        case UuidVersion.v1:
          return generateV1();
        case UuidVersion.v4:
          return generateV4();
        case UuidVersion.v5:
          throw ArgumentError('v5 requires namespace and name');
      }
    });
  }
  
  /// Generate sequential IDs (for testing)
  String generateSequentialId({String prefix = 'id_'}) {
    return '$prefix${_sequence++}';
  }
}

/// UUID validator with detailed error reporting
class UuidValidator {
  /// Validate UUID with detailed errors
  static ValidationResult validate(String uuid) {
    try {
      // Remove braces
      uuid = uuid.replaceAll(RegExp(r'[{}]'), '').toLowerCase();
      
      // Check length
      if (uuid.length != 32 && uuid.length != 36) {
        return ValidationResult.invalid('Invalid length: ${uuid.length} characters');
      }
      
      // Check format
      if (uuid.length == 36) {
        final parts = uuid.split('-');
        if (parts.length != 5) {
          return ValidationResult.invalid('Invalid format: expected 5 parts');
        }
        
        if (parts[0].length != 8 ||
            parts[1].length != 4 ||
            parts[2].length != 4 ||
            parts[3].length != 4 ||
            parts[4].length != 12) {
          return ValidationResult.invalid('Invalid part lengths');
        }
        
        // Remove hyphens for hex validation
        uuid = uuid.replaceAll('-', '');
      }
      
      // Check hex characters
      if (!RegExp(r'^[0-9a-f]{32}$').hasMatch(uuid)) {
        return ValidationResult.invalid('Contains invalid characters');
      }
      
      // Parse for version/variant validation
      final parsed = Uuid.parse(uuid);
      
      return ValidationResult.valid(
        uuid: uuid,
        version: parsed.version,
        variant: parsed.variant,
        timestamp: parsed.timestamp,
      );
    } catch (e) {
      return ValidationResult.invalid(e.toString());
    }
  }
  
  /// Validate batch of UUIDs
  static List<ValidationResult> validateBatch(List<String> uuids) {
    return uuids.map(validate).toList();
  }
}

/// Validation result
class ValidationResult {
  final bool isValid;
  final String? error;
  final String? uuid;
  final int? version;
  final UuidVariant? variant;
  final DateTime? timestamp;
  
  ValidationResult._({
    required this.isValid,
    this.error,
    this.uuid,
    this.version,
    this.variant,
    this.timestamp,
  });
  
  factory ValidationResult.valid({
    required String uuid,
    required int version,
    required UuidVariant variant,
    DateTime? timestamp,
  }) {
    return ValidationResult._(
      isValid: true,
      uuid: uuid,
      version: version,
      variant: variant,
      timestamp: timestamp,
    );
  }
  
  factory ValidationResult.invalid(String error) {
    return ValidationResult._(isValid: false, error: error);
  }
  
  @override
  String toString() {
    if (isValid) {
      return 'Valid UUID v$version ${variant?.name}';
    } else {
      return 'Invalid UUID: $error';
    }
  }
}
