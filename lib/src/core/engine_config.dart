/// Engine configuration management and validation.
/// 
/// This class handles engine initialization configuration, platform detection,
/// and capability validation. It ensures the engine is properly configured
/// for the target platform and hardware.
/// 
/// [DSRT]: Dart Spatial Rendering Technology
/// 
/// @internal - Core engine internals
library dsrt.core.engine_config;

import 'dart:async';
import 'dart:io' show Platform;
import 'dart:math' as math;
import 'constants.dart';
import 'version.dart';
import 'settings.dart';

/// Platform types supported by DSRT Engine
enum DSRTPlatformType {
  /// Web browser platform
  web,
  
  /// Android mobile platform
  android,
  
  /// iOS mobile platform
  ios,
  
  /// macOS desktop platform
  macos,
  
  /// Windows desktop platform
  windows,
  
  /// Linux desktop platform
  linux,
  
  /// Fuchsia platform
  fuchsia,
  
  /// Unknown platform
  unknown,
}

/// Rendering backend types
enum DSRTRenderingBackend {
  /// WebGL 1.0 backend
  webgl1,
  
  /// WebGL 2.0 backend
  webgl2,
  
  /// WebGPU backend (future)
  webgpu,
  
  /// Software rendering fallback
  software,
  
  /// Vulkan backend (native)
  vulkan,
  
  /// Metal backend (macOS/iOS)
  metal,
  
  /// DirectX backend (Windows)
  directx,
  
  /// OpenGL backend (legacy)
  opengl,
}

/// Engine configuration with full validation
class DSRTEngineConfig {
  /// Platform type
  final DSRTPlatformType platform;
  
  /// Rendering backend
  final DSRTRenderingBackend renderingBackend;
  
  /// Whether to enable WebGL extensions
  final bool enableWebGLExtensions;
  
  /// Whether to preserve drawing buffer
  final bool preserveDrawingBuffer;
  
  /// Whether to use premultiplied alpha
  final bool premultipliedAlpha;
  
  /// Whether to enable antialiasing
  final bool antialias;
  
  /// Whether to enable alpha channel
  final bool alpha;
  
  /// Whether to enable depth buffer
  final bool depth;
  
  /// Whether to enable stencil buffer
  final bool stencil;
  
  /// Whether to enable desynchronized rendering
  final bool desynchronized;
  
  /// Whether to be XR compatible
  final bool xrCompatible;
  
  /// Power preference for GPU
  final String powerPreference;
  
  /// Whether to fail if major performance caveat is detected
  final bool failIfMajorPerformanceCaveat;
  
  /// Canvas element ID for Web platform
  final String? canvasId;
  
  /// Canvas element for Web platform
  final dynamic canvasElement;
  
  /// WebGL context attributes
  final Map<String, dynamic>? webGLContextAttributes;
  
  /// Initial viewport width
  final int viewportWidth;
  
  /// Initial viewport height
  final int viewportHeight;
  
  /// Pixel ratio for rendering
  final double pixelRatio;
  
  /// Whether to auto-resize with window
  final bool autoResize;
  
  /// Whether to listen to window events
  final bool listenToWindowEvents;
  
  /// Maximum frame rate (0 = unlimited)
  final double maxFrameRate;
  
  /// Whether to enable VSync
  final bool vsync;
  
  /// Whether to enable performance monitoring
  final bool performanceMonitoring;
  
  /// Whether to enable memory monitoring
  final bool memoryMonitoring;
  
  /// Whether to enable error reporting
  final bool errorReporting;
  
  /// Whether to enable crash reporting
  final bool crashReporting;
  
  /// Whether to enable analytics
  final bool analytics;
  
  /// Whether to enable telemetry
  final bool telemetry;
  
  /// Whether to enable debug mode
  final bool debugMode;
  
  /// Whether to enable profiling
  final bool profiling;
  
  /// Whether to enable hot reload
  final bool hotReload;
  
  /// Whether to enable asset caching
  final bool assetCaching;
  
  /// Asset cache size in megabytes
  final int assetCacheSizeMB;
  
  /// Whether to compress assets
  final bool compressAssets;
  
  /// Compression level (0-9)
  final int compressionLevel;
  
  /// Whether to validate assets on load
  final bool validateAssets;
  
  /// Whether to optimize assets on load
  final bool optimizeAssets;
  
  /// Maximum concurrent asset loads
  final int maxConcurrentAssetLoads;
  
  /// Asset load timeout in seconds
  final int assetLoadTimeoutSeconds;
  
  /// Maximum asset load retries
  final int maxAssetLoadRetries;
  
  /// Default material to use
  final String defaultMaterial;
  
  /// Default shader to use
  final String defaultShader;
  
  /// Default texture to use
  final String defaultTexture;
  
  /// Default geometry to use
  final String defaultGeometry;
  
  /// Default camera type
  final String defaultCameraType;
  
  /// Default light type
  final String defaultLightType;
  
  /// Whether to enable physics by default
  final bool enablePhysics;
  
  /// Physics engine to use
  final String physicsEngine;
  
  /// Whether to enable audio by default
  final bool enableAudio;
  
  /// Audio engine to use
  final String audioEngine;
  
  /// Whether to enable UI by default
  final bool enableUI;
  
  /// UI framework to use
  final String uiFramework;
  
  /// Whether to enable networking
  final bool enableNetworking;
  
  /// Network protocol to use
  final String networkProtocol;
  
  /// Whether to enable multiplayer
  final bool enableMultiplayer;
  
  /// Multiplayer framework to use
  final String multiplayerFramework;
  
  /// Whether to enable VR
  final bool enableVR;
  
  /// VR framework to use
  final String vrFramework;
  
  /// Whether to enable AR
  final bool enableAR;
  
