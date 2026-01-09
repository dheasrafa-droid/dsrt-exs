/// DSRT Engine - Platform Detection
/// Platform detection and capabilities analysis.
library dsrt_engine.src.core.utils.platform;

import 'dart:io' as io;
import 'dart:js' as js;
import 'dart:math' as math;
import '../constants.dart';
import 'logger.dart';

/// Platform information and capabilities
class PlatformInfo {
  /// Platform type
  PlatformType _type = PlatformType.unknown;
  
  /// Operating system
  OperatingSystem _os = OperatingSystem.unknown;
  
  /// Browser information (web only)
  BrowserInfo? _browser;
  
  /// Device type
  DeviceType _device = DeviceType.desktop;
  
  /// Screen information
  ScreenInfo _screen = ScreenInfo();
  
  /// GPU information
  GpuInfo _gpu = GpuInfo();
  
  /// Platform capabilities
  PlatformCapabilities _capabilities = PlatformCapabilities();
  
  /// Platform version
  String _version = 'unknown';
  
  /// Platform architecture
  String _architecture = 'unknown';
  
  /// Engine logger
  final Logger _logger = Logger('Platform');
  
  /// Get platform type
  PlatformType get type => _type;
  
  /// Get operating system
  OperatingSystem get os => _os;
  
  /// Get browser info (web only)
  BrowserInfo? get browser => _browser;
  
  /// Get device type
  DeviceType get device => _device;
  
  /// Get screen info
  ScreenInfo get screen => _screen;
  
  /// Get GPU info
  GpuInfo get gpu => _gpu;
  
  /// Get platform capabilities
  PlatformCapabilities get capabilities => _capabilities;
  
  /// Get platform version
  String get version => _version;
  
  /// Get platform architecture
  String get architecture => _architecture;
  
  /// Get platform name
  String get name {
    switch (_type) {
      case PlatformType.web:
        return 'Web';
      case PlatformType.android:
        return 'Android';
      case PlatformType.ios:
        return 'iOS';
      case PlatformType.windows:
        return 'Windows';
      case PlatformType.macos:
        return 'macOS';
      case PlatformType.linux:
        return 'Linux';
      case PlatformType.fuchsia:
        return 'Fuchsia';
      default:
        return 'Unknown';
    }
  }
  
  /// Get full platform string
  String get fullName {
    final osName = _os != OperatingSystem.unknown ? ' on ${_os.name}' : '';
    final browserName = _browser != null ? ' (${_browser!.name})' : '';
    return '$name$osName$browserName';
  }
  
  /// Check if running on web
  bool get isWeb => _type == PlatformType.web;
  
  /// Check if running on mobile
  bool get isMobile => _device == DeviceType.mobile;
  
  /// Check if running on tablet
  bool get isTablet => _device == DeviceType.tablet;
  
  /// Check if running on desktop
  bool get isDesktop => _device == DeviceType.desktop;
  
  /// Check if running on TV
  bool get isTv => _device == DeviceType.tv;
  
  /// Check if running on wearable
  bool get isWearable => _device == DeviceType.wearable;
  
  /// Check if running on console
  bool get isConsole => _device == DeviceType.console;
  
  /// Check if touch screen is available
  bool get hasTouchScreen => capabilities.touchScreen;
  
  /// Check if WebGL is available
  bool get hasWebGL => capabilities.webGL;
  
  /// Check if WebGL2 is available
  bool get hasWebGL2 => capabilities.webGL2;
  
  /// Check if WebGPU is available
  bool get hasWebGPU => capabilities.webGPU;
  
  /// Check if WebAssembly is available
  bool get hasWebAssembly => capabilities.webAssembly;
  
  /// Check if SIMD is available
  bool get hasSIMD => capabilities.simd;
  
  /// Check if SharedArrayBuffer is available
  bool get hasSharedArrayBuffer => capabilities.sharedArrayBuffer;
  
  /// Check if Audio API is available
  bool get hasAudioAPI => capabilities.audioAPI;
  
  /// Check if Video API is available
  bool get hasVideoAPI => capabilities.videoAPI;
  
  /// Check if Gamepad API is available
  bool get hasGamepadAPI => capabilities.gamepadAPI;
  
