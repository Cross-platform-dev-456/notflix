import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:notflix/model/movie.dart';
import 'package:notflix/model/tvShow.dart';

// 18361ad82497ec1cf55ca10b74f1d3750'; <- This is a dummy key
class APIRunner {
  final String api_key = 'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI0NmQ4OGZkYzE0ZmMxMDdjNzQxZTYyNGFiYTNjYWMzYiIsIm5iZiI6MTc1NzM1NjMyMS41OTEsInN1YiI6IjY4YmYyMTIxZDliZTBjZGYzNjk4YzlhNyIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.fl3rvzIwWU87nda24DWaLeIUPYiUBCgzBhENIKipeEY';
  final String urlBase = 'https://api.themoviedb.org/3';

  final String apiUpcoming = '/movie/upcoming?';
  final String apiDiscover = '/discover/movie?';
  final String apiSearch = '/search/movie?';
  final String apiTvUpcoming = '/tv/airing_today?';
  final String apiTvDiscover = '/discover/tv?';

  final String urlLanguage = '?language=en-US';
  

  Future<List?> runAPI(API, type, genre) async {
    http.Response result = await http.get(
      Uri.parse(API),
      headers: {
        'Authorization': 'Bearer $api_key',
        'Accept': 'application/json',
      },
    );
    if (result.statusCode == 200) {
      final jsonResponse = json.decode(result.body);
      final moviesMap = jsonResponse['results'];
      try {
        late var movies = [];
        if(type == 'movieGenres') {
          movies = moviesMap.map((i) => MovieDiscover.fromJson(i)).toList();
          genre = await getGenreByID(genre, 'Movies'); 
          movies[0].genres.add('${await genre} Movies');
          print('Successfully parsed ${movies.length} movies');
          return movies;
        }
        else if(type == 'moviesList') {
          movies = moviesMap.map((i) => MovieList.fromJson(i)).toList();
          movies[0].genres.add('Upcoming Movies');
          print('Successfully parsed ${movies.length} movies');
          return movies;
        }
        else if(type == 'tvGenres') {
          movies = moviesMap.map((i) => TvShowDiscover.fromJson(i)).toList();
          genre = await getGenreByID(genre, 'TV Shows'); 
          movies[0].genres.add('${await genre} TV Shows');
          print('Successfully parsed ${movies.length} movies');
          return movies;
        }
        else if(type == 'tvList') {
          movies = moviesMap.map((i) => TvShowList.fromJson(i)).toList();
          movies[0].genres.add('Upcoming TV Shows');
          print('Successfully parsed ${movies.length} movies');
          return movies;
        }
        print('Could not parse movies: ${type}');
        return [];
      } catch (e) {
        print('Error parsing movies: $e');
        return <Movie>[]; // Return empty list on error
      }
    } else {
      print('Request failed with status: ${result.statusCode}.');
      print('Response body: ${result.body}');
      print('API URL: $API');
      // Handle the error appropriately, maybe throw an exception or return null
      // For now, we just return null
      // You might want to log this error or handle it in a way that informs the user
      return null;
    }
  }

  Future<List?> getUpcoming(String? categorie) async {
    String upcomingAPI;
    if(categorie == 'Movies') {
      upcomingAPI = urlBase + apiUpcoming + urlLanguage;
      return runAPI(upcomingAPI, 'moviesList', '');
    }
    else if(categorie == 'TV Shows') {
      upcomingAPI = urlBase + apiTvUpcoming + urlLanguage;
      return runAPI(upcomingAPI, 'tvList', '');
    }
    
    return [];
  }

  Future<List?> getGenre(String genre, String? catagorie) async {
    //String? genreId = await getIDByGenre(genre);
    if(catagorie == 'Movies') {
      String genreAPI = '$urlBase${apiDiscover}with_genres=$genre$urlLanguage';
      return runAPI(genreAPI, 'movieGenres', genre);
    }
    else if(catagorie == 'TV Shows') {
      String genreAPI = '$urlBase${apiTvDiscover}with_genres=$genre$urlLanguage';
      return runAPI(genreAPI, 'tvGenres', genre);
    }

    return [];
  }

