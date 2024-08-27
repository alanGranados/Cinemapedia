import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/domain/repositories/local_storage_repository.dart';
import 'package:cinemapedia/presentation/providers/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final favoritesMoviesProvider = StateNotifierProvider<StorageMoviesNotifier, Map<int,Movie>>((ref) {
  
  final LocalStorageRepository localStorageRepository = ref.watch( localStorageRepositoryProvider );

  return StorageMoviesNotifier(localStorageRepository: localStorageRepository);
},  );

/* 
  ? {
  ?  123: Movie,
  ?  2223: Movie,
  ?  1345: Movie,
  ?  8756: Movie,
  ? }
 */

class StorageMoviesNotifier extends StateNotifier<Map<int, Movie>> {
  int page = 0;
  final LocalStorageRepository localStorageRepository;
  final Map<int, Movie>  tempMoviesMap = {};

  StorageMoviesNotifier({required this.localStorageRepository}) : super({});

  Future<List<Movie>> loadNextPage() async {
    final movies = await localStorageRepository.loadMovies(offset: page*10, limit: 20); 
    page++;


    for (final movie in movies) {
      tempMoviesMap[movie.id] = movie;
    }
    state = {...state, ...tempMoviesMap };
    return movies;
  }

  Future<void> toggleFavorite( Movie movie ) async{
    await localStorageRepository.toggleFavorite(movie);
    final bool isMovieInFavorites = state[movie.id] != null;

    if( isMovieInFavorites ){
      state.remove(movie.id);
      state = { ...state };
    }else{
      state = { ...state, movie.id: movie };
    }
  }
}
