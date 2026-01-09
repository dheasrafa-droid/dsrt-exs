// Copyright (c) 2024 DSRT Engine. All rights reserved.
// Use of this source code is governed by a MIT-style license that can be
// found in the LICENSE file.

/// 4x4 Matrix implementation for DSRT Engine.
library dsrt_engine.math.matrix4;

import 'dart:math' as math;
import 'math_constants.dart';
import 'vec3.dart';
import 'vec4.dart';

/// A mutable 4x4 matrix class for engine mathematics.
/// 
/// Stored in column-major order (compatible with WebGL/OpenGL).
/// Indices: 0  4  8  12
///          1  5  9  13
///          2  6  10 14
///          3  7  11 15
class Exs_Matrix4 {
  final Float64List _elements;

  /// Creates a new 4x4 matrix.
  Exs_Matrix4([List<double>? elements])
      : _elements = Float64List(16) {
    if (elements != null) {
      setElements(elements);
    } else {
      setIdentity();
    }
  }

  /// Creates a copy of [other].
  Exs_Matrix4.copy(Exs_Matrix4 other) : _elements = Float64List.fromList(other._elements);

  // Static getters
  static Exs_Matrix4 get identity => Exs_Matrix4()..setIdentity();
  static Exs_Matrix4 get zero => Exs_Matrix4()..setZero();

  /// Gets the element at row [row] and column [col].
  double getElement(int row, int col) => _elements[col * 4 + row];

  /// Sets the element at row [row] and column [col] to [value].
  Exs_Matrix4 setElement(int row, int col, double value) {
    _elements[col * 4 + row] = value;
    return this;
  }

  /// Returns a copy of the matrix elements as a list.
  List<double> get elements => List<double>.from(_elements);

  /// Sets all matrix elements from a list.
  Exs_Matrix4 setElements(List<double> elements) {
    if (elements.length != 16) {
      throw ArgumentError('Elements list must have 16 elements');
    }
    for (int i = 0; i < 16; i++) {
      _elements[i] = elements[i];
    }
    return this;
  }

  // ===========================================================================
  // Basic Mutations
  // ===========================================================================

  /// Sets this matrix to the identity matrix.
  Exs_Matrix4 setIdentity() {
    for (int i = 0; i < 16; i++) {
      _elements[i] = 0.0;
    }
    _elements[0] = 1.0;
    _elements[5] = 1.0;
    _elements[10] = 1.0;
    _elements[15] = 1.0;
    return this;
  }

  /// Sets all matrix elements to zero.
  Exs_Matrix4 setZero() {
    for (int i = 0; i < 16; i++) {
      _elements[i] = 0.0;
    }
    return this;
  }

  /// Sets this matrix from another matrix.
  Exs_Matrix4 setFrom(Exs_Matrix4 other) {
    for (int i = 0; i < 16; i++) {
      _elements[i] = other._elements[i];
    }
    return this;
  }

  /// Adds another matrix to this matrix.
  Exs_Matrix4 add(Exs_Matrix4 other) {
    for (int i = 0; i < 16; i++) {
      _elements[i] += other._elements[i];
    }
    return this;
  }

  /// Subtracts another matrix from this matrix.
  Exs_Matrix4 subtract(Exs_Matrix4 other) {
    for (int i = 0; i < 16; i++) {
      _elements[i] -= other._elements[i];
    }
    return this;
  }

  /// Scales this matrix by a scalar.
  Exs_Matrix4 scale(double scalar) {
    for (int i = 0; i < 16; i++) {
      _elements[i] *= scalar;
    }
    return this;
  }

