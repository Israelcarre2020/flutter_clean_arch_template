import 'package:dio/dio.dart';
import 'package:gist/features/demo/data/models/joke_model.dart';
import 'package:retrofit/retrofit.dart';

part 'joke_api_service.g.dart';

/// API service for jokes using Retrofit
/// Defines REST API endpoints for joke operations
@RestApi()
abstract class JokeApiService {
  factory JokeApiService(Dio dio, {String baseUrl}) = _JokeApiService;

  /// Get a random joke
  @GET('/random_joke')
  Future<JokeModel> getRandomJoke();

  /// Get jokes by type
  @GET('/jokes/{type}/ten')
  Future<List<JokeModel>> getJokesByType(@Path('type') String type);
}