  /// Check if VR API is available
  bool get hasVRAPI => capabilities.vrAPI;
  
  /// Check if AR API is available
  bool get hasARAPI => capabilities.arAPI;
  
  /// Check if device has gyroscope
  bool get hasGyroscope => capabilities.gyroscope;
  
  /// Check if device has accelerometer
  bool get hasAccelerometer => capabilities.accelerometer;
  
  /// Check if device has GPS
  bool get hasGPS => capabilities.gps;
  
  /// Detect platform information
  Future<void> detect() async {
    _logger.info('Detecting platform...');
    
    try {
      // Detect platform type
      await _detectPlatformType();
      
      // Detect operating system
      await _detectOperatingSystem();
      
      // Detect device type
      await _detectDeviceType();
      
      // Detect screen information
      await _detectScreenInfo();
      
      // Detect capabilities
      await _detectCapabilities();
      
      // Detect GPU information
      await _detectGpuInfo();
      
      _logger.info('Platform detection complete: $fullName');
      _logger.debug('Capabilities: $_capabilities');
      _logger.debug('GPU: $_gpu');
    } catch (error, stackTrace) {
      _logger.error('Platform detection failed: $error', stackTrace);
      // Set defaults
      _type = PlatformType.unknown;
      _os = OperatingSystem.unknown;
      _device = DeviceType.desktop;
    }
  }
  
  /// Get platform-specific constants
  Map<String, dynamic> get constants {
    return {
      'platform': _type.name,
      'os': _os.name,
      'device': _device.name,
      'screen': _screen.toMap(),
      'gpu': _gpu.toMap(),
      'capabilities': _capabilities.toMap(),
      'version': _version,
      'architecture': _architecture,
    };
  }
  
  /// Check if platform supports feature
  bool supports(String feature) {
    switch (feature.toLowerCase()) {
      case 'webgl':
        return hasWebGL;
      case 'webgl2':
        return hasWebGL2;
      case 'webgpu':
        return hasWebGPU;
      case 'webassembly':
        return hasWebAssembly;
      case 'simd':
        return hasSIMD;
      case 'sharedarraybuffer':
        return hasSharedArrayBuffer;
      case 'audio':
        return hasAudioAPI;
      case 'video':
        return hasVideoAPI;
      case 'gamepad':
        return hasGamepadAPI;
      case 'vr':
        return hasVRAPI;
      case 'ar':
        return hasARAPI;
      case 'touch':
        return hasTouchScreen;
      case 'gyroscope':
        return hasGyroscope;
      case 'accelerometer':
        return hasAccelerometer;
      case 'gps':
        return hasGPS;
      default:
        return false;
    }
  }
  
  /// Get recommended renderer based on platform capabilities
  String get recommendedRenderer {
    if (hasWebGPU && _gpu.webGPUScore >= 70) {
      return 'WebGPU';
    } else if (hasWebGL2 && _gpu.webGL2Score >= 60) {
      return 'WebGL2';
    } else if (hasWebGL && _gpu.webGLScore >= 50) {
      return 'WebGL';
    } else {
      return 'Canvas2D';
    }
  }
  
  /// Get performance tier based on hardware capabilities
  PerformanceTier get performanceTier {
    final score = _calculatePerformanceScore();
    
    if (score >= 80) {
      return PerformanceTier.high;
    } else if (score >= 50) {
      return PerformanceTier.medium;
    } else {
      return PerformanceTier.low;
    }
  }
  
  /// Get memory limit in MB (estimated)
  int get estimatedMemoryLimit {
    if (isWeb) {
      // Web memory limits
      if (device == DeviceType.mobile) {
        return 512; // Mobile devices
      } else if (device == DeviceType.tablet) {
        return 1024; // Tablets
      } else {
        return 2048; // Desktop
      }
    } else {
      // Native platforms have more memory
      if (device == DeviceType.mobile) {
        return 2048; // Modern mobile devices
      } else if (device == DeviceType.tablet) {
        return 4096; // Tablets
      } else {
        return 8192; // Desktop
      }
    }
  }
  
  /// Get recommended texture size limit
  int get recommendedTextureSize {
    final tier = performanceTier;
    
    switch (tier) {
      case PerformanceTier.high:
        return 4096;
      case PerformanceTier.medium:
        return 2048;
      case PerformanceTier.low:
        return 1024;
    }
  }
  
