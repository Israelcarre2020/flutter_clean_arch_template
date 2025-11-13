import 'package:dartz/dartz.dart';
import 'package:gist/core/error/exceptions.dart';
import 'package:gist/core/error/failures.dart';
import 'package:gist/core/utils/typedef.dart';
import 'package:gist/features/demo/data/datasources/joke_remote_data_source.dart';
import 'package:gist/features/demo/domain/entities/joke.dart';
import 'package:gist/features/demo/domain/repositories/joke_repository.dart';

/// Implementation of JokeRepository
/// Handles data operations and error handling
class JokeRepositoryImpl implements JokeRepository {

  JokeRepositoryImpl(this._remoteDataSource);
  final JokeRemoteDataSource _remoteDataSource;

  @override
  ResultFuture<Joke> getRandomJoke() async {
    try {
      final result = await _remoteDataSource.getRandomJoke();
      return Right(result.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } on NetworkException {
      return const Left(NetworkFailure());
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  ResultFuture<List<Joke>> getJokesByType(String type) async {
    try {
      final result = await _remoteDataSource.getJokesByType(type);
      final jokes = result.map((model) => model.toEntity()).toList();
      return Right(jokes);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } on NetworkException {
      return const Left(NetworkFailure());
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