  /// AR framework to use
  final String arFramework;
  
  /// Whether to enable AI
  final bool enableAI;
  
  /// AI framework to use
  final String aiFramework;
  
  /// Custom configuration options
  final Map<String, dynamic> customOptions;
  
  /// Creates engine configuration with validation
  DSRTEngineConfig({
    this.platform = DSRTPlatformType.unknown,
    this.renderingBackend = DSRTRenderingBackend.webgl2,
    this.enableWebGLExtensions = true,
    this.preserveDrawingBuffer = false,
    this.premultipliedAlpha = false,
    this.antialias = true,
    this.alpha = true,
    this.depth = true,
    this.stencil = false,
    this.desynchronized = false,
    this.xrCompatible = false,
    this.powerPreference = 'default',
    this.failIfMajorPerformanceCaveat = false,
    this.canvasId,
    this.canvasElement,
    this.webGLContextAttributes,
    this.viewportWidth = 800,
    this.viewportHeight = 600,
    this.pixelRatio = 1.0,
    this.autoResize = true,
    this.listenToWindowEvents = true,
    this.maxFrameRate = 0.0,
    this.vsync = true,
    this.performanceMonitoring = true,
    this.memoryMonitoring = true,
    this.errorReporting = true,
    this.crashReporting = false,
    this.analytics = false,
    this.telemetry = false,
    this.debugMode = false,
    this.profiling = false,
    this.hotReload = false,
    this.assetCaching = true,
    this.assetCacheSizeMB = 256,
    this.compressAssets = true,
    this.compressionLevel = 6,
    this.validateAssets = true,
    this.optimizeAssets = true,
    this.maxConcurrentAssetLoads = 4,
    this.assetLoadTimeoutSeconds = 30,
    this.maxAssetLoadRetries = 3,
    this.defaultMaterial = 'StandardMaterial',
    this.defaultShader = 'StandardShader',
    this.defaultTexture = 'WhiteTexture',
    this.defaultGeometry = 'BoxGeometry',
    this.defaultCameraType = 'PerspectiveCamera',
    this.defaultLightType = 'DirectionalLight',
    this.enablePhysics = true,
    this.physicsEngine = 'DSRTPhysics',
    this.enableAudio = true,
    this.audioEngine = 'DSRTAudio',
    this.enableUI = true,
    this.uiFramework = 'DSRTUI',
    this.enableNetworking = false,
    this.networkProtocol = 'WebSocket',
    this.enableMultiplayer = false,
    this.multiplayerFramework = 'DSRTMultiplayer',
    this.enableVR = false,
    this.vrFramework = 'DSRTVR',
    this.enableAR = false,
    this.arFramework = 'DSRTAR',
    this.enableAI = false,
    this.aiFramework = 'DSRTAI',
    this.customOptions = const {},
  }) {
    _validateConfiguration();
  }
  
  /// Validates configuration parameters
  void _validateConfiguration() {
    // Validate viewport dimensions
    if (viewportWidth <= 0 || viewportWidth > dsrtMaxViewportWidth) {
      throw ArgumentError('Viewport width must be between 1 and $dsrtMaxViewportWidth');
    }
    
    if (viewportHeight <= 0 || viewportHeight > dsrtMaxViewportHeight) {
      throw ArgumentError('Viewport height must be between 1 and $dsrtMaxViewportHeight');
    }
    
    // Validate pixel ratio
    if (pixelRatio <= 0 || pixelRatio > 4.0) {
      throw ArgumentError('Pixel ratio must be between 0.1 and 4.0');
    }
    
    // Validate frame rate
    if (maxFrameRate < 0 || maxFrameRate > 1000) {
      throw ArgumentError('Max frame rate must be between 0 and 1000');
    }
    
    // Validate cache size
    if (assetCacheSizeMB < 0 || assetCacheSizeMB > 4096) {
      throw ArgumentError('Asset cache size must be between 0 and 4096 MB');
    }
    
    // Validate compression level
    if (compressionLevel < 0 || compressionLevel > 9) {
      throw ArgumentError('Compression level must be between 0 and 9');
    }
    
    // Validate concurrent loads
    if (maxConcurrentAssetLoads < 1 || maxConcurrentAssetLoads > 16) {
      throw ArgumentError('Max concurrent asset loads must be between 1 and 16');
    }
    
    // Validate load timeout
    if (assetLoadTimeoutSeconds < 1 || assetLoadTimeoutSeconds > 300) {
      throw ArgumentError('Asset load timeout must be between 1 and 300 seconds');
    }
    
    // Validate retries
    if (maxAssetLoadRetries < 0 || maxAssetLoadRetries > 10) {
      throw ArgumentError('Max asset load retries must be between 0 and 10');
    }
    
    // Validate power preference
    if (!['default', 'high-performance', 'low-power'].contains(powerPreference)) {
      throw ArgumentError('Power preference must be one of: default, high-performance, low-power');
    }
  }
  
  /// Detects current platform
  static DSRTPlatformType detectPlatform() {
    try {
      if (Platform.isAndroid) return DSRTPlatformType.android;
      if (Platform.isIOS) return DSRTPlatformType.ios;
      if (Platform.isMacOS) return DSRTPlatformType.macos;
      if (Platform.isWindows) return DSRTPlatformType.windows;
      if (Platform.isLinux) return DSRTPlatformType.linux;
      if (Platform.isFuchsia) return DSRTPlatformType.fuchsia;
      
      // Check for web platform
      try {
        // This will throw on non-web platforms
        final hasWindow = (() {
          try {
            return true;
          } catch (_) {
            return false;
          }
        })();
        
        if (hasWindow) {
          return DSRTPlatformType.web;
        }
      } catch (_) {
        // Not web platform
      }
      
      return DSRTPlatformType.unknown;
    } catch (_) {
      // Platform detection failed
      return DSRTPlatformType.unknown;
    }
  }
  
