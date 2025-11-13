import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gist/app.dart';
import 'package:gist/core/di/injection_container.dart';
import 'package:gist/core/observers/app_bloc_observer.dart';

/// Main entry point
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize dependencies
  await initializeDependencies();

  // Set BLoC observer
  Bloc.observer = getIt<AppBlocObserver>();

  runApp(const MyApp());
}
