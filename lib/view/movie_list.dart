import 'dart:js_interop';

import 'package:flutter/material.dart';
import 'package:notflix/util/api.dart';
import 'movie_detail.dart';
import 'search.dart';

class MovieList extends StatefulWidget {
  @override
  _MovieListState createState() => _MovieListState();
}

class _MovieListState extends State<MovieList> {
  String? result;
  APIRunner? helper;
  int? moviesCount;
  List? movies;
  List<List?>? moviesTvShows = [];
  List? horror;
  List? action;
  List? adventure;
  List? mystery;
  List? documentery;
  List? animation;
  List<String?>? heroGenres = [];
  String? _selectedValue = 'All';
  List<List> movieGenres = [
    ['28', 'Action'],
    ['12', 'Adventure'],
    ['16', 'Animation'],
    ['35', 'Comedy'],
    ['80', 'Crime'],
    ['99', 'Documentary'],
    ['18', 'Drama'],
    ['10751', 'Family'],
    ['14', 'Fantasy'],
    ['36', 'History'],
    ['27', 'Horror'],
    ['10402', 'Music'],
    ['9648', 'Mystery'],
    ['10749', 'Romance'],
    ['878', 'Science Fiction'],
    ['10770','TV Movie'],
    ['53','Thriller'],
    ['10752', 'War'],
    ['37', ' Western']
  ];
  List<List> tvGenres = [
    ['10759', 'Action & Adventure'],
    ['16', 'Animation'],
    ['35', 'Comedy'],
    ['80', 'Crime'],
    ['99', 'Documentary'],
    ['18', 'Drama'],
    ['10751', 'Family'],
    ['10762', 'Kids'],
    ['9648', 'Mystery'],
    ['10763', 'News'],
    ['10764', 'Reality'],
    ['10765', 'Sci-Fi & Fantasy'],
    ['10766', 'Soap'],
    ['10767', 'Talk'],
    ['10768', 'War & Politics'],
    ['37', 'Western']
  ];

  Icon visibleIcon = Icon(Icons.search);
  Widget searchBar = Text('Notflix');

  @override
  void initState() {
    helper = APIRunner();
    initialize();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: searchBar, actions: <Widget>[
        IconButton(
          icon: visibleIcon,
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (context) => const Search(),
              ),
            );
          },

        ),
      ]),      
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: categoriesButton(),
          ),
          // SliverToBoxAdapter(
          //   child:heroMovie(movie: movies, context: context, genres: heroGenres)
          // ),

          SliverToBoxAdapter(
            child: movieGroup(moviesCount: moviesCount, movieGroup: movies)
          ),

          // Builds movies and shows based on genres
          SliverList.builder(
            itemCount: moviesTvShows?.length,
            itemBuilder: (BuildContext context, int index) {
              return movieGroup(moviesCount: moviesCount, movieGroup: moviesTvShows?[index]);
            },
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

        // for(int i = 0; i < movies![0].genres.length; i++) {
      // heroGenres?.add(
      //   await helper?.getGenreByID(movies?[0].genres[i], 'Movies')
      // );

  Future initialize() async {
    moviesTvShows = []; // reset moviesTvShows
    heroGenres = []; // reset hero genres

    if(_selectedValue == 'Movies' || _selectedValue == 'All') {
      movies = (await helper?.getUpcoming('Movies'))!;
    }
    else if(_selectedValue == 'TV Shows' ) {
      movies = (await helper?.getUpcoming('TV Shows'))!;
    }
    for(int i = 0; i < movieGenres.length; i++) {
      print(_selectedValue);
      if(_selectedValue == 'Movies' || _selectedValue == 'All') {
        moviesTvShows?.add(await helper?.getGenre(movieGenres[i][0], 'Movies')); 
      }
      if((_selectedValue == 'TV Shows' || _selectedValue == 'All') && i <= 15) {
        moviesTvShows?.add(await helper?.getGenre(tvGenres[i][0], 'TV Shows')); 
      }
    }

    setState(
      () {
        moviesCount = 20; // movies?.length;
        movies = movies;
        moviesTvShows = moviesTvShows;
        // action = action;
        // adventure = adventure;
        // mystery = mystery;
        // documentery = documentery;
        // animation = animation;
      },
    );
  }

  Widget categoriesButton() {
  final List<String> _options = ['All', 'Movies', 'TV Shows'];

  return Container(
    padding: EdgeInsets.symmetric(vertical: 4.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding:  EdgeInsets.only(right: 16),
          child:
            Text('Browse by Categories')
        ),
        Padding( 
          padding:  EdgeInsets.only(right: 16),
          child:
            DropdownButton<String>(
              value: _selectedValue,
              hint: const Text('Categories'),
              items: _options.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),);
              }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                _selectedValue = newValue; // Update the state with the new selection
                initialize();
              });
            },
          ),
        )
      ])
  );
}

}

