import 'package:cinemapedia/domain/entities/actor.dart';
import 'package:cinemapedia/infraestructure/models/moviedb/credits_response.dart';

class ActorMapper {
  static Actor castToEntity(Cast cast) => Actor(
        id: cast.id,
        name: cast.name,
        profilePath: cast.profilePath != null
            ? 'https://image.tmdb.org/t/p/w500${cast.profilePath}'
            : 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRpWPpUvZfsJw0FFmFa-I9J9nQCxwK0c74uDdQ8EWGJhQoVF0vqAR8-gcp8rY2ehxkkymg&usqp=CAU',
        character: cast.character,
      );
}
