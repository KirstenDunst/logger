import 'package:logger_csx/src/filters/development_filter.dart';
import 'package:logger_csx/src/printers/pretty_printer.dart';
import 'package:logger_csx/src/outputs/console_output.dart';
import 'package:logger_csx/src/log_filter.dart';
import 'package:logger_csx/src/log_printer.dart';
import 'package:logger_csx/src/log_output.dart';

/// [Level]s to control logging output. Logging can be enabled to include all
/// levels above certain [Level].
enum Level {
  verbose,
  debug,
  info,
  warning,
  error,
  wtf,
}

class LogEvent {
  final Level level;
  final dynamic message;
  final dynamic error;
  final StackTrace? stackTrace;
  //附带参数，可自定义使用传递参数
  final dynamic extraParam;

  LogEvent(this.level, this.message,
      {this.error, this.stackTrace, this.extraParam});
}

class OutputEvent {
  final Level level;
  final List<String?> lines;
  //附带参数，可自定义使用传递参数
  final dynamic extraParam;

  OutputEvent(this.level, this.lines, {this.extraParam});
}

/// Use instances of logger to send log messages to the [LogPrinter].
class Logger {
  /// The current logging level of the app.
  ///
  /// All logs with levels below this level will be omitted.
  static Level level = Level.verbose;

  final LogFilter _filter;
  final LogPrinter _printer;
  final LogOutput _output;
  bool _active = true;

  /// Create a new instance of Logger.
  ///
  /// You can provide a custom [printer], [filter] and [output]. Otherwise the
  /// defaults: [PrettyPrinter], [DevelopmentFilter] and [ConsoleOutput] will be
  /// used.
  Logger({
    LogFilter? filter,
    LogPrinter? printer,
    LogOutput? output,
    Level? level,
  })  : _filter = filter ?? DevelopmentFilter(),
        _printer = printer ?? PrettyPrinter(),
        _output = output ?? ConsoleOutput() {
    _filter.init();
    _filter.level = level ?? Logger.level;
    _printer.init();
    _output.init();
  }

  /// Log a message at level [Level.verbose].
  void v(dynamic message,
      {dynamic error, StackTrace? stackTrace, dynamic extraParam}) {
    log(Level.verbose, message,
        error: error, stackTrace: stackTrace, extraParam: extraParam);
  }

  /// Log a message at level [Level.debug].
  void d(dynamic message,
      {dynamic error, StackTrace? stackTrace, dynamic extraParam}) {
    log(Level.debug, message,
        error: error, stackTrace: stackTrace, extraParam: extraParam);
  }

  /// Log a message at level [Level.info].
  void i(dynamic message,
      {dynamic error, StackTrace? stackTrace, dynamic extraParam}) {
    log(Level.info, message,
        error: error, stackTrace: stackTrace, extraParam: extraParam);
  }

  /// Log a message at level [Level.warning].
  void w(dynamic message,
      {dynamic error, StackTrace? stackTrace, dynamic extraParam}) {
    log(Level.warning, message,
        error: error, stackTrace: stackTrace, extraParam: extraParam);
  }

  /// Log a message at level [Level.error].
  void e(dynamic message,
      {dynamic error, StackTrace? stackTrace, dynamic extraParam}) {
    log(Level.error, message,
        error: error, stackTrace: stackTrace, extraParam: extraParam);
  }

  /// Log a message at level [Level.wtf].
  void wtf(dynamic message,
      {dynamic error, StackTrace? stackTrace, dynamic extraParam}) {
    log(Level.wtf, message,
        error: error, stackTrace: stackTrace, extraParam: extraParam);
  }

  /// Log a message with [level].
  void log(Level level, dynamic message,
      {dynamic error, StackTrace? stackTrace, dynamic extraParam}) {
    if (!_active) {
      throw ArgumentError('Logger has already been closed.');
    } else if (error != null && error is StackTrace) {
      throw ArgumentError('Error parameter cannot take a StackTrace!');
    } 
    var logEvent = LogEvent(level, message,
        error: error, stackTrace: stackTrace, extraParam: extraParam);
    if (_filter.shouldLog(logEvent)) {
      var output = _printer.log(logEvent)!;

      if (output.isNotEmpty) {
        var outputEvent = OutputEvent(level, output, extraParam: extraParam);
        // Issues with log output should NOT influence
        // the main software behavior.
        try {
          _output.output(outputEvent);
        } catch (e, s) {
          print(e);
          print(s);
        }
      }
    }
  }

  /// Closes the logger and releases all resources.
  void close() {
    _active = false;
    _filter.destroy();
    _printer.destroy();
    _output.destroy();
  }
}
