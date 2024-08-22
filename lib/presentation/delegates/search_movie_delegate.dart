import 'dart:async';

import 'package:animate_do/animate_do.dart';
import 'package:cinemapedia/config/helpers/human_formats.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:flutter/material.dart';

typedef SearchMoviesCallback = Future<List<Movie>> Function(String query);

class SearchMovieDelegate extends SearchDelegate<Movie?> {
  final SearchMoviesCallback searchMovies;
  List<Movie> initialMovies;
  Timer? _debounceTimer;
  StreamController<List<Movie>> debounceMovies = StreamController.broadcast();
  StreamController<bool> isLoadingStream = StreamController.broadcast();

  SearchMovieDelegate(
      {required this.searchMovies, required this.initialMovies});



  void _clearStreams() => debounceMovies.close();

  void _onQueryChange(String query) {
    isLoadingStream.add(true);
    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();

    _debounceTimer = Timer(const Duration(milliseconds: 500), () async {
      // if( query.isEmpty ){
      //   debounceMovies.add([]);
      //   return;
      // }

      //* añadimos las peliculas
      final movies = await searchMovies(query);
      initialMovies = movies;
      debounceMovies.add(movies);
      isLoadingStream.add(false);
    });
  }

  Widget _builtResultAndSuggestion() {
    return StreamBuilder(
      initialData: initialMovies,
      stream: debounceMovies.stream,
      builder: (context, snapshot) {
        final movies = snapshot.data ?? [];
        return ListView.builder(
          itemCount: movies.length,
          itemBuilder: (context, index) => _MovieSearchItem(
            movie: movies[index],
            onMovieSelected: (context, movie) {
              _clearStreams();
              close(context, movie);
            },
          ),
        );
      },
    );
  }

  @override
  String get searchFieldLabel => 'BuscarPelicula';

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      StreamBuilder(
        stream: isLoadingStream.stream,
        builder: (context, snapshot) {
          if (snapshot.data == true) {
            return SpinPerfect(
                spins: 10,
                infinite: true,
                animate: query.isNotEmpty,
                child: IconButton(
                    onPressed: () => query = '',
                    icon: const Icon(Icons.refresh_rounded)));
          }
          return FadeIn(
              animate: query.isNotEmpty,
              child: IconButton(
                  onPressed: () => query = '', icon: const Icon(Icons.clear)));
        },
      ),
    ];
  }
  
  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          _clearStreams();
          close(context, null);
        },
        icon: const Icon(Icons.arrow_back));
  }

  @override
  Widget buildResults(BuildContext context) {
    return _builtResultAndSuggestion();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    _onQueryChange(query);
    return _builtResultAndSuggestion();
  }
}

class _MovieSearchItem extends StatelessWidget {
  final Movie movie;
  final Function onMovieSelected;

  const _MovieSearchItem({required this.movie, required this.onMovieSelected});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final Size size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () => onMovieSelected(context, movie),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //* Imgen
            SizedBox(
              width: size.width * 0.20,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(movie.posterPath,
                    loadingBuilder: (context, child, loadingProgress) =>
                        loadingProgress != null
                            ? const CircularProgressIndicator(strokeWidth: 2)
                            : FadeIn(child: child)),
              ),
            ),
            const SizedBox(width: 10),

            // * Titulo y Description
            SizedBox(
              width: size.width * 0.7,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    movie.title,
                    style: textTheme.titleMedium,
                  ),
                  (movie.overview.length > 100)
                      ? Text(
                          '${movie.overview.substring(0, 100)}...',
                          style: textTheme.titleMedium,
                        )
                      : Text(
                          movie.overview,
                          style: textTheme.titleMedium,
                        ),
                  Row(
                    children: [
                      Icon(Icons.star_half_rounded,
                          color: Colors.yellow.shade900),
                      const SizedBox(width: 5),
                      Text(
                        HumanFormats.number(movie.voteAverage, 2),
                        style: textTheme.bodyMedium!
                            .copyWith(color: Colors.yellow.shade900),
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
