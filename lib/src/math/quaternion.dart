// Copyright (c) 2024 DSRT Engine. All rights reserved.
// Use of this source code is governed by a MIT-style license that can be
// found in the LICENSE file.

/// Quaternion implementation for DSRT Engine.
library dsrt_engine.math.quaternion;

import 'dart:math' as math;
import 'math_constants.dart';
import 'vec3.dart';
import 'matrix4.dart';

/// A mutable quaternion class for 3D rotations.
/// 
/// Quaternions are represented as (x, y, z, w) where:
/// - (x, y, z) is the vector part
/// - w is the scalar part
/// 
/// Unit quaternions represent rotations in 3D space.
class Exs_Quaternion {
  double x;
  double y;
  double z;
  double w;

  /// Creates a new quaternion.
  /// Defaults to identity quaternion (0, 0, 0, 1).
  Exs_Quaternion([this.x = 0.0, this.y = 0.0, this.z = 0.0, this.w = 1.0]);

  /// Creates a quaternion from axis-angle representation.
  /// [axis] must be normalized.
  Exs_Quaternion.fromAxisAngle(Exs_Vec3 axis, double angle) {
    final halfAngle = angle * 0.5;
    final s = math.sin(halfAngle);
    x = axis.x * s;
    y = axis.y * s;
    z = axis.z * s;
    w = math.cos(halfAngle);
  }

  /// Creates a quaternion from Euler angles (in radians).
  /// Uses XYZ order (pitch, yaw, roll).
  Exs_Quaternion.fromEuler(double x, double y, double z) {
    final halfX = x * 0.5;
    final halfY = y * 0.5;
    final halfZ = z * 0.5;

    final sinX = math.sin(halfX);
    final cosX = math.cos(halfX);
    final sinY = math.sin(halfY);
    final cosY = math.cos(halfY);
    final sinZ = math.sin(halfZ);
    final cosZ = math.cos(halfZ);

    this.x = sinX * cosY * cosZ - cosX * sinY * sinZ;
    this.y = cosX * sinY * cosZ + sinX * cosY * sinZ;
    this.z = cosX * cosY * sinZ - sinX * sinY * cosZ;
    w = cosX * cosY * cosZ + sinX * sinY * sinZ;
  }

  /// Creates a copy of [other].
  Exs_Quaternion.copy(Exs_Quaternion other) : this(other.x, other.y, other.z, other.w);

  // Static getters
  static Exs_Quaternion get identity => Exs_Quaternion(0.0, 0.0, 0.0, 1.0);

  /// Gets the length (magnitude) of the quaternion.
  double get length => math.sqrt(x * x + y * y + z * z + w * w);

  /// Gets the squared length of the quaternion.
  double get lengthSquared => x * x + y * y + z * z + w * w;

  /// Checks if this is a unit quaternion (within tolerance).
  bool get isNormalized {
    final lenSq = lengthSquared;
    return (lenSq - 1.0).abs() < Exs_MathConstants.tolerance;
  }

  /// Sets the components of this quaternion.
  Exs_Quaternion setValues(double x, double y, double z, double w) {
    this.x = x;
    this.y = y;
    this.z = z;
    this.w = w;
    return this;
  }

  /// Sets this quaternion from another quaternion.
  Exs_Quaternion setFrom(Exs_Quaternion other) {
    x = other.x;
    y = other.y;
    z = other.z;
    w = other.w;
    return this;
  }

  /// Sets this quaternion from axis-angle representation.
  /// [axis] must be normalized.
  Exs_Quaternion setFromAxisAngle(Exs_Vec3 axis, double angle) {
    final halfAngle = angle * 0.5;
    final s = math.sin(halfAngle);
    x = axis.x * s;
    y = axis.y * s;
    z = axis.z * s;
    w = math.cos(halfAngle);
    return this;
  }

  /// Sets this quaternion from Euler angles (in radians).
  /// Uses XYZ order (pitch, yaw, roll).
  Exs_Quaternion setFromEuler(double x, double y, double z) {
    final halfX = x * 0.5;
    final halfY = y * 0.5;
    final halfZ = z * 0.5;

    final sinX = math.sin(halfX);
    final cosX = math.cos(halfX);
    final sinY = math.sin(halfY);
    final cosY = math.cos(halfY);
    final sinZ = math.sin(halfZ);
    final cosZ = math.cos(halfZ);

    this.x = sinX * cosY * cosZ - cosX * sinY * sinZ;
    this.y = cosX * sinY * cosZ + sinX * cosY * sinZ;
    this.z = cosX * cosY * sinZ - sinX * sinY * cosZ;
    w = cosX * cosY * cosZ + sinX * sinY * sinZ;
    return this;
  }

