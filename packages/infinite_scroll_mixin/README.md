# InfiniteScrollMixin

A Flutter package that provides a mixin for infinite scrolling functionality.

## Features

- Infinite scrolling functionality

## Getting started
Add `infinite_scroll_mixin` to your `pubspec.yaml` file:

```yaml
dependencies:
  infinite_scroll_mixin: ^1.0.0
```

import the package in your Dart code:

```dart
import 'package:infinite_scroll_mixin/infinite_scroll_mixin.dart';
```


Add the mixin to your page class and implement the loadMore:
```dart
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with InfiniteScrollMixin {
  final List<String> items = List.generate(10, (index) => 'Item $index');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView.builder(
        controller: infiniteScrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: items.length + 1,
        itemBuilder: (context, index) {
          if (index == items.length) {
            return isLoading
                ? buildProgressIndicator()
                : const SizedBox.shrink();
          }
          final item = items[index];

          return ListTile(title: Text(item));
        },
      ),
    );
  }

  @override
  Future<void> loadMore() async {
    await Future.delayed(const Duration(seconds: 2));
    final newItems =
        List.generate(10, (index) => 'Item ${items.length + index}');
    items.addAll(newItems);

    setState(() {});
  }
}

```
