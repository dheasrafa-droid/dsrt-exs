// lib/src/core/math/vector4.dart

/// DSRT Engine - 4D Vector Mathematics
/// 
/// Provides comprehensive 4D vector operations for homogeneous coordinates,
/// quaternion operations, and advanced mathematical transformations.
/// 
/// @category Core
/// @subcategory Math
/// @version 1.0.0
/// @license MIT
/// @copyright DSRT Engine Team

library dsrt_engine.core.math.vector4;

import 'dart:math' as math;
import 'dart:typed_data';

import '../constants.dart';
import 'vector3.dart';

/// 4D Vector class for mathematical operations in homogeneous coordinates
class DsrtVector4 implements DsrtDisposable {
  /// X component
  double x;
  
  /// Y component
  double y;
  
  /// Z component
  double z;
  
  /// W component
  double w;
  
  /// Creates a 4D vector
  /// 
  /// [x]: X component (default: 0.0)
  /// [y]: Y component (default: 0.0)
  /// [z]: Z component (default: 0.0)
  /// [w]: W component (default: 0.0)
  DsrtVector4([this.x = 0.0, this.y = 0.0, this.z = 0.0, this.w = 0.0]);
  
  /// Creates a homogeneous vector from 3D coordinates
  /// 
  /// [x]: X component
  /// [y]: Y component
  /// [z]: Z component
  /// [w]: Homogeneous coordinate (default: 1.0)
  factory DsrtVector4.fromVector3(DsrtVector3 vec3, [double w = 1.0]) {
    return DsrtVector4(vec3.x, vec3.y, vec3.z, w);
  }
  
  /// Creates a vector from a list
  /// 
  /// [list]: List of [x, y, z, w] values
  /// 
  /// Throws [ArgumentError] if list length is not 4.
  factory DsrtVector4.fromList(List<double> list) {
    if (list.length != 4) {
      throw ArgumentError('List must contain exactly 4 elements');
    }
    return DsrtVector4(list[0], list[1], list[2], list[3]);
  }
  
  /// Creates a vector from a Float32List
  /// 
  /// [array]: Float32List containing vector data
  /// [offset]: Offset in the array (default: 0)
  /// 
  /// Throws [ArgumentError] if array doesn't have enough elements.
  factory DsrtVector4.fromFloat32List(Float32List array, [int offset = 0]) {
    if (offset + 4 > array.length) {
      throw ArgumentError('Array does not have enough elements');
    }
    return DsrtVector4(
      array[offset],
      array[offset + 1],
      array[offset + 2],
      array[offset + 3],
    );
  }
  
  /// Creates a vector with all components set to the same value
  /// 
  /// [scalar]: Value for x, y, z, and w components
  factory DsrtVector4.scalar(double scalar) {
    return DsrtVector4(scalar, scalar, scalar, scalar);
  }
  
  /// Creates a color vector from RGBA values (0-255 range)
  /// 
  /// [r]: Red component (0-255)
  /// [g]: Green component (0-255)
  /// [b]: Blue component (0-255)
  /// [a]: Alpha component (0-255, default: 255)
  factory DsrtVector4.fromRGBA(int r, int g, int b, [int a = 255]) {
    return DsrtVector4(
      r / 255.0,
      g / 255.0,
      b / 255.0,
      a / 255.0,
    );
  }
  
  /// Creates a color vector from hex color code
  /// 
  /// [hex]: Hex color code (e.g., 0xFF336699)
  /// [alpha]: Alpha value (0.0 to 1.0, default: 1.0)
  factory DsrtVector4.fromHex(int hex, [double alpha = 1.0]) {
    return DsrtVector4(
      ((hex >> 16) & 0xFF) / 255.0,
      ((hex >> 8) & 0xFF) / 255.0,
      (hex & 0xFF) / 255.0,
      alpha,
    );
  }
  
  /// Zero vector (0, 0, 0, 0)
  static final DsrtVector4 zero = DsrtVector4(0.0, 0.0, 0.0, 0.0);
  
  /// Unit X vector (1, 0, 0, 0)
  static final DsrtVector4 unitX = DsrtVector4(1.0, 0.0, 0.0, 0.0);
  
  /// Unit Y vector (0, 1, 0, 0)
  static final DsrtVector4 unitY = DsrtVector4(0.0, 1.0, 0.0, 0.0);
  
  /// Unit Z vector (0, 0, 1, 0)
  static final DsrtVector4 unitZ = DsrtVector4(0.0, 0.0, 1.0, 0.0);
  
  /// Unit W vector (0, 0, 0, 1)
  static final DsrtVector4 unitW = DsrtVector4(0.0, 0.0, 0.0, 1.0);
  
  /// One vector (1, 1, 1, 1)
  static final DsrtVector4 one = DsrtVector4(1.0, 1.0, 1.0, 1.0);
  
  /// Identity quaternion (0, 0, 0, 1)
  static final DsrtVector4 identityQuaternion = DsrtVector4(0.0, 0.0, 0.0, 1.0);
  
  /// Positive infinity vector
  static final DsrtVector4 positiveInfinity = DsrtVector4(
    double.infinity,
    double.infinity,
    double.infinity,
    double.infinity,
  );
  
  /// Negative infinity vector
  static final DsrtVector4 negativeInfinity = DsrtVector4(
    double.negativeInfinity,
    double.negativeInfinity,
    double.negativeInfinity,
    double.negativeInfinity,
  );
  
  /// Gets the vector as a list
  List<double> get asList => [x, y, z, w];
  
  /// Gets the vector as a Float32List
  Float32List get asFloat32List => Float32List.fromList([x, y, z, w]);
  
  /// Gets the vector magnitude (length)
  double get magnitude {
    return math.sqrt(x * x + y * y + z * z + w * w);
  }
  
