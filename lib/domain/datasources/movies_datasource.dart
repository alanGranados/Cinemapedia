import 'package:cinemapedia/domain/entities/movier.dart';

abstract class MovieDatasource {
  Future<List<Movie>> getNowPlaying({ int page = 1});
}