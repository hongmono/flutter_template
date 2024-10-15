import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';

class RouteLog {
  final GoRoute route;
  final GoRoute? previousRoute;
  final String? fullPath;
  final Duration? duration;

  RouteLog({
    required this.route,
    required this.previousRoute,
    required this.fullPath,
    required this.duration,
  });

  @override
  String toString() {
    final buffer = StringBuffer();
    buffer.writeln();
    buffer.write('Move from [${previousRoute?.name}]');
    buffer.writeln(' to [${route.name}]');
    buffer.write('Stay on [${previousRoute?.name}]');
    buffer.writeln(' ${duration?.inSeconds}s');
    buffer.write('Full path: $fullPath');

    return buffer.toString();
  }
}

class GoRouterWatcher with ChangeNotifier {
  static final GoRouterWatcher instance = GoRouterWatcher._();

  GoRouterWatcher._();

  GoRoute? _lastRoute;
  GoRoute? _currentRoute;
  DateTime? _lastTime;
  String? _fullPath;

  String get currentRouteName => _currentRoute?.name ?? 'unknown';
  String get fullPath => _fullPath ?? 'unknown';

  late final GoRouter _router;

  late final Function(RouteLog)? _log;

  void initialize(GoRouter router, {required Function(RouteLog) log}) {
    _router = router;
    _log = log;

    _router.routerDelegate.addListener(_onRouteChanged);
  }

  void _onRouteChanged() {
    final route = _router.routerDelegate.currentConfiguration.lastOrNull?.route;

    final buffer = StringBuffer();
    for (final route in _router.routerDelegate.currentConfiguration.routes) {
      if (route is GoRoute) {
        buffer.write('/${route.path}');
      }
    }

    if (route == null) return;

    _currentRoute = route;
    _fullPath = buffer.toString().replaceAll(RegExp(r'/+'), '/');

    RouteLog log = RouteLog(
      route: _currentRoute!,
      previousRoute: _lastRoute,
      fullPath: _fullPath,
      duration: DateTime.now().difference(_lastTime ?? DateTime.now()),
    );

    _log?.call(log);

    _lastTime = DateTime.now();
    _lastRoute = route;
  }
}
