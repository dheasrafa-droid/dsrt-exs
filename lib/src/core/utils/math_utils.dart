/// DSRT Engine - Math Utilities
/// Mathematical utility functions and helpers.
library dsrt_engine.src.core.utils.math_utils;

import 'dart:math' as math;
import '../constants.dart';

/// Mathematical utility functions
class MathUtils {
  /// Clamp value between min and max
  static double clamp(double value, double min, double max) {
    if (value < min) return min;
    if (value > max) return max;
    return value;
  }
  
  /// Clamp value between 0 and 1
  static double clamp01(double value) => clamp(value, 0.0, 1.0);
  
  /// Linear interpolation between a and b
  static double lerp(double a, double b, double t) {
    return a + (b - a) * clamp01(t);
  }
  
  /// Inverse lerp - get t value between a and b for value
  static double inverseLerp(double a, double b, double value) {
    if (a != b) {
      return clamp01((value - a) / (b - a));
    }
    return 0.0;
  }
  
  /// Smooth interpolation using smoothstep function
  static double smoothStep(double t) {
    t = clamp01(t);
    return t * t * (3.0 - 2.0 * t);
  }
  
  /// Smoother interpolation using smootherstep function
  static double smootherStep(double t) {
    t = clamp01(t);
    return t * t * t * (t * (t * 6.0 - 15.0) + 10.0);
  }
  
  /// Remap value from one range to another
  static double remap(
    double value,
    double inMin,
    double inMax,
    double outMin,
    double outMax,
  ) {
    final t = inverseLerp(inMin, inMax, value);
    return lerp(outMin, outMax, t);
  }
  
  /// Wrap value between min and max
  static double wrap(double value, double min, double max) {
    final range = max - min;
    if (range == 0.0) return min;
    
    var result = (value - min) % range;
    if (result < 0.0) result += range;
    return result + min;
  }
  
  /// Wrap angle in radians between -π and π
  static double wrapAngle(double angle) {
    angle = angle % (2.0 * math.pi);
    if (angle > math.pi) angle -= 2.0 * math.pi;
    if (angle < -math.pi) angle += 2.0 * math.pi;
    return angle;
  }
  
  /// Wrap angle in degrees between -180 and 180
  static double wrapAngleDegrees(double angle) {
    angle = angle % 360.0;
    if (angle > 180.0) angle -= 360.0;
    if (angle < -180.0) angle += 360.0;
    return angle;
  }
  
  /// Convert degrees to radians
  static double degreesToRadians(double degrees) {
    return degrees * DSRTConstants.degToRad;
  }
  
  /// Convert radians to degrees
  static double radiansToDegrees(double radians) {
    return radians * DSRTConstants.radToDeg;
  }
  
  /// Check if two floating point numbers are approximately equal
  static bool approximately(double a, double b, [double epsilon = DSRTConstants.epsilon]) {
    return (a - b).abs() < epsilon;
  }
  
  /// Check if value is approximately zero
  static bool approximatelyZero(double a, [double epsilon = DSRTConstants.epsilon]) {
    return a.abs() < epsilon;
  }
  
  /// Round to nearest multiple
  static double roundToMultiple(double value, double multiple) {
    if (approximatelyZero(multiple)) return value;
    return (value / multiple).roundToDouble() * multiple;
  }
  
  /// Floor to nearest multiple
  static double floorToMultiple(double value, double multiple) {
    if (approximatelyZero(multiple)) return value;
    return (value / multiple).floorToDouble() * multiple;
  }
  
  /// Ceil to nearest multiple
  static double ceilToMultiple(double value, double multiple) {
    if (approximatelyZero(multiple)) return value;
    return (value / multiple).ceilToDouble() * multiple;
  }
  
  /// Calculate factorial
  static int factorial(int n) {
    if (n < 0) throw ArgumentError('Factorial not defined for negative numbers');
    if (n <= 1) return 1;
    
    int result = 1;
    for (int i = 2; i <= n; i++) {
      result *= i;
    }
    return result;
  }
  
