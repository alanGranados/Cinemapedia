import 'package:cinemapedia/config/constants/environment.dart';
import 'package:cinemapedia/domain/datasources/movies_datasource.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/infraestructure/mappers/movie_mapper.dart';
import 'package:cinemapedia/infraestructure/models/moviedb/movie_details.dart';
import 'package:cinemapedia/infraestructure/models/moviedb/moviedb_response.dart';
import 'package:dio/dio.dart';

class MovieDbDatasource extends MoviesDatasource {
  final Dio dio = Dio(BaseOptions(
      baseUrl: 'https://api.themoviedb.org/3',
      queryParameters: {
        'api_key': Environment.movieDbKey,
        'language': 'es-MX'
      }));

  List<Movie> _jsonToMovies( Map<String, dynamic> json) {
    
    final MovieDbResponse movieDbResponse =
        MovieDbResponse.fromJson(json);

    final List<Movie> movies = movieDbResponse.results
        .where((movieResult) => movieResult.posterPath != 'no-poster')
        .map((movieResult) => MovieMapper.movieDbToEntity(movieResult))
        .toList();
      
    return movies;
  }

  @override
  Future<List<Movie>> getNowPlaying({int page = 1}) async {
    final response = await dio.get('/movie/now_playing', queryParameters: {'page': page});

    final List<Movie> movies = _jsonToMovies(response.data);

    return movies;
  }
  
  @override
  Future<List<Movie>> getPopular({int page = 1}) async{
    final response = await dio.get('/movie/popular', queryParameters: {'page': page});
    return _jsonToMovies(response.data);
  }
  
  @override
  Future<List<Movie>> getTopRated({int page = 1}) async{
    final response = await dio.get('/movie/top_rated', queryParameters: {'page': page});
    return _jsonToMovies(response.data);
  }
  
  @override
  Future<List<Movie>> getUpcoming({int page = 1}) async{
    final response = await dio.get('/movie/upcoming', queryParameters: {'page': page});
    return _jsonToMovies(response.data);
  }
  
  @override
  Future<Movie> getMovieById(String movieId) async{
    final response = await dio.get('/movie/$movieId');
    if (response.statusCode != 200) throw Exception('Movie with id: $movieId not found');

    final MovieDetails movieDetails = MovieDetails.fromJson(response.data);
    final Movie movie = MovieMapper.movieDetailsToentity(movieDetails);
    return movie;
  }
  
  @override
  Future<List<Movie>> searchMovies(String query) async {
    if ( query.isEmpty ) return [];
    final response = await dio.get('/search/movie', queryParameters: {'query': query});
    return _jsonToMovies(response.data);
  }
}
