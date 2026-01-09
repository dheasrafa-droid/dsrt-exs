/// DSRT Engine - Color Utilities
/// Color manipulation and conversion utilities.
library dsrt_engine.src.core.utils.color_utils;

import 'dart:math' as math;
import 'dart:ui' as ui;
import '../constants.dart';
import 'math_utils.dart';

/// Color utilities for manipulation and conversion
class ColorUtils {
  /// Create color from RGBA components (0-255)
  static int fromRGBA(int r, int g, int b, [int a = 255]) {
    r = MathUtils.clamp(r, 0, 255);
    g = MathUtils.clamp(g, 0, 255);
    b = MathUtils.clamp(b, 0, 255);
    a = MathUtils.clamp(a, 0, 255);
    
    return (a << 24) | (r << 16) | (g << 8) | b;
  }
  
  /// Create color from RGB components (0-255)
  static int fromRGB(int r, int g, int b) {
    return fromRGBA(r, g, b, 255);
  }
  
  /// Create color from normalized RGBA components (0.0-1.0)
  static int fromNormalizedRGBA(double r, double g, double b, [double a = 1.0]) {
    return fromRGBA(
      (r * 255).round(),
      (g * 255).round(),
      (b * 255).round(),
      (a * 255).round(),
    );
  }
  
  /// Create color from normalized RGB components (0.0-1.0)
  static int fromNormalizedRGB(double r, double g, double b) {
    return fromNormalizedRGBA(r, g, b, 1.0);
  }
  
  /// Create color from HSL components
  /// h: hue (0-360), s: saturation (0-100), l: lightness (0-100)
  static int fromHSL(double h, double s, double l, [double a = 1.0]) {
    h = MathUtils.wrap(h, 0.0, 360.0);
    s = MathUtils.clamp(s, 0.0, 100.0) / 100.0;
    l = MathUtils.clamp(l, 0.0, 100.0) / 100.0;
    a = MathUtils.clamp01(a);
    
    final (r, g, b) = _hslToRgb(h, s, l);
    return fromNormalizedRGBA(r, g, b, a);
  }
  
  /// Create color from HSV components
  /// h: hue (0-360), s: saturation (0-100), v: value (0-100)
  static int fromHSV(double h, double s, double v, [double a = 1.0]) {
    h = MathUtils.wrap(h, 0.0, 360.0);
    s = MathUtils.clamp(s, 0.0, 100.0) / 100.0;
    v = MathUtils.clamp(v, 0.0, 100.0) / 100.0;
    a = MathUtils.clamp01(a);
    
    final (r, g, b) = _hsvToRgb(h, s, v);
    return fromNormalizedRGBA(r, g, b, a);
  }
  
  /// Create color from hex string
  static int fromHex(String hex) {
    hex = hex.replaceFirst('#', '');
    
    if (hex.length == 3) {
      // #RGB
      final r = int.parse(hex[0] * 2, radix: 16);
      final g = int.parse(hex[1] * 2, radix: 16);
      final b = int.parse(hex[2] * 2, radix: 16);
      return fromRGB(r, g, b);
    } else if (hex.length == 4) {
      // #RGBA
      final r = int.parse(hex[0] * 2, radix: 16);
      final g = int.parse(hex[1] * 2, radix: 16);
      final b = int.parse(hex[2] * 2, radix: 16);
      final a = int.parse(hex[3] * 2, radix: 16);
      return fromRGBA(r, g, b, a);
    } else if (hex.length == 6) {
      // #RRGGBB
      final r = int.parse(hex.substring(0, 2), radix: 16);
      final g = int.parse(hex.substring(2, 4), radix: 16);
      final b = int.parse(hex.substring(4, 6), radix: 16);
      return fromRGB(r, g, b);
    } else if (hex.length == 8) {
      // #RRGGBBAA
      final r = int.parse(hex.substring(0, 2), radix: 16);
      final g = int.parse(hex.substring(2, 4), radix: 16);
      final b = int.parse(hex.substring(4, 6), radix: 16);
      final a = int.parse(hex.substring(6, 8), radix: 16);
      return fromRGBA(r, g, b, a);
    }
    
    throw ArgumentError('Invalid hex color format: $hex');
  }
  
