# LogExecutionTime

`LogExecutionTime` is a utility class for Flutter applications that allows you to easily measure and log the execution time of asynchronous functions in debug mode.

## Features

- Measures the execution time of asynchronous functions
- Logs the execution time only in debug mode
- Seamlessly integrates with existing async functions
- Doesn't affect performance in release mode

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  log_execution_time: ^1.0.0
```

```dart
import 'package:log_execution_time/log_execution_time.dart';

final fetchData = LogExecutionTime('fetchData', () async {
  // Your async function logic here
  await Future.delayed(Duration(seconds: 2)); // Simulating network request
  return 'Data fetched';
});

void main() async {
  final result = await fetchData();
  print(result); // Prints: Data fetched
}
```