  /// Calculate binomial coefficient (n choose k)
  static int binomialCoefficient(int n, int k) {
    if (k < 0 || k > n) return 0;
    if (k == 0 || k == n) return 1;
    
    // Use symmetry property
    if (k > n - k) k = n - k;
    
    int result = 1;
    for (int i = 1; i <= k; i++) {
      result = result * (n - k + i) ~/ i;
    }
    return result;
  }
  
  /// Calculate greatest common divisor using Euclidean algorithm
  static int gcd(int a, int b) {
    while (b != 0) {
      final t = b;
      b = a % b;
      a = t;
    }
    return a.abs();
  }
  
  /// Calculate least common multiple
  static int lcm(int a, int b) {
    if (a == 0 || b == 0) return 0;
    return (a ~/ gcd(a, b)) * b;
  }
  
  /// Solve quadratic equation ax² + bx + c = 0
  /// Returns list of real roots (0, 1, or 2)
  static List<double> solveQuadratic(double a, double b, double c) {
    if (approximatelyZero(a)) {
      // Linear equation bx + c = 0
      if (approximatelyZero(b)) return [];
      return [-c / b];
    }
    
    final discriminant = b * b - 4.0 * a * c;
    
    if (discriminant < 0.0) {
      return [];
    } else if (approximatelyZero(discriminant)) {
      return [-b / (2.0 * a)];
    } else {
      final sqrtD = math.sqrt(discriminant);
      final a2 = 2.0 * a;
      return [
        (-b - sqrtD) / a2,
        (-b + sqrtD) / a2,
      ];
    }
  }
  
  /// Calculate cubic root
  static double cubicRoot(double x) {
    if (x >= 0.0) {
      return math.pow(x, 1.0 / 3.0) as double;
    } else {
      return -math.pow(-x, 1.0 / 3.0) as double;
    }
  }
  
  /// Calculate sigmoid function
  static double sigmoid(double x) {
    return 1.0 / (1.0 + math.exp(-x));
  }
  
  /// Calculate smooth minimum of two values
  static double smoothMin(double a, double b, double k) {
    final h = clamp(0.5 + 0.5 * (b - a) / k, 0.0, 1.0);
    return lerp(b, a, h) - k * h * (1.0 - h);
  }
  
  /// Calculate smooth maximum of two values
  static double smoothMax(double a, double b, double k) {
    final h = clamp(0.5 + 0.5 * (a - b) / k, 0.0, 1.0);
    return lerp(b, a, h) + k * h * (1.0 - h);
  }
  
  /// Calculate Perlin noise-like smooth interpolation
  static double fade(double t) {
    return t * t * t * (t * (t * 6.0 - 15.0) + 10.0);
  }
  
  /// Linear interpolation with extrapolation
  static double lerpUnclamped(double a, double b, double t) {
    return a + (b - a) * t;
  }
  
  /// Calculate move towards target with max delta
  static double moveTowards(double current, double target, double maxDelta) {
    if ((target - current).abs() <= maxDelta) {
      return target;
    }
    return current + (target - current).sign * maxDelta;
  }
  
  /// Calculate smooth damp
  static double smoothDamp(
    double current,
    double target,
    double currentVelocity,
    double smoothTime,
    double maxSpeed,
    double deltaTime,
  ) {
    smoothTime = math.max(0.0001, smoothTime);
    final omega = 2.0 / smoothTime;
    
    final x = omega * deltaTime;
    final exp = 1.0 / (1.0 + x + 0.48 * x * x + 0.235 * x * x * x);
    
    var change = current - target;
    final originalTo = target;
    
    // Clamp maximum speed
    final maxChange = maxSpeed * smoothTime;
    change = clamp(change, -maxChange, maxChange);
    target = current - change;
    
    final temp = (currentVelocity + omega * change) * deltaTime;
    currentVelocity = (currentVelocity - omega * temp) * exp;
    var output = target + (change + temp) * exp;
    
    // Prevent overshooting
    if (originalTo - current > 0.0 == output > originalTo) {
      output = originalTo;
      currentVelocity = (output - originalTo) / deltaTime;
    }
    
    return output;
  }
  
