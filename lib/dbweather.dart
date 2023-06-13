import 'dart:io';

import 'package:sqflite/sqflite.dart'
show Database, getDatabasesPath, openDatabase;
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';

class weatherdb {
  static Database? _database;
  static Directory? appDocDir;
  static Future<void> initDb() async {
    final dbPath = await getDatabasesPath();
    appDocDir = await getApplicationSupportDirectory();
    _database = await openDatabase(join(dbPath, "weather.db"),
        version: 1,
        onOpen: (db) {}, onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE user ("
          "id int PRIMARY KEY,"
          "username TEXT,"
          "email TEXT,"
          "password TEXT"
          ")");
          
    });
  }

  /*updateData(
      {required String table,
      required String id,
      required Map<String, Object?> data}) async {
    _database!.transaction((txn) async {
      await txn.update(table, data, where: "id = ?", whereArgs: [id]);
    });
  }
*/
  getLastEntry() async {
    final result = await _database!
        .rawQuery('SELECT * FROM user');
        print("data is--------------$result");
    return result.last;
  }

  /*getRoomEntry({required String id}) async {
    final result =
        await _database!.rawQuery('SELECT * FROM Room WHERE id=?', [id]);
    print("voici le resulat ----------------$result");
    return result.isNotEmpty ? result.first : null;
  }*/

  /*getMessageEntry({required String id}) async {
    final result =
        await _database!.rawQuery('SELECT * FROM Message WHERE id=?', [id]);
    print("voici ----------------$result");
    return result.isNotEmpty ? result.first : null;
  }*/

  createData(
      {required Map<String, Object?> data}) async {
    _database!.transaction((txn) async {
      await txn.insert("user", data).catchError((error) {
        print("error is --------------$error");
      });
    });
  }

  /*Future<List> getMessagesByRoomId(
      {required String id, required int limit, int page = 0}) {
    final offset = (page) * limit;
    return _database!.transaction((txn) async {
      var result = await txn.rawQuery(
          '''SELECT * FROM Message WHERE roomID=? ORDER BY createdAt DESC LIMIT ? OFFSET ?''',
          [id, limit, offset]);
      return result;
    });
  }*/

  /*Future<List> getRooms({required int limit, required int page}) {
    return _database!.transaction((txn) async {
      var result = await txn.rawQuery('SELECT * FROM Room ORDER BY createdAt');
      return result;
    });
  }*/
}