  /// Gets the squared magnitude (faster than magnitude for comparisons)
  double get magnitudeSquared {
    return x * x + y * y + z * z + w * w;
  }
  
  /// Gets the 3D part (xyz) as Vector3
  DsrtVector3 get xyz => DsrtVector3(x, y, z);
  
  /// Gets the homogeneous 3D coordinates (xyz/w if w != 0)
  DsrtVector3 get homogeneous3D {
    if (w.abs() < DsrtMathConstants.EPSILON_SMALL) {
      return DsrtVector3(x, y, z);
    }
    return DsrtVector3(x / w, y / w, z / w);
  }
  
  /// Gets RGBA color as integers (0-255)
  Map<String, int> get rgba {
    return {
      'r': (x.clamp(0.0, 1.0) * 255).round(),
      'g': (y.clamp(0.0, 1.0) * 255).round(),
      'b': (z.clamp(0.0, 1.0) * 255).round(),
      'a': (w.clamp(0.0, 1.0) * 255).round(),
    };
  }
  
  /// Gets hex color code (0xAARRGGBB)
  int get hex {
    final r = (x.clamp(0.0, 1.0) * 255).round();
    final g = (y.clamp(0.0, 1.0) * 255).round();
    final b = (z.clamp(0.0, 1.0) * 255).round();
    final a = (w.clamp(0.0, 1.0) * 255).round();
    return (a << 24) | (r << 16) | (g << 8) | b;
  }
  
  /// Checks if the vector is normalized (approximately unit length)
  bool get isNormalized {
    return (magnitudeSquared - 1.0).abs() < DsrtMathConstants.EPSILON_SMALL;
  }
  
  /// Checks if the vector is approximately zero
  bool get isZero {
    return magnitudeSquared < DsrtMathConstants.EPSILON_SMALL;
  }
  
  /// Checks if this is an identity quaternion
  bool get isIdentityQuaternion {
    return (x.abs() < DsrtMathConstants.EPSILON_SMALL &&
            y.abs() < DsrtMathConstants.EPSILON_SMALL &&
            z.abs() < DsrtMathConstants.EPSILON_SMALL &&
            (w - 1.0).abs() < DsrtMathConstants.EPSILON_SMALL);
  }
  
  /// Checks if this represents a pure quaternion (w = 0)
  bool get isPureQuaternion {
    return w.abs() < DsrtMathConstants.EPSILON_SMALL;
  }
  
  /// Checks if the vector contains NaN values
  bool get isNaN {
    return x.isNaN || y.isNaN || z.isNaN || w.isNaN;
  }
  
  /// Checks if the vector contains infinite values
  bool get isInfinite {
    return x.isInfinite || y.isInfinite || z.isInfinite || w.isInfinite;
  }
  
  /// Checks if the vector is valid (finite and not NaN)
  bool get isValid {
    return !isNaN && !isInfinite;
  }
  
  /// Gets the normalized vector (unit vector)
  DsrtVector4 get normalized {
    final mag = magnitude;
    if (mag < DsrtMathConstants.EPSILON_SMALL) {
      return DsrtVector4.zero;
    }
    return DsrtVector4(x / mag, y / mag, z / mag, w / mag);
  }
  
  /// Gets the conjugate (for quaternions: -x, -y, -z, w)
  DsrtVector4 get conjugate {
    return DsrtVector4(-x, -y, -z, w);
  }
  
  /// Gets the inverse (for quaternions: conjugate / magnitude²)
  DsrtVector4 get inverse {
    final magSq = magnitudeSquared;
    if (magSq < DsrtMathConstants.EPSILON_SMALL) {
      return DsrtVector4.zero;
    }
    return DsrtVector4(-x / magSq, -y / magSq, -z / magSq, w / magSq);
  }
  
  /// Sets the vector components
  /// 
  /// [newX]: New X component
  /// [newY]: New Y component
  /// [newZ]: New Z component
  /// [newW]: New W component
  /// 
  /// Returns this vector for chaining.
  DsrtVector4 set(double newX, double newY, double newZ, double newW) {
    x = newX;
    y = newY;
    z = newZ;
    w = newW;
    return this;
  }
  
  /// Sets the vector from another vector
  /// 
  /// [other]: Vector to copy from
  /// 
  /// Returns this vector for chaining.
  DsrtVector4 setFrom(DsrtVector4 other) {
    x = other.x;
    y = other.y;
    z = other.z;
    w = other.w;
    return this;
  }
  
  /// Sets the vector from a list
  /// 
  /// [list]: List of [x, y, z, w] values
  /// 
  /// Returns this vector for chaining.
  /// Throws [ArgumentError] if list length is not 4.
  DsrtVector4 setFromList(List<double> list) {
    if (list.length != 4) {
      throw ArgumentError('List must contain exactly 4 elements');
    }
    x = list[0];
    y = list[1];
    z = list[2];
    w = list[3];
    return this;
  }
  
  /// Sets the vector from a Vector3 with homogeneous coordinate
  /// 
  /// [vec3]: 3D vector
  /// [newW]: Homogeneous coordinate (default: 1.0)
  /// 
  /// Returns this vector for chaining.
  DsrtVector4 setFromVector3(DsrtVector3 vec3, [double newW = 1.0]) {
    x = vec3.x;
    y = vec3.y;
    z = vec3.z;
    w = newW;
    return this;
  }
  
  /// Sets the vector from RGBA color values
  /// 
  /// [r]: Red component (0-255)
  /// [g]: Green component (0-255)
  /// [b]: Blue component (0-255)
  /// [a]: Alpha component (0-255, default: 255)
  /// 
  /// Returns this vector for chaining.
  DsrtVector4 setFromRGBA(int r, int g, int b, [int a = 255]) {
    x = r / 255.0;
    y = g / 255.0;
    z = b / 255.0;
    w = a / 255.0;
    return this;
  }
  
