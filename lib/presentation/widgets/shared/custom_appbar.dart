import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/presentation/delegates/search_movie_delegate.dart';
import 'package:cinemapedia/presentation/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class CustomAppbar extends ConsumerWidget {
  const CustomAppbar({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    // final movieRepository = ref.read( movieRepositoryProvider );
    final String searchQuery = ref.watch( searchQueryProvider );
    final searchedMovies = ref.watch( searchedMoviesProvier );

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: SizedBox(
          width: double.infinity,
          child: Row(
            children: [
              Icon(Icons.movie_outlined, color: colors.primary),
              const SizedBox(
                width: 5,
              ),
              Text(
                'Cinemapedia',
                style: textTheme.titleMedium,
              ),

              const Spacer(),

              IconButton(onPressed: 
              () => showSearch<Movie?>(
                query: searchQuery,
                context: context,
                delegate: SearchMovieDelegate(
                  searchMovies: ref.read( searchedMoviesProvier.notifier ).searchedMoviesByQuery,
                  initialMovies: searchedMovies
                  // ( query ) {
                    // ref.read( searchQueryProvider.notifier ).update( (state) => query, );
                    // return movieRepository.searchMovies(query);
                  // } 
                )
              ).then((movie) => movie != null 
                ? context.push('/movie/${ movie.id }')
                : null
              ), 
              icon: const Icon(Icons.search)),
            ],
          ),
        ),
      ),
    );
  }
}
