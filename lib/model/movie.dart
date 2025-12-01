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
    try {
      // Handle both int and String for id
      var movieId = parsedJson['id'];
      if (movieId is String) {
        id = int.parse(movieId);
      } else if (movieId is int) {
        id = movieId;
      } else {
        print("ERROR: id is neither String nor int: $movieId (${movieId.runtimeType})");
        id = 0;
      }
      
      title = parsedJson['title'] as String? ?? '';
      
      // Handle both int and double for vote_average
      var voteAvg = parsedJson['vote_average'];
      if (voteAvg is int) {
        voteAverage = voteAvg.toDouble();
      } else if (voteAvg is double) {
        voteAverage = voteAvg;
      } else {
        print("ERROR: vote_average is neither int nor double: $voteAvg (${voteAvg?.runtimeType})");
        voteAverage = 0.0;
      }
      
      releaseDate = parsedJson['release_date'] as String? ?? '';
      overview = parsedJson['overview'] as String? ?? '';
      posterPath = parsedJson['poster_path'] as String? ?? '';
      genres = parsedJson['genre_ids'] as List? ?? [];
    } catch (e, stackTrace) {
      print("ERROR in Movie.fromJson: $e");
      print("Data received: $parsedJson");
      print("Stack trace: $stackTrace");
      rethrow;
    }
  }
}
