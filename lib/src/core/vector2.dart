// lib/src/core/math/vector2.dart

/// DSRT Engine - 2D Vector Mathematics
/// 
/// Provides comprehensive 2D vector operations including arithmetic,
/// geometric transformations, interpolation, and utilities.
/// 
/// @category Core
/// @subcategory Math
/// @version 1.0.0
/// @license MIT
/// @copyright DSRT Engine Team

library dsrt_engine.core.math.vector2;

import 'dart:math' as math;
import 'dart:typed_data';

import '../constants.dart';

/// 2D Vector class for mathematical operations
class DsrtVector2 implements DsrtDisposable {
  /// X component
  double x;
  
  /// Y component
  double y;
  
  /// Creates a 2D vector
  /// 
  /// [x]: X component (default: 0.0)
  /// [y]: Y component (default: 0.0)
  DsrtVector2([this.x = 0.0, this.y = 0.0]);
  
  /// Creates a vector from a list
  /// 
  /// [list]: List of [x, y] values
  /// 
  /// Throws [ArgumentError] if list length is not 2.
  factory DsrtVector2.fromList(List<double> list) {
    if (list.length != 2) {
      throw ArgumentError('List must contain exactly 2 elements');
    }
    return DsrtVector2(list[0], list[1]);
  }
  
  /// Creates a vector from a Float32List
  /// 
  /// [array]: Float32List containing vector data
  /// [offset]: Offset in the array (default: 0)
  /// 
  /// Throws [ArgumentError] if array doesn't have enough elements.
  factory DsrtVector2.fromFloat32List(Float32List array, [int offset = 0]) {
    if (offset + 2 > array.length) {
      throw ArgumentError('Array does not have enough elements');
    }
    return DsrtVector2(array[offset], array[offset + 1]);
  }
  
  /// Creates a vector with both components set to the same value
  /// 
  /// [scalar]: Value for both x and y components
  factory DsrtVector2.scalar(double scalar) {
    return DsrtVector2(scalar, scalar);
  }
  
  /// Creates a vector from polar coordinates
  /// 
  /// [radius]: Distance from origin
  /// [angle]: Angle in radians
  factory DsrtVector2.fromPolar(double radius, double angle) {
    return DsrtVector2(
      radius * math.cos(angle),
      radius * math.sin(angle),
    );
  }
  
  /// Zero vector (0, 0)
  static final DsrtVector2 zero = DsrtVector2(0.0, 0.0);
  
  /// Unit X vector (1, 0)
  static final DsrtVector2 unitX = DsrtVector2(1.0, 0.0);
  
  /// Unit Y vector (0, 1)
  static final DsrtVector2 unitY = DsrtVector2(0.0, 1.0);
  
  /// One vector (1, 1)
  static final DsrtVector2 one = DsrtVector2(1.0, 1.0);
  
  /// Negative one vector (-1, -1)
  static final DsrtVector2 negativeOne = DsrtVector2(-1.0, -1.0);
  
  /// Positive infinity vector
  static final DsrtVector2 positiveInfinity = DsrtVector2(
    double.infinity,
    double.infinity,
  );
  
  /// Negative infinity vector
  static final DsrtVector2 negativeInfinity = DsrtVector2(
    double.negativeInfinity,
    double.negativeInfinity,
  );
  
  /// Gets the vector as a list
  List<double> get asList => [x, y];
  
  /// Gets the vector as a Float32List
  Float32List get asFloat32List => Float32List.fromList([x, y]);
  
  /// Gets the vector magnitude (length)
  double get magnitude {
    return math.sqrt(x * x + y * y);
  }
  
  /// Gets the squared magnitude (faster than magnitude for comparisons)
  double get magnitudeSquared {
    return x * x + y * y;
  }
  
  /// Checks if the vector is normalized (approximately unit length)
  bool get isNormalized {
    return (magnitudeSquared - 1.0).abs() < DsrtMathConstants.EPSILON_SMALL;
  }
  
  /// Checks if the vector is approximately zero
  bool get isZero {
    return magnitudeSquared < DsrtMathConstants.EPSILON_SMALL;
  }
  
