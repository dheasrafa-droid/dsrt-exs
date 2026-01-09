/// 3D Vector class for mathematical operations
///
/// Mutable by design for performance. Methods mutate `this` and return `this`
/// for fluent chaining. Use clone() for immutable copies.
///
/// @license MIT
/// @copyright (c) 2024 DSRT Engine

import 'dart:math';
import '../core/constants.dart';
import 'vec2.dart';

/// 3D Vector class with mutable operations
class ExsVec3 {
  /// X component
  double x;
  
  /// Y component
  double y;
  
  /// Z component
  double z;
  
  /// Constructor with optional initialization
  ExsVec3([double x = 0.0, double y = 0.0, double z = 0.0])
    : x = x,
      y = y,
      z = z;
  
  /// Create from list [x, y, z]
  factory ExsVec3.fromList(List<double> list) {
    assert(list.length >= 3, 'List must contain at least 3 elements');
    return ExsVec3(list[0], list[1], list[2]);
  }
  
  /// Create from map {'x': value, 'y': value, 'z': value}
  factory ExsVec3.fromMap(Map<String, dynamic> map) {
    return ExsVec3(
      (map['x'] ?? 0.0).toDouble(),
      (map['y'] ?? 0.0).toDouble(),
      (map['z'] ?? 0.0).toDouble(),
    );
  }
  
  /// Create from another vector (copy constructor)
  factory ExsVec3.from(ExsVec3 other) {
    return ExsVec3(other.x, other.y, other.z);
  }
  
  /// Create from Vec2 and optional z component
  factory ExsVec3.fromVec2(ExsVec2 vec2, [double z = 0.0]) {
    return ExsVec3(vec2.x, vec2.y, z);
  }
  
  /// Zero vector (0, 0, 0)
  static final ExsVec3 zero = ExsVec3(0.0, 0.0, 0.0);
  
  /// Unit X vector (1, 0, 0)
  static final ExsVec3 unitX = ExsVec3(1.0, 0.0, 0.0);
  
  /// Unit Y vector (0, 1, 0)
  static final ExsVec3 unitY = ExsVec3(0.0, 1.0, 0.0);
  
  /// Unit Z vector (0, 0, 1)
  static final ExsVec3 unitZ = ExsVec3(0.0, 0.0, 1.0);
  
  /// One vector (1, 1, 1)
  static final ExsVec3 one = ExsVec3(1.0, 1.0, 1.0);
  
  /// Negative one vector (-1, -1, -1)
  static final ExsVec3 negativeOne = ExsVec3(-1.0, -1.0, -1.0);
  
  /// Up vector (0, 1, 0) - commonly used for world up
  static final ExsVec3 up = ExsVec3(0.0, 1.0, 0.0);
  
  /// Down vector (0, -1, 0)
  static final ExsVec3 down = ExsVec3(0.0, -1.0, 0.0);
  
  /// Forward vector (0, 0, -1) - commonly used in 3D graphics
  static final ExsVec3 forward = ExsVec3(0.0, 0.0, -1.0);
  
  /// Backward vector (0, 0, 1)
  static final ExsVec3 backward = ExsVec3(0.0, 0.0, 1.0);
  
  /// Left vector (-1, 0, 0)
  static final ExsVec3 left = ExsVec3(-1.0, 0.0, 0.0);
  
  /// Right vector (1, 0, 0)
  static final ExsVec3 right = ExsVec3(1.0, 0.0, 0.0);
  
  /// Infinity vector (infinity, infinity, infinity)
  static final ExsVec3 infinity = ExsVec3(double.infinity, double.infinity, double.infinity);
  
  /// Negative infinity vector (-infinity, -infinity, -infinity)
  static final ExsVec3 negativeInfinity = ExsVec3(double.negativeInfinity, double.negativeInfinity, double.negativeInfinity);
  
  /// Set vector components
  ExsVec3 set(double x, double y, double z) {
    this.x = x;
    this.y = y;
    this.z = z;
    return this;
  }
  
  /// Set from another vector
  ExsVec3 setFrom(ExsVec3 other) {
    x = other.x;
    y = other.y;
    z = other.z;
    return this;
  }
  
  /// Set from list
  ExsVec3 setFromList(List<double> list) {
    assert(list.length >= 3, 'List must contain at least 3 elements');
    x = list[0];
    y = list[1];
    z = list[2];
    return this;
  }
  
