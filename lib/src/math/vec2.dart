/// 2D Vector class for mathematical operations
///
/// Mutable by design for performance. Methods mutate `this` and return `this`
/// for fluent chaining. Use clone() for immutable copies.
///
/// @license MIT
/// @copyright (c) 2024 DSRT Engine

import 'dart:math';
import '../core/constants.dart';

/// 2D Vector class with mutable operations
class ExsVec2 {
  /// X component
  double x;
  
  /// Y component
  double y;
  
  /// Constructor with optional initialization
  ExsVec2([double x = 0.0, double y = 0.0])
    : x = x,
      y = y;
  
  /// Create from list [x, y]
  factory ExsVec2.fromList(List<double> list) {
    assert(list.length >= 2, 'List must contain at least 2 elements');
    return ExsVec2(list[0], list[1]);
  }
  
  /// Create from map {'x': value, 'y': value}
  factory ExsVec2.fromMap(Map<String, dynamic> map) {
    return ExsVec2(
      (map['x'] ?? 0.0).toDouble(),
      (map['y'] ?? 0.0).toDouble(),
    );
  }
  
  /// Create from another vector (copy constructor)
  factory ExsVec2.from(ExsVec2 other) {
    return ExsVec2(other.x, other.y);
  }
  
  /// Zero vector (0, 0)
  static final ExsVec2 zero = ExsVec2(0.0, 0.0);
  
  /// Unit X vector (1, 0)
  static final ExsVec2 unitX = ExsVec2(1.0, 0.0);
  
  /// Unit Y vector (0, 1)
  static final ExsVec2 unitY = ExsVec2(0.0, 1.0);
  
  /// One vector (1, 1)
  static final ExsVec2 one = ExsVec2(1.0, 1.0);
  
  /// Negative one vector (-1, -1)
  static final ExsVec2 negativeOne = ExsVec2(-1.0, -1.0);
  
  /// Infinity vector (infinity, infinity)
  static final ExsVec2 infinity = ExsVec2(double.infinity, double.infinity);
  
  /// Negative infinity vector (-infinity, -infinity)
  static final ExsVec2 negativeInfinity = ExsVec2(double.negativeInfinity, double.negativeInfinity);
  
  /// Set vector components
  ExsVec2 set(double x, double y) {
    this.x = x;
    this.y = y;
    return this;
  }
  
  /// Set from another vector
  ExsVec2 setFrom(ExsVec2 other) {
    x = other.x;
    y = other.y;
    return this;
  }
  
  /// Set from list
  ExsVec2 setFromList(List<double> list) {
    assert(list.length >= 2, 'List must contain at least 2 elements');
    x = list[0];
    y = list[1];
    return this;
  }
  
  /// Set all components to scalar value
  ExsVec2 setScalar(double scalar) {
    x = scalar;
    y = scalar;
    return this;
  }
  
  /// Add scalar to vector
  ExsVec2 addScalar(double scalar) {
    x += scalar;
    y += scalar;
    return this;
  }
  
  /// Add another vector
  ExsVec2 add(ExsVec2 other) {
    x += other.x;
    y += other.y;
    return this;
  }
  
  /// Add scaled vector: this + other * scalar
  ExsVec2 addScaled(ExsVec2 other, double scalar) {
    x += other.x * scalar;
    y += other.y * scalar;
    return this;
  }
  
  /// Subtract scalar from vector
  ExsVec2 subScalar(double scalar) {
    x -= scalar;
    y -= scalar;
    return this;
  }
  
  /// Subtract another vector
  ExsVec2 sub(ExsVec2 other) {
    x -= other.x;
    y -= other.y;
    return this;
  }
  
  /// Multiply by scalar
  ExsVec2 multiplyScalar(double scalar) {
    x *= scalar;
    y *= scalar;
    return this;
  }
  
  /// Multiply by another vector (component-wise)
  ExsVec2 multiply(ExsVec2 other) {
    x *= other.x;
    y *= other.y;
    return this;
  }
  
  /// Divide by scalar
  ExsVec2 divideScalar(double scalar) {
    if (scalar.abs() < ExsPrecision.epsilon) {
      throw ArgumentError('Division by zero or near-zero');
    }
    return multiplyScalar(1.0 / scalar);
  }
  
