/*
 * @Author: Cao Shixin
 * @Date: 2021-01-18 16:27:06
 * @LastEditors: Cao Shixin
 * @LastEditTime: 2021-01-18 16:34:29
 * @Description: 
 */
import 'package:logger/src/logger.dart';
import 'package:logger/src/log_filter.dart';

/// Prints all logs with `level >= Logger.level` while in development mode (eg
/// when `assert`s are evaluated, Flutter calls this debug mode).
///
/// In release mode ALL logs are omitted.
class DevelopmentFilter extends LogFilter {
  @override
  bool shouldLog(LogEvent event) {
    var shouldLog = false;
    assert(() {
      if (event.level.index >= level.index) {
        shouldLog = true;
      }
      return true;
    }());
    return shouldLog;
  }
}
