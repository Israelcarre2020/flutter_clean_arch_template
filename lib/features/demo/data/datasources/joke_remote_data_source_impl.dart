import 'package:dio/dio.dart';
import 'package:gist/core/error/exceptions.dart';
import 'package:gist/features/demo/data/datasources/joke_api_service.dart';
import 'package:gist/features/demo/data/datasources/joke_remote_data_source.dart';
import 'package:gist/features/demo/data/models/joke_model.dart';

/// Implementation of remote data source using Retrofit API service
class JokeRemoteDataSourceImpl implements JokeRemoteDataSource {

  JokeRemoteDataSourceImpl(this._apiService);
  final JokeApiService _apiService;

  @override
  Future<JokeModel> getRandomJoke() async {
    try {
      final joke = await _apiService.getRandomJoke();
      return joke;
    } on DioException catch (e) {
      throw ServerException(
        message: e.message ?? 'Failed to get random joke',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      throw ServerException(
        message: e.toString(),
      );
    }
  }

  @override
  Future<List<JokeModel>> getJokesByType(String type) async {
    try {
      final jokes = await _apiService.getJokesByType(type);
      return jokes;
    } on DioException catch (e) {
      throw ServerException(
        message: e.message ?? 'Failed to get jokes by type',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      throw ServerException(
        message: e.toString(),
      );
    }
  }
}