  /// Calculate smooth damp angle
  static double smoothDampAngle(
    double current,
    double target,
    double currentVelocity,
    double smoothTime,
    double maxSpeed,
    double deltaTime,
  ) {
    target = current + wrapAngle(target - current);
    return smoothDamp(current, target, currentVelocity, smoothTime, maxSpeed, deltaTime);
  }
  
  /// Calculate ping pong value between 0 and length
  static double pingPong(double t, double length) {
    t = wrap(t, 0.0, length * 2.0);
    return length - (t - length).abs();
  }
  
  /// Calculate repeat value
  static double repeat(double t, double length) {
    return t - (t / length).floor() * length;
  }
  
  /// Calculate delta angle in degrees
  static double deltaAngleDegrees(double current, double target) {
    var delta = wrapAngleDegrees(target - current);
    if (delta > 180.0) delta -= 360.0;
    return delta;
  }
  
  /// Calculate delta angle in radians
  static double deltaAngleRadians(double current, double target) {
    var delta = wrapAngle(target - current);
    if (delta > math.pi) delta -= 2.0 * math.pi;
    return delta;
  }
  
  /// Linearly interpolate between angles in degrees
  static double lerpAngleDegrees(double a, double b, double t) {
    var delta = wrapAngleDegrees(b - a);
    if (delta > 180.0) delta -= 360.0;
    return a + delta * clamp01(t);
  }
  
  /// Linearly interpolate between angles in radians
  static double lerpAngleRadians(double a, double b, double t) {
    var delta = wrapAngle(b - a);
    if (delta > math.pi) delta -= 2.0 * math.pi;
    return a + delta * clamp01(t);
  }
  
  /// Check if point is inside triangle using barycentric coordinates
  static bool pointInTriangle(
    double px, double py,
    double ax, double ay,
    double bx, double by,
    double cx, double cy,
  ) {
    // Compute vectors
    final v0 = (cx - ax, cy - ay);
    final v1 = (bx - ax, by - ay);
    final v2 = (px - ax, py - ay);
    
    // Compute dot products
    final dot00 = v0.$1 * v0.$1 + v0.$2 * v0.$2;
    final dot01 = v0.$1 * v1.$1 + v0.$2 * v1.$2;
    final dot02 = v0.$1 * v2.$1 + v0.$2 * v2.$2;
    final dot11 = v1.$1 * v1.$1 + v1.$2 * v1.$2;
    final dot12 = v1.$1 * v2.$1 + v1.$2 * v2.$2;
    
    // Compute barycentric coordinates
    final invDenom = 1.0 / (dot00 * dot11 - dot01 * dot01);
    final u = (dot11 * dot02 - dot01 * dot12) * invDenom;
    final v = (dot00 * dot12 - dot01 * dot02) * invDenom;
    
    // Check if point is in triangle
    return (u >= 0.0) && (v >= 0.0) && (u + v < 1.0);
  }
  
  /// Calculate distance from point to line segment
  static double distancePointToLineSegment(
    double px, double py,
    double ax, double ay,
    double bx, double by,
  ) {
    final lineLengthSq = (bx - ax) * (bx - ax) + (by - ay) * (by - ay);
    
    if (lineLengthSq == 0.0) {
      // Line segment is a point
      return math.sqrt((px - ax) * (px - ax) + (py - ay) * (py - ay));
    }
    
    // Consider the line extending the segment, parameterized as A + t (B - A)
    final t = ((px - ax) * (bx - ax) + (py - ay) * (by - ay)) / lineLengthSq;
    
    if (t < 0.0) {
      // Beyond the 'A' end of the segment
      return math.sqrt((px - ax) * (px - ax) + (py - ay) * (py - ay));
    } else if (t > 1.0) {
      // Beyond the 'B' end of the segment
      return math.sqrt((px - bx) * (px - bx) + (py - by) * (py - by));
    }
    
    // Projection falls on the segment
    final projectionX = ax + t * (bx - ax);
    final projectionY = ay + t * (by - ay);
    
    return math.sqrt((px - projectionX) * (px - projectionX) + (py - projectionY) * (py - projectionY));
  }
  