  /// Get recommended maximum draw calls
  int get recommendedMaxDrawCalls {
    final tier = performanceTier;
    
    switch (tier) {
      case PerformanceTier.high:
        return 1000;
      case PerformanceTier.medium:
        return 500;
      case PerformanceTier.low:
        return 100;
    }
  }
  
  /// Get recommended maximum vertices
  int get recommendedMaxVertices {
    final tier = performanceTier;
    
    switch (tier) {
      case PerformanceTier.high:
        return 1000000;
      case PerformanceTier.medium:
        return 500000;
      case PerformanceTier.low:
        return 100000;
    }
  }
  
  // Private methods
  
  /// Detect platform type
  Future<void> _detectPlatformType() async {
    // Check if running in browser
    if (_isWebPlatform()) {
      _type = PlatformType.web;
      
      // Detect browser
      _browser = _detectBrowser();
      
      // Detect web platform version
      _version = _detectWebVersion();
      
      // Web architecture is typically "web"
      _architecture = 'web';
    } else {
      // Native platform
      if (io.Platform.isAndroid) {
        _type = PlatformType.android;
      } else if (io.Platform.isIOS) {
        _type = PlatformType.ios;
      } else if (io.Platform.isWindows) {
        _type = PlatformType.windows;
      } else if (io.Platform.isMacOS) {
        _type = PlatformType.macos;
      } else if (io.Platform.isLinux) {
        _type = PlatformType.linux;
      } else if (io.Platform.isFuchsia) {
        _type = PlatformType.fuchsia;
      } else {
        _type = PlatformType.unknown;
      }
      
      // Get OS version
      _version = io.Platform.version;
      
      // Get architecture
      _architecture = io.Platform.operatingSystem;
    }
  }
  
  /// Detect operating system
  Future<void> _detectOperatingSystem() async {
    if (isWeb) {
      // Detect OS from user agent
      _os = _detectWebOS();
    } else {
      // Native platform
      if (io.Platform.isAndroid) {
        _os = OperatingSystem.android;
      } else if (io.Platform.isIOS) {
        _os = OperatingSystem.ios;
      } else if (io.Platform.isWindows) {
        _os = OperatingSystem.windows;
      } else if (io.Platform.isMacOS) {
        _os = OperatingSystem.macos;
      } else if (io.Platform.isLinux) {
        _os = OperatingSystem.linux;
      } else {
        _os = OperatingSystem.unknown;
      }
    }
  }
  
  /// Detect device type
  Future<void> _detectDeviceType() async {
    if (isWeb) {
      // Detect device from user agent and screen size
      _device = _detectWebDeviceType();
    } else {
      // Native platform - use screen size and platform
      final screenWidth = _screen.width;
      
      if (_type == PlatformType.android || _type == PlatformType.ios) {
        if (screenWidth < 768) {
          _device = DeviceType.mobile;
        } else {
          _device = DeviceType.tablet;
        }
      } else {
        _device = DeviceType.desktop;
      }
    }
  }
  
  /// Detect screen information
  Future<void> _detectScreenInfo() async {
    if (isWeb) {
      _screen = _detectWebScreenInfo();
    } else {
      _screen = ScreenInfo(
        width: io.window.physicalSize.width.toInt(),
        height: io.window.physicalSize.height.toInt(),
        devicePixelRatio: io.window.devicePixelRatio,
        refreshRate: 60.0, // Default
      );
    }
  }
  
  /// Detect platform capabilities
  Future<void> _detectCapabilities() async {
    if (isWeb) {
      _capabilities = _detectWebCapabilities();
    } else {
      _capabilities = _detectNativeCapabilities();
    }
  }
  
  /// Detect GPU information
  Future<void> _detectGpuInfo() async {
    if (isWeb) {
      _gpu = _detectWebGpuInfo();
    } else {
      _gpu = GpuInfo(
        vendor: 'Unknown',
        renderer: 'Unknown',
        version: 'Unknown',
      );
    }
  }
  
  /// Check if running on web platform
  bool _isWebPlatform() {
    // Simple check for web platform
    try {
      // Check for browser APIs
      if (js.context.hasProperty('window') &&
          js.context.hasProperty('document') &&
          js.context.hasProperty('navigator')) {
        return true;
      }
    } catch (_) {
      // Not in browser
    }
    
    return false;
  }
  
