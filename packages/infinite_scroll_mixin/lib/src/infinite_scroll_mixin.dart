import 'package:flutter/material.dart';

/// A mixin that provides infinite scrolling functionality for scrollable widgets.
///
/// This mixin can be applied to a [State] of a [StatefulWidget] to implement
/// infinite scrolling with automatic loading of more items when the user
/// reaches the bottom of the scroll view.
///
/// Example usage:
/// ```dart
/// class MyInfiniteScrollWidget extends StatefulWidget {
///   @override
///   _MyInfiniteScrollWidgetState createState() => _MyInfiniteScrollWidgetState();
/// }
///
/// class _MyInfiniteScrollWidgetState extends State<MyInfiniteScrollWidget> with InfiniteScrollMixin {
///   List<String> items = [];
///
///   @override
///   Widget build(BuildContext context) {
///     return ListView.builder(
///       controller: infiniteScrollController,
///       itemCount: items.length + 1,
///       itemBuilder: (context, index) {
///         if (index == items.length) {
///           return buildProgressIndicator();
///         }
///         return ListTile(title: Text(items[index]));
///       },
///     );
///   }
///
///   @override
///   Future<void> loadMore() async {
///     // Simulate API call
///     await Future.delayed(Duration(seconds: 2));
///     setState(() {
///       items.addAll(['Item ${items.length + 1}', 'Item ${items.length + 2}', 'Item ${items.length + 3}']);
///     });
///   }
/// }
/// ```
///
/// Key properties and methods:
/// - [infiniteScrollController]: The [ScrollController] used for the scrollable widget.
/// - [isLoading]: A boolean flag indicating whether more items are currently being loaded.
/// - [currentPage]: An integer representing the current page of loaded items.
/// - [loadMore]: An abstract method that should be implemented to load more items.
/// - [buildProgressIndicator]: A method that returns a widget to display while loading more items.
///
/// Override the [loadMore] method to implement the logic for loading additional items.
/// This method will be called automatically when the user scrolls to the bottom of the list.
mixin InfiniteScrollMixin<T extends StatefulWidget> on State<T> {
  ScrollController infiniteScrollController = ScrollController();
  bool isLoading = false;
  int currentPage = 1;

  @override
  void initState() {
    super.initState();
    infiniteScrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    infiniteScrollController.removeListener(_onScroll);
    infiniteScrollController.dispose();
    super.dispose();
  }

  Future<void> loadMore();

  void _onScroll() {
    final maxScroll = infiniteScrollController.position.maxScrollExtent;
    final currentScroll = infiniteScrollController.position.pixels;
    if (currentScroll >= maxScroll) {
      _loadMoreItems();
    }
  }

  Future<void> _loadMoreItems() async {
    if (!isLoading) {
      setState(() {
        isLoading = true;
      });

      await loadMore();

      setState(() {
        isLoading = false;
        currentPage++;
      });
    }
  }

  Widget buildProgressIndicator() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
