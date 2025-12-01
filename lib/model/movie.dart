class Movie {
  late int id;
  late String title;
  late double voteAverage;
  late String releaseDate;
  late String overview;
  late String posterPath;
  late List genres;

  Movie(
    {required this.id,
    required this.title,
    required this.voteAverage,
    required this.releaseDate,
    required this.overview,
    required this.posterPath,
    required this.genres
    }
  );

  Movie.fromJson(Map<String, dynamic> parsedJson) {
    id = parsedJson['id'] as int;
    title = parsedJson['title'] as String? ?? '';
    voteAverage = (parsedJson['vote_average'] is int) 
        ? (parsedJson['vote_average'] as int).toDouble() 
        : (parsedJson['vote_average'] as double?) ?? 0.0;
    releaseDate = parsedJson['release_date'] as String? ?? '';
    overview = parsedJson['overview'] as String? ?? '';
    posterPath = parsedJson['poster_path'] as String? ?? '';
    genres = parsedJson['genre_ids'] as List? ?? [];
  }
}
