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

  bool checkUserLogStatus() {
    if (pb.authStore.isValid) { return true; }
    return false;
  }
/*

  Future<RecordAuth?> _logInUser (String email, String password) async {
    
  

    print(pb.authStore.record);
    print(pb.authStore.token);

    return userData;
  }

*/

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