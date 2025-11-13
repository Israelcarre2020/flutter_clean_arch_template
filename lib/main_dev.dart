import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gist/app.dart';
import 'package:gist/core/config/environment_manager.dart';
import 'package:gist/core/di/injection_container.dart';
import 'package:gist/core/observers/app_bloc_observer.dart';

/// Development entry point
/// Initializes app with DEV environment
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize dependencies with DEV environment
  await initializeDependencies(initialEnvironment: Environment.dev);

  // Set BLoC observer
  Bloc.observer = getIt<AppBlocObserver>();

  runApp(const MyApp());
}