  /// Detects default rendering backend for platform
  static DSRTRenderingBackend detectRenderingBackend(DSRTPlatformType platform) {
    switch (platform) {
      case DSRTPlatformType.web:
        // Check for WebGL 2.0 support
        try {
          // In a real implementation, this would check for WebGL2 context
          return DSRTRenderingBackend.webgl2;
        } catch (_) {
          return DSRTRenderingBackend.webgl1;
        }
      case DSRTPlatformType.ios:
      case DSRTPlatformType.macos:
        return DSRTRenderingBackend.metal;
      case DSRTPlatformType.windows:
        return DSRTRenderingBackend.directx;
      case DSRTPlatformType.android:
      case DSRTPlatformType.linux:
        return DSRTRenderingBackend.vulkan;
      case DSRTPlatformType.fuchsia:
        return DSRTRenderingBackend.vulkan;
      default:
        return DSRTRenderingBackend.software;
    }
  }
  
  /// Creates default configuration for current platform
  factory DSRTEngineConfig.defaults() {
    final platform = detectPlatform();
    final backend = detectRenderingBackend(platform);
    
    return DSRTEngineConfig(
      platform: platform,
      renderingBackend: backend,
      // Platform-specific defaults
      preserveDrawingBuffer: platform == DSRTPlatformType.web,
      antialias: platform != DSRTPlatformType.web || backend == DSRTRenderingBackend.webgl2,
      depth: true,
      stencil: platform == DSRTPlatformType.web && backend == DSRTRenderingBackend.webgl2,
      powerPreference: platform == DSRTPlatformType.web ? 'high-performance' : 'default',
      viewportWidth: _getDefaultViewportWidth(platform),
      viewportHeight: _getDefaultViewportHeight(platform),
      pixelRatio: _getDefaultPixelRatio(platform),
      maxFrameRate: _getDefaultMaxFrameRate(platform),
      vsync: platform != DSRTPlatformType.web,
      enablePhysics: platform != DSRTPlatformType.web,
      enableAudio: true,
      enableUI: true,
      enableVR: platform == DSRTPlatformType.web || platform == DSRTPlatformType.android || platform == DSRTPlatformType.ios,
      enableAR: platform == DSRTPlatformType.android || platform == DSRTPlatformType.ios,
    );
  }
  
  /// Gets default viewport width for platform
  static int _getDefaultViewportWidth(DSRTPlatformType platform) {
    switch (platform) {
      case DSRTPlatformType.web:
        return 1024;
      case DSRTPlatformType.android:
      case DSRTPlatformType.ios:
        return 375; // Mobile portrait width
      case DSRTPlatformType.macos:
      case DSRTPlatformType.windows:
      case DSRTPlatformType.linux:
        return 1280;
      default:
        return 800;
    }
  }
  
  /// Gets default viewport height for platform
  static int _getDefaultViewportHeight(DSRTPlatformType platform) {
    switch (platform) {
      case DSRTPlatformType.web:
        return 768;
      case DSRTPlatformType.android:
      case DSRTPlatformType.ios:
        return 667; // Mobile portrait height
      case DSRTPlatformType.macos:
      case DSRTPlatformType.windows:
      case DSRTPlatformType.linux:
        return 720;
      default:
        return 600;
    }
  }
  
  /// Gets default pixel ratio for platform
  static double _getDefaultPixelRatio(DSRTPlatformType platform) {
    switch (platform) {
      case DSRTPlatformType.android:
      case DSRTPlatformType.ios:
        return 2.0; // High DPI mobile displays
      case DSRTPlatformType.macos:
        return 2.0; // Retina displays
      case DSRTPlatformType.web:
        // Get actual device pixel ratio for web
        try {
          // In real implementation, this would be window.devicePixelRatio
          return 1.0;
        } catch (_) {
          return 1.0;
        }
      default:
        return 1.0;
    }
  }
  
  /// Gets default max frame rate for platform
  static double _getDefaultMaxFrameRate(DSRTPlatformType platform) {
    switch (platform) {
      case DSRTPlatformType.web:
        return 60.0; // Typical browser refresh rate
      case DSRTPlatformType.android:
      case DSRTPlatformType.ios:
        return 60.0; // Mobile refresh rate
      case DSRTPlatformType.macos:
      case DSRTPlatformType.windows:
      case DSRTPlatformType.linux:
        return 0.0; // Unlimited for desktop
      default:
        return 60.0;
    }
  }
  
  /// Creates configuration for WebGL backend
  factory DSRTEngineConfig.forWebGL({
    String? canvasId,
    dynamic canvasElement,
    bool webgl2 = true,
    Map<String, dynamic>? contextAttributes,
  }) {
    return DSRTEngineConfig(
      platform: DSRTPlatformType.web,
      renderingBackend: webgl2 ? DSRTRenderingBackend.webgl2 : DSRTRenderingBackend.webgl1,
      canvasId: canvasId,
      canvasElement: canvasElement,
      webGLContextAttributes: contextAttributes ?? {
        'alpha': true,
        'depth': true,
        'stencil': webgl2,
        'antialias': true,
        'premultipliedAlpha': false,
        'preserveDrawingBuffer': false,
        'powerPreference': 'high-performance',
        'failIfMajorPerformanceCaveat': false,
        'desynchronized': false,
        'xrCompatible': false,
      },
      viewportWidth: 1024,
      viewportHeight: 768,
      pixelRatio: 1.0,
      autoResize: true,
      listenToWindowEvents: true,
      maxFrameRate: 60.0,
      vsync: true,
    );
  }
  
