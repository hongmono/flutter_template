import 'package:flutter/material.dart';
import 'package:scroll_to_top_mixin/scroll_to_top_mixin.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Scroll To Top Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Scroll To Top Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with ScrollToTopMixin {
  final List<String> items = List.generate(50, (index) => 'Item $index');
  bool isTop = true;

  @override
  // TODO: implement threshold
  double get threshold => 100;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Stack(
        children: [
          ListView.builder(
            controller: scrollToTopController,
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];

              return ListTile(title: Text(item));
            },
          ),
          if (!isTop)
            Positioned(
              bottom: 32,
              left: 32,
              right: 32,
              child: FloatingActionButton(
                onPressed: scrollToTop,
                backgroundColor: Colors.grey.withOpacity(0.3),
                splashColor: Colors.transparent,
                elevation: 0,
                child: const Icon(Icons.arrow_upward),
              ),
            ),
        ],
      ),
    );
  }

  @override
  void onAttach() {
    print('Attached');

    setState(() {
      isTop = true;
    });
  }

  @override
  void onDetach() {
    print('Detached');

    setState(() {
      isTop = false;
    });
  }
}