  /// Sets the vector from hex color code
  /// 
  /// [hex]: Hex color code (e.g., 0xFF336699)
  /// [alpha]: Alpha value (0.0 to 1.0, default: 1.0)
  /// 
  /// Returns this vector for chaining.
  DsrtVector4 setFromHex(int hex, [double alpha = 1.0]) {
    x = ((hex >> 16) & 0xFF) / 255.0;
    y = ((hex >> 8) & 0xFF) / 255.0;
    z = (hex & 0xFF) / 255.0;
    w = alpha;
    return this;
  }
  
  /// Copies this vector to a new instance
  DsrtVector4 copy() {
    return DsrtVector4(x, y, z, w);
  }
  
  /// Clones this vector (alias for copy)
  DsrtVector4 clone() => copy();
  
  /// Adds another vector to this vector
  /// 
  /// [other]: Vector to add
  /// 
  /// Returns this vector for chaining.
  DsrtVector4 add(DsrtVector4 other) {
    x += other.x;
    y += other.y;
    z += other.z;
    w += other.w;
    return this;
  }
  
  /// Adds scalar values to this vector
  /// 
  /// [scalarX]: X scalar to add
  /// [scalarY]: Y scalar to add
  /// [scalarZ]: Z scalar to add
  /// [scalarW]: W scalar to add
  /// 
  /// Returns this vector for chaining.
  DsrtVector4 addScalars(double scalarX, double scalarY, double scalarZ, double scalarW) {
    x += scalarX;
    y += scalarY;
    z += scalarZ;
    w += scalarW;
    return this;
  }
  
  /// Subtracts another vector from this vector
  /// 
  /// [other]: Vector to subtract
  /// 
  /// Returns this vector for chaining.
  DsrtVector4 subtract(DsrtVector4 other) {
    x -= other.x;
    y -= other.y;
    z -= other.z;
    w -= other.w;
    return this;
  }
  
  /// Subtracts scalar values from this vector
  /// 
  /// [scalarX]: X scalar to subtract
  /// [scalarY]: Y scalar to subtract
  /// [scalarZ]: Z scalar to subtract
  /// [scalarW]: W scalar to subtract
  /// 
  /// Returns this vector for chaining.
  DsrtVector4 subtractScalars(double scalarX, double scalarY, double scalarZ, double scalarW) {
    x -= scalarX;
    y -= scalarY;
    z -= scalarZ;
    w -= scalarW;
    return this;
  }
  
  /// Multiplies this vector by another vector (component-wise)
  /// 
  /// [other]: Vector to multiply by
  /// 
  /// Returns this vector for chaining.
  DsrtVector4 multiply(DsrtVector4 other) {
    x *= other.x;
    y *= other.y;
    z *= other.z;
    w *= other.w;
    return this;
  }
  
  /// Multiplies this vector by a scalar
  /// 
  /// [scalar]: Scalar to multiply by
  /// 
  /// Returns this vector for chaining.
  DsrtVector4 multiplyScalar(double scalar) {
    x *= scalar;
    y *= scalar;
    z *= scalar;
    w *= scalar;
    return this;
  }
  
  /// Divides this vector by another vector (component-wise)
  /// 
  /// [other]: Vector to divide by
  /// 
  /// Returns this vector for chaining.
  /// Throws [ArgumentError] if any component of other is zero.
  DsrtVector4 divide(DsrtVector4 other) {
    if (other.x == 0.0 || other.y == 0.0 || other.z == 0.0 || other.w == 0.0) {
      throw ArgumentError('Cannot divide by zero vector component');
    }
    x /= other.x;
    y /= other.y;
    z /= other.z;
    w /= other.w;
    return this;
  }
  
  /// Divides this vector by a scalar
  /// 
  /// [scalar]: Scalar to divide by
  /// 
  /// Returns this vector for chaining.
  /// Throws [ArgumentError] if scalar is zero.
  DsrtVector4 divideScalar(double scalar) {
    if (scalar == 0.0) {
      throw ArgumentError('Cannot divide by zero');
    }
    return multiplyScalar(1.0 / scalar);
  }
  
  /// Multiplies as quaternion: this = this * other
  /// 
  /// [other]: Quaternion to multiply with
  /// 
  /// Returns this vector for chaining.
  DsrtVector4 multiplyQuaternion(DsrtVector4 other) {
    final qax = x, qay = y, qaz = z, qaw = w;
    final qbx = other.x, qby = other.y, qbz = other.z, qbw = other.w;
    
    x = qax * qbw + qaw * qbx + qay * qbz - qaz * qby;
    y = qay * qbw + qaw * qby + qaz * qbx - qax * qbz;
    z = qaz * qbw + qaw * qbz + qax * qby - qay * qbx;
    w = qaw * qbw - qax * qbx - qay * qby - qaz * qbz;
    
    return this;
  }
  
  /// Premultiplies as quaternion: this = other * this
  /// 
  /// [other]: Quaternion to premultiply with
  /// 
  /// Returns this vector for chaining.
  DsrtVector4 premultiplyQuaternion(DsrtVector4 other) {
    final qax = other.x, qay = other.y, qaz = other.z, qaw = other.w;
    final qbx = x, qby = y, qbz = z, qbw = w;
    
    x = qax * qbw + qaw * qbx + qay * qbz - qaz * qby;
    y = qay * qbw + qaw * qby + qaz * qbx - qax * qbz;
    z = qaz * qbw + qaw * qbz + qax * qby - qay * qbx;
    w = qaw * qbw - qax * qbx - qay * qby - qaz * qbz;
    
    return this;
  }
  
