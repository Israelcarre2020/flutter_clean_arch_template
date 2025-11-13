import 'package:gist/core/utils/typedef.dart';
import 'package:gist/features/demo/domain/entities/joke.dart';
import 'package:gist/features/demo/domain/repositories/joke_repository.dart';

/// Use case to get jokes by type
class GetJokesByType {

  GetJokesByType(this._repository);
  final JokeRepository _repository;

  ResultFuture<List<Joke>> call(String type) async {
    return _repository.getJokesByType(type);
  }
}
