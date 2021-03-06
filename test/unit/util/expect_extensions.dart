import 'package:kotlin_extensions/object.dart';

import 'package:test/test.dart' as test;

extension Expect<T> on T {
  T expect(dynamic matcher) => Also(this).also((e) => test.expect(e, matcher));
}

extension ExpectEquals<T> on T {
  T expectEquals(T element) => Expect(this).expect(test.equals(element));
}

extension ExpectIsTrue<T> on T {
  T expectIsTrue() => Expect(this).expect(test.isTrue);
}

extension ExpectIsFalse<T> on T {
  T expectIsFalse() => Expect(this).expect(test.isFalse);
}

extension ExpectIsA<T> on T {
  T expectIsA<K>() => Expect(this).expect(test.isA<K>());
}

extension ExpectIsNull<T> on T {
  T expectIsNull() => Expect(this).expect(test.isNull);
}

extension ExpectMatchesReference<T> on T {
  T expectMatchesReference(T other) {
    identical(this, other).expectIsTrue();

    return this;
  }
}

extension ExpectNotReference<T> on T {
  T expectNotReference(T other) {
    identical(this, other).expectIsFalse();

    return this;
  }
}

T expectFailsWith<T>(void Function() block) {
  T output;

  block.expect(test.throwsA(test.predicate<T>((e) => (output = e) is T)));

  return output;
}

void expectReturnsNormally(void Function() block) {
  test.expect(block, test.returnsNormally);
}

extension VerifyArgumentError on ArgumentError {
  void verifyArgumentError({String name, String message}) {
    this.name.expectEquals(name);
    (this.message as String).expectEquals(message);
  }
}