  /// Get red component (0-255)
  static int getRed(int color) {
    return (color >> 16) & 0xFF;
  }
  
  /// Get green component (0-255)
  static int getGreen(int color) {
    return (color >> 8) & 0xFF;
  }
  
  /// Get blue component (0-255)
  static int getBlue(int color) {
    return color & 0xFF;
  }
  
  /// Get alpha component (0-255)
  static int getAlpha(int color) {
    return (color >> 24) & 0xFF;
  }
  
  /// Get normalized red component (0.0-1.0)
  static double getNormalizedRed(int color) {
    return getRed(color) / 255.0;
  }
  
  /// Get normalized green component (0.0-1.0)
  static double getNormalizedGreen(int color) {
    return getGreen(color) / 255.0;
  }
  
  /// Get normalized blue component (0.0-1.0)
  static double getNormalizedBlue(int color) {
    return getBlue(color) / 255.0;
  }
  
  /// Get normalized alpha component (0.0-1.0)
  static double getNormalizedAlpha(int color) {
    return getAlpha(color) / 255.0;
  }
  
  /// Convert color to HSL
  /// Returns (hue: 0-360, saturation: 0-100, lightness: 0-100)
  static (double, double, double) toHSL(int color) {
    final r = getNormalizedRed(color);
    final g = getNormalizedGreen(color);
    final b = getNormalizedBlue(color);
    
    final max = math.max(r, math.max(g, b));
    final min = math.min(r, math.min(g, b));
    final delta = max - min;
    
    double h = 0.0;
    double s = 0.0;
    final l = (max + min) / 2.0;
    
    if (delta != 0.0) {
      s = delta / (1.0 - (2.0 * l - 1.0).abs());
      
      if (max == r) {
        h = (g - b) / delta;
        if (g < b) h += 6.0;
      } else if (max == g) {
        h = 2.0 + (b - r) / delta;
      } else {
        h = 4.0 + (r - g) / delta;
      }
      
      h *= 60.0;
    }
    
    return (h, s * 100.0, l * 100.0);
  }
  
  /// Convert color to HSV
  /// Returns (hue: 0-360, saturation: 0-100, value: 0-100)
  static (double, double, double) toHSV(int color) {
    final r = getNormalizedRed(color);
    final g = getNormalizedGreen(color);
    final b = getNormalizedBlue(color);
    
    final max = math.max(r, math.max(g, b));
    final min = math.min(r, math.min(g, b));
    final delta = max - min;
    
    double h = 0.0;
    double s = 0.0;
    final v = max;
    
    if (delta != 0.0) {
      s = delta / max;
      
      if (max == r) {
        h = (g - b) / delta;
        if (g < b) h += 6.0;
      } else if (max == g) {
        h = 2.0 + (b - r) / delta;
      } else {
        h = 4.0 + (r - g) / delta;
      }
      
      h *= 60.0;
    }
    
    return (h, s * 100.0, v * 100.0);
  }
  
  /// Convert color to hex string
  static String toHex(int color, {bool includeAlpha = false, bool includeHash = true}) {
    final r = getRed(color);
    final g = getGreen(color);
    final b = getBlue(color);
    
    String hex;
    if (includeAlpha) {
      final a = getAlpha(color);
      hex = '${r.toRadixString(16).padLeft(2, '0')}'
            '${g.toRadixString(16).padLeft(2, '0')}'
            '${b.toRadixString(16).padLeft(2, '0')}'
            '${a.toRadixString(16).padLeft(2, '0')}';
    } else {
      hex = '${r.toRadixString(16).padLeft(2, '0')}'
            '${g.toRadixString(16).padLeft(2, '0')}'
            '${b.toRadixString(16).padLeft(2, '0')}';
    }
    
    return includeHash ? '#$hex' : hex;
  }
  
  /// Convert color to Flutter Color
  static ui.Color toFlutterColor(int color) {
    return ui.Color(color);
  }
  
