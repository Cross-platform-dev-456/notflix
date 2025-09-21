import 'package:flutter/material.dart';
import 'package:notflix/util/api.dart';
import 'movie_detail.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<StatefulWidget> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  String? results;
  APIRunner? helper;
  int? moviesCount;
  List? movies;

  final String iconBase = 'https://image.tmdb.org/t/p/w92/';
  final String defaultImage =
      'ttps://images.freeimages.com/images/large-previews/5eb/movie-clapboard-1184339.jpg';

  @override
  void initState() {
    helper = APIRunner();
    initialize();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    NetworkImage image;
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          textInputAction: TextInputAction.search,
          onSubmitted: (String text) {
            search(text);
          },
          style: TextStyle(
            color: Colors.black,
            fontSize: 20.0,
          ),
          decoration: InputDecoration(
            hintText: "Search For Movies",
          ),
        ), 
        actions: <Widget>[
        IconButton(
          icon: Icon(Icons.home),
          onPressed: () {
            Navigator.pop(context);
          }
        ), 
      ]),
      body: ListView.builder(
        itemCount: (moviesCount == null) ? 0 : moviesCount,
        itemBuilder: (BuildContext context, int position) {
          if (movies?[position].posterPath != null) {
            image = NetworkImage(iconBase + movies?[position].posterPath);
          } else {
            image = NetworkImage(defaultImage);
          }
          return Card(
            color: Colors.white,
            elevation: 2.0,
            child: ListTile(
              onTap: () {
                MaterialPageRoute route = MaterialPageRoute(
                    builder: (_) => MovieDetail(movies?[position]));
                Navigator.push(context, route);
              },
              leading: CircleAvatar(
                backgroundImage: image,
              ),
              title: Text(movies?[position].title),
              subtitle: Text('${'Released: ' +
                  movies?[position].releaseDate} - Vote: ${movies![position].voteAverage}'),
            ),
          );
        },
      )
    );
  }

  Future search(text) async {
    movies = (await helper?.searchMovie(text))!;
    setState(
      () {
        moviesCount = movies?.length;
        movies = movies;
      },
    );
  }

  Future initialize() async {
    movies = (await helper?.getUpcoming())!;
    setState(
      () {
        moviesCount = movies?.length;
        movies = movies;
      },
    );
  }
}