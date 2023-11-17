import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:sth/models/sport.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider {
  final String sportsTable = "sport";
  DBProvider._();
  static final DBProvider db = DBProvider._();

  static Database? _database;

  factory DBProvider() {
    return db;
  }

  Future<Database> get database async {
    if (_database != null) return _database!;

    // if _database is null we instantiate it
    _database = await initDB();
    return _database!;
  }

  Future<Database> initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String dbPath = join(documentsDirectory.path, "database.db");

    final database = openDatabase(dbPath,
        version: 1, onCreate: _onCreate, onUpgrade: _onUpgrade);
    return database;
  }

  void _onCreate(Database db, int version) {
    db.execute("CREATE TABLE $sportsTable ("
        "sport_id TEXT PRIMARY KEY,"
        "sport_name TEXT,"
        "isSelected INTEGER"
        ")");
    print("Database was created!");
  }

  void _onUpgrade(Database db, int oldVersion, int newVersion) {
    // Run migration according database versions
  }
  //
  // Counting all Row in the Table //
  //
  Future<int> getCount() async {
    //database connection
    final db = await database;
    var x = await db.rawQuery('SELECT COUNT (*) from  $sportsTable');
    int? count = Sqflite.firstIntValue(x);
    return count ?? 0;
  }

  Future<int> updateSport(Sport sport) async {
    final db = await database;
    var res = await db.update(sportsTable, sport.toMap(),
        where: "sport_id = ?", whereArgs: [sport.sportId]);
    return res;
  }

  newSport(Sport sport) async {
    final db = await database;
    var res = await db.insert(sportsTable, sport.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    return res;
  }

  getSport(int sportId) async {
    final db = await database;
    var res = await db
        .query(sportsTable, where: "sport_id = ?", whereArgs: [sportId]);
    return res.isNotEmpty ? Sport.fromMap(res.first) : Null;
  }

  blockOrUnblock(Sport sport) async {
    final db = await database;
    Sport favorite = Sport(
        sportId: sport.sportId,
        name: sport.name,
        isSelected: !sport.isSelected);
    var res = await db.update(sportsTable, favorite.toMap(),
        where: "sport_id = ?", whereArgs: [sport.sportId]);
    return res;
  }

  Future<List<Sport>> getAllSports() async {
    final db = await database;
    var res = await db.query(sportsTable);
    List<Sport> list =
        res.isNotEmpty ? res.map((s) => Sport.fromMap(s)).toList() : [];
    return list;
  }

  deleteSport(int sportId) async {
    final db = await database;
    db.delete(sportsTable, where: "sport_id = ?", whereArgs: [sportId]);
  }

  deleteAll() async {
    final db = await database;
    db.rawDelete("Delete * from $sportsTable");
  }
}
