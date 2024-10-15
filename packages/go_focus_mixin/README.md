# GoFocusMixin

A Flutter mixin that provides onFocused and onUnFocused callbacks for pages registered with go_router, enabling easy tracking of page focus states.

## Features

- Easy integration with go_router
- Simple API with onFocused and onUnFocused callbacks
- Lightweight mixin-based implementation
- No additional widget wrapping required

## Getting started

Add `go_focus_mixin` to your `pubspec.yaml` file:

```yaml
dependencies:
  go_focus_mixin: ^1.0.0
```

Import the package in your Dart code:
```dart
import 'package:go_focus_mixin/go_focus_mixin.dart';
```

Add the mixin to your page class and implement the onFocused and onUnFocused callbacks:
```dart
class MyPage extends StatefulWidget {
  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> with GoFocusMixin {
  @override
  void onFocused() {
    print('Page gained focus');
    // Perform actions when the page gains focus
  }

  @override
  void onUnFocused() {
    print('Page lost focus');
    // Perform actions when the page loses focus
  }

  @override
  Widget build(BuildContext context) {
    // Your page UI implementation
  }
}
```

initialize the GoFocusWatcher instance with a GoRouter instance:
```dart
final GoRouter router = GoRouter(
  // Route configuration
);

void main() {
  GoFocusWatcher.instance.initilize(router);
  
  runApp(App());
}
```