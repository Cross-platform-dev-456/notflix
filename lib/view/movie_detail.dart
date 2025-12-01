import 'package:flutter/material.dart';
import 'package:notflix/model/movie.dart';
import 'package:notflix/model/tvShow.dart';
import 'package:notflix/model/episode.dart';
import 'package:notflix/util/api.dart';
import 'package:notflix/view/widgets/watch_list_buttons.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class MovieDetail extends StatefulWidget {
  final dynamic item; // Can be Movie or TvShow
  final String imgPath = 'https://image.tmdb.org/t/p/w500/';
  const MovieDetail(this.item, {super.key});

  @override
  State<MovieDetail> createState() => _MovieDetailState();
}

class _MovieDetailState extends State<MovieDetail> {
  YoutubePlayerController? _controller;
  bool isLoading = true;
  bool hasTrailer = false;
  bool isTvShow = false;
  Map<String, dynamic>? tvShowDetails;
  List<Episode> episodes = [];
  List<int> seasons = [];
  int selectedSeason = 1;
  bool isLoadingEpisodes = false;

  @override
  void initState() {
    super.initState();
    isTvShow = widget.item is TvShow;
    _loadData();
  }

  Future<void> _loadData() async {
    final api = APIRunner();
    
    if (isTvShow) {
      // Load TV show details and trailer
      final tvShow = widget.item as TvShow;
      final details = await api.getTvShowDetails(tvShow.id.toString());
      
      if (details != null) {
        setState(() {
          tvShowDetails = details;
          // Get available seasons
          if (details['seasons'] != null) {
            seasons = (details['seasons'] as List)
                .where((s) => s['season_number'] != null && s['season_number'] >= 0)
                .map((s) => s['season_number'] as int)
                .toList()
              ..sort();
            if (seasons.isNotEmpty) {
              selectedSeason = seasons.first;
            }
          }
        });
        
        // Load episodes for first season
        if (seasons.isNotEmpty) {
          await _loadEpisodes(selectedSeason);
        }
      }
      
      // Load trailer
      final trailerKey = await api.getTvTrailerKey(tvShow.id.toString());
      if (trailerKey != null) {
        _controller = YoutubePlayerController.fromVideoId(
          videoId: trailerKey,
          autoPlay: false,
          params: const YoutubePlayerParams(
            showFullscreenButton: true,
            enableKeyboard: true,
            strictRelatedVideos: true,
          ),
        );
        setState(() {
          hasTrailer = true;
          isLoading = false;
        });
      } else {
        setState(() {
          hasTrailer = false;
          isLoading = false;
        });
      }
    } else {
      // Load movie trailer
      final movie = widget.item as Movie;
      final trailerKey = await api.getTrailerKey(movie.id.toString());
      if (trailerKey != null) {
        _controller = YoutubePlayerController.fromVideoId(
          videoId: trailerKey,
          autoPlay: false,
          params: const YoutubePlayerParams(
            showFullscreenButton: true,
            enableKeyboard: true,
            strictRelatedVideos: true,
          ),
        );
        setState(() {
          hasTrailer = true;
          isLoading = false;
        });
      } else {
        setState(() {
          hasTrailer = false;
          isLoading = false;
        });
      }
    }
  }

  Future<void> _loadEpisodes(int seasonNumber) async {
    if (!isTvShow) return;
    
    setState(() {
      isLoadingEpisodes = true;
    });

    final api = APIRunner();
    final tvShow = widget.item as TvShow;
    final seasonData = await api.getTvSeasonEpisodes(tvShow.id.toString(), seasonNumber);
    
    if (seasonData != null && seasonData['episodes'] != null) {
      final episodesList = (seasonData['episodes'] as List)
          .map((e) => Episode.fromJson(e))
          .toList();
      
      setState(() {
        episodes = episodesList;
        isLoadingEpisodes = false;
      });
    } else {
      setState(() {
        episodes = [];
        isLoadingEpisodes = false;
      });
    }
  }

  @override
  void dispose() {
    _controller?.close();
    super.dispose();
  }

  String getTitle() {
    if (isTvShow) {
      return (widget.item as TvShow).title;
    } else {
      return (widget.item as Movie).title;
    }
  }

  String getOverview() {
    if (isTvShow) {
      return (widget.item as TvShow).overview;
    } else {
      return (widget.item as Movie).overview;
    }
  }

  String getPosterPath() {
    if (isTvShow) {
      return (widget.item as TvShow).posterPath;
    } else {
      return (widget.item as Movie).posterPath;
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    String posterUrl = widget.imgPath + getPosterPath();

    return Scaffold(
      appBar: AppBar(title: Text(getTitle())),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Trailer or Poster
                  Container(
                    height: height / 2,
                    padding: const EdgeInsets.all(16),
                    alignment: Alignment.center,
                    child: hasTrailer
                        ? Center(
                            child: YoutubePlayer(
                              controller: _controller!,
                              aspectRatio: 16 / 9,
                            ),
                          )
                        : Image.network(
                            posterUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Center(
                                child: Icon(Icons.error, size: 50),
                              );
                            },
                          ),
                  ),
                  
                  // Overview
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Overview',
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          getOverview().isEmpty 
                              ? 'No overview available.' 
                              : getOverview(),
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ],
                    ),
                  ),

                  // TV Show Episodes Section
                  if (isTvShow && seasons.isNotEmpty) ...[
                    const Divider(),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Episodes',
                                style: Theme.of(context).textTheme.headlineMedium,
                              ),
                              // Season Selector
                              DropdownButton<int>(
                                value: selectedSeason,
                                items: seasons.map((season) {
                                  return DropdownMenuItem<int>(
                                    value: season,
                                    child: Text('Season $season'),
                                  );
                                }).toList(),
                                onChanged: (int? newSeason) {
                                  if (newSeason != null) {
                                    setState(() {
                                      selectedSeason = newSeason;
                                    });
                                    _loadEpisodes(newSeason);
                                  }
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          if (isLoadingEpisodes)
                            const Center(child: CircularProgressIndicator())
                          else if (episodes.isEmpty)
                            const Text('No episodes available for this season.')
                          else
                            ...episodes.map((episode) => _buildEpisodeCard(episode)),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
    );
  }

  Widget _buildEpisodeCard(Episode episode) {
    final String imgPath = 'https://image.tmdb.org/t/p/w500/';
    String? episodeImageUrl = episode.stillPath != null 
        ? imgPath + episode.stillPath! 
        : null;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: const Color(0xFF181818),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Episode Image
            if (episodeImageUrl != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Image.network(
                  episodeImageUrl,
                  width: 120,
                  height: 80,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 120,
                      height: 80,
                      color: Colors.grey[800],
                      child: const Icon(Icons.image, color: Colors.grey),
                    );
                  },
                ),
              )
            else
              Container(
                width: 120,
                height: 80,
                color: Colors.grey[800],
                child: const Icon(Icons.image, color: Colors.grey),
              ),
            const SizedBox(width: 12),
            // Episode Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'E${episode.episodeNumber}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          episode.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  if (episode.airDate.isNotEmpty)
                    Text(
                      episode.airDate,
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 12,
                      ),
                    ),
                  if (episode.runtime > 0) ...[
                    const SizedBox(height: 4),
                    Text(
                      '${episode.runtime} min',
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 12,
                      ),
                    ),
                  ],
                  if (episode.overview.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(
                      episode.overview,
                      style: TextStyle(
                        color: Colors.grey[300],
                        fontSize: 13,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
