import 'package:pocketbase/pocketbase.dart';

final pb = PocketBase('http://127.0.0.1:8090');
class DbConnection {

  Future<List?> getUserList() async {
    try {
      // Authenticate first (this sets pb.authStore.token)
      final authData = await pb.collection('user').getList();
      
      print(authData);
      
      // Now fetch the list (authenticated request will include token)
      final result = await pb.collection('users').getList(
        page: 1,
        perPage: 30,
      );
      
      print("Records found: ${result.items.length}");
      for (var record in result.items) {
        print(record.toJson());
      }
      
      return result.items;
    } catch (e) {
      print("Error: $e");
      return null;
    }
  }

  Future<bool> logInUser(String email, String password) async {
    // Pocket base will automatically handle 
    bool loggedIn = false;
    try{
      final authData = await pb.collection('users').authWithPassword(
        email, 
        password
      );
      loggedIn = true;
      print("User logged in with ID: ${authData.record.id}");
    } catch(e) {
      print("Log in failed");
    }
    return loggedIn;
  }

  void logoutUser() { 
    try {
      pb.authStore.clear();
    } catch(e) {
      print(e);
    }
  }

  bool checkUserLogStatus() {
    if (pb.authStore.isValid) { return true; }
    return false;
  }

  // Check if a show exists in user's watch list (either recently_watched or watch_later)
  Future<Map<String, bool>> checkShowInWatchList(String userId, int showId) async {
    try {
      // Get the user's watch list record
      final records = await pb.collection('user_watch_lists').getList(
        filter: 'field = "$userId"',
      );
      
      if (records.items.isEmpty) {
        return {'recently_watched': false, 'watch_later': false};
      }
      
      final record = records.items.first;
      final recentlyWatched = record.data['recently_watched'] as Map<String, dynamic>? ?? {};
      final watchLater = record.data['watch_later'] as Map<String, dynamic>? ?? {};
      
      return {
        'recently_watched': recentlyWatched.containsKey(showId.toString()),
        'watch_later': watchLater.containsKey(showId.toString()),
      };
    } catch (e) {
      print("Error checking show in watch list: $e");
      return {'recently_watched': false, 'watch_later': false};
    }
  }

  // Add a show to either recently_watched or watch_later
  Future<bool> addShowToWatchList(
    String userId, 
    int showId, 
    Map<String, dynamic> showData,
    String listType, // 'recently_watched' or 'watch_later'
  ) async {
    try {
      // Get existing watch list record or create new one
      final records = await pb.collection('user_watch_lists').getList(
        filter: 'field = "$userId"',
      );
      
      Map<String, dynamic> recentlyWatched = {};
      Map<String, dynamic> watchLater = {};
      String? recordId;
      
      if (records.items.isNotEmpty) {
        final record = records.items.first;
        recordId = record.id;
        recentlyWatched = Map<String, dynamic>.from(
          record.data['recently_watched'] as Map<String, dynamic>? ?? {}
        );
        watchLater = Map<String, dynamic>.from(
          record.data['watch_later'] as Map<String, dynamic>? ?? {}
        );
      }
      
      // Add show to the specified list
      if (listType == 'recently_watched') {
        recentlyWatched[showId.toString()] = showData;
      } else if (listType == 'watch_later') {
        watchLater[showId.toString()] = showData;
      } else {
        print("Invalid list type: $listType");
        return false;
      }
      
      // Update or create the record
      if (recordId != null) {
        await pb.collection('user_watch_lists').update(recordId, body: {
          'recently_watched': recentlyWatched,
          'watch_later': watchLater,
        });
      } else {
        await pb.collection('user_watch_lists').create(body: {
          'user': userId,
          'recently_watched': recentlyWatched,
          'watch_later': watchLater,
        });
      }
      
      print("Show $showId added to $listType for user $userId");
      return true;
    } catch (e) {
      print("Error adding show to watch list: $e");
      return false;
    }
  }