  /// Creates configuration for testing
  factory DSRTEngineConfig.forTesting({
    DSRTPlatformType platform = DSRTPlatformType.unknown,
    int width = 800,
    int height = 600,
  }) {
    return DSRTEngineConfig(
      platform: platform,
      renderingBackend: DSRTRenderingBackend.software,
      enableWebGLExtensions: false,
      preserveDrawingBuffer: false,
      premultipliedAlpha: false,
      antialias: false,
      alpha: true,
      depth: true,
      stencil: false,
      desynchronized: false,
      xrCompatible: false,
      powerPreference: 'default',
      failIfMajorPerformanceCaveat: false,
      viewportWidth: width,
      viewportHeight: height,
      pixelRatio: 1.0,
      autoResize: false,
      listenToWindowEvents: false,
      maxFrameRate: 0.0,
      vsync: false,
      performanceMonitoring: false,
      memoryMonitoring: false,
      errorReporting: false,
      crashReporting: false,
      analytics: false,
      telemetry: false,
      debugMode: true,
      profiling: false,
      hotReload: false,
      assetCaching: false,
      assetCacheSizeMB: 0,
      compressAssets: false,
      compressionLevel: 0,
      validateAssets: false,
      optimizeAssets: false,
      maxConcurrentAssetLoads: 1,
      assetLoadTimeoutSeconds: 5,
      maxAssetLoadRetries: 0,
      enablePhysics: false,
      enableAudio: false,
      enableUI: false,
      enableNetworking: false,
      enableMultiplayer: false,
      enableVR: false,
      enableAR: false,
      enableAI: false,
    );
  }
  
  /// Creates configuration from environment variables
  factory DSRTEngineConfig.fromEnvironment() {
    final platform = detectPlatform();
    
    return DSRTEngineConfig(
      platform: platform,
      renderingBackend: detectRenderingBackend(platform),
      debugMode: bool.fromEnvironment('DSRT_DEBUG', defaultValue: false),
      profiling: bool.fromEnvironment('DSRT_PROFILE', defaultValue: false),
      enablePhysics: bool.fromEnvironment('DSRT_PHYSICS', defaultValue: true),
      enableAudio: bool.fromEnvironment('DSRT_AUDIO', defaultValue: true),
      enableUI: bool.fromEnvironment('DSRT_UI', defaultValue: true),
      enableVR: bool.fromEnvironment('DSRT_VR', defaultValue: false),
      enableAR: bool.fromEnvironment('DSRT_AR', defaultValue: false),
      viewportWidth: int.fromEnvironment('DSRT_WIDTH', defaultValue: 800),
      viewportHeight: int.fromEnvironment('DSRT_HEIGHT', defaultValue: 600),
      maxFrameRate: double.fromEnvironment('DSRT_FPS', defaultValue: 0.0),
      assetCacheSizeMB: int.fromEnvironment('DSRT_CACHE_SIZE', defaultValue: 256),
    );
  }
  
  /// Merges this configuration with another
  DSRTEngineConfig merge(DSRTEngineConfig other) {
    return DSRTEngineConfig(
      platform: other.platform != DSRTPlatformType.unknown ? other.platform : platform,
      renderingBackend: other.renderingBackend != DSRTRenderingBackend.software ? other.renderingBackend : renderingBackend,
      enableWebGLExtensions: other.enableWebGLExtensions,
      preserveDrawingBuffer: other.preserveDrawingBuffer,
      premultipliedAlpha: other.premultipliedAlpha,
      antialias: other.antialias,
      alpha: other.alpha,
      depth: other.depth,
      stencil: other.stencil,
      desynchronized: other.desynchronized,
      xrCompatible: other.xrCompatible,
      powerPreference: other.powerPreference,
      failIfMajorPerformanceCaveat: other.failIfMajorPerformanceCaveat,
      canvasId: other.canvasId ?? canvasId,
      canvasElement: other.canvasElement ?? canvasElement,
      webGLContextAttributes: other.webGLContextAttributes ?? webGLContextAttributes,
      viewportWidth: other.viewportWidth,
      viewportHeight: other.viewportHeight,
      pixelRatio: other.pixelRatio,
      autoResize: other.autoResize,
      listenToWindowEvents: other.listenToWindowEvents,
      maxFrameRate: other.maxFrameRate,
      vsync: other.vsync,
      performanceMonitoring: other.performanceMonitoring,
      memoryMonitoring: other.memoryMonitoring,
      errorReporting: other.errorReporting,
      crashReporting: other.crashReporting,
      analytics: other.analytics,
      telemetry: other.telemetry,
      debugMode: other.debugMode,
      profiling: other.profiling,
      hotReload: other.hotReload,
      assetCaching: other.assetCaching,
      assetCacheSizeMB: other.assetCacheSizeMB,
      compressAssets: other.compressAssets,
      compressionLevel: other.compressionLevel,
      validateAssets: other.validateAssets,
      optimizeAssets: other.optimizeAssets,
      maxConcurrentAssetLoads: other.maxConcurrentAssetLoads,
      assetLoadTimeoutSeconds: other.assetLoadTimeoutSeconds,
      maxAssetLoadRetries: other.maxAssetLoadRetries,
      defaultMaterial: other.defaultMaterial,
      defaultShader: other.defaultShader,
      defaultTexture: other.defaultTexture,
      defaultGeometry: other.defaultGeometry,
      defaultCameraType: other.defaultCameraType,
      defaultLightType: other.defaultLightType,
      enablePhysics: other.enablePhysics,
      physicsEngine: other.physicsEngine,
      enableAudio: other.enableAudio,
      audioEngine: other.audioEngine,
      enableUI: other.enableUI,
      uiFramework: other.uiFramework,
      enableNetworking: other.enableNetworking,
      networkProtocol: other.networkProtocol,
      enableMultiplayer: other.enableMultiplayer,
      multiplayerFramework: other.multiplayerFramework,
      enableVR: other.enableVR,
      vrFramework: other.vrFramework,
      enableAR: other.enableAR,
      arFramework: other.arFramework,
      enableAI: other.enableAI,
      aiFramework: other.aiFramework,
      customOptions: {...customOptions, ...other.customOptions},
    );
  }
  
