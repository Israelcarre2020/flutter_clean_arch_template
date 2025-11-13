import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gist/features/demo/data/datasources/joke_remote_data_source.dart';
import 'package:gist/features/demo/data/models/joke_model.dart';
import 'package:gist/features/demo/data/repositories/joke_repository_impl.dart';
import 'package:gist/features/demo/domain/entities/joke.dart';
import 'package:mocktail/mocktail.dart';

class MockJokeRemoteDataSource extends Mock implements JokeRemoteDataSource {}

void main() {
  late JokeRepositoryImpl repository;
  late MockJokeRemoteDataSource mockRemoteDataSource;

  setUp(() {
    mockRemoteDataSource = MockJokeRemoteDataSource();
    repository = JokeRepositoryImpl(mockRemoteDataSource);
  });

  group('getRandomJoke', () {
    const tJokeModel = JokeModel(
      id: 1,
      type: 'general',
      setup: 'Why did the chicken cross the road?',
      punchline: 'To get to the other side!',
    );

    const tJoke = Joke(
      id: 1,
      type: 'general',
      setup: 'Why did the chicken cross the road?',
      punchline: 'To get to the other side!',
    );

    test(
      'should return Joke when call to remote data source is successful',
      () async {
        // arrange
        when(
          () => mockRemoteDataSource.getRandomJoke(),
        ).thenAnswer((_) async => tJokeModel);

        // act
        final result = await repository.getRandomJoke();

        // assert
        expect(result, equals(const Right(tJoke)));
        verify(() => mockRemoteDataSource.getRandomJoke()).called(1);
        verifyNoMoreInteractions(mockRemoteDataSource);
      },
    );

    test(
      'should return ServerFailure when call to remote data source fails',
      () async {
        // arrange
        when(
          () => mockRemoteDataSource.getRandomJoke(),
        ).thenThrow(Exception('Server error'));

        // act
        final result = await repository.getRandomJoke();

        // assert
        expect(result.isLeft(), true);
        verify(() => mockRemoteDataSource.getRandomJoke()).called(1);
      },
    );
  });

  group('getJokesByType', () {
    const tType = 'programming';
    const tJokeModels = [
      JokeModel(
        id: 1,
        type: 'programming',
        setup: 'Why do programmers prefer dark mode?',
        punchline: 'Because light attracts bugs!',
      ),
    ];

    const tJokes = [
      Joke(
        id: 1,
        type: 'programming',
        setup: 'Why do programmers prefer dark mode?',
        punchline: 'Because light attracts bugs!',
      ),
    ];

    test('should return list of Jokes when call is successful', () async {
      // arrange
      when(
        () => mockRemoteDataSource.getJokesByType(any()),
      ).thenAnswer((_) async => tJokeModels);

      // act
      final result = await repository.getJokesByType(tType);

      // assert
      expect(result.isRight(), true);
      result.fold(
        (failure) => fail('Expected Right but got Left'),
        (jokes) => expect(jokes, tJokes),
      );
      verify(() => mockRemoteDataSource.getJokesByType(tType)).called(1);
    });
  });
}