  /// Checks if the vector contains NaN values
  bool get isNaN {
    return x.isNaN || y.isNaN;
  }
  
  /// Checks if the vector contains infinite values
  bool get isInfinite {
    return x.isInfinite || y.isInfinite;
  }
  
  /// Checks if the vector is valid (finite and not NaN)
  bool get isValid {
    return !isNaN && !isInfinite;
  }
  
  /// Gets the normalized vector (unit vector)
  DsrtVector2 get normalized {
    final mag = magnitude;
    if (mag < DsrtMathConstants.EPSILON_SMALL) {
      return DsrtVector2.zero;
    }
    return DsrtVector2(x / mag, y / mag);
  }
  
  /// Gets the perpendicular vector (rotated 90 degrees clockwise)
  DsrtVector2 get perpendicular {
    return DsrtVector2(y, -x);
  }
  
  /// Gets the angle of the vector in radians
  double get angle {
    return math.atan2(y, x);
  }
  
  /// Gets the angle in degrees
  double get angleDegrees {
    return angle * DsrtMathConstants.RAD_TO_DEG;
  }
  
  /// Sets the vector components
  /// 
  /// [newX]: New X component
  /// [newY]: New Y component
  /// 
  /// Returns this vector for chaining.
  DsrtVector2 set(double newX, double newY) {
    x = newX;
    y = newY;
    return this;
  }
  
  /// Sets the vector from another vector
  /// 
  /// [other]: Vector to copy from
  /// 
  /// Returns this vector for chaining.
  DsrtVector2 setFrom(DsrtVector2 other) {
    x = other.x;
    y = other.y;
    return this;
  }
  
  /// Sets the vector from a list
  /// 
  /// [list]: List of [x, y] values
  /// 
  /// Returns this vector for chaining.
  /// Throws [ArgumentError] if list length is not 2.
  DsrtVector2 setFromList(List<double> list) {
    if (list.length != 2) {
      throw ArgumentError('List must contain exactly 2 elements');
    }
    x = list[0];
    y = list[1];
    return this;
  }
  
  /// Sets the vector from polar coordinates
  /// 
  /// [radius]: Distance from origin
  /// [angle]: Angle in radians
  /// 
  /// Returns this vector for chaining.
  DsrtVector2 setFromPolar(double radius, double angle) {
    x = radius * math.cos(angle);
    y = radius * math.sin(angle);
    return this;
  }
  
  /// Copies this vector to a new instance
  DsrtVector2 copy() {
    return DsrtVector2(x, y);
  }
  
  /// Clones this vector (alias for copy)
  DsrtVector2 clone() => copy();
  
  /// Adds another vector to this vector
  /// 
  /// [other]: Vector to add
  /// 
  /// Returns this vector for chaining.
  DsrtVector2 add(DsrtVector2 other) {
    x += other.x;
    y += other.y;
    return this;
  }
  
  /// Adds scalar values to this vector
  /// 
  /// [scalarX]: X scalar to add
  /// [scalarY]: Y scalar to add
  /// 
  /// Returns this vector for chaining.
  DsrtVector2 addScalars(double scalarX, double scalarY) {
    x += scalarX;
    y += scalarY;
    return this;
  }
  
  /// Subtracts another vector from this vector
  /// 
  /// [other]: Vector to subtract
  /// 
  /// Returns this vector for chaining.
  DsrtVector2 subtract(DsrtVector2 other) {
    x -= other.x;
    y -= other.y;
    return this;
  }
  
  /// Subtracts scalar values from this vector
  /// 
  /// [scalarX]: X scalar to subtract
  /// [scalarY]: Y scalar to subtract
  /// 
  /// Returns this vector for chaining.
  DsrtVector2 subtractScalars(double scalarX, double scalarY) {
    x -= scalarX;
    y -= scalarY;
    return this;
  }
  
  /// Multiplies this vector by another vector (component-wise)
  /// 
  /// [other]: Vector to multiply by
  /// 
  /// Returns this vector for chaining.
  DsrtVector2 multiply(DsrtVector2 other) {
    x *= other.x;
    y *= other.y;
    return this;
  }
  