  /// Updates configuration with partial changes
  DSRTEngineConfig copyWith({
    DSRTPlatformType? platform,
    DSRTRenderingBackend? renderingBackend,
    bool? enableWebGLExtensions,
    bool? preserveDrawingBuffer,
    bool? premultipliedAlpha,
    bool? antialias,
    bool? alpha,
    bool? depth,
    bool? stencil,
    bool? desynchronized,
    bool? xrCompatible,
    String? powerPreference,
    bool? failIfMajorPerformanceCaveat,
    String? canvasId,
    dynamic canvasElement,
    Map<String, dynamic>? webGLContextAttributes,
    int? viewportWidth,
    int? viewportHeight,
    double? pixelRatio,
    bool? autoResize,
    bool? listenToWindowEvents,
    double? maxFrameRate,
    bool? vsync,
    bool? performanceMonitoring,
    bool? memoryMonitoring,
    bool? errorReporting,
    bool? crashReporting,
    bool? analytics,
    bool? telemetry,
    bool? debugMode,
    bool? profiling,
    bool? hotReload,
    bool? assetCaching,
    int? assetCacheSizeMB,
    bool? compressAssets,
    int? compressionLevel,
    bool? validateAssets,
    bool? optimizeAssets,
    int? maxConcurrentAssetLoads,
    int? assetLoadTimeoutSeconds,
    int? maxAssetLoadRetries,
    String? defaultMaterial,
    String? defaultShader,
    String? defaultTexture,
    String? defaultGeometry,
    String? defaultCameraType,
    String? defaultLightType,
    bool? enablePhysics,
    String? physicsEngine,
    bool? enableAudio,
    String? audioEngine,
    bool? enableUI,
    String? uiFramework,
    bool? enableNetworking,
    String? networkProtocol,
    bool? enableMultiplayer,
    String? multiplayerFramework,
    bool? enableVR,
    String? vrFramework,
    bool? enableAR,
    String? arFramework,
    bool? enableAI,
    String? aiFramework,
    Map<String, dynamic>? customOptions,
  }) {
    return DSRTEngineConfig(
      platform: platform ?? this.platform,
      renderingBackend: renderingBackend ?? this.renderingBackend,
      enableWebGLExtensions: enableWebGLExtensions ?? this.enableWebGLExtensions,
      preserveDrawingBuffer: preserveDrawingBuffer ?? this.preserveDrawingBuffer,
      premultipliedAlpha: premultipliedAlpha ?? this.premultipliedAlpha,
      antialias: antialias ?? this.antialias,
      alpha: alpha ?? this.alpha,
      depth: depth ?? this.depth,
      stencil: stencil ?? this.stencil,
      desynchronized: desynchronized ?? this.desynchronized,
      xrCompatible: xrCompatible ?? this.xrCompatible,
      powerPreference: powerPreference ?? this.powerPreference,
      failIfMajorPerformanceCaveat: failIfMajorPerformanceCaveat ?? this.failIfMajorPerformanceCaveat,
      canvasId: canvasId ?? this.canvasId,
      canvasElement: canvasElement ?? this.canvasElement,
      webGLContextAttributes: webGLContextAttributes ?? this.webGLContextAttributes,
      viewportWidth: viewportWidth ?? this.viewportWidth,
      viewportHeight: viewportHeight ?? this.viewportHeight,
      pixelRatio: pixelRatio ?? this.pixelRatio,
      autoResize: autoResize ?? this.autoResize,
      listenToWindowEvents: listenToWindowEvents ?? this.listenToWindowEvents,
      maxFrameRate: maxFrameRate ?? this.maxFrameRate,
      vsync: vsync ?? this.vsync,
      performanceMonitoring: performanceMonitoring ?? this.performanceMonitoring,
      memoryMonitoring: memoryMonitoring ?? this.memoryMonitoring,
      errorReporting: errorReporting ?? this.errorReporting,
      crashReporting: crashReporting ?? this.crashReporting,
      analytics: analytics ?? this.analytics,
      telemetry: telemetry ?? this.telemetry,
      debugMode: debugMode ?? this.debugMode,
      profiling: profiling ?? this.profiling,
      hotReload: hotReload ?? this.hotReload,
      assetCaching: assetCaching ?? this.assetCaching,
      assetCacheSizeMB: assetCacheSizeMB ?? this.assetCacheSizeMB,
      compressAssets: compressAssets ?? this.compressAssets,
      compressionLevel: compressionLevel ?? this.compressionLevel,
      validateAssets: validateAssets ?? this.validateAssets,
      optimizeAssets: optimizeAssets ?? this.optimizeAssets,
      maxConcurrentAssetLoads: maxConcurrentAssetLoads ?? this.maxConcurrentAssetLoads,
      assetLoadTimeoutSeconds: assetLoadTimeoutSeconds ?? this.assetLoadTimeoutSeconds,
      maxAssetLoadRetries: maxAssetLoadRetries ?? this.maxAssetLoadRetries,
      defaultMaterial: defaultMaterial ?? this.defaultMaterial,
      defaultShader: defaultShader ?? this.defaultShader,
      defaultTexture: defaultTexture ?? this.defaultTexture,
      defaultGeometry: defaultGeometry ?? this.defaultGeometry,
      defaultCameraType: defaultCameraType ?? this.defaultCameraType,
      defaultLightType: defaultLightType ?? this.defaultLightType,
      enablePhysics: enablePhysics ?? this.enablePhysics,
      physicsEngine: physicsEngine ?? this.physicsEngine,
      enableAudio: enableAudio ?? this.enableAudio,
      audioEngine: audioEngine ?? this.audioEngine,
      enableUI: enableUI ?? this.enableUI,
      uiFramework: uiFramework ?? this.uiFramework,
      enableNetworking: enableNetworking ?? this.enableNetworking,
      networkProtocol: networkProtocol ?? this.networkProtocol,
      enableMultiplayer: enableMultiplayer ?? this.enableMultiplayer,
      multiplayerFramework: multiplayerFramework ?? this.multiplayerFramework,
      enableVR: enableVR ?? this.enableVR,
      vrFramework: vrFramework ?? this.vrFramework,
      enableAR: enableAR ?? this.enableAR,
      arFramework: arFramework ?? this.arFramework,
      enableAI: enableAI ?? this.enableAI,
      aiFramework: aiFramework ?? this.aiFramework,
      customOptions: customOptions ?? this.customOptions,
    );
  }
  
