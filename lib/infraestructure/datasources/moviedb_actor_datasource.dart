import 'package:cinemapedia/config/helpers/moviedb_dio.dart';
import 'package:cinemapedia/domain/datasources/actors_datasource.dart';
import 'package:cinemapedia/domain/entities/actor.dart';
import 'package:cinemapedia/infraestructure/mappers/actor_mapper.dart';
import 'package:cinemapedia/infraestructure/models/moviedb/credits_response.dart';

class ActorMovieDbDatasource extends ActorsDatasource {
  _jsonToActors(Map<String, dynamic> json) {
    final CreditsResponse creditsResponse = CreditsResponse.fromJson(json);

    final List<Actor> actors = creditsResponse.cast
        .map((cast) => ActorMapper.castToEntity(cast))
        .toList();
      return actors;
  }

  @override
  Future<List<Actor>> getActorsByMovie(String movieId) async {
    final response = await MoviedbDio.movieDbDio.get('/movie/$movieId/credits');
    return _jsonToActors(response.data);
  }
}
