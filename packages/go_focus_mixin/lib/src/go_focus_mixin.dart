import 'package:GoFocusMixin/src/go_focus_watcher.dart';
import 'package:flutter/material.dart';

mixin GoFocusMixin<T extends StatefulWidget> on State<T> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      GoFocusWatcher.instance.subscribe(this);
    });
  }

  @override
  void dispose() {
    GoFocusWatcher.instance.unsubscribe(this);

    super.dispose();
  }

  void onFocused(bool isFirstTime) {}

  void onUnfocused() {}
}