  /// Convert Flutter Color to color integer
  static int fromFlutterColor(ui.Color color) {
    return color.value;
  }
  
  /// Lighten color by percentage
  static int lighten(int color, double percent) {
    final (h, s, l) = toHSL(color);
    final newL = MathUtils.clamp(l + percent, 0.0, 100.0);
    final a = getNormalizedAlpha(color);
    return fromHSL(h, s, newL, a);
  }
  
  /// Darken color by percentage
  static int darken(int color, double percent) {
    final (h, s, l) = toHSL(color);
    final newL = MathUtils.clamp(l - percent, 0.0, 100.0);
    final a = getNormalizedAlpha(color);
    return fromHSL(h, s, newL, a);
  }
  
  /// Saturate color by percentage
  static int saturate(int color, double percent) {
    final (h, s, l) = toHSL(color);
    final newS = MathUtils.clamp(s + percent, 0.0, 100.0);
    final a = getNormalizedAlpha(color);
    return fromHSL(h, newS, l, a);
  }
  
  /// Desaturate color by percentage
  static int desaturate(int color, double percent) {
    final (h, s, l) = toHSL(color);
    final newS = MathUtils.clamp(s - percent, 0.0, 100.0);
    final a = getNormalizedAlpha(color);
    return fromHSL(h, newS, l, a);
  }
  
  /// Adjust hue by degrees
  static int adjustHue(int color, double degrees) {
    final (h, s, l) = toHSL(color);
    final newH = MathUtils.wrap(h + degrees, 0.0, 360.0);
    final a = getNormalizedAlpha(color);
    return fromHSL(newH, s, l, a);
  }
  
  /// Invert color
  static int invert(int color) {
    final r = 255 - getRed(color);
    final g = 255 - getGreen(color);
    final b = 255 - getBlue(color);
    final a = getAlpha(color);
    return fromRGBA(r, g, b, a);
  }
  
  /// Adjust opacity/alpha
  static int withOpacity(int color, double opacity) {
    final r = getRed(color);
    final g = getGreen(color);
    final b = getBlue(color);
    final a = (MathUtils.clamp01(opacity) * 255).round();
    return fromRGBA(r, g, b, a);
  }
  
  /// Linear interpolate between two colors
  static int lerp(int colorA, int colorB, double t) {
    t = MathUtils.clamp01(t);
    
    final r = MathUtils.lerp(getRed(colorA).toDouble(), getRed(colorB).toDouble(), t).round();
    final g = MathUtils.lerp(getGreen(colorA).toDouble(), getGreen(colorB).toDouble(), t).round();
    final b = MathUtils.lerp(getBlue(colorA).toDouble(), getBlue(colorB).toDouble(), t).round();
    final a = MathUtils.lerp(getAlpha(colorA).toDouble(), getAlpha(colorB).toDouble(), t).round();
    
    return fromRGBA(r, g, b, a);
  }
  
  /// Linear interpolate in HSL space
  static int lerpHSL(int colorA, int colorB, double t) {
    t = MathUtils.clamp01(t);
    
    final (h1, s1, l1) = toHSL(colorA);
    final (h2, s2, l2) = toHSL(colorB);
    final a1 = getNormalizedAlpha(colorA);
    final a2 = getNormalizedAlpha(colorB);
    
    // Handle hue interpolation correctly (wrap around 360)
    double h;
    final diff = h2 - h1;
    if (diff.abs() > 180.0) {
      if (h2 > h1) {
        h = MathUtils.lerp(h1 + 360.0, h2, t);
      } else {
        h = MathUtils.lerp(h1, h2 + 360.0, t);
      }
      h = MathUtils.wrap(h, 0.0, 360.0);
    } else {
      h = MathUtils.lerp(h1, h2, t);
    }
    
    final s = MathUtils.lerp(s1, s2, t);
    final l = MathUtils.lerp(l1, l2, t);
    final a = MathUtils.lerp(a1, a2, t);
    
    return fromHSL(h, s, l, a);
  }
  
  /// Generate complementary color
  static int complementary(int color) {
    return adjustHue(color, 180.0);
  }
  
