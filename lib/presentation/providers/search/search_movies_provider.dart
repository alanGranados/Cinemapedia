import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/presentation/providers/movies/movie_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final StateProvider<String> searchQueryProvider = StateProvider(
  (ref) => '',
);

final searchedMoviesProvier =
    StateNotifierProvider<SearchedMoviesNotifier, List<Movie>>((ref) {
  final movieRepository = ref.read(movieRepositoryProvider);

  return SearchedMoviesNotifier(
      searchedMovies: movieRepository.searchMovies, ref: ref 
  );
});

typedef SearchedMoviesCallback = Future<List<Movie>> Function(String query);

class SearchedMoviesNotifier extends StateNotifier<List<Movie>> {
  final SearchedMoviesCallback searchedMovies;
  final Ref ref;

  SearchedMoviesNotifier({
    required this.searchedMovies,
    required this.ref,
  }) : super([]);

  Future<List<Movie>> searchedMoviesByQuery(String query) async {
    final List<Movie> movies = await searchedMovies(query);
    ref.read(searchQueryProvider.notifier).update((state) => query);
    state = movies;
    return movies;
  }
}
