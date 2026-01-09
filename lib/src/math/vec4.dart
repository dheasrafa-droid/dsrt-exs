/// 4D Vector class for mathematical operations
///
/// Used for homogeneous coordinates, colors (RGBA), and quaternions.
/// Mutable by design for performance. Methods mutate `this` and return `this`
/// for fluent chaining. Use clone() for immutable copies.
///
/// @license MIT
/// @copyright (c) 2024 DSRT Engine

import 'dart:math';
import '../core/constants.dart';
import 'vec2.dart';
import 'vec3.dart';

/// 4D Vector class with mutable operations
class ExsVec4 {
  /// X component
  double x;
  
  /// Y component
  double y;
  
  /// Z component
  double z;
  
  /// W component
  double w;
  
  /// Constructor with optional initialization
  ExsVec4([double x = 0.0, double y = 0.0, double z = 0.0, double w = 0.0])
    : x = x,
      y = y,
      z = z,
      w = w;
  
  /// Create from list [x, y, z, w]
  factory ExsVec4.fromList(List<double> list) {
    assert(list.length >= 4, 'List must contain at least 4 elements');
    return ExsVec4(list[0], list[1], list[2], list[3]);
  }
  
  /// Create from map {'x': value, 'y': value, 'z': value, 'w': value}
  factory ExsVec4.fromMap(Map<String, dynamic> map) {
    return ExsVec4(
      (map['x'] ?? 0.0).toDouble(),
      (map['y'] ?? 0.0).toDouble(),
      (map['z'] ?? 0.0).toDouble(),
      (map['w'] ?? 0.0).toDouble(),
    );
  }
  
  /// Create from another vector (copy constructor)
  factory ExsVec4.from(ExsVec4 other) {
    return ExsVec4(other.x, other.y, other.z, other.w);
  }
  
  /// Create from Vec3 and optional w component
  factory ExsVec4.fromVec3(ExsVec3 vec3, [double w = 0.0]) {
    return ExsVec4(vec3.x, vec3.y, vec3.z, w);
  }
  
  /// Create from Vec2 and optional z, w components
  factory ExsVec4.fromVec2(ExsVec2 vec2, [double z = 0.0, double w = 0.0]) {
    return ExsVec4(vec2.x, vec2.y, z, w);
  }
  
  /// Zero vector (0, 0, 0, 0)
  static final ExsVec4 zero = ExsVec4(0.0, 0.0, 0.0, 0.0);
  
  /// Unit X vector (1, 0, 0, 0)
  static final ExsVec4 unitX = ExsVec4(1.0, 0.0, 0.0, 0.0);
  
  /// Unit Y vector (0, 1, 0, 0)
  static final ExsVec4 unitY = ExsVec4(0.0, 1.0, 0.0, 0.0);
  
  /// Unit Z vector (0, 0, 1, 0)
  static final ExsVec4 unitZ = ExsVec4(0.0, 0.0, 1.0, 0.0);
  
  /// Unit W vector (0, 0, 0, 1)
  static final ExsVec4 unitW = ExsVec4(0.0, 0.0, 0.0, 1.0);
  
  /// One vector (1, 1, 1, 1)
  static final ExsVec4 one = ExsVec4(1.0, 1.0, 1.0, 1.0);
  
  /// Negative one vector (-1, -1, -1, -1)
  static final ExsVec4 negativeOne = ExsVec4(-1.0, -1.0, -1.0, -1.0);
  
  /// Infinity vector (infinity, infinity, infinity, infinity)
  static final ExsVec4 infinity = ExsVec4(double.infinity, double.infinity, double.infinity, double.infinity);
  
  /// Negative infinity vector (-infinity, -infinity, -infinity, -infinity)
  static final ExsVec4 negativeInfinity = ExsVec4(double.negativeInfinity, double.negativeInfinity, double.negativeInfinity, double.negativeInfinity);
  
  /// Set vector components
  ExsVec4 set(double x, double y, double z, double w) {
    this.x = x;
    this.y = y;
    this.z = z;
    this.w = w;
    return this;
  }
  
  /// Set from another vector
  ExsVec4 setFrom(ExsVec4 other) {
    x = other.x;
    y = other.y;
    z = other.z;
    w = other.w;
    return this;
  }
  
