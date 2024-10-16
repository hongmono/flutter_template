import 'package:flutter/material.dart';

/// A mixin that provides functionality to detect when scrolling reaches the top
/// and allows scrolling to the top of a scrollable widget.
///
/// This mixin can be applied to a [State] of a [StatefulWidget] and automatically
/// manages a scroll controller.
///
/// Example usage:
/// ```dart
/// class MyScrollableWidget extends StatefulWidget {
///   @override
///   _MyScrollableWidgetState createState() => _MyScrollableWidgetState();
/// }
///
/// class _MyScrollableWidgetState extends State<MyScrollableWidget> with ScrollToTopMixin {
///   @override
///   Widget build(BuildContext context) {
///     return Scaffold(
///       appBar: AppBar(title: Text('Scrollable List')),
///       body: ListView.builder(
///         controller: scrollToTopController,
///         itemCount: 100,
///         itemBuilder: (context, index) => ListTile(title: Text('Item $index')),
///       ),
///       floatingActionButton: FloatingActionButton(
///         child: Icon(Icons.arrow_upward),
///         onPressed: scrollToTop,  // Use the scrollToTop function
///       ),
///     );
///   }
///
///   @override
///   void onAttach() {
///     print('Scroll reached the top');
///   }
///
///   @override
///   void onDetach() {
///     print('Scroll left the top');
///   }
/// }
/// ```
///
/// Configurable properties:
/// - [offset]: The target offset when scrolling to the top. Defaults to 0.
/// - [duration]: The duration of the scroll animation. Defaults to 300 milliseconds.
/// - [curve]: The curve of the scroll animation. Defaults to [Curves.easeInOut].
/// - [threshold]: The threshold to consider as the top. Defaults to 0.
///
/// Override [onAttach] and [onDetach] methods to define custom behavior
/// when the scroll reaches or leaves the top.
mixin ScrollToTopMixin<T extends StatefulWidget> on State<T> {
  final ScrollController scrollToTopController = ScrollController();
  bool _isTop = true;

  double offset = 0;
  Duration duration = const Duration(milliseconds: 300);
  Curve curve = Curves.easeInOut;
  double threshold = 0;

  @override
  void initState() {
    super.initState();

    scrollToTopController.addListener(_onScroll);
  }

  @override
  void dispose() {
    scrollToTopController.removeListener(_onScroll);
    scrollToTopController.dispose();

    super.dispose();
  }

  void scrollToTop() {
    if (scrollToTopController.hasClients == false) return;
    if (scrollToTopController.offset == 0) return;

    scrollToTopController.animateTo(
      offset,
      duration: duration,
      curve: curve,
    );
  }

  void _onScroll() {
    final isTop = scrollToTopController.offset <= threshold;
    if (_isTop != isTop) {
      _isTop = isTop;
      isTop ? onAttach() : onDetach();
    }
  }

  void onAttach() {}

  void onDetach() {}
}
