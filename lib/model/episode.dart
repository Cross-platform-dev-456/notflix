class Episode {
  late int id;
  late String name;
  late String overview;
  late int episodeNumber;
  late int seasonNumber;
  late String airDate;
  late String? stillPath;
  late double voteAverage;
  late int runtime;

  Episode({
    required this.id,
    required this.name,
    required this.overview,
    required this.episodeNumber,
    required this.seasonNumber,
    required this.airDate,
    this.stillPath,
    required this.voteAverage,
    required this.runtime,
  });

  Episode.fromJson(Map<String, dynamic> parsedJson) {
    id = parsedJson['id'] as int;
    name = parsedJson['name'] as String? ?? '';
    overview = parsedJson['overview'] as String? ?? '';
    episodeNumber = parsedJson['episode_number'] as int? ?? 0;
    seasonNumber = parsedJson['season_number'] as int? ?? 0;
    airDate = parsedJson['air_date'] as String? ?? '';
    stillPath = parsedJson['still_path'] as String?;
    voteAverage = (parsedJson['vote_average'] is int) 
        ? (parsedJson['vote_average'] as int).toDouble() 
        : (parsedJson['vote_average'] as double?) ?? 0.0;
    runtime = parsedJson['runtime'] as int? ?? 0;
  }
}

