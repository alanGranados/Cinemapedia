import 'package:cinemapedia/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/presentation/providers/providers.dart';

class Favoritesview extends ConsumerStatefulWidget {
  const Favoritesview({super.key});

  @override
  FavoritesviewState createState() => FavoritesviewState();
}

class FavoritesviewState extends ConsumerState<Favoritesview> {
  bool isLastPage = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    // * Favorites Movies
    // ref.read( favoritesMoviesProvider.notifier ).loadNextPage();
    loadNextPage();
  }

  void loadNextPage() async {
    if (isLoading || isLastPage) return;

    isLoading = true;
    final movies =
        await ref.read(favoritesMoviesProvider.notifier).loadNextPage();
    isLoading = false;

    if (movies.isEmpty) {
      isLastPage = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final Map<int, Movie> favoritesMovie = ref.watch(favoritesMoviesProvider);
    // ? Lo hago como list porque con Map se pone roñoso
    final List<Movie> listFavoritesMovie = favoritesMovie.values.toList();

    if (favoritesMovie.isEmpty) {
    final colorScheme = Theme.of(context).colorScheme;
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.favorite_outline_sharp, size: 60, color: colorScheme.primary,),
            Text('Ohhh no!', style:  TextStyle(fontSize: 30, color: colorScheme.primary),),
            Text('no tienes peliculas favoritas', style:  TextStyle(fontSize: 20, color: colorScheme.secondary),)
          ],
        ),
      );
    }

    return Scaffold(
        body: MovieMasonry(
            loadNextPage: loadNextPage, movies: listFavoritesMovie));
  }
}