  /// Divide by another vector (component-wise)
  ExsVec2 divide(ExsVec2 other) {
    if (other.x.abs() < ExsPrecision.epsilon || other.y.abs() < ExsPrecision.epsilon) {
      throw ArgumentError('Division by zero or near-zero component');
    }
    x /= other.x;
    y /= other.y;
    return this;
  }
  
  /// Apply absolute value to each component
  ExsVec2 abs() {
    x = x.abs();
    y = y.abs();
    return this;
  }
  
  /// Apply floor to each component
  ExsVec2 floor() {
    x = x.floorToDouble();
    y = y.floorToDouble();
    return this;
  }
  
  /// Apply ceil to each component
  ExsVec2 ceil() {
    x = x.ceilToDouble();
    y = y.ceilToDouble();
    return this;
  }
  
  /// Apply round to each component
  ExsVec2 round() {
    x = x.roundToDouble();
    y = y.roundToDouble();
    return this;
  }
  
  /// Negate the vector
  ExsVec2 negate() {
    x = -x;
    y = -y;
    return this;
  }
  
  /// Dot product with another vector
  double dot(ExsVec2 other) {
    return x * other.x + y * other.y;
  }
  
  /// Cross product with another vector (returns scalar in 2D)
  double cross(ExsVec2 other) {
    return x * other.y - y * other.x;
  }
  
  /// Length (magnitude) squared
  double lengthSq() {
    return x * x + y * y;
  }
  
  /// Length (magnitude)
  double length() {
    return sqrt(lengthSq());
  }
  
  /// Manhattan length (sum of absolute components)
  double manhattanLength() {
    return x.abs() + y.abs();
  }
  
  /// Normalize the vector (make unit length)
  ExsVec2 normalize() {
    return divideScalar(length());
  }
  
  /// Set length of vector
  ExsVec2 setLength(double length) {
    return normalize().multiplyScalar(length);
  }
  
  /// Distance to another vector squared
  double distanceToSq(ExsVec2 other) {
    final dx = x - other.x;
    final dy = y - other.y;
    return dx * dx + dy * dy;
  }
  
  /// Distance to another vector
  double distanceTo(ExsVec2 other) {
    return sqrt(distanceToSq(other));
  }
  
  /// Manhattan distance to another vector
  double manhattanDistanceTo(ExsVec2 other) {
    return (x - other.x).abs() + (y - other.y).abs();
  }
  
  /// Linear interpolation towards another vector
  ExsVec2 lerp(ExsVec2 other, double alpha) {
    x = x + (other.x - x) * alpha;
    y = y + (other.y - y) * alpha;
    return this;
  }
  
  /// Spherical linear interpolation (for 2D, equivalent to angle lerp)
  ExsVec2 slerp(ExsVec2 other, double alpha) {
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
    
    return this;
  }
  
  /// Rotate vector by angle (radians)
  ExsVec2 rotate(double angle) {
    final cosA = cos(angle);
    final sinA = sin(angle);
    final newX = x * cosA - y * sinA;
    final newY = x * sinA + y * cosA;
    x = newX;
    y = newY;
    return this;
  }
  
  /// Angle between this vector and another (radians)
  double angleTo(ExsVec2 other) {
    final denominator = sqrt(lengthSq() * other.lengthSq());
    if (denominator < ExsPrecision.epsilon) {
      return 0.0;
    }
    final cosTheta = dot(other) / denominator;
    return acos(cosTheta.clamp(-1.0, 1.0));
  }
  
  /// Signed angle between this vector and another (radians)
  double signedAngleTo(ExsVec2 other) {
    return atan2(cross(other), dot(other));
  }
  
  /// Perpendicular vector (rotate 90 degrees counter-clockwise)
  ExsVec2 perpendicular() {
    final temp = x;
    x = -y;
    y = temp;
    return this;
  }
  
  /// Reflect vector off plane with normal
  ExsVec2 reflect(ExsVec2 normal) {
    // r = v - 2 * (v·n) * n
    final dotProduct = dot(normal);
    return sub(normal.multiplyScalar(2.0 * dotProduct));
  }
  
  /// Project vector onto another vector
  ExsVec2 projectOnVector(ExsVec2 vector) {
    final scalar = vector.dot(this) / vector.lengthSq();
    return setFrom(vector).multiplyScalar(scalar);
  }
  
  /// Project vector onto plane defined by normal
  ExsVec2 projectOnPlane(ExsVec2 planeNormal) {
    // v - (v·n) * n
    final dotProduct = dot(planeNormal);
    return sub(planeNormal.multiplyScalar(dotProduct));
  }
  