  /// Matrix multiplication: this = this * [other].
  Exs_Matrix4 multiply(Exs_Matrix4 other) {
    final a00 = _elements[0], a01 = _elements[4], a02 = _elements[8], a03 = _elements[12];
    final a10 = _elements[1], a11 = _elements[5], a12 = _elements[9], a13 = _elements[13];
    final a20 = _elements[2], a21 = _elements[6], a22 = _elements[10], a23 = _elements[14];
    final a30 = _elements[3], a31 = _elements[7], a32 = _elements[11], a33 = _elements[15];

    final b00 = other._elements[0], b01 = other._elements[4], b02 = other._elements[8], b03 = other._elements[12];
    final b10 = other._elements[1], b11 = other._elements[5], b12 = other._elements[9], b13 = other._elements[13];
    final b20 = other._elements[2], b21 = other._elements[6], b22 = other._elements[10], b23 = other._elements[14];
    final b30 = other._elements[3], b31 = other._elements[7], b32 = other._elements[11], b33 = other._elements[15];

    _elements[0] = a00 * b00 + a01 * b10 + a02 * b20 + a03 * b30;
    _elements[1] = a10 * b00 + a11 * b10 + a12 * b20 + a13 * b30;
    _elements[2] = a20 * b00 + a21 * b10 + a22 * b20 + a23 * b30;
    _elements[3] = a30 * b00 + a31 * b10 + a32 * b20 + a33 * b30;

    _elements[4] = a00 * b01 + a01 * b11 + a02 * b21 + a03 * b31;
    _elements[5] = a10 * b01 + a11 * b11 + a12 * b21 + a13 * b31;
    _elements[6] = a20 * b01 + a21 * b11 + a22 * b21 + a23 * b31;
    _elements[7] = a30 * b01 + a31 * b11 + a32 * b21 + a33 * b31;

    _elements[8] = a00 * b02 + a01 * b12 + a02 * b22 + a03 * b32;
    _elements[9] = a10 * b02 + a11 * b12 + a12 * b22 + a13 * b32;
    _elements[10] = a20 * b02 + a21 * b12 + a22 * b22 + a23 * b32;
    _elements[11] = a30 * b02 + a31 * b12 + a32 * b22 + a33 * b32;

    _elements[12] = a00 * b03 + a01 * b13 + a02 * b23 + a03 * b33;
    _elements[13] = a10 * b03 + a11 * b13 + a12 * b23 + a13 * b33;
    _elements[14] = a20 * b03 + a21 * b13 + a22 * b23 + a23 * b33;
    _elements[15] = a30 * b03 + a31 * b13 + a32 * b23 + a33 * b33;

    return this;
  }

  /// Transposes this matrix in-place.
  Exs_Matrix4 transpose() {
    _swap(1, 4);
    _swap(2, 8);
    _swap(3, 12);
    _swap(6, 9);
    _swap(7, 13);
    _swap(11, 14);
    return this;
  }

  /// Helper method to swap two elements.
  void _swap(int i, int j) {
    final temp = _elements[i];
    _elements[i] = _elements[j];
    _elements[j] = temp;
  }

  /// Computes the determinant of this matrix.
  double get determinant {
    final n11 = _elements[0], n12 = _elements[4], n13 = _elements[8], n14 = _elements[12];
    final n21 = _elements[1], n22 = _elements[5], n23 = _elements[9], n24 = _elements[13];
    final n31 = _elements[2], n32 = _elements[6], n33 = _elements[10], n34 = _elements[14];
    final n41 = _elements[3], n42 = _elements[7], n43 = _elements[11], n44 = _elements[15];

    return (
        n41 * (
          + n14 * n23 * n32
          - n13 * n24 * n32
          - n14 * n22 * n33
          + n12 * n24 * n33
          + n13 * n22 * n34
          - n12 * n23 * n34
        ) +
        n42 * (
          + n11 * n23 * n34
          - n11 * n24 * n33
          + n14 * n21 * n33
          - n13 * n21 * n34
          + n13 * n24 * n31
          - n14 * n23 * n31
        ) +
        n43 * (
          + n11 * n24 * n32
          - n11 * n22 * n34
          - n14 * n21 * n32
          + n12 * n21 * n34
          + n14 * n22 * n31
          - n12 * n24 * n31
        ) +
        n44 * (
          - n13 * n22 * n31
          - n11 * n23 * n32
          + n11 * n22 * n33
          + n13 * n21 * n32
          - n12 * n21 * n33
          + n12 * n23 * n31
        )
    );
  }

