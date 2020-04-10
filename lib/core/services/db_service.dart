import 'dart:async';
import 'dart:io';
import 'package:flutter_provider_arch/core/constants/app_contstants.dart';
import 'package:flutter_provider_arch/core/models/places.dart';
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
    db = await openDatabase(path, version: 4,
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
            longitude REAL
          )
    """);
      batch.execute(
          """ALTER TABLE ${AppConstants.PLACE_TABLE} ADD COLUMN synced INTEGER DEFAULT 0 """);
      batch.execute(
          """ALTER TABLE ${AppConstants.PLACE_TABLE} ADD COLUMN rating REAL""");

      batch.commit();
    }, onUpgrade: _onDbUpgrade);
  }

  Future<User> fetchUser() async {
    if (db == null) {
      await _init();
    }
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

  List<List<String>> getMigrations() {
    List<List<String>> migrations = [];
    List<String> migrationOne = [
      """
          CREATE TABLE ${AppConstants.PLACE_TABLE}
          (
            id TEXT PRIMARY KEY,
            title TEXT,
            address TEXT,
            imagePath TEXT,
            latitude REAL,
            longitude REAL
          )
    """
    ];
    List<String> migrationTwo = [
      "ALTER TABLE ${AppConstants.PLACE_TABLE} ADD COLUMN synced INTEGER DEFAULT 0",
    ];
    List<String> migrationThree = [
      """ALTER TABLE ${AppConstants.PLACE_TABLE} ADD COLUMN rating REAL"""
    ];
    migrations.add(migrationOne);
    migrations.add(migrationTwo);
    migrations.add(migrationThree);
    return migrations;
  }

  Future _onDbUpgrade(Database newDb, int oldVersion, int newVersion) async {
    Batch batch = newDb.batch();
    for (int i = oldVersion; i < newVersion; i++) {
      getMigrations()[i - 1].forEach((String script) {
        batch.execute(script);
      });
    }

    // if (oldVersion == 1 && newVersion == 2) {
    //   batch.execute("""
    //       CREATE TABLE ${AppConstants.PLACE_TABLE}
    //       (
    //         id TEXT PRIMARY KEY,
    //         title TEXT,
    //         address TEXT,
    //         imagePath TEXT,
    //         latitude REAL,
    //         longitude REAL
    //       )
    // """);
    // }
    // if (oldVersion == 1 && newVersion == 3) {
    //   batch.execute("""
    //       CREATE TABLE ${AppConstants.PLACE_TABLE}
    //       (
    //         id TEXT PRIMARY KEY,
    //         title TEXT,
    //         address TEXT,
    //         imagePath TEXT,
    //         latitude REAL,
    //         longitude REAL
    //       )
    // """);
    //   batch.execute(
    //       """ALTER TABLE ${AppConstants.PLACE_TABLE} ADD COLUMN synced INTEGER DEFAULT 0 """);
    // }
    // if (oldVersion == 2 && newVersion == 3) {
    //   batch.execute(
    //       """ALTER TABLE ${AppConstants.PLACE_TABLE} ADD COLUMN synced INTEGER DEFAULT 0 """);
    // }

    batch.commit();
  }

  Future<int> insertPlace(Place place) async {
    if (db == null) {
      await _init();
    }
    return db.insert(AppConstants.PLACE_TABLE, place.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<Place> fetchPlace(String id) async {
    if (db == null) {
      await _init();
    }
    final data = await db
        .query(AppConstants.PLACE_TABLE, where: 'id = ? ', whereArgs: [id]);
    if (data.length > 0) {
      return Place.fromJson(data.first);
    }
    return null;
  }

  Future<List<Place>> fetchAllPlaces() async {
    if (db == null) {
      await _init();
    }
    final data = await db.query(AppConstants.PLACE_TABLE);
    return Place.allPlaces(data);
  }

  Future<List<Place>> fetchAllUnsyncedPlaces() async {
    if (db == null) {
      await _init();
    }
    final data = await db
        .query(AppConstants.PLACE_TABLE, where: " synced = ? ", whereArgs: [0]);
    print("The data from local db $data");
    if (data.length > 0) return Place.allPlaces(data);
    return null;
  }

  Future updateData(Place place, String newId) async {
    if (db == null) {
      await _init();
    }
//  return db.rawUpdate("UPDATE  ${AppConstants.PLACE_TABLE} SET synced = 1, id = $newId where id = ${place.id}");

    var oldId = place.id;
    place.id = newId;
    place.synced = 1;
    return db.update(AppConstants.PLACE_TABLE, place.toJson(),
        where: 'id = ?', whereArgs: [oldId]);
  }
}
