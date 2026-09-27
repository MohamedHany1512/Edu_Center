import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Logs bloc transitions and errors.
///
/// Verbose state dumps are disabled in release builds to avoid leaking
/// sensitive data (e.g. session payloads) into production logs.
class AppBlocObserver extends BlocObserver {
  const AppBlocObserver();

  /// `true` to print the current/next state of every transition.
  static const bool _debugStateChanges = kDebugMode;

  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    if (!_debugStateChanges) return;

    debugPrint('${bloc.runtimeType} $change');
    debugPrint('  currentState: ${change.currentState}');
    debugPrint('  nextState:    ${change.nextState}');
  }

  @override
  void onError(
    BlocBase<dynamic> bloc,
    Object error,
    StackTrace stackTrace,
  ) {
    debugPrint('${bloc.runtimeType} error: $error');
    debugPrint(stackTrace.toString());
    super.onError(bloc, error, stackTrace);
  }
}
