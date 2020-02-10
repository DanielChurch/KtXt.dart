import 'package:meta/meta.dart';

import 'package:kt_xt/pair.dart';
import 'package:kt_xt/typedefs.dart';

import 'iterable_map_extensions.dart';

bool _isNotNull<T>(T element) => element != null;

extension KotlinIterableExtensions<T> on Iterable<T> {
  /// Returns a [Map] containing key-value pairs provided by the [transform]
  /// function applied to elements of the given [Iterable].
  ///
  /// The [transform] function can return multiple key-value pairs and all will be added to the resulting [Map].
  ///
  /// If any of two pairs would have the same key the last one gets added to the [Map].
  ///
  /// The returned [Map] preserves the entry iteration order of the original [Iterable].
  ///
  /// Related: [associateBy], [associateWith]
  ///
  /// Example:
  /// ```Dart
  /// [0, 1, 2, 3].associate((i) => {i: '$i'}); // => {0: '0', 1: '1', 2: '2', 3: '3'}
  /// [0, 1].associate((i) => {i: '$i', -i: '$i'}); // => {0: '0', 1: '1', -1: '1'}
  /// ```
  Map<K, V> associate<K, V>(Transform<T, Map<K, V>> transform) {
    return map(transform).toMap();
  }

  /// Returns a [Map] containing the values provided by [value] and indexed by
  /// the [key] functions applied to elements of the given `[terable].
  ///
  /// If any two elements would have the same key returned by [key] the last one gets added to the map.
  ///
  /// The returned [Map] preserves the entry iteration order of the original [Iterable].
  ///
  /// Related: [associate], [associateWith]
  ///
  /// Examples:
  /// ```Dart
  /// [0, 1, 2, 3].associateBy(key: (i) => -i, value: (i) => i); // => {0: 0, -1: 1, -2: 2, -3: 3}
  /// [0, 1, 2, 3].associateBy(key: (i) => i, value: (i) => -i); // => {0: 0, 1: -1, 2: -2, 3: -3}
  /// [0, 1, 2, 3].associateBy(key: (i) => i * 5, value: (i) => -i); // => {0: 0, 5: -1, 10: -2, 15: -3}
  /// ```
  Map<K, V> associateBy<K, V>({
    @required Transform<T, K> key,
    @required Transform<T, V> value,
  }) {
    return {for (final element in this) key(element): value(element)};
  }

  /// Returns a [Map] where keys are elements from the given collection and values are
  /// produced by the [valueSelector] function applied to each element.
  ///
  /// If any two elements are equal, the last one gets added to the [Map].
  ///
  /// The returned [Map] preserves the entry iteration order of the original collection.
  ///
  /// Related: [associate], [associateBy]
  ///
  /// Example:
  /// ```Dart
  /// ['a', 'abc', 'ab', 'def', 'abcd'].associateWith((s) => s.length);
  /// // => {'a': 1, 'abc': 3, 'ab': 2, 'def': 3, 'abcd': 4}
  /// ```
  Map<T, V> associateWith<V>(Selector<T, V> valueSelector) {
    return {for (final element in this) element: valueSelector(element)};
  }

  /// Checks if all elements in the specified collection are contained in this collection.
  ///
  /// Examples:
  /// ```Dart
  /// [0, 1, 2].containsAll([0, 1]); // => true
  /// [0, 1, 3].containsAll([0, 1, 4]); // => false
  /// ```
  bool containsAll(Iterable<T> elements) => elements.every(contains);

  /// Returns the [first] element, or `null` if the collection [isEmpty] or `null`.
  ///
  /// Related: [last], [lastOrNull], [first]
  ///
  /// Examples:
  /// ```Dart
  /// null.firstOrNull; // => null
  /// [].firstOrNull; // => null
  /// [0, 1, 2].firstOrNull; // => 0
  /// ```
  T get firstOrNull => isNullOrEmpty ? null : first;

  /// Returns a lazy [Iterable] of all elements yielded from the results of the
  /// [transform] function being invoked on each entry of the original [Iterable].
  ///
  /// Related: [expand], [map], [mapIndexed], [mapIndexedNotNull], [mapNotNull]
  ///
  /// Example:
  /// ```Dart
  /// [0, 1, 2].flatMap((i) => [i, i + 5]); // => (0, 5, 1, 6, 2, 7)
  /// ```
  Iterable<R> flatMap<R>(Transform<T, Iterable<R>> transform) {
    return expand(transform);
  }