  /// Detect browser from user agent
  BrowserInfo? _detectBrowser() {
    try {
      final userAgent = js.context['navigator']['userAgent'] as String?;
      if (userAgent == null) return null;
      
      final ua = userAgent.toLowerCase();
      
      if (ua.contains('chrome') && !ua.contains('edge')) {
        return BrowserInfo(
          name: 'Chrome',
          version: _extractVersion(ua, 'chrome'),
          vendor: 'Google',
        );
      } else if (ua.contains('firefox')) {
        return BrowserInfo(
          name: 'Firefox',
          version: _extractVersion(ua, 'firefox'),
          vendor: 'Mozilla',
        );
      } else if (ua.contains('safari') && !ua.contains('chrome')) {
        return BrowserInfo(
          name: 'Safari',
          version: _extractVersion(ua, 'safari'),
          vendor: 'Apple',
        );
      } else if (ua.contains('edge')) {
        return BrowserInfo(
          name: 'Edge',
          version: _extractVersion(ua, 'edge'),
          vendor: 'Microsoft',
        );
      } else if (ua.contains('opera')) {
        return BrowserInfo(
          name: 'Opera',
          version: _extractVersion(ua, 'opera'),
          vendor: 'Opera',
        );
      }
    } catch (_) {
      // Could not detect browser
    }
    
    return null;
  }
  
  /// Detect OS from user agent (web)
  OperatingSystem _detectWebOS() {
    try {
      final userAgent = js.context['navigator']['userAgent'] as String?;
      if (userAgent == null) return OperatingSystem.unknown;
      
      final ua = userAgent.toLowerCase();
      
      if (ua.contains('windows')) {
        return OperatingSystem.windows;
      } else if (ua.contains('mac')) {
        return OperatingSystem.macos;
      } else if (ua.contains('linux')) {
        return OperatingSystem.linux;
      } else if (ua.contains('android')) {
        return OperatingSystem.android;
      } else if (ua.contains('iphone') || ua.contains('ipad') || ua.contains('ipod')) {
        return OperatingSystem.ios;
      }
    } catch (_) {
      // Could not detect OS
    }
    
    return OperatingSystem.unknown;
  }
  
  /// Detect device type from user agent and screen size (web)
  DeviceType _detectWebDeviceType() {
    try {
      final userAgent = js.context['navigator']['userAgent'] as String?;
      if (userAgent == null) return DeviceType.desktop;
      
      final ua = userAgent.toLowerCase();
      
      // Check for mobile devices
      if (ua.contains('mobile') ||
          ua.contains('android') ||
          ua.contains('iphone') ||
          ua.contains('ipod')) {
        return DeviceType.mobile;
      }
      
      // Check for tablets
      if (ua.contains('tablet') || ua.contains('ipad')) {
        return DeviceType.tablet;
      }
      
      // Check screen size
      final width = js.context['screen']['width'] as int? ?? 0;
      if (width < 768) {
        return DeviceType.mobile;
      } else if (width < 1024) {
        return DeviceType.tablet;
      }
    } catch (_) {
      // Could not detect device
    }
    
    return DeviceType.desktop;
  }
  
  /// Detect screen info (web)
  ScreenInfo _detectWebScreenInfo() {
    try {
      final width = js.context['screen']['width'] as int? ?? 0;
      final height = js.context['screen']['height'] as int? ?? 0;
      final devicePixelRatio = js.context['devicePixelRatio'] as double? ?? 1.0;
      
      // Try to get refresh rate
      double refreshRate = 60.0;
      try {
        if (js.context.hasProperty('window') &&
            js.context['window'].hasProperty('chrome') &&
            js.context['window']['chrome'].hasProperty('gpuBenchmarking')) {
          refreshRate = (js.context['window']['chrome']['gpuBenchmarking']['refreshRate'] as num?)?.toDouble() ?? 60.0;
        }
      } catch (_) {
        // Could not get refresh rate
      }
      
      return ScreenInfo(
        width: width,
        height: height,
        devicePixelRatio: devicePixelRatio,
        refreshRate: refreshRate,
      );
    } catch (_) {
      return ScreenInfo();
    }
  }
  
