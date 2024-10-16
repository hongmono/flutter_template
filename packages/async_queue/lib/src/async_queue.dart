import 'dart:async';
import 'dart:collection';

abstract class AsyncQueue {
  static Duration delay = const Duration(milliseconds: 100);

  static final Queue<(Function, Completer<dynamic>)> _queue = Queue();

  static Completer<dynamic>? _completer;

  static Future<T> add<T>(Function callback) async {
    final Completer<T> completer = Completer();
    _queue.add((callback, completer));

    if (_completer == null || _completer!.isCompleted) {
      execute();
    }

    return completer.future;
  }

  static dynamic execute() async {
    _completer = Completer();

    while (_queue.isNotEmpty) {
      final (callback, completer) = _queue.removeFirst();

      completer.complete(await callback());

      if (_queue.isNotEmpty) {
        await Future.delayed(delay);
      }
    }

    _completer?.complete();
  }

  static bool get isEmpty => _queue.isEmpty;

  static bool get isNotEmpty => _queue.isNotEmpty;

  static int get length => _queue.length;
}
