import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gist/core/l10n/app_localizations.dart';
import 'package:gist/features/demo/presentation/screens/detail_screen.dart';

void main() {
  Widget makeTestableWidget({String? joke}) {
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: DetailScreen(joke: joke),
    );
  }

  testWidgets('should display joke text when provided', (
    WidgetTester tester,
  ) async {
    // arrange
    const testJoke = 'This is a test joke';

    // act
    await tester.pumpWidget(makeTestableWidget(joke: testJoke));

    // assert
    expect(find.text('Detail Screen'), findsOneWidget);
    expect(find.text('Joke Details'), findsOneWidget);
    expect(find.text(testJoke), findsOneWidget);
    expect(find.text('Go Back'), findsOneWidget);
  });

  testWidgets('should display default message when no joke provided', (
    WidgetTester tester,
  ) async {
    // act
    await tester.pumpWidget(makeTestableWidget());

    // assert
    expect(find.text('No joke provided'), findsOneWidget);
  });

  testWidgets('should have back button', (WidgetTester tester) async {
    // act
    await tester.pumpWidget(makeTestableWidget(joke: 'Test'));

    // assert
    expect(find.byIcon(Icons.arrow_back), findsNWidgets(2)); // AppBar + Button
  });
}