  /// Generate analogous colors (main color ± hue offset)
  static List<int> analogous(int color, {double offset = 30.0, int count = 3}) {
    final colors = <int>[];
    
    for (int i = 0; i < count; i++) {
      final hueOffset = offset * (i - (count - 1) / 2);
      colors.add(adjustHue(color, hueOffset));
    }
    
    return colors;
  }
  
  /// Generate triadic colors
  static List<int> triadic(int color) {
    return [
      color,
      adjustHue(color, 120.0),
      adjustHue(color, 240.0),
    ];
  }
  
  /// Generate tetradic colors
  static List<int> tetradic(int color) {
    return [
      color,
      adjustHue(color, 90.0),
      adjustHue(color, 180.0),
      adjustHue(color, 270.0),
    ];
  }
  
  /// Generate split complementary colors
  static List<int> splitComplementary(int color, {double offset = 30.0}) {
    return [
      color,
      adjustHue(color, 180.0 - offset),
      adjustHue(color, 180.0 + offset),
    ];
  }
  
  /// Generate monochromatic colors
  static List<int> monochromatic(int color, {int count = 5, double lightnessStep = 20.0}) {
    final (h, s, _) = toHSL(color);
    final a = getNormalizedAlpha(color);
    final colors = <int>[];
    
    for (int i = 0; i < count; i++) {
      final l = lightnessStep * i;
      colors.add(fromHSL(h, s, l, a));
    }
    
    return colors;
  }
  
  /// Calculate luminance (perceived brightness)
  static double luminance(int color) {
    final r = getNormalizedRed(color);
    final g = getNormalizedGreen(color);
    final b = getNormalizedBlue(color);
    
    // sRGB luminance coefficients
    return 0.2126 * r + 0.7152 * g + 0.0722 * b;
  }
  
  /// Check if color is dark (for text contrast)
  static bool isDark(int color) {
    return luminance(color) < 0.5;
  }
  
  /// Check if color is light (for text contrast)
  static bool isLight(int color) {
    return !isDark(color);
  }
  
  /// Calculate contrast ratio between two colors
  static double contrastRatio(int color1, int color2) {
    final l1 = luminance(color1);
    final l2 = luminance(color2);
    
    final lighter = math.max(l1, l2);
    final darker = math.min(l1, l2);
    
    return (lighter + 0.05) / (darker + 0.05);
  }
  
  /// Get contrasting text color (black or white)
  static int getContrastColor(int backgroundColor) {
    return isDark(backgroundColor) ? DSRTConstants.white : DSRTConstants.black;
  }
  