  /// Scales this vector by another vector
  /// 
  /// [other]: Vector to scale by
  /// 
  /// Returns this vector for chaining.
  DsrtVector4 scale(DsrtVector4 other) {
    x *= other.x;
    y *= other.y;
    z *= other.z;
    w *= other.w;
    return this;
  }
  
  /// Negates this vector (multiplies by -1)
  /// 
  /// Returns this vector for chaining.
  DsrtVector4 negate() {
    x = -x;
    y = -y;
    z = -z;
    w = -w;
    return this;
  }
  
  /// Normalizes this vector (makes it unit length)
  /// 
  /// Returns this vector for chaining.
  DsrtVector4 normalize() {
    final mag = magnitude;
    if (mag > DsrtMathConstants.EPSILON_SMALL) {
      return multiplyScalar(1.0 / mag);
    }
    return set(0.0, 0.0, 0.0, 0.0);
  }
  
  /// Conjugates this quaternion (-x, -y, -z, w)
  /// 
  /// Returns this vector for chaining.
  DsrtVector4 conjugateQuaternion() {
    x = -x;
    y = -y;
    z = -z;
    // w remains unchanged
    return this;
  }
  
  /// Inverts this quaternion
  /// 
  /// Returns this vector for chaining.
  DsrtVector4 invertQuaternion() {
    final magSq = magnitudeSquared;
    if (magSq < DsrtMathConstants.EPSILON_SMALL) {
      return set(0.0, 0.0, 0.0, 0.0);
    }
    return multiplyScalar(1.0 / magSq).conjugateQuaternion();
  }
  
  /// Limits the magnitude of this vector
  /// 
  /// [maxLength]: Maximum allowed magnitude
  /// 
  /// Returns this vector for chaining.
  DsrtVector4 limit(double maxLength) {
    final magSq = magnitudeSquared;
    if (magSq > maxLength * maxLength) {
      return multiplyScalar(maxLength / math.sqrt(magSq));
    }
    return this;
  }
  
  /// Clamps this vector between two vectors
  /// 
  /// [min]: Minimum vector
  /// [max]: Maximum vector
  /// 
  /// Returns this vector for chaining.
  DsrtVector4 clamp(DsrtVector4 min, DsrtVector4 max) {
    x = x.clamp(min.x, max.x);
    y = y.clamp(min.y, max.y);
    z = z.clamp(min.z, max.z);
    w = w.clamp(min.w, max.w);
    return this;
  }
  
  /// Clamps the magnitude of this vector
  /// 
  /// [minLength]: Minimum allowed magnitude
  /// [maxLength]: Maximum allowed magnitude
  /// 
  /// Returns this vector for chaining.
  DsrtVector4 clampLength(double minLength, double maxLength) {
    final mag = magnitude;
    
    if (mag < DsrtMathConstants.EPSILON_SMALL) {
      return this;
    }
    
    if (mag < minLength) {
      return multiplyScalar(minLength / mag);
    } else if (mag > maxLength) {
      return multiplyScalar(maxLength / mag);
    }
    
    return this;
  }
  
  /// Floors the components of this vector
  /// 
  /// Returns this vector for chaining.
  DsrtVector4 floor() {
    x = x.floorToDouble();
    y = y.floorToDouble();
    z = z.floorToDouble();
    w = w.floorToDouble();
    return this;
  }
  
  /// Ceils the components of this vector
  /// 
  /// Returns this vector for chaining.
  DsrtVector4 ceil() {
    x = x.ceilToDouble();
    y = y.ceilToDouble();
    z = z.ceilToDouble();
    w = w.ceilToDouble();
    return this;
  }
  
  /// Rounds the components of this vector
  /// 
  /// Returns this vector for chaining.
  DsrtVector4 round() {
    x = x.roundToDouble();
    y = y.roundToDouble();
    z = z.roundToDouble();
    w = w.roundToDouble();
    return this;
  }
  
  /// Absolute values of the components
  /// 
  /// Returns this vector for chaining.
  DsrtVector4 absolute() {
    x = x.abs();
    y = y.abs();
    z = z.abs();
    w = w.abs();
    return this;
  }
  
  /// Sets this vector to the linear interpolation between two vectors
  /// 
  /// [start]: Start vector
  /// [end]: End vector
  /// [t]: Interpolation factor (0.0 to 1.0)
  /// 
  /// Returns this vector for chaining.
  DsrtVector4 lerp(DsrtVector4 start, DsrtVector4 end, double t) {
    x = start.x + (end.x - start.x) * t;
    y = start.y + (end.y - start.y) * t;
    z = start.z + (end.z - start.z) * t;
    w = start.w + (end.w - start.w) * t;
    return this;
  }
  
  /// Sets this vector to the spherical linear interpolation between two quaternions
  /// 
  /// [start]: Start quaternion (should be normalized)
  /// [end]: End quaternion (should be normalized)
  /// [t]: Interpolation factor (0.0 to 1.0)
  /// 
  /// Returns this vector for chaining.
  DsrtVector4 slerp(DsrtVector4 start, DsrtVector4 end, double t) {
    var cosHalfTheta = start.dot(end);
    
    // If dot < 0, the quaternions have opposite handedness
    if (cosHalfTheta < 0.0) {
      end = end.copy().negate();
      cosHalfTheta = -cosHalfTheta;
    }
    
    // If the quaternions are very close, use linear interpolation
    if (cosHalfTheta > 0.9995) {
      return lerp(start, end, t).normalize();
    }
    
    final halfTheta = math.acos(cosHalfTheta.clamp(-1.0, 1.0));
    final sinHalfTheta = math.sqrt(1.0 - cosHalfTheta * cosHalfTheta);
    
    // Avoid division by zero
    if (sinHalfTheta.abs() < DsrtMathConstants.EPSILON_SMALL) {
      return setFrom(start).multiplyScalar(0.5).add(end.copy().multiplyScalar(0.5));
    }
    
    final ratioA = math.sin((1.0 - t) * halfTheta) / sinHalfTheta;
    final ratioB = math.sin(t * halfTheta) / sinHalfTheta;
    
    return setFrom(
      start.copy().multiplyScalar(ratioA).add(end.copy().multiplyScalar(ratioB)),
    );
  }
  
