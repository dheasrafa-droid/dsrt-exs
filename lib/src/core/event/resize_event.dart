/// DSRT Engine - Resize Events
/// Window and viewport resize event handling.
library dsrt_engine.src.core.events.resize_event;

import 'event_system.dart';
import '../../utils/uuid.dart';

/// Resize event for window/viewport size changes
class ResizeEvent extends Event {
  /// New width in pixels
  final int width;
  
  /// New height in pixels
  final int height;
  
  /// Previous width in pixels
  final int previousWidth;
  
  /// Previous height in pixels
  final int previousHeight;
  
  /// Aspect ratio (width / height)
  final double aspectRatio;
  
  /// Previous aspect ratio
  final double previousAspectRatio;
  
  /// Device pixel ratio
  final double devicePixelRatio;
  
  /// Resize type
  final ResizeType type;
  
  /// Create resize event
  ResizeEvent({
    required this.width,
    required this.height,
    required this.previousWidth,
    required this.previousHeight,
    required this.devicePixelRatio,
    this.type = ResizeType.window,
  }) : 
    aspectRatio = width / height,
    previousAspectRatio = previousWidth / previousHeight;
  
  /// Get width change delta
  int get widthDelta => width - previousWidth;
  
  /// Get height change delta
  int get heightDelta => height - previousHeight;
  
  /// Get area change
  int get areaDelta => (width * height) - (previousWidth * previousHeight);
  
  /// Check if size actually changed
  bool get sizeChanged => width != previousWidth || height != previousHeight;
  
  /// Check if aspect ratio changed
  bool get aspectRatioChanged => aspectRatio != previousAspectRatio;
  
  /// Get scale factor from previous size
  (double, double) get scale {
    return (
      previousWidth > 0 ? width / previousWidth : 1.0,
      previousHeight > 0 ? height / previousHeight : 1.0,
    );
  }
  
  /// Get diagonal size
  double get diagonal {
    return (width * width + height * height).toDouble();
  }
  
  /// Get previous diagonal size
  double get previousDiagonal {
    return (previousWidth * previousWidth + previousHeight * previousHeight).toDouble();
  }
  
  /// Get diagonal change
  double get diagonalDelta => diagonal - previousDiagonal;
}

/// Resize type
enum ResizeType {
  window,      // Window resize
  viewport,    // Viewport resize (canvas)
  fullscreen,  // Fullscreen toggle
  orientation, // Device orientation change
  virtual,     // Virtual/simulated resize
}

/// Orientation event for device orientation changes
class OrientationEvent extends Event {
  /// Current orientation
  final DeviceOrientation orientation;
  
  /// Previous orientation
  final DeviceOrientation? previousOrientation;
  
  /// Screen width in current orientation
  final int screenWidth;
  
  /// Screen height in current orientation
  final int screenHeight;
  
  /// Create orientation event
  OrientationEvent({
    required this.orientation,
    this.previousOrientation,
    required this.screenWidth,
    required this.screenHeight,
  });
  
  /// Check if orientation changed
  bool get orientationChanged => orientation != previousOrientation;
  
  /// Get orientation angle
  int get angle {
    switch (orientation) {
      case DeviceOrientation.portraitUp:
        return 0;
      case DeviceOrientation.landscapeRight:
        return 90;
      case DeviceOrientation.portraitDown:
        return 180;
      case DeviceOrientation.landscapeLeft:
        return 270;
    }
  }
  
  /// Get previous orientation angle
  int? get previousAngle {
    if (previousOrientation == null) return null;
    
    switch (previousOrientation!) {
      case DeviceOrientation.portraitUp:
        return 0;
      case DeviceOrientation.landscapeRight:
        return 90;
      case DeviceOrientation.portraitDown:
        return 180;
      case DeviceOrientation.landscapeLeft:
        return 270;
    }
  }
  
  /// Get rotation delta
  int? get rotationDelta {
    if (previousAngle == null) return null;
    
    var delta = angle - previousAngle!;
    // Normalize to -180 to 180
    if (delta > 180) delta -= 360;
    if (delta < -180) delta += 360;
    return delta;
  }
}

/// Device orientation
enum DeviceOrientation {
  portraitUp,
  portraitDown,
  landscapeLeft,
  landscapeRight,
}

/// Fullscreen event
class FullscreenEvent extends Event {
  /// Fullscreen state
  final bool isFullscreen;
  
  /// Previous fullscreen state
  final bool wasFullscreen;
  
  /// Screen width in fullscreen
  final int screenWidth;
  
  /// Screen height in fullscreen
  final int screenHeight;
  
  /// Create fullscreen event
  FullscreenEvent({
    required this.isFullscreen,
    required this.wasFullscreen,
    required this.screenWidth,
    required this.screenHeight,
  });
  
