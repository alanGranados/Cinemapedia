import 'package:cinemapedia/config/constants/environment.dart';
import 'package:cinemapedia/domain/datasources/movies_datasource.dart';
import 'package:cinemapedia/domain/entities/movier.dart';
import 'package:cinemapedia/infraestructure/mappers/movie_mapper.dart';
import 'package:cinemapedia/infraestructure/models/moviedb/moviedb_response.dart';
import 'package:dio/dio.dart';

class MovieDbDatasource extends MoviesDatasource {
  final Dio dio = Dio(BaseOptions(
      baseUrl: 'https://api.themoviedb.org/3',
      queryParameters: {
        'api_key': Environment.movieDbKey,
        'language': 'mx-MX'
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
}