  /// Performs the given [action] on each element, providing sequential index
  /// (starting at 0) with the element.
  ///
  /// Related: [forEach]
  ///
  /// Example:
  /// ```Dart
  /// ['Hello', 'World'].forEachIndexed((int index, String text) {
  ///   print('$text $index');
  /// });
  ///
  /// // Hello 0
  /// // World 1
  /// ```
  void forEachIndexed(IndexedAction<T> indexedAction) {
    var index = 0;

    forEach((T element) => indexedAction(index++, element));
  }

  /// Groups elements of the original [Iterable] by the key returned by the
  /// given [keySelector] function applied to each element and returns a [Map]
  /// where each group key is associated with a [List] of corresponding elements.
  ///
  /// The returned map preserves the entry iteration order of the keys
  /// produced from the original [Iterable].
  ///
  /// Example:
  /// ```Dart
  /// ['a', 'abc', 'ab', 'def', 'abcd'].groupBy((i) => i.length);
  /// // => {1: [a], 3: [abc, def], 2: [ab], 4: [abcd]}
  /// ```
  Map<R, List<T>> groupBy<R>(Selector<T, R> keySelector) {
    final output = <R, List<T>>{};

    forEach((element) {
      final key = keySelector(element);
      output[key] ??= [];
      output[key].add(element);
    });

    return output;
  }

  /// Returns `true` if this Iterable is either `null` or empty.
  ///
  /// Examples:
  /// ```Dart
  /// null.isNullOrEmpty; // => true
  /// [].isNullOrEmpty; // => true
  /// [0, 1].isNullOrEmpty; // => false
  /// ```
  bool get isNullOrEmpty => this == null || isEmpty;

  /// Returns the [last] element, or `null` if the collection [isEmpty] or `null`.
  ///
  /// Related: [last], [first], [firstOrNull]
  ///
  /// Examples:
  /// ```Dart
  /// null.lastOrNull; // => null
  /// [].lastOrNull; // => null
  /// [0, 1, 2].lastOrNull; // => 2
  /// ```
  T get lastOrNull => isNullOrEmpty ? null : last;

  /// Returns a lazy [Iterable] containing the results of applying the given [transform] function
  /// to each element and its index in the original collection.
  ///
  /// Related: [map], [flatMap], [mapIndexedNotNull], [mapNotNull]
  ///
  /// Example:
  /// ```Dart
  /// ['Hello', 'World'].mapIndexed((int index, String text) {
  ///   return '$text $index';
  /// }); // => ('Hello 0', 'World 1')
  /// ```
  Iterable<R> mapIndexed<R>(IndexedTransform<T, R> indexedTransform) {
    var index = 0;

    return map((T element) => indexedTransform(index++, element));
  }

  /// Returns a lazy [Iterable] containing only the non-null results of applying the given [transform] function
  /// to each element and its index in the original collection.
  ///
  /// Does not null check the elements before [indexedTransform] is applied.
  ///
  /// Related: [map], [flatMap], [mapIndexedNotNull], [mapNotNull]
  ///
  /// Example:
  /// ```Dart
  /// ['Hello', 'Foo', 'World'].mapIndexedNotNull((int index, String text) {
  ///   if (text == 'Foo') return null;
  ///
  ///   return '$text $index';
  /// }); // => ('Hello 0', 'World 2')
  /// ```
  Iterable<R> mapIndexedNotNull<R>(IndexedTransform<T, R> indexedTransform) {
    return mapIndexed(indexedTransform).whereNotNull();
  }

  /// Returns a lazy [Iterable] containing only the non-null results of applying
  /// the given [transform] function to each element in the original collection.
  ///
  /// Does not null check the elements before [transform] is applied.
  ///
  /// Related: [map], [flatMap], [mapIndexed], [mapIndexedNotNull]
  ///
  /// Example:
  /// ```Dart
  /// [0, 1, 2, 3].mapNotNull((i) {
  ///   if (i % 2 == 0) return null;
  ///
  ///   return i;
  /// }); // => (1, 3)
  /// ```
  Iterable<R> mapNotNull<R>(Transform<T, R> transform) {
    return map(transform).whereNotNull();
  }

