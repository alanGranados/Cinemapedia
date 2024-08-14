import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cinemapedia/infraestructure/datasources/moviedb_datasource.dart';
import 'package:cinemapedia/infraestructure/repositories/movie_repository_impl.dart';

// ? Este Repository es inmutable (Provider) 
final Provider<MovieRepositoryImpl> movieRepositoryProvider = Provider(
    (ref) => MovieRepositoryImpl(moviesDatasource: MovieDbDatasource()));
