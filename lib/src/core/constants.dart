/// DSRT Engine - Global Constants
/// Global constants used throughout the engine.
library dsrt_engine.src.core.constants;

/// DSRT Engine global constants
class DSRTConstants {
  // Engine constants
  static const String engineName = 'DSRT Engine';
  static const String engineVersion = '1.0.0-alpha';
  static const int engineBuild = 1;
  
  // Math constants
  static const double pi = 3.14159265358979323846;
  static const double twoPi = pi * 2.0;
  static const double halfPi = pi / 2.0;
  static const double degToRad = pi / 180.0;
  static const double radToDeg = 180.0 / pi;
  
  // Numerical precision
  static const double epsilon = 1e-6;
  static const double epsilonSq = epsilon * epsilon;
  static const double epsilonFloat = 1.192092896e-07;
  
  // Default values
  static const int defaultWidth = 800;
  static const int defaultHeight = 600;
  static const double targetFPS = 60.0;
  static const double maxDeltaTime = 0.1; // 100ms
  
  // Rendering constants
  static const int defaultNearPlane = 0.1;
  static const int defaultFarPlane = 1000;
  static const int defaultFOV = 60;
  
  // Color constants
  static const int black = 0xFF000000;
  static const int white = 0xFFFFFFFF;
  static const int red = 0xFFFF0000;
  static const int green = 0xFF00FF00;
  static const int blue = 0xFF0000FF;
  static const int transparent = 0x00000000;
  
  // Geometry constants
  static const int defaultGeometryDetail = 8;
  static const int maxVertices = 65535;
  static const int maxIndices = 65535;
  
  // Material constants
  static const int defaultMaterialSide = 0; // Front
  static const bool defaultMaterialTransparent = false;
  static const int defaultMaterialBlending = 1; // Normal blending
  
  // Event constants
  static const int mouseLeft = 0;
  static const int mouseMiddle = 1;
  static const int mouseRight = 2;
  
  // Input constants
  static const int keyBackspace = 8;
  static const int keyTab = 9;
  static const int keyEnter = 13;
  static const int keyShift = 16;
  static const int keyCtrl = 17;
  static const int keyAlt = 18;
  static const int keyEscape = 27;
  static const int keySpace = 32;
  static const int keyArrowLeft = 37;
  static const int keyArrowUp = 38;
  static const int keyArrowRight = 39;
  static const int keyArrowDown = 40;
  static const int keyDelete = 46;
  
  // Platform constants
  static const String platformWeb = 'web';
  static const String platformAndroid = 'android';
  static const String platformIOS = 'ios';
  static const String platformWindows = 'windows';
  static const String platformMacOS = 'macos';
  static const String platformLinux = 'linux';
  
  // Shader constants
  static const String defaultVertexShader = '''
    attribute vec3 position;
    attribute vec3 normal;
    attribute vec2 uv;
    
    uniform mat4 modelViewMatrix;
    uniform mat4 projectionMatrix;
    uniform mat3 normalMatrix;
    
    varying vec3 vNormal;
    varying vec2 vUv;
    
    void main() {
      vNormal = normalize(normalMatrix * normal);
      vUv = uv;
      gl_Position = projectionMatrix * modelViewMatrix * vec4(position, 1.0);
    }
  ''';
  
  static const String defaultFragmentShader = '''
    precision mediump float;
    
    varying vec3 vNormal;
    varying vec2 vUv;
    
    uniform vec3 color;
    
    void main() {
      vec3 normal = normalize(vNormal);
      float lighting = dot(normal, vec3(0.0, 0.0, 1.0));
      gl_FragColor = vec4(color * (0.5 + 0.5 * lighting), 1.0);
    }
  ''';
  
  // Animation constants
  static const double defaultAnimationFPS = 30.0;
  static const int defaultAnimationLoop = 0; // LoopOnce
  
  // Physics constants
  static const double defaultGravity = 9.81;
  static const int defaultPhysicsSubsteps = 1;
  
  // Audio constants
  static const double defaultAudioVolume = 1.0;
  static const double defaultAudioPitch = 1.0;
  
  // Private constructor - this is a constants class
  DSRTConstants._();
}
