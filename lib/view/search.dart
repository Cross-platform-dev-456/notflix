import 'package:flutter/material.dart';
import 'package:notflix/util/api.dart';
import 'movie_detail.dart';
import 'package:notflix/util/db.dart';
import 'package:carousel_slider/carousel_slider.dart';

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

  NetworkImage? image;

  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose () {
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
      canPop: false, 
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
            style: TextStyle(
              color: Colors.black,
              fontSize: 20.0,
            ),
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
            icon: Icon(Icons.home),
            onPressed: () {
              Navigator.pop(context);
            }
          ), 
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: ()async  => await testDb(),
          ),
        ]),
        body: isSearching
          ? _buildSearchResults()
          : defautContent(),
      ),
    );
  }


  Widget defautContent() {
    return ListView(
      scrollDirection: Axis.vertical,
      children: <Widget>[
        Container( // For You
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
                      if (movies?[position].posterPath != null) {
                        image = NetworkImage(
                          iconBase + movies?[position].posterPath,
                        );
                      } else {
                        image = NetworkImage(defaultImage);
                      }
                      return Card(
                        color: Colors.white,
                        elevation: 2.0,
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
                                      MovieDetail(movies?[position]),
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
                                      movies?[position].title ?? '',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      '${'Released: ' + (movies?[position].releaseDate ?? '')} - Vote: ${movies![position].voteAverage}',
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
                    },
                  );
                }).toList(),
              ),
            ],
          ),
        ),
        Container( // Because You Watched
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
                child: Text('Because You Watched', textScaler: TextScaler.linear(1.2)),
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
                      if (movies?[position].posterPath != null) {
                        image = NetworkImage(
                          iconBase + movies?[position].posterPath,
                        );
                      } else {
                        image = NetworkImage(defaultImage);
                      }
                      return Card(
                        color: Colors.white,
                        elevation: 2.0,
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
                                      MovieDetail(movies?[position]),
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
                                      movies?[position].title ?? '',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      '${'Released: ' + (movies?[position].releaseDate ?? '')} - Vote: ${movies![position].voteAverage}',
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
    movies = (await helper?.getUpcoming())!;
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
    return ListView.builder(
      itemCount: searchCount ?? 0,
      scrollDirection: Axis.vertical,
      itemBuilder: (BuildContext context, int index) {
        if (searchResults?[index].posterPath != null) {
          image = NetworkImage(iconBase + searchResults?[index].posterPath);
        } else {
          image = NetworkImage(defaultImage);
        }
        return Card(
          color: Colors.white,
          elevation: 2.0,
          child: Container(
            width: 300,
            height: 300,
            child: ListTile(
              onTap: () {
                MaterialPageRoute route = MaterialPageRoute(
                  builder: (_) => MovieDetail(searchResults?[index]),
                );
                Navigator.push(context, route);
              },
              leading: CircleAvatar(backgroundImage: image),
              title: Text(searchResults?[index].title),
              subtitle: Text(
                '${'Released: ' + searchResults?[index].releaseDate} - Vote: ${searchResults![index].voteAverage}',
              ),
            ),
          ),
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
      await db?.insertUserTest();
    } catch (e) {
      print(e.toString());
      print("Could not test db");
    }
  }
}
