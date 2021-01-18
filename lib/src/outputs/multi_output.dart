/*
 * @Author: Cao Shixin
 * @Date: 2021-01-18 16:27:06
 * @LastEditors: Cao Shixin
 * @LastEditTime: 2021-01-18 16:34:11
 * @Description: 
 */
import 'package:logger/src/log_output.dart';
import 'package:logger/src/logger.dart';

/// Logs simultaneously to multiple [LogOutput] outputs.
class MultiOutput extends LogOutput {
  List<LogOutput> _outputs;

  MultiOutput(List<LogOutput> outputs) {
    _outputs = _normalizeOutputs(outputs);
  }
  List<LogOutput> _normalizeOutputs(List<LogOutput> outputs) {
    final normalizedOutputs = <LogOutput>[];

    if (outputs != null) {
      for (final output in outputs) {
        if (output != null) {
          normalizedOutputs.add(output);
        }
      }
    }

    return normalizedOutputs;
  }

  @override
  void init() {
    _outputs.forEach((o) => o.init());
  }

  @override
  void output(OutputEvent event) {
    _outputs.forEach((o) => o.output(event));
  }

  @override
  void destroy() {
    _outputs.forEach((o) => o.destroy());
  }
}
