import 'package:flutter/material.dart';

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
