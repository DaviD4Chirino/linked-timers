abstract class Utils {
  static double getPercentage(num value, num min, num max) {
    if (max == min) return 0.0; // Avoid division by zero
    final percent = (value - min) / (max - min);
    return percent.clamp(0.0, 1.0);
  }
}
