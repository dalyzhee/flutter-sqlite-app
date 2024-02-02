import 'package:flutter_sqlite/models/planets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _databaseHelper = DatabaseHelper._();

  DatabaseHelper._();

  late Database db;

  factory DatabaseHelper() {
    return _databaseHelper;
  }
  Future<void> initDB() async {
    String path = await getDatabasesPath();
    db = await openDatabase(
      join(path, 'users_demo.db'),
      onCreate: (database, version) async {
        await database.execute(
          """
            CREATE TABLE users (
              id INTEGER PRIMARY KEY AUTOINCREMENT, 
              name TEXT NOT NULL,
              age INTEGER NOT NULL, 
              email TEXT NOT NULL
            )
          """,
        );
      },
      version: 1,
    );
  }

  Future<int> insertUser(List<Users> users) async {
    int result = 0;
    for (var user in users) {
      result = await db.insert("users", user.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    }

    return result;
  }

  Future<int> updateUser(Users user) async {
    int result = await db.update(
      "users",
      user.toMap(),
      where: "id=?",
      whereArgs: [user.id],
    );
    return result;
  }

  Future<List<Users>> retrieveUsers() async {
    final List<Map<String, Object?>> queryResult = await db.query("users");
    return queryResult.map((e) => Users.fromMap(e)).toList();
  }

  Future<void> deleteUser(int id) async {
    await db.delete("users", where: "id=?", whereArgs: [id]);
  }
}
