import 'package:cinemapedia/domain/entities/movier.dart';

abstract class MoviesRepository {
  Future<List<Movie>> getNowPlaying({ int page = 1});

  Future<List<Movie>> getPopular({ int page = 1});
}