  /// Sets this vector to the minimum components of two vectors
  /// 
  /// [a]: First vector
  /// [b]: Second vector
  /// 
  /// Returns this vector for chaining.
  DsrtVector4 min(DsrtVector4 a, DsrtVector4 b) {
    x = math.min(a.x, b.x);
    y = math.min(a.y, b.y);
    z = math.min(a.z, b.z);
    w = math.min(a.w, b.w);
    return this;
  }
  
  /// Sets this vector to the maximum components of two vectors
  /// 
  /// [a]: First vector
  /// [b]: Second vector
  /// 
  /// Returns this vector for chaining.
  DsrtVector4 max(DsrtVector4 a, DsrtVector4 b) {
    x = math.max(a.x, b.x);
    y = math.max(a.y, b.y);
    z = math.max(a.z, b.z);
    w = math.max(a.w, b.w);
    return this;
  }
  
  /// Calculates the dot product with another vector
  /// 
  /// [other]: Other vector
  /// 
  /// Returns the dot product.
  double dot(DsrtVector4 other) {
    return x * other.x + y * other.y + z * other.z + w * other.w;
  }
  
  /// Calculates the 4D cross product (wedge product) with another vector
  /// Note: In 4D, cross product is not uniquely defined
  /// This returns the six-component bivector (simplified)
  List<double> cross4D(DsrtVector4 other) {
    return [
      x * other.y - y * other.x, // XY
      x * other.z - z * other.x, // XZ
      x * other.w - w * other.x, // XW
      y * other.z - z * other.y, // YZ
      y * other.w - w * other.y, // YW
      z * other.w - w * other.z, // ZW
    ];
  }
  
  /// Calculates the distance to another vector
  /// 
  /// [other]: Other vector
  /// 
  /// Returns the distance.
  double distanceTo(DsrtVector4 other) {
    final dx = x - other.x;
    final dy = y - other.y;
    final dz = z - other.z;
    final dw = w - other.w;
    return math.sqrt(dx * dx + dy * dy + dz * dz + dw * dw);
  }
  
  /// Calculates the squared distance to another vector
  /// 
  /// [other]: Other vector
  /// 
  /// Returns the squared distance.
  double distanceToSquared(DsrtVector4 other) {
    final dx = x - other.x;
    final dy = y - other.y;
    final dz = z - other.z;
    final dw = w - other.w;
    return dx * dx + dy * dy + dz * dz + dw * dw;
  }
  
  /// Calculates the Manhattan distance to another vector
  /// 
  /// [other]: Other vector
  /// 
  /// Returns the Manhattan distance.
  double manhattanDistanceTo(DsrtVector4 other) {
    return (x - other.x).abs() +
           (y - other.y).abs() +
           (z - other.z).abs() +
           (w - other.w).abs();
  }
  
  /// Applies a rotation quaternion to a 3D vector (treats this as quaternion)
  /// 
  /// [vec3]: 3D vector to rotate
  /// 
  /// Returns the rotated 3D vector.
  DsrtVector3 applyQuaternionToVector(DsrtVector3 vec3) {
    final qx = x, qy = y, qz = z, qw = w;
    final vx = vec3.x, vy = vec3.y, vz = vec3.z;
    
    // t = 2 * cross(q.xyz, v)
    final tx = 2.0 * (qy * vz - qz * vy);
    final ty = 2.0 * (qz * vx - qx * vz);
    final tz = 2.0 * (qx * vy - qy * vx);
    
    // v + q.w * t + cross(q.xyz, t)
    return DsrtVector3(
      vx + qw * tx + qy * tz - qz * ty,
      vy + qw * ty + qz * tx - qx * tz,
      vz + qw * tz + qx * ty - qy * tx,
    );
  }
  
  /// Sets this quaternion from axis-angle rotation
  /// 
  /// [axis]: Rotation axis (should be normalized)
  /// [angle]: Rotation angle in radians
  /// 
  /// Returns this vector for chaining.
  DsrtVector4 setFromAxisAngle(DsrtVector3 axis, double angle) {
    final halfAngle = angle * 0.5;
    final s = math.sin(halfAngle);
    
    x = axis.x * s;
    y = axis.y * s;
    z = axis.z * s;
    w = math.cos(halfAngle);
    
    return this;
  }
  
  /// Sets this quaternion from Euler angles (XYZ order)
  /// 
  /// [x]: Rotation around X axis in radians
  /// [y]: Rotation around Y axis in radians
  /// [z]: Rotation around Z axis in radians
  /// 
  /// Returns this vector for chaining.
  DsrtVector4 setFromEuler(double xRot, double yRot, double zRot) {
    final halfX = xRot * 0.5;
    final halfY = yRot * 0.5;
    final halfZ = zRot * 0.5;
    
    final sinX = math.sin(halfX);
    final cosX = math.cos(halfX);
    final sinY = math.sin(halfY);
    final cosY = math.cos(halfY);
    final sinZ = math.sin(halfZ);
    final cosZ = math.cos(halfZ);
    
    // XYZ order (same as Three.js)
    x = sinX * cosY * cosZ - cosX * sinY * sinZ;
    y = cosX * sinY * cosZ + sinX * cosY * sinZ;
    z = cosX * cosY * sinZ - sinX * sinY * cosZ;
    w = cosX * cosY * cosZ + sinX * sinY * sinZ;
    
    return this;
  }
  
