import 'package:animate_do/animate_do.dart';
import 'package:cinemapedia/presentation/providers/actors/actors_by_movie_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/presentation/providers/movies/movie_info_provider.dart';

class MovieScreen extends ConsumerStatefulWidget {
  static const name = 'movie-screen';
  final String movieId;

  const MovieScreen({super.key, required this.movieId});

  @override
  MovieScreenState createState() => MovieScreenState();
}

class MovieScreenState extends ConsumerState<MovieScreen> {
  @override
  void initState() {
    super.initState();

    ref.read(movieInfoProvider.notifier).loadMovie(widget.movieId);
    ref.read(actorsByMovieProvider.notifier).loadActors(widget.movieId);
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;
    final Movie? movie = ref.watch(movieInfoProvider)[widget.movieId];

    if (movie == null) {
      return const Scaffold(
          body: Center(child: CircularProgressIndicator(strokeWidth: 2)));
    }

    return Scaffold(
      body: CustomScrollView(
        physics: const ClampingScrollPhysics(),
        slivers: [
          _CustomSliverAppBar(
            movie: movie,
            colorScheme: colorScheme,
            textTheme: textTheme,
            size: size,
          ),
          SliverList(
              delegate: SliverChildBuilderDelegate(
                  (context, index) => _MovieDetails(
                        movie: movie,
                        colorScheme: colorScheme,
                        textTheme: textTheme,
                        size: size,
                      ),
                  childCount: 1))
        ],
      ),
    );
  }
}

class _MovieDetails extends StatelessWidget {
  final Size size;
  final ColorScheme colorScheme;
  final TextTheme textTheme;
  final Movie movie;

  const _MovieDetails(
      {required this.movie,
      required this.colorScheme,
      required this.textTheme,
      required this.size});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //* Imagen
              ClipRRect(
                child: Image.network(
                  movie.posterPath,
                  width: size.width * 0.30,
                ),
              ),
              const SizedBox(width: 10),
              //* Titulo y Reseña
              SizedBox(
                width: (size.width - 40) * 0.70,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      movie.title,
                      style: textTheme.titleLarge,
                    ),
                    Text(movie.overview)
                  ],
                ),
              ),
            ],
          ),
        ),
        // * Generos
        Padding(
          padding: const EdgeInsets.all(8),
          child: Wrap(
            children: [
              ...movie.genreIds.map((gender) => Container(
                    margin: const EdgeInsets.only(right: 10),
                    child: Chip(
                      label: Text(gender),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                    ),
                  )),
            ],
          ),
        ),

        //* Actores
        _ActorsByMovie(movieId: movie.id.toString()),

        const SizedBox(
          height: 20,
        )
      ],
    );
  }
}

class _CustomSliverAppBar extends StatelessWidget {
  final Size size;
  final TextTheme textTheme;
  final ColorScheme colorScheme;
  final Movie movie;

  const _CustomSliverAppBar(
      {required this.movie,
      required this.colorScheme,
      required this.textTheme,
      required this.size});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: Colors.black87,
      expandedHeight: size.height * 0.70,
      foregroundColor: Colors.white,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          children: [
            SizedBox.expand(
              child: Image.network(
                movie.posterPath,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) => loadingProgress != null ? const SizedBox() :  FadeIn(child: child),
              ),
            ),

            // * Gradiente para poder ver un titulo en blanco
            const SizedBox.expand(
              child: DecoratedBox(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          stops: [0.9, 1.0],
                          colors: [Colors.transparent, Colors.black87]))),
            ),

            // * Gradiente para la flecha de volver
            const SizedBox.expand(
              child: DecoratedBox(
                  decoration: BoxDecoration(
                      gradient:
                          LinearGradient(begin: Alignment.topLeft, stops: [
                0.0,
                0.3
              ], colors: [
                Colors.black87,
                Colors.transparent,
              ]))),
            ),
          ],
        ),
        titlePadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        // title: Text(
        //   movie.title,
        //   style: const TextStyle(fontSize: 20, color: Colors.white),
        //   textAlign: TextAlign.start,
        // ),
      ),
    );
  }
}

class _ActorsByMovie extends ConsumerWidget {
  final String movieId;

  const _ActorsByMovie({required this.movieId});

  @override
  Widget build(BuildContext context, ref) {
    final actorsByMovie = ref.watch(actorsByMovieProvider);

    if (actorsByMovie[movieId] == null){
      return const Center(child: CircularProgressIndicator(strokeWidth: 2));
    }

    final actors = actorsByMovie[movieId];

    return SizedBox(
      height: 300,
      child: ListView.builder(
        itemCount: actorsByMovie[movieId]?.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) => Container(
                padding: const EdgeInsets.all(8),
                width: 135,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //* Foto del Actor
                    FadeInRight(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.network(
                          actors![index].profilePath,
                          height: 180,
                          width: 135,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),

                    const SizedBox(
                      height: 5,
                    ),

                    Text(actors[index].name),
                    Text(
                      actors[index].character ?? '',
                      maxLines: 2,
                      style: const TextStyle(fontWeight: FontWeight.bold, overflow: TextOverflow.ellipsis),
                    ),

                    //* Nombre
                  ],
                ),
              )),
    );
  }
}
