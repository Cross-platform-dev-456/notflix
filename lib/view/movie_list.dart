import 'package:flutter/material.dart';
import 'package:notflix/util/api.dart';
import 'movie_detail.dart';

class MovieList extends StatefulWidget {
  @override
  _MovieListState createState() => _MovieListState();
}

class _MovieListState extends State<MovieList> {
  String? result;
  APIRunner? helper;
  int? moviesCount;
  List? movies;
  List? horror;
  List? action;
  List? adventure;
  List? mystery;
  List? documentery;
  List? animation;

  Icon visibleIcon = Icon(Icons.search);
  Widget searchBar = Text('Movies');

  @override
  void initState() {
    helper = APIRunner();
    initialize();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final String iconBase = 'https://image.tmdb.org/t/p/w92/';
    final String defaultImage = 'https://images.freeimages.com/images/large-previews/5eb/movie-clapboard-1184339.jpg';

    NetworkImage image;
    return Scaffold(
      appBar: AppBar(title: searchBar, actions: <Widget>[
        IconButton(
          icon: visibleIcon,
          onPressed: () {
            setState(
              () {
                if (this.visibleIcon.icon == Icons.search) {
                  this.visibleIcon = Icon(Icons.cancel);
                  this.searchBar = TextField(
                    textInputAction: TextInputAction.search,
                    onSubmitted: (String text) {
                      search(text);
                    },
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20.0,
                    ),
                  );
                } else {
                  this.visibleIcon = Icon(Icons.search);
                  this.searchBar = Text('Notflix');
                }
              },
            );
          },
        ),
      ]),      
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: movieTitle(title: 'Upcoming')),
          SliverToBoxAdapter(
            child: movieGroup(moviesCount: moviesCount, movieGroup: movies)
          ),
          SliverToBoxAdapter(child: movieTitle(title: 'Action')),
          SliverToBoxAdapter(
            child: movieGroup(moviesCount: moviesCount, movieGroup: action)
          ),
          SliverToBoxAdapter(child: movieTitle(title: 'Adventure')),
          SliverToBoxAdapter(
            child: movieGroup(moviesCount: moviesCount, movieGroup: adventure)
          ),
          SliverToBoxAdapter(child: movieTitle(title: 'Horror')),
          SliverToBoxAdapter(
            child: movieGroup(moviesCount: moviesCount, movieGroup: horror)
          ),
          SliverToBoxAdapter(child: movieTitle(title: 'Mystery')),
          SliverToBoxAdapter(
            child: movieGroup(moviesCount: moviesCount, movieGroup: mystery)
          ),
          SliverToBoxAdapter(child: movieTitle(title: 'Animation')),
          SliverToBoxAdapter(
            child: movieGroup(moviesCount: moviesCount, movieGroup: animation)
          ),
          SliverToBoxAdapter(child: movieTitle(title: 'Documentery')),
          SliverToBoxAdapter(
            child: movieGroup(moviesCount: moviesCount, movieGroup: documentery)
          ),
        ]),
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
    horror = (await helper?.getGenre('Horror'))!;
    action = (await helper?.getGenre('Action'))!;
    adventure = (await helper?.getGenre('Adventure'))!;
    mystery = (await helper?.getGenre('Mystery'))!;
    documentery = (await helper?.getGenre('Documentary'))!;
    animation = (await helper?.getGenre('Animation'))!;
    setState(
      () {
        moviesCount = movies?.length;
        movies = movies;
        horror = horror;
        action = action;
        adventure = adventure;
        mystery = mystery;
        documentery = documentery;
        animation = animation;
      },
    );
  }
}

// widget for showing the movie group title
Widget movieTitle({required title}) {
  return Padding(padding: const EdgeInsets.all(8),
    child: Text('$title', style: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      )
    )
  );
}

// widget for making a horizontally scrollable movie list
Widget movieGroup({required moviesCount, required movieGroup, }) {
  final String iconBase = 'https://image.tmdb.org/t/p/w92/';
  final String defaultImage = 'https://images.freeimages.com/images/large-previews/5eb/movie-clapboard-1184339.jpg';
  
  NetworkImage image;

  return Container(
    height: 100, 
    child: ListView.builder(
      itemCount: (moviesCount == null) ? 0 : moviesCount,
      scrollDirection: Axis.horizontal,
      itemBuilder: (BuildContext context, int position) {
        if (movieGroup?[position].posterPath != null) {
          image = NetworkImage(iconBase + movieGroup?[position].posterPath);
        } else {
          image = NetworkImage(defaultImage);
        }
        return Container(
          color: Colors.white,
          width: 200,
          height: 10,
          child: ListTile(
            onTap: () {
              MaterialPageRoute route = MaterialPageRoute(
                  builder: (_) => MovieDetail(movieGroup?[position]));
              Navigator.push(context, route);
            },
            leading: CircleAvatar(
              backgroundImage: image,
            ),
            title: Text(movieGroup?[position].title),
            subtitle: Text('Released: ' +
                movieGroup?[position].releaseDate +
                ' - Vote: ' +
                movieGroup![position].voteAverage.toString()),
          ),
        );
      }
    )
  );
}