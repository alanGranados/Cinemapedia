import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/presentation/providers/movies/movie_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final StateNotifierProvider<MovieMapNotifier, Map<String, Movie>>
    movieInfoProvider = StateNotifierProvider((ref) => MovieMapNotifier(
        getMovie: ref.watch(movieRepositoryProvider).getMovieById));


// [
//   718821: Instance of 'Movie',
//   123421: Instance of 'Movie',
//   929421: Instance of 'Movie',W
// ]

typedef GetMovieCallBack = Future<Movie> Function(String movieId);

class MovieMapNotifier extends StateNotifier<Map<String, Movie>> {
  final GetMovieCallBack getMovie;

  MovieMapNotifier({required this.getMovie}) : super({});

  Future<void> loadMovie(String movieId) async {
    if (state[movieId] != null) return;

    final Movie movie = await getMovie(movieId);
    state = {...state, movieId: movie};
  }
}
