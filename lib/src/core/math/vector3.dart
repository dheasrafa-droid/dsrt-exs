// lib/src/core/math/vector3.dart

/// DSRT Engine - 3D Vector Mathematics
/// 
/// Provides comprehensive 3D vector operations including arithmetic,
/// geometric transformations, interpolation, and utilities for 3D graphics.
/// 
/// @category Core
/// @subcategory Math
/// @version 1.0.0
/// @license MIT
/// @copyright DSRT Engine Team

library dsrt_engine.core.math.vector3;

import 'dart:math' as math;
import 'dart:typed_data';

import '../constants.dart';

/// 3D Vector class for mathematical operations in 3D space
class DsrtVector3 implements DsrtDisposable {
  /// X component
  double x;
  
  /// Y component
  double y;
  
  /// Z component
  double z;
  
  /// Creates a 3D vector
  /// 
  /// [x]: X component (default: 0.0)
  /// [y]: Y component (default: 0.0)
  /// [z]: Z component (default: 0.0)
  DsrtVector3([this.x = 0.0, this.y = 0.0, this.z = 0.0]);
  
  /// Creates a vector from a list
  /// 
  /// [list]: List of [x, y, z] values
  /// 
  /// Throws [ArgumentError] if list length is not 3.
  factory DsrtVector3.fromList(List<double> list) {
    if (list.length != 3) {
      throw ArgumentError('List must contain exactly 3 elements');
    }
    return DsrtVector3(list[0], list[1], list[2]);
  }
  
  /// Creates a vector from a Float32List
  /// 
  /// [array]: Float32List containing vector data
  /// [offset]: Offset in the array (default: 0)
  /// 
  /// Throws [ArgumentError] if array doesn't have enough elements.
  factory DsrtVector3.fromFloat32List(Float32List array, [int offset = 0]) {
    if (offset + 3 > array.length) {
      throw ArgumentError('Array does not have enough elements');
    }
    return DsrtVector3(array[offset], array[offset + 1], array[offset + 2]);
  }
  
  /// Creates a vector with all components set to the same value
  /// 
  /// [scalar]: Value for x, y, and z components
  factory DsrtVector3.scalar(double scalar) {
    return DsrtVector3(scalar, scalar, scalar);
  }
  
  /// Creates a vector from spherical coordinates
  /// 
  /// [radius]: Distance from origin
  /// [phi]: Polar angle in radians (0 to π)
  /// [theta]: Azimuthal angle in radians (0 to 2π)
  factory DsrtVector3.fromSpherical(double radius, double phi, double theta) {
    final sinPhi = math.sin(phi);
    return DsrtVector3(
      radius * sinPhi * math.cos(theta),
      radius * sinPhi * math.sin(theta),
      radius * math.cos(phi),
    );
  }
  
  /// Creates a vector from cylindrical coordinates
  /// 
  /// [radius]: Radial distance
  /// [theta]: Azimuthal angle in radians
  /// [height]: Height
  factory DsrtVector3.fromCylindrical(double radius, double theta, double height) {
    return DsrtVector3(
      radius * math.cos(theta),
      radius * math.sin(theta),
      height,
    );
  }
  
  /// Zero vector (0, 0, 0)
  static final DsrtVector3 zero = DsrtVector3(0.0, 0.0, 0.0);
  
  /// Unit X vector (1, 0, 0)
  static final DsrtVector3 unitX = DsrtVector3(1.0, 0.0, 0.0);
  
  /// Unit Y vector (0, 1, 0)
  static final DsrtVector3 unitY = DsrtVector3(0.0, 1.0, 0.0);
  
  /// Unit Z vector (0, 0, 1)
  static final DsrtVector3 unitZ = DsrtVector3(0.0, 0.0, 1.0);
  
  /// One vector (1, 1, 1)
  static final DsrtVector3 one = DsrtVector3(1.0, 1.0, 1.0);
  
  /// Negative one vector (-1, -1, -1)
  static final DsrtVector3 negativeOne = DsrtVector3(-1.0, -1.0, -1.0);
  
  /// Positive infinity vector
  static final DsrtVector3 positiveInfinity = DsrtVector3(
    double.infinity,
    double.infinity,
    double.infinity,
  );
  
