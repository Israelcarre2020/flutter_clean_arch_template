import 'package:bloc/bloc.dart';
import 'package:logger/logger.dart';

/// Custom BlocObserver to log all bloc events, changes, transitions, and errors
/// This helps with debugging and monitoring the application state management
class AppBlocObserver extends BlocObserver {
  AppBlocObserver(this._logger);
  final Logger _logger;

  @override
  void onCreate(BlocBase bloc) {
    super.onCreate(bloc);
    _logger.i('🟢 onCreate -- ${bloc.runtimeType}');
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    _logger.d(
      '🔄 onChange -- ${bloc.runtimeType}\n'
      'Current State: ${change.currentState}\n'
      'Next State: ${change.nextState}',
    );
  }

  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    _logger.i(
      '📥 onEvent -- ${bloc.runtimeType}\n'
      'Event: $event',
    );
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    _logger.d(
      '🔀 onTransition -- ${bloc.runtimeType}\n'
      'Event: ${transition.event}\n'
      'Current State: ${transition.currentState}\n'
      'Next State: ${transition.nextState}',
    );
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    _logger.e(
      '❌ onError -- ${bloc.runtimeType}',
      error: error,
      stackTrace: stackTrace,
    );
  }

  @override
  void onClose(BlocBase bloc) {
    super.onClose(bloc);
    _logger.i('🔴 onClose -- ${bloc.runtimeType}');
  }
}