  /// Check if fullscreen changed
  bool get fullscreenChanged => isFullscreen != wasFullscreen;
  
  /// Check if entered fullscreen
  bool get enteredFullscreen => isFullscreen && !wasFullscreen;
  
  /// Check if exited fullscreen
  bool get exitedFullscreen => !isFullscreen && wasFullscreen;
}

/// Display metrics event
class DisplayMetricsEvent extends Event {
  /// Display width in pixels
  final int displayWidth;
  
  /// Display height in pixels
  final int displayHeight;
  
  /// Device pixel ratio
  final double devicePixelRatio;
  
  /// Color depth in bits
  final int colorDepth;
  
  /// Refresh rate in Hz
  final double refreshRate;
  
  /// Display orientation
  final DeviceOrientation displayOrientation;
  
  /// Available display modes
  final List<DisplayMode> displayModes;
  
  /// Create display metrics event
  DisplayMetricsEvent({
    required this.displayWidth,
    required this.displayHeight,
    required this.devicePixelRatio,
    required this.colorDepth,
    required this.refreshRate,
    required this.displayOrientation,
    required this.displayModes,
  });
  
  /// Get display diagonal in inches (if DPI is known)
  double? getDiagonalInches(double dpi) {
    final diagonalPixels = (displayWidth * displayWidth + displayHeight * displayHeight).toDouble();
    return diagonalPixels / dpi;
  }
  
  /// Get pixels per inch (PPI)
  double get ppi {
    return devicePixelRatio * 96; // Standard assumption
  }
}

/// Display mode information
class DisplayMode {
  /// Width in pixels
  final int width;
  
  /// Height in pixels
  final int height;
  
  /// Refresh rate in Hz
  final double refreshRate;
  
  /// Color depth in bits
  final int colorDepth;
  
  /// Is this the current display mode
  final bool isCurrent;
  
  /// Create display mode
  DisplayMode({
    required this.width,
    required this.height,
    required this.refreshRate,
    required this.colorDepth,
    this.isCurrent = false,
  });
  
  /// Get aspect ratio
  double get aspectRatio => width / height;
  
  /// Get pixel count
  int get pixelCount => width * height;
  
  /// Get bandwidth in MB/s (approximate)
  double get bandwidth {
    return (pixelCount * (colorDepth / 8) * refreshRate) / (1024 * 1024);
  }
}

/// Resolution change event
class ResolutionChangeEvent extends Event {
  /// New resolution
  final Resolution resolution;
  
  /// Previous resolution
  final Resolution previousResolution;
  
  /// Create resolution change event
  ResolutionChangeEvent({
    required this.resolution,
    required this.previousResolution,
  });
  
  /// Check if resolution changed
  bool get resolutionChanged => resolution != previousResolution;
  
  /// Get resolution scale
  double get scale {
    return resolution.pixelCount / previousResolution.pixelCount;
  }
}

/// Resolution information
class Resolution {
  /// Width in pixels
  final int width;
  
  /// Height in pixels
  final int height;
  
  /// Create resolution
  Resolution({
    required this.width,
    required this.height,
  });
  
  /// Get aspect ratio
  double get aspectRatio => width / height;
  
  /// Get pixel count
  int get pixelCount => width * height;
  
  /// Get common name (if known)
  String get name {
    // Common resolutions
    if (width == 3840 && height == 2160) return '4K UHD';
    if (width == 2560 && height == 1440) return 'QHD';
    if (width == 1920 && height == 1080) return 'Full HD';
    if (width == 1280 && height == 720) return 'HD';
    if (width == 800 && height == 600) return 'SVGA';
    if (width == 640 && height == 480) return 'VGA';
    
    // Aspect ratio based names
    final ratio = aspectRatio;
    if ((ratio - 16/9).abs() < 0.01) return '${width}x$height (16:9)';
    if ((ratio - 4/3).abs() < 0.01) return '${width}x$height (4:3)';
    if ((ratio - 21/9).abs() < 0.01) return '${width}x$height (21:9)';
    if ((ratio - 1).abs() < 0.01) return '${width}x$height (1:1)';
    
    return '${width}x$height';
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Resolution &&
        width == other.width &&
        height == other.height;
  }
  
  @override
  int get hashCode => Object.hash(width, height);
}

/// Resize manager for tracking window/viewport size
class ResizeManager {
  /// Current width
  int _width = 0;
  
  /// Current height
  int _height = 0;
  
  /// Previous width
  int _previousWidth = 0;
  
  /// Previous height
  int _previousHeight = 0;
  
  /// Device pixel ratio
  double _devicePixelRatio = 1.0;
  
  /// Current orientation
  DeviceOrientation _orientation = DeviceOrientation.portraitUp;
  
