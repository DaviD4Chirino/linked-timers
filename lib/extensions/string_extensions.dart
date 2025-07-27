extension StringExtensions on String {
  int toInt({fallback = 0}) {
    if (isEmpty) return fallback;
    final int? value = int.tryParse(this);
    return value ?? fallback;
  }

  double toDouble({fallback = 0}) {
    if (isEmpty) return fallback;
    final double? value = double.tryParse(this);
    return value ?? fallback;
  }
}
