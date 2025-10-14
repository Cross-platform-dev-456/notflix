//import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:notflix/model/movie.dart';

// 18361ad82497ec1cf55ca10b74f1d3750'; <- This is a dummy key
class APIRunner {
  final String api_key = 'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI0NmQ4OGZkYzE0ZmMxMDdjNzQxZTYyNGFiYTNjYWMzYiIsIm5iZiI6MTc1NzM1NjMyMS41OTEsInN1YiI6IjY4YmYyMTIxZDliZTBjZGYzNjk4YzlhNyIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.fl3rvzIwWU87nda24DWaLeIUPYiUBCgzBhENIKipeEY';
  final String urlBase = 'https://api.themoviedb.org/3';

  final String apiUpcoming = '/movie/upcoming?';
  final String apiDiscover = '/discover/movie?';
  final String apiSearch = '/search/movie?';

  final String urlLanguage = '&language=en-US';
  

  Future<List?> runAPI(API) async {
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
        var movies = moviesMap.map((i) => Movie.fromJson(i)).toList();
        print('Successfully parsed ${movies.length} movies');
        return movies;
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

  Future<List?> getUpcoming() async {
    final String upcomingAPI = urlBase + apiUpcoming + urlLanguage;
    return runAPI(upcomingAPI);
  }

  Future<List?> getGenre(String genre) async {
    String? genreId = await getIDByGenre(genre);
    final String genreAPI = 
        '$urlBase${apiDiscover}with_genres=$genreId$urlLanguage';
    return runAPI(genreAPI);
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

  Future<List?> searchMovie(String title) async {
    final String search =
        '$urlBase${apiSearch}query=$title';
    return runAPI(search);
  }

  // This is for recommended based on the selected movie
  Future<List?> getRecommended(String movieId) async {
    final String recommendedAPI = 
        '$urlBase/movie/$movieId/recommendations';
    return runAPI(recommendedAPI);
  }

  // This is the similar mob
  Future<List?> getSimilar(String movieId) async {
    final String similarAPI = 
        '$urlBase/movie/$movieId/similar';
    return runAPI(similarAPI);
  }
}
