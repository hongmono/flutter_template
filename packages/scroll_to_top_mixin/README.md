# ScrollToTopMixin

A Flutter package that provides a mixin for scroll to top functionality.

## Features

- Scroll to top functionality

## Getting started
Add `scroll_to_top_mixin` to your `pubspec.yaml` file:

```yaml
dependencies:
  scroll_to_top_mixin: ^1.0.0
```

import the package in your Dart code:

```dart
import 'package:scroll_to_top_mixin/scroll_to_top_mixin.dart';
```


Add the mixin to your page class and implement the onAttach and onDetach:
```dart
class MyScrollableWidget extends StatefulWidget {
  @override
  _MyScrollableWidgetState createState() => _MyScrollableWidgetState();
}

class _MyScrollableWidgetState extends State<MyScrollableWidget> with ScrollToTopMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Scrollable List')),
      body: ListView.builder(
        controller: scrollToTopController,
        itemCount: 100,
        itemBuilder: (context, index) => ListTile(title: Text('Item $index')),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.arrow_upward),
        onPressed: scrollToTop,  // Use the scrollToTop function
      ),
    );
  }

  @override
  void onAttach() {
    print('Scroll reached the top');
  }

  @override
  void onDetach() {
    print('Scroll left the top');
  }
}
```
