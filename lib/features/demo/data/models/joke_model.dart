import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gist/features/demo/domain/entities/joke.dart';

part 'joke_model.freezed.dart';
part 'joke_model.g.dart';

/// Joke model - data layer
/// Data transfer object with JSON serialization using Freezed
@freezed
class JokeModel with _$JokeModel {
  const factory JokeModel({
    required int id,
    required String type,
    required String setup,
    required String punchline,
  }) = _JokeModel;

  /// Create model from domain entity
  factory JokeModel.fromEntity(Joke joke) {
    return JokeModel(
      id: joke.id,
      type: joke.type,
      setup: joke.setup,
      punchline: joke.punchline,
    );
  }

  const JokeModel._();

  /// Create model from JSON
  factory JokeModel.fromJson(Map<String, dynamic> json) =>
      _$JokeModelFromJson(json);

  /// Convert model to domain entity
  Joke toEntity() {
    return Joke(id: id, type: type, setup: setup, punchline: punchline);
  }
}