  /// Blend two colors using various blend modes
  static int blend(int colorA, int colorB, BlendMode mode) {
    final ra = getNormalizedRed(colorA);
    final ga = getNormalizedGreen(colorA);
    final ba = getNormalizedBlue(colorA);
    final aa = getNormalizedAlpha(colorA);
    
    final rb = getNormalizedRed(colorB);
    final gb = getNormalizedGreen(colorB);
    final bb = getNormalizedBlue(colorB);
    final ab = getNormalizedAlpha(colorB);
    
    double r, g, b, a;
    
    switch (mode) {
      case BlendMode.normal:
        r = MathUtils.lerp(ra, rb, ab);
        g = MathUtils.lerp(ga, gb, ab);
        b = MathUtils.lerp(ba, bb, ab);
        a = aa + ab * (1.0 - aa);
        break;
        
      case BlendMode.multiply:
        r = ra * rb;
        g = ga * gb;
        b = ba * bb;
        a = aa + ab * (1.0 - aa);
        break;
        
      case BlendMode.screen:
        r = 1.0 - (1.0 - ra) * (1.0 - rb);
        g = 1.0 - (1.0 - ga) * (1.0 - gb);
        b = 1.0 - (1.0 - ba) * (1.0 - bb);
        a = aa + ab * (1.0 - aa);
        break;
        
      case BlendMode.overlay:
        r = ra < 0.5 ? 2.0 * ra * rb : 1.0 - 2.0 * (1.0 - ra) * (1.0 - rb);
        g = ga < 0.5 ? 2.0 * ga * gb : 1.0 - 2.0 * (1.0 - ga) * (1.0 - gb);
        b = ba < 0.5 ? 2.0 * ba * bb : 1.0 - 2.0 * (1.0 - ba) * (1.0 - bb);
        a = aa + ab * (1.0 - aa);
        break;
        
      case BlendMode.darken:
        r = math.min(ra, rb);
        g = math.min(ga, gb);
        b = math.min(ba, bb);
        a = aa + ab * (1.0 - aa);
        break;
        
      case BlendMode.lighten:
        r = math.max(ra, rb);
        g = math.max(ga, gb);
        b = math.max(ba, bb);
        a = aa + ab * (1.0 - aa);
        break;
        
      case BlendMode.colorDodge:
        r = rb == 1.0 ? 1.0 : math.min(1.0, ra / (1.0 - rb));
        g = gb == 1.0 ? 1.0 : math.min(1.0, ga / (1.0 - gb));
        b = bb == 1.0 ? 1.0 : math.min(1.0, ba / (1.0 - bb));
        a = aa + ab * (1.0 - aa);
        break;
        
      case BlendMode.colorBurn:
        r = rb == 0.0 ? 0.0 : 1.0 - math.min(1.0, (1.0 - ra) / rb);
        g = gb == 0.0 ? 0.0 : 1.0 - math.min(1.0, (1.0 - ga) / gb);
        b = bb == 0.0 ? 0.0 : 1.0 - math.min(1.0, (1.0 - ba) / bb);
        a = aa + ab * (1.0 - aa);
        break;
        
      case BlendMode.hardLight:
        r = rb < 0.5 ? 2.0 * ra * rb : 1.0 - 2.0 * (1.0 - ra) * (1.0 - rb);
        g = gb < 0.5 ? 2.0 * ga * gb : 1.0 - 2.0 * (1.0 - ga) * (1.0 - gb);
        b = bb < 0.5 ? 2.0 * ba * bb : 1.0 - 2.0 * (1.0 - ba) * (1.0 - bb);
        a = aa + ab * (1.0 - aa);
        break;
        
      case BlendMode.softLight:
        r = rb < 0.5 
            ? 2.0 * ra * rb + ra * ra * (1.0 - 2.0 * rb)
            : 2.0 * ra * (1.0 - rb) + math.sqrt(ra) * (2.0 * rb - 1.0);
        g = gb < 0.5 
            ? 2.0 * ga * gb + ga * ga * (1.0 - 2.0 * gb)
            : 2.0 * ga * (1.0 - gb) + math.sqrt(ga) * (2.0 * gb - 1.0);
        b = bb < 0.5 
            ? 2.0 * ba * bb + ba * ba * (1.0 - 2.0 * bb)
            : 2.0 * ba * (1.0 - bb) + math.sqrt(ba) * (2.0 * bb - 1.0);
        a = aa + ab * (1.0 - aa);
        break;
        
      case BlendMode.difference:
        r = (ra - rb).abs();
        g = (ga - gb).abs();
        b = (ba - bb).abs();
        a = aa + ab * (1.0 - aa);
        break;
        
      case BlendMode.exclusion:
        r = ra + rb - 2.0 * ra * rb;
        g = ga + gb - 2.0 * ga * gb;
        b = ba + bb - 2.0 * ba * bb;
        a = aa + ab * (1.0 - aa);
        break;
    }
    
    // Composite alpha
    if (a > 0.0) {
      r = (ra * (1.0 - ab) + r * ab) / a;
      g = (ga * (1.0 - ab) + g * ab) / a;
      b = (ba * (1.0 - ab) + b * ab) / a;
    }
    
    return fromNormalizedRGBA(
      MathUtils.clamp01(r),
      MathUtils.clamp01(g),
      MathUtils.clamp01(b),
      MathUtils.clamp01(a),
    );
  }
  
  // Private methods
  
