import 'iterable_object_extensions.dart';

extension KotlinIterableOfComparableExtensions<T extends Comparable>
    on Iterable<T> {
  /// Returns the largest element or `null` if there are no elements.
  ///
  /// Related: [maxBy], [maxWith], [min], [minBy], [minWith]
  ///
  /// Examples:
  /// ```Dart
  /// [8, 10, 2].max; // => 10
  /// [].max; // => null
  /// ```
  T get max => reduceOrNull((i, j) => i.compareTo(j) > 0 ? i : j);

  /// Returns the smallest element or `null` if there are no elements.
  ///
  /// Related: [minBy], [minWith], [max], [maxBy], [maxWith]
  ///
  /// Examples:
  /// ```Dart
  /// [8, 10, 2].min; // => 2
  /// [].min; // => null
  /// ```
  T get min => reduceOrNull((i, j) => i.compareTo(j) < 0 ? i : j);
}
