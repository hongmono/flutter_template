import 'package:flutter/foundation.dart';

class LogExecutionTime<T> {
  final String _name;
  final Future<T> Function() _function;

  LogExecutionTime(this._name, this._function);

  Future<T> call() async {
    if (kDebugMode) {
      final stopwatch = Stopwatch()..start();
      final result = await _function();
      stopwatch.stop();
      print('$_name executed in ${stopwatch.elapsedMilliseconds}ms');
      return result;
    } else {
      return await _function();
    }
  }
}
