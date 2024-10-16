# AsyncQueue

`AsyncQueue` is a utility class for Flutter and Dart applications that manages a queue of asynchronous operations, executing them sequentially with a configurable delay between each operation.

## Features

- Queue asynchronous operations
- Execute operations sequentially
- Configurable delay between operations
- Easy to use API

## Getting started

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  # ... other dependencies
  async_queue: ^1.0.0
```

Import the package in your Dart code:
```dart
import 'package:async_queue/async_queue.dart';
```

```dart
void main() async {
  // Add operations to the queue
  final result1 = await AsyncQueue.add(() async {
    await Future.delayed(Duration(seconds: 1));
    return 'Operation 1 complete';
  });

  final result2 = await AsyncQueue.add(() async {
    await Future.delayed(Duration(seconds: 1));
    return 'Operation 2 complete';
  });

  print(result1); // Prints: Operation 1 complete
  print(result2); // Prints: Operation 2 complete

  // Check queue status
  print(AsyncQueue.isEmpty);    // Prints: true
  print(AsyncQueue.isNotEmpty); // Prints: false
  print(AsyncQueue.length);     // Prints: 0
}
```