  /// Returns the first element yielding the largest value of
  /// the given [selector] or `null` if there are no elements.
  ///
  /// Related: [max], [maxWith], [min], [minBy], [minWith]
  ///
  /// Example:
  /// ```Dart
  /// final data = {'World': 1, 'Hello': 0};
  /// data.keys.maxBy((i) => data[i]); // => 'World'
  /// ```
  T maxBy<R extends Comparable>(Selector<T, R> selector) {
    return reduceOrNull((i, j) {
      return selector(i).compareTo(selector(j)) >= 0 ? i : j;
    });
  }

  /// Returns the first element having the largest value according
  /// to the provided [comparator] or `null` if there are no elements.
  ///
  /// Related: [max], [maxBy], [min], [minBy], [minWith]
  ///
  /// Example:
  /// ```Dart
  /// [0, 1, 2].maxWith((i, j) => i > j ? 1 : -1); // => 2
  /// [0, 1, 2].maxWith((i, j) => i < j ? 1 : -1); // => 0
  /// ```
  T maxWith(Comparator<T> comparator) {
    return reduceOrNull((i, j) => comparator(i, j) >= 0 ? i : j);
  }

  /// Returns the first element yielding the smallest value of
  /// the given function or `null` if there are no elements.
  ///
  /// Related: [min], [minWith], [max], [maxBy], [maxWith]
  ///
  /// Example:
  /// ```Dartdart
  /// final data = {'World': 1, 'Hello': 0};
  /// data.keys.minBy((i) => data[i]); // => 'Hello'
  /// ```
  T minBy<R extends Comparable>(Selector<T, R> selector) {
    return reduceOrNull((i, j) {
      return selector(i).compareTo(selector(j)) <= 0 ? i : j;
    });
  }

  /// Returns the first element having the smallest value according
  /// to the provided [comparator] or `null` if there are no elements.
  ///
  /// Related: [minBy], [maxBy], [maxWith]
  ///
  /// Example:
  /// ```Dart
  /// [0, 1, 2].minWith((i, j) => i > j ? 1 : -1); // => 0
  /// [0, 1, 2].minWith((i, j) => i < j ? 1 : -1); // => 2
  /// ```
  T minWith(Comparator<T> comparator) {
    return reduceOrNull((i, j) => comparator(i, j) <= 0 ? i : j);
  }

  /// Splits the original [Iterable] into a [Pair] of [Iterable]s.
  ///
  /// The first [Iterable] contains elements for which [predicate] yielded `true`.
  /// The second [Iterable] contains elements for which [predicate] yielded `false`.
  ///
  /// Example:
  /// ```Dart
  /// [0, 1, 2, 3].partition((i) => i > 1); // => Pair((0, 1), (2, 3))
  ///
  /// ['Hello', 'World', 'Foo', 'Bar'].partition((s) => s.contains('o'));
  /// // => Pair(('Hello', 'World', 'Foo'), ('Bar'))
  /// ```
  Pair<Iterable<T>, Iterable<T>> partition(Predicate<T> predicate) {
    return Pair(where(predicate), whereNot(predicate));
  }

  /// Accumulates value starting with the first element and applying operation
  /// from left to right to current accumulator value and each element with its
  /// index in the original `Iterable`.
  ///
  /// If the [Iterable] is empty, throws `Bad state: No element`.
  /// If the [Iterable] has one element, that element is returned.
  ///
  /// The index starts at 1.
  ///
  /// Related: [reduceIndexedOrNull], [reduce], [reduceOrNull]
  ///
  /// Examples:
  /// ```Dart
  /// [].reduceIndexed((i, j, k) => j); // => Bad state: No element
  /// [5].reduceIndexed((i, j, k) => j); // => 5
  /// [0, 1].reduceIndexed((index, first, second) => index + first + second);
  /// // => (1 + 0 + 1) => 2
  /// [0, 1, 2].reduceIndexed((index, first, second) => index + first + second);
  /// // => (1, 0, 1) => (2, 2, 2) => 6
  /// ```
  T reduceIndexed(IndexedCombinator<T> indexedCombine) {
    var index = 1;

    return reduce((i, j) => indexedCombine(index++, i, j));
  }

