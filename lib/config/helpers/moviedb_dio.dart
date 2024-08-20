import 'package:cinemapedia/config/constants/environment.dart';
import 'package:dio/dio.dart';

class MoviedbDio {
  static Dio movieDbDio = Dio(BaseOptions(
      baseUrl: 'https://api.themoviedb.org/3',
      queryParameters: {
        'api_key': Environment.movieDbKey,
        'language': 'es-MX'
      }));
}