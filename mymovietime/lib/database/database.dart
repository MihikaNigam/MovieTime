import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

class DatabaseHelper {
  /*static String TABLE_MOVIES="Movie";
  static String COL_ID="id";
  static String COL_NAME="name";
  static String COL_IMG="poster";
  static String COL_Director="director";*/
  static Future<Database> createdatabase() async {
    String dbpath = await getDatabasesPath();
    return await openDatabase(join(dbpath, 'movies.db'),
        onCreate: (db, version) {
      print('creating table');
      return db.execute(
          'CREATE TABLE movies_list(id TEXT PRIMARY KEY, name TEXT, director TEXT, image TEXT)');
    }, version: 1);
  }

  static Future<List<Map<String, dynamic>>> getData(String table) async {
    final db = await DatabaseHelper.createdatabase();
    return db.query(table);
  }

  static Future<void> insert(String table, Map<String, Object> data) async {
    final db = await DatabaseHelper.createdatabase();
     db.insert(table, data, conflictAlgorithm: ConflictAlgorithm.replace);
  }
  static Future<void> delete(String table, String id) async {
    final db = await DatabaseHelper.createdatabase();
     db.delete(table,where: "id = ?",whereArgs: [id] );
  }
  static Future<void> update(String table,  Map<String, Object> data) async {
    final db = await DatabaseHelper.createdatabase();
     db.update(table,
     data,
     where: "id = ?",whereArgs: [data['id']] );
  }
  

}
