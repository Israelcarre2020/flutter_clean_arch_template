import 'package:gist/features/demo/data/models/joke_model.dart';

/// Remote data source interface for jokes
abstract class JokeRemoteDataSource {
  /// Get a random joke from API
  Future<JokeModel> getRandomJoke();

  /// Get jokes by type from API
  Future<List<JokeModel>> getJokesByType(String type);
}