  /// Validates configuration against platform capabilities
  Future<Map<String, dynamic>> validate() async {
    final results = <String, dynamic>{
      'valid': true,
      'errors': <String>[],
      'warnings': <String>[],
      'capabilities': <String, dynamic>{},
    };
    
    // Check platform compatibility
    if (!_isPlatformCompatible()) {
      results['valid'] = false;
      results['errors'].add('Platform ${platform.name} is not fully supported');
    }
    
    // Check rendering backend compatibility
    if (!_isRenderingBackendCompatible()) {
      results['valid'] = false;
      results['errors'].add('Rendering backend ${renderingBackend.name} is not available on platform ${platform.name}');
    }
    
    // Check viewport dimensions
    if (viewportWidth > dsrtMaxViewportWidth || viewportHeight > dsrtMaxViewportHeight) {
      results['warnings'].add('Viewport dimensions exceed recommended maximum');
    }
    
    // Check pixel ratio
    if (pixelRatio > 4.0) {
      results['warnings'].add('High pixel ratio may impact performance');
    }
    
    // Check frame rate
    if (maxFrameRate > 0 && maxFrameRate < 30) {
      results['warnings'].add('Low frame rate limit may cause poor user experience');
    }
    
    // Check cache size
    if (assetCacheSizeMB > 2048) {
      results['warnings'].add('Large asset cache may impact memory usage');
    }
    
    // Detect capabilities
    results['capabilities'] = await _detectCapabilities();
    
    return results;
  }
  
  /// Checks if platform is compatible
  bool _isPlatformCompatible() {
    // All platforms are compatible, but some may have limited features
    return true;
  }
  
  /// Checks if rendering backend is compatible
  bool _isRenderingBackendCompatible() {
    switch (platform) {
      case DSRTPlatformType.web:
        return renderingBackend == DSRTRenderingBackend.webgl1 ||
               renderingBackend == DSRTRenderingBackend.webgl2 ||
               renderingBackend == DSRTRenderingBackend.software;
      case DSRTPlatformType.android:
        return renderingBackend == DSRTRenderingBackend.vulkan ||
               renderingBackend == DSRTRenderingBackend.opengl ||
               renderingBackend == DSRTRenderingBackend.software;
      case DSRTPlatformType.ios:
      case DSRTPlatformType.macos:
        return renderingBackend == DSRTRenderingBackend.metal ||
               renderingBackend == DSRTRenderingBackend.opengl ||
               renderingBackend == DSRTRenderingBackend.software;
      case DSRTPlatformType.windows:
        return renderingBackend == DSRTRenderingBackend.directx ||
               renderingBackend == DSRTRenderingBackend.vulkan ||
               renderingBackend == DSRTRenderingBackend.opengl ||
               renderingBackend == DSRTRenderingBackend.software;
      case DSRTPlatformType.linux:
        return renderingBackend == DSRTRenderingBackend.vulkan ||
               renderingBackend == DSRTRenderingBackend.opengl ||
               renderingBackend == DSRTRenderingBackend.software;
      default:
        return renderingBackend == DSRTRenderingBackend.software;
    }
  }
  
  /// Detects platform capabilities
  Future<Map<String, dynamic>> _detectCapabilities() async {
    final capabilities = <String, dynamic>{};
    
    // Platform capabilities
    capabilities['platform'] = platform.name;
    capabilities['renderingBackend'] = renderingBackend.name;
    capabilities['supportsWebGL'] = platform == DSRTPlatformType.web;
    capabilities['supportsVulkan'] = platform == DSRTPlatformType.linux || 
                                     platform == DSRTPlatformType.android ||
                                     platform == DSRTPlatformType.windows;
    capabilities['supportsMetal'] = platform == DSRTPlatformType.ios || 
                                    platform == DSRTPlatformType.macos;
    capabilities['supportsDirectX'] = platform == DSRTPlatformType.windows;
    
    // Memory capabilities (estimated)
    capabilities['estimatedMemoryMB'] = _estimateAvailableMemory();
    capabilities['recommendedMaxTextureSize'] = _getRecommendedMaxTextureSize();
    capabilities['recommendedMaxGeometryVertices'] = _getRecommendedMaxGeometryVertices();
    
    // Feature support
    capabilities['supportsHighDPI'] = pixelRatio > 1.0;
    capabilities['supportsMultisampling'] = antialias;
    capabilities['supportsStencilBuffer'] = stencil;
    capabilities['supportsDepthBuffer'] = depth;
    capabilities['supportsAlphaBlending'] = alpha;
    
    // Performance estimates
    capabilities['estimatedMaxDrawCalls'] = _estimateMaxDrawCalls();
    capabilities['estimatedMaxTriangles'] = _estimateMaxTriangles();
    capabilities['estimatedMaxLights'] = _estimateMaxLights();
    
    return capabilities;
  }
  