  /// Gets the axis-angle representation of this quaternion
  /// 
  /// Returns a map with 'axis' (Vector3) and 'angle' (radians).
  Map<String, dynamic> get axisAngle {
    if (w.abs() > 0.9999) {
      return {
        'axis': DsrtVector3(1.0, 0.0, 0.0),
        'angle': 0.0,
      };
    }
    
    final angle = 2.0 * math.acos(w.clamp(-1.0, 1.0));
    final s = math.sqrt(1.0 - w * w);
    
    if (s < DsrtMathConstants.EPSILON_SMALL) {
      return {
        'axis': DsrtVector3(1.0, 0.0, 0.0),
        'angle': angle,
      };
    }
    
    return {
      'axis': DsrtVector3(x / s, y / s, z / s).normalized,
      'angle': angle,
    };
  }
  
  /// Gets the Euler angles (XYZ order) from this quaternion
  /// 
  /// Returns a map with 'x', 'y', 'z' angles in radians.
  Map<String, double> get eulerAngles {
    final qx = x, qy = y, qz = z, qw = w;
    
    // XYZ order
    final sinr_cosp = 2.0 * (qw * qx + qy * qz);
    final cosr_cosp = 1.0 - 2.0 * (qx * qx + qy * qy);
    final roll = math.atan2(sinr_cosp, cosr_cosp);
    
    final sinp = 2.0 * (qw * qy - qz * qx);
    double pitch;
    if (sinp.abs() >= 1.0) {
      pitch = math.copysign(DsrtMathConstants.HALF_PI, sinp);
    } else {
      pitch = math.asin(sinp);
    }
    
    final siny_cosp = 2.0 * (qw * qz + qx * qy);
    final cosy_cosp = 1.0 - 2.0 * (qy * qy + qz * qz);
    final yaw = math.atan2(siny_cosp, cosy_cosp);
    
    return {'x': roll, 'y': pitch, 'z': yaw};
  }
  
  /// Checks if this vector is approximately equal to another vector
  /// 
  /// [other]: Other vector to compare with
  /// [epsilon]: Tolerance for comparison
  /// 
  /// Returns true if vectors are approximately equal.
  bool equals(DsrtVector4 other, [double? epsilon]) {
    final eps = epsilon ?? DsrtMathConstants.EPSILON_SMALL;
    return (x - other.x).abs() < eps &&
           (y - other.y).abs() < eps &&
           (z - other.z).abs() < eps &&
           (w - other.w).abs() < eps;
  }
  
  /// Checks if this vector is exactly equal to another vector
  /// 
  /// [other]: Other vector to compare with
  /// 
  /// Returns true if vectors are exactly equal.
  @override
  bool operator ==(Object other) {
    return other is DsrtVector4 &&
           x == other.x &&
           y == other.y &&
           z == other.z &&
           w == other.w;
  }
  
  /// Gets the hash code for this vector
  @override
  int get hashCode => Object.hash(x, y, z, w);
  
  /// String representation of this vector
  @override
  String toString() {
    return 'DsrtVector4(${x.toStringAsFixed(6)}, ${y.toStringAsFixed(6)}, ${z.toStringAsFixed(6)}, ${w.toStringAsFixed(6)})';
  }
  
  /// Adds two vectors
  DsrtVector4 operator +(DsrtVector4 other) {
    return DsrtVector4(x + other.x, y + other.y, z + other.z, w + other.w);
  }
  
  /// Subtracts two vectors
  DsrtVector4 operator -(DsrtVector4 other) {
    return DsrtVector4(x - other.x, y - other.y, z - other.z, w - other.w);
  }
  
  /// Multiplies vector by scalar
  DsrtVector4 operator *(double scalar) {
    return DsrtVector4(x * scalar, y * scalar, z * scalar, w * scalar);
  }
  
  /// Divides vector by scalar
  DsrtVector4 operator /(double scalar) {
    if (scalar == 0.0) {
      throw ArgumentError('Cannot divide by zero');
    }
    return DsrtVector4(x / scalar, y / scalar, z / scalar, w / scalar);
  }
  
  /// Negates vector
  DsrtVector4 operator -() {
    return DsrtVector4(-x, -y, -z, -w);
  }
  
  /// Accesses vector components by index
  /// 
  /// [index]: 0 for x, 1 for y, 2 for z, 3 for w
  /// 
  /// Returns the component value.
  /// Throws [RangeError] if index is not 0-3.
  double operator [](int index) {
    switch (index) {
      case 0:
        return x;
      case 1:
        return y;
      case 2:
        return z;
      case 3:
        return w;
      default:
        throw RangeError.index(index, this, 'index', 'Index must be 0-3');
    }
  }
  
  /// Sets vector components by index
  /// 
  /// [index]: 0 for x, 1 for y, 2 for z, 3 for w
  /// [value]: New value
  /// 
  /// Throws [RangeError] if index is not 0-3.
  void operator []=(int index, double value) {
    switch (index) {
      case 0:
        x = value;
        break;
      case 1:
        y = value;
        break;
      case 2:
        z = value;
        break;
      case 3:
        w = value;
        break;
      default:
        throw RangeError.index(index, this, 'index', 'Index must be 0-3');
    }
  }
  
  /// Disposes this vector
  @override
  Future<void> dispose() async {
    // Vector doesn't hold any native resources
  }
}

/// Vector4 utilities and static functions
class DsrtVector4Utils {
  /// Creates a random unit quaternion
  /// 
  /// [random]: Optional Random instance
  /// 
  /// Returns a random unit quaternion.
  static DsrtVector4 randomUnitQuaternion([math.Random? random]) {
    final rnd = random ?? math.Random();
    
    // Marsaglia's method for uniform random quaternion
    double u1 = rnd.nextDouble();
    double u2 = rnd.nextDouble();
    double u3 = rnd.nextDouble();
    
    final sqrt1MinusU1 = math.sqrt(1.0 - u1);
    final sqrtU1 = math.sqrt(u1);
    
    final twoPiU2 = DsrtMathConstants.TAU * u2;
    final twoPiU3 = DsrtMathConstants.TAU * u3;
    
    return DsrtVector4(
      sqrt1MinusU1 * math.sin(twoPiU2),
      sqrt1MinusU1 * math.cos(twoPiU2),
      sqrtU1 * math.sin(twoPiU3),
      sqrtU1 * math.cos(twoPiU3),
    );
  }
  