  /// Convert HSL to RGB
  static (double, double, double) _hslToRgb(double h, double s, double l) {
    if (s == 0.0) {
      return (l, l, l);
    }
    
    final q = l < 0.5 ? l * (1.0 + s) : l + s - l * s;
    final p = 2.0 * l - q;
    
    final hk = h / 360.0;
    final tr = _hueToRgb(p, q, hk + 1.0 / 3.0);
    final tg = _hueToRgb(p, q, hk);
    final tb = _hueToRgb(p, q, hk - 1.0 / 3.0);
    
    return (tr, tg, tb);
  }
  
  /// Convert HSV to RGB
  static (double, double, double) _hsvToRgb(double h, double s, double v) {
    if (s == 0.0) {
      return (v, v, v);
    }
    
    h = h / 60.0;
    final i = h.floor();
    final f = h - i;
    final p = v * (1.0 - s);
    final q = v * (1.0 - s * f);
    final t = v * (1.0 - s * (1.0 - f));
    
    switch (i % 6) {
      case 0: return (v, t, p);
      case 1: return (q, v, p);
      case 2: return (p, v, t);
      case 3: return (p, q, v);
      case 4: return (t, p, v);
      case 5: return (v, p, q);
      default: return (v, v, v);
    }
  }
  
  /// Helper for HSL to RGB conversion
  static double _hueToRgb(double p, double q, double t) {
    if (t < 0.0) t += 1.0;
    if (t > 1.0) t -= 1.0;
    
    if (t < 1.0 / 6.0) return p + (q - p) * 6.0 * t;
    if (t < 1.0 / 2.0) return q;
    if (t < 2.0 / 3.0) return p + (q - p) * (2.0 / 3.0 - t) * 6.0;
    return p;
  }
}

/// Blend modes for color blending
enum BlendMode {
  normal,
  multiply,
  screen,
  overlay,
  darken,
  lighten,
  colorDodge,
  colorBurn,
  hardLight,
  softLight,
  difference,
  exclusion,
}

/// Color palette generator
class ColorPalette {
  /// Generate rainbow colors
  static List<int> rainbow(int count, {double saturation = 100.0, double lightness = 50.0}) {
    final colors = <int>[];
    final hueStep = 360.0 / count;
    
    for (int i = 0; i < count; i++) {
      final hue = i * hueStep;
      colors.add(ColorUtils.fromHSL(hue, saturation, lightness));
    }
    
    return colors;
  }
  
  /// Generate warm colors
  static List<int> warm(int count, {double saturation = 70.0, double lightness = 50.0}) {
    final colors = <int>[];
    final hueStep = 60.0 / count;
    
    for (int i = 0; i < count; i++) {
      final hue = 0.0 + i * hueStep; // Red to yellow
      colors.add(ColorUtils.fromHSL(hue, saturation, lightness));
    }
    
    return colors;
  }
  
  /// Generate cool colors
  static List<int> cool(int count, {double saturation = 70.0, double lightness = 50.0}) {
    final colors = <int>[];
    final hueStep = 120.0 / count;
    
    for (int i = 0; i < count; i++) {
      final hue = 180.0 + i * hueStep; // Cyan to purple
      colors.add(ColorUtils.fromHSL(hue, saturation, lightness));
    }
    
    return colors;
  }
  
  /// Generate pastel colors
  static List<int> pastel(int count, {double saturation = 30.0, double lightness = 80.0}) {
    final colors = <int>[];
    final hueStep = 360.0 / count;
    
    for (int i = 0; i < count; i++) {
      final hue = i * hueStep;
      colors.add(ColorUtils.fromHSL(hue, saturation, lightness));
    }
    
    return colors;
  }
  
  /// Generate earth tones
  static List<int> earthTones(int count) {
    // Predefined earth tone colors
    const earthColors = [
      0xFF8B4513, // SaddleBrown
      0xFFA0522D, // Sienna
      0xFFD2691E, // Chocolate
      0xFFCD853F, // Peru
      0xFFD2B48C, // Tan
      0xFFBC8F8F, // RosyBrown
      0xFFF4A460, // SandyBrown
      0xFFDEB887, // BurlyWood
    ];
    
    final colors = <int>[];
    for (int i = 0; i < count; i++) {
      colors.add(earthColors[i % earthColors.length]);
    }
    
    return colors;
  }
}