  /// Inverts this matrix in-place.
  /// Throws [ArgumentError] if the matrix is not invertible.
  Exs_Matrix4 invert() {
    final det = determinant;
    if (det.abs() < Exs_MathConstants.epsilon) {
      throw ArgumentError('Matrix is not invertible');
    }

    final invDet = 1.0 / det;
    final n11 = _elements[0], n12 = _elements[4], n13 = _elements[8], n14 = _elements[12];
    final n21 = _elements[1], n22 = _elements[5], n23 = _elements[9], n24 = _elements[13];
    final n31 = _elements[2], n32 = _elements[6], n33 = _elements[10], n34 = _elements[14];
    final n41 = _elements[3], n42 = _elements[7], n43 = _elements[11], n44 = _elements[15];

    _elements[0] = invDet * (
      + n23 * n34 * n42 - n24 * n33 * n42
      + n24 * n32 * n43 - n22 * n34 * n43
      - n23 * n32 * n44 + n22 * n33 * n44
    );
    _elements[1] = invDet * (
      + n14 * n33 * n42 - n13 * n34 * n42
      - n14 * n32 * n43 + n12 * n34 * n43
      + n13 * n32 * n44 - n12 * n33 * n44
    );
    _elements[2] = invDet * (
      + n13 * n24 * n42 - n14 * n23 * n42
      + n14 * n22 * n43 - n12 * n24 * n43
      - n13 * n22 * n44 + n12 * n23 * n44
    );
    _elements[3] = invDet * (
      + n14 * n23 * n32 - n13 * n24 * n32
      - n14 * n22 * n33 + n12 * n24 * n33
      + n13 * n22 * n34 - n12 * n23 * n34
    );

    _elements[4] = invDet * (
      + n24 * n33 * n41 - n23 * n34 * n41
      - n24 * n31 * n43 + n21 * n34 * n43
      + n23 * n31 * n44 - n21 * n33 * n44
    );
    _elements[5] = invDet * (
      + n13 * n34 * n41 - n14 * n33 * n41
      + n14 * n31 * n43 - n11 * n34 * n43
      - n13 * n31 * n44 + n11 * n33 * n44
    );
    _elements[6] = invDet * (
      + n14 * n23 * n41 - n13 * n24 * n41
      - n14 * n21 * n43 + n11 * n24 * n43
      + n13 * n21 * n44 - n11 * n23 * n44
    );
    _elements[7] = invDet * (
      + n13 * n24 * n31 - n14 * n23 * n31
      + n14 * n21 * n33 - n11 * n24 * n33
      - n13 * n21 * n34 + n11 * n23 * n34
    );

    _elements[8] = invDet * (
      + n22 * n34 * n41 - n24 * n32 * n41
      + n24 * n31 * n42 - n21 * n34 * n42
      - n22 * n31 * n44 + n21 * n32 * n44
    );
    _elements[9] = invDet * (
      + n14 * n32 * n41 - n12 * n34 * n41
      - n14 * n31 * n42 + n11 * n34 * n42
      + n12 * n31 * n44 - n11 * n32 * n44
    );
    _elements[10] = invDet * (
      + n12 * n24 * n41 - n14 * n22 * n41
      + n14 * n21 * n42 - n11 * n24 * n42
      - n12 * n21 * n44 + n11 * n22 * n44
    );
    _elements[11] = invDet * (
      + n14 * n22 * n31 - n12 * n24 * n31
      - n14 * n21 * n32 + n11 * n24 * n32
      + n12 * n21 * n34 - n11 * n22 * n34
    );

    _elements[12] = invDet * (
      + n23 * n32 * n41 - n22 * n33 * n41
      - n23 * n31 * n42 + n21 * n33 * n42
      + n22 * n31 * n43 - n21 * n32 * n43
    );
    _elements[13] = invDet * (
      + n12 * n33 * n41 - n13 * n32 * n41
      + n13 * n31 * n42 - n11 * n33 * n42
      - n12 * n31 * n43 + n11 * n32 * n43
    );
    _elements[14] = invDet * (
      + n13 * n22 * n41 - n12 * n23 * n41
      - n13 * n21 * n42 + n11 * n23 * n42
      + n12 * n21 * n43 - n11 * n22 * n43
    );
    _elements[15] = invDet * (
      + n12 * n23 * n31 - n13 * n22 * n31
      + n13 * n21 * n32 - n11 * n23 * n32
      - n12 * n21 * n33 + n11 * n22 * n33
    );

    return this;
  }

  /// Sets this matrix to a translation matrix.
  Exs_Matrix4 setTranslation(double x, double y, double z) {
    setIdentity();
    _elements[12] = x;
    _elements[13] = y;
    _elements[14] = z;
    return this;
  }

  /// Sets this matrix to a scaling matrix.
  Exs_Matrix4 setScale(double x, double y, double z) {
    setIdentity();
    _elements[0] = x;
    _elements[5] = y;
    _elements[10] = z;
    return this;
  }

  /// Sets this matrix to a rotation matrix around the X axis.
  Exs_Matrix4 setRotationX(double angle) {
    final c = math.cos(angle);
    final s = math.sin(angle);
    setIdentity();
    _elements[5] = c;
    _elements[6] = s;
    _elements[9] = -s;
    _elements[10] = c;
    return this;
  }

  /// Sets this matrix to a rotation matrix around the Y axis.
  Exs_Matrix4 setRotationY(double angle) {
    final c = math.cos(angle);
    final s = math.sin(angle);
    setIdentity();
    _elements[0] = c;
    _elements[2] = -s;
    _elements[8] = s;
    _elements[10] = c;
    return this;
  }

  /// Sets this matrix to a rotation matrix around the Z axis.
  Exs_Matrix4 setRotationZ(double angle) {
    final c = math.cos(angle);
    final s = math.sin(angle);
    setIdentity();
    _elements[0] = c;
    _elements[1] = s;
    _elements[4] = -s;
    _elements[5] = c;
    return this;
  }

