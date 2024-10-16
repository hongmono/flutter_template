import 'package:go_focus_mixin/src/go_focus_mixin.dart';
import 'package:go_router/go_router.dart';

/// Singleton class for watching focused page. using GoRouter
class GoFocusWatcher {
  GoFocusWatcher._internal();

  static final GoFocusWatcher instance = GoFocusWatcher._internal();

  GoRoute? previousRoute;

  late GoRouter router;

  Map<GoRoute, Set<GoFocusMixin>> listeners = <GoRoute, Set<GoFocusMixin>>{};

  void initialize(GoRouter router) {
    this.router = router;

    this.router.routerDelegate.addListener(onRouteChanged);
  }

  void subscribe(GoFocusMixin page) {
    final route = router.routerDelegate.currentConfiguration.lastOrNull?.route;
    if (route == null) throw Exception('Route is not found');

    final Set<GoFocusMixin> subscribers =
        listeners.putIfAbsent(route, () => <GoFocusMixin>{});
    if (subscribers.add(page)) {
      page.onFocused(true);
    }
  }

  void unsubscribe(GoFocusMixin page) {
    final List<GoRoute> routes = listeners.keys.toList();
    for (final GoRoute route in routes) {
      final Set<GoFocusMixin>? subscribers = listeners[route];
      if (subscribers != null) {
        subscribers.remove(page);
        if (subscribers.isEmpty) {
          listeners.remove(route);
        }
      }
    }
  }

  void onRouteChanged() {
    final Set<GoFocusMixin>? previousSubscribers = listeners[previousRoute];
    if (previousSubscribers != null) {
      for (final GoFocusMixin route in previousSubscribers) {
        route.onUnfocused();
      }
    }

    final route = router.routerDelegate.currentConfiguration.lastOrNull?.route;
    final Set<GoFocusMixin>? subscribers = listeners[route];

    if (subscribers != null) {
      for (final GoFocusMixin route in subscribers) {
        route.onFocused(false);
      }
    }

    previousRoute = route;
  }
}