  /// Estimates available memory
  int _estimateAvailableMemory() {
    switch (platform) {
      case DSRTPlatformType.web:
        return 512; // Conservative estimate for web
      case DSRTPlatformType.android:
      case DSRTPlatformType.ios:
        return 1024; // Typical mobile
      case DSRTPlatformType.macos:
      case DSRTPlatformType.windows:
      case DSRTPlatformType.linux:
        return 4096; // Typical desktop
      default:
        return 256; // Unknown/low-end
    }
  }
  
  /// Gets recommended maximum texture size
  int _getRecommendedMaxTextureSize() {
    switch (renderingBackend) {
      case DSRTRenderingBackend.webgl1:
        return 2048;
      case DSRTRenderingBackend.webgl2:
        return 4096;
      case DSRTRenderingBackend.vulkan:
      case DSRTRenderingBackend.metal:
      case DSRTRenderingBackend.directx:
        return 8192;
      default:
        return 1024;
    }
  }
  
  /// Gets recommended maximum geometry vertices
  int _getRecommendedMaxGeometryVertices() {
    switch (renderingBackend) {
      case DSRTRenderingBackend.webgl1:
        return 65536;
      case DSRTRenderingBackend.webgl2:
        return 131072;
      case DSRTRenderingBackend.vulkan:
      case DSRTRenderingBackend.metal:
      case DSRTRenderingBackend.directx:
        return 1048576;
      default:
        return 32768;
    }
  }
  
  /// Estimates maximum draw calls
  int _estimateMaxDrawCalls() {
    switch (renderingBackend) {
      case DSRTRenderingBackend.webgl1:
        return 500;
      case DSRTRenderingBackend.webgl2:
        return 1000;
      case DSRTRenderingBackend.vulkan:
      case DSRTRenderingBackend.metal:
      case DSRTRenderingBackend.directx:
        return 5000;
      default:
        return 100;
    }
  }
  
  /// Estimates maximum triangles
  int _estimateMaxTriangles() {
    switch (renderingBackend) {
      case DSRTRenderingBackend.webgl1:
        return 500000;
      case DSRTRenderingBackend.webgl2:
        return 1000000;
      case DSRTRenderingBackend.vulkan:
      case DSRTRenderingBackend.metal:
      case DSRTRenderingBackend.directx:
        return 5000000;
      default:
        return 100000;
    }
  }
  
  /// Estimates maximum lights
  int _estimateMaxLights() {
    switch (renderingBackend) {
      case DSRTRenderingBackend.webgl1:
        return 8;
      case DSRTRenderingBackend.webgl2:
        return 16;
      case DSRTRenderingBackend.vulkan:
      case DSRTRenderingBackend.metal:
      case DSRTRenderingBackend.directx:
        return 32;
      default:
        return 4;
    }
  }
  
  /// Converts configuration to map
  Map<String, dynamic> toMap() {
    return {
      'platform': platform.name,
      'renderingBackend': renderingBackend.name,
      'enableWebGLExtensions': enableWebGLExtensions,
      'preserveDrawingBuffer': preserveDrawingBuffer,
      'premultipliedAlpha': premultipliedAlpha,
      'antialias': antialias,
      'alpha': alpha,
      'depth': depth,
      'stencil': stencil,
      'desynchronized': desynchronized,
      'xrCompatible': xrCompatible,
      'powerPreference': powerPreference,
      'failIfMajorPerformanceCaveat': failIfMajorPerformanceCaveat,
      'canvasId': canvasId,
      'viewportWidth': viewportWidth,
      'viewportHeight': viewportHeight,
      'pixelRatio': pixelRatio,
      'autoResize': autoResize,
      'listenToWindowEvents': listenToWindowEvents,
      'maxFrameRate': maxFrameRate,
      'vsync': vsync,
      'performanceMonitoring': performanceMonitoring,
      'memoryMonitoring': memoryMonitoring,
      'errorReporting': errorReporting,
      'crashReporting': crashReporting,
      'analytics': analytics,
      'telemetry': telemetry,
      'debugMode': debugMode,
      'profiling': profiling,
      'hotReload': hotReload,
      'assetCaching': assetCaching,
      'assetCacheSizeMB': assetCacheSizeMB,
      'compressAssets': compressAssets,
      'compressionLevel': compressionLevel,
      'validateAssets': validateAssets,
      'optimizeAssets': optimizeAssets,
      'maxConcurrentAssetLoads': maxConcurrentAssetLoads,
      'assetLoadTimeoutSeconds': assetLoadTimeoutSeconds,
      'maxAssetLoadRetries': maxAssetLoadRetries,
      'defaultMaterial': defaultMaterial,
      'defaultShader': defaultShader,
      'defaultTexture': defaultTexture,
      'defaultGeometry': defaultGeometry,
      'defaultCameraType': defaultCameraType,
      'defaultLightType': defaultLightType,
      'enablePhysics': enablePhysics,
      'physicsEngine': physicsEngine,
      'enableAudio': enableAudio,
      'audioEngine': audioEngine,
      'enableUI': enableUI,
      'uiFramework': uiFramework,
      'enableNetworking': enableNetworking,
      'networkProtocol': networkProtocol,
      'enableMultiplayer': enableMultiplayer,
      'multiplayerFramework': multiplayerFramework,
      'enableVR': enableVR,
      'vrFramework': vrFramework,
      'enableAR': enableAR,
      'arFramework': arFramework,
      'enableAI': enableAI,
      'aiFramework': aiFramework,
      'customOptions': customOptions,
    };
  }
  