  /// Accumulates value starting with the first element and applying operation
  /// from left to right to current accumulator value and each element with its
  /// index in the original `Iterable`.
  ///
  /// If the [Iterable] is empty, returns `null`.
  /// If the [Iterable] has one element, that element is returned.
  ///
  /// The index starts at 1.
  ///
  /// Related: [reduceOrNull], [reduceIndexed], [reduce]
  ///
  /// Examples:
  /// ```Dart
  /// [].reduceIndexedOrNull((i, j, k) => j); // => null
  /// [5].reduceIndexedOrNull((i, j, k) => j); // => 5
  /// [0, 1].reduceIndexedOrNull((index, first, second) => index + first + second);
  /// // => (1 + 0 + 1) => 2
  /// [0, 1, 2].reduceIndexedOrNull((index, first, second) => index + first + second);
  /// // => (1, 0, 1) => (2, 2, 2) => 6
  /// ```
  T reduceIndexedOrNull(IndexedCombinator<T> combine) {
    var index = 1;

    return reduceOrNull((i, j) => combine(index++, i, j));
  }

  /// Accumulates value starting with the first element and applying operation
  /// from left to right to current accumulator value and each element.
  ///
  /// If the [Iterable] is empty, returns `null`.
  /// If the [Iterable] has one element, that element is returned.
  ///
  /// Related: [reduce], [reduceIndexed], [reduceIndexedOrNull]
  ///
  /// Examples:
  /// ```Dart
  /// [].reduceOrNull((i, j) => j); // => null
  /// [5].reduceOrNull((i, j) => j); // => 5
  /// [0, 1, 2].reduceOrNull((first, second) => first + second); // => 3
  /// ```
  T reduceOrNull(T Function(T element1, T element2) reducer) {
    if (isEmpty || reducer == null) return null;

    return reduce(reducer);
  }

  /// Returns a lazy [Iterable] containing only elements matching the given [predicate].
  ///
  /// Related: [where], [whereIsNotNull], [whereNotNull], [whereNot]
  ///
  /// Example:
  /// ```Dart
  /// ['Hello', 'World', 'Foo'].whereIndexed((int index, String text) {
  ///   return index == 0 || text == 'World';
  /// }); // => ('Hello', 'World')
  /// ```
  Iterable<T> whereIndexed(IndexedPredicate<T> indexedPredicate) {
    var index = 0;

    return where((T element) => indexedPredicate(index++, element));
  }

  /// Returns a lazy [Iterable] containing all elements of the original [Iterable]
  /// where the result of [transform] applied on the elements is not `null`.
  ///
  /// Does not `null` check the element before [transform] is applied.
  ///
  /// Related: [where], [whereIndexed], [whereNotNull], [whereNot]
  ///
  /// Example:
  /// ```Dart
  /// [Data()..id = 'test', Data()].whereIsNotNull((data) => data.id); // (Data(id = 'test'))
  /// [0, 1].whereIsNotNull((i) => i == 0 ? null : i); // => (1)
  /// ```
  Iterable<T> whereIsNotNull<R>(Transform<T, R> transform) {
    return where((T element) => transform(element) != null);
  }

  /// Returns a lazy [Iterable] containing all elements not matching the given predicate.
  ///
  /// Related: [where], [whereIndexed], [whereIsNotNull], [whereNotNull]
  ///
  /// Examples:
  /// ```Dart
  /// [0, 1, 2, 3].whereNot((i) => i == 2); // => (0, 1, 3)
  /// ['Hello', 'Foo', 'World'].filterNot((i) => i == 'Foo'); // => ('Hello', 'World')
  /// ```
  Iterable<T> whereNot(Predicate<T> predicate) => where((e) => !predicate(e));

  /// Returns a lazy [Iterable] containing all elements that are not `null`.
  ///
  /// Related: [where], [whereIndexed], [whereIsNotNull], [whereNot]
  ///
  /// Example:
  /// ```Dart
  /// [0, null, 1].whereNotNull(); // => (0, 1)
  /// ```
  Iterable<T> whereNotNull() => where(_isNotNull);
}