  /// Sets this matrix to an orthographic projection matrix.
  Exs_Matrix4 setOrthographic(double left, double right, double bottom, double top, double near, double far) {
    final xRange = right - left;
    final yRange = top - bottom;
    final zRange = far - near;

    if (xRange == 0.0 || yRange == 0.0 || zRange == 0.0) {
      throw ArgumentError('Invalid orthographic projection parameters');
    }

    setIdentity();
    _elements[0] = 2.0 / xRange;
    _elements[5] = 2.0 / yRange;
    _elements[10] = -2.0 / zRange;
    _elements[12] = -(right + left) / xRange;
    _elements[13] = -(top + bottom) / yRange;
    _elements[14] = -(far + near) / zRange;
    return this;
  }

  /// Sets this matrix to a perspective projection matrix.
  Exs_Matrix4 setPerspective(double fovY, double aspect, double near, double far) {
    final height = 1.0 / math.tan(fovY * 0.5);
    final width = height / aspect;
    final range = near - far;

    if (range == 0.0 || aspect == 0.0) {
      throw ArgumentError('Invalid perspective projection parameters');
    }

    setZero();
    _elements[0] = width;
    _elements[5] = height;
    _elements[10] = (far + near) / range;
    _elements[11] = -1.0;
    _elements[14] = (2.0 * far * near) / range;
    return this;
  }

  /// Transforms a 3D vector by this matrix (3x3 rotation/scale only).
  Exs_Vec3 transformVector3(Exs_Vec3 vector, [Exs_Vec3? out]) {
    out ??= Exs_Vec3();
    final x = vector.x;
    final y = vector.y;
    final z = vector.z;
    out.x = _elements[0] * x + _elements[4] * y + _elements[8] * z;
    out.y = _elements[1] * x + _elements[5] * y + _elements[9] * z;
    out.z = _elements[2] * x + _elements[6] * y + _elements[10] * z;
    return out;
  }

  /// Transforms a 3D point by this matrix (including translation).
  Exs_Vec3 transformPoint3(Exs_Vec3 point, [Exs_Vec3? out]) {
    out ??= Exs_Vec3();
    final x = point.x;
    final y = point.y;
    final z = point.z;
    out.x = _elements[0] * x + _elements[4] * y + _elements[8] * z + _elements[12];
    out.y = _elements[1] * x + _elements[5] * y + _elements[9] * z + _elements[13];
    out.z = _elements[2] * x + _elements[6] * y + _elements[10] * z + _elements[14];
    return out;
  }

  /// Transforms a 4D vector by this matrix.
  Exs_Vec4 transformVector4(Exs_Vec4 vector, [Exs_Vec4? out]) {
    out ??= Exs_Vec4();
    final x = vector.x;
    final y = vector.y;
    final z = vector.z;
    final w = vector.w;
    out.x = _elements[0] * x + _elements[4] * y + _elements[8] * z + _elements[12] * w;
    out.y = _elements[1] * x + _elements[5] * y + _elements[9] * z + _elements[13] * w;
    out.z = _elements[2] * x + _elements[6] * y + _elements[10] * z + _elements[14] * w;
    out.w = _elements[3] * x + _elements[7] * y + _elements[11] * z + _elements[15] * w;
    return out;
  }

  Exs_Matrix4 clone() => Exs_Matrix4.copy(this);
  Exs_Matrix4 transposed() => clone().transpose();
  Exs_Matrix4 inverted() => clone().invert();

  bool equals(Exs_Matrix4 other, [double tolerance = Exs_MathConstants.tolerance]) {
    for (int i = 0; i < 16; i++) {
      if ((_elements[i] - other._elements[i]).abs() > tolerance) {
        return false;
      }
    }
    return true;
  }

  @override
  String toString() {
    return 'Exs_Matrix4(\n'
           '  ${_elements[0].toStringAsFixed(4)}, ${_elements[4].toStringAsFixed(4)}, ${_elements[8].toStringAsFixed(4)}, ${_elements[12].toStringAsFixed(4)},\n'
           '  ${_elements[1].toStringAsFixed(4)}, ${_elements[5].toStringAsFixed(4)}, ${_elements[9].toStringAsFixed(4)}, ${_elements[13].toStringAsFixed(4)},\n'
           '  ${_elements[2].toStringAsFixed(4)}, ${_elements[6].toStringAsFixed(4)}, ${_elements[10].toStringAsFixed(4)}, ${_elements[14].toStringAsFixed(4)},\n'
           '  ${_elements[3].toStringAsFixed(4)}, ${_elements[7].toStringAsFixed(4)}, ${_elements[11].toStringAsFixed(4)}, ${_elements[15].toStringAsFixed(4)}\n'
           ')';
  }
}