  /// Detect web capabilities
  PlatformCapabilities _detectWebCapabilities() {
    final caps = PlatformCapabilities();
    
    try {
      // Check for WebGL
      final canvas = js.context['document']['createElement']('canvas');
      caps.webGL = _testWebGL(canvas, 'webgl') || _testWebGL(canvas, 'experimental-webgl');
      caps.webGL2 = _testWebGL(canvas, 'webgl2');
      
      // Check for WebGPU
      caps.webGPU = js.context.hasProperty('navigator') &&
          js.context['navigator'].hasProperty('gpu');
      
      // Check for WebAssembly
      caps.webAssembly = js.context.hasProperty('WebAssembly');
      
      // Check for SIMD
      caps.simd = js.context.hasProperty('WebAssembly') &&
          js.context['WebAssembly'].hasProperty('SIMD');
      
      // Check for SharedArrayBuffer
      caps.sharedArrayBuffer = js.context.hasProperty('SharedArrayBuffer');
      
      // Check for APIs
      caps.audioAPI = js.context.hasProperty('AudioContext') ||
          js.context.hasProperty('webkitAudioContext');
      caps.videoAPI = js.context.hasProperty('HTMLVideoElement');
      caps.gamepadAPI = js.context.hasProperty('navigator') &&
          js.context['navigator'].hasProperty('getGamepads');
      caps.vrAPI = js.context.hasProperty('navigator') &&
          js.context['navigator'].hasProperty('getVRDisplays');
      caps.arAPI = js.context.hasProperty('navigator') &&
          js.context['navigator'].hasProperty('xr');
      
      // Check for device features
      caps.touchScreen = js.context.hasProperty('ontouchstart') ||
          (js.context.hasProperty('navigator') &&
              js.context['navigator'].hasProperty('maxTouchPoints') &&
              (js.context['navigator']['maxTouchPoints'] as int) > 0);
      caps.gyroscope = js.context.hasProperty('DeviceOrientationEvent');
      caps.accelerometer = js.context.hasProperty('DeviceMotionEvent');
      caps.gps = js.context.hasProperty('navigator') &&
          js.context['navigator'].hasProperty('geolocation');
    } catch (_) {
      // Capabilities detection failed
    }
    
    return caps;
  }
  
  /// Detect native capabilities
  PlatformCapabilities _detectNativeCapabilities() {
    final caps = PlatformCapabilities();
    
    // Native platforms typically have more capabilities
    caps.audioAPI = true;
    caps.videoAPI = true;
    
    // Check for touch screen (mobile/tablet)
    caps.touchScreen = isMobile || isTablet;
    
    // Check for sensors (mobile devices)
    caps.gyroscope = isMobile || isTablet;
    caps.accelerometer = isMobile || isTablet;
    caps.gps = isMobile || isTablet;
    
    return caps;
  }
  
  /// Detect web GPU info
  GpuInfo _detectWebGpuInfo() {
    final gpu = GpuInfo();
    
    try {
      final canvas = js.context['document']['createElement']('canvas');
      
      // Try WebGL first
      final gl = canvas.getContext('webgl') ?? canvas.getContext('experimental-webgl');
      if (gl != null) {
        final debugInfo = gl.getExtension('WEBGL_debug_renderer_info');
        if (debugInfo != null) {
          gpu.vendor = gl.getParameter(debugInfo.UNMASKED_VENDOR_WEBGL) as String? ?? 'Unknown';
          gpu.renderer = gl.getParameter(debugInfo.UNMASKED_RENDERER_WEBGL) as String? ?? 'Unknown';
        }
        gpu.version = gl.getParameter(gl.VERSION) as String? ?? 'Unknown';
        
        // Calculate WebGL score
        gpu.webGLScore = _calculateWebGLScore(gl);
      }
      
      // Try WebGL2
      final gl2 = canvas.getContext('webgl2');
      if (gl2 != null) {
        gpu.webGL2Score = _calculateWebGL2Score(gl2);
      }
      
      // Try WebGPU
      if (js.context.hasProperty('navigator') && js.context['navigator'].hasProperty('gpu')) {
        gpu.webGPUScore = _estimateWebGPUScore();
      }
    } catch (_) {
      // GPU detection failed
    }
    
    return gpu;
  }
  