  /// Set all components to scalar value
  ExsVec3 setScalar(double scalar) {
    x = scalar;
    y = scalar;
    z = scalar;
    return this;
  }
  
  /// Set from Vec2 and optional z component
  ExsVec3 setFromVec2(ExsVec2 vec2, [double z = 0.0]) {
    x = vec2.x;
    y = vec2.y;
    this.z = z;
    return this;
  }
  
  /// Add scalar to vector
  ExsVec3 addScalar(double scalar) {
    x += scalar;
    y += scalar;
    z += scalar;
    return this;
  }
  
  /// Add another vector
  ExsVec3 add(ExsVec3 other) {
    x += other.x;
    y += other.y;
    z += other.z;
    return this;
  }
  
  /// Add scaled vector: this + other * scalar
  ExsVec3 addScaled(ExsVec3 other, double scalar) {
    x += other.x * scalar;
    y += other.y * scalar;
    z += other.z * scalar;
    return this;
  }
  
  /// Subtract scalar from vector
  ExsVec3 subScalar(double scalar) {
    x -= scalar;
    y -= scalar;
    z -= scalar;
    return this;
  }
  
  /// Subtract another vector
  ExsVec3 sub(ExsVec3 other) {
    x -= other.x;
    y -= other.y;
    z -= other.z;
    return this;
  }
  
  /// Multiply by scalar
  ExsVec3 multiplyScalar(double scalar) {
    x *= scalar;
    y *= scalar;
    z *= scalar;
    return this;
  }
  
  /// Multiply by another vector (component-wise)
  ExsVec3 multiply(ExsVec3 other) {
    x *= other.x;
    y *= other.y;
    z *= other.z;
    return this;
  }
  
  /// Divide by scalar
  ExsVec3 divideScalar(double scalar) {
    if (scalar.abs() < ExsPrecision.epsilon) {
      throw ArgumentError('Division by zero or near-zero');
    }
    return multiplyScalar(1.0 / scalar);
  }
  
  /// Divide by another vector (component-wise)
  ExsVec3 divide(ExsVec3 other) {
    if (other.x.abs() < ExsPrecision.epsilon || 
        other.y.abs() < ExsPrecision.epsilon || 
        other.z.abs() < ExsPrecision.epsilon) {
      throw ArgumentError('Division by zero or near-zero component');
    }
    x /= other.x;
    y /= other.y;
    z /= other.z;
    return this;
  }
  
  /// Apply absolute value to each component
  ExsVec3 abs() {
    x = x.abs();
    y = y.abs();
    z = z.abs();
    return this;
  }
  
  /// Apply floor to each component
  ExsVec3 floor() {
    x = x.floorToDouble();
    y = y.floorToDouble();
    z = z.floorToDouble();
    return this;
  }
  
  /// Apply ceil to each component
  ExsVec3 ceil() {
    x = x.ceilToDouble();
    y = y.ceilToDouble();
    z = z.ceilToDouble();
    return this;
  }
  
  /// Apply round to each component
  ExsVec3 round() {
    x = x.roundToDouble();
    y = y.roundToDouble();
    z = z.roundToDouble();
    return this;
  }
  
  /// Negate the vector
  ExsVec3 negate() {
    x = -x;
    y = -y;
    z = -z;
    return this;
  }
  
  /// Dot product with another vector
  double dot(ExsVec3 other) {
    return x * other.x + y * other.y + z * other.z;
  }
  
  /// Cross product with another vector
  ExsVec3 cross(ExsVec3 other) {
    final newX = y * other.z - z * other.y;
    final newY = z * other.x - x * other.z;
    final newZ = x * other.y - y * other.x;
    x = newX;
    y = newY;
    z = newZ;
    return this;
  }
  
  /// Cross product with another vector (returns new vector)
  ExsVec3 crossWith(ExsVec3 other) {
    return clone().cross(other);
  }
  
  /// Length (magnitude) squared
  double lengthSq() {
    return x * x + y * y + z * z;
  }
  
  /// Length (magnitude)
  double length() {
    return sqrt(lengthSq());
  }
  
  /// Manhattan length (sum of absolute components)
  double manhattanLength() {
    return x.abs() + y.abs() + z.abs();
  }
  
  /// Normalize the vector (make unit length)
  ExsVec3 normalize() {
    return divideScalar(length());
  }
  
