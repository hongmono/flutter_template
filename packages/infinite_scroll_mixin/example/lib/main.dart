import 'package:flutter/material.dart';
import 'package:infinite_scroll_mixin/infinite_scroll_mixin.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Infinite Scroll Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Infinite Scroll Demo'),
    );
  }
}

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
