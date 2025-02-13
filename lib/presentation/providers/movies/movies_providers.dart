import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/presentation/providers/movies/movie_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final StateNotifierProvider<MoviesNotifier, List<Movie>>
    nowPlayingMoviesProvider = StateNotifierProvider((ref) => MoviesNotifier(
        fecthMoreMoives: ref.watch(movieRepositoryProvider).getNowPlaying));

final StateNotifierProvider<MoviesNotifier, List<Movie>>
    popularMoviesProvider = StateNotifierProvider((ref) => MoviesNotifier(
        fecthMoreMoives: ref.watch(movieRepositoryProvider).getPopular));

final StateNotifierProvider<MoviesNotifier, List<Movie>>
    topRatedMoviesProvider = StateNotifierProvider((ref) => MoviesNotifier(
        fecthMoreMoives: ref.watch(movieRepositoryProvider).getTopRated));

final StateNotifierProvider<MoviesNotifier, List<Movie>>
    upComingMoviesProvider = StateNotifierProvider((ref) => MoviesNotifier(
        fecthMoreMoives: ref.watch(movieRepositoryProvider).getUpcoming));


typedef MovieCallback = Future<List<Movie>> Function({int page});
// * Controlador de los providers
class MoviesNotifier extends StateNotifier<List<Movie>> {
  int currentPage = 0;
  bool isLoading = false;
  MovieCallback fecthMoreMoives;

  MoviesNotifier({required this.fecthMoreMoives}) : super([]);

  Future<void> loadNextPage() async {
    if (isLoading) return;

    isLoading = true;
    currentPage++;
    final List<Movie> movies = await fecthMoreMoives(page: currentPage);
    state = [...state, ...movies];
    await Future.delayed(const Duration(milliseconds: 500));
    isLoading = false;
  }
}
