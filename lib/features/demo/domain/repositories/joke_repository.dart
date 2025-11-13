import 'package:gist/core/utils/typedef.dart';
import 'package:gist/features/demo/domain/entities/joke.dart';

/// Repository interface for jokes
/// Defines the contract for data operations (domain layer)
abstract class JokeRepository {
  /// Get a random joke from the data source
  ResultFuture<Joke> getRandomJoke();

  /// Get a list of jokes by type
  ResultFuture<List<Joke>> getJokesByType(String type);
}