  /// Set from list
  ExsVec4 setFromList(List<double> list) {
    assert(list.length >= 4, 'List must contain at least 4 elements');
    x = list[0];
    y = list[1];
    z = list[2];
    w = list[3];
    return this;
  }
  
  /// Set all components to scalar value
  ExsVec4 setScalar(double scalar) {
    x = scalar;
    y = scalar;
    z = scalar;
    w = scalar;
    return this;
  }
  
  /// Set from Vec3 and optional w component
  ExsVec4 setFromVec3(ExsVec3 vec3, [double w = 0.0]) {
    x = vec3.x;
    y = vec3.y;
    z = vec3.z;
    this.w = w;
    return this;
  }
  
  /// Set from Vec2 and optional z, w components
  ExsVec4 setFromVec2(ExsVec2 vec2, [double z = 0.0, double w = 0.0]) {
    x = vec2.x;
    y = vec2.y;
    this.z = z;
    this.w = w;
    return this;
  }
  
  /// Add scalar to vector
  ExsVec4 addScalar(double scalar) {
    x += scalar;
    y += scalar;
    z += scalar;
    w += scalar;
    return this;
  }
  
  /// Add another vector
  ExsVec4 add(ExsVec4 other) {
    x += other.x;
    y += other.y;
    z += other.z;
    w += other.w;
    return this;
  }
  
  /// Add scaled vector: this + other * scalar
  ExsVec4 addScaled(ExsVec4 other, double scalar) {
    x += other.x * scalar;
    y += other.y * scalar;
    z += other.z * scalar;
    w += other.w * scalar;
    return this;
  }
  
  /// Subtract scalar from vector
  ExsVec4 subScalar(double scalar) {
    x -= scalar;
    y -= scalar;
    z -= scalar;
    w -= scalar;
    return this;
  }
  
  /// Subtract another vector
  ExsVec4 sub(ExsVec4 other) {
    x -= other.x;
    y -= other.y;
    z -= other.z;
    w -= other.w;
    return this;
  }
  
  /// Multiply by scalar
  ExsVec4 multiplyScalar(double scalar) {
    x *= scalar;
    y *= scalar;
    z *= scalar;
    w *= scalar;
    return this;
  }
  
  /// Multiply by another vector (component-wise)
  ExsVec4 multiply(ExsVec4 other) {
    x *= other.x;
    y *= other.y;
    z *= other.z;
    w *= other.w;
    return this;
  }
  
  /// Divide by scalar
  ExsVec4 divideScalar(double scalar) {
    if (scalar.abs() < ExsPrecision.epsilon) {
      throw ArgumentError('Division by zero or near-zero');
    }
    return multiplyScalar(1.0 / scalar);
  }
  
  /// Divide by another vector (component-wise)
  ExsVec4 divide(ExsVec4 other) {
    if (other.x.abs() < ExsPrecision.epsilon || 
        other.y.abs() < ExsPrecision.epsilon || 
        other.z.abs() < ExsPrecision.epsilon ||
        other.w.abs() < ExsPrecision.epsilon) {
      throw ArgumentError('Division by zero or near-zero component');
    }
    x /= other.x;
    y /= other.y;
    z /= other.z;
    w /= other.w;
    return this;
  }
  
  /// Apply absolute value to each component
  ExsVec4 abs() {
    x = x.abs();
    y = y.abs();
    z = z.abs();
    w = w.abs();
    return this;
  }
  
  /// Apply floor to each component
  ExsVec4 floor() {
    x = x.floorToDouble();
    y = y.floorToDouble();
    z = z.floorToDouble();
    w = w.floorToDouble();
    return this;
  }
  
  /// Apply ceil to each component
  ExsVec4 ceil() {
    x = x.ceilToDouble();
    y = y.ceilToDouble();
    z = z.ceilToDouble();
    w = w.ceilToDouble();
    return this;
  }
  
  /// Apply round to each component
  ExsVec4 round() {
    x = x.roundToDouble();
    y = y.roundToDouble();
    z = z.roundToDouble();
    w = w.roundToDouble();
    return this;
  }
  
  /// Negate the vector
  ExsVec4 negate() {
    x = -x;
    y = -y;
    z = -z;
    w = -w;
    return this;
  }
  
