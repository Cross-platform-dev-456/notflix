import 'package:flutter/material.dart';
import 'package:notflix/util/api.dart';
import 'package:notflix/model/movie.dart';
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
  const Profile({super.key});

  @override
  State<StatefulWidget> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String? results;
  APIRunner? helper;
  DbConnection? db;

  List<Movie> watchLaterMovies = [];
  List<Movie> recentlyWatchedMovies = [];
  bool isLoading = true;

  final String iconBase = 'https://image.tmdb.org/t/p/w500/';
  final String defaultImage =
      'https://images.freeimages.com/images/large-previews/5eb/movie-clapboard-1184339.jpg';

  @override
  void initState() {
    super.initState();
    helper = APIRunner();
    db = DbConnection();
    _loadWatchLists();
  }

  Future<void> _loadWatchLists() async {
    setState(() => isLoading = true);
    
    final userId = pb.authStore.model?.id;
    if (userId != null) {
      final watchLaterData = await db!.getWatchLaterShows(userId);
      final recentlyWatchedData = await db!.getRecentlyWatchedShows(userId);
      
      print("Watch Later data count: ${watchLaterData.length}");
      print("Recently Watched data count: ${recentlyWatchedData.length}");
      
      setState(() {
        watchLaterMovies = watchLaterData.map((data) => Movie.fromJson(data)).toList();
        recentlyWatchedMovies = recentlyWatchedData.map((data) => Movie.fromJson(data)).toList();
        print("Watch Later movies: ${watchLaterMovies.length}");
        print("Recently Watched movies: ${recentlyWatchedMovies.length}");
        isLoading = false;
      });
    } else {
      setState(() => isLoading = false);
    }
  }

  void _logout() {
    // Clear the PocketBase auth store
    db = DbConnection();
    // PocketBase auth store can be accessed via the global pb instance
    // Clear authentication
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Logout'),
          content: Text('Are you sure you want to logout?'),
          actions: [
            // Cancel
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
              },
              child: Text('Cancel'),
            ),
            // Log-out
            TextButton(
              onPressed: () {
                // Perform logout
                db!.logoutUser();
                Navigator.of(context).pop(); // Close dialog
                // Return to main page and clear navigation stack
                Navigator.of(context).pushNamedAndRemoveUntil(
                  '/',
                  (route) => false,
                );
              },
              child: Text('Logout'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: _logout,
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    // Watch Later Section
                    Container(
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
                              'Watch Later (${watchLaterMovies.length})',
                              textScaler: TextScaler.linear(1.2),
                            ),
                          ),
                          watchLaterMovies.isEmpty
                              ? Padding(
                                  padding: const EdgeInsets.all(30.0),
                                  child: Text(
                                    'No movies in watch later list',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                )
                              : Container(
                                  height: 350,
                                  alignment: Alignment.centerLeft,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    shrinkWrap: true,
                                    itemCount: watchLaterMovies.length,
                                    itemBuilder: (BuildContext context, int position) {
                                      return MovieCard(
                                        movie: watchLaterMovies[position],
                                        iconBase: iconBase,
                                        defaultImage: defaultImage,
                                      );
                                    },
                                  ),
                                ),
                        ],
                      ),
                    ),
                    // Recently Watched Section
                    Container(
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
                              'Recently Watched (${recentlyWatchedMovies.length})',
                              textScaler: TextScaler.linear(1.2),
                            ),
                          ),
                          recentlyWatchedMovies.isEmpty
                              ? Padding(
                                  padding: const EdgeInsets.all(30.0),
                                  child: Text(
                                    'No recently watched movies',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                )
                              : Container(
                                  height: 350,
                                  alignment: Alignment.centerLeft,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    shrinkWrap: true,
                                    itemCount: recentlyWatchedMovies.length,
                                    itemBuilder: (BuildContext context, int position) {
                                      return MovieCard(
                                        movie: recentlyWatchedMovies[position],
                                        iconBase: iconBase,
                                        defaultImage: defaultImage,
                                      );
                                    },
                                  ),
                                ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
