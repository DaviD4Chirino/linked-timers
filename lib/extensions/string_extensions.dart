extension StringExtensions on String {
  int toInt({fallback = 0}) {
    final int? value = int.tryParse(this);
    return value ?? fallback;
  }

  double toDouble({fallback = 0}) {
    final double? value = double.tryParse(this);
    return value ?? fallback;
  }
}
