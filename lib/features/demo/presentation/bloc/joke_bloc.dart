import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gist/features/demo/domain/usecases/get_jokes_by_type.dart';
import 'package:gist/features/demo/domain/usecases/get_random_joke.dart';
import 'package:gist/features/demo/presentation/bloc/joke_event.dart';
import 'package:gist/features/demo/presentation/bloc/joke_state.dart';

/// BLoC for managing joke-related state and events
class JokeBloc extends Bloc<JokeEvent, JokeState> {

  JokeBloc({
    required GetRandomJoke getRandomJoke,
    required GetJokesByType getJokesByType,
  }) : _getRandomJoke = getRandomJoke,
       _getJokesByType = getJokesByType,
       super(const JokeInitial()) {
    on<GetRandomJokeEvent>(_onGetRandomJoke);
    on<GetJokesByTypeEvent>(_onGetJokesByType);
  }
  final GetRandomJoke _getRandomJoke;
  final GetJokesByType _getJokesByType;

  /// Handle GetRandomJokeEvent
  Future<void> _onGetRandomJoke(
    GetRandomJokeEvent event,
    Emitter<JokeState> emit,
  ) async {
    emit(const JokeLoading());

    final result = await _getRandomJoke();

    result.fold(
      (failure) => emit(JokeError(failure.message)),
      (joke) => emit(JokeLoaded(joke)),
    );
  }

  /// Handle GetJokesByTypeEvent
  Future<void> _onGetJokesByType(
    GetJokesByTypeEvent event,
    Emitter<JokeState> emit,
  ) async {
    emit(const JokeLoading());

    final result = await _getJokesByType(event.type);

    result.fold(
      (failure) => emit(JokeError(failure.message)),
      (jokes) => emit(JokesLoaded(jokes)),
    );
  }
}