  /// Set length of vector
  ExsVec3 setLength(double length) {
    return normalize().multiplyScalar(length);
  }
  
  /// Distance to another vector squared
  double distanceToSq(ExsVec3 other) {
    final dx = x - other.x;
    final dy = y - other.y;
    final dz = z - other.z;
    return dx * dx + dy * dy + dz * dz;
  }
  
  /// Distance to another vector
  double distanceTo(ExsVec3 other) {
    return sqrt(distanceToSq(other));
  }
  
  /// Manhattan distance to another vector
  double manhattanDistanceTo(ExsVec3 other) {
    return (x - other.x).abs() + (y - other.y).abs() + (z - other.z).abs();
  }
  
  /// Linear interpolation towards another vector
  ExsVec3 lerp(ExsVec3 other, double alpha) {
    x = x + (other.x - x) * alpha;
    y = y + (other.y - y) * alpha;
    z = z + (other.z - z) * alpha;
    return this;
  }
  
  /// Spherical linear interpolation
  ExsVec3 slerp(ExsVec3 other, double alpha) {
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
    
    return this;
  }
  
  /// Angle between this vector and another (radians)
  double angleTo(ExsVec3 other) {
    final denominator = sqrt(lengthSq() * other.lengthSq());
    if (denominator < ExsPrecision.epsilon) {
      return 0.0;
    }
    final cosTheta = dot(other) / denominator;
    return acos(cosTheta.clamp(-1.0, 1.0));
  }
  
  /// Reflect vector off plane with normal
  ExsVec3 reflect(ExsVec3 normal) {
    // r = v - 2 * (v·n) * n
    final dotProduct = dot(normal);
    return sub(normal.multiplyScalar(2.0 * dotProduct));
  }
  
  /// Project vector onto another vector
  ExsVec3 projectOnVector(ExsVec3 vector) {
    final scalar = vector.dot(this) / vector.lengthSq();
    return setFrom(vector).multiplyScalar(scalar);
  }
  
  /// Project vector onto plane defined by normal
  ExsVec3 projectOnPlane(ExsVec3 planeNormal) {
    // v - (v·n) * n
    final dotProduct = dot(planeNormal);
    return sub(planeNormal.multiplyScalar(dotProduct));
  }
  
  /// Project point onto line defined by point a and direction b
  ExsVec3 projectOnLine(ExsVec3 point, ExsVec3 direction) {
    // p = a + ((v - a)·d) * d
    final dx = x - point.x;
    final dy = y - point.y;
    final dz = z - point.z;
    final dot = dx * direction.x + dy * direction.y + dz * direction.z;
    final dirLengthSq = direction.lengthSq();
    
    if (dirLengthSq < ExsPrecision.epsilon) {
      return setFrom(point);
    }
    
    final t = dot / dirLengthSq;
    x = point.x + direction.x * t;
    y = point.y + direction.y * t;
    z = point.z + direction.z * t;
    
    return this;
  }
  
  /// Clamp length between min and max
  ExsVec3 clampLength(double min, double max) {
    final currentLength = length();
    if (currentLength < ExsPrecision.epsilon) {
      return this;
    }
    
    final targetLength = currentLength.clamp(min, max);
    return multiplyScalar(targetLength / currentLength);
  }
  
  /// Clamp components between min and max
  ExsVec3 clamp(ExsVec3 min, ExsVec3 max) {
    x = x.clamp(min.x, max.x);
    y = y.clamp(min.y, max.y);
    z = z.clamp(min.z, max.z);
    return this;
  }
  
  /// Clamp components between scalar min and max
  ExsVec3 clampScalar(double min, double max) {
    x = x.clamp(min, max);
    y = y.clamp(min, max);
    z = z.clamp(min, max);
    return this;
  }
  
  /// Transform by 4x4 matrix (assuming vector is a point, w = 1)
  ExsVec3 applyMatrix4(ExsMat4 matrix) {
    // Implementation depends on ExsMat4 class
    // This is a placeholder for now
    // Will be implemented when ExsMat4 is created
    return this;
  }
  
  /// Transform by 3x3 matrix
  ExsVec3 applyMatrix3(ExsMat3 matrix) {
    // Implementation depends on ExsMat3 class
    // This is a placeholder for now
    // Will be implemented when ExsMat3 is created
    return this;
  }
  
