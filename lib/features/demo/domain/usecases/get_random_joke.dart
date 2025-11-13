import 'package:gist/core/utils/typedef.dart';
import 'package:gist/features/demo/domain/entities/joke.dart';
import 'package:gist/features/demo/domain/repositories/joke_repository.dart';

/// Use case to get a random joke
/// Implements the use case pattern from clean architecture
class GetRandomJoke {

  GetRandomJoke(this._repository);
  final JokeRepository _repository;

  ResultFuture<Joke> call() async {
    return _repository.getRandomJoke();
  }
}
