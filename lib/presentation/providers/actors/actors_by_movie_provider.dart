import 'package:cinemapedia/domain/entities/actor.dart';
import 'package:cinemapedia/presentation/providers/actors/actors_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final StateNotifierProvider<ActorByMovieNotifier, Map<String, List<Actor>>>
    actorsByMovieProvider = StateNotifierProvider((ref) => ActorByMovieNotifier(
        getActors: ref.watch(actorsRepositoryProvider).getActorsByMovie));

// [
//   718821: List of Instance of 'Actor',
//   123421: List of Instance of 'Actor',
//   929421: List of Instance of 'Actor',
// ]

typedef GetActorsCallBack = Future<List<Actor>> Function(String movieId);

class ActorByMovieNotifier extends StateNotifier<Map<String, List<Actor>>> {
  final GetActorsCallBack getActors;

  ActorByMovieNotifier({required this.getActors}) : super({});

  Future<void> loadActors(String movieId) async {
    if (state[movieId] != null) return;

    final List<Actor> actors = await getActors(movieId);
    state = {...state, movieId: actors};
  }
}   