  // Remove a show from either recently_watched or watch_later
  Future<bool> removeShowFromWatchList(
    String userId, 
    int showId,
    String listType, // 'recently_watched' or 'watch_later'
  ) async {
    try {
      // Get the user's watch list record
      final records = await pb.collection('user_watch_lists').getList(
        filter: 'field = "$userId"',
      );
      
      if (records.items.isEmpty) {
        print("No watch list found for user $userId");
        return false;
      }
      
      final record = records.items.first;
      Map<String, dynamic> recentlyWatched = Map<String, dynamic>.from(
        record.data['recently_watched'] as Map<String, dynamic>? ?? {}
      );
      Map<String, dynamic> watchLater = Map<String, dynamic>.from(
        record.data['watch_later'] as Map<String, dynamic>? ?? {}
      );
      
      // Remove show from the specified list
      bool removed = false;
      if (listType == 'recently_watched') {
        removed = recentlyWatched.remove(showId.toString()) != null;
      } else if (listType == 'watch_later') {
        removed = watchLater.remove(showId.toString()) != null;
      } else {
        print("Invalid list type: $listType");
        return false;
      }
      
      if (!removed) {
        print("Show $showId not found in $listType");
        return false;
      }
      
      // Update the record
      await pb.collection('user_watch_lists').update(record.id, body: {
        'recently_watched': recentlyWatched,
        'watch_later': watchLater,
      });
      
      print("Show $showId removed from $listType for user $userId");
      return true;
    } catch (e) {
      print("Error removing show from watch list: $e");
      return false;
    }
  }

  // Get all shows from watch later list
  Future<List<Map<String, dynamic>>> getWatchLaterShows(String userId) async {
    try {
      final records = await pb.collection('user_watch_lists').getList(
        filter: 'field = "$userId"',
      );
      
      if (records.items.isEmpty) {
        return [];
      }
      
      final record = records.items.first;
      final watchLater = record.data['watch_later'] as Map<String, dynamic>? ?? {};
      
      // Convert the map values to a list
      return watchLater.values.map((show) => show as Map<String, dynamic>).toList();
    } catch (e) {
      print("Error getting watch later shows: $e");
      return [];
    }
  }

  // Get all shows from recently watched list
  Future<List<Map<String, dynamic>>> getRecentlyWatchedShows(String userId) async {
    try {
      final records = await pb.collection('user_watch_lists').getList(
        filter: 'field = "$userId"',
      );
      
      if (records.items.isEmpty) {
        return [];
      }
      
      final record = records.items.first;
      final recentlyWatched = record.data['recently_watched'] as Map<String, dynamic>? ?? {};
      
      // Convert the map values to a list
      return recentlyWatched.values.map((show) => show as Map<String, dynamic>).toList();
    } catch (e) {
      print("Error getting recently watched shows: $e");
      return [];
    }
  }

}
/*
  Future<Db> openDb() async {

    var db = Db(dbString);

    await db.open();

    return db;
  }

  /*  
    The action that is desired should be sent as a lambda function, for example findOne() should be passed
  */
  Future<E> _performDatabaseOperation<E>(
    String collectionName,
    Future<E> Function(DbCollection) action, 
  ) async {
      late Db db;
    try{
      db = await openDb();

      var collection = db.collection(collectionName);

      return await action(collection);

    } catch(lateInitializationError){
      rethrow;
    } finally {
      try{ 
        db.close();
      } catch(lateInitializationError){
        // TODO: Something here
      }
    }
  }

  Future<Map<String, dynamic>?> getUserInfo(String userId) async {

    return await _performDatabaseOperation(
      'user', 
      (collection) => collection.findOne(
        where
        .eq('id',userId)
      )
    );
  }

  Future<Map<String, dynamic>?> getRecentlyWatched(String userId) async {

    return await _performDatabaseOperation(
      'users',
     (collection) => collection.findOne(
        where
        .eq("id", userId)
        .fields(['recently_watched'])
      )
    );
  }

  Future<Map<String, dynamic>?> getWatchList(String userId) async {

    return await _performDatabaseOperation(
      'users',
      (collection) => collection.findOne(
        where
        .eq('id', userId)
        .fields(['watchlist'])
      )
    );
  }

  Future<void> insertUserTest() async {

    String collection = 'user';

    var insertReturn = await _performDatabaseOperation(
      collection, 
      (collection) => collection.insertOne({
        'username': 'Joe',
        'watchlist': [],
        'recently_watched': [],
      })
    );

    print(insertReturn);

  }

}
*/