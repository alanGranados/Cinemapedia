import 'package:cinemapedia/infraestructure/datasources/moviedb_actor_datasource.dart';
import 'package:cinemapedia/infraestructure/repositories/actors_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ? Este Repository es inmutable (Provider) 
final Provider<ActorsRepositoryImpl> actorsRepositoryProvider = Provider(
    (ref) => ActorsRepositoryImpl(datasource: ActorMovieDbDatasource()));
