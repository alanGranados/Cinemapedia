import 'package:animate_do/animate_do.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:flutter/material.dart';

class MoviesSlideShow extends StatelessWidget {
  final List<Movie> movies;

  const MoviesSlideShow({super.key, required this.movies});

  @override
  Widget build(BuildContext context) {

    return SizedBox(
      height: 210,
      width: double.infinity,
      child: _SwiperMovies(movies: movies),
    );
  }
}

class _SwiperMovies extends StatelessWidget {
  final List<Movie> movies;

  const _SwiperMovies({ required this.movies });

  @override
  Widget build(BuildContext context) {
  final ColorScheme colorScheme = Theme.of(context).colorScheme;
  
    return Swiper(
      viewportFraction: 0.8,
      scale: 0.9,
      pagination: SwiperPagination(
        margin: const EdgeInsets.only(top: 0),
        builder: DotSwiperPaginationBuilder(
          activeColor: colorScheme.primary,
          color: colorScheme.secondary
        )
      ),
      itemCount: movies.length,
      itemBuilder: (context, index) => _Slide(movie: movies[index]),
    );
  }
}

class _Slide extends StatelessWidget {
  final Movie movie;

  const _Slide({required this.movie});

  @override
  Widget build(BuildContext context) {
    final decoration = BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
              color: Colors.black45, blurRadius: 10, offset: Offset(0, 10))
        ]);

    return Padding(
      padding: const EdgeInsets.only(bottom: 30),
      child: DecoratedBox(
          decoration: decoration,
          child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(movie.backdropPath,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) =>
                      loadingProgress != null
                          ? const DecoratedBox(
                              decoration: BoxDecoration(color: Colors.black12))
                          : FadeIn(child: child)))),
    );
  }
}