  /// Negative infinity vector
  static final DsrtVector3 negativeInfinity = DsrtVector3(
    double.negativeInfinity,
    double.negativeInfinity,
    double.negativeInfinity,
  );
  
  /// Up vector (0, 1, 0)
  static final DsrtVector3 up = DsrtVector3(0.0, 1.0, 0.0);
  
  /// Down vector (0, -1, 0)
  static final DsrtVector3 down = DsrtVector3(0.0, -1.0, 0.0);
  
  /// Left vector (-1, 0, 0)
  static final DsrtVector3 left = DsrtVector3(-1.0, 0.0, 0.0);
  
  /// Right vector (1, 0, 0)
  static final DsrtVector3 right = DsrtVector3(1.0, 0.0, 0.0);
  
  /// Forward vector (0, 0, -1) - OpenGL convention
  static final DsrtVector3 forward = DsrtVector3(0.0, 0.0, -1.0);
  
  /// Backward vector (0, 0, 1)
  static final DsrtVector3 backward = DsrtVector3(0.0, 0.0, 1.0);
  
  /// Gets the vector as a list
  List<double> get asList => [x, y, z];
  
  /// Gets the vector as a Float32List
  Float32List get asFloat32List => Float32List.fromList([x, y, z]);
  
  /// Gets the vector magnitude (length)
  double get magnitude {
    return math.sqrt(x * x + y * y + z * z);
  }
  
  /// Gets the squared magnitude (faster than magnitude for comparisons)
  double get magnitudeSquared {
    return x * x + y * y + z * z;
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
    return x.isNaN || y.isNaN || z.isNaN;
  }
  
  /// Checks if the vector contains infinite values
  bool get isInfinite {
    return x.isInfinite || y.isInfinite || z.isInfinite;
  }
  
  /// Checks if the vector is valid (finite and not NaN)
  bool get isValid {
    return !isNaN && !isInfinite;
  }
  
  /// Gets the normalized vector (unit vector)
  DsrtVector3 get normalized {
    final mag = magnitude;
    if (mag < DsrtMathConstants.EPSILON_SMALL) {
      return DsrtVector3.zero;
    }
    return DsrtVector3(x / mag, y / mag, z / mag);
  }
  
  /// Gets the spherical coordinates
  Map<String, double> get spherical {
    final radius = magnitude;
    if (radius < DsrtMathConstants.EPSILON_SMALL) {
      return {'radius': 0.0, 'phi': 0.0, 'theta': 0.0};
    }
    
    final phi = math.acos(z / radius);
    final theta = math.atan2(y, x);
    
    return {
      'radius': radius,
      'phi': phi,
      'theta': theta,
    };
  }
  
  /// Gets the cylindrical coordinates
  Map<String, double> get cylindrical {
    final radius = math.sqrt(x * x + y * y);
    final theta = math.atan2(y, x);
    
    return {
      'radius': radius,
      'theta': theta,
      'height': z,
    };
  }
  
  /// Sets the vector components
  /// 
  /// [newX]: New X component
  /// [newY]: New Y component
  /// [newZ]: New Z component
  /// 
  /// Returns this vector for chaining.
  DsrtVector3 set(double newX, double newY, double newZ) {
    x = newX;
    y = newY;
    z = newZ;
    return this;
  }
  
  /// Sets the vector from another vector
  /// 
  /// [other]: Vector to copy from
  /// 
  /// Returns this vector for chaining.
  DsrtVector3 setFrom(DsrtVector3 other) {
    x = other.x;
    y = other.y;
    z = other.z;
    return this;
  }
  
  /// Sets the vector from a list
  /// 
  /// [list]: List of [x, y, z] values
  /// 
  /// Returns this vector for chaining.
  /// Throws [ArgumentError] if list length is not 3.
  DsrtVector3 setFromList(List<double> list) {
    if (list.length != 3) {
      throw ArgumentError('List must contain exactly 3 elements');
    }
    x = list[0];
    y = list[1];
    z = list[2];
    return this;
  }
  