  /// Normalizes this quaternion.
  Exs_Quaternion normalize() {
    final len = length;
    if (len > 0.0) {
      final invLen = 1.0 / len;
      x *= invLen;
      y *= invLen;
      z *= invLen;
      w *= invLen;
    } else {
      setValues(0.0, 0.0, 0.0, 1.0);
    }
    return this;
  }

  /// Conjugates this quaternion.
  Exs_Quaternion conjugate() {
    x = -x;
    y = -y;
    z = -z;
    return this;
  }

  /// Inverts this quaternion.
  Exs_Quaternion invert() {
    final lenSq = lengthSquared;
    if (lenSq > 0.0) {
      final invLenSq = 1.0 / lenSq;
      x = -x * invLenSq;
      y = -y * invLenSq;
      z = -z * invLenSq;
      w = w * invLenSq;
    }
    return this;
  }

  /// Multiplies this quaternion by [other].
  /// Result: this = this * other
  Exs_Quaternion multiply(Exs_Quaternion other) {
    final qax = x, qay = y, qaz = z, qaw = w;
    final qbx = other.x, qby = other.y, qbz = other.z, qbw = other.w;

    x = qaw * qbx + qax * qbw + qay * qbz - qaz * qby;
    y = qaw * qby - qax * qbz + qay * qbw + qaz * qbx;
    z = qaw * qbz + qax * qby - qay * qbx + qaz * qbw;
    w = qaw * qbw - qax * qbx - qay * qby - qaz * qbz;

    return this;
  }

  /// Linearly interpolates this quaternion toward [target] by [alpha].
  /// Result is NOT normalized.
  Exs_Quaternion lerpTo(Exs_Quaternion target, double alpha) {
    x = x + (target.x - x) * alpha;
    y = y + (target.y - y) * alpha;
    z = z + (target.z - z) * alpha;
    w = w + (target.w - w) * alpha;
    return this;
  }

  /// Spherically interpolates this quaternion toward [target] by [alpha].
  Exs_Quaternion slerpTo(Exs_Quaternion target, double alpha) {
    var cosOmega = x * target.x + y * target.y + z * target.z + w * target.w;

    // If the dot product is negative, the quaternions have opposite handedness
    // and we need to invert one to take the shortest path.
    if (cosOmega < 0.0) {
      cosOmega = -cosOmega;
      target = Exs_Quaternion(-target.x, -target.y, -target.z, -target.w);
    }

    double scale0, scale1;
    if (cosOmega < 0.95) {
      // Standard slerp
      final omega = math.acos(cosOmega);
      final sinOmega = math.sin(omega);
      scale0 = math.sin((1.0 - alpha) * omega) / sinOmega;
      scale1 = math.sin(alpha * omega) / sinOmega;
    } else {
      // Linear interpolation for very close quaternions
      scale0 = 1.0 - alpha;
      scale1 = alpha;
    }

    x = scale0 * x + scale1 * target.x;
    y = scale0 * y + scale1 * target.y;
    z = scale0 * z + scale1 * target.z;
    w = scale0 * w + scale1 * target.w;

    return this;
  }

  /// Rotates this quaternion by an angle around an axis.
  Exs_Quaternion rotateByAxisAngle(Exs_Vec3 axis, double angle) {
    final q = Exs_Quaternion.fromAxisAngle(axis, angle);
    return multiply(q);
  }

  Exs_Quaternion clone() => Exs_Quaternion.copy(this);
  Exs_Quaternion normalized() => clone().normalize();
  Exs_Quaternion conjugated() => clone().conjugate();
  Exs_Quaternion inverted() => clone().invert();

  /// Returns the dot product with another quaternion.
  double dot(Exs_Quaternion other) => x * other.x + y * other.y + z * other.z + w * other.w;

  /// Rotates a vector by this quaternion.
  Exs_Vec3 rotateVector(Exs_Vec3 vector, [Exs_Vec3? out]) {
    out ??= Exs_Vec3();

    // Optimized vector rotation using quaternion multiplication
    // v' = q * v * q^-1
    final qx = x, qy = y, qz = z, qw = w;
    final vx = vector.x, vy = vector.y, vz = vector.z;

    // uv = cross(q.xyz, v)
    final uvx = qy * vz - qz * vy;
    final uvy = qz * vx - qx * vz;
    final uvz = qx * vy - qy * vx;

    // uuv = cross(q.xyz, uv)
    final uuvx = qy * uvz - qz * uvy;
    final uuvy = qz * uvx - qx * uvz;
    final uuvz = qx * uvy - qy * uvx;

    // v' = v + 2 * (uv * q.w + uuv)
    out.x = vx + 2.0 * (uvx * qw + uuvx);
    out.y = vy + 2.0 * (uvy * qw + uuvy);
    out.z = vz + 2.0 * (uvz * qw + uuvz);

    return out;
  }

