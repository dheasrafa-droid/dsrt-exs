/// Mathematics API for DSRT Engine
/// 
/// Provides vector, matrix, quaternion, and geometric types for 3D
/// graphics and physics calculations.
/// 
/// [includeAdvanced]: Whether to include advanced mathematical functions.
/// Defaults to true.
library dsrt_engine.public.math;

// 2D Vector
export '../src/math/vector2.dart' 
    show Vector2, vec2, Vector2List;

// 3D Vector
export '../src/math/vector3.dart' 
    show Vector3, vec3, Vector3List;

// 4D Vector
export '../src/math/vector4.dart' 
    show Vector4, vec4, Vector4List;

// 3x3 Matrix
export '../src/math/matrix3.dart' 
    show Matrix3, mat3, Matrix3List;

// 4x4 Matrix
export '../src/math/matrix4.dart' 
    show Matrix4, mat4, Matrix4List;

// Quaternion
export '../src/math/quaternion.dart' 
    show Quaternion, quat, QuaternionList;

// Euler Angles
export '../src/math/euler.dart' 
    show Euler, euler, EulerOrder;

// Color Representation
export '../src/math/color.dart' 
    show Color, rgb, rgba, ColorFormat;

// Interpolation Functions
export '../src/math/interpolation.dart' 
    show Interpolation, lerp, slerp, nlerp;

// Ray Geometry
export '../src/math/ray.dart' 
    show Ray, ray;

// Plane Geometry
export '../src/math/plane.dart' 
    show Plane;

// 2D Bounding Box
export '../src/math/box2.dart' 
    show Box2, Rect;

// 3D Bounding Box
export '../src/math/box3.dart' 
    show Box3, AABB;

// Sphere Geometry
export '../src/math/sphere.dart' 
    show Sphere;

// View Frustum
export '../src/math/frustum.dart' 
    show Frustum, FrustumPlane;

// Spline Curves
export '../src/math/spline.dart' 
    show Spline, CatmullRomSpline;

// Transformation Helpers
export '../src/math/transformations.dart' 
    show Transform, Transformation;

// Mathematical Constants
export '../src/math/math_constants.dart' 
    show MathConstants, PI, TAU, EPSILON;

// Curve Functions
export '../src/math/curve.dart' 
    show Curve, BezierCurve;

// 3D Line Segment
export '../src/math/line3.dart' 
    show Line3;

// Triangle Geometry
export '../src/math/triangle.dart' 
    show Triangle;

// Capsule Geometry
export '../src/math/capsule.dart' 
    show Capsule;

// Bounding Volume Hierarchy
export '../src/math/bounding_volume.dart' 
    show BoundingVolume, BVHNode;

// Procedural Noise
export '../src/math/noise.dart' 
    show Noise, PerlinNoise, SimplexNoise;

// Random Number Generation
export '../src/math/random.dart' 
    show Random, SeededRandom;

// Spherical Coordinates
export '../src/math/spherical.dart' 
    show Spherical;

// Cylindrical Coordinates
export '../src/math/cylindrical.dart' 
    show Cylindrical;

// Polar Coordinates
export '../src/math/polar.dart' 
    show Polar;

// Cartesian Coordinates
export '../src/math/cartesian.dart' 
    show Cartesian;

// Mathematical Operations
export '../src/math/math_operations.dart' 
    show MathOperations, dot, cross, normalize;

// Math Validation
export '../src/math/math_validation.dart' 
    show MathValidation, isFiniteVector, isNormalized;

// Math Serialization
export '../src/math/math_serialization.dart' 
    show MathSerialization, VectorSerializer;
