/*
 * @Author: Cao Shixin
 * @Date: 2021-01-18 16:27:06
 * @LastEditors: Cao Shixin
 * @LastEditTime: 2021-01-19 15:16:02
 * @Description: 
 */
import 'dart:async';

import 'package:logger/src/logger.dart';
import 'package:logger/src/log_output.dart';

class StreamOutput extends LogOutput {
  StreamController<OutputEvent> _controller;
  bool _shouldForward = false;

  StreamOutput() {
    _controller = StreamController<OutputEvent>(
      onListen: () => _shouldForward = true,
      onPause: () => _shouldForward = false,
      onResume: () => _shouldForward = true,
      onCancel: () => _shouldForward = false,
    );
  }

  Stream<OutputEvent> get stream => _controller.stream;

  @override
  void output(OutputEvent event) {
    if (!_shouldForward) {
      return;
    }
    _controller.add(event);
  }

  @override
  void destroy() {
    _controller.close();
  }
}