  /// Test WebGL support
  bool _testWebGL(dynamic canvas, String contextName) {
    try {
      final context = canvas.getContext(contextName);
      return context != null;
    } catch (_) {
      return false;
    }
  }
  
  /// Extract version from user agent
  String _extractVersion(String userAgent, String browserName) {
    final regex = RegExp('$browserName[\\/\\s]([\\d\\.]+)');
    final match = regex.firstMatch(userAgent);
    return match?.group(1) ?? 'unknown';
  }
  
  /// Detect web platform version
  String _detectWebVersion() {
    try {
      return js.context['navigator']['appVersion'] as String? ?? 'unknown';
    } catch (_) {
      return 'unknown';
    }
  }
  
  /// Calculate WebGL score (0-100)
  int _calculateWebGLScore(dynamic gl) {
    int score = 50; // Base score
    
    try {
      // Check maximum texture size
      final maxTextureSize = gl.getParameter(gl.MAX_TEXTURE_SIZE) as int? ?? 0;
      if (maxTextureSize >= 8192) score += 20;
      else if (maxTextureSize >= 4096) score += 15;
      else if (maxTextureSize >= 2048) score += 10;
      
      // Check maximum render buffer size
      final maxRenderBufferSize = gl.getParameter(gl.MAX_RENDERBUFFER_SIZE) as int? ?? 0;
      if (maxRenderBufferSize >= 8192) score += 10;
      else if (maxRenderBufferSize >= 4096) score += 5;
      
      // Check available extensions
      final extensions = gl.getSupportedExtensions() as List<dynamic>? ?? [];
      final importantExtensions = [
        'OES_texture_float',
        'OES_texture_float_linear',
        'OES_texture_half_float',
        'OES_texture_half_float_linear',
        'EXT_texture_filter_anisotropic',
        'WEBGL_compressed_texture_s3tc',
        'WEBGL_depth_texture',
      ];
      
      int extensionCount = 0;
      for (final ext in importantExtensions) {
        if (extensions.contains(ext)) extensionCount++;
      }
      
      score += (extensionCount * 3);
      
      // Cap score
      score = math.min(100, score);
    } catch (_) {
      // Score calculation failed
    }
    
    return score;
  }
  
  /// Calculate WebGL2 score (0-100)
  int _calculateWebGL2Score(dynamic gl) {
    int score = 60; // Base score (higher than WebGL)
    
    try {
      // WebGL2 has better capabilities by default
      final maxTextureSize = gl.getParameter(gl.MAX_TEXTURE_SIZE) as int? ?? 0;
      if (maxTextureSize >= 16384) score += 20;
      else if (maxTextureSize >= 8192) score += 15;
      else if (maxTextureSize >= 4096) score += 10;
      
      // Check available extensions
      final extensions = gl.getSupportedExtensions() as List<dynamic>? ?? [];
      final importantExtensions = [
        'EXT_color_buffer_float',
        'EXT_texture_filter_anisotropic',
        'OES_texture_float_linear',
        'WEBGL_compressed_texture_s3tc',
        'WEBGL_compressed_texture_etc',
        'WEBGL_compressed_texture_astc',
      ];
      
      int extensionCount = 0;
      for (final ext in importantExtensions) {
        if (extensions.contains(ext)) extensionCount++;
      }
      
      score += (extensionCount * 3);
      
      // Cap score
      score = math.min(100, score);
    } catch (_) {
      // Score calculation failed
    }
    
    return score;
  }
  
  /// Estimate WebGPU score
  int _estimateWebGPUScore() {
    // WebGPU is new, assume good performance if available
    return 80;
  }
  
  /// Calculate overall performance score
  int _calculatePerformanceScore() {
    int score = 50;
    
    // Adjust based on device type
    switch (device) {
      case DeviceType.desktop:
        score += 20;
        break;
      case DeviceType.tablet:
        score += 10;
        break;
      case DeviceType.mobile:
        score += 0;
        break;
      case DeviceType.tv:
        score += 15;
        break;
      case DeviceType.console:
        score += 25;
        break;
      default:
        break;
    }
    
    // Adjust based on GPU capabilities
    final gpuScore = math.max(_gpu.webGPUScore, math.max(_gpu.webGL2Score, _gpu.webGLScore));
    score += (gpuScore ~/ 4); // Add up to 25 points
    
    // Adjust based on memory
    final memoryScore = _estimateMemoryScore();
    score += memoryScore;
    
    // Cap score
    return math.min(100, score);
  }
  
