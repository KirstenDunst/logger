/*
 * @Author: Cao Shixin
 * @Date: 2021-01-18 16:27:06
 * @LastEditors: Cao Shixin
 * @LastEditTime: 2021-01-19 10:59:37
 * @Description: 
 */
import 'package:logger_csx/src/printers/simple_printer.dart';
import 'package:test/test.dart';
import 'package:logger_csx/logger_csx.dart';

const ansiEscapeLiteral = '\x1B';

void main() {
  var event = LogEvent(
    Level.verbose,
    'some message',
    error: 'some error',
    stackTrace: StackTrace.current,
  );

  var plainPrinter = SimplePrinter(colors: false, printTime: false);

  test('represent event on a single line (ignoring stacktrace)', () {
    var outputs = plainPrinter.log(event);

    expect(outputs, hasLength(1));
    expect(outputs[0], '[V]  some message  ERROR: some error');
  });

  group('color', () {
    test('print color', () {
      // `useColor` is detected but here we override it because we want to print
      // the ANSI control characters regardless for the test.
      var printer = SimplePrinter(colors: true);

      expect(printer.log(event)[0], contains(ansiEscapeLiteral));
    });

    test('toggle color', () {
      var printer = SimplePrinter(colors: false);

      expect(printer.log(event)[0], isNot(contains(ansiEscapeLiteral)));
    });
  });

  test('print time', () {
    var printer = SimplePrinter(printTime: true);

    expect(printer.log(event)[0], contains('TIME'));
  });

  test('does not print time', () {
    var printer = SimplePrinter(printTime: false);

    expect(printer.log(event)[0], isNot(contains('TIME')));
  });

  test('omits error when null', () {
    var withoutError = LogEvent(
      Level.debug,
      'some message',
      error: null,
      stackTrace: StackTrace.current,
    );
    var outputs = SimplePrinter().log(withoutError);

    expect(outputs[0], isNot(contains('ERROR')));
  });

  test('deal with Map type message', () {
    var withMap = LogEvent(
      Level.debug,
      {'foo': 123},
      error: 'some error',
      stackTrace: StackTrace.current,
    );

    expect(
      plainPrinter.log(withMap)[0],
      '[D]  {"foo":123}  ERROR: some error',
    );
  });

  test('deal with Iterable type message', () {
    var withIterable = LogEvent(
      Level.debug,
      [1, 2, 3, 4],
      error: 'some error',
      stackTrace: StackTrace.current,
    );

    expect(
      plainPrinter.log(withIterable)[0],
      '[D]  [1,2,3,4]  ERROR: some error',
    );
  });
}
