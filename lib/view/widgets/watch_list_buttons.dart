import 'package:flutter/material.dart';
import 'package:notflix/util/db.dart';

class WatchListButtons extends StatefulWidget {
  final int showId;
  final String showTitle;
  final String showPosterPath;
  final Map<String, dynamic> showData;

  const WatchListButtons({
    super.key,
    required this.showId,
    required this.showTitle,
    required this.showPosterPath,
    required this.showData,
  });

  @override
  State<WatchListButtons> createState() => _WatchListButtonsState();
}

class _WatchListButtonsState extends State<WatchListButtons> {
  final DbConnection db = DbConnection();
  bool isLoggedIn = false;
  bool inRecentlyWatched = false;
  bool inWatchLater = false;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkLoginAndWatchStatus();
  }

  Future<void> _checkLoginAndWatchStatus() async {
    setState(() => isLoading = true);
    
    // Check if user is logged in
    isLoggedIn = db.checkUserLogStatus();
    
    if (isLoggedIn) {
      // Get current user ID from authStore
      final userId = pb.authStore.model?.id;
      
      if (userId != null) {
        // Check if show is in any lists
        final status = await db.checkShowInWatchList(userId, widget.showId);
        setState(() {
          inRecentlyWatched = status['recently_watched'] ?? false;
          inWatchLater = status['watch_later'] ?? false;
        });
      }
    }
    
    setState(() => isLoading = false);
  }

  Future<void> _toggleRecentlyWatched() async {
    if (!isLoggedIn) return;
    
    final userId = pb.authStore.model?.id;
    if (userId == null) return;
    
    setState(() => isLoading = true);
    
    bool success;
    if (inRecentlyWatched) {
      success = await db.removeShowFromWatchList(userId, widget.showId, 'recently_watched');
    } else {
      success = await db.addShowToWatchList(
        userId, 
        widget.showId, 
        widget.showData,
        'recently_watched'
      );
    }
    
    if (success) {
      setState(() => inRecentlyWatched = !inRecentlyWatched);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            inRecentlyWatched 
              ? 'Added to Recently Watched' 
              : 'Removed from Recently Watched'
          ),
          duration: const Duration(seconds: 2),
        ),
      );
    }
    
    setState(() => isLoading = false);
  }

  Future<void> _toggleWatchLater() async {
    if (!isLoggedIn) return;
    
    final userId = pb.authStore.model?.id;
    if (userId == null) return;
    
    setState(() => isLoading = true);
    
    bool success;
    if (inWatchLater) {
      success = await db.removeShowFromWatchList(userId, widget.showId, 'watch_later');
    } else {
      success = await db.addShowToWatchList(
        userId, 
        widget.showId, 
        widget.showData,
        'watch_later'
      );
    }
    
    if (success) {
      setState(() => inWatchLater = !inWatchLater);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            inWatchLater 
              ? 'Added to Watch Later' 
              : 'Removed from Watch Later'
          ),
          duration: const Duration(seconds: 2),
        ),
      );
    }
    
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    if (!isLoggedIn) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.info_outline, color: Colors.grey[600]),
                const SizedBox(width: 8),
                Text(
                  'Log in to save to your watch list',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ),
      );
    }

    if (isLoading) {
      return const Padding(
        padding: EdgeInsets.all(16.0),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Recently Watched Checkbox
          CheckboxListTile(
            value: inRecentlyWatched,
            onChanged: (bool? value) => _toggleRecentlyWatched(),
            title: const Text('Recently Watched'),
            subtitle: Text(
              inRecentlyWatched 
                ? 'Marked as watched' 
                : 'Mark this as watched'
            ),
            secondary: Icon(
              Icons.history,
              color: inRecentlyWatched ? Colors.green : null,
            ),
            activeColor: Colors.green,
            controlAffinity: ListTileControlAffinity.trailing,
          ),
          const Divider(),
          // Watch Later Checkbox
          CheckboxListTile(
            value: inWatchLater,
            onChanged: (bool? value) => _toggleWatchLater(),
            title: const Text('Watch Later'),
            subtitle: Text(
              inWatchLater 
                ? 'Saved to watch later' 
                : 'Save to watch later'
            ),
            secondary: Icon(
              Icons.bookmark,
              color: inWatchLater ? Colors.blue : null,
            ),
            activeColor: Colors.blue,
            controlAffinity: ListTileControlAffinity.trailing,
          ),
        ],
      ),
    );
  }
}