  /// Creates a random vector within a 4D hypersphere
  /// 
  /// [radius]: Hypersphere radius
  /// [random]: Optional Random instance
  /// 
  /// Returns a random vector within the hypersphere.
  static DsrtVector4 randomInHypersphere(double radius, [math.Random? random]) {
    final rnd = random ?? math.Random();
    
    // Generate random point on 4D sphere and scale
    final u1 = rnd.nextDouble();
    final u2 = rnd.nextDouble();
    final u3 = rnd.nextDouble();
    final u4 = rnd.nextDouble();
    
    final r = math.pow(rnd.nextDouble(), 0.25) * radius;
    
    final sqrt1MinusU1 = math.sqrt(1.0 - u1);
    final sqrtU1 = math.sqrt(u1);
    
    final twoPiU2 = DsrtMathConstants.TAU * u2;
    final twoPiU3 = DsrtMathConstants.TAU * u3;
    final twoPiU4 = DsrtMathConstants.TAU * u4;
    
    return DsrtVector4(
      r * sqrt1MinusU1 * math.sin(twoPiU2),
      r * sqrt1MinusU1 * math.cos(twoPiU2),
      r * sqrtU1 * math.sin(twoPiU3),
      r * sqrtU1 * math.cos(twoPiU3),
    );
  }
  
  /// Creates a color vector from HSL values
  /// 
  /// [h]: Hue (0-360)
  /// [s]: Saturation (0-1)
  /// [l]: Lightness (0-1)
  /// [alpha]: Alpha (0-1, default: 1.0)
  /// 
  /// Returns the color as Vector4.
  static DsrtVector4 fromHSL(double h, double s, double l, [double alpha = 1.0]) {
    h = h % 360.0;
    s = s.clamp(0.0, 1.0);
    l = l.clamp(0.0, 1.0);
    
    final c = (1.0 - (2.0 * l - 1.0).abs()) * s;
    final x = c * (1.0 - ((h / 60.0) % 2.0 - 1.0).abs());
    final m = l - c / 2.0;
    
    double r, g, b;
    
    if (h < 60.0) {
      r = c; g = x; b = 0.0;
    } else if (h < 120.0) {
      r = x; g = c; b = 0.0;
    } else if (h < 180.0) {
      r = 0.0; g = c; b = x;
    } else if (h < 240.0) {
      r = 0.0; g = x; b = c;
    } else if (h < 300.0) {
      r = x; g = 0.0; b = c;
    } else {
      r = c; g = 0.0; b = x;
    }
    
    return DsrtVector4(r + m, g + m, b + m, alpha);
  }
  
  /// Creates a color vector from HSV values
  /// 
  /// [h]: Hue (0-360)
  /// [s]: Saturation (0-1)
  /// [v]: Value (0-1)
  /// [alpha]: Alpha (0-1, default: 1.0)
  /// 
  /// Returns the color as Vector4.
  static DsrtVector4 fromHSV(double h, double s, double v, [double alpha = 1.0]) {
    h = h % 360.0;
    s = s.clamp(0.0, 1.0);
    v = v.clamp(0.0, 1.0);
    
    final c = v * s;
    final x = c * (1.0 - ((h / 60.0) % 2.0 - 1.0).abs());
    final m = v - c;
    
    double r, g, b;
    
    if (h < 60.0) {
      r = c; g = x; b = 0.0;
    } else if (h < 120.0) {
      r = x; g = c; b = 0.0;
    } else if (h < 180.0) {
      r = 0.0; g = c; b = x;
    } else if (h < 240.0) {
      r = 0.0; g = x; b = c;
    } else if (h < 300.0) {
      r = x; g = 0.0; b = c;
    } else {
      r = c; g = 0.0; b = x;
    }
    
    return DsrtVector4(r + m, g + m, b + m, alpha);
  }
  
  /// Calculates the dot product of two vectors
  static double dot(DsrtVector4 a, DsrtVector4 b) {
    return a.x * b.x + a.y * b.y + a.z * b.z + a.w * b.w;
  }
  
  /// Calculates the distance between two vectors
  static double distance(DsrtVector4 a, DsrtVector4 b) {
    return a.distanceTo(b);
  }
  
  /// Calculates the squared distance between two vectors
  static double distanceSquared(DsrtVector4 a, DsrtVector4 b) {
    return a.distanceToSquared(b);
  }
  
  /// Linearly interpolates between two vectors
  static DsrtVector4 lerp(DsrtVector4 a, DsrtVector4 b, double t) {
    return DsrtVector4(
      a.x + (b.x - a.x) * t,
      a.y + (b.y - a.y) * t,
      a.z + (b.z - a.z) * t,
      a.w + (b.w - a.w) * t,
    );
  }
  
  /// Spherically interpolates between two quaternions
  static DsrtVector4 slerp(DsrtVector4 a, DsrtVector4 b, double t) {
    final result = DsrtVector4();
    return result.slerp(a, b, t);
  }
  
  /// Returns the component-wise minimum of two vectors
  static DsrtVector4 min(DsrtVector4 a, DsrtVector4 b) {
    return DsrtVector4(
      math.min(a.x, b.x),
      math.min(a.y, b.y),
      math.min(a.z, b.z),
      math.min(a.w, b.w),
    );
  }
  
