class TvShow {
  late int id;
  late String title;
  late double voteAverage;
  late String releaseDate;
  late String overview;
  late String posterPath;

  TvShow(
    {required this.id,
    required this.title,
    required this.voteAverage,
    required this.releaseDate,
    required this.overview,
    required this.posterPath
    }
  );

  TvShow.fromJson(Map<String, dynamic> parsedJson) {
    id = parsedJson['id'] as int;
    title = parsedJson['name'] as String? ?? '';
    voteAverage = (parsedJson['vote_average'] as double?) ?? 0.0;
    releaseDate = parsedJson['first_air_date'] as String? ?? '';
    overview = parsedJson['overview'] as String? ?? '';
    posterPath = parsedJson['backdrop_path'] as String? ?? '';
  }

}

// For TV Shows that use the discover API
class TvShowDiscover extends TvShow {
  late List genres;

  TvShowDiscover(
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

  TvShowDiscover.fromJson(Map<String, dynamic> parsedJson) 
  : super.fromJson(parsedJson) {
    genres = parsedJson['genres'] as List? ?? [];
  }

}

// For TV shows that use the list API
class TvShowList extends TvShow {
  late List genres;

  TvShowList(
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

  TvShowList.fromJson(Map<String, dynamic> parsedJson) 
  : super.fromJson(parsedJson) {
    genres = parsedJson['genre_ids'] as List? ?? [];
  }

}