import 'dart:io';
import 'dart:async';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class AppDatabase {
  static final AppDatabase _appDatabase = new AppDatabase._internal();

  Database _db;
  bool didInit = false;

  factory AppDatabase() {
    return _appDatabase;
  }

  AppDatabase._internal();

  Future<Database> getDb() async {
    if (!didInit) await _initDatabase();
    return _db;
  }

  Future _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "maui.db");

    _db = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      // When creating the db, create the table
      await db.execute(
          "CREATE TABLE User (id TEXT PRIMARY KEY, name TEXT, image TEXT)");
    });
    didInit = true;
  }
}