  /// Dot product with another vector
  double dot(ExsVec4 other) {
    return x * other.x + y * other.y + z * other.z + w * other.w;
  }
  
  /// Length (magnitude) squared
  double lengthSq() {
    return x * x + y * y + z * z + w * w;
  }
  
  /// Length (magnitude)
  double length() {
    return sqrt(lengthSq());
  }
  
  /// Manhattan length (sum of absolute components)
  double manhattanLength() {
    return x.abs() + y.abs() + z.abs() + w.abs();
  }
  
  /// Normalize the vector (make unit length)
  ExsVec4 normalize() {
    return divideScalar(length());
  }
  
  /// Set length of vector
  ExsVec4 setLength(double length) {
    return normalize().multiplyScalar(length);
  }
  
  /// Distance to another vector squared
  double distanceToSq(ExsVec4 other) {
    final dx = x - other.x;
    final dy = y - other.y;
    final dz = z - other.z;
    final dw = w - other.w;
    return dx * dx + dy * dy + dz * dz + dw * dw;
  }
  
  /// Distance to another vector
  double distanceTo(ExsVec4 other) {
    return sqrt(distanceToSq(other));
  }
  
  /// Manhattan distance to another vector
  double manhattanDistanceTo(ExsVec4 other) {
    return (x - other.x).abs() + 
           (y - other.y).abs() + 
           (z - other.z).abs() + 
           (w - other.w).abs();
  }
  
  /// Linear interpolation towards another vector
  ExsVec4 lerp(ExsVec4 other, double alpha) {
    x = x + (other.x - x) * alpha;
    y = y + (other.y - y) * alpha;
    z = z + (other.z - z) * alpha;
    w = w + (other.w - w) * alpha;
    return this;
  }
  
  /// Spherical linear interpolation (for quaternions)
  ExsVec4 slerp(ExsVec4 other, double alpha) {
    // For homogeneous coordinates or quaternions
    final cosTheta = dot(other) / (length() * other.length());
    final theta = acos(cosTheta.clamp(-1.0, 1.0));
    
    if (theta.abs() < ExsPrecision.epsilon) {
      return setFrom(other);
    }
    
    final sinTheta = sin(theta);
    final wa = sin((1.0 - alpha) * theta) / sinTheta;
    final wb = sin(alpha * theta) / sinTheta;
    
    x = x * wa + other.x * wb;
    y = y * wa + other.y * wb;
    z = z * wa + other.z * wb;
    w = w * wa + other.w * wb;
    
    return this;
  }
  
  /// Transform by 4x4 matrix (for homogeneous coordinates)
  ExsVec4 applyMatrix4(ExsMat4 matrix) {
    // Implementation depends on ExsMat4 class
    // This is a placeholder for now
    // Will be implemented when ExsMat4 is created
    return this;
  }
  
  /// Clamp length between min and max
  ExsVec4 clampLength(double min, double max) {
    final currentLength = length();
    if (currentLength < ExsPrecision.epsilon) {
      return this;
    }
    
    final targetLength = currentLength.clamp(min, max);
    return multiplyScalar(targetLength / currentLength);
  }
  
  /// Clamp components between min and max
  ExsVec4 clamp(ExsVec4 min, ExsVec4 max) {
    x = x.clamp(min.x, max.x);
    y = y.clamp(min.y, max.y);
    z = z.clamp(min.z, max.z);
    w = w.clamp(min.w, max.w);
    return this;
  }
  
  /// Clamp components between scalar min and max
  ExsVec4 clampScalar(double min, double max) {
    x = x.clamp(min, max);
    y = y.clamp(min, max);
    z = z.clamp(min, max);
    w = w.clamp(min, max);
    return this;
  }
  
  /// Homogeneous divide (for points: divide x, y, z by w)
  ExsVec4 divideByW() {
    if (w.abs() < ExsPrecision.epsilon) {
      throw ArgumentError('W component is zero or near-zero');
    }
    x /= w;
    y /= w;
    z /= w;
    w = 1.0;
    return this;
  }
  
  /// Get XYZ components as Vec3
  ExsVec3 get xyz => ExsVec3(x, y, z);
  
  /// Get XY components as Vec2
  ExsVec2 get xy => ExsVec2(x, y);
  
