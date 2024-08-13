import 'package:cinemapedia/domain/entities/movier.dart';

abstract class MovieRepositorie {
  Future<List<Movie>> getNowPlaying({ int page = 1});
}