// ignore_for_file: avoid_classes_with_only_static_members

import 'package:notes/_aap_packages.dart';
import 'package:notes/_external_packages.dart';
import 'package:notes/_internal_packages.dart';

class SqfliteDatabaseHelper {
  static String tableName = 'notes';
  static String dbName = 'notes_database.db';

  static final fieldMap = {
    'id': 'text PRIMARY KEY ',
    'title': 'text',
    'content': 'text',
    'lastModify': 'INTEGER',
    'state': 'INTEGER',
  };

  static late Database _database;

  static Future<Database> get database async {
    final databasePath = await getDatabasesPath();
    final status = await databaseExists(databasePath);
    if (!status) {
      _database = await openDatabase(join(databasePath, dbName),
          onCreate: (final database, final version) => database.execute(
                query(),
              ),
          version: dbVersion,);
    }
    return _database;
  }

  static String query() {
    var query = 'CREATE TABLE ';
    query += tableName;
    query += '(';
    fieldMap.forEach((final key, final value) {
      query += '$key $value,';
    });
    query = query.substring(0, query.length - 1);
    query += ')';
    return query;
  }

  static Future<bool> insert(final Note note) async {
    final db = await database;
    try {
      await db.insert(
        tableName,
        note.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } on Exception catch (_) {
      return false;
    }
    return true;
  }

  static Future<bool> update(final Note note) async {
    final db = await database;
    try {
      await db.update(
        tableName,
        note.toMap(),
        where: 'id = ?',
        whereArgs: [note.id],
      );
    } on Exception catch (_) {
      return false;
    }
    return true;
  }

  static Future<bool> delete(
      final String whereCond, final List<Object> where,) async {
    final db = await database;
    try {
      await db.delete(
        tableName,
        where: whereCond,
        whereArgs: where,
      );
      return true;
    } on Exception catch (_) {
      return false;
    }
  }

  static Future<List<Map<String, dynamic>>> queryData({
    final String? whereStr,
    final List<Object>? whereCond,
    final int? limit,
    final int? offSet,
  }) async {
    final db = await database;
    late Future<List<Map<String, Object?>>> resultSet;
    try {
      resultSet = db.query(
        tableName,
        orderBy: 'lastModify desc',
        where: whereStr,
        whereArgs: whereCond,
        limit: limit,
        offset: offSet,
      );
    } on Exception catch (_) {
      throw DatabaseExceptions('9');
    }
    return resultSet;
  }

  static Future<bool> batchInsert(final List<Map<String, dynamic>> notesList,
      {final ConflictAlgorithm? conflictAlgorithm,}) async {
    final db = await database;
    final batch = db.batch();
    for (final element in notesList) {
      batch.insert(tableName, element, conflictAlgorithm: conflictAlgorithm);
    }
    await batch.commit(noResult: true);
    return true;
  }

  static Future<bool> batchInsert1(final List<dynamic> notesList,
      {final ConflictAlgorithm? conflictAlgorithm,}) async {
    final db = await database;
    final batch = db.batch();
    for (final element in notesList) {
      batch.insert(tableName, element as Map<String, dynamic>,
          conflictAlgorithm: conflictAlgorithm,);
    }
    await batch.commit(noResult: true);
    return true;
  }

  static Future<void> deleteDB() async {
    final databasePath = await getDatabasesPath();
    return deleteDatabase(join(databasePath, dbName),);
  }
}
