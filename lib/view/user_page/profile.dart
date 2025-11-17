import 'package:flutter/material.dart';
import 'package:notflix/util/api.dart';
import '../movie_detail.dart';
import 'package:notflix/util/db.dart';
import 'package:carousel_slider/carousel_slider.dart';

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

class Profile extends StatefulWidget {
  State<StatefulWidget> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String? results;
  APIRunner? helper;
  DbConnection? db; 

  int? moviesCount;
  List? movies;

  final String iconBase = 'https://image.tmdb.org/t/p/w500/';
  final String defaultImage =
      'https://images.freeimages.com/images/large-previews/5eb/movie-clapboard-1184339.jpg';


  Widget build(BuildContext context) {
    helper = APIRunner();

    return Scaffold(
      appBar : AppBar(
        title: Text("Profile"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              // Watch-List
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
                    child: Text('Watch-List', textScaler: TextScaler.linear(1.2)),
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
              // Recently Watched
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
                      'Recently Watched',
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
        ),
      ),
    );
  }
}