  //Gets a genre's ID. capitalize first letter in the genre
  Future<String?> getIDByGenre(String genre) async {
    String id = '0';
    final String genreUrl = 
        '$urlBase/genre/movie/list?$urlLanguage';

    http.Response result = await http.get(
      Uri.parse(genreUrl),
      headers: {
        'Authorization': 'Bearer $api_key',
        'Accept': 'application/json',
      },
    );
    if (result.statusCode == HttpStatus.ok) {
      final jsonResponse = json.decode(result.body);
      //print(jsonResponse);
      for(int i = 0; i < jsonResponse['genres'].length; i++) {
        if(jsonResponse['genres'][i]['name'] == genre) {
          id = jsonResponse['genres'][i]['id'].toString();
        }
      }
    }
      
    return id;
  }

  //Gets a genre's ID. capitalize first letter in the genre
  Future<String?> getGenreByID(String id, type) async {
    String? genre = 'Genre Not Found';
    String genreUrl;
    if(type == 'Movies') {
      genreUrl = '$urlBase/genre/movie/list?$urlLanguage';
    }
    else if(type == 'TV Shows') {
      genreUrl = '$urlBase/genre/tv/list?$urlLanguage';
    }
    else {
      return genre;
    }


    http.Response result = await http.get(
      Uri.parse(genreUrl),
      headers: {
        'Authorization': 'Bearer $api_key',
        'Accept': 'application/json',
      },
    );
    if (result.statusCode == HttpStatus.ok) {
      final jsonResponse = json.decode(result.body);
      //print(jsonResponse);
      for(int i = 0; i < jsonResponse['genres'].length; i++) {
        if(jsonResponse['genres'][i]['id'] == int.parse(id)) {

          genre = jsonResponse['genres'][i]['name'];
        }
      }
    }
      
    return genre;
  }

  Future<List?> searchMovie(String title) async {
    final String search =
        '$urlBase${apiSearch}query=$title';
    return runAPI(search, 'moviesList', '');
  }

  // This is for recommended based on the selected movie
  Future<List?> getRecommended(String movieId) async {
    final String recommendedAPI = 
        '$urlBase/movie/$movieId/recommendations';
    return runAPI(recommendedAPI, 'moviesList', '');
  }

  // This is the similar mob
  Future<List?> getSimilar(String movieId) async {
    final String similarAPI = 
        '$urlBase/movie/$movieId/similar';
    return runAPI(similarAPI, 'moviesList', '');
  }

  Future<String?> getTrailerKey(String movieId) async {
  final String videoAPI = '$urlBase/movie/$movieId/videos$urlLanguage';
  final response = await http.get(
    Uri.parse(videoAPI),
    headers: {
      'Authorization': 'Bearer $api_key',
      'Accept': 'application/json',
    },
  );

  if (response.statusCode == HttpStatus.ok) {
    final jsonResponse = json.decode(response.body);
    final videos = jsonResponse['results'] as List;
    if (videos.isEmpty) return null;

    final trailer = videos.firstWhere(
      (v) => v['site'] == 'YouTube' && v['type'] == 'Trailer',
      orElse: () => null,
    );

    return trailer?['key'];
  } else {
    print('Failed to load trailer: ${response.statusCode}');
    return null;
  }

    // Dead code?
//   Future<String?> getTrailerKey(String movieId) async {
//   final String videoAPI = '$urlBase/movie/$movieId/videos$urlLanguage';
//   final response = await http.get(
//     Uri.parse(videoAPI),
//     headers: {
//       'Authorization': 'Bearer $api_key',
//       'Accept': 'application/json',
//     },
//   );

//   if (response.statusCode == HttpStatus.ok) {
//     final jsonResponse = json.decode(response.body);
//     final videos = jsonResponse['results'] as List;
//     if (videos.isEmpty) return null;

//     final trailer = videos.firstWhere(
//       (v) => v['site'] == 'YouTube' && v['type'] == 'Trailer',
//       orElse: () => null,
//     );

//     return trailer?['key'];
//   } else {
//     print('Failed to load trailer: ${response.statusCode}');
//     return null;
//   }
// }

}
}