  /// Sets the vector from spherical coordinates
  /// 
  /// [radius]: Distance from origin
  /// [phi]: Polar angle in radians (0 to π)
  /// [theta]: Azimuthal angle in radians (0 to 2π)
  /// 
  /// Returns this vector for chaining.
  DsrtVector3 setFromSpherical(double radius, double phi, double theta) {
    final sinPhi = math.sin(phi);
    x = radius * sinPhi * math.cos(theta);
    y = radius * sinPhi * math.sin(theta);
    z = radius * math.cos(phi);
    return this;
  }
  
  /// Sets the vector from cylindrical coordinates
  /// 
  /// [radius]: Radial distance
  /// [theta]: Azimuthal angle in radians
  /// [height]: Height
  /// 
  /// Returns this vector for chaining.
  DsrtVector3 setFromCylindrical(double radius, double theta, double height) {
    x = radius * math.cos(theta);
    y = radius * math.sin(theta);
    z = height;
    return this;
  }
  
  /// Copies this vector to a new instance
  DsrtVector3 copy() {
    return DsrtVector3(x, y, z);
  }
  
  /// Clones this vector (alias for copy)
  DsrtVector3 clone() => copy();
  
  /// Adds another vector to this vector
  /// 
  /// [other]: Vector to add
  /// 
  /// Returns this vector for chaining.
  DsrtVector3 add(DsrtVector3 other) {
    x += other.x;
    y += other.y;
    z += other.z;
    return this;
  }
  
  /// Adds scalar values to this vector
  /// 
  /// [scalarX]: X scalar to add
  /// [scalarY]: Y scalar to add
  /// [scalarZ]: Z scalar to add
  /// 
  /// Returns this vector for chaining.
  DsrtVector3 addScalars(double scalarX, double scalarY, double scalarZ) {
    x += scalarX;
    y += scalarY;
    z += scalarZ;
    return this;
  }
  
  /// Subtracts another vector from this vector
  /// 
  /// [other]: Vector to subtract
  /// 
  /// Returns this vector for chaining.
  DsrtVector3 subtract(DsrtVector3 other) {
    x -= other.x;
    y -= other.y;
    z -= other.z;
    return this;
  }
  
  /// Subtracts scalar values from this vector
  /// 
  /// [scalarX]: X scalar to subtract
  /// [scalarY]: Y scalar to subtract
  /// [scalarZ]: Z scalar to subtract
  /// 
  /// Returns this vector for chaining.
  DsrtVector3 subtractScalars(double scalarX, double scalarY, double scalarZ) {
    x -= scalarX;
    y -= scalarY;
    z -= scalarZ;
    return this;
  }
  
  /// Multiplies this vector by another vector (component-wise)
  /// 
  /// [other]: Vector to multiply by
  /// 
  /// Returns this vector for chaining.
  DsrtVector3 multiply(DsrtVector3 other) {
    x *= other.x;
    y *= other.y;
    z *= other.z;
    return this;
  }
  
  /// Multiplies this vector by a scalar
  /// 
  /// [scalar]: Scalar to multiply by
  /// 
  /// Returns this vector for chaining.
  DsrtVector3 multiplyScalar(double scalar) {
    x *= scalar;
    y *= scalar;
    z *= scalar;
    return this;
  }
  
  /// Divides this vector by another vector (component-wise)
  /// 
  /// [other]: Vector to divide by
  /// 
  /// Returns this vector for chaining.
  /// Throws [ArgumentError] if any component of other is zero.
  DsrtVector3 divide(DsrtVector3 other) {
    if (other.x == 0.0 || other.y == 0.0 || other.z == 0.0) {
      throw ArgumentError('Cannot divide by zero vector component');
    }
    x /= other.x;
    y /= other.y;
    z /= other.z;
    return this;
  }
  
