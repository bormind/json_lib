import 'package:json_lib/json_lib.dart';
import 'package:test/expect.dart';

class _ExceptionMatcher extends Matcher {
  final String message;

  _ExceptionMatcher(this.message);

  @override
  Description describe(Description description) {
    return description.add('Expected JasonLibException with message "$message"');
  }

  @override
  bool matches(item, Map matchState) {
    return item is JsonLibException && item.message == message;
  }
}

void expectThrow(Function() actual, String message) {
  expect(actual, throwsA(_ExceptionMatcher(message)));
}