  /// Get as color (RGBA)
  ExsVec4 get asColor => this;
  
  /// Check if vector equals another within epsilon tolerance
  bool equals(ExsVec4 other, {double epsilon = ExsPrecision.epsilon}) {
    return (x - other.x).abs() <= epsilon &&
           (y - other.y).abs() <= epsilon &&
           (z - other.z).abs() <= epsilon &&
           (w - other.w).abs() <= epsilon;
  }
  
  /// Check if vector is approximately zero
  bool isZero({double epsilon = ExsPrecision.epsilon}) {
    return lengthSq() <= epsilon * epsilon;
  }
  
  /// Check if vector has any NaN component
  bool get isNaN => x.isNaN || y.isNaN || z.isNaN || w.isNaN;
  
  /// Check if vector has any infinite component
  bool get isInfinite => x.isInfinite || y.isInfinite || z.isInfinite || w.isInfinite;
  
  /// Check if vector has any finite component
  bool get isFinite => x.isFinite && y.isFinite && z.isFinite && w.isFinite;
  
  /// Create a copy (clone) of this vector
  ExsVec4 clone() {
    return ExsVec4(x, y, z, w);
  }
  
  /// Convert to list [x, y, z, w]
  List<double> toList() {
    return [x, y, z, w];
  }
  
  /// Convert to Float32List
  Float32List toFloat32List() {
    return Float32List(4)..[0] = x..[1] = y..[2] = z..[3] = w;
  }
  
  /// Convert to map {'x': x, 'y': y, 'z': z, 'w': w}
  Map<String, double> toMap() {
    return {'x': x, 'y': y, 'z': z, 'w': w};
  }
  
  /// Apply function to each component
  ExsVec4 apply(Function(double) fn) {
    x = fn(x);
    y = fn(y);
    z = fn(z);
    w = fn(w);
    return this;
  }
  
  /// Minimum components with another vector
  ExsVec4 min(ExsVec4 other) {
    x = min(x, other.x);
    y = min(y, other.y);
    z = min(z, other.z);
    w = min(w, other.w);
    return this;
  }
  
  /// Maximum components with another vector
  ExsVec4 max(ExsVec4 other) {
    x = max(x, other.x);
    y = max(y, other.y);
    z = max(z, other.z);
    w = max(w, other.w);
    return this;
  }
  
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExsVec4 &&
          runtimeType == other.runtimeType &&
          x == other.x &&
          y == other.y &&
          z == other.z &&
          w == other.w;
  
  @override
  int get hashCode => Object.hash(x, y, z, w);
  
  /// String representation
  @override
  String toString() {
    return 'ExsVec4($x, $y, $z, $w)';
  }
  
  /// Operator overloads (syntactic sugar)
  
  /// Add operator: this + other
  ExsVec4 operator +(ExsVec4 other) {
    return clone().add(other);
  }
  
  /// Subtract operator: this - other
  ExsVec4 operator -(ExsVec4 other) {
    return clone().sub(other);
  }
  
  /// Multiply operator (component-wise): this * other
  ExsVec4 operator *(ExsVec4 other) {
    return clone().multiply(other);
  }
  
  /// Multiply by scalar operator: this * scalar
  ExsVec4 operator *(double scalar) {
    return clone().multiplyScalar(scalar);
  }
  
  /// Divide operator (component-wise): this / other
  ExsVec4 operator /(ExsVec4 other) {
    return clone().divide(other);
  }
  
  /// Divide by scalar operator: this / scalar
  ExsVec4 operator /(double scalar) {
    return clone().divideScalar(scalar);
  }
  
  /// Negate operator: -this
  ExsVec4 operator -() {
    return clone().negate();
  }
  
  /// Index access
  double operator [](int index) {
    switch (index) {
      case 0: return x;
      case 1: return y;
      case 2: return z;
      case 3: return w;
      default:
        throw RangeError.index(index, this, 'index', 'Index must be 0, 1, 2, or 3');
    }
  }
  
  /// Index assignment
  void operator []=(int index, double value) {
    switch (index) {
      case 0: x = value; break;
      case 1: y = value; break;
      case 2: z = value; break;
      case 3: w = value; break;
      default:
        throw RangeError.index(index, this, 'index', 'Index must be 0, 1, 2, or 3');
    }
  }
}
