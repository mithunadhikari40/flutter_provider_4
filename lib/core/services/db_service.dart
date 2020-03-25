import 'dart:async';
import 'dart:io';
import 'package:flutter_provider_arch/core/constants/app_contstants.dart';
import 'package:flutter_provider_arch/core/models/user.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DbService {
  Database db;
  DbService() {
    _init();
  }
  Future _init() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, AppConstants.DB_NAME);
    db = await openDatabase(path, version: 2,
        onCreate: (Database newDb, int newVersion) {
      Batch batch = newDb.batch();
      batch.execute("""
            CREATE TABLE ${AppConstants.USER_TABLE}
            (
              id INTEGER PRIMARY KEY,
              name TEXT,
              username TEXT
            )
          """);

      batch.execute("""
          CREATE TABLE ${AppConstants.PLACE_TABLE}
          (
            id TEXT PRIMARY KEY,
            title TEXT,
            address TEXT,
            imagePath TEXT,
            latitude REAL,
            longiture REAL
          )
    """);

      batch.commit();
    }, onUpgrade: _onDbUpgrade);
  }

  Future<User> fetchUser() async {
    final data = await db.query(AppConstants.USER_TABLE);
    if (data.length < 1) {
      return null;
    }
    return User.fromJson(data.first);
  }

  Future<int> insertUser(User user) async {
    return db.insert(AppConstants.USER_TABLE, user.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future _onDbUpgrade(Database newDb, int oldVersion, int newVersion) async {
    Batch batch = newDb.batch();
    batch.execute("""
          CREATE TABLE ${AppConstants.PLACE_TABLE}
          (
            id TEXT PRIMARY KEY,
            title TEXT,
            address TEXT,
            imagePath TEXT,
            latitude REAL,
            longiture REAL
          )
    """);
    batch.commit();
  }
}
