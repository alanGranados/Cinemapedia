import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/infraestructure/models/moviedb/movie_details.dart';
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
          : 'https://static.displate.com/857x1200/displate/2022-04-15/7422bfe15b3ea7b5933dffd896e9c7f9_46003a1b7353dc7b5a02949bd074432a.jpg',
      releaseDate: movieResult.releaseDate != null ? movieResult.releaseDate! : DateTime.now(),
      title: movieResult.title,
      video: movieResult.video,
      voteAverage: movieResult.voteAverage,
      voteCount: movieResult.voteCount);

  static Movie movieDetailsToentity(MovieDetails movieDetails) => Movie(
      adult: movieDetails.adult,
      backdropPath: (movieDetails.backdropPath != '')
          ? 'https://image.tmdb.org/t/p/w500${movieDetails.backdropPath}'
          : 'https://static.displate.com/857x1200/displate/2022-04-15/7422bfe15b3ea7b5933dffd896e9c7f9_46003a1b7353dc7b5a02949bd074432a.jpg',
      genreIds:
          movieDetails.genres.map((genreId) => genreId.name ).toList(),
      id: movieDetails.id,
      originalLanguage: movieDetails.originalLanguage,
      originalTitle: movieDetails.originalTitle,
      overview: movieDetails.overview,
      popularity: movieDetails.popularity,
      posterPath: (movieDetails.posterPath != '')
          ? 'https://image.tmdb.org/t/p/w500${movieDetails.posterPath}'
          : 'https://static.displate.com/857x1200/displate/2022-04-15/7422bfe15b3ea7b5933dffd896e9c7f9_46003a1b7353dc7b5a02949bd074432a.jpg',
      releaseDate: movieDetails.releaseDate,
      title: movieDetails.title,
      video: movieDetails.video,
      voteAverage: movieDetails.voteAverage,
      voteCount: movieDetails.voteCount);
}
