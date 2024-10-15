# GoRouterWatcher

GoRouterWatcher is a utility class for tracking and logging route changes in Flutter applications using go_router.

## Features

- Route change detection
- Tracking of previous and current route information
- Calculation of route duration
- Full path tracking
- Custom logging functionality

## Getting started
Add `go_router_watcher` to your `pubspec.yaml` file:

```yaml
dependencies:
  go_router_watcher: ^1.0.0
```

import the package in your Dart code:

```dart
import 'package:go_router_watcher/go_router_watcher.dart';
```


initialize the GoRouterWatcher instance with a GoRouter instance and a log function:
```dart
final GoRouter router = GoRouter(
  // Route configuration
);

void main() {
  GoRouterWatcher.instance.initialize(
    router,
    log: (RouteLog log) {
      print(log.toString());
    },
  );

  runApp(MyApp(router: router));
}
```
