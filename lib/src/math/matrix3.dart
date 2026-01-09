// Copyright (c) 2024 DSRT Engine. All rights reserved.
// Use of this source code is governed by a MIT-style license that can be
// found in the LICENSE file.

/// 3x3 Matrix implementation for DSRT Engine.
library dsrt_engine.math.matrix3;

import 'dart:math' as math;
import 'math_constants.dart';
import 'vec3.dart';

/// A mutable 3x3 matrix class for engine mathematics.
/// 
/// Stored in column-major order (compatible with WebGL/OpenGL).
/// Indices: 0 3 6
///          1 4 7
///          2 5 8
class Exs_Matrix3 {
  final Float64List _elements;

  /// Creates a new 3x3 matrix.
  Exs_Matrix3([List<double>? elements])
      : _elements = Float64List(9) {
    if (elements != null) {
      setElements(elements);
    } else {
      setIdentity();
    }
  }

  /// Creates a copy of [other].
  Exs_Matrix3.copy(Exs_Matrix3 other) : _elements = Float64List.fromList(other._elements);

  // Static getters
  static Exs_Matrix3 get identity => Exs_Matrix3()..setIdentity();
  static Exs_Matrix3 get zero => Exs_Matrix3()..setZero();

  /// Gets the element at row [row] and column [col].
  double getElement(int row, int col) => _elements[col * 3 + row];

  /// Sets the element at row [row] and column [col] to [value].
  Exs_Matrix3 setElement(int row, int col, double value) {
    _elements[col * 3 + row] = value;
    return this;
  }

  List<double> get elements => List<double>.from(_elements);

  Exs_Matrix3 setElements(List<double> elements) {
    if (elements.length != 9) {
      throw ArgumentError('Elements list must have 9 elements');
    }
    for (int i = 0; i < 9; i++) {
      _elements[i] = elements[i];
    }
    return this;
  }

  Exs_Matrix3 setIdentity() {
    _elements[0] = 1.0; _elements[3] = 0.0; _elements[6] = 0.0;
    _elements[1] = 0.0; _elements[4] = 1.0; _elements[7] = 0.0;
    _elements[2] = 0.0; _elements[5] = 0.0; _elements[8] = 1.0;
    return this;
  }

  Exs_Matrix3 setZero() {
    for (int i = 0; i < 9; i++) {
      _elements[i] = 0.0;
    }
    return this;
  }

  Exs_Matrix3 setFrom(Exs_Matrix3 other) {
    for (int i = 0; i < 9; i++) {
      _elements[i] = other._elements[i];
    }
    return this;
  }
  
  Exs_Matrix3 add(Exs_Matrix3 other) {
    for (int i = 0; i < 9; i++) {
      _elements[i] += other._elements[i];
    }
    return this;
  }

  Exs_Matrix3 subtract(Exs_Matrix3 other) {
    for (int i = 0; i < 9; i++) {
      _elements[i] -= other._elements[i];
    }
    return this;
  }

  Exs_Matrix3 scale(double scalar) {
    for (int i = 0; i < 9; i++) {
      _elements[i] *= scalar;
    }
    return this;
  }

  /// Matrix multiplication: this = this * [other].
  Exs_Matrix3 multiply(Exs_Matrix3 other) {
    final a00 = _elements[0], a01 = _elements[3], a02 = _elements[6];
    final a10 = _elements[1], a11 = _elements[4], a12 = _elements[7];
    final a20 = _elements[2], a21 = _elements[5], a22 = _elements[8];

    final b00 = other._elements[0], b01 = other._elements[3], b02 = other._elements[6];
    final b10 = other._elements[1], b11 = other._elements[4], b12 = other._elements[7];
    final b20 = other._elements[2], b21 = other._elements[5], b22 = other._elements[8];

    _elements[0] = a00 * b00 + a01 * b10 + a02 * b20;
    _elements[1] = a10 * b00 + a11 * b10 + a12 * b20;
    _elements[2] = a20 * b00 + a21 * b10 + a22 * b20;

    _elements[3] = a00 * b01 + a01 * b11 + a02 * b21;
    _elements[4] = a10 * b01 + a11 * b11 + a12 * b21;
    _elements[5] = a20 * b01 + a21 * b11 + a22 * b21;

    _elements[6] = a00 * b02 + a01 * b12 + a02 * b22;
    _elements[7] = a10 * b02 + a11 * b12 + a12 * b22;
    _elements[8] = a20 * b02 + a21 * b12 + a22 * b22;

    return this;
  }

  Exs_Matrix3 transpose() {
    final temp = _elements[1];
    _elements[1] = _elements[3];
    _elements[3] = temp;

    temp = _elements[2];
    _elements[2] = _elements[6];
    _elements[6] = temp;

    temp = _elements[5];
    _elements[5] = _elements[7];
    _elements[7] = temp;

    return this;
  }

  double get determinant {
    final a = _elements;
    return a[0] * (a[4] * a[8] - a[5] * a[7]) -
           a[3] * (a[1] * a[8] - a[2] * a[7]) +
           a[6] * (a[1] * a[5] - a[2] * a[4]);
  }

  Exs_Matrix3 setTranslation(double x, double y) {
    setIdentity();
    _elements[6] = x;
    _elements[7] = y;
    return this;
  }

  Exs_Matrix3 setRotation(double angle) {
    final c = math.cos(angle);
    final s = math.sin(angle);
    setIdentity();
    _elements[0] = c;
    _elements[1] = s;
    _elements[3] = -s;
    _elements[4] = c;
    return this;
  }

  Exs_Matrix3 setScale(double x, double y) {
    setIdentity();
    _elements[0] = x;
    _elements[4] = y;
    return this;
  }

  /// Transforms [vector] by this matrix and stores result in [out].
  Exs_Vec3 transformVector(Exs_Vec3 vector, [Exs_Vec3? out]) {
    out ??= Exs_Vec3();
    final x = vector.x;
    final y = vector.y;
    final z = vector.z;
    out.x = _elements[0] * x + _elements[3] * y + _elements[6] * z;
    out.y = _elements[1] * x + _elements[4] * y + _elements[7] * z;
    out.z = _elements[2] * x + _elements[5] * y + _elements[8] * z;
    return out;
  }

  Exs_Matrix3 clone() => Exs_Matrix3.copy(this);
  Exs_Matrix3 transposed() => clone().transpose();

  bool equals(Exs_Matrix3 other, [double tolerance = Exs_MathConstants.tolerance]) {
    for (int i = 0; i < 9; i++) {
      if ((_elements[i] - other._elements[i]).abs() > tolerance) {
        return false;
      }
    }
    return true;
  }

  @override
  String toString() {
    return 'Exs_Matrix3(\n'
           '  ${_elements[0].toStringAsFixed(4)}, ${_elements[3].toStringAsFixed(4)}, ${_elements[6].toStringAsFixed(4)},\n'
           '  ${_elements[1].toStringAsFixed(4)}, ${_elements[4].toStringAsFixed(4)}, ${_elements[7].toStringAsFixed(4)},\n'
           '  ${_elements[2].toStringAsFixed(4)}, ${_elements[5].toStringAsFixed(4)}, ${_elements[8].toStringAsFixed(4)}\n'
           ')';
  }
}