  /// Clamp length between min and max
  ExsVec2 clampLength(double min, double max) {
    final currentLength = length();
    if (currentLength < ExsPrecision.epsilon) {
      return this;
    }
    
    final targetLength = currentLength.clamp(min, max);
    return multiplyScalar(targetLength / currentLength);
  }
  
  /// Clamp components between min and max
  ExsVec2 clamp(ExsVec2 min, ExsVec2 max) {
    x = x.clamp(min.x, max.x);
    y = y.clamp(min.y, max.y);
    return this;
  }
  
  /// Clamp components between scalar min and max
  ExsVec2 clampScalar(double min, double max) {
    x = x.clamp(min, max);
    y = y.clamp(min, max);
    return this;
  }
  
  /// Check if vector equals another within epsilon tolerance
  bool equals(ExsVec2 other, {double epsilon = ExsPrecision.epsilon}) {
    return (x - other.x).abs() <= epsilon &&
           (y - other.y).abs() <= epsilon;
  }
  
  /// Check if vector is approximately zero
  bool isZero({double epsilon = ExsPrecision.epsilon}) {
    return lengthSq() <= epsilon * epsilon;
  }
  
  /// Check if vector has any NaN component
  bool get isNaN => x.isNaN || y.isNaN;
  
  /// Check if vector has any infinite component
  bool get isInfinite => x.isInfinite || y.isInfinite;
  
  /// Check if vector has any finite component
  bool get isFinite => x.isFinite && y.isFinite;
  
  /// Create a copy (clone) of this vector
  ExsVec2 clone() {
    return ExsVec2(x, y);
  }
  
  /// Convert to list [x, y]
  List<double> toList() {
    return [x, y];
  }
  
  /// Convert to Float32List
  Float32List toFloat32List() {
    return Float32List(2)..[0] = x..[1] = y;
  }
  
  /// Convert to map {'x': x, 'y': y}
  Map<String, double> toMap() {
    return {'x': x, 'y': y};
  }
  
  /// Apply function to each component
  ExsVec2 apply(Function(double) fn) {
    x = fn(x);
    y = fn(y);
    return this;
  }
  
  /// Minimum components with another vector
  ExsVec2 min(ExsVec2 other) {
    x = min(x, other.x);
    y = min(y, other.y);
    return this;
  }
  
  /// Maximum components with another vector
  ExsVec2 max(ExsVec2 other) {
    x = max(x, other.x);
    y = max(y, other.y);
    return this;
  }
  
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExsVec2 &&
          runtimeType == other.runtimeType &&
          x == other.x &&
          y == other.y;
  
  @override
  int get hashCode => Object.hash(x, y);
  
  /// String representation
  @override
  String toString() {
    return 'ExsVec2($x, $y)';
  }
  
  /// Operator overloads (syntactic sugar)
  
  /// Add operator: this + other
  ExsVec2 operator +(ExsVec2 other) {
    return clone().add(other);
  }
  
  /// Subtract operator: this - other
  ExsVec2 operator -(ExsVec2 other) {
    return clone().sub(other);
  }
  
  /// Multiply operator (component-wise): this * other
  ExsVec2 operator *(ExsVec2 other) {
    return clone().multiply(other);
  }
  
  /// Multiply by scalar operator: this * scalar
  ExsVec2 operator *(double scalar) {
    return clone().multiplyScalar(scalar);
  }
  
  /// Divide operator (component-wise): this / other
  ExsVec2 operator /(ExsVec2 other) {
    return clone().divide(other);
  }
  
  /// Divide by scalar operator: this / scalar
  ExsVec2 operator /(double scalar) {
    return clone().divideScalar(scalar);
  }
  
  /// Negate operator: -this
  ExsVec2 operator -() {
    return clone().negate();
  }
  
  /// Index access
  double operator [](int index) {
    switch (index) {
      case 0: return x;
      case 1: return y;
      default:
        throw RangeError.index(index, this, 'index', 'Index must be 0 or 1');
    }
  }
  
  /// Index assignment
  void operator []=(int index, double value) {
    switch (index) {
      case 0: x = value; break;
      case 1: y = value; break;
      default:
        throw RangeError.index(index, this, 'index', 'Index must be 0 or 1');
    }
  }
}