  /// Calculate intersection of two lines
  static (double, double, bool)? lineIntersection(
    double ax1, double ay1, double ax2, double ay2,
    double bx1, double by1, double bx2, double by2,
  ) {
    final denominator = (ax1 - ax2) * (by1 - by2) - (ay1 - ay2) * (bx1 - bx2);
    
    if (approximatelyZero(denominator)) {
      // Lines are parallel
      return null;
    }
    
    final x = ((ax1 * ay2 - ay1 * ax2) * (bx1 - bx2) - (ax1 - ax2) * (bx1 * by2 - by1 * bx2)) / denominator;
    final y = ((ax1 * ay2 - ay1 * ax2) * (by1 - by2) - (ay1 - ay2) * (bx1 * by2 - by1 * bx2)) / denominator;
    
    return (x, y, true);
  }
  
  /// Generate random number in range [min, max]
  static double randomRange(double min, double max, [math.Random? random]) {
    random ??= math.Random();
    return min + random.nextDouble() * (max - min);
  }
  
  /// Generate random integer in range [min, max] inclusive
  static int randomInt(int min, int max, [math.Random? random]) {
    random ??= math.Random();
    return min + random.nextInt(max - min + 1);
  }
  
  /// Generate random boolean
  static bool randomBool([math.Random? random]) {
    random ??= math.Random();
    return random.nextBool();
  }
  
  /// Generate random element from list
  static T randomElement<T>(List<T> list, [math.Random? random]) {
    if (list.isEmpty) {
      throw ArgumentError('List cannot be empty');
    }
    random ??= math.Random();
    return list[random.nextInt(list.length)];
  }
  
  /// Shuffle list in place using Fisher-Yates algorithm
  static void shuffle<T>(List<T> list, [math.Random? random]) {
    random ??= math.Random();
    for (int i = list.length - 1; i > 0; i--) {
      final j = random.nextInt(i + 1);
      final temp = list[i];
      list[i] = list[j];
      list[j] = temp;
    }
  }
  
  /// Calculate mean of values
  static double mean(List<double> values) {
    if (values.isEmpty) return 0.0;
    
    double sum = 0.0;
    for (final value in values) {
      sum += value;
    }
    return sum / values.length;
  }
  
  /// Calculate variance of values
  static double variance(List<double> values) {
    if (values.length < 2) return 0.0;
    
    final avg = mean(values);
    double sum = 0.0;
    
    for (final value in values) {
      final diff = value - avg;
      sum += diff * diff;
    }
    
    return sum / (values.length - 1);
  }
  
  /// Calculate standard deviation of values
  static double standardDeviation(List<double> values) {
    return math.sqrt(variance(values));
  }
  
  /// Calculate median of values
  static double median(List<double> values) {
    if (values.isEmpty) return 0.0;
    
    final sorted = List<double>.from(values)..sort();
    final middle = values.length ~/ 2;
    
    if (values.length.isEven) {
      return (sorted[middle - 1] + sorted[middle]) / 2.0;
    } else {
      return sorted[middle];
    }
  }
  
  /// Calculate mode of values
  static double mode(List<double> values) {
    if (values.isEmpty) return 0.0;
    
    final frequency = <double, int>{};
    double modeValue = values[0];
    int maxCount = 0;
    
    for (final value in values) {
      final count = (frequency[value] ?? 0) + 1;
      frequency[value] = count;
      
      if (count > maxCount) {
        maxCount = count;
        modeValue = value;
      }
    }
    
    return modeValue;
  }
}
