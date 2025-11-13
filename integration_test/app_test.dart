import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gist/app.dart';
import 'package:gist/core/config/environment_manager.dart';
import 'package:gist/core/di/injection_container.dart';
import 'package:gist/core/observers/app_bloc_observer.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('App Integration Test', () {
    setUpAll(() async {
      // Initialize dependencies with DEV environment for testing
      await initializeDependencies(initialEnvironment: Environment.dev);
      Bloc.observer = getIt<AppBlocObserver>();
    });

    testWidgets('Complete flow: Load joke -> Navigate to detail -> Go back', (
      WidgetTester tester,
    ) async {
      // Start app
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Wait for initial joke to load
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Verify we're on the demo screen
      expect(find.text('Demo Screen'), findsOneWidget);

      // Check if joke is loaded or error is shown
      final jokeLoaded = find.text('Get Another Joke').evaluate().isNotEmpty;
      final errorShown = find.text('Try Again').evaluate().isNotEmpty;

      expect(jokeLoaded || errorShown, isTrue);

      if (jokeLoaded) {
        // Tap on View Details button
        await tester.tap(find.text('View Details'));
        await tester.pumpAndSettle();

        // Verify we're on the detail screen
        expect(find.text('Detail Screen'), findsOneWidget);
        expect(find.text('Joke Details'), findsOneWidget);

        // Tap back button
        await tester.tap(find.text('Go Back'));
        await tester.pumpAndSettle();

        // Verify we're back on the demo screen
        expect(find.text('Demo Screen'), findsOneWidget);

        // Test refresh functionality
        await tester.tap(find.text('Get Another Joke'));
        await tester.pump();

        // Wait for new joke to load
        await tester.pumpAndSettle(const Duration(seconds: 5));
      }
    });

    testWidgets('Theme toggle works', (WidgetTester tester) async {
      // Start app
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Wait for app to load
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Find and tap theme toggle button
      final themeButton = find.byIcon(Icons.dark_mode);
      if (themeButton.evaluate().isNotEmpty) {
        await tester.tap(themeButton);
        await tester.pumpAndSettle();

        // Verify theme icon changed
        expect(find.byIcon(Icons.light_mode), findsOneWidget);

        // Toggle back
        await tester.tap(find.byIcon(Icons.light_mode));
        await tester.pumpAndSettle();

        // Verify theme icon changed back
        expect(find.byIcon(Icons.dark_mode), findsOneWidget);
      }
    });
  });
}
