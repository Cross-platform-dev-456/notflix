//Username   brewern5_db_user
//PW   dHnGqHWw2naNGR6U

import 'package:mongo_dart/mongo_dart.dart';

final String dbString = 'mongodb://brewern5_db_user:dHnGqHWw2naNGR6U@test.ywzop73.mongodb.net:27017/mongo_dart-blog?retryWrites=true&w=majority&appName=test';

class DbConnection {

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