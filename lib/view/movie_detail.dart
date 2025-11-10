import 'package:flutter/material.dart';
import 'package:notflix/model/movie.dart';
import 'package:notflix/util/api.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class MovieDetail extends StatefulWidget {
  final Movie movie;
  final String imgPath = 'https://image.tmdb.org/t/p/w500/';
  const MovieDetail(this.movie, {super.key});

  @override
  State<MovieDetail> createState() => _MovieDetailState();
}

class _MovieDetailState extends State<MovieDetail> {
  YoutubePlayerController? _controller;
  bool isLoading = true;
  bool hasTrailer = false;

  @override
  void initState() {
    super.initState();
    _loadTrailer();
  }

  Future<void> _loadTrailer() async {
    final api = APIRunner();
    final trailerKey = await api.getTrailerKey(widget.movie.id.toString());
    if (trailerKey != null) {
      _controller = YoutubePlayerController.fromVideoId(
        videoId: trailerKey,
        autoPlay: true,
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

  @override
  void dispose() {
    _controller?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    String posterUrl = widget.imgPath + widget.movie.posterPath;

    return Scaffold(
      appBar: AppBar(title: Text(widget.movie.title)),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    height: height / 2,
                    padding: const EdgeInsets.all(16),
                    child: hasTrailer
                        ? YoutubePlayer(
                            controller: _controller!,
                            aspectRatio: 16 / 9,
                          )
                        : Image.network(posterUrl),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(widget.movie.overview),
                  ),
                ],
              ),
            ),
    );
  }
}
