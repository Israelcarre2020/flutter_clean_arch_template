import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gist/core/config/app_config.dart';
import 'package:gist/core/config/environment.dart';
import 'package:gist/core/config/environment_manager.dart' hide Environment;
import 'package:gist/core/di/injection_container.dart';
import 'package:gist/core/l10n/app_localizations.dart';
import 'package:gist/core/l10n/locale_cubit.dart';
import 'package:gist/core/theme/theme_cubit.dart';
import 'package:gist/features/demo/domain/entities/joke.dart';
import 'package:gist/features/demo/presentation/bloc/joke_bloc.dart';
import 'package:gist/features/demo/presentation/bloc/joke_event.dart';
import 'package:gist/features/demo/presentation/bloc/joke_state.dart';
import 'package:gist/features/demo/presentation/screens/demo_screen.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockJokeBloc extends Mock implements JokeBloc {}

class MockThemeCubit extends Mock implements ThemeCubit {}

class MockLocaleCubit extends Mock implements LocaleCubit {}

class FakeJokeEvent extends Fake implements JokeEvent {}

class FakeJokeState extends Fake implements JokeState {}

void main() {
  late MockJokeBloc mockJokeBloc;
  late MockThemeCubit mockThemeCubit;
  late MockLocaleCubit mockLocaleCubit;

  setUpAll(() {
    registerFallbackValue(FakeJokeEvent());
    registerFallbackValue(FakeJokeState());
  });

  setUp(() async {
    mockJokeBloc = MockJokeBloc();
    mockThemeCubit = MockThemeCubit();
    mockLocaleCubit = MockLocaleCubit();

    // Setup SharedPreferences for tests
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    // Setup GetIt for tests
    if (getIt.isRegistered<JokeBloc>()) {
      await getIt.unregister<JokeBloc>();
    }
    if (getIt.isRegistered<EnvironmentManager>()) {
      await getIt.unregister<EnvironmentManager>();
    }
    if (getIt.isRegistered<AppConfig>()) {
      await getIt.unregister<AppConfig>();
    }

    // Stub the close method to return a completed Future
    when(() => mockJokeBloc.close()).thenAnswer((_) async {});

    getIt.registerSingleton<JokeBloc>(mockJokeBloc);
    getIt.registerSingleton<EnvironmentManager>(EnvironmentManager(prefs));
    getIt.registerSingleton<AppConfig>(
      const AppConfig(
        environment: Environment.dev,
        apiBaseUrl: 'https://test.api.com',
        appName: 'Test App',
        enableLogger: true,
        apiTimeout: Duration(seconds: 30),
      ),
    );

    // Setup default mock returns
    when(() => mockThemeCubit.state).thenReturn(ThemeMode.light);
    when(() => mockThemeCubit.stream).thenAnswer((_) => const Stream.empty());
    when(() => mockLocaleCubit.state).thenReturn(const Locale('en'));
    when(() => mockLocaleCubit.stream).thenAnswer((_) => const Stream.empty());
  });

  tearDown(() async {
    if (getIt.isRegistered<JokeBloc>()) {
      await getIt.unregister<JokeBloc>();
    }
    if (getIt.isRegistered<EnvironmentManager>()) {
      await getIt.unregister<EnvironmentManager>();
    }
    if (getIt.isRegistered<AppConfig>()) {
      await getIt.unregister<AppConfig>();
    }
  });

  Widget makeTestableWidget() {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ThemeCubit>.value(value: mockThemeCubit),
        BlocProvider<LocaleCubit>.value(value: mockLocaleCubit),
      ],
      child: const MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: DemoScreen(),
      ),
    );
  }

  testWidgets('should show loading indicator when state is JokeLoading', (
    WidgetTester tester,
  ) async {
    // arrange
    when(() => mockJokeBloc.state).thenReturn(const JokeLoading());
    when(() => mockJokeBloc.stream).thenAnswer((_) => const Stream.empty());

    // act
    await tester.pumpWidget(makeTestableWidget());

    // assert
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('should show error message when state is JokeError', (
    WidgetTester tester,
  ) async {
    // arrange
    const errorMessage = 'Server error';
    when(() => mockJokeBloc.state).thenReturn(const JokeError(errorMessage));
    when(() => mockJokeBloc.stream).thenAnswer((_) => const Stream.empty());

    // act
    await tester.pumpWidget(makeTestableWidget());

    // assert
    expect(find.text('Error'), findsOneWidget);
    expect(find.text(errorMessage), findsOneWidget);
    expect(find.text('Try Again'), findsOneWidget);
  });

  testWidgets('should display joke when state is JokeLoaded', (
    WidgetTester tester,
  ) async {
    // arrange
    const tJoke = Joke(
      id: 1,
      type: 'general',
      setup: 'Why did the chicken cross the road?',
      punchline: 'To get to the other side!',
    );

    when(() => mockJokeBloc.state).thenReturn(const JokeLoaded(tJoke));
    when(() => mockJokeBloc.stream).thenAnswer((_) => const Stream.empty());

    // act
    await tester.pumpWidget(makeTestableWidget());

    // assert
    expect(find.text(tJoke.setup), findsOneWidget);
    expect(find.text(tJoke.punchline), findsOneWidget);
    expect(find.text('Get Another Joke'), findsOneWidget);
    expect(find.text('View Details'), findsOneWidget);
  });

  testWidgets('should trigger GetRandomJokeEvent when refresh button is tapped', (
    WidgetTester tester,
  ) async {
    // arrange
    const tJoke = Joke(
      id: 1,
      type: 'general',
      setup: 'Test setup',
      punchline: 'Test punchline',
    );

    when(() => mockJokeBloc.state).thenReturn(const JokeLoaded(tJoke));
    when(() => mockJokeBloc.stream).thenAnswer((_) => const Stream.empty());
    when(() => mockJokeBloc.add(any())).thenReturn(null);

    // act
    await tester.pumpWidget(makeTestableWidget());
    // Reset interactions to ignore the initial GetRandomJokeEvent triggered by BlocProvider.create
    reset(mockJokeBloc);
    when(() => mockJokeBloc.state).thenReturn(const JokeLoaded(tJoke));
    when(() => mockJokeBloc.stream).thenAnswer((_) => const Stream.empty());
    when(() => mockJokeBloc.add(any())).thenReturn(null);
    when(() => mockJokeBloc.close()).thenAnswer((_) async {});

    await tester.tap(find.text('Get Another Joke'));
    await tester.pump();

    // assert
    verify(() => mockJokeBloc.add(const GetRandomJokeEvent())).called(1);
  });
}
