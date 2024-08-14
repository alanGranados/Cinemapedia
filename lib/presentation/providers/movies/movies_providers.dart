import 'package:cinemapedia/domain/entities/movier.dart';
import 'package:cinemapedia/presentation/providers/movies/movie_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final StateNotifierProvider<MoviesNotifier, List<Movie>>
    nowPlayingMoviesProvider = StateNotifierProvider((ref) => MoviesNotifier(
        fecthMoreMoives: ref.watch(movieRepositoryProvider).getNowPlaying));

typedef MovieCallback = Future<List<Movie>> Function({int page});

class MoviesNotifier extends StateNotifier<List<Movie>> {
  int currentPage = 0;
  MovieCallback fecthMoreMoives;

  MoviesNotifier({required this.fecthMoreMoives}) : super([]);

  Future<void> loadNextPage() async {
    currentPage++;
    final List<Movie> movies = await fecthMoreMoives(page: currentPage);
    state = [...state, ...movies];
  }
}
