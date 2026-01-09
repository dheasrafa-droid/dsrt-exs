/// Engine-wide constants
/// 
/// Contains mathematical constants, engine limits, and other
/// immutable values used throughout the engine.
/// 
/// @license MIT
/// @copyright (c) 2024 DSRT Engine

/// Mathematical constants
class ExsMathConstants {
  /// Pi constant (π)
  static const double pi = 3.14159265358979323846;
  
  /// Two times Pi (2π)
  static const double twoPi = 6.28318530717958647692;
  
  /// Half Pi (π/2)
  static const double halfPi = 1.57079632679489661923;
  
  /// Pi over 180 (conversion factor: degrees to radians)
  static const double degToRad = 0.01745329251994329577;
  
  /// 180 over Pi (conversion factor: radians to degrees)
  static const double radToDeg = 57.2957795130823208768;
  
  /// Square root of 2
  static const double sqrt2 = 1.41421356237309504880;
  
  /// Square root of 3
  static const double sqrt3 = 1.73205080756887729353;
  
  /// Square root of 0.5
  static const double sqrtHalf = 0.70710678118654752440;
  
  /// Euler's number (e)
  static const double e = 2.71828182845904523536;
  
  /// Natural logarithm of 2
  static const double ln2 = 0.69314718055994530942;
  
  /// Natural logarithm of 10
  static const double ln10 = 2.30258509299404568402;
}

/// Engine performance limits
class ExsEngineLimits {
  /// Maximum number of vertices in a single geometry
  static const int maxVertices = 65536;
  
  /// Maximum number of indices in a single geometry
  static const int maxIndices = 131072;
  
  /// Maximum number of bones for skinning
  static const int maxBones = 128;
  
  /// Maximum number of lights in a scene
  static const int maxLights = 16;
  
  /// Maximum texture size
  static const int maxTextureSize = 8192;
  
  /// Maximum cubemap size
  static const int maxCubeMapSize = 4096;
  
  /// Maximum render target size
  static const int maxRenderTargetSize = 4096;
  
  /// Maximum shader uniforms
  static const int maxUniforms = 256;
  
  /// Maximum shader attributes
  static const int maxAttributes = 16;
  
  /// Maximum draw calls per frame (soft limit)
  static const int maxDrawCalls = 1000;
}

/// Default engine values
class ExsDefaults {
  /// Default near plane distance
  static const double nearPlane = 0.1;
  
  /// Default far plane distance
  static const double farPlane = 1000.0;
  
  /// Default field of view (in degrees)
  static const double fieldOfView = 60.0;
  
  /// Default aspect ratio (16:9)
  static const double aspectRatio = 16.0 / 9.0;
  
  /// Default clear color (RGBA)
  static const List<double> clearColor = [0.0, 0.0, 0.0, 1.0];
  
  /// Default ambient light color
  static const List<double> ambientColor = [0.2, 0.2, 0.2];
  
  /// Default diffuse color
  static const List<double> diffuseColor = [1.0, 1.0, 1.0];
  
  /// Default specular color
  static const List<double> specularColor = [1.0, 1.0, 1.0];
  
  /// Default shininess
  static const double shininess = 30.0;
  
  /// Default opacity
  static const double opacity = 1.0;
  
  /// Default line width
  static const double lineWidth = 1.0;
  
  /// Default point size
  static const double pointSize = 1.0;
}

/// Engine precision settings
class ExsPrecision {
  /// Floating point epsilon for equality comparisons
  static const double epsilon = 1e-6;
  
  /// Larger epsilon for approximate comparisons
  static const double epsilonLarge = 1e-3;
  
  /// Smallest meaningful number
  static const double minValue = 1e-10;
  
  /// Largest meaningful number
  static const double maxValue = 1e10;
}

/// Combined constants class for public API exposure
class ExsConstants {
  /// Mathematical constants
  static const ExsMathConstants math = ExsMathConstants();
  
  /// Engine limits
  static const ExsEngineLimits limits = ExsEngineLimits();
  
  /// Default values
  static const ExsDefaults defaults = ExsDefaults();
  
  /// Precision settings
  static const ExsPrecision precision = ExsPrecision();
}
