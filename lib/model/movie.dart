class Movie {
  late int id;
  late String title;
  late double voteAverage;
  late String releaseDate;
  late String overview;
  late String posterPath;

  Movie(
    {required this.id,
    required this.title,
    required this.voteAverage,
    required this.releaseDate,
    required this.overview,
    required this.posterPath
    }
  );

  Movie.fromJson(Map<String, dynamic> parsedJson) {
    id = parsedJson['id'] as int;
    title = parsedJson['title'] as String? ?? '';
    voteAverage = (parsedJson['vote_average'] as double?) ?? 0.0;
    releaseDate = parsedJson['release_date'] as String? ?? '';
    overview = parsedJson['overview'] as String? ?? '';
    posterPath = parsedJson['poster_path'] as String? ?? '';
  }
}

// For movies that use the discover API
class MovieDiscover extends Movie {
  late List genres;

  MovieDiscover(
    {
      required this.genres,
      required super.id,
      required super.title,
      required super.voteAverage,
      required super.releaseDate,
      required super.overview,
      required super.posterPath,
    }
  );

  MovieDiscover.fromJson(Map<String, dynamic> parsedJson) 
  : super.fromJson(parsedJson) {
    genres = parsedJson['genres'] as List? ?? [];
  }

}

// For movies that use the list API
class MovieList extends Movie {
  late List genres;

  MovieList(
    {
      required this.genres,
      required super.id,
      required super.title,
      required super.voteAverage,
      required super.releaseDate,
      required super.overview,
      required super.posterPath,
    }
  );

  MovieList.fromJson(Map<String, dynamic> parsedJson) 
  : super.fromJson(parsedJson) {
    genres = parsedJson['genre_ids'] as List? ?? [];
  }

}
