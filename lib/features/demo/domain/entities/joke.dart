import 'package:equatable/equatable.dart';

/// Joke entity - domain layer
/// Represents a joke in the domain layer (clean architecture)
class Joke extends Equatable {

  const Joke({
    required this.id,
    required this.type,
    required this.setup,
    required this.punchline,
  });
  final int id;
  final String type;
  final String setup;
  final String punchline;

  /// Get complete joke text
  String get fullJoke => '$setup\n\n$punchline';

  @override
  List<Object?> get props => [id, type, setup, punchline];
}
