import 'package:flutter/material.dart';

class Navigate {
  // Initialize the navigator key
  static void init() {
    // Create a new global key for the navigator state
    _navigatorKey = GlobalKey<NavigatorState>();
  }

  // The global key for the navigator state
  static GlobalKey<NavigatorState>? _navigatorKey;

  // Get the navigator key and assert that it is not null
  static get navigatorKey {
    // Make sure that the navigator key has been initialized before accessing it
    assert(_navigatorKey != null,
        'you need to call the init function in the main');
    // Return the navigator key as a non-nullable value
    return _navigatorKey!;
  }

  // Get the current navigator state
  static NavigatorState get _navigator => navigatorKey.currentState!;

  // Navigate to a named route
  static toNamed(String routeName, {Object? arguments}) =>
      _navigator.pushNamed(routeName);

  // Pop the navigator stack until a predicate is true
  static backUntil(RoutePredicate predicate) => _navigator.popUntil(predicate);

  // Navigate to a page and return a future with the result
  static Future<T?> to<T extends Object?>(Widget page) =>
      _navigator.push<T>(MaterialPageRoute(builder: (_) => page));

  // Replace the current page with a new page
  static off(Widget page) =>
      _navigator.pushReplacement(MaterialPageRoute(builder: (_) => page));

  // Replace the current page with a named route
  static offNamed(String routeName) =>
      _navigator.pushReplacementNamed(routeName);

  // Pop the navigator stack with an optional result
  static back<T extends Object?>([T? result]) => _navigator.pop(result);
}