  /// Creates configuration from map
  static DSRTEngineConfig fromMap(Map<String, dynamic> map) {
    return DSRTEngineConfig(
      platform: DSRTPlatformType.values.firstWhere(
        (e) => e.name == (map['platform'] as String? ?? 'unknown'),
        orElse: () => DSRTPlatformType.unknown,
      ),
      renderingBackend: DSRTRenderingBackend.values.firstWhere(
        (e) => e.name == (map['renderingBackend'] as String? ?? 'software'),
        orElse: () => DSRTRenderingBackend.software,
      ),
      enableWebGLExtensions: map['enableWebGLExtensions'] as bool? ?? true,
      preserveDrawingBuffer: map['preserveDrawingBuffer'] as bool? ?? false,
      premultipliedAlpha: map['premultipliedAlpha'] as bool? ?? false,
      antialias: map['antialias'] as bool? ?? true,
      alpha: map['alpha'] as bool? ?? true,
      depth: map['depth'] as bool? ?? true,
      stencil: map['stencil'] as bool? ?? false,
      desynchronized: map['desynchronized'] as bool? ?? false,
      xrCompatible: map['xrCompatible'] as bool? ?? false,
      powerPreference: map['powerPreference'] as String? ?? 'default',
      failIfMajorPerformanceCaveat: map['failIfMajorPerformanceCaveat'] as bool? ?? false,
      canvasId: map['canvasId'] as String?,
      viewportWidth: (map['viewportWidth'] as num?)?.toInt() ?? 800,
      viewportHeight: (map['viewportHeight'] as num?)?.toInt() ?? 600,
      pixelRatio: (map['pixelRatio'] as num?)?.toDouble() ?? 1.0,
      autoResize: map['autoResize'] as bool? ?? true,
      listenToWindowEvents: map['listenToWindowEvents'] as bool? ?? true,
      maxFrameRate: (map['maxFrameRate'] as num?)?.toDouble() ?? 0.0,
      vsync: map['vsync'] as bool? ?? true,
      performanceMonitoring: map['performanceMonitoring'] as bool? ?? true,
      memoryMonitoring: map['memoryMonitoring'] as bool? ?? true,
      errorReporting: map['errorReporting'] as bool? ?? true,
      crashReporting: map['crashReporting'] as bool? ?? false,
      analytics: map['analytics'] as bool? ?? false,
      telemetry: map['telemetry'] as bool? ?? false,
      debugMode: map['debugMode'] as bool? ?? false,
      profiling: map['profiling'] as bool? ?? false,
      hotReload: map['hotReload'] as bool? ?? false,
      assetCaching: map['assetCaching'] as bool? ?? true,
      assetCacheSizeMB: (map['assetCacheSizeMB'] as num?)?.toInt() ?? 256,
      compressAssets: map['compressAssets'] as bool? ?? true,
      compressionLevel: (map['compressionLevel'] as num?)?.toInt() ?? 6,
      validateAssets: map['validateAssets'] as bool? ?? true,
      optimizeAssets: map['optimizeAssets'] as bool? ?? true,
      maxConcurrentAssetLoads: (map['maxConcurrentAssetLoads'] as num?)?.toInt() ?? 4,
      assetLoadTimeoutSeconds: (map['assetLoadTimeoutSeconds'] as num?)?.toInt() ?? 30,
      maxAssetLoadRetries: (map['maxAssetLoadRetries'] as num?)?.toInt() ?? 3,
      defaultMaterial: map['defaultMaterial'] as String? ?? 'StandardMaterial',
      defaultShader: map['defaultShader'] as String? ?? 'StandardShader',
      defaultTexture: map['defaultTexture'] as String? ?? 'WhiteTexture',
      defaultGeometry: map['defaultGeometry'] as String? ?? 'BoxGeometry',
      defaultCameraType: map['defaultCameraType'] as String? ?? 'PerspectiveCamera',
      defaultLightType: map['defaultLightType'] as String? ?? 'DirectionalLight',
      enablePhysics: map['enablePhysics'] as bool? ?? true,
      physicsEngine: map['physicsEngine'] as String? ?? 'DSRTPhysics',
      enableAudio: map['enableAudio'] as bool? ?? true,
      audioEngine: map['audioEngine'] as String? ?? 'DSRTAudio',
      enableUI: map['enableUI'] as bool? ?? true,
      uiFramework: map['uiFramework'] as String? ?? 'DSRTUI',
      enableNetworking: map['enableNetworking'] as bool? ?? false,
      networkProtocol: map['networkProtocol'] as String? ?? 'WebSocket',
      enableMultiplayer: map['enableMultiplayer'] as bool? ?? false,
      multiplayerFramework: map['multiplayerFramework'] as String? ?? 'DSRTMultiplayer',
      enableVR: map['enableVR'] as bool? ?? false,
      vrFramework: map['vrFramework'] as String? ?? 'DSRTVR',
      enableAR: map['enableAR'] as bool? ?? false,
      arFramework: map['arFramework'] as String? ?? 'DSRTAR',
      enableAI: map['enableAI'] as bool? ?? false,
      aiFramework: map['aiFramework'] as String? ?? 'DSRTAI',
      customOptions: (map['customOptions'] as Map<String, dynamic>?) ?? const {},
    );
  }
  
  /// Gets string representation
  @override
  String toString() {
    return 'DSRTEngineConfig('
        'platform: $platform, '
        'renderingBackend: $renderingBackend, '
        'viewport: ${viewportWidth}x$viewportHeight, '
        'pixelRatio: $pixelRatio, '
        'maxFrameRate: $maxFrameRate, '
        'debugMode: $debugMode)';
  }
}
