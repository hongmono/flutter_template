import 'package:flutter/foundation.dart';

/// A class that measures and logs the execution time of a function in debug mode.
///
/// This class wraps a function and measures its execution time when called.
/// The execution time is only measured and logged in debug mode.
///
/// Example usage:
/// ```dart
/// final fetchData = LogExecutionTime('fetchData', () async {
///   // Your async function logic here
///   return await someAsyncOperation();
/// });
///
/// // Call the wrapped function
/// final result = await fetchData();
/// ```
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
