import 'package:equatable/equatable.dart';
import 'package:gist/features/demo/domain/entities/joke.dart';

/// Base state class for JokeBloc
abstract class JokeState extends Equatable {
  const JokeState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class JokeInitial extends JokeState {
  const JokeInitial();
}

/// Loading state
class JokeLoading extends JokeState {
  const JokeLoading();
}

/// Success state for single joke
class JokeLoaded extends JokeState {

  const JokeLoaded(this.joke);
  final Joke joke;

  @override
  List<Object?> get props => [joke];
}

/// Success state for multiple jokes
class JokesLoaded extends JokeState {

  const JokesLoaded(this.jokes);
  final List<Joke> jokes;

  @override
  List<Object?> get props => [jokes];
}

/// Error state
class JokeError extends JokeState {

  const JokeError(this.message);
  final String message;

  @override
  List<Object?> get props => [message];
}
