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
      required this.posterPath});

  Movie.fromJson(Map<String, dynamic> parsedJson) {
    id = parsedJson['id'] as int;
    title = parsedJson['title'] as String? ?? '';
    voteAverage = (parsedJson['vote_average'] as double?) ?? 0.0;
    releaseDate = parsedJson['release_date'] as String? ?? '';
    overview = parsedJson['overview'] as String? ?? '';
    posterPath = parsedJson['poster_path'] as String? ?? '';
  }
}