  /// Transform by quaternion
  ExsVec3 applyQuaternion(ExsQuaternion quaternion) {
    // Implementation depends on ExsQuaternion class
    // This is a placeholder for now
    // Will be implemented when ExsQuaternion is created
    return this;
  }
  
  /// Rotate around axis by angle (radians)
  ExsVec3 rotateAround(ExsVec3 axis, double angle) {
    // Implementation depends on quaternion methods
    // This is a placeholder for now
    return this;
  }
  
  /// Check if vector equals another within epsilon tolerance
  bool equals(ExsVec3 other, {double epsilon = ExsPrecision.epsilon}) {
    return (x - other.x).abs() <= epsilon &&
           (y - other.y).abs() <= epsilon &&
           (z - other.z).abs() <= epsilon;
  }
  
  /// Check if vector is approximately zero
  bool isZero({double epsilon = ExsPrecision.epsilon}) {
    return lengthSq() <= epsilon * epsilon;
  }
  
  /// Check if vector has any NaN component
  bool get isNaN => x.isNaN || y.isNaN || z.isNaN;
  
  /// Check if vector has any infinite component
  bool get isInfinite => x.isInfinite || y.isInfinite || z.isInfinite;
  
  /// Check if vector has any finite component
  bool get isFinite => x.isFinite && y.isFinite && z.isFinite;
  
  /// Create a copy (clone) of this vector
  ExsVec3 clone() {
    return ExsVec3(x, y, z);
  }
  
  /// Convert to list [x, y, z]
  List<double> toList() {
    return [x, y, z];
  }
  
  /// Convert to Float32List
  Float32List toFloat32List() {
    return Float32List(3)..[0] = x..[1] = y..[2] = z;
  }
  
  /// Convert to map {'x': x, 'y': y, 'z': z}
  Map<String, double> toMap() {
    return {'x': x, 'y': y, 'z': z};
  }
  
  /// Apply function to each component
  ExsVec3 apply(Function(double) fn) {
    x = fn(x);
    y = fn(y);
    z = fn(z);
    return this;
  }
  
  /// Minimum components with another vector
  ExsVec3 min(ExsVec3 other) {
    x = min(x, other.x);
    y = min(y, other.y);
    z = min(z, other.z);
    return this;
  }
  
  /// Maximum components with another vector
  ExsVec3 max(ExsVec3 other) {
    x = max(x, other.x);
    y = max(y, other.y);
    z = max(z, other.z);
    return this;
  }
  
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExsVec3 &&
          runtimeType == other.runtimeType &&
          x == other.x &&
          y == other.y &&
          z == other.z;
  
  @override
  int get hashCode => Object.hash(x, y, z);
  
  /// String representation
  @override
  String toString() {
    return 'ExsVec3($x, $y, $z)';
  }
  
  /// Operator overloads (syntactic sugar)
  
  /// Add operator: this + other
  ExsVec3 operator +(ExsVec3 other) {
    return clone().add(other);
  }
  
  /// Subtract operator: this - other
  ExsVec3 operator -(ExsVec3 other) {
    return clone().sub(other);
  }
  
  /// Multiply operator (component-wise): this * other
  ExsVec3 operator *(ExsVec3 other) {
    return clone().multiply(other);
  }
  
  /// Multiply by scalar operator: this * scalar
  ExsVec3 operator *(double scalar) {
    return clone().multiplyScalar(scalar);
  }
  
  /// Divide operator (component-wise): this / other
  ExsVec3 operator /(ExsVec3 other) {
    return clone().divide(other);
  }
  
  /// Divide by scalar operator: this / scalar
  ExsVec3 operator /(double scalar) {
    return clone().divideScalar(scalar);
  }
  
  /// Negate operator: -this
  ExsVec3 operator -() {
    return clone().negate();
  }
  
  /// Index access
  double operator [](int index) {
    switch (index) {
      case 0: return x;
      case 1: return y;
      case 2: return z;
      default:
        throw RangeError.index(index, this, 'index', 'Index must be 0, 1, or 2');
    }
  }
  
  /// Index assignment
  void operator []=(int index, double value) {
    switch (index) {
      case 0: x = value; break;
      case 1: y = value; break;
      case 2: z = value; break;
      default:
        throw RangeError.index(index, this, 'index', 'Index must be 0, 1, or 2');
    }
  }
}