  /// Multiplies this vector by a scalar
  /// 
  /// [scalar]: Scalar to multiply by
  /// 
  /// Returns this vector for chaining.
  DsrtVector2 multiplyScalar(double scalar) {
    x *= scalar;
    y *= scalar;
    return this;
  }
  
  /// Divides this vector by another vector (component-wise)
  /// 
  /// [other]: Vector to divide by
  /// 
  /// Returns this vector for chaining.
  /// Throws [ArgumentError] if any component of other is zero.
  DsrtVector2 divide(DsrtVector2 other) {
    if (other.x == 0.0 || other.y == 0.0) {
      throw ArgumentError('Cannot divide by zero vector component');
    }
    x /= other.x;
    y /= other.y;
    return this;
  }
  
  /// Divides this vector by a scalar
  /// 
  /// [scalar]: Scalar to divide by
  /// 
  /// Returns this vector for chaining.
  /// Throws [ArgumentError] if scalar is zero.
  DsrtVector2 divideScalar(double scalar) {
    if (scalar == 0.0) {
      throw ArgumentError('Cannot divide by zero');
    }
    return multiplyScalar(1.0 / scalar);
  }
  
  /// Scales this vector by another vector
  /// 
  /// [other]: Vector to scale by
  /// 
  /// Returns this vector for chaining.
  DsrtVector2 scale(DsrtVector2 other) {
    x *= other.x;
    y *= other.y;
    return this;
  }
  
  /// Negates this vector (multiplies by -1)
  /// 
  /// Returns this vector for chaining.
  DsrtVector2 negate() {
    x = -x;
    y = -y;
    return this;
  }
  
  /// Normalizes this vector (makes it unit length)
  /// 
  /// Returns this vector for chaining.
  DsrtVector2 normalize() {
    final mag = magnitude;
    if (mag > DsrtMathConstants.EPSILON_SMALL) {
      return multiplyScalar(1.0 / mag);
    }
    return set(0.0, 0.0);
  }
  
