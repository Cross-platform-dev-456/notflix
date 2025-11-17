import 'package:flutter/material.dart';
import 'package:notflix/util/api.dart';
import 'movie_detail.dart';
import 'package:notflix/util/db.dart';
import 'package:carousel_slider/carousel_slider.dart';

// Reusable movie card widget for consistent styling
class MovieCard extends StatelessWidget {
  final dynamic movie;
  final double width;
  final double height;
  final String iconBase;
  final String defaultImage;

  const MovieCard({
    super.key,
    required this.movie,
    this.width = 300,
    this.height = 300,
    required this.iconBase,
    required this.defaultImage,
  });

  @override
  Widget build(BuildContext context) {
    NetworkImage image;
    if (movie?.posterPath != null) {
      image = NetworkImage(iconBase + movie.posterPath);
    } else {
      image = NetworkImage(defaultImage);
    }

    // Determine if this is a smaller card (for grid layout)
    bool isGridCard = width == double.infinity;
    double titleFontSize = isGridCard ? 16 : 18;
    double subtitleFontSize = isGridCard ? 12 : 14;

    return Card(
      color: Colors.white,
      elevation: 8.0,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          image: DecorationImage(image: image, fit: BoxFit.cover),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              MaterialPageRoute route = MaterialPageRoute(
                builder: (_) => MovieDetail(movie),
              );
              Navigator.push(context, route);
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black.withValues()],
                ),
              ),
              padding: EdgeInsets.all(isGridCard ? 12 : 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    movie?.title ?? '',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: titleFontSize,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4),
                  Text(
                    '${'Released: ' + (movie?.releaseDate ?? '')} - Vote: ${movie?.voteAverage}',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: subtitleFontSize,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<StatefulWidget> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  String? results;
  APIRunner? helper;
  DbConnection? db;

  int? moviesCount;
  List? movies;

  late bool isSearching;

  int? searchCount;
  List? searchResults;

  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  final String iconBase = 'https://image.tmdb.org/t/p/w500/';
  final String defaultImage =
      'https://images.freeimages.com/images/large-previews/5eb/movie-clapboard-1184339.jpg';

  @override
  void initState() {
    helper = APIRunner();
    isSearching = false;
    initialize();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // pop scope prevents multfinger gestures from happening on the page
    return PopScope(
      canPop: true,
      child: Scaffold(
        appBar: AppBar(
          title: TextFormField(
            controller: _searchController,
            textInputAction: TextInputAction.search,
            onChanged: (String text) {
              if (text.isEmpty) {
                clearSearch();
              } else {
                search(text);
              }
            },
            style: TextStyle(color: Colors.white, fontSize: 20.0),
            decoration: InputDecoration(
              hintText: "Search For Movies",
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        clearSearch();
                      },
                    )
                  : null,
            ),
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.settings),
              onPressed: () async => await testDb(),
            ),
            IconButton(
              icon: Icon(Icons.person),
              onPressed: () async => await testDb(),
            )
          ],
        ),
        body: isSearching ? _buildSearchResults() : defautContent(),
      ),
    );
  }

  Widget defautContent() {
    return ListView(
      scrollDirection: Axis.vertical,
      children: <Widget>[
        Container(
          // For You
          margin: EdgeInsets.all(20.0),
          child: Column(
            spacing: 5.0,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(
                  left: 30.0,
                  top: 5.0,
                  bottom: 5.0,
                ),
                child: Text('For You', textScaler: TextScaler.linear(1.2)),
              ),
              CarouselSlider(
                options: CarouselOptions(
                  height: 350,
                  viewportFraction: 1.0,
                  enableInfiniteScroll: false,
                  padEnds: false,
                ),
                items: [1].map((i) {
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: (moviesCount == null) ? 0 : moviesCount,
                    itemBuilder: (BuildContext context, int position) {
                      return MovieCard(
                        movie: movies?[position],
                        iconBase: iconBase,
                        defaultImage: defaultImage,
                      );
                    },
                  );
                }).toList(),
              ),
            ],
          ),
        ),
        Container(
          // Because You Watched
          margin: EdgeInsets.all(20.0),
          child: Column(
            spacing: 5.0,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(
                  left: 30.0,
                  top: 5.0,
                  bottom: 5.0,
                ),
                child: Text(
                  'Because You Watched',
                  textScaler: TextScaler.linear(1.2),
                ),
              ),
              CarouselSlider(
                options: CarouselOptions(
                  height: 350,
                  viewportFraction: 1.0,
                  enableInfiniteScroll: false,
                  padEnds: false,
                ),
                items: [1].map((i) {
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: (moviesCount == null) ? 0 : moviesCount,
                    itemBuilder: (BuildContext context, int position) {
                      return MovieCard(
                        movie: movies?[position],
                        iconBase: iconBase,
                        defaultImage: defaultImage,
                      );
                    },
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future initialize() async {
    movies = (await helper?.getUpcoming('Movies', ''))!;
    setState(() {
      moviesCount = movies?.length;
      movies = movies;
    });
  }

  // TODO: Create a search by different attributes. I.e Genre, name, actor

  /*
    The search function of 
  */
  Future search(text) async {
    searchResults = (await helper?.searchMovie(text))!;
    setState(() {
      isSearching = true; // Set search state to true
      searchCount = searchResults?.length;
      searchResults = searchResults;
    });
  }

  Widget _buildSearchResults() {
    return GridView.builder(
      padding: EdgeInsets.all(8.0),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 6, // Reduced from 4 to 2 for better card visibility
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
        childAspectRatio:
            0.7, // Adjusted for the taller cards with gradient overlay
      ),
      itemCount: searchCount ?? 0,
      itemBuilder: (BuildContext context, int index) {
        return MovieCard(
          movie: searchResults?[index],
          width: double.infinity, // Fill the grid cell width
          height: double.infinity, // Fill the grid cell height
          iconBase: iconBase,
          defaultImage: defaultImage,
        );
      },
    );
  }

  void clearSearch() {
    setState(() {
      isSearching = false;
      searchCount = null;
      searchResults = null;
    });
  }

  testDb() async {
    try {
      db = DbConnection();
      final users = await db?.getUserList();
      print("Got users: $users");
      //await db?.insertUserTest();
    } catch (e) {
      print(e.toString());
      print("Could not test db");
    }
  }
}
