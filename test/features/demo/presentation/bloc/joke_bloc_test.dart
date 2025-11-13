import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gist/core/error/failures.dart';
import 'package:gist/features/demo/domain/entities/joke.dart';
import 'package:gist/features/demo/domain/usecases/get_jokes_by_type.dart';
import 'package:gist/features/demo/domain/usecases/get_random_joke.dart';
import 'package:gist/features/demo/presentation/bloc/joke_bloc.dart';
import 'package:gist/features/demo/presentation/bloc/joke_event.dart';
import 'package:gist/features/demo/presentation/bloc/joke_state.dart';
import 'package:mocktail/mocktail.dart';

class MockGetRandomJoke extends Mock implements GetRandomJoke {}

class MockGetJokesByType extends Mock implements GetJokesByType {}

void main() {
  late JokeBloc bloc;
  late MockGetRandomJoke mockGetRandomJoke;
  late MockGetJokesByType mockGetJokesByType;

  setUp(() {
    mockGetRandomJoke = MockGetRandomJoke();
    mockGetJokesByType = MockGetJokesByType();
    bloc = JokeBloc(
      getRandomJoke: mockGetRandomJoke,
      getJokesByType: mockGetJokesByType,
    );
  });

  tearDown(() {
    bloc.close();
  });

  group('JokeBloc', () {
    const tJoke = Joke(
      id: 1,
      type: 'general',
      setup: 'Why did the chicken cross the road?',
      punchline: 'To get to the other side!',
    );

    const tJokes = [
      Joke(
        id: 1,
        type: 'programming',
        setup: 'Why do programmers prefer dark mode?',
        punchline: 'Because light attracts bugs!',
      ),
    ];

    test('initial state should be JokeInitial', () {
      expect(bloc.state, equals(const JokeInitial()));
    });

    blocTest<JokeBloc, JokeState>(
      'should emit [JokeLoading, JokeLoaded] when GetRandomJokeEvent is successful',
      build: () {
        when(
          () => mockGetRandomJoke(),
        ).thenAnswer((_) async => const Right(tJoke));
        return bloc;
      },
      act: (bloc) => bloc.add(const GetRandomJokeEvent()),
      expect: () => [const JokeLoading(), const JokeLoaded(tJoke)],
      verify: (_) {
        verify(() => mockGetRandomJoke()).called(1);
      },
    );

    blocTest<JokeBloc, JokeState>(
      'should emit [JokeLoading, JokeError] when GetRandomJokeEvent fails',
      build: () {
        when(() => mockGetRandomJoke()).thenAnswer(
          (_) async => const Left(ServerFailure(message: 'Server error')),
        );
        return bloc;
      },
      act: (bloc) => bloc.add(const GetRandomJokeEvent()),
      expect: () => [const JokeLoading(), const JokeError('Server error')],
    );

    blocTest<JokeBloc, JokeState>(
      'should emit [JokeLoading, JokesLoaded] when GetJokesByTypeEvent is successful',
      build: () {
        when(
          () => mockGetJokesByType('programming'),
        ).thenAnswer((_) async => const Right(tJokes));
        return bloc;
      },
      act: (bloc) => bloc.add(const GetJokesByTypeEvent('programming')),
      expect: () => [const JokeLoading(), const JokesLoaded(tJokes)],
      verify: (_) {
        verify(() => mockGetJokesByType('programming')).called(1);
      },
    );

    blocTest<JokeBloc, JokeState>(
      'should emit [JokeLoading, JokeError] when GetJokesByTypeEvent fails',
      build: () {
        when(() => mockGetJokesByType('programming')).thenAnswer(
          (_) async => const Left(ServerFailure(message: 'No jokes found')),
        );
        return bloc;
      },
      act: (bloc) => bloc.add(const GetJokesByTypeEvent('programming')),
      expect: () => [const JokeLoading(), const JokeError('No jokes found')],
    );
  });
}
