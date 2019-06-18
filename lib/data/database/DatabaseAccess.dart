import 'dart:io';

import 'package:newsletter_reader/data/database/entity/article_entity.dart';
import 'package:newsletter_reader/data/database/entity/newsletter_entity.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseAccess {
  static final _databaseName = "Database.db";
  static final _databaseVersion = 1;
  static Database _databaseInstance;

  static final String idColumnName = "id";

  Future<Database> get _database async {
    if (_databaseInstance != null) return _databaseInstance;

    _databaseInstance = await _initDatabase();
    return _databaseInstance;
  }

  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path, version: _databaseVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute(NewsletterEntity.createStatement());
    await db.execute(ArticleEntity.createStatement());
  }

  Future<int> insert(String table, Map<String, dynamic> row) async {
    Database db = await _database;
    return await db.insert(table, row);
  }

  Future<List<Map<String, dynamic>>> queryAllRows(String table) async {
    Database db = await _database;
    return await db.query(table);
  }

  Future<int> queryRowCount(String table) async {
    Database db = await _database;
    return Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM $table'));
  }

  Future<int> update(String table, Map<String, dynamic> row) async {
    Database db = await _database;
    int id = row[idColumnName];
    return await db.update(table, row, where: '$idColumnName = ?', whereArgs: [id]);
  }

  Future<int> delete(String table, int id) async {
    Database db = await _database;
    return await db.delete(table, where: '$idColumnName = ?', whereArgs: [id]);
  }
}