  /// Sets this quaternion from a rotation matrix.
  Exs_Quaternion setFromRotationMatrix(Exs_Matrix4 matrix) {
    final m = matrix.elements;
    final m11 = m[0], m12 = m[4], m13 = m[8];
    final m21 = m[1], m22 = m[5], m23 = m[9];
    final m31 = m[2], m32 = m[6], m33 = m[10];

    final trace = m11 + m22 + m33;

    if (trace > 0) {
      final s = 0.5 / math.sqrt(trace + 1.0);
      w = 0.25 / s;
      x = (m32 - m23) * s;
      y = (m13 - m31) * s;
      z = (m21 - m12) * s;
    } else if (m11 > m22 && m11 > m33) {
      final s = 2.0 * math.sqrt(1.0 + m11 - m22 - m33);
      w = (m32 - m23) / s;
      x = 0.25 * s;
      y = (m12 + m21) / s;
      z = (m13 + m31) / s;
    } else if (m22 > m33) {
      final s = 2.0 * math.sqrt(1.0 + m22 - m11 - m33);
      w = (m13 - m31) / s;
      x = (m12 + m21) / s;
      y = 0.25 * s;
      z = (m23 + m32) / s;
    } else {
      final s = 2.0 * math.sqrt(1.0 + m33 - m11 - m22);
      w = (m21 - m12) / s;
      x = (m13 + m31) / s;
      y = (m23 + m32) / s;
      z = 0.25 * s;
    }

    return this;
  }

  /// Converts this quaternion to a rotation matrix.
  Exs_Matrix4 toMatrix4([Exs_Matrix4? out]) {
    out ??= Exs_Matrix4();
    final e = out.elements;

    final x2 = x + x, y2 = y + y, z2 = z + z;
    final xx = x * x2, xy = x * y2, xz = x * z2;
    final yy = y * y2, yz = y * z2, zz = z * z2;
    final wx = w * x2, wy = w * y2, wz = w * z2;

    e[0] = 1.0 - (yy + zz);
    e[4] = xy - wz;
    e[8] = xz + wy;
    e[12] = 0.0;

    e[1] = xy + wz;
    e[5] = 1.0 - (xx + zz);
    e[9] = yz - wx;
    e[13] = 0.0;

    e[2] = xz - wy;
    e[6] = yz + wx;
    e[10] = 1.0 - (xx + yy);
    e[14] = 0.0;

    e[3] = 0.0;
    e[7] = 0.0;
    e[11] = 0.0;
    e[15] = 1.0;

    return out;
  }

  /// Linear interpolation between [start] and [end], storing result in [out].
  static Exs_Quaternion lerp(Exs_Quaternion start, Exs_Quaternion end, double alpha, [Exs_Quaternion? out]) {
    out ??= Exs_Quaternion();
    out.x = start.x + (end.x - start.x) * alpha;
    out.y = start.y + (end.y - start.y) * alpha;
    out.z = start.z + (end.z - start.z) * alpha;
    out.w = start.w + (end.w - start.w) * alpha;
    return out;
  }

  /// Spherical interpolation between [start] and [end], storing result in [out].
  static Exs_Quaternion slerp(Exs_Quaternion start, Exs_Quaternion end, double alpha, [Exs_Quaternion? out]) {
    out ??= Exs_Quaternion();
    out.setFrom(start).slerpTo(end, alpha);
    return out;
  }

  List<double> toList() => [x, y, z, w];

  bool equals(Exs_Quaternion other, [double tolerance = Exs_MathConstants.tolerance]) {
    return (x - other.x).abs() <= tolerance &&
           (y - other.y).abs() <= tolerance &&
           (z - other.z).abs() <= tolerance &&
           (w - other.w).abs() <= tolerance;
  }

  @override
  String toString() => 'Exs_Quaternion(${x.toStringAsFixed(4)}, ${y.toStringAsFixed(4)}, ${z.toStringAsFixed(4)}, ${w.toStringAsFixed(4)})';
}