  /// Estimate memory score
  int _estimateMemoryScore() {
    final estimatedMemory = estimatedMemoryLimit;
    
    if (estimatedMemory >= 8192) return 20;
    if (estimatedMemory >= 4096) return 15;
    if (estimatedMemory >= 2048) return 10;
    if (estimatedMemory >= 1024) return 5;
    return 0;
  }
}

/// Platform types
enum PlatformType {
  web,
  android,
  ios,
  windows,
  macos,
  linux,
  fuchsia,
  unknown,
}

/// Operating systems
enum OperatingSystem {
  windows,
  macos,
  linux,
  android,
  ios,
  unknown,
}

/// Device types
enum DeviceType {
  desktop,
  mobile,
  tablet,
  tv,
  wearable,
  console,
  unknown,
}

/// Browser information
class BrowserInfo {
  final String name;
  final String version;
  final String vendor;
  
  BrowserInfo({
    required this.name,
    required this.version,
    required this.vendor,
  });
  
  @override
  String toString() {
    return '$name $version ($vendor)';
  }
}

/// Screen information
class ScreenInfo {
  final int width;
  final int height;
  final double devicePixelRatio;
  final double refreshRate;
  final double aspectRatio;
  
  ScreenInfo({
    this.width = 0,
    this.height = 0,
    this.devicePixelRatio = 1.0,
    this.refreshRate = 60.0,
  }) : aspectRatio = width > 0 && height > 0 ? width / height : 0.0;
  
  /// Check if screen is portrait orientation
  bool get isPortrait => height > width;
  
  /// Check if screen is landscape orientation
  bool get isLandscape => width > height;
  
  /// Get screen diagonal in inches (if DPI is known)
  double? getDiagonalInches(double dpi) {
    if (width == 0 || height == 0) return null;
    final diagonalPixels = math.sqrt(width * width + height * height);
    return diagonalPixels / dpi;
  }
  
  /// Convert to map
  Map<String, dynamic> toMap() {
    return {
      'width': width,
      'height': height,
      'devicePixelRatio': devicePixelRatio,
      'refreshRate': refreshRate,
      'aspectRatio': aspectRatio,
      'orientation': isPortrait ? 'portrait' : 'landscape',
    };
  }
  
  @override
  String toString() {
    return '${width}x$height @${devicePixelRatio}x ${refreshRate}Hz';
  }
}

/// GPU information
class GpuInfo {
  String vendor = 'Unknown';
  String renderer = 'Unknown';
  String version = 'Unknown';
  int webGLScore = 0;
  int webGL2Score = 0;
  int webGPUScore = 0;
  
  /// Get GPU performance tier
  String get performanceTier {
    final score = math.max(webGPUScore, math.max(webGL2Score, webGLScore));
    
    if (score >= 80) return 'High';
    if (score >= 60) return 'Medium';
    return 'Low';
  }
  
  /// Check if GPU is integrated (vs discrete)
  bool get isIntegrated {
    final rendererLower = renderer.toLowerCase();
    return rendererLower.contains('intel') ||
           rendererLower.contains('amd') && rendererLower.contains('radeon') && rendererLower.contains('graphics') ||
           rendererLower.contains('mali') ||
           rendererLower.contains('adreno') ||
           rendererLower.contains('powervr');
  }
  
  /// Convert to map
  Map<String, dynamic> toMap() {
    return {
      'vendor': vendor,
      'renderer': renderer,
      'version': version,
      'webGLScore': webGLScore,
      'webGL2Score': webGL2Score,
      'webGPUScore': webGPUScore,
      'performanceTier': performanceTier,
      'isIntegrated': isIntegrated,
    };
  }
  
  @override
  String toString() {
    return '$vendor $renderer ($version) - $performanceTier';
  }
}

