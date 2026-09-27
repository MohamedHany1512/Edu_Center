import 'package:edu_app/core/routing/routes.dart';
import 'package:flutter/material.dart';

 
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

 
extension AppNavigation on BuildContext {
 
  Future<T?> pushRoute<T>(String route, {Object? arguments}) {
    return Navigator.of(this).pushNamed<T>(route, arguments: arguments);
  }

 
  Future<T?> replaceRoute<T>(String route, {Object? arguments}) {
    return Navigator.of(this).pushReplacementNamed<T, void>(
      route,
      arguments: arguments,
    );
  }

  /// Pops the current route, if it is safe to do so.
  ///
  /// Guards against popping the last route, which would leave a black screen.
  void popRoute<T>([T? result]) {
    final navigator = Navigator.of(this);
    if (navigator.canPop()) {
      navigator.pop<T>(result);
    }
  }

  /// Pops every route until the first one, then hands control back to
  /// whatever gate page is mounted as the app root (e.g. `AuthGate`).
  void popToRoot<T>() {
    Navigator.of(this).popUntil((route) => route.isFirst);
  }

  /// Convenience wrappers for the app's named routes.
  Future<void> pushCourseDetails(Object course) =>
      pushRoute<void>(Routes.courseDetails, arguments: course);

  Future<void> pushCourseVideos(Object course) =>
      pushRoute<void>(Routes.courseVideos, arguments: course);
}
