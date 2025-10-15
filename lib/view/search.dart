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
  int? moviesCount;
  List? movies;
  DbConnection? db;

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
    // pop scope prevents multfinger gestures from happening on the page
    return PopScope(
      canPop: false, 
      child: Scaffold(
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
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: ()async  => await testDb(),
          ),
        ]),
        body: ListView(
          scrollDirection: Axis.vertical,
          children: <Widget>[
            Container(      // For You 
              margin: EdgeInsets.all(20.0),
              child: Column(
                spacing: 5.0,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left:30.0, top: 5.0, bottom: 5.0),
                    child: Text('For You', textScaler: TextScaler.linear(1.2),),
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
                              child: ListTile(
                                onTap: () {
                                  MaterialPageRoute route = MaterialPageRoute(
                                    builder: (_) =>
                                        MovieDetail(movies?[position]),
                                  );
                                  Navigator.push(context, route);
                                },
                                leading: CircleAvatar(backgroundImage: image),
                                title: Text(movies?[position].title),
                                subtitle: Text(
                                  '${'Released: ' + movies?[position].releaseDate} - Vote: ${movies![position].voteAverage}',
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
            Container(      // Because You Watched
              margin: EdgeInsets.all(20.0),
              child: Column(
                spacing: 5.0,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left:30.0, top: 5.0, bottom: 5.0),
                    child: Text('Because You watched', textScaler: TextScaler.linear(1.2),),
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
                              child: ListTile(
                                onTap: () {
                                  MaterialPageRoute route = MaterialPageRoute(
                                    builder: (_) =>
                                        MovieDetail(movies?[position]),
                                  );
                                  Navigator.push(context, route);
                                },
                                leading: CircleAvatar(backgroundImage: image),
                                title: Text(movies?[position].title),
                                subtitle: Text(
                                  '${'Released: ' + movies?[position].releaseDate} - Vote: ${movies![position].voteAverage}',
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
        ),
      ),
    );
  }

  // Create a search by different attributes. I.e Genre, name, actor

  Future search(text) async {

    // Todo: clear search screen and display the results a vertical scroll


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

  testDb() async {
    try{
      db = DbConnection();
      await db?.insertUserTest();
    } catch (e) {
      print(e.toString());
      print("Could not test db");
    }
  }

}