/// Platform capabilities
class PlatformCapabilities {
  bool webGL = false;
  bool webGL2 = false;
  bool webGPU = false;
  bool webAssembly = false;
  bool simd = false;
  bool sharedArrayBuffer = false;
  bool audioAPI = false;
  bool videoAPI = false;
  bool gamepadAPI = false;
  bool vrAPI = false;
  bool arAPI = false;
  bool touchScreen = false;
  bool gyroscope = false;
  bool accelerometer = false;
  bool gps = false;
  
  /// Convert to map
  Map<String, dynamic> toMap() {
    return {
      'webGL': webGL,
      'webGL2': webGL2,
      'webGPU': webGPU,
      'webAssembly': webAssembly,
      'simd': simd,
      'sharedArrayBuffer': sharedArrayBuffer,
      'audioAPI': audioAPI,
      'videoAPI': videoAPI,
      'gamepadAPI': gamepadAPI,
      'vrAPI': vrAPI,
      'arAPI': arAPI,
      'touchScreen': touchScreen,
      'gyroscope': gyroscope,
      'accelerometer': accelerometer,
      'gps': gps,
    };
  }
  
  @override
  String toString() {
    final enabled = <String>[];
    if (webGL) enabled.add('WebGL');
    if (webGL2) enabled.add('WebGL2');
    if (webGPU) enabled.add('WebGPU');
    if (webAssembly) enabled.add('WASM');
    if (touchScreen) enabled.add('Touch');
    if (gamepadAPI) enabled.add('Gamepad');
    if (vrAPI) enabled.add('VR');
    if (arAPI) enabled.add('AR');
    
    return 'Capabilities: ${enabled.join(', ')}';
  }
}

/// Performance tiers
enum PerformanceTier {
  low,
  medium,
  high,
}

/// Platform utilities
class PlatformUtils {
  /// Get platform-specific path separator
  static String get pathSeparator {
    if (io.Platform.isWindows) {
      return '\\';
    } else {
      return '/';
    }
  }
  
  /// Get platform-specific line separator
  static String get lineSeparator {
    if (io.Platform.isWindows) {
      return '\r\n';
    } else {
      return '\n';
    }
  }
  
  /// Get temporary directory path
  static String get tempDirectory {
    return io.Directory.systemTemp.path;
  }
  
  /// Get application data directory
  static String get applicationDataDirectory {
    if (io.Platform.isWindows) {
      return io.Platform.environment['APPDATA'] ?? '';
    } else if (io.Platform.isMacOS) {
      return '${io.Platform.environment['HOME']}/Library/Application Support';
    } else if (io.Platform.isLinux) {
      return '${io.Platform.environment['HOME']}/.local/share';
    } else {
      return tempDirectory;
    }
  }
  
  /// Get document directory
  static String get documentsDirectory {
    if (io.Platform.isWindows) {
      return io.Platform.environment['USERPROFILE'] ?? '';
    } else {
      return io.Platform.environment['HOME'] ?? '';
    }
  }
  
  /// Check if running in debug mode
  static bool get isDebugMode {
    bool isDebug = false;
    assert(() {
      isDebug = true;
      return true;
    }());
    return isDebug;
  }
  
  /// Check if running in profile mode
  static bool get isProfileMode {
    // This would require platform-specific detection
    return false;
  }
  
  /// Check if running in release mode
  static bool get isReleaseMode {
    return !isDebugMode && !isProfileMode;
  }
  
  /// Get CPU architecture
  static String get cpuArchitecture {
    return io.Platform.operatingSystem;
  }
  
  /// Get number of CPU cores
  static int get cpuCores {
    return io.Platform.numberOfProcessors;
  }
  
  /// Get system locale
  static String get systemLocale {
    return io.Platform.localeName;
  }
  
  /// Get system timezone
  static String get systemTimezone {
    return DateTime.now().timeZoneName;
  }
  
  /// Get system uptime in seconds
  static int get systemUptime {
    // This would require platform-specific APIs
    return 0;
  }
  
  /// Get available memory in bytes
  static int get availableMemory {
    // This would require platform-specific APIs
    return 0;
  }
  
  /// Get total memory in bytes
  static int get totalMemory {
    // This would require platform-specific APIs
    return 0;
  }
  
  /// Get CPU usage percentage
  static double get cpuUsage {
    // This would require platform-specific APIs
    return 0.0;
  }
}