  /// Returns the component-wise maximum of two vectors
  static DsrtVector4 max(DsrtVector4 a, DsrtVector4 b) {
    return DsrtVector4(
      math.max(a.x, b.x),
      math.max(a.y, b.y),
      math.max(a.z, b.z),
      math.max(a.w, b.w),
    );
  }
  
  /// Multiplies two quaternions: q1 * q2
  static DsrtVector4 multiplyQuaternions(DsrtVector4 q1, DsrtVector4 q2) {
    final qax = q1.x, qay = q1.y, qaz = q1.z, qaw = q1.w;
    final qbx = q2.x, qby = q2.y, qbz = q2.z, qbw = q2.w;
    
    return DsrtVector4(
      qax * qbw + qaw * qbx + qay * qbz - qaz * qby,
      qay * qbw + qaw * qby + qaz * qbx - qax * qbz,
      qaz * qbw + qaw * qbz + qax * qby - qay * qbx,
      qaw * qbw - qax * qbx - qay * qby - qaz * qbz,
    );
  }
  
  /// Creates a quaternion from axis-angle rotation
  static DsrtVector4 fromAxisAngle(DsrtVector3 axis, double angle) {
    return DsrtVector4().setFromAxisAngle(axis, angle);
  }
  
  /// Creates a quaternion from Euler angles (XYZ order)
  static DsrtVector4 fromEuler(double x, double y, double z) {
    return DsrtVector4().setFromEuler(x, y, z);
  }
  
  /// Creates a rotation quaternion that rotates from vector a to vector b
  static DsrtVector4 rotationBetweenVectors(DsrtVector3 a, DsrtVector3 b) {
    final aNorm = a.normalized;
    final bNorm = b.normalized;
    
    final cosTheta = aNorm.dot(bNorm);
    
    // If vectors are nearly parallel
    if (cosTheta > 0.99999) {
      return DsrtVector4.identityQuaternion.copy();
    }
    
    // If vectors are opposite
    if (cosTheta < -0.99999) {
      // Find an arbitrary axis perpendicular to a
      DsrtVector3 axis;
      if (aNorm.x.abs() > 0.1) {
        axis = DsrtVector3(0.0, 1.0, 0.0).cross(aNorm).normalized;
      } else {
        axis = DsrtVector3(1.0, 0.0, 0.0).cross(aNorm).normalized;
      }
      return DsrtVector4().setFromAxisAngle(axis, DsrtMathConstants.PI);
    }
    
    // Standard case
    final axis = aNorm.cross(bNorm).normalized;
    final angle = math.acos(cosTheta.clamp(-1.0, 1.0));
    
    return DsrtVector4().setFromAxisAngle(axis, angle);
  }
  
  /// Converts a list of vectors to a Float32List
  static Float32List toFloat32List(List<DsrtVector4> vectors) {
    final result = Float32List(vectors.length * 4);
    for (var i = 0; i < vectors.length; i++) {
      final vector = vectors[i];
      result[i * 4] = vector.x;
      result[i * 4 + 1] = vector.y;
      result[i * 4 + 2] = vector.z;
      result[i * 4 + 3] = vector.w;
    }
    return result;
  }
  
  /// Creates vectors from a Float32List
  static List<DsrtVector4> fromFloat32List(Float32List data) {
    if (data.length % 4 != 0) {
      throw ArgumentError('Data length must be divisible by 4');
    }
    
    final vectors = <DsrtVector4>[];
    for (var i = 0; i < data.length; i += 4) {
      vectors.add(DsrtVector4(data[i], data[i + 1], data[i + 2], data[i + 3]));
    }
    return vectors;
  }
  
  /// Converts HSL to RGB
  static DsrtVector4 hslToRGB(double h, double s, double l, [double alpha = 1.0]) {
    return fromHSL(h, s, l, alpha);
  }
  
  /// Converts RGB to HSL
  static Map<String, double> rgbToHSL(DsrtVector4 rgb) {
    final r = rgb.x.clamp(0.0, 1.0);
    final g = rgb.y.clamp(0.0, 1.0);
    final b = rgb.z.clamp(0.0, 1.0);
    
    final max = math.max(r, math.max(g, b));
    final min = math.min(r, math.min(g, b));
    final delta = max - min;
    
    double h = 0.0;
    double s = 0.0;
    final l = (max + min) / 2.0;
    
    if (delta > DsrtMathConstants.EPSILON_SMALL) {
      s = l > 0.5 ? delta / (2.0 - max - min) : delta / (max + min);
      
      if (max == r) {
        h = (g - b) / delta + (g < b ? 6.0 : 0.0);
      } else if (max == g) {
        h = (b - r) / delta + 2.0;
      } else {
        h = (r - g) / delta + 4.0;
      }
      
      h /= 6.0;
      h *= 360.0;
    }
    
    return {'h': h, 's': s, 'l': l};
  }
  
  /// Linear to sRGB conversion
  static DsrtVector4 linearToSRGB(DsrtVector4 linear) {
    double toSRGB(double channel) {
      if (channel <= 0.0031308) {
        return channel * 12.92;
      }
      return 1.055 * math.pow(channel, 1.0 / 2.4) - 0.055;
    }
    
    return DsrtVector4(
      toSRGB(linear.x),
      toSRGB(linear.y),
      toSRGB(linear.z),
      linear.w,
    );
  }
  
  /// sRGB to linear conversion
  static DsrtVector4 sRGBToLinear(DsrtVector4 srgb) {
    double toLinear(double channel) {
      if (channel <= 0.04045) {
        return channel / 12.92;
      }
      return math.pow((channel + 0.055) / 1.055, 2.4);
    }
    
    return DsrtVector4(
      toLinear(srgb.x),
      toLinear(srgb.y),
      toLinear(srgb.z),
      srgb.w,
    );
  }
}