// widget for showing the movie group title
Widget movieTitle({required title}) {
  return Padding(padding: const EdgeInsets.all(16),
    child: Text('$title', style: TextStyle(
      fontSize: 18,
      )
    )
  );
}

// widget for making a horizontally scrollable movie list
Widget movieGroup({required moviesCount, required movieGroup}) {
  final String iconBase = 'https://image.tmdb.org/t/p/w500/';
  final String defaultImage = 'https://images.freeimages.com/images/large-previews/5eb/movie-clapboard-1184339.jpg';
  
  NetworkImage image;

  return Container(
    height: 400, 
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text('${movieGroup[0]}', style: TextStyle(
            fontSize: 18,
            )
          )
        ),
    
        Expanded(
          child: 
            ListView.builder(
              itemCount: (moviesCount == null) ? 0 : moviesCount-1,
              scrollDirection: Axis.horizontal,
              itemBuilder: (BuildContext context, int position) {
                if (movieGroup?[position+1].posterPath != null) {
                  image = NetworkImage(iconBase + movieGroup?[position+1].posterPath);
                } else {
                  image = NetworkImage(defaultImage);
                }
                return Card(
                  color: Colors.white,
                  elevation: 8.0,
                  child: Container(
                    width: 300,
                    height: 300,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      image: DecorationImage(
                        image: image!,
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          MaterialPageRoute route = MaterialPageRoute(
                            builder: (_) =>
                                MovieDetail(movieGroup?[position+1]),
                          );
                          Navigator.push(context, route);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withValues(),
                              ],
                            ),
                          ),
                          padding: EdgeInsets.all(16),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                movieGroup?[position+1].title ?? '',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                '${'Released: ' + (movieGroup?[position+1].releaseDate ?? '')} - Vote: ${movieGroup![position+1].voteAverage}',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }
            ), 
          )
        ]
      )
  );
}



Widget heroMovie({required movie, required context, required genres}) {
  final String iconBase = 'https://image.tmdb.org/t/p/w780/';
  final String defaultImage = 'https://images.freeimages.com/images/large-previews/5eb/movie-clapboard-1184339.jpg';
  movie = movie[0];



  NetworkImage image;
  if (movie.posterPath != null) {
    image = NetworkImage(iconBase + movie.posterPath);
  } else {
    image = NetworkImage(defaultImage);
  }
  return Card(
    color: Colors.white,
    elevation: 8.0,
    child: Container(
      width: 600,
      height: 600,
      decoration: BoxDecoration(
        boxShadow: [BoxShadow(color: Colors.red)],
        borderRadius: BorderRadius.circular(4),
        image: DecorationImage(
          image: image,
          fit: BoxFit.cover,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            MaterialPageRoute route = MaterialPageRoute(
              builder: (_) =>
                  MovieDetail(movie),
            );
            Navigator.push(context, route);
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withValues(),
                ],
              ),
            ),
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  movie.title ?? '',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  '${genres}',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
