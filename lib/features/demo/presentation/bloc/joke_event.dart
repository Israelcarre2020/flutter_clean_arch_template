import 'package:equatable/equatable.dart';

/// Base event class for JokeBloc
abstract class JokeEvent extends Equatable {
  const JokeEvent();

  @override
  List<Object?> get props => [];
}

/// Event to fetch a random joke
class GetRandomJokeEvent extends JokeEvent {
  const GetRandomJokeEvent();
}

/// Event to fetch jokes by type
class GetJokesByTypeEvent extends JokeEvent {

  const GetJokesByTypeEvent(this.type);
  final String type;

  @override
  List<Object?> get props => [type];
}