  /// Limits the magnitude of this vector
  /// 
  /// [maxLength]: Maximum allowed magnitude
  /// 
  /// Returns this vector for chaining.
  DsrtVector2 limit(double maxLength) {
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
  DsrtVector2 clamp(DsrtVector2 min, DsrtVector2 max) {
    x = x.clamp(min.x, max.x);
    y = y.clamp(min.y, max.y);
    return this;
  }
  
  /// Clamps the magnitude of this vector
  /// 
  /// [minLength]: Minimum allowed magnitude
  /// [maxLength]: Maximum allowed magnitude
  /// 
  /// Returns this vector for chaining.
  DsrtVector2 clampLength(double minLength, double maxLength) {
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
  DsrtVector2 floor() {
    x = x.floorToDouble();
    y = y.floorToDouble();
    return this;
  }
  
  /// Ceils the components of this vector
  /// 
  /// Returns this vector for chaining.
  DsrtVector2 ceil() {
    x = x.ceilToDouble();
    y = y.ceilToDouble();
    return this;
  }
  
  /// Rounds the components of this vector
  /// 
  /// Returns this vector for chaining.
  DsrtVector2 round() {
    x = x.roundToDouble();
    y = y.roundToDouble();
    return this;
  }
  
  /// Absolute values of the components
  /// 
  /// Returns this vector for chaining.
  DsrtVector2 absolute() {
    x = x.abs();
    y = y.abs();
    return this;
  }
  
  /// Rotates this vector by an angle
  /// 
  /// [angle]: Angle in radians
  /// 
  /// Returns this vector for chaining.
  DsrtVector2 rotate(double angle) {
    final cosA = math.cos(angle);
    final sinA = math.sin(angle);
    final newX = x * cosA - y * sinA;
    final newY = x * sinA + y * cosA;
    x = newX;
    y = newY;
    return this;
  }
  
  /// Rotates this vector by 90 degrees
  /// 
  /// Returns this vector for chaining.
  DsrtVector2 rotate90() {
    final temp = x;
    x = -y;
    y = temp;
    return this;
  }
  
  /// Rotates this vector by -90 degrees
  /// 
  /// Returns this vector for chaining.
  DsrtVector2 rotateNeg90() {
    final temp = x;
    x = y;
    y = -temp;
    return this;
  }
  
  /// Sets this vector to the linear interpolation between two vectors
  /// 
  /// [start]: Start vector
  /// [end]: End vector
  /// [t]: Interpolation factor (0.0 to 1.0)
  /// 
  /// Returns this vector for chaining.
  DsrtVector2 lerp(DsrtVector2 start, DsrtVector2 end, double t) {
    x = start.x + (end.x - start.x) * t;
    y = start.y + (end.y - start.y) * t;
    return this;
  }
  
  /// Sets this vector to the spherical linear interpolation between two vectors
  /// 
  /// [start]: Start vector (should be normalized)
  /// [end]: End vector (should be normalized)
  /// [t]: Interpolation factor (0.0 to 1.0)
  /// 
  /// Returns this vector for chaining.
  DsrtVector2 slerp(DsrtVector2 start, DsrtVector2 end, double t) {
    final dot = start.dot(end);
    
    // Clamp dot product to handle floating point errors
    final clampedDot = dot.clamp(-1.0, 1.0);
    
    final theta = math.acos(clampedDot) * t;
    final relative = end.subtract(start.multiplyScalar(dot)).normalize();
    
    return setFrom(
      start.multiplyScalar(math.cos(theta)).add(relative.multiplyScalar(math.sin(theta))),
    );
  }
  
  /// Sets this vector to the minimum components of two vectors
  /// 
  /// [a]: First vector
  /// [b]: Second vector
  /// 
  /// Returns this vector for chaining.
  DsrtVector2 min(DsrtVector2 a, DsrtVector2 b) {
    x = math.min(a.x, b.x);
    y = math.min(a.y, b.y);
    return this;
  }
  
  /// Sets this vector to the maximum components of two vectors
  /// 
  /// [a]: First vector
  /// [b]: Second vector
  /// 
  /// Returns this vector for chaining.
  DsrtVector2 max(DsrtVector2 a, DsrtVector2 b) {
    x = math.max(a.x, b.x);
    y = math.max(a.y, b.y);
    return this;
  }
  
  /// Calculates the dot product with another vector
  /// 
  /// [other]: Other vector
  /// 
  /// Returns the dot product.
  double dot(DsrtVector2 other) {
    return x * other.x + y * other.y;
  }
  
  /// Calculates the cross product with another vector
  /// 
  /// [other]: Other vector
  /// 
  /// Returns the cross product (z-component in 3D).
  double cross(DsrtVector2 other) {
    return x * other.y - y * other.x;
  }
  
  /// Calculates the distance to another vector
  /// 
  /// [other]: Other vector
  /// 
  /// Returns the distance.
  double distanceTo(DsrtVector2 other) {
    final dx = x - other.x;
    final dy = y - other.y;
    return math.sqrt(dx * dx + dy * dy);
  }
  
  /// Calculates the squared distance to another vector
  /// 
  /// [other]: Other vector
  /// 
  /// Returns the squared distance.
  double distanceToSquared(DsrtVector2 other) {
    final dx = x - other.x;
    final dy = y - other.y;
    return dx * dx + dy * dy;
  }
  
  /// Calculates the Manhattan distance to another vector
  /// 
  /// [other]: Other vector
  /// 
  /// Returns the Manhattan distance.
  double manhattanDistanceTo(DsrtVector2 other) {
    return (x - other.x).abs() + (y - other.y).abs();
  }
  
  /// Calculates the angle to another vector
  /// 
  /// [other]: Other vector
  /// 
  /// Returns the angle in radians.
  double angleTo(DsrtVector2 other) {
    final dot = this.dot(other);
    final mag = magnitude * other.magnitude;
    
    if (mag < DsrtMathConstants.EPSILON_SMALL) {
      return 0.0;
    }
    
    final cosTheta = dot / mag;
    return math.acos(cosTheta.clamp(-1.0, 1.0));
  }
  
  /// Checks if this vector is approximately equal to another vector
  /// 
  /// [other]: Other vector to compare with
  /// [epsilon]: Tolerance for comparison
  /// 
  /// Returns true if vectors are approximately equal.
  bool equals(DsrtVector2 other, [double? epsilon]) {
    final eps = epsilon ?? DsrtMathConstants.EPSILON_SMALL;
    return (x - other.x).abs() < eps && (y - other.y).abs() < eps;
  }
  
  /// Checks if this vector is exactly equal to another vector
  /// 
  /// [other]: Other vector to compare with
  /// 
  /// Returns true if vectors are exactly equal.
  @override
  bool operator ==(Object other) {
    return other is DsrtVector2 && x == other.x && y == other.y;
  }
  
  /// Gets the hash code for this vector
  @override
  int get hashCode => Object.hash(x, y);
  
  /// String representation of this vector
  @override
  String toString() {
    return 'DsrtVector2(${x.toStringAsFixed(6)}, ${y.toStringAsFixed(6)})';
  }
  
  /// Adds two vectors
  DsrtVector2 operator +(DsrtVector2 other) {
    return DsrtVector2(x + other.x, y + other.y);
  }
  
  /// Subtracts two vectors
  DsrtVector2 operator -(DsrtVector2 other) {
    return DsrtVector2(x - other.x, y - other.y);
  }
  
  /// Multiplies vector by scalar
  DsrtVector2 operator *(double scalar) {
    return DsrtVector2(x * scalar, y * scalar);
  }
  
  /// Divides vector by scalar
  DsrtVector2 operator /(double scalar) {
    if (scalar == 0.0) {
      throw ArgumentError('Cannot divide by zero');
    }
    return DsrtVector2(x / scalar, y / scalar);
  }
  
  /// Negates vector
  DsrtVector2 operator -() {
    return DsrtVector2(-x, -y);
  }
  
  /// Accesses vector components by index
  /// 
  /// [index]: 0 for x, 1 for y
  /// 
  /// Returns the component value.
  /// Throws [RangeError] if index is not 0 or 1.
  double operator [](int index) {
    switch (index) {
      case 0:
        return x;
      case 1:
        return y;
      default:
        throw RangeError.index(index, this, 'index', 'Index must be 0 or 1');
    }
  }
  
  /// Sets vector components by index
  /// 
  /// [index]: 0 for x, 1 for y
  /// [value]: New value
  /// 
  /// Throws [RangeError] if index is not 0 or 1.
  void operator []=(int index, double value) {
    switch (index) {
      case 0:
        x = value;
        break;
      case 1:
        y = value;
        break;
      default:
        throw RangeError.index(index, this, 'index', 'Index must be 0 or 1');
    }
  }
  
  /// Disposes this vector
  @override
  Future<void> dispose() async {
    // Vector doesn't hold any native resources
  }
}

/// Vector2 utilities and static functions
class DsrtVector2Utils {
  /// Creates a vector from an angle
  /// 
  /// [angle]: Angle in radians
  /// 
  /// Returns a unit vector pointing in the given direction.
  static DsrtVector2 fromAngle(double angle) {
    return DsrtVector2(math.cos(angle), math.sin(angle));
  }
  
  /// Creates a random unit vector
  /// 
  /// [random]: Optional Random instance
  /// 
  /// Returns a random unit vector.
  static DsrtVector2 randomUnit([math.Random? random]) {
    final rnd = random ?? math.Random();
    final angle = rnd.nextDouble() * DsrtMathConstants.TAU;
    return DsrtVector2(math.cos(angle), math.sin(angle));
  }
  
  /// Creates a random vector within a circle
  /// 
  /// [radius]: Maximum radius
  /// [random]: Optional Random instance
  /// 
  /// Returns a random vector within the circle.
  static DsrtVector2 randomInCircle(double radius, [math.Random? random]) {
    final rnd = random ?? math.Random();
    final angle = rnd.nextDouble() * DsrtMathConstants.TAU;
    final r = math.sqrt(rnd.nextDouble()) * radius;
    return DsrtVector2(r * math.cos(angle), r * math.sin(angle));
  }
  
  /// Creates a random vector within a rectangle
  /// 
  /// [width]: Rectangle width
  /// [height]: Rectangle height
  /// [random]: Optional Random instance
  /// 
  /// Returns a random vector within the rectangle.
  static DsrtVector2 randomInRectangle(double width, double height, [math.Random? random]) {
    final rnd = random ?? math.Random();
    return DsrtVector2(
      rnd.nextDouble() * width - width * 0.5,
      rnd.nextDouble() * height - height * 0.5,
    );
  }
  
  /// Calculates the dot product of two vectors
  static double dot(DsrtVector2 a, DsrtVector2 b) {
    return a.x * b.x + a.y * b.y;
  }
  
  /// Calculates the cross product of two vectors
  static double cross(DsrtVector2 a, DsrtVector2 b) {
    return a.x * b.y - a.y * b.x;
  }
  
  /// Calculates the distance between two vectors
  static double distance(DsrtVector2 a, DsrtVector2 b) {
    return a.distanceTo(b);
  }
  
  /// Calculates the squared distance between two vectors
  static double distanceSquared(DsrtVector2 a, DsrtVector2 b) {
    return a.distanceToSquared(b);
  }
  
  /// Calculates the angle between two vectors
  static double angle(DsrtVector2 a, DsrtVector2 b) {
    return a.angleTo(b);
  }
  
  /// Linearly interpolates between two vectors
  static DsrtVector2 lerp(DsrtVector2 a, DsrtVector2 b, double t) {
    return DsrtVector2(
      a.x + (b.x - a.x) * t,
      a.y + (b.y - a.y) * t,
    );
  }
  
  /// Spherically interpolates between two vectors
  static DsrtVector2 slerp(DsrtVector2 a, DsrtVector2 b, double t) {
    final result = DsrtVector2();
    return result.slerp(a, b, t);
  }
  
  /// Returns the component-wise minimum of two vectors
  static DsrtVector2 min(DsrtVector2 a, DsrtVector2 b) {
    return DsrtVector2(
      math.min(a.x, b.x),
      math.min(a.y, b.y),
    );
  }
  
  /// Returns the component-wise maximum of two vectors
  static DsrtVector2 max(DsrtVector2 a, DsrtVector2 b) {
    return DsrtVector2(
      math.max(a.x, b.x),
      math.max(a.y, b.y),
    );
  }
  
  /// Returns the reflection of a vector off a surface
  /// 
  /// [vector]: Incident vector
  /// [normal]: Surface normal (should be normalized)
  /// 
  /// Returns the reflected vector.
  static DsrtVector2 reflect(DsrtVector2 vector, DsrtVector2 normal) {
    final dot = vector.dot(normal);
    return DsrtVector2(
      vector.x - 2.0 * dot * normal.x,
      vector.y - 2.0 * dot * normal.y,
    );
  }
  
  /// Returns the projection of a vector onto another vector
  /// 
  /// [vector]: Vector to project
  /// [onto]: Vector to project onto (should be normalized)
  /// 
  /// Returns the projected vector.
  static DsrtVector2 project(DsrtVector2 vector, DsrtVector2 onto) {
    final scalar = vector.dot(onto);
    return DsrtVector2(
      onto.x * scalar,
      onto.y * scalar,
    );
  }
  
  /// Returns the rejection of a vector from another vector
  /// 
  /// [vector]: Vector to reject
  /// [from]: Vector to reject from (should be normalized)
  /// 
  /// Returns the rejected vector.
  static DsrtVector2 reject(DsrtVector2 vector, DsrtVector2 from) {
    final projection = project(vector, from);
    return DsrtVector2(
      vector.x - projection.x,
      vector.y - projection.y,
    );
  }
  
  /// Returns the perpendicular vector
  static DsrtVector2 perpendicular(DsrtVector2 vector) {
    return DsrtVector2(-vector.y, vector.x);
  }
  
  /// Checks if three points are collinear
  /// 
  /// [a]: First point
  /// [b]: Second point
  /// [c]: Third point
  /// [epsilon]: Tolerance for collinearity
  /// 
  /// Returns true if points are collinear.
  static bool areCollinear(
    DsrtVector2 a,
    DsrtVector2 b,
    DsrtVector2 c, [
    double epsilon = DsrtMathConstants.EPSILON_SMALL,
  ]) {
    final area = (b.x - a.x) * (c.y - a.y) - (b.y - a.y) * (c.x - a.x);
    return area.abs() < epsilon;
  }
  
  /// Calculates the signed area of a triangle
  /// 
  /// [a]: First vertex
  /// [b]: Second vertex
  /// [c]: Third vertex
  /// 
  /// Returns the signed area (positive if vertices are counter-clockwise).
  static double triangleArea(
    DsrtVector2 a,
    DsrtVector2 b,
    DsrtVector2 c,
  ) {
    return (b.x - a.x) * (c.y - a.y) - (b.y - a.y) * (c.x - a.x);
  }
  
  /// Checks if a point is inside a triangle
  /// 
  /// [point]: Point to test
  /// [a]: First triangle vertex
  /// [b]: Second triangle vertex
  /// [c]: Third triangle vertex
  /// 
  /// Returns true if point is inside the triangle.
  static bool pointInTriangle(
    DsrtVector2 point,
    DsrtVector2 a,
    DsrtVector2 b,
    DsrtVector2 c,
  ) {
    final s1 = c.y - a.y;
    final s2 = c.x - a.x;
    final s3 = b.y - a.y;
    final s4 = point.y - a.y;
    
    final w1 = (a.x * s1 + s4 * s2 - point.x * s1) / (s3 * s2 - (b.x - a.x) * s1);
    final w2 = (s4 - w1 * s3) / s1;
    
    return w1 >= 0.0 && w2 >= 0.0 && (w1 + w2) <= 1.0;
  }
  
  /// Calculates the barycentric coordinates of a point relative to a triangle
  /// 
  /// [point]: Point to convert
  /// [a]: First triangle vertex
  /// [b]: Second triangle vertex
  /// [c]: Third triangle vertex
  /// 
  /// Returns barycentric coordinates [u, v, w].
  static List<double> barycentricCoordinates(
    DsrtVector2 point,
    DsrtVector2 a,
    DsrtVector2 b,
    DsrtVector2 c,
  ) {
    final v0 = DsrtVector2(b.x - a.x, b.y - a.y);
    final v1 = DsrtVector2(c.x - a.x, c.y - a.y);
    final v2 = DsrtVector2(point.x - a.x, point.y - a.y);
    
    final d00 = v0.dot(v0);
    final d01 = v0.dot(v1);
    final d11 = v1.dot(v1);
    final d20 = v2.dot(v0);
    final d21 = v2.dot(v1);
    
    final denom = d00 * d11 - d01 * d01;
    
    final v = (d11 * d20 - d01 * d21) / denom;
    final w = (d00 * d21 - d01 * d20) / denom;
    final u = 1.0 - v - w;
    
    return [u, v, w];
  }
  
  /// Converts a list of vectors to a Float32List
  static Float32List toFloat32List(List<DsrtVector2> vectors) {
    final result = Float32List(vectors.length * 2);
    for (var i = 0; i < vectors.length; i++) {
      final vector = vectors[i];
      result[i * 2] = vector.x;
      result[i * 2 + 1] = vector.y;
    }
    return result;
  }
  
  /// Creates vectors from a Float32List
  static List<DsrtVector2> fromFloat32List(Float32List data) {
    if (data.length % 2 != 0) {
      throw ArgumentError('Data length must be even');
    }
    
    final vectors = <DsrtVector2>[];
    for (var i = 0; i < data.length; i += 2) {
      vectors.add(DsrtVector2(data[i], data[i + 1]));
    }
    return vectors;
  }
}