  /// Divides this vector by a scalar
  /// 
  /// [scalar]: Scalar to divide by
  /// 
  /// Returns this vector for chaining.
  /// Throws [ArgumentError] if scalar is zero.
  DsrtVector3 divideScalar(double scalar) {
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
  DsrtVector3 scale(DsrtVector3 other) {
    x *= other.x;
    y *= other.y;
    z *= other.z;
    return this;
  }
  
  /// Negates this vector (multiplies by -1)
  /// 
  /// Returns this vector for chaining.
  DsrtVector3 negate() {
    x = -x;
    y = -y;
    z = -z;
    return this;
  }
  
  /// Normalizes this vector (makes it unit length)
  /// 
  /// Returns this vector for chaining.
  DsrtVector3 normalize() {
    final mag = magnitude;
    if (mag > DsrtMathConstants.EPSILON_SMALL) {
      return multiplyScalar(1.0 / mag);
    }
    return set(0.0, 0.0, 0.0);
  }
  
  /// Limits the magnitude of this vector
  /// 
  /// [maxLength]: Maximum allowed magnitude
  /// 
  /// Returns this vector for chaining.
  DsrtVector3 limit(double maxLength) {
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
  DsrtVector3 clamp(DsrtVector3 min, DsrtVector3 max) {
    x = x.clamp(min.x, max.x);
    y = y.clamp(min.y, max.y);
    z = z.clamp(min.z, max.z);
    return this;
  }
  
  /// Clamps the magnitude of this vector
  /// 
  /// [minLength]: Minimum allowed magnitude
  /// [maxLength]: Maximum allowed magnitude
  /// 
  /// Returns this vector for chaining.
  DsrtVector3 clampLength(double minLength, double maxLength) {
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
  DsrtVector3 floor() {
    x = x.floorToDouble();
    y = y.floorToDouble();
    z = z.floorToDouble();
    return this;
  }
  
  /// Ceils the components of this vector
  /// 
  /// Returns this vector for chaining.
  DsrtVector3 ceil() {
    x = x.ceilToDouble();
    y = y.ceilToDouble();
    z = z.ceilToDouble();
    return this;
  }
  
  /// Rounds the components of this vector
  /// 
  /// Returns this vector for chaining.
  DsrtVector3 round() {
    x = x.roundToDouble();
    y = y.roundToDouble();
    z = z.roundToDouble();
    return this;
  }
  
  /// Absolute values of the components
  /// 
  /// Returns this vector for chaining.
  DsrtVector3 absolute() {
    x = x.abs();
    y = y.abs();
    z = z.abs();
    return this;
  }
  
  /// Sets this vector to the linear interpolation between two vectors
  /// 
  /// [start]: Start vector
  /// [end]: End vector
  /// [t]: Interpolation factor (0.0 to 1.0)
  /// 
  /// Returns this vector for chaining.
  DsrtVector3 lerp(DsrtVector3 start, DsrtVector3 end, double t) {
    x = start.x + (end.x - start.x) * t;
    y = start.y + (end.y - start.y) * t;
    z = start.z + (end.z - start.z) * t;
    return this;
  }
  
  /// Sets this vector to the spherical linear interpolation between two vectors
  /// 
  /// [start]: Start vector (should be normalized)
  /// [end]: End vector (should be normalized)
  /// [t]: Interpolation factor (0.0 to 1.0)
  /// 
  /// Returns this vector for chaining.
  DsrtVector3 slerp(DsrtVector3 start, DsrtVector3 end, double t) {
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
  DsrtVector3 min(DsrtVector3 a, DsrtVector3 b) {
    x = math.min(a.x, b.x);
    y = math.min(a.y, b.y);
    z = math.min(a.z, b.z);
    return this;
  }
  
  /// Sets this vector to the maximum components of two vectors
  /// 
  /// [a]: First vector
  /// [b]: Second vector
  /// 
  /// Returns this vector for chaining.
  DsrtVector3 max(DsrtVector3 a, DsrtVector3 b) {
    x = math.max(a.x, b.x);
    y = math.max(a.y, b.y);
    z = math.max(a.z, b.z);
    return this;
  }
  
  /// Calculates the dot product with another vector
  /// 
  /// [other]: Other vector
  /// 
  /// Returns the dot product.
  double dot(DsrtVector3 other) {
    return x * other.x + y * other.y + z * other.z;
  }
  
  /// Calculates the cross product with another vector
  /// 
  /// [other]: Other vector
  /// 
  /// Returns the cross product as a new vector.
  DsrtVector3 cross(DsrtVector3 other) {
    return DsrtVector3(
      y * other.z - z * other.y,
      z * other.x - x * other.z,
      x * other.y - y * other.x,
    );
  }
  
  /// Calculates the distance to another vector
  /// 
  /// [other]: Other vector
  /// 
  /// Returns the distance.
  double distanceTo(DsrtVector3 other) {
    final dx = x - other.x;
    final dy = y - other.y;
    final dz = z - other.z;
    return math.sqrt(dx * dx + dy * dy + dz * dz);
  }
  
  /// Calculates the squared distance to another vector
  /// 
  /// [other]: Other vector
  /// 
  /// Returns the squared distance.
  double distanceToSquared(DsrtVector3 other) {
    final dx = x - other.x;
    final dy = y - other.y;
    final dz = z - other.z;
    return dx * dx + dy * dy + dz * dz;
  }
  
  /// Calculates the Manhattan distance to another vector
  /// 
  /// [other]: Other vector
  /// 
  /// Returns the Manhattan distance.
  double manhattanDistanceTo(DsrtVector3 other) {
    return (x - other.x).abs() + (y - other.y).abs() + (z - other.z).abs();
  }
  
  /// Calculates the angle to another vector
  /// 
  /// [other]: Other vector
  /// 
  /// Returns the angle in radians.
  double angleTo(DsrtVector3 other) {
    final dot = this.dot(other);
    final mag = magnitude * other.magnitude;
    
    if (mag < DsrtMathConstants.EPSILON_SMALL) {
      return 0.0;
    }
    
    final cosTheta = dot / mag;
    return math.acos(cosTheta.clamp(-1.0, 1.0));
  }
  
  /// Projects this vector onto another vector
  /// 
  /// [other]: Vector to project onto (should be normalized)
  /// 
  /// Returns this vector for chaining.
  DsrtVector3 projectOnVector(DsrtVector3 other) {
    final denominator = other.magnitudeSquared;
    
    if (denominator == 0.0) {
      return set(0.0, 0.0, 0.0);
    }
    
    final scalar = dot(other) / denominator;
    return setFrom(other.multiplyScalar(scalar));
  }
  
  /// Projects this vector onto a plane
  /// 
  /// [planeNormal]: Plane normal (should be normalized)
  /// 
  /// Returns this vector for chaining.
  DsrtVector3 projectOnPlane(DsrtVector3 planeNormal) {
    final projection = projectOnVector(planeNormal);
    return subtract(projection);
  }
  
  /// Reflects this vector off a plane
  /// 
  /// [planeNormal]: Plane normal (should be normalized)
  /// 
  /// Returns this vector for chaining.
  DsrtVector3 reflect(DsrtVector3 planeNormal) {
    final dot = this.dot(planeNormal);
    return subtract(planeNormal.multiplyScalar(2.0 * dot));
  }
  
  /// Rotates this vector around an axis by an angle
  /// 
  /// [axis]: Rotation axis (should be normalized)
  /// [angle]: Rotation angle in radians
  /// 
  /// Returns this vector for chaining.
  DsrtVector3 rotateAroundAxis(DsrtVector3 axis, double angle) {
    // Rodrigues' rotation formula
    final cosAngle = math.cos(angle);
    final sinAngle = math.sin(angle);
    
    final dot = this.dot(axis);
    final cross = this.cross(axis);
    
    return setFrom(
      this.multiplyScalar(cosAngle)
          .add(cross.multiplyScalar(sinAngle))
          .add(axis.multiplyScalar(dot * (1.0 - cosAngle))),
    );
  }
  
  /// Checks if this vector is approximately equal to another vector
  /// 
  /// [other]: Other vector to compare with
  /// [epsilon]: Tolerance for comparison
  /// 
  /// Returns true if vectors are approximately equal.
  bool equals(DsrtVector3 other, [double? epsilon]) {
    final eps = epsilon ?? DsrtMathConstants.EPSILON_SMALL;
    return (x - other.x).abs() < eps &&
           (y - other.y).abs() < eps &&
           (z - other.z).abs() < eps;
  }
  
  /// Checks if this vector is exactly equal to another vector
  /// 
  /// [other]: Other vector to compare with
  /// 
  /// Returns true if vectors are exactly equal.
  @override
  bool operator ==(Object other) {
    return other is DsrtVector3 && x == other.x && y == other.y && z == other.z;
  }
  
  /// Gets the hash code for this vector
  @override
  int get hashCode => Object.hash(x, y, z);
  
  /// String representation of this vector
  @override
  String toString() {
    return 'DsrtVector3(${x.toStringAsFixed(6)}, ${y.toStringAsFixed(6)}, ${z.toStringAsFixed(6)})';
  }
  
  /// Adds two vectors
  DsrtVector3 operator +(DsrtVector3 other) {
    return DsrtVector3(x + other.x, y + other.y, z + other.z);
  }
  
  /// Subtracts two vectors
  DsrtVector3 operator -(DsrtVector3 other) {
    return DsrtVector3(x - other.x, y - other.y, z - other.z);
  }
  
  /// Multiplies vector by scalar
  DsrtVector3 operator *(double scalar) {
    return DsrtVector3(x * scalar, y * scalar, z * scalar);
  }
  
  /// Divides vector by scalar
  DsrtVector3 operator /(double scalar) {
    if (scalar == 0.0) {
      throw ArgumentError('Cannot divide by zero');
    }
    return DsrtVector3(x / scalar, y / scalar, z / scalar);
  }
  
  /// Negates vector
  DsrtVector3 operator -() {
    return DsrtVector3(-x, -y, -z);
  }
  
  /// Accesses vector components by index
  /// 
  /// [index]: 0 for x, 1 for y, 2 for z
  /// 
  /// Returns the component value.
  /// Throws [RangeError] if index is not 0, 1, or 2.
  double operator [](int index) {
    switch (index) {
      case 0:
        return x;
      case 1:
        return y;
      case 2:
        return z;
      default:
        throw RangeError.index(index, this, 'index', 'Index must be 0, 1, or 2');
    }
  }
  
  /// Sets vector components by index
  /// 
  /// [index]: 0 for x, 1 for y, 2 for z
  /// [value]: New value
  /// 
  /// Throws [RangeError] if index is not 0, 1, or 2.
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
      default:
        throw RangeError.index(index, this, 'index', 'Index must be 0, 1, or 2');
    }
  }
  
  /// Disposes this vector
  @override
  Future<void> dispose() async {
    // Vector doesn't hold any native resources
  }
}

/// Vector3 utilities and static functions
class DsrtVector3Utils {
  /// Creates a random unit vector
  /// 
  /// [random]: Optional Random instance
  /// 
  /// Returns a random unit vector.
  static DsrtVector3 randomUnit([math.Random? random]) {
    final rnd = random ?? math.Random();
    final phi = math.acos(2.0 * rnd.nextDouble() - 1.0);
    final theta = rnd.nextDouble() * DsrtMathConstants.TAU;
    return DsrtVector3.fromSpherical(1.0, phi, theta);
  }
  
  /// Creates a random vector within a sphere
  /// 
  /// [radius]: Sphere radius
  /// [random]: Optional Random instance
  /// 
  /// Returns a random vector within the sphere.
  static DsrtVector3 randomInSphere(double radius, [math.Random? random]) {
    final rnd = random ?? math.Random();
    final phi = math.acos(2.0 * rnd.nextDouble() - 1.0);
    final theta = rnd.nextDouble() * DsrtMathConstants.TAU;
    final r = math.pow(rnd.nextDouble(), 1.0 / 3.0) * radius;
    return DsrtVector3.fromSpherical(r, phi, theta);
  }
  
  /// Creates a random vector on a sphere surface
  /// 
  /// [radius]: Sphere radius
  /// [random]: Optional Random instance
  /// 
  /// Returns a random vector on the sphere surface.
  static DsrtVector3 randomOnSphere(double radius, [math.Random? random]) {
    final rnd = random ?? math.Random();
    final phi = math.acos(2.0 * rnd.nextDouble() - 1.0);
    final theta = rnd.nextDouble() * DsrtMathConstants.TAU;
    return DsrtVector3.fromSpherical(radius, phi, theta);
  }
  
  /// Creates a random vector within a box
  /// 
  /// [width]: Box width (x dimension)
  /// [height]: Box height (y dimension)
  /// [depth]: Box depth (z dimension)
  /// [random]: Optional Random instance
  /// 
  /// Returns a random vector within the box.
  static DsrtVector3 randomInBox(double width, double height, double depth, [math.Random? random]) {
    final rnd = random ?? math.Random();
    return DsrtVector3(
      rnd.nextDouble() * width - width * 0.5,
      rnd.nextDouble() * height - height * 0.5,
      rnd.nextDouble() * depth - depth * 0.5,
    );
  }
  
  /// Calculates the dot product of two vectors
  static double dot(DsrtVector3 a, DsrtVector3 b) {
    return a.x * b.x + a.y * b.y + a.z * b.z;
  }
  
  /// Calculates the cross product of two vectors
  static DsrtVector3 cross(DsrtVector3 a, DsrtVector3 b) {
    return DsrtVector3(
      a.y * b.z - a.z * b.y,
      a.z * b.x - a.x * b.z,
      a.x * b.y - a.y * b.x,
    );
  }
  
  /// Calculates the distance between two vectors
  static double distance(DsrtVector3 a, DsrtVector3 b) {
    return a.distanceTo(b);
  }
  
  /// Calculates the squared distance between two vectors
  static double distanceSquared(DsrtVector3 a, DsrtVector3 b) {
    return a.distanceToSquared(b);
  }
  
  /// Calculates the angle between two vectors
  static double angle(DsrtVector3 a, DsrtVector3 b) {
    return a.angleTo(b);
  }
  
  /// Linearly interpolates between two vectors
  static DsrtVector3 lerp(DsrtVector3 a, DsrtVector3 b, double t) {
    return DsrtVector3(
      a.x + (b.x - a.x) * t,
      a.y + (b.y - a.y) * t,
      a.z + (b.z - a.z) * t,
    );
  }
  
  /// Spherically interpolates between two vectors
  static DsrtVector3 slerp(DsrtVector3 a, DsrtVector3 b, double t) {
    final result = DsrtVector3();
    return result.slerp(a, b, t);
  }
  
  /// Returns the component-wise minimum of two vectors
  static DsrtVector3 min(DsrtVector3 a, DsrtVector3 b) {
    return DsrtVector3(
      math.min(a.x, b.x),
      math.min(a.y, b.y),
      math.min(a.z, b.z),
    );
  }
  
  /// Returns the component-wise maximum of two vectors
  static DsrtVector3 max(DsrtVector3 a, DsrtVector3 b) {
    return DsrtVector3(
      math.max(a.x, b.x),
      math.max(a.y, b.y),
      math.max(a.z, b.z),
    );
  }
  
  /// Returns the reflection of a vector off a surface
  /// 
  /// [vector]: Incident vector
  /// [normal]: Surface normal (should be normalized)
  /// 
  /// Returns the reflected vector.
  static DsrtVector3 reflect(DsrtVector3 vector, DsrtVector3 normal) {
    final dot = vector.dot(normal);
    return DsrtVector3(
      vector.x - 2.0 * dot * normal.x,
      vector.y - 2.0 * dot * normal.y,
      vector.z - 2.0 * dot * normal.z,
    );
  }
  
  /// Returns the projection of a vector onto another vector
  /// 
  /// [vector]: Vector to project
  /// [onto]: Vector to project onto
  /// 
  /// Returns the projected vector.
  static DsrtVector3 project(DsrtVector3 vector, DsrtVector3 onto) {
    final denominator = onto.magnitudeSquared;
    
    if (denominator == 0.0) {
      return DsrtVector3.zero;
    }
    
    final scalar = vector.dot(onto) / denominator;
    return onto * scalar;
  }
  
  /// Returns the rejection of a vector from another vector
  /// 
  /// [vector]: Vector to reject
  /// [from]: Vector to reject from
  /// 
  /// Returns the rejected vector.
  static DsrtVector3 reject(DsrtVector3 vector, DsrtVector3 from) {
    final projection = project(vector, from);
    return vector - projection;
  }
  
  /// Returns the projection of a vector onto a plane
  /// 
  /// [vector]: Vector to project
  /// [planeNormal]: Plane normal (should be normalized)
  /// 
  /// Returns the projected vector.
  static DsrtVector3 projectOnPlane(DsrtVector3 vector, DsrtVector3 planeNormal) {
    return reject(vector, planeNormal);
  }
  
  /// Rotates a vector around an axis by an angle
  /// 
  /// [vector]: Vector to rotate
  /// [axis]: Rotation axis (should be normalized)
  /// [angle]: Rotation angle in radians
  /// 
  /// Returns the rotated vector.
  static DsrtVector3 rotateAroundAxis(DsrtVector3 vector, DsrtVector3 axis, double angle) {
    final result = vector.copy();
    return result.rotateAroundAxis(axis, angle);
  }
  
  /// Calculates the triple product of three vectors
  /// 
  /// [a]: First vector
  /// [b]: Second vector
  /// [c]: Third vector
  /// 
  /// Returns the scalar triple product a · (b × c).
  static double tripleProduct(DsrtVector3 a, DsrtVector3 b, DsrtVector3 c) {
    return a.dot(b.cross(c));
  }
  
  /// Checks if three vectors are coplanar
  /// 
  /// [a]: First vector
  /// [b]: Second vector
  /// [c]: Third vector
  /// [epsilon]: Tolerance for coplanarity
  /// 
  /// Returns true if vectors are coplanar.
  static bool areCoplanar(
    DsrtVector3 a,
    DsrtVector3 b,
    DsrtVector3 c, [
    double epsilon = DsrtMathConstants.EPSILON_SMALL,
  ]) {
    final volume = tripleProduct(a, b, c).abs();
    return volume < epsilon;
  }
  
  /// Calculates the area of a triangle defined by three points
  /// 
  /// [a]: First vertex
  /// [b]: Second vertex
  /// [c]: Third vertex
  /// 
  /// Returns the triangle area.
  static double triangleArea(DsrtVector3 a, DsrtVector3 b, DsrtVector3 c) {
    final ab = b - a;
    final ac = c - a;
    final cross = ab.cross(ac);
    return cross.magnitude * 0.5;
  }
  
  /// Calculates the volume of a tetrahedron defined by four points
  /// 
  /// [a]: First vertex
  /// [b]: Second vertex
  /// [c]: Third vertex
  /// [d]: Fourth vertex
  /// 
  /// Returns the tetrahedron volume.
  static double tetrahedronVolume(
    DsrtVector3 a,
    DsrtVector3 b,
    DsrtVector3 c,
    DsrtVector3 d,
  ) {
    final ab = b - a;
    final ac = c - a;
    final ad = d - a;
    return tripleProduct(ab, ac, ad).abs() / 6.0;
  }
  
  /// Converts a list of vectors to a Float32List
  static Float32List toFloat32List(List<DsrtVector3> vectors) {
    final result = Float32List(vectors.length * 3);
    for (var i = 0; i < vectors.length; i++) {
      final vector = vectors[i];
      result[i * 3] = vector.x;
      result[i * 3 + 1] = vector.y;
      result[i * 3 + 2] = vector.z;
    }
    return result;
  }
  
  /// Creates vectors from a Float32List
  static List<DsrtVector3> fromFloat32List(Float32List data) {
    if (data.length % 3 != 0) {
      throw ArgumentError('Data length must be divisible by 3');
    }
    
    final vectors = <DsrtVector3>[];
    for (var i = 0; i < data.length; i += 3) {
      vectors.add(DsrtVector3(data[i], data[i + 1], data[i + 2]));
    }
    return vectors;
  }
  
  /// Creates an orthonormal basis from a normal vector
  /// 
  /// [normal]: Normal vector (will be normalized)
  /// 
  /// Returns a map with 'normal', 'tangent', and 'bitangent' vectors.
  static Map<String, DsrtVector3> createOrthonormalBasis(DsrtVector3 normal) {
    final n = normal.normalized;
    
    // Choose a vector not parallel to n
    DsrtVector3 tangent;
    if (n.x.abs() > 0.9) {
      tangent = DsrtVector3(0.0, 1.0, 0.0);
    } else {
      tangent = DsrtVector3(1.0, 0.0, 0.0);
    }
    
    // Make tangent orthogonal to n
    tangent = tangent.reject(n).normalized;
    
    // Calculate bitangent
    final bitangent = n.cross(tangent).normalized;
    
    return {
      'normal': n,
      'tangent': tangent,
      'bitangent': bitangent,
    };
  }
}
