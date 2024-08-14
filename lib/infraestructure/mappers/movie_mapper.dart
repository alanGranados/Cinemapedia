import 'package:cinemapedia/domain/entities/movier.dart';
import 'package:cinemapedia/infraestructure/models/moviedb/movie_moviedb.dart';

class MovieMapper {
  static Movie movieDbToEntity(MovieFromMovieDb movieResult) => Movie(
      adult: movieResult.adult,
      backdropPath: (movieResult.backdropPath != '')
          ? 'https://image.tmdb.org/t/p/w500${movieResult.backdropPath}'
          : 'https://static.displate.com/857x1200/displate/2022-04-15/7422bfe15b3ea7b5933dffd896e9c7f9_46003a1b7353dc7b5a02949bd074432a.jpg',
      genreIds:
          movieResult.genreIds.map((genreId) => genreId.toString()).toList(),
      id: movieResult.id,
      originalLanguage: movieResult.originalLanguage,
      originalTitle: movieResult.originalTitle,
      overview: movieResult.overview,
      popularity: movieResult.popularity,
      posterPath: (movieResult.posterPath != '')
          ? 'https://image.tmdb.org/t/p/w500${movieResult.posterPath}'
          : 'no-poster',
      releaseDate: movieResult.releaseDate,
      title: movieResult.title,
      video: movieResult.video,
      voteAverage: movieResult.voteAverage,
      voteCount: movieResult.voteCount);
}
