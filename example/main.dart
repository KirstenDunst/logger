/*
 * @Author: Cao Shixin
 * @Date: 2021-01-18 16:26:37
 * @LastEditors: Cao Shixin
 * @LastEditTime: 2021-01-19 10:54:59
 * @Description: 
 */
import 'package:logger/logger.dart';

var logger = Logger(
  printer: PrettyPrinter(),
);

var loggerNoStack = Logger(
  printer: PrettyPrinter(methodCount: 0),
);

void main() {
  print(
      'Run with either `dart example/main.dart` or `dart --enable-asserts example/main.dart`.');
  demo();
}

void demo() {
  logger.d('Log message with 2 methods');

  loggerNoStack.i('Info message');

  loggerNoStack.w('Just a warning!');

  logger.e('Error! Something bad happened', error: 'Test Error');

  loggerNoStack.v({'key': 5, 'value': 'something'});

  loggerNoStack.wtf('what the fuck!');

  Logger(printer: SimplePrinter(colors: true)).v('boom');
}
