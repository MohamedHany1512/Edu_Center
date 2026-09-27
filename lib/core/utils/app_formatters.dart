/// Presentation-layer formatting helpers.
///
/// Centralised so currency/lesson labels stay consistent across the home,
/// course-details, my-courses and my-favorites features, which previously each
/// built their own `'${price} EGP'` / `'$count درس'` strings inline.
abstract final class AppFormatters {
  /// Currency code used across the app.
  static const String currencyCode = 'EGP';

  /// Fallback label when a course has no category.
  static const String defaultCategory = 'دورة';

  /// Formats a price as `"123.45 EGP"`.
  static String price(double value) => '${value.toStringAsFixed(2)} $currencyCode';

  /// Formats a lesson count as `"12 درس"`, or `null` when there are none.
  static String? lessons(int? count) =>
      (count == null || count <= 0) ? null : '$count درس';

  /// Formats a category, falling back to [defaultCategory] when blank.
  static String category(String? value) =>
      (value == null || value.trim().isEmpty) ? defaultCategory : value;

  /// Formats a rating, hiding the row entirely when the value is zero.
  static String rating(double value) => value.toStringAsFixed(1);

  /// Formats `"2 / 10 درس"`.
  static String lessonsProgress(int completed, int total) =>
      '$completed / $total درس';
}