  /// Fullscreen state
  bool _isFullscreen = false;
  
  /// Minimum width constraint
  int? minWidth;
  
  /// Minimum height constraint
  int? minHeight;
  
  /// Maximum width constraint
  int? maxWidth;
  
  /// Maximum height constraint
  int? maxHeight;
  
  /// Aspect ratio constraint
  double? aspectRatio;
  
  /// Lock aspect ratio
  bool lockAspectRatio = false;
  
  /// Resize debounce delay in milliseconds
  int resizeDebounceDelay = 100;
  
  /// Get current width
  int get width => _width;
  
  /// Get current height
  int get height => _height;
  
  /// Get previous width
  int get previousWidth => _previousWidth;
  
  /// Get previous height
  int get previousHeight => _previousHeight;
  
  /// Get device pixel ratio
  double get devicePixelRatio => _devicePixelRatio;
  
  /// Get orientation
  DeviceOrientation get orientation => _orientation;
  
  /// Get fullscreen state
  bool get isFullscreen => _isFullscreen;
  
  /// Get aspect ratio
  double get aspectRatioValue => _width / _height;
  
  /// Initialize with initial size
  void initialize(int width, int height, double devicePixelRatio) {
    _width = width;
    _height = height;
    _previousWidth = width;
    _previousHeight = height;
    _devicePixelRatio = devicePixelRatio;
    _updateOrientation();
  }
  
  /// Resize window/viewport
  bool resize(int newWidth, int newHeight, {ResizeType type = ResizeType.window}) {
    // Apply constraints
    newWidth = _applyWidthConstraints(newWidth);
    newHeight = _applyHeightConstraints(newHeight);
    
    if (lockAspectRatio && aspectRatio != null) {
      newHeight = (newWidth / aspectRatio!).round();
    }
    
    // Check if size actually changed
    if (newWidth == _width && newHeight == _height) {
      return false;
    }
    
    // Update previous size
    _previousWidth = _width;
    _previousHeight = _height;
    
    // Update current size
    _width = newWidth;
    _height = newHeight;
    
    // Update orientation
    _updateOrientation();
    
    return true;
  }
  
  /// Update device pixel ratio
  void updateDevicePixelRatio(double newRatio) {
    if (newRatio != _devicePixelRatio) {
      _devicePixelRatio = newRatio;
    }
  }
  
  /// Toggle fullscreen
  bool toggleFullscreen(bool fullscreen, int screenWidth, int screenHeight) {
    if (fullscreen == _isFullscreen) return false;
    
    final wasFullscreen = _isFullscreen;
    _isFullscreen = fullscreen;
    
    if (fullscreen) {
      // Enter fullscreen - use screen dimensions
      _previousWidth = _width;
      _previousHeight = _height;
      _width = screenWidth;
      _height = screenHeight;
    } else {
      // Exit fullscreen - restore previous dimensions
      _width = _previousWidth;
      _height = _previousHeight;
    }
    
    _updateOrientation();
    
    return true;
  }
  
  /// Check if size is valid
  bool isValidSize(int width, int height) {
    if (minWidth != null && width < minWidth!) return false;
    if (maxWidth != null && width > maxWidth!) return false;
    if (minHeight != null && height < minHeight!) return false;
    if (maxHeight != null && height > maxHeight!) return false;
    if (aspectRatio != null) {
      final currentAspect = width / height;
      return (currentAspect - aspectRatio!).abs() < 0.01;
    }
    return true;
  }
  
  /// Get current resolution
  Resolution get resolution => Resolution(width: _width, height: _height);
  
  /// Get previous resolution
  Resolution get previousResolution => Resolution(width: _previousWidth, height: _previousHeight);
  
  /// Reset to initial state
  void reset() {
    _width = 0;
    _height = 0;
    _previousWidth = 0;
    _previousHeight = 0;
    _devicePixelRatio = 1.0;
    _orientation = DeviceOrientation.portraitUp;
    _isFullscreen = false;
  }
  
  // Private methods
  
  /// Apply width constraints
  int _applyWidthConstraints(int width) {
    if (minWidth != null && width < minWidth!) return minWidth!;
    if (maxWidth != null && width > maxWidth!) return maxWidth!;
    return width;
  }
  
  /// Apply height constraints
  int _applyHeightConstraints(int height) {
    if (minHeight != null && height < minHeight!) return minHeight!;
    if (maxHeight != null && height > maxHeight!) return maxHeight!;
    return height;
  }
  
  /// Update orientation based on current dimensions
  void _updateOrientation() {
    if (_width >= _height) {
      // Landscape
      _orientation = DeviceOrientation.landscapeRight;
    } else {
      // Portrait
      _orientation = DeviceOrientation.portraitUp;
    }